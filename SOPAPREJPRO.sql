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

create table #Parametros	-- Parametros a agregar en la ejecucion de procedimientos
	(
		Par_Identi	int	identity	not null,
		Par_NomPar	varchar(20) 	not null,	-- Nombre de Parametro
		Par_Valor	varchar(50)		not null,	-- Valor de Parametro
		Par_Comill	varchar(1)		not null	-- El Valor de Comillas para Parametro. (Se agrega Comillas al valor cuando este lo requiera).
	)

--Variables
declare	@Ppf_NomPar	varchar(20),	-- Nombre de Parametro
		@Ppf_Valor	varchar(50),	-- Valor de Parametro
		@Val_Comill	varchar(1),		-- El Valor de Comillas para Parametro. (Se agrega Comillas al valor cuando este lo requiera).
		@Reg_Inicia	int,			-- Registro Inicial a procesar
		@Reg_Final	int,			-- Registro Final a procesar
		@Reg_Actual	int				-- Registro Actual en proceso

--Constantes
declare	@Ent_Uno	tinyint,	-- Cantidad: Uno
		@Bit_Si		bit			-- Si

select  @Ent_Uno	= 1,		-- Cantidad: Uno
		@Bit_Si		= 1			-- Si

--

select	@Lis_Parame	= ''

insert into #Parametros(Par_NomPar,	Par_Valor,	Par_Comill)
	select Ppf_NomPar, Ppf_Valor = isnull(Ppe_Valor, Ppf_Valor), Val_Comill = case when Ppf_Comill = @Bit_Si then '''' else '' end
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_Activo = @Bit_Si

select	@Reg_Inicia	= min(Par_Identi)
	from #Parametros noholdlock
	
select	@Reg_Final	= max(Par_Identi)
	from #Parametros noholdlock

select	@Reg_Actual	= @Reg_Inicia

while @Reg_Actual <= @Reg_Final begin
	select 
		@Ppf_NomPar	= Par_NomPar, 
		@Ppf_Valor	= Par_Valor, 
		@Val_Comill	= Par_Comill
		from #Parametros noholdlock
		where Par_Identi	= @Reg_Actual

	select @Lis_Parame	= @Lis_Parame + ',' + '@' + @Ppf_NomPar + ' = ' + @Val_Comill + @Ppf_Valor + @Val_Comill + ' '
	
	select	@Reg_Actual	= @Reg_Actual + @Ent_Uno
end

drop table #Parametros
