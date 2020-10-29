create procedure SOINEJPRMOD (
	@Iep_Numero	int,
	@Iep_EjeFlu	int,
	@Iep_ProFlu	int,
	@Iep_ElePro	int,
	@Iep_ElPrEx	int,
	@Iep_ElPrEr	int,
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Modificacion de Informacion de Procesos de Flujos					****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		16/07/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Modificacion de Informacion de Procesos de Flujos						****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int

--Constantes
declare	@Can_Cero  tinyint,		-- Cantidad: Cero
		@Can_Uno   tinyint		-- Cantidad: Uno

select  @Can_Cero   = 0,		-- Cantidad: Cero
		@Can_Uno	= 1			-- Cantidad: Uno

--
select	@Res_EjePro	= @Can_Uno
		
update SOINEJPR
	set Iep_ElePro	= @Iep_ElePro,
		Iep_ElPrEx	= @Iep_ElPrEx, 
		Iep_ElPrEr	= @Iep_ElPrEr,
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis, 
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Iep_Numero	= @Iep_Numero
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Can_Cero begin
	return	@Res_EjePro
end
