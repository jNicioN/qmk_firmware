--create function SOCOCMFAFN
create procedure SOCACOAPPRO
(
	@Fec_Apertu smalldatetime, 		/* Fecha de Apertura de la Cuenta*/
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
** DESCRIPCION: Calculo de Comision de Tipo Monto Fijo por Apertura		****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Code4u Joel Gonzalez									****
** Fecha:		31/01/2020											    ****
** Help:			1286068											    ****
** Descripcion:	Creacion de la funcion									****
****************************************************************************/

-- Declaración de Variables
declare	@Suc_Origen char(3)			/* Sucursal de Origen para obtener la Fecha de Operacion */
		
-- Declaración de Constantes
declare	@Fec_Actual smalldatetime,	/* Fecha de Operacion del Sistema */
		@Bit_Si		bit,			/* Si (bit) */
		@Bit_No		bit,			/* No (bit) */
		@Mon_Cero 	money,			/* Monto cero */
		@Ele_Comisi	int				/* Elemento Comision */

-- Asignación de Constantes
select  @Suc_Origen = '001',		/* Sucursal de Origen para obtener la Fecha de Operacion */
		@Bit_Si		= 1,			/* Si (bit)*/
		@Bit_No		= 0,			/* No (bit) */
		@Ele_Comisi	= 1				/* Elemento Comision */

-- Proceso principal

select	@Fec_Actual		= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @Suc_Origen

--Tma_Aplica indica si se debe aplicar la Comision o no
--ETC1.Etc_Valor contiene el valor de la Comision

select	@Mon_Comisi = 0.00
--Se aplica la Comision solo en el mes y año de Apertura
if DATEPART(year, @Fec_Apertu) = DATEPART(year, @Fec_Actual) and DATEPART(month, @Fec_Apertu) = DATEPART(month, @Fec_Actual)
begin
	select	@Mon_Comisi = case when Tma_Aplica = @Bit_Si then ETC1.Etc_Valor else @Mon_Cero end
		from SOTIMOAS
		inner join SOELTICA ETC1
				on ETC1.Etc_TiMoAs  = Tma_Numero
				and ETC1.Etc_Activo = @Bit_Si
		inner join SOELTIMO ETM1
				on ETM1.Etm_Numero  = ETC1.Etc_ElTiMo
				and ETM1.Etm_NumEle = @Ele_Comisi
				and ETM1.Etm_Activo = @Bit_Si
		where	Tma_Numero = @Tma_Numero
end

return