create procedure SOSINPROPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Sincronizacion de la información de configuracion    ****
**                 producto.                                            ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		Alan Santamaria                           			****
** Fecha:		    06/10/2021									        ****
** Help:			 1574028         								    ****
** Descripción:	    Procedimiento padre de Sincronizacion.              ****
****************************************************************************
** Elaboró: 		Marco Eduardo Bustos de la Rsoa            			****
** Fecha:		    03/03/2025									        ****
** Help:			TCELNC-21562       								    ****
** Descripción:	    Cambio en el rollback                               ****

****************************************************************************/

											/* Declaración de variables  */
declare	@Status     int,
        @Act_Fecha  smalldatetime
                                            /* Declaracion de Constantes */
declare @Ent_Uno	int,
        @Ent_Dos	int,        
        @Ent_Tres	int,
        @Ent_Cuatro	int,       				
        @Ent_Cinco	int,
        @Ent_Seis	int,
        @Ent_Siete	int,                                
        @Str_Produc char(11),                /* Producto */
        @Str_PrTiCu char(11),               /* Producto Tipo Cuenta */
        @Str_PrPrFi char(11),                /* Producto Personalidad Fiscal */
        @Str_PrClPr char(11),                /* Producto clasificacion Producto */
        @Str_PrCrCc char(11),                /* Producto Credito Consumo */
        @Str_PrCrCo char(11),                /* Producto Credito Comercial */
        @Str_PrTarj char(11),                /* Producto Tarjeta */
        @Bit_Exito  bit,                    
        @Bit_Error  bit 

								            /* Asignacion de Constantes */
select  @Ent_Uno    =  1,
        @Ent_Dos	=  2,
        @Ent_Tres	=  3,
        @Ent_Cuatro	=  4,
        @Ent_Cinco	=  5,
        @Ent_Seis	=  6,
        @Ent_Siete	=  7,
        @Str_Produc =  'SOTMPPROPRO',
        @Str_PrTiCu =  'SOTMPPTCPRO',
        @Str_PrPrFi =  'SOTMPPPFPRO',
        @Str_PrClPr =  'SOTMPCLPPRO',
        @Str_PrCrCc =  'SOTMPPCCPRO',
        @Str_PrCrCo =  'SOTMPPCOPRO',
        @Str_PrTarj =  'SOTMPPTAPRO',
        @Bit_Exito  =   0,
        @Bit_Error  =   1


select @Act_Fecha = getdate()

/***** producto ******/
exec @Status = SOTMPPROPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Uno,     @Str_Produc,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo    
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,  @Ent_Uno,    @Str_Produc,  @Bit_Exito,       
                      @NumTransac, @Transaccio,   @Usuario,     @FechaSis,
                      @SucOrigen,  @SucDestino,   @Modulo
end

/***** producto_tipo_cuenta ******/
exec @Status = SOTMPPTCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Dos,     @Str_PrTiCu,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,  @Ent_Dos,  @Str_PrTiCu,  @Bit_Exito,       
                      @NumTransac, @Transaccio, @Usuario,     @FechaSis,
                      @SucOrigen,  @SucDestino, @Modulo
end

/***** producto_personalidad_fiscal ******/
exec @Status = SOTMPPPFPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Tres,     @Str_PrPrFi,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Tres,     @Str_PrPrFi,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_clasificacion_producto ******/
exec @Status = SOTMPCLPPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Cuatro,     @Str_PrClPr,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Cuatro,     @Str_PrClPr,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_credito_consumo******/
exec @Status = SOTMPPCCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Cinco,     @Str_PrCrCc,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Cinco,     @Str_PrCrCc,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_credito_comercial******/
exec @Status = SOTMPPCOPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Seis,     @Str_PrCrCo,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Seis,     @Str_PrCrCo,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_tarjeta******/
exec @Status = SOTMPPTAPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    rollback
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Siete,     @Str_PrTarj,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    return 1
end else begin
    exec @Status = SOPROBITALT  @Act_Fecha,   @Ent_Siete,     @Str_PrTarj,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end