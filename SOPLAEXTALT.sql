create procedure SOPLAEXTALT (
	@Pla_Banco  char(4),
	@Pla_Descri varchar(30),
	@Pla_Ubicac varchar(50),
	@Pla_Contac	varchar(30),
	@Pla_NumTel	varchar(20),
	@Pla_Fax	varchar(20),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

declare @Pla_Numero char(3),		/* Declaración de Variables */
		@Consec 	int

declare	@Str_Vacio	char(1)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''			/* String Vacío */

if (@Pla_Descri = @Str_Vacio) begin
	select 	Err_Codigo  = '000001', 
			Err_Mensaj	= 'Nombre incorrecto', 
			Err_Variab  = 'Pla_Nombre'
	rollback
end

if not exists(select 	Ban_NumSis 
				from SOBANCOS noholdlock
				where	Ban_NumSis	= @Pla_Banco) begin
	select 	Err_Codigo	= '000003', 
			Err_Mensaj	= 'El Banco no existe', 
			Err_Variab	= 'Pla_Banco'
	rollback 
	return 1
end 

select	@Pla_Numero = max(Pla_Numero) 
	from SOPLAEXT noholdlock
	where	Pla_Banco	= @Pla_Banco

if isnull(@Pla_Numero, @Str_Vacio) = @Str_Vacio
	select	@Pla_Numero	= '000'
	
select	@Consec     = convert(int, @Pla_Numero) + 1
select	@Pla_Numero = right('000' + ltrim(rtrim(convert(char, @Consec))), 3)

insert into SOPLAEXT values(
	@Pla_Banco,		@Pla_Numero,	@Pla_Descri,	@Pla_Ubicac,	@Pla_Contac,	
	@Pla_NumTel,	@Pla_Fax,		@NumTransac,	@Transaccio,	@Usuario,		
	@FechaSis,		@SucOrigen,		@SucDestino)

select 	Err_Codigo  = '000000', 
		Err_Mensaj	= 'Registro Agregado'

