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
** Fecha:			01/Septiembre/2022							  		****
** Help:			    	  											****
** Descripcion:		Ajuste a cargos y abonos Recibidos y Enviados       ****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			25/Agosto/2022							  			****
** Help:			    	  											****
** Descripcion:		Ajuste consulta de cunetas CODESETE              	****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			15/Agosto/2022							  			****
** Help:			    	  											****
** Descripcion:		Se agrega insert a la bitacora COBIFOND          	****
****************************************************************************
** Modifico:		Edgar Cabriales             						****
** Fecha:			06/Abril/2022							  			****
** Help:			    	  											****
** Descripcion:		Se crea el proceso para el neteo de pagos          	****
**                  spei a cuentas hey									****
****************************************************************************/	
	
-- Declaración de Variables 
declare @Par_BanAct int,
        @Status 	int,
        @Cue_ChCaAb char(12),
        @Fecha      smalldatetime

-- Declaración de Constantes 
declare @Str_Vacio  char(1),
        @Str_Blanco  char(2),		
        @Dic_Transa char(3),
        @Dic_Fecha  smalldatetime,
        @Nat_Cargo  char(1),
        @Nat_Abono  char(1),        
        @Des_CarRec varchar(35),
        @Des_AboRec varchar(35),
        @Des_CarEnv varchar(35),
        @Des_AboEnv varchar(35),        
        @Cue_CarRec char(15),     
		@Cue_AboRec char(15),
        @Cue_CarEnv char(15),     
		@Cue_AboEnv char(15),        
        @Dic_Moneda char(2),
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
        @Par_BanBan int,
        @Par_BanHey int,
        @Che_TiMoEn char(6),      
        @Che_TiMoRe char(6),
        @Ser_Numero char(4),
        @Bfd_DeCoRe char(35),
        @Bfd_DeCoEn char(35),
        @Bfd_TiCoRe int,
        @Bfd_TiCoEn int,        
        @Det_NumRec int,
        @Det_NumEnv int,
        @Fec_Vacia  smalldatetime,
        @Ent_Uno    int,     
        @Mon_Cero	money,
		@Ent_Cero	int   

-- Asignacion de Constantes 
select	@Str_Vacio  = '',               -- String Vacio
        @Str_Blanco = ' ',              -- String Espacio en blanco
		@Mon_Cero   = $0.0,				-- Moneda en cero
		@Ent_Cero   =  0,				-- Numero cero
        @Dic_Transa = 'PXU',            -- Transacción        
        @Dic_Fecha  = convert(varchar, getdate(), 101),         -- Fecha        
        @Des_CarRec = 'Cargo de Neteo pagos Recibidos SPEI',   -- Descripción de cargo recibido
        @Des_AboRec = 'Abono de Neteo pagos Recibidos SPEI',   -- Descripción de abono recibido 
        @Des_CarEnv = 'Cargo de Neteo pagos Enviados SPEI',    -- Descripción de cargo enviado
        @Des_AboEnv = 'Abono de Neteo pagos Enviados SPEI',    -- Descripción de abono enviado
        @Nat_Cargo  = '1',               -- Movimiento Cargo
        @Nat_Abono  = '2',               -- MovimientAbono                
        @Dic_Moneda = '01',             -- Moneda
        @Tra_CaReBa = 'PXU',            -- cuenta concentradora CHMOVIMI
        @Tra_AbReBa = 'PXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_CaEnBa = 'PXU',            -- Cuenta Complemento simula entrada y salida de banco
        @Tra_AbEnBa = 'PXU',            -- cuenta concentradora CHMOVIMI 
        @Tra_CaReHe = 'PXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_AbReHe = 'PXU',            -- CUENTA COMPLEMENTO 1505.
        @Tra_CaEnHe = 'PXU',            -- CUENTA COMPLEMENTO 2311.
        @Tra_AbEnHe = 'PXU',            -- Cuenta Complemento simula entrada y salida de banco        
        @Par_BanBan = 2,                -- Clave Banco Activo Banregio
        @Par_BanHey = 1,                -- Clave Banco Activo Hey
        @Che_TiMoEn = '000097',         -- Cargo por Deposito programado
        @Che_TiMoRe = '000098',         -- Recepcion Deposito programado
        @Ser_Numero = '0069',           -- Id de la institucion de la cuenta de cheques         
        @Bfd_DeCoRe = 'Compensacion por recursos recibidos',
        @Bfd_DeCoEn = 'Compensacion por recursos enviados',
        @Bfd_TiCoRe = 2,  
        @Bfd_TiCoEn = 4,
        @Det_NumRec = 29,
        @Det_NumEnv = 30,
        @Fec_Vacia  = '1990-01-01',
        @Ent_Uno    = 1
    
--validar si la fecha no viene vacía
if(@Par_Fecha = @Fec_Vacia)
begin
    select  Err_Codigo  = '000001',
            Err_Mensaj  = 'Error en la fecha, no puede registrarse una fecha invalida'
    return 1
end

select  @Fecha  =   @Par_Fecha

-- Banco Actual 
exec SOBANACTCON
    @Par_BanAct output, @NumTransac,    @Transaccio,    @Usuario,   @FechaSis,
    @SucOrigen,         @SucDestino,    @Modulo

-- validar Par_BanAct is null = 0
select  @Par_BanAct =   isnull(@Par_BanAct,@Ent_Cero)

-- Separación Tecnologica Activa 1-2/Inactiva 0
if @Par_BanAct > @Ent_Cero  begin    
    -- Asignación de cuentas CARGOS Y ABONOS
    if @Par_BanAct = @Par_BanBan    begin
        select  @Cot_CarRec = @Tra_CaReBa,
                @Cot_AboRec = @Tra_AbReBa,
                @Cot_CarEnv = @Tra_CaEnBa,
                @Cot_AboEnv = @Tra_AbEnBa
    end

    if @Par_BanAct = @Par_BanHey    begin
        select  @Cot_CarRec = @Tra_CaReHe,
                @Cot_AboRec = @Tra_AbReHe,
                @Cot_CarEnv = @Tra_CaEnHe,
                @Cot_AboEnv = @Tra_AbEnHe            
    end

    -- cuentas CODESETE Recibidos    
    select @Cue_CarRec = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock  on Sst_Numero = Det_Numero
        where   Cod.Det_Numero  = @Det_NumRec 
        and   Cod.Det_Origen  = @Par_BanAct
        and   Cod.Det_Natura  = @Nat_Cargo
    
    select @Cue_AboRec = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock on Sst_Numero = Det_Numero
        where   Cod.Det_Numero  = @Det_NumRec
            and Cod.Det_Origen  = @Par_BanAct 
            and Cod.Det_Natura  = @Nat_Abono

    -- cuentas CODESETE Enviados
    select @Cue_CarEnv = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock on Sst_Numero = Det_Numero
        where   Cod.Det_Numero  = @Det_NumEnv 
            and Cod.Det_Origen  = @Par_BanAct 
            and Cod.Det_Natura  = @Nat_Cargo


    select @Cue_AboEnv = Cod.Det_Cuenta
        from CODESETE Cod noholdlock
        inner join COSESETE Cos noholdlock on Sst_Numero = Det_Numero
        where   Cod.Det_Numero = @Det_NumEnv 
            and Cod.Det_Origen = @Par_BanAct 
            and Cod.Det_Natura = @Nat_Abono


    select  @Cue_CarRec = isnull(@Cue_CarRec, @Str_Vacio),
            @Cue_AboRec = isnull(@Cue_AboRec, @Str_Vacio),
            @Cue_CarEnv = isnull(@Cue_CarEnv, @Str_Vacio),
            @Cue_AboEnv = isnull(@Cue_AboEnv, @Str_Vacio)

    if(@Cue_CarRec  = @Str_Vacio or @Cue_AboRec = @Str_Vacio or @Cue_CarEnv = @Str_Vacio or @Cue_AboEnv = @Str_Vacio)
    begin
        select  Err_Codigo  = '000002',
                Err_Mensaj  = 'Error en la cuentas puente, no existe alguna de las cuentas'
        return @Ent_Uno
    end

    --  Registro asiento Contable                          
    if  @Par_BanAct = @Par_BanBan
    begin

        select  @Cue_ChCaAb = SeR_Cuenta 
        from PEINSTIT noholdlock 
        WHERE   SeR_Numero  = @Ser_Numero 
                    
        -- Moviemiento Contable Abono Enviados            
        execute @Status = CHMOVIMIALT
                @Cue_ChCaAb,	@NumTransac,	@Nat_Abono,		@Par_Fecha,	    @Par_Fecha,
                @Des_AboEnv,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Enviad,
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
            (@Par_Fecha,    @Bfd_TiCoEn,    @Bfd_DeCoEn,    @Par_Enviad,    getdate(),
            @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,    
            @SucDestino) 


        -- Moviemiento Contable Cargo Recibidos

        execute @Status = CHMOVIMIALT
            @Cue_ChCaAb,	@NumTransac,	@Nat_Cargo,		@Par_Fecha,	    @Par_Fecha,
            @Des_CarRec,	@Par_Refere,	@Transaccio,	@Mon_Cero,		@Par_Recibi,
            @Che_TiMoEn,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
            @SucOrigen,		@SucDestino,	@Modulo

        if @Status <> @Ent_Cero begin
            rollback
            return 1
        end

        insert into COBIFOND
                (Bcc_Fecha, Bcc_Tipo,   Bcc_DesTip, Bcc_Monto,  Bfd_FecHor,
                NumTransac, Transaccio, Usuario,    FechaSis,   SucOrigen,
                SucDestino)
            values
                (@Par_Fecha,    @Bfd_TiCoRe,    @Bfd_DeCoRe,    @Par_Recibi,    getdate(),
                @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,    
                @SucDestino)

    end
    
    -- COMPENSACION SPEI RECIBIDO FIN DE DÍA

    -- Cargo            
    execute @Status = SYDIACTAALT
            @NumTransac,	@Transaccio,	@Par_Recibi,    @Nat_Cargo,		@Des_CarRec,
            @Nat_Cargo,		@Cue_CarRec,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Cot_CarRec,	@NumTransac,	@Transaccio,
            @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
    if @Status <> @Ent_Cero begin
        rollback
        return @Ent_Uno
    end

    -- Abono
    execute @Status = SYDIACTAALT
            @NumTransac,	@Transaccio,	@Par_Recibi,    @Nat_Abono,		@Des_AboRec,
            @Nat_Abono,		@Cue_AboRec,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Cot_AboRec,	@NumTransac,	@Transaccio,
            @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
    if @Status <> @Ent_Cero begin
        rollback
        return @Ent_Uno
    end

    -- COMPENSACION SPEI ENVIADO FIN DE DÍA

    -- Cargo
    execute @Status = SYDIACTAALT
            @NumTransac,	@Transaccio,	@Par_Enviad,    @Nat_Cargo,		@Des_CarEnv,
            @Nat_Cargo,		@Cue_CarEnv,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Cot_CarEnv,	@NumTransac,	@Transaccio,
            @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
    if @Status <> @Ent_Cero begin
        rollback
        return @Ent_Uno
    end

    -- Abono 
    execute @Status = SYDIACTAALT
            @NumTransac,	@Transaccio,	@Par_Enviad,    @Nat_Abono,		@Des_AboEnv,
            @Nat_Abono,		@Cue_AboEnv,	@Dic_Moneda,	@Par_Fecha,     @Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
            @Str_Vacio,		@Str_Vacio,		@Cot_AboEnv,	@NumTransac,	@Transaccio,
            @Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
    if @Status <> @Ent_Cero begin
        rollback
        return @Ent_Uno
    end

end