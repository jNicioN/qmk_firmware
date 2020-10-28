create procedure SOBITFLUREP (
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
** Descripcion:    	Reporte de Bitacora de Flujos										****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		28/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Cambio en acceso a SOBITFLU utilizan el Numero de Ejecucion de Flujo	****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		12/06/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Bitacora de Flujos											****
********************************************************************************************/

select	Flu_Numero,	Flu_Nombre = isnull(Flu_Nombre,''), Bif_ProFlu, Prf_Nombre = isnull(Prf_Nombre, ''), Bif_EjeExi = case when Bif_EjeExi = 1 then 'Ejecucion Exitosa' else 'Ejecucion Fallida' end, 
		Bif_FecHor,	Bif_Mensaj
	from SOBITFLU noholdlock
	left join SOPROFLU noholdlock
			on Prf_Numero = Bif_ProFlu
	left join SOFLUJOS noholdlock
			on Flu_Numero = Prf_Flujo
	where Bif_EjeFlu	= @Num_EjeFlu
	order by Bif_Numero
