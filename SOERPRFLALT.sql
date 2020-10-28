create procedure SOERPRFLALT (
	@Epf_EjeFlu	int,
    @Epf_ProFlu	int,
    @Epf_Elemen	varchar(20),
    @Epf_Mensaj	varchar(200),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Errores de Procesos de Flujos								****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		28/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Cambio por acceso a SOERPRFL con el Numero de Ejecucion de Flujo		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		27/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Alta de Errores de Procesos de Flujos									****
********************************************************************************************/
		
insert into SOERPRFL	(	Epf_EjeFlu,	Epf_ProFlu,	Epf_Elemen,	Epf_Mensaj, NumTransac, 
							Transaccio, Usuario,	FechaSis, 	SucOrigen,	SucDestino)
values(						@Epf_EjeFlu,@Epf_ProFlu,@Epf_Elemen,@Epf_Mensaj,@NumTransac,
							@Transaccio,@Usuario,	@FechaSis, 	@SucOrigen,	@SucDestino)
