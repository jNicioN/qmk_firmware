create procedure SOBITFLUREP (
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
** Descripcion:    	Reporte de Bitacora de Flujos										****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		12/06/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Bitacora de Flujos											****
********************************************************************************************/
		
--Variables
declare	@Fec_Inicia	smalldatetime,	-- Fecha y Hora de Inicio de consulta
		@Fec_Final	smalldatetime	-- Fecha y Hora Final de consulta

--Constantes
declare	@Can_Cero   tinyint		-- Cantidad: Cero 

-- Asignacion de Constantes
select  @Can_Cero   = 0			-- Cantidad: Cero
		
select	@Fec_Inicia	=	convert(smalldatetime, convert(varchar(8), @Fec_Report, 112))

select	@Fec_Final	=	dateadd(dd, 1, @Fec_Inicia)

select	Bif_Flujo,	Flu_Nombre = isnull(Flu_Nombre,''), Bif_ProFlu, Prf_Nombre = isnull(Prf_Nombre, ''), Bif_EjeExi = case when Bif_EjeExi = 1 then 'Ejecucion Exitosa' else 'Ejecucion Fallida' end, 
		Bif_FecHor,	Bif_Mensaj
	from SOBITFLU noholdlock
	left join SOFLUJOS noholdlock
			on Flu_Numero = Bif_Flujo
	left join SOPROFLU noholdlock
			on Prf_Numero = Bif_ProFlu
	where Bif_Flujo	= @Num_Flujo
	  and Bif_Fecha	= @Fec_Inicia
	order by Bif_Numero

return @Can_Cero
