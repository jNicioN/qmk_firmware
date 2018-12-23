create procedure SOUSUPANALT	(
	@Usu_Nombre	varchar(50),
	@Usu_Pantal	varchar(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre	char(8),			/* Declaración de Constantes */
		@Str_Vacio	char(1)

/* Asignación de Constantes */
select	@Tab_Nombre = 'SOUSUPAN',		/* Nombre de la tabla */
		@Str_Vacio	= ''				/* String Vacio */

if @Usu_Nombre = @Str_Vacio begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Nombre de usuario incorrecto', 
			Err_Variab	= 'Usu_Nombre'
	rollback
	return 1
end 


if not exists(select	Pan_Nombre 
				from SYPANTAL noholdlock 
				where	Pan_Nombre	= @Usu_Pantal) begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'Pantalla no existe en el catalogo', 
			Err_Variab	= 'Usu_Pantal'
	rollback
	return 1
end

if exists(select	Usu_Nombre
				from SOUSUPAN noholdlock 
				where	Usu_Nombre	= @Usu_Nombre
				  and	Usu_Pantal	= @Usu_Pantal) begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'El usuario ya existe para el acceso', 
			Err_Variab	= 'Usu_Nombre'
	rollback
	return 1
end

insert into SOUSUPAN values (
	@Usu_Nombre,	@Str_Vacio,	@Usu_Pantal,	@NumTransac,	@Transaccio,	
	@Usuario,		@FechaSis,	@SucOrigen,		@SucDestino)

exec SYTABLOCACT	
	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,		
	@SucOrigen,		@SucDestino,	@Modulo

select	Err_Codigo	= '000001', 
		Err_Mensaj	= 'Registro agregado', 
		Err_Variab	= ''
