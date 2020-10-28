create procedure SOBIPRFLREP (
	@Num_EjeFlu	int,			-- Numero de Ejecucion de Flujo
    @Num_ProFlu	int,			-- Numero de Proceso de Flujo
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Reporte de Bitacora de Procesos de Flujos							****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		21/07/2020									        					****
** Help:		1394242						        						****
** Descripcion:	Reporte de Bitacora de Procesos de Flujos								****
********************************************************************************************/	

select	Bpf_Numero,	Bpf_ProFlu,	Bpf_Elemen,	Bpf_FecHor,	Bpf_EjeExi,
		Bpf_Mensaj,	Bpf_IdeExt
	from SOBIPRFL noholdlock
	where Bpf_EjeFlu	= @Num_EjeFlu
	  and Bpf_ProFlu	= @Num_ProFlu
	order by Bpf_FecHor, Bpf_Numero
