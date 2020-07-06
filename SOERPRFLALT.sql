create procedure SOERPRFLALT (
	@Epf_Fecha	smalldatetime,
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
** Fecha:		27/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Alta de Errores de Procesos de Flujos									****
********************************************************************************************/
		
--Variables

--Constantes
declare	@Can_Cero   tinyint		-- Cantidad: Cero 

select  @Can_Cero   = 0			-- Cantidad: Cero
		
insert into SOERPRFL	(	Epf_Fecha,	Epf_ProFlu,	Epf_Elemen,	Epf_Mensaj, NumTransac, 
							Transaccio, Usuario,	FechaSis, 	SucOrigen,	SucDestino)
values(						@Epf_Fecha,	@Epf_ProFlu,@Epf_Elemen,@Epf_Mensaj,@NumTransac,
							@Transaccio,@Usuario,	@FechaSis, 	@SucOrigen,	@SucDestino)

return @Can_Cero
