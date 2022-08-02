create procedure SOPASPEIPRO (
	@Par_Fecha	smalldatetime,
	@Par_Recibi money,
    @Par_Enviad money,
    @Par_Refere char(35),
    
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
** DESCRIPCION:  	Neteo cuentas spei para abonos hey           		****
***************************************************************************/
/***************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			06/Abril/2022							  			****
** Help:			    	  											****
** Descripcion:		Se crea el proceso para el neteo de pagos          	****
**                  spei a cuentas hey									****
****************************************************************************/	
	
-- Declaración de Variables 

declare @Par_FecApe	smalldatetime,   
		@Par_FecSig	smalldatetime,                                        
        @Par_BanAct int,
        @Status 	int,
        @Cue_ChCaAb char(12)  

-- Declaración de Constantes 

declare
        @Str_Vacio  char(1),
        @Str_Blanco  char(2),
		@Mon_Cero	money,
		@Ent_Cero	int,
        @Orp_Tipo	char(1),
		@Tip_OrdEnv char(1),
		@Tip_OrdRec char(1),
		@Tip_OrdAmb char(1),
		@Sta_Liquid char(1),
		@Sta_Aplica char(1),
		@Tip_Devolu char(2),
		@Tip_DevExt char(2),
        @Orp_Cuenta char(12),
        @Dic_Transa char(3),
        @Dic_Fecha  smalldatetime,
        @Dic_Cargo  char(1),
        @Dic_Abono  char(1),
        @Dic_Cantid money,                
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
        --
        @Cot_CarRec char(3),
        @Cot_AboRec char(3),
        @Cot_CarEnv char(3),
        @Cot_AboEnv char(3),  

        @Tra_CaReBa char(3),
        @Tra_AbReBa char(3),
        @Tra_CaEnBa char(3),
        @Tra_AbEnBa char(3),      

        @Tra_CaReHe char(3),
        @Tra_AbReHe char(3),
        @Tra_CaEnHe char(3),
        @Tra_AbEnHe char(3),      
        --
        @Par_BanBan int,
        @Par_BanHey int,
        @Che_TiMoEn char(6),      
        @Che_TiMoRe char(6),
        @Ser_Numero char(4)



-- Asignacion de Constantes 
select	@Str_Vacio  = '',               -- String Vacio
        @Str_Blanco = ' ',              -- String Espacio en blanco
		@Mon_Cero	= $0.0,				-- Moneda en cero
		@Ent_Cero	=  0,				-- Numero cero
		@Tip_OrdEnv = 'E',				-- Tipo de orden de pago Envio
		@Tip_OrdRec = 'R',				-- Tipo de orden de pago Recepcion
		@Tip_OrdAmb = 'A',				-- Tipo de orden de pago ambas(Envio y Recepcion)
        @Orp_Tipo	= @Tip_OrdAmb,      -- Enviados y Recibidos
		@Sta_Liquid = 'O',				-- Estatus liquidada
		@Sta_Aplica = 'P',				-- Estatus aplicada
		@Tip_Devolu = '00',				-- Tipo de orden Devolucion
		@Tip_DevExt = '16',				-- Tipo de orden Devolucion extemporanea
        @Dic_Transa = 'XXT',            -- Transacción
        @Dic_Fecha = convert(varchar, getdate(), 101),         -- Fecha        
        @Des_CarRec = 'Cargo de Neteo pagos Recibidos SPEI',   -- Descripción de cargo recibido
        @Des_AboRec = 'Abono de Neteo pagos Recibidos SPEI',   -- Descripción de abono recibido 
        @Des_CarEnv = 'Cargo de Neteo pagos Enviados SPEI',    -- Descripción de cargo enviado
        @Des_AboEnv = 'Abono de Neteo pagos Enviados SPEI',    -- Descripción de abono enviado
        @Dic_Cargo = '1',               -- Movimiento Cargo
        @Dic_Abono = '2',               -- MovimientAbono                
        @Dic_Moneda = '01',             -- Moneda
        @Dic_Poliza = '000',            -- Poliza
        @Dic_CR     = @Str_Vacio,       -- CR que afecta el movimiento
        @Dic_UsuCon = @Str_Vacio,       -- Clave de Usuario
        @Dic_TipOpe = @Str_Vacio,       -- Tipo de Operación contable 
        @Dic_TipRef = @Str_Vacio,       -- Tipo de referencia
        @Dic_Refere = @Str_Vacio,       -- Referencia
        @Dic_ConCta = @Str_Vacio,       -- Contra-cuenta
        @Dic_Tipo   = @Str_Vacio,       -- Tipo de cuenta
        @Dic_TraCon = @Str_Vacio,       -- Transacción Contable      
        --
        @Tra_CaReBa = 'PXU',            -- cuenta concentradora CHMOVIMI
        @Tra_AbReBa = 'RXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_CaEnBa = 'TRU',            -- Cuenta Complemento simula entrada y salida de banco
        @Tra_AbEnBa = 'PXU',            -- cuenta concentradora CHMOVIMI 

        @Tra_CaReHe = 'RXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_AbReHe = 'TXU',            -- CUENTA COMPLEMENTO 1505.
        @Tra_CaEnHe = 'RXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_AbEnHe = 'TRU',            -- Cuenta Complemento simula entrada y salida de banco
        --
        @Par_BanBan = 2,                -- Clave 2 Banco Activo Hey
        @Par_BanHey = 1,                -- Clave 1 Banco Activo Banregio
        @Che_TiMoEn = '000097',         -- Cargo por Deposito programado
        @Che_TiMoRe = '000098',         -- Recepcion Deposito programado
        @Ser_Numero = '0069'            -- Id de la institucion de la cuenta de cheques         

-- Asignación de Variables 

    -- Banco Actual 

    exec SOBANACTCON @Par_BanAct output, @NumTransac, @Transaccio, @Usuario, @FechaSis,
    @SucOrigen, @SucDestino, @Modulo

    -- Separación Tecnologica Activa 1-2/Inactiva 0
    if @Par_BanAct > @Ent_Cero
    begin
    
    -- Asignación de cuentas CARGOS Y ABONOS
    
        if @Par_BanAct = @Par_BanBan begin
            select @Cot_CarRec = @Tra_CaReBa ,@Cot_AboRec = @Tra_AbReBa, @Cot_CarEnv = @Tra_CaEnBa, @Cot_AboEnv = @Tra_AbEnBa
        end

        if @Par_BanAct = @Par_BanHey begin
            select @Cot_CarRec = @Tra_CaReHe ,@Cot_AboRec = @Tra_AbReHe, @Cot_CarEnv = @Tra_CaEnHe, @Cot_AboEnv = @Tra_AbEnHe            
        end

        -- Cuentas Cargo Recibidos
        select @Cue_CarRec = Tra_Cuenta from COTRANSA NOHOLDLOCK WHERE  Tra_Codigo = @Cot_CarRec

        -- Cuentas Abono Recibidos
        select @Cue_AboRec = Tra_Cuenta from COTRANSA NOHOLDLOCK WHERE  Tra_Codigo = @Cot_AboRec

        -- Cuentas Cargo Recibidos Enviados
        select @Cue_CarEnv = Tra_Cuenta from COTRANSA NOHOLDLOCK WHERE  Tra_Codigo = @Cot_CarEnv

        -- Cuentas Abono Recibidos Enviados
        select @Cue_AboEnv = Tra_Cuenta from COTRANSA NOHOLDLOCK WHERE  Tra_Codigo = @Cot_AboEnv

    --  Registro asiento Contable   
                        
        if  @Par_BanAct = @Par_BanBan
        begin

            select @Cue_ChCaAb = SeR_Cuenta from PEINSTIT noholdlock WHERE SeR_Numero = @Ser_Numero 
                       
            -- Moviemiento Contable Cargo
            
            execute @Status = CHMOVIMIALT
			@Cue_ChCaAb,	@NumTransac,	@Dic_Cargo,		@Par_Fecha,	    @Par_Fecha,
			@Des_CarRec,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Enviad,
			@Che_TiMoEn,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
			@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> 0 begin
                rollback
                return 1
            end

            -- Moviemiento Contable Abono
            
            execute @Status = CHMOVIMIALT
			@Cue_ChCaAb,	@NumTransac,	@Dic_Abono,		@Par_Fecha,	    @Par_Fecha,
			@Des_AboRec,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Recibi,
			@Che_TiMoRe,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
			@SucOrigen,		@SucDestino,	@Modulo

            if @Status <> 0 begin
                rollback
                return 1
            end
        end
        
        -- COMPENSACION SPEI RECIBIDO FIN DE DÍA

            -- Cargo

            insert into SYHISCTA
            select	@NumTransac,	@Transaccio,	@Dic_Transa,	@Dic_Fecha,     @Par_Recibi,
                    @Dic_Cargo,	    @Des_CarRec,    @Cue_CarRec,	@Str_Vacio,     @Dic_Moneda,
                    @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,    @Dic_TipRef,
                    @Dic_Refere,	@Str_Blanco,	@Dic_Tipo,	    @Dic_TraCon,	@NumTransac,
                    @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
                    @Modulo

            -- Abono

            insert into SYHISCTA
            select	@NumTransac,	@Transaccio,	@Dic_Transa,	@Dic_Fecha,     @Par_Recibi,
                    @Dic_Abono,	    @Des_AboRec,    @Cue_AboRec,	@Str_Vacio,     @Dic_Moneda,
                    @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
                    @Dic_Refere,	@Str_Blanco,	@Dic_Tipo,	    @Dic_TraCon,	@NumTransac,
                    @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,     @SucDestino,
                    @Modulo 

        -- COMPENSACION SPEI ENVIADO FIN DE DÍA

            -- Cargo

            insert into SYHISCTA
            select	@NumTransac,	@Transaccio,	@Dic_Transa,	@Dic_Fecha,     @Par_Enviad,
                    @Dic_Cargo,	    @Des_CarEnv,    @Cue_CarEnv,	@Str_Vacio,     @Dic_Moneda,
                    @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
                    @Dic_Refere,	' ',	        @Dic_Tipo,	    @Dic_TraCon,	@NumTransac,
                    @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
                    @Modulo

            -- Abono

            insert into SYHISCTA
            select	@NumTransac,	@Transaccio,	@Dic_Transa,	@Dic_Fecha,     @Par_Enviad,
                    @Dic_Abono,	    @Des_AboEnv,    @Cue_AboEnv,	@Str_Vacio,     @Dic_Moneda,
                    @Dic_Poliza,	@Dic_CR,        @Dic_UsuCon,    @Dic_TipOpe,	@Dic_TipRef,
                    @Dic_Refere,	' ',	        @Dic_Tipo,      @Dic_TraCon,	@NumTransac,
                    @Transaccio,	@Usuario,	    @FechaSis,	    @SucOrigen,	    @SucDestino,
                    @Modulo 

    end