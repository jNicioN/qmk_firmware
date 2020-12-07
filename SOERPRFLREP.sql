create procedure SOERPRFLREP (
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
** Descripcion:    	Reporte de Errores de Procesos de Flujos							****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		28/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Cambio en acceso a Bitacora utilizando el Numero de Ejecucion de Flujo	****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		29/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Errores de Procesos de Flujos								****
********************************************************************************************/

select	Flu_Numero, Flu_Nombre, Prf_Numero, Prf_Nombre, Epf_Elemen, 
		Epf_Mensaj
	from SOERPRFL noholdlock
	inner join SOPROFLU noholdlock
			on Prf_Numero	= Epf_ProFlu
	inner join SOFLUJOS noholdlock
			on Flu_Numero	= Prf_Flujo
	where Epf_EjeFlu	= @Num_EjeFlu
	order by Epf_Numero
