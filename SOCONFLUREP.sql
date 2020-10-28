create procedure SOCONFLUREP (
	@Num_EjeFlu	int,			-- Numero de Ejecucion de Flujo
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Reporte de Control de Flujos										****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		28/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Se cambia la consulta a SOCONFLU para utilizar el Numero de Ejecucion	****
**              de Flujo.																****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		14/06/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Control de Flujos											****
********************************************************************************************/

select	Flu_Numero, Flu_Nombre = isnull(Flu_Nombre,''), Cof_ProFlu, Prf_Nombre = isnull(Prf_Nombre, ''), Ejecucion = case when Cof_Ejecut = 1 then 'Ejecucion Exitosa' else 'Ejecucion PENDIENTE' end, 
		Cof_FecHor = case when Cof_FecHor = '19000101' then null else Cof_FecHor end
	from SOCONFLU noholdlock
	left join SOPROFLU noholdlock
			on Prf_Numero = Cof_ProFlu
	left join SOFLUJOS noholdlock
			on Flu_Numero = Prf_Flujo
	where Cof_EjeFlu	= @Num_EjeFlu
	order by Cof_Orden
