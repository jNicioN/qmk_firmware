create procedure SODEPARTMOD (
	@Dep_Numero	char(3),
	@Dep_Nombre	varchar(40),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Str_Vacio	char(1)			/* Declaracion de Constantes */

/* Asignacion de Constantes */
select	@Str_Vacio	= ''			/* String Vacio */

if isnull(@Dep_Nombre, @Str_Vacio) = @Str_Vacio begin
	select 	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Nombre del Departamento no puede ser vacio',
			Err_Variab	= 'Dep_Nombre'
	rollback
	return 1
end

update SODEPART set
	Dep_Nombre	= @Dep_Nombre
	where	Dep_Numero	= @Dep_Numero

if @@nestlevel = 1
	select	Err_Codigo 	= '000000',
			Err_Mensaj 	= 'Registro Modificado'
