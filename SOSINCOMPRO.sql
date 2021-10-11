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
** Descripción:    Sincronizacion de la información de comisiones          ****
****************************************************************************
** Referencias:															****
****************************************************************************
****************************************************************************
** Creó:		Alan Santamaria		                            		****
** Fecha:		07-10-2021          									****
** Descripción: Se elimina la seccion de configuracion producto         ****
**              debido a que se separa el sp de sincronizacion          ****
** Help:		    										            ****
****************************************************************************
** Elaboró: 		CODE4U Jonathan Perez                      			****
** Fecha:		    12/01/2020									        ****
** Help:			1286068  									        ****
** Descripción:	    Procedimiento padre de Sincronizacion.              ****
****************************************************************************/

											/* Declaración de variables  */
declare	@Status     int,
        @Act_Fecha  smalldatetime

declare	@Ent_Uno	int,                    /* Declaracion de Constantes */
        @Ent_Dos	int,        
        @Ent_Tres	int,
        @Ent_Cuatro	int,       				
        @Ent_Cinco	int,
        @Ent_Seis	int,
        @Ent_Siete	int,
        @Ent_Ocho	int,
        @Ent_Nueve	int,
        @Ent_Diez	int,
        @Ent_Once	int,
        @Ent_Doce	int,
        @Ent_Trece	int,
        @Ent_Catorc	int,
        @Ent_Quince	int,
        @Ent_DieSei	int,
        @Ent_DieSie	int,
        @Ent_DieOch	int,
        @Ent_DieNue	int,
        @Ent_Veinte	int,
        @Ent_VeiUno	int,
        @Ent_VeiDos	int,      
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
select  @Ent_Uno	=  1,
        @Ent_Dos	=  2,
        @Ent_Tres	=  3,
        @Ent_Cuatro	=  4,
        @Ent_Cinco	=  5,
        @Ent_Seis	=  6,
        @Ent_Siete	=  7,
        @Ent_Ocho	=  8,
        @Ent_Nueve	=  9,
        @Ent_Diez	=  10,
        @Ent_Once	=  11,
        @Ent_Doce =  12,
        @Ent_Trece	=  13,
        @Ent_Catorc	=  14,
        @Ent_Quince	=  15,
        @Ent_DieSei	=  16,
        @Ent_DieSie	=  17,
        @Ent_DieOch	=  18,
        @Ent_DieNue	=  19,
        @Ent_Veinte	=  20,
        @Ent_VeiUno	=  21,
        @Ent_VeiDos	=  22,
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

/***** tipo_movimiento_personalidad ******/
exec @Status = SOTMPTIMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Uno,     @Str_TiMvPr,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Uno,     @Str_TiMvPr,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** nivel ******/
exec @Status = SOTMPNIVPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Dos,     @Str_Nivel,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Dos,     @Str_Nivel,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** nivel_tipo_movimiento_personalidad ******/
exec @Status = SOTMPPTMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Tres,     @Str_NiMvPr,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Tres,     @Str_NiMvPr,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_tipo_movimiento ******/
exec @Status = SOTMPCTMPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Cuatro,     @Str_CoTiMv,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Cuatro,     @Str_CoTiMv,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** vigencia_configuracion ******/
exec @Status = SOTMPVIGPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo


if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Cinco,     @Str_VigCon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Cinco,     @Str_VigCon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end


/***** configuracion_producto ******/
exec @Status = SOTMPCPRPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Seis,     @Str_ConPro,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Seis,     @Str_ConPro,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configracion_clasificacion_cliente ******/
exec @Status = SOTMPCCCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Siete,    @Str_CoClCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Siete,    @Str_CoClCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_plaza ******/
exec @Status = SOTMPCPLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Ocho,    @Str_ConPla,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Ocho,    @Str_ConPla,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_sucursal ******/
exec @Status = SOTMPCSUPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Nueve,    @Str_ConSuc,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Nueve,    @Str_ConSuc,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_zona ******/
exec @Status = SOTMPCZOPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Diez,    @Str_ConZon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Diez,    @Str_ConZon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_grupo_cliente ******/
exec @Status = SOTMPCGCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Once,    @Str_CoGpCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Once,    @Str_CoGpCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_cliente ******/
exec @Status = SOTMPCCLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Doce,    @Str_ConCli,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Doce,    @Str_ConCli,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_cuenta ******/
exec @Status = SOTMPCCUPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Trece,    @Str_ConCue,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Trece,    @Str_ConCue,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** categoria_cliente ******/
exec @Status = SOTMPCTCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Catorc,    @Str_CatCli,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Catorc,    @Str_CatCli,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** configuracion_categoria_cliente ******/
exec @Status = SOTMPCACPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Quince,    @Str_CoCtCl,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Quince,    @Str_CoCtCl,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** producto_personalidad_configuracion ******/
exec @Status = SOTMPPPCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieSei,    @Str_PrPrCo,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieSei,    @Str_PrPrCo,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_movimiento_configuracion ******/
exec @Status = SOTMPTMCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieSie,    @Str_TiMvCo,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieSie,    @Str_TiMvCo,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** elemento_configuracion ******/
exec @Status = SOTMPELCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieOch,    @Str_EleCon,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieOch,    @Str_EleCon,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_calculo ******/
exec @Status = SOTMPTCAPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieNue,    @Str_TipCal,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_DieNue,    @Str_TipCal,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** tipo_valor ******/
exec @Status = SOTMPTVLPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Veinte,    @Str_TipVal,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_Veinte,    @Str_TipVal,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** elemento_tipo_calculo ******/
exec @Status = SOTMPETCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_VeiUno,    @Str_ElTiCa,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_VeiUno,    @Str_ElTiCa,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end

/***** dato_adicional_tipo_movimiento ******/
exec @Status = SOTMPATCPRO @NumTransac, @Transaccio,    @Usuario,   @FechaSis,
                           @SucOrigen,  @SucDestino,    @Modulo

if @Status <> 0 begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_VeiDos,    @Str_DaAdMv,    @Bit_Error,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
    rollback
    return 1
end else begin
    exec SOCOMBITALT  @Act_Fecha,   @Ent_VeiDos,    @Str_DaAdMv,    @Bit_Exito,       
                      @NumTransac,  @Transaccio,    @Usuario,       @FechaSis,
                      @SucOrigen,   @SucDestino,    @Modulo
end
