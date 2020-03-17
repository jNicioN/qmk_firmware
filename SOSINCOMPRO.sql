create procedure SOSINCOMPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Migracion de la Información de Modalidades           ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		CODE4U Jonathan Perez                      			****
** Fecha:		    12/01/2020									        ****
** Help:			1286068  									        ****
** Descripción:	    Procedimiento padre de Sincronizacion.              ****
****************************************************************************/

											/* Declaración de variables  */
declare	@Status     int,
        @Act_Fecha  smalldatetime

declare	@Ent_Paso1	int,       				/* Declaracion de Constantes */
		@Ent_Paso2	int,
        @Ent_Paso3	int,
        @Ent_Paso4	int,
        @Ent_Paso5	int,
        @Ent_Paso6	int,
        @Ent_Paso7	int,
        @Ent_Paso8	int,
        @Ent_Paso9	int,
        @Ent_Paso10	int,
        @Ent_Paso11	int,
        @Ent_Paso12	int,
        @Ent_Paso13	int,
        @Ent_Paso14	int,
        @Ent_Paso15	int,
        @Ent_Paso16	int,
        @Ent_Paso17	int,
        @Ent_Paso18	int,
        @Ent_Paso19	int,
        @Ent_Paso20	int,
        @Ent_Paso21	int,
        @Ent_Paso22	int,
        @Ent_Paso23	int,
        @Ent_Paso24	int,
        @Ent_Paso25	int,
        @Str_Produc char(11),               /* Producto */
        @Str_PrTiCu char(11),               /* Producto Tipo Cuenta */
        @Str_PrPrFi char(11),               /* Producto Personalidad Fiscal */
        @Str_TiMvPr char(11),               /* Tipo Movimiento Personalidad */
        @Str_Nivel  char(11),               /* Nivel */
        @Str_NiMvPr char(11),               /* Nivel Tipo Movimiento Personalidad */
        @Str_CoTiMv char(11),               /* Configuracion Tipo Movimiento */
        @Str_VigCon char(11),               /* Vigencia Configuracion */
        @Str_ConPro char(11),               /* Configuracion Producto */
        @Str_CoClCl char(11),               /* Configuracion Clasificacion Cliente */
        @Str_ConPla char(11),               /* Configuracion Plaza */
        @Str_ConSuc char(11),               /* Configuracion Sucursal */
        @Str_ConZon char(11),               /* Configuracion Zona */
        @Str_CoGpCl char(11),               /* Configuracion Grupo Cliente */
        @Str_ConCli char(11),               /* Configuracion Cliente */
        @Str_ConCue char(11),               /* Configuracion Cuenta */
        @Str_CatCli char(11),               /* Categoria Cliente */
        @Str_CoCtCl char(11),               /* Configuracion Categoria Cliente */
        @Str_PrPrCo char(11),               /* Producto Personalidad Configuracion */
        @Str_TiMvCo char(11),               /* Tipo Movimiento Configuracion */
        @Str_EleCon char(11),               /* Elemento Configuracion */
        @Str_TipCal char(11),               /* Tipo Calculo */
        @Str_TipVal char(11),               /* Tipo Valor */
        @Str_ElTiCa char(11),               /* Elemento Tipo Calculo */
        @Str_DaAdMv char(11),               /* Dato Adicional Tipo Movimiento */
        @Bit_Exito  bit,                    
        @Bit_Error  bit                     

								            /* Asignacion de Constantes */
select  @Ent_Paso1  =  1,
        @Ent_Paso2	=  2,
        @Ent_Paso3	=  3,
        @Ent_Paso4	=  4,
        @Ent_Paso5	=  5,
        @Ent_Paso6	=  6,
        @Ent_Paso7	=  7,
        @Ent_Paso8	=  8,
        @Ent_Paso9	=  9,
        @Ent_Paso10	=  10,
        @Ent_Paso11	=  11,
        @Ent_Paso12 =  12,
        @Ent_Paso13	=  13,
        @Ent_Paso14	=  14,
        @Ent_Paso15	=  15,
        @Ent_Paso16	=  16,
        @Ent_Paso17	=  17,
        @Ent_Paso18	=  18,
        @Ent_Paso19	=  19,
        @Ent_Paso20	=  20,
        @Ent_Paso21	=  21,
        @Ent_Paso22	=  22,
        @Ent_Paso23	=  23,
        @Ent_Paso24	=  24,
        @Ent_Paso25	=  25,
        @Str_Produc =  'SOTMPPROPRO',
        @Str_PrTiCu =  'SOTMPPTCPRO',
        @Str_PrPrFi =  'SOTMPPPFPRO',
        @Str_TiMvPr =  'SOTMPTIMPRO',
        @Str_Nivel  =  'SOTMPNIVPRO',
        @Str_NiMvPr =  'SOTMPPTMPRO',
        @Str_CoTiMv =  'SOTMPCTMPRO',
        @Str_VigCon =  'SOTMPVIGPRO',
        @Str_ConPro =  'SOTMPCPRPRO',
        @Str_CoClCl =  'SOTMPCCCPRO',
        @Str_ConPla =  'SOTMPCPLPRO',
        @Str_ConSuc =  'SOTMPCSUPRO',
        @Str_ConZon =  'SOTMPCZOPRO',
        @Str_CoGpCl =  'SOTMPCGCPRO',
        @Str_ConCli =  'SOTMPCCLPRO',
        @Str_ConCue =  'SOTMPCCUPRO',
        @Str_CatCli =  'SOTMPCTCPRO',
        @Str_CoCtCl =  'SOTMPCACPRO',
        @Str_PrPrCo =  'SOTMPPPCPRO',
        @Str_TiMvCo =  'SOTMPTMCPRO',
        @Str_EleCon =  'SOTMPELCPRO',
        @Str_TipCal =  'SOTMPTCAPRO',
        @Str_TipVal =  'SOTMPTVLPRO',
        @Str_ElTiCa =  'SOTMPETCPRO',
        @Str_DaAdMv =  'SOTMPATCPRO',
        @Bit_Exito  =   0,
        @Bit_Error  =   1

select @Act_Fecha = getdate()

/***** producto ******/
exec @Status = SOTMPPROPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso1,     @Str_Produc,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,  @Ent_Paso1,    @Str_Produc,  @Bit_Exito,       
                      @NumTransac, @Transaccio,   @Usuario,     @FechaSis,
                      @SucOrigen,  @SucDestino,   @Modulo
end

/***** producto_tipo_cuenta ******/
exec @Status = SOTMPPTCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso2,     @Str_PrTiCu,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,  @Ent_Paso2,  @Str_PrTiCu,  @Bit_Exito,       
                      @NumTransac, @Transaccio, @Usuario,     @FechaSis,
                      @SucOrigen,  @SucDestino, @Modulo
end

/***** producto_personalidad_fiscal ******/
exec @Status = SOTMPPPFPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso3,     @Str_PrPrFi,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso3,     @Str_PrPrFi,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_movimiento_personalidad ******/
exec @Status = SOTMPTIMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso4,     @Str_TiMvPr,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso4,     @Str_TiMvPr,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** nivel ******/
exec @Status = SOTMPNIVPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso5,     @Str_Nivel,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso5,     @Str_Nivel,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** nivel_tipo_movimiento_personalidad ******/
exec @Status = SOTMPPTMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso6,     @Str_NiMvPr,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso6,     @Str_NiMvPr,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_tipo_movimiento ******/
exec @Status = SOTMPCTMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso7,     @Str_CoTiMv,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso7,     @Str_CoTiMv,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** vigencia_configuracion ******/
exec @Status = SOTMPVIGPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo


if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso8,     @Str_VigCon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso8,     @Str_VigCon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end


/***** configuracion_producto ******/
exec @Status = SOTMPCPRPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso9,     @Str_ConPro,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso9,     @Str_ConPro,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configracion_clasificacion_cliente ******/
exec @Status = SOTMPCCCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso10,    @Str_CoClCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso10,    @Str_CoClCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_plaza ******/
exec @Status = SOTMPCPLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso11,    @Str_ConPla,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso11,    @Str_ConPla,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_sucursal ******/
exec @Status = SOTMPCSUPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso12,    @Str_ConSuc,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso12,    @Str_ConSuc,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_zona ******/
exec @Status = SOTMPCZOPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso13,    @Str_ConZon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso13,    @Str_ConZon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_grupo_cliente ******/
exec @Status = SOTMPCGCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso14,    @Str_CoGpCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso14,    @Str_CoGpCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_cliente ******/
exec @Status = SOTMPCCLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso15,    @Str_ConCli,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso15,    @Str_ConCli,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_cuenta ******/
exec @Status = SOTMPCCUPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso16,    @Str_ConCue,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso16,    @Str_ConCue,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** categoria_cliente ******/
exec @Status = SOTMPCTCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso17,    @Str_CatCli,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso17,    @Str_CatCli,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_categoria_cliente ******/
exec @Status = SOTMPCACPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso18,    @Str_CoCtCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso18,    @Str_CoCtCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_personalidad_configuracion ******/
exec @Status = SOTMPPPCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso19,    @Str_PrPrCo,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso19,    @Str_PrPrCo,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_movimiento_configuracion ******/
exec @Status = SOTMPTMCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso20,    @Str_TiMvCo,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso20,    @Str_TiMvCo,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** elemento_configuracion ******/
exec @Status = SOTMPELCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso21,    @Str_EleCon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso21,    @Str_EleCon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_calculo ******/
exec @Status = SOTMPTCAPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso22,    @Str_TipCal,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso22,    @Str_TipCal,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_valor ******/
exec @Status = SOTMPTVLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso23,    @Str_TipVal,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso23,    @Str_TipVal,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** elemento_tipo_calculo ******/
exec @Status = SOTMPETCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso24,    @Str_ElTiCa,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso24,    @Str_ElTiCa,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** dato_adicional_tipo_movimiento ******/
exec @Status = SOTMPATCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso25,    @Str_DaAdMv,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Paso25,    @Str_DaAdMv,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end
