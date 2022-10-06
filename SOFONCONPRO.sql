create procedure SOFONCONPRO(
	@Cue_Saldos money,
    
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)) 
	
as
	
/* 
****************************************************************************
** DESCRIPCION:  	Fondeo de cuenta de cheques concentradora     		****
***************************************************************************/
/***************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			05/Septiembre/2022							  		****
** Help:			    	  											****
** Descripcion:		Logica de fechas habiles e inhabiles              	****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			01/Septiembre/2022							  		****
** Help:			    	  											****
** Descripcion:		Validación saldo negativo en cuenta              	****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			25/Agosto/2022							  			****
** Help:			    	  											****
** Descripcion:		Ajuste consulta de cunetas CODESETE              	****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			02/Agosto/2022							  			****
** Help:			    	  											****
** Descripcion:		Se crea el proceso para el fondeo de la cuenta     	****
**                  concentradora de la	cuenta de cheques concentradora ****
****************************************************************************/	
	
-- Declaración de Variables 

declare @Par_FecApe smalldatetime,   
		@Par_FecSig smalldatetime,                                        
        @Par_BanAct int,
        @Status     int,
        @Cue_ChCaAb char(12),
        @Par_Fecha  smalldatetime,
        @Par_Recibi money,
        @Par_Enviad money,
        @Par_FecCon smalldatetime,
        @Fecha      smalldatetime,
        @Cue_Dispon money,
        @Cue_Residu money,
        @Sop_FecHoy datetime,
        @Sop_FecIni datetime,
        @Sop_FecFin datetime,
        @Sop_FecSig datetime,
        @Sop_FecAye datetime,
        @Sop_FecAnt datetime


-- Declaración de Constantes 

declare
        @Str_Vacio  char(1),
        @Str_Blanco char(2),
		@Mon_Cero   money,
		@Ent_Cero   int,    
        @Dic_Transa char(3),
        @Dic_Fecha  smalldatetime,
        @Nat_Cargo   char(1),
        @Nat_Abono   char(1),
        @Des_CarRec varchar(35),
        @Des_AboRec varchar(35),
        @Des_CarEnv varchar(35),
        @Des_AboEnv varchar(35),        
        @Cue_CarRec char(15),     
		@Cue_AboRec char(15),
        @Cue_CarEnv char(15),     
		@Cue_AboEnv char(15),        
        @Dic_Moneda char(2),
        @Dic_Poliza char(3),
        @Dic_CR     char(3),
        @Dic_UsuCon char(8),
        @Dic_TipOpe char(3),
        @Dic_TipRef char(3),
        @Dic_Refere char(40),
        @Dic_ConCta varchar(255),
        @Dic_Tipo   char(3),
        @Dic_TraCon char(3),        
        @Cot_CarRec char(3),
        @Cot_AboRec char(3),
        @Cot_CarEnv char(3),
        @Cot_AboEnv char(3),  
        @Tra_CaReBa char(3),
        @Tra_AbReHe char(3),                
        @Par_BanBan int,
        @Par_BanHey int,
        @Che_TiMoEn char(6),      
        @Che_TiMoRe char(6),
        @Ser_Numero char(4),
        @Bfd_TipFon int,
        @Bfd_DesFon varchar(35),
        @Bfd_TipTra int,
        @Bfd_DesTra varchar(35),        
        @Bfd_TipSal int,
        @Bfd_DesSal varchar(35),
        @Par_Refere char(35),
        @Con_Uno	char(6),
        @Des_CarFon char(35),
        @Des_AboFon char(35),        
        @Par_FecNat	smalldatetime,
		@Dia_Semana	char(1),
		@Dia_Habil	char(1),
		@Mes		char(2),
		@Dia		char(2),
		@Anio		char(4),    			
		@Str_No		char(1),
		@Str_Si		char(1),
		@Str_Lunes	int,
		@Str_Martes	int,
		@Str_Mierco	int,
		@Str_Jueves	int,
		@Str_Vierne	int,
		@Str_Guion  char(1),
		@Ent_Uno	int,        
        @Det_NumFon int,
        @Par_Porcen float,
        @Par_FonBas money,
        @Par_AuxFon money,
        @Ent_Neg    int



-- Asignacion de Constantes 
select	@Str_Vacio  = '',               -- String Vacio
        @Str_Blanco = ' ',              -- String Espacio en blanco
		@Mon_Cero   = $0.0,				-- Moneda en cero
		@Ent_Cero   =  0,				-- Numero cero		
        @Ent_Neg    = -1,               -- Numero negativo
        @Dic_Transa = 'ZUR',            -- Transacción
        @Dic_Fecha  = convert(varchar, getdate(), 101),         -- Fecha   
        --@Dic_Fecha    = convert(varchar, (select Par_Valor from dbo.SOPARGEN NOHOLDLOCK WHERE Par_Consec  = 86 ), 101),         
        @Des_CarRec = 'Cargo Saldo Deudor Provisión',   -- Descripción de cargo recibido
        @Des_AboRec = 'Abono Saldo Deudor Provisión',   -- Descripción de abono recibido 
        @Des_CarEnv = 'Cargo Provisión saldo ctas Hey',    -- Descripción de cargo enviado
        @Des_AboEnv = 'Abono Provisión saldo ctas Hey',    -- Descripción de abono enviado
        @Des_CarFon = 'Cargo Fondeo cuenta complemento',    -- Descripción de cargo enviado
        @Des_AboFon = 'Abono Fondeo cuenta complemento',    -- Descripción de abono enviado
        @Nat_Cargo  = '1',               -- Movimiento Cargo
        @Nat_Abono  = '2',               -- Movimient Abono                
        @Dic_Moneda = '01',             -- Moneda
        @Dic_Poliza = '',               -- Poliza
        @Dic_CR     = @Str_Vacio,       -- CR que afecta el movimiento
        @Dic_UsuCon = @Str_Vacio,       -- Clave de Usuario
        @Dic_TipOpe = @Str_Vacio,       -- Tipo de Operación contable 
        @Dic_TipRef = @Str_Vacio,       -- Tipo de referencia
        @Dic_Refere = @Str_Vacio,       -- Referencia
        @Dic_ConCta = @Str_Vacio,       -- Contra-cuenta
        @Dic_Tipo   = @Str_Vacio,       -- Tipo de cuenta
        @Dic_TraCon = @Str_Vacio,       -- Transacción Contable              
        @Tra_CaReBa = 'PXU',            -- cuenta concentradora CHMOVIMI        
        @Tra_AbReHe = 'PXU',            -- CUENTA COMPLEMENTO 1505.        
        @Che_TiMoEn = '000097',         -- Cargo por Deposito programado
        @Che_TiMoRe = '000098',         -- Recepcion Deposito programado
        @Ser_Numero = '0069',           -- Id de la institucion de la cuenta de cheques       
        @Bfd_TipFon = 1,
        @Bfd_DesFon = 'Fondeo',
        @Bfd_TipTra = 2,
        @Bfd_DesTra = 'Traslado de Recursos Recepciones',        
        @Bfd_TipSal = 3,
        @Bfd_DesSal = 'Saldar Provisión',
        @Par_Refere = 'FONDEO CTAS SPEI',
        @Con_Uno    = '000001',
        @Str_No     = 'N',				/* String No */
		@Str_Si     = 'S',				/* String Si */	
		@Str_Lunes  = 2,				/* Día de la semana Lunes */
		@Str_Martes = 3,				/* Día de la semana Martes */
		@Str_Mierco = 4,				/* Día de la semana Miercoles */
		@Str_Jueves = 5,				/* Día de la semana Jueves */
		@Str_Vierne = 6,				/* Día de la semana Viernes */										
		@Ent_Uno    = 1,				/* Entero en Uno */
		@Str_Guion  = '-',                /*Guion*/     
        @Det_NumFon = 27,   
        @Par_Porcen = 0.1,
        @Par_BanBan = 2,                -- Clave 2 Banco Activo H
        @Par_FonBas = 160000000

    -- Logica de fechas

    --Saca la fecha de Hoy
        select @Sop_FecHoy = convert (datetime, convert (char(10), getdate(), 101))        

        --La fecha Final debe ser igual a Sop_FecHoy
        select @Sop_FecFin = dateadd (ss, -1, @Sop_FecHoy)
             , @Sop_FecIni = dateadd (dd, -1, @Sop_FecHoy)
             , @Sop_FecAnt  = @Sop_FecHoy

        --Si Sop_FecHoy es habil, reviso que tengo que obtener
        select @Sop_FecSig = @Sop_FecHoy

        exec SOSIGFECHAB @Sop_FecSig out, @Ent_Cero, 'N', 'N'

        if (@Sop_FecHoy <> @Sop_FecSig) begin --Hoy es inhabil
            --si es el primer inhabil debe procesar
            select @Sop_FecAnt = dateadd (dd, -1, @Sop_FecHoy)
            select @Sop_FecAye = @Sop_FecHoy
            exec SOANTFECHAB @Sop_FecAye out, @Ent_Cero, 'N', 'N'
            
            if (@Sop_FecAnt <> @Sop_FecAye) begin  --Hoy NO es el primer inhabil    
                return @Ent_Cero--no hago nada
            end
        end

        --Si Sop_FecHoy es el primer dia habil, no hago nada
        select  @Sop_FecAye = dateadd (dd, -1, @Sop_FecHoy)
        exec SOSIGFECHAB @Sop_FecAye out, @Ent_Cero, 'N', 'N'

        if (@Sop_FecAye = @Sop_FecHoy) begin --Hoy es inhabil  
            return @Ent_Cero--no hago nada
        end

    select  @Par_Fecha  = @Sop_FecIni,
            @Fecha      = @Sop_FecSig

    select @Cue_ChCaAb = SeR_Cuenta 
        from    PEINSTIT    noholdlock 
        WHERE   SeR_Numero  = @Ser_Numero   
    
    -- Obtener montos    
    select top 1 @Par_Recibi = Bcc_Monto
        from    COBIFOND NOHOLDLOCK 
        WHERE   Bcc_Tipo    = @Bfd_TipFon 
        order by    Bcc_Numero  desc
    
    select @Par_Enviad = (@Cue_Saldos * @Par_Porcen)-- Monto Provisión al inicio de dia por el total del saldo de las ctas Hey para FONDEAR

    -- Obtener cuentas

    select  @Cot_CarRec = @Tra_AbReHe,
            @Cot_AboRec = @Tra_CaReBa,
            @Cot_CarEnv = @Tra_CaReBa,
            @Cot_AboEnv = @Tra_AbReHe                

    -- Obtener cuentas

    select @Cue_CarRec = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock on Sst_Numero = Det_Numero
        where   Cod.Det_Numero  = @Det_NumFon
            and Cod.Det_Origen  = @Par_BanBan
            and Cod.Det_Natura  = @Nat_Cargo


    select @Cue_AboRec = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock on Sst_Numero = Det_Numero
        where   Cod.Det_Numero  = @Det_NumFon
            and Cod.Det_Origen  = @Par_BanBan
            and Cod.Det_Natura  = @Nat_Abono

    -- Registro Fondeo

    -- FONDEO    

            -- Cargo 

            -- insert into SYDIACTA
            -- select	@NumTransac,	@Con_Uno,   	@Dic_Transa,	@Fecha,         @Par_Enviad,
            --         @Nat_Cargo,	    @Des_CarFon,    @Cue_CarRec,	@Str_Vacio,     @Dic_Moneda,
            --         @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
            --         @Dic_Refere,	@Str_Blanco,	@Dic_Tipo,	    @Cot_CarRec,	@NumTransac,
            --         @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
            --         @Modulo

            execute @Status = SYDIACTAALT
                @NumTransac,	@Transaccio,	@Par_Enviad,    @Nat_Cargo,		@Des_CarFon,
                @Nat_Cargo,		@Cue_CarRec,	@Dic_Moneda,	@Fecha,         @Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Cot_CarRec,	@NumTransac,	@Transaccio,
                @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            -- Abono

            -- insert into SYDIACTA
            -- select	@NumTransac, 	@Con_Uno,   	@Dic_Transa,	@Fecha,         @Par_Enviad,
            --         @Nat_Abono,     @Des_AboFon,    @Cue_AboRec,	@Str_Vacio,     @Dic_Moneda,
            --         @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
            --         @Dic_Refere,	@Str_Blanco,    @Dic_Tipo,      @Cot_AboRec,	@NumTransac,
            --         @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
            --         @Modulo  

            execute @Status = SYDIACTAALT
                @NumTransac,	@Transaccio,	@Par_Enviad,    @Nat_Abono,		@Des_AboFon,
                @Nat_Abono,		@Cue_AboRec,	@Dic_Moneda,	@Fecha,         @Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Cot_AboRec,	@NumTransac,	@Transaccio,
                @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            -- abono cuenta de cheques concentradora
        
            execute @Status = CHMOVIMIALT                   
                @Cue_ChCaAb,	@NumTransac,	@Nat_Abono,		@Fecha, 	    @Fecha,
                @Des_AboEnv,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Enviad,
                @Che_TiMoRe,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
                @SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            --insert into COBIFOND
            insert into COBIFOND
                (Bcc_Fecha, Bcc_Tipo,   Bcc_DesTip, Bcc_Monto,  Bfd_FecHor,
                NumTransac, Transaccio, Usuario,    FechaSis,   SucOrigen,
                SucDestino)
            values
                (@Fecha,        @Bfd_TipFon,    @Bfd_DesFon,    @Par_Enviad,    getdate(),
                @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,    
                @SucDestino)

        -- Saldo deudor por la provición 

            -- Cargo

            -- insert into SYDIACTA
            -- select	@NumTransac,	@Con_Uno,   	@Dic_Transa,	@Par_Fecha,     @Par_Recibi,
            --         @Nat_Cargo,	    @Des_CarRec,    @Cue_AboRec,	@Str_Vacio,     @Dic_Moneda,
            --         @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,    @Dic_TipRef,
            --         @Dic_Refere,	@Str_Blanco,	@Dic_Tipo,	    @Cot_CarRec,	@NumTransac,
            --         @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
            --         @Modulo

            execute @Status = SYDIACTAALT
                @NumTransac,	@Transaccio,	@Par_Recibi,    @Nat_Cargo,		@Des_CarRec,
                @Nat_Cargo,		@Cue_AboRec,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Cot_CarRec,	@NumTransac,	@Transaccio,
                @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            -- Abono

            -- insert into SYDIACTA
            -- select   @NumTransac, 	@Con_Uno,   	@Dic_Transa,	@Par_Fecha,     @Par_Recibi,
            --         @Nat_Abono,     @Des_AboRec,    @Cue_CarRec,	@Str_Vacio,     @Dic_Moneda,
            --         @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
            --         @Dic_Refere,	@Str_Blanco,	@Dic_Tipo,	    @Cot_AboRec,	@NumTransac,
            --         @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,     @SucDestino,
            --         @Modulo 

            execute @Status = SYDIACTAALT
                @NumTransac,	@Transaccio,	@Par_Recibi,    @Nat_Abono,		@Des_AboRec,
                @Nat_Abono,		@Cue_CarRec,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                @Str_Vacio,		@Str_Vacio,		@Cot_AboRec,	@NumTransac,	@Transaccio,
                @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            -- cargo cuenta de cheuqes concentradora
            execute @Status = CHMOVIMIALT
                @Cue_ChCaAb,	@NumTransac,	@Nat_Cargo,		@Par_Fecha,	    @Par_Fecha,
                @Des_CarRec,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Recibi,
                @Che_TiMoEn,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
                @SucOrigen,		@SucDestino,	@Modulo

            if @Status <> @Ent_Cero begin
                rollback
                return @Ent_Uno
            end

            insert into COBIFOND
                (Bcc_Fecha, Bcc_Tipo,   Bcc_DesTip, Bcc_Monto,  Bfd_FecHor,
                NumTransac, Transaccio, Usuario,    FechaSis,   SucOrigen,
                SucDestino)
            values
                (@Par_Fecha,    @Bfd_TipSal,    @Bfd_DesSal,    @Par_Recibi,    getdate(),
                @NumTransac,    @Transaccio,	@Usuario,	    @FechaSis,      @SucOrigen,    
                @SucDestino)

            -- validar saldo disponible de la cuenta >= @Par_FonBas

            select @Cue_Dispon = Cue_Dispon 
                from CHCUENTA NOHOLDLOCK 
                WHERE   Cue_Numero  = @Cue_ChCaAb


            if @Cue_Dispon < @Par_FonBas begin
                                
                select @Cue_Residu = @Cue_Dispon - @Par_FonBas  -- Residuo (Disponible - Base)
                select @Par_AuxFon = @Cue_Residu * @Ent_Neg     -- Se asigna el operador correcto (-/+)
                
                -- Cargo                
                execute @Status = SYDIACTAALT
                    @NumTransac,	@Transaccio,	@Par_AuxFon,    @Nat_Cargo,		@Des_CarFon,
                    @Nat_Cargo,		@Cue_CarRec,	@Dic_Moneda,	@Fecha,         @Str_Vacio,
                    @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                    @Str_Vacio,		@Str_Vacio,		@Cot_CarRec,	@NumTransac,	@Transaccio,
                    @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

                if @Status <> @Ent_Cero begin
                    rollback
                    return @Ent_Uno
                end

                 -- Abono
                execute @Status = SYDIACTAALT
                    @NumTransac,	@Transaccio,	@Par_AuxFon,    @Nat_Abono,		@Des_AboFon,
                    @Nat_Abono,		@Cue_AboRec,	@Dic_Moneda,	@Fecha,         @Str_Vacio,
                    @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
                    @Str_Vacio,		@Str_Vacio,		@Cot_AboRec,	@NumTransac,	@Transaccio,
                    @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

                if @Status <> @Ent_Cero begin
                    rollback
                    return @Ent_Uno
                end

                -- abono cuenta de cheques concentradora
        
                execute @Status = CHMOVIMIALT
                    @Cue_ChCaAb,    @NumTransac,    @Nat_Abono,     @Par_Fecha,     @Par_Fecha,
                    @Des_AboEnv,	@Par_Refere, 	@Transaccio,	@Mon_Cero,		@Par_AuxFon,
                    @Che_TiMoRe,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
                    @SucOrigen,		@SucDestino,	@Modulo

                if @Status <> @Ent_Cero begin                    
                    rollback
                    return @Ent_Uno
                end

                insert into COBIFOND
                    (Bcc_Fecha, Bcc_Tipo,   Bcc_DesTip, Bcc_Monto,  Bfd_FecHor,
                    NumTransac, Transaccio, Usuario,    FechaSis,   SucOrigen,
                    SucDestino)
                values
                    (@Fecha,        @Bfd_TipFon,    @Bfd_DesFon,    @Par_AuxFon,    getdate(),
                    @NumTransac,    @Transaccio,	@Usuario,	    @FechaSis,      @SucOrigen,    
                    @SucDestino)
            end
