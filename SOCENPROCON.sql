create procedure SOCENPROCON (
	@Cen_Numero char(3),
	@Cen_Nombre	varchar(70),
	@Cen_Plaza	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Str_Vacio	char(1)			/* Declaración de Constantes */

/* Asignacion de Constantes */
select	@Str_Vacio	= ''


if @Cen_Numero = @Str_Vacio and @Cen_Nombre = @Str_Vacio and @Cen_Plaza = @Str_Vacio
	select	Cen_Numero,		Cen_Nombre,		Cen_Plaza
		from SOCENPRO noholdlock
		order by Cen_Nombre
else if @Cen_Numero = @Str_Vacio and @Cen_Plaza = @Str_Vacio 
	select	Cen_Numero,		Cen_Nombre,		Cen_Plaza
		from SOCENPRO noholdlock
		where	Cen_Nombre like @Cen_Nombre+'%'
		order by Cen_Nombre
	else if @Cen_Numero = @Str_Vacio
		select	Cen_Numero,		Cen_Nombre,		Cen_Plaza
			from SOCENPRO noholdlock
			where	Cen_Plaza = @Cen_Plaza
	else 
		select	Cen_Numero,		Cen_Nombre,		Cen_Plaza
			from SOCENPRO noholdlock
			where	Cen_Numero = @Cen_Numero


