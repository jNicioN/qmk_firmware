create procedure SOERPRFLREP (
	@Num_Flujo	int,			-- Numero de Flujo
	@Fec_Report	smalldatetime,	-- Fecha de Consulta
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
** Fecha:		29/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Errores de Procesos de Flujos								****
********************************************************************************************/
		
--Variables
declare	@Fec_Inicia	smalldatetime,	-- Fecha y Hora de Inicio de consulta
		@Fec_Final	smalldatetime	-- Fecha y Hora Final de consulta

--Constantes
declare	@Can_Cero   tinyint		-- Cantidad: Cero 

-- Asignacion de Constantes
select  @Can_Cero   = 0			-- Cantidad: Cero

select	@Fec_Report	=	convert(smalldatetime, convert(varchar(8), @Fec_Report, 112))

select	@Fec_Inicia	= min(Bif_FecHor),
		@Fec_Final	= max(Bif_FecHor)
	from SOBITFLU noholdlock
	where Bif_Fecha	= @Fec_Report

select	Flu_Numero, Flu_Nombre, Prf_Numero, Prf_Nombre, Epf_Fecha, 
		Epf_Elemen, Epf_Mensaj
	from SOFLUJOS noholdlock
	inner join SOPROFLU noholdlock
			on Prf_Flujo	= Flu_Numero
	inner join SOERPRFL noholdlock
			on  Epf_ProFlu	= Prf_Numero
			and Epf_Fecha	between @Fec_Inicia	and @Fec_Final
	where Flu_Numero	= @Num_Flujo
	order by Epf_Numero

return @Can_Cero
