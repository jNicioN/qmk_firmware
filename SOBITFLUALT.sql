create procedure SOBITFLUALT (
	@Bif_Flujo	int,			-- Flujo
	@Bif_Fecha	smalldatetime,	-- Fecha
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
		
--Variables

--Constantes
declare	@Can_Cero   tinyint		-- Cantidad: Cero 

select  @Can_Cero   = 0			-- Cantidad: Cero
		
insert into SOBITFLU	(	Bif_Flujo,	Bif_Fecha,	Bif_ProFlu, Bif_EjeExi, Bif_FecHor, 
							Bif_Mensaj, NumTransac, Transaccio, Usuario,	FechaSis, 
							SucOrigen,	SucDestino)
values(						@Bif_Flujo,	@Bif_Fecha,	@Bif_ProFlu,@Bif_EjeExi,@Bif_FecHor, 
							@Bif_Mensaj,@NumTransac,@Transaccio,@Usuario,	@FechaSis, 
							@SucOrigen,	@SucDestino)

return @Can_Cero
