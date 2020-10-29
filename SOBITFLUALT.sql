create procedure SOBITFLUALT (
	@Bif_EjeFlu	int,			-- Ejecucion de Flujo
	@Bif_ProFlu	int,			-- Proceso
	@Bif_EjeExi	bit,			-- Ejecucion Exitosa
	@Bif_FecHor	smalldatetime,	-- Fecha y hora de ejecucion
	@Bif_Mensaj varchar(200),	-- Mensaje
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Bitacora de Flujos											****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		27/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Alta de mensajes en Bitacora de Flujos									****
********************************************************************************************/
		
insert into SOBITFLU	(	Bif_EjeFlu,	Bif_ProFlu, Bif_EjeExi, Bif_FecHor, Bif_Mensaj, 
							NumTransac, Transaccio, Usuario,	FechaSis, 	SucOrigen,	
							SucDestino)
values(						@Bif_EjeFlu,@Bif_ProFlu,@Bif_EjeExi,@Bif_FecHor,@Bif_Mensaj,
							@NumTransac,@Transaccio,@Usuario,	@FechaSis, 	@SucOrigen,	
							@SucDestino)
							