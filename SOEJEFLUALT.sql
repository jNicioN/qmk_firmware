create procedure SOEJEFLUALT (
	@Ejf_Numero int output, 
	@Ejf_Flujo 	int,
    @Ejf_Fecha 	smalldatetime,
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Ejecucion de Flujo											****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		26/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Alta de Ejecucion de Flujo												****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int

--Constantes
declare	@Can_Cero  tinyint,		-- Cantidad: Cero
		@Can_Uno   tinyint		-- Cantidad: Uno

--Valores de Constantes
select  @Can_Cero  = 0,			-- Cantidad: Cero
		@Can_Uno   = 1			-- Cantidad: Uno

--
select	@Res_EjePro	= @Can_Uno

insert into SOEJEFLU	(	Ejf_Flujo,	Ejf_Fecha,	NumTransac, Transaccio, Usuario,
							FechaSis, 	SucOrigen,	SucDestino)
values(						@Ejf_Flujo,	@Ejf_Fecha,	@NumTransac,@Transaccio,@Usuario,
							@FechaSis, 	@SucOrigen,	@SucDestino)
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Can_Cero begin
	return	@Res_EjePro
end

-- Obtener el Numero de Ejecucion generado
select	@Ejf_Numero	= @@identity

