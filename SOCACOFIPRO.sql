--create function SOCOCMFSFN
create procedure SOCACOFIPRO
(
	@Sal_Promed money,				/* Saldo Promedio de la Cuenta */
	@Tma_Numero int,				/* Numero de Configuracion de SOTIMOAS a utilizar en el calculo */
	@Mon_Comisi money output,		/* Monto de Comision */
	@NumTransac	char(10),			/* Auditoria */
	@Transaccio	char(3),			/* Auditoria */
	@Usuario	char(6),            /* Auditoria */
	@FechaSis	smalldatetime,      /* Auditoria */
	@SucOrigen	char(3),            /* Auditoria */
	@SucDestino	char(3),            /* Auditoria */
    @Modulo		char(2)            	/* Auditoria */
)
as

/***************************************************************************
** DESCRIPCION: Calculo de Comision de Tipo Monto Fijo con Saldo Minimo	****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Code4u Joel Gonzalez									****
** Fecha:		31/01/2020											    ****
** Help:			1286068											    ****
** Descripcion:	Creacion de la funcion									****
****************************************************************************/

-- Declaración de Constantes
declare	@Bit_Si		bit,		/* Si (bit) */
		@Bit_No		bit,		/* No (bit) */
		@Mon_Cero 	money,		/* Monto cero */
		@Ele_Comisi	int,		/* Elemento Comision */
		@Ele_SaPrMi	int,		/* Elemento Saldo Promedio Minimo */
		@Ele_ExeCuo	int			/* Elemento Exenta Cuota (La Cuenta podria Exenta la Cuota si cumple con el SPM) */

-- Asignación de Constantes
select  @Bit_Si		= 1,		/* Si (bit)*/
		@Bit_No		= 0,		/* No (bit) */
		@Mon_Cero 	= 0.00,		/* Monto cero */
		@Ele_Comisi = 1,		/* Elemento Comision */
		@Ele_SaPrMi	= 2,		/* Elemento Saldo Promedio Minimo */
		@Ele_ExeCuo	= 3			/* Elemento Exenta Cuota (La Cuenta podria Exenta la Cuota si cumple con el SPM) */

-- Proceso principal

--Tma_Aplica indica si se debe aplicar la Comision o no
--ETC1.Etc_Valor contiene el valor de la Comision
--ETC2.Etc_Valor contiene el valor del Saldo Promedio Minimo
--ETC3.Etc_Valor contiene el valor que indica si la Cuenta puede Exentar la Cuota si Cumple con el Saldo Promedio Minimo
--Si el Saldo Promedio Minimo es Cero, quiere decir que no se tiene posibilidad de Exentar la Cuota
select	@Mon_Comisi = 	case when Tma_Aplica = @Bit_Si then
							case when ETC3.Etc_Valor = @Mon_Cero then ETC1.Etc_Valor
							else
								case when @Sal_Promed >= ETC2.Etc_Valor 
								then @Mon_Cero 
								else ETC1.Etc_Valor
								end
							end
						else
							@Mon_Cero
						end
	from SOTIMOAS
	inner join SOELTICA ETC1
			on ETC1.Etc_TiMoAs = Tma_Numero
			and ETC1.Etc_Activo = @Bit_Si
	inner join SOELTIMO ETM1
			on ETM1.Etm_Numero = ETC1.Etc_ElTiMo
			and ETM1.Etm_NumEle = @Ele_Comisi
			and ETM1.Etm_Activo = @Bit_Si
	inner join SOELTICA ETC2
			on ETC2.Etc_TiMoAs = Tma_Numero
			and ETC2.Etc_Activo = @Bit_Si		
	inner join SOELTIMO ETM2
			on ETM2.Etm_Numero = ETC2.Etc_ElTiMo
			and ETM2.Etm_NumEle = @Ele_SaPrMi
			and ETM2.Etm_Activo = @Bit_Si
	inner join SOELTICA ETC3
			on ETC3.Etc_TiMoAs = Tma_Numero
			and ETC3.Etc_Activo = @Bit_Si		
	inner join SOELTIMO ETM3
			on ETM3.Etm_Numero = ETC3.Etc_ElTiMo
			and ETM3.Etm_NumEle = @Ele_SaPrMi
			and ETM3.Etm_Activo = @Bit_Si
	where	Tma_Numero = @Tma_Numero

return