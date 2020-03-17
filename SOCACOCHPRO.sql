--create function SOCOCCHEFN
create procedure SOCACOCHPRO
(
	@Che_Expedi money,				/* Cantidad de Cheques Expedidos */
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
** DESCRIPCION: Calculo de Comision de Tipo Cheques Librados			****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Code4u Joel Gonzalez									****
** Fecha:		31/01/2020											    ****
** Help:														   		****
** Descripcion:	Creacion de la funcion							   		****
****************************************************************************/


-- Declaración de Constantes
declare	@Bit_Si		bit,		/* Si (bit) */
		@Bit_No		bit,		/* No (bit) */
		@Mon_Cero 	money,		/* Monto cero */
		@Ele_Comisi	int,		/* Elemento Comision */
		@Ele_CheGra	int			/* Elemento Cheques Gratis */

-- Asignación de Constantes
select @Bit_Si		= 1,		/* Si (bit)*/
		@Bit_No		= 0,		/* No (bit) */
		@Mon_Cero 	= 0.00,		/* Monto cero */
		@Ele_Comisi = 1,		/* Elemento Comision */
		@Ele_CheGra	= 2			/* Elemento Cheques Gratis */

--Tma_Aplica indica si se debe aplicar la Comision o no
--ETC1.Etc_Valor contiene el valor de la Comision
--ETC2.Etc_Valor contiene la Cantidad de Cheques Gratis en el mes

select	@Mon_Comisi =	case when Tma_Aplica = @Bit_Si then
						case when @Che_Expedi >= ETC2.Etc_Valor then (@Che_Expedi - ETC2.Etc_Valor) * ETC1.Etc_Valor else @Mon_Cero end
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
			and ETM2.Etm_NumEle = @Ele_CheGra
			and ETM2.Etm_Activo = @Bit_Si
	where	Tma_Numero = @Tma_Numero

return