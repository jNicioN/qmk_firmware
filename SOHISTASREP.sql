create procedure SOHISTASREP (
	@Hit_Tasa	char(2),
	@Anio		int,
	@Mes		int,
	@Tip_Report	char(1) ,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Reporte de Tasas Historicas									 */
/*****************************************************************************/

/** REFERENCIAS: 
****************************************************************************
** Modificý:		Juan Manuel Ramirez								****
** Fecha:		25/Junio/2018											****
** Help:		1047250		
****************************************************************************
** Creý:		Marco A. Morales Ventura								****
** Fecha:		02/Enero/2013											****
** Help:		00514341												****
******************************************************************************/

/* Declaraciýn de Variables */

/* Declaraciýn de Constantes */
declare	@Tip_TaAnMe	char(1)

/* Asignaciýn de Constantes */
select	@Tip_TaAnMe	= '1'			/* Tipo de Consulta por Tasa, Aýo y Mes */
SELECT @Tip_Report = '1'
if @Tip_Report = @Tip_TaAnMe begin
	select	Hit_Tasa,	Hit_Fecha,	Hit_Valor
		from SOHISTAS noholdlock
		where Hit_Tasa = @Hit_Tasa
		  and datepart(yy, Hit_Fecha) = @Anio
		  and datepart(mm, Hit_Fecha) = @Mes
		order by Hit_Fecha
end
