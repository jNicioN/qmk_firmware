create procedure SOPAPREJALT (
	@Ppe_Numero int output,
	@Ppe_EjeFlu int,
	@Ppe_PaPrFl int,
	@Ppe_Valor	varchar(50),
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Parametros de Procesos en Ejecucion de Flujos				****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		08/09/2020									        					****
** Help:		1394242						        									****
** Descripcion:	Alta de Parametros de Procesos en Ejecucion de Flujos					****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int

--Constantes
declare	@Can_Cero  tinyint,		-- Cantidad: Cero
		@Can_Uno   tinyint		-- Cantidad: Uno

select  @Can_Cero  = 0,			-- Cantidad: Cero
		@Can_Uno   = 1			-- Cantidad: Uno

--
select	@Res_EjePro	= @Can_Uno

insert into SOPAPREJ	(	Ppe_EjeFlu,	Ppe_PaPrFl,	Ppe_Valor, NumTransac, Transaccio,
							Usuario,	FechaSis, 	SucOrigen,	SucDestino)
values(						@Ppe_EjeFlu,@Ppe_PaPrFl,@Ppe_Valor,@NumTransac,@Transaccio,
							@Usuario,	@FechaSis, 	@SucOrigen,	@SucDestino)
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Can_Cero begin
	return	@Res_EjePro
end

select	@Ppe_Numero	= @@identity
