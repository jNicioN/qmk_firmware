create procedure SODEPARTALT (
	@Dep_Nombre	varchar(40),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Dep_Numero	char(3)			/* Declaracion de Variables */

declare	@Str_Vacio	char(1),		/* Declaracion de Constantes */
		@Sta_Activo	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/* String Vacio */
		@Sta_Activo	= 'A'			/* Status de Activo */

if isnull(@Dep_Nombre, @Str_Vacio) = @Str_Vacio begin
	select 	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Nombre del Departamento no puede ser vacio',
			Err_Variab	= 'Dep_Nombre'
	rollback
	return 1
end

/* Obtenemos El Numero Consecutivo de Departamentos */
select	@Dep_Numero	= max(Dep_Numero)
	from SODEPART noholdlock

select	@Dep_Numero	= convert(char(3), isnull(convert(int, @Dep_Numero), 0) + 1)

exec UTCERIZQ
	@Valor		= @Dep_Numero output,
	@Longitud	= 3

insert into SODEPART values (
	@Dep_Numero,	@Dep_Nombre,	@Sta_Activo,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado',
			Err_Numero	= @Dep_Numero
