create procedure SOINEJPRREP (
	@Iep_EjeFlu	int,			-- Numero de Ejecucion de Flujo
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Reporte de Informacion de Procesos de Flujos						****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		12/06/2020									        					****
** Help:		1394242						        						****
** Descripcion:	Reporte de Informacion de Procesos de Flujos							****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int

--Constantes
declare	@Can_Cero  tinyint,		-- Cantidad: Cero
		@Can_Uno   tinyint		-- Cantidad: Uno

-- Asignacion de Constantes
select  @Can_Cero   = 0,		-- Cantidad: Cero
		@Can_Uno	= 1			-- Cantidad: Uno

--
select	@Res_EjePro	= @Can_Uno		

select	Prf_Numero, Prf_Nombre, Iep_ElePro, Iep_ElPrEx, Iep_ElPrEr
	from SOINEJPR noholdlock
	inner join SOPROFLU noholdlock
			on Prf_Numero	= Iep_ProFlu
	inner join SOFLUJOS noholdlock
			on Flu_Numero	= Prf_Flujo
	where Iep_EjeFlu	= @Iep_EjeFlu
	order by Prf_Orden
	
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Can_Cero begin
	return	@Res_EjePro
end

