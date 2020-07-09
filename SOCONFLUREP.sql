create procedure SOCONFLUREP (
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
** Descripcion:    	Reporte de Control de Flujos										****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		14/06/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Reporte de Control de Flujos											****
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

select	Cof_Flujo, Flu_Nombre = isnull(Flu_Nombre,''), Cof_ProFlu, Prf_Nombre = isnull(Prf_Nombre, ''), Ejecucion = case when Cof_Ejecut = 1 then 'Ejecucion Exitosa' else 'Ejecucion PENDIENTE' end, 
		Cof_FecHor = case when Cof_FecHor = '19000101' then null else Cof_FecHor end
	from SOCONFLU noholdlock
	left join SOFLUJOS noholdlock
			on Flu_Numero = Cof_Flujo
	left join SOPROFLU noholdlock
			on Prf_Numero = Cof_ProFlu
	where Cof_Flujo	= @Num_Flujo
	  and Cof_Fecha	= @Fec_Inicia
	order by Cof_Orden

return @Can_Cero
