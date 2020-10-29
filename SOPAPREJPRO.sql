create procedure SOPAPREJPRO (
	@Num_EjeFlu int,				-- Numero de Ejecucion de Flujo
	@Num_ProFlu int,				-- Numero de Proceso de Flujo
	@Lis_Parame	varchar(200) output,		-- Lista de Parametros
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion: Generacion de Lista de Parametros de Procesos en Ejecucion de Flujos	****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		09/09/2020									        					****
** Help:		1394242						        									****
** Descripcion:	Generacion de Lista de Parametros de Procesos en Ejecucion de Flujos	****
**              para incluirse en la ejecucion del Proceso								****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int,			-- Resultado de Ejecucion
		@Ppf_NomPar	varchar(20),	-- Nombre de Parametro
		@Ppf_Valor	varchar(50),	-- Valor de Parametro
		@Val_Comill	varchar(1)		-- El Valor de Comillas para Parametro. (Se agrega Comillas al valor cuando este lo requiera).

--Constantes
declare	@Can_Cero	tinyint,	-- Cantidad: Cero
		@Can_Uno	tinyint,	-- Cantidad: Uno
		@Bit_Si		bit			-- Si

select  @Can_Cero	= 0,		-- Cantidad: Cero
		@Can_Uno	= 1,		-- Cantidad: Uno
		@Bit_Si		= 1			-- Si

--
--select	@Res_EjePro	= @Can_Uno

select	@Lis_Parame	= ''

declare PAPRFL cursor for
	select Ppf_NomPar, Ppf_Valor = isnull(Ppe_Valor, Ppf_Valor), Val_Comill = case when Ppf_Comill = 1 then '''' else '' end
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_Activo = @Bit_Si
	for read only

open PAPRFL

fetch PAPRFL into @Ppf_NomPar, @Ppf_Valor, @Val_Comill

while @@sqlstatus = 0 begin
	select @Lis_Parame	= @Lis_Parame + ',' + '@' + @Ppf_NomPar + ' = ' + @Val_Comill + @Ppf_Valor + @Val_Comill + ' '
	
	fetch PAPRFL into @Ppf_NomPar, @Ppf_Valor, @Val_Comill
end

-- En caso de error informar Codigo de Error
-- select	@Res_EjePro	= @@error
-- if @Res_EjePro	<> @Can_Cero begin
	-- return	@Res_EjePro
-- end

close PAPRFL
deallocate PAPRFL
