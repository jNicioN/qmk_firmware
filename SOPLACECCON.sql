create procedure SOPLACECCON (
	@Plc_Numero char(2),
	@Plc_Nombre	varchar(35),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Str_Vacio	char(1)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Str_Vacio	= ''


if @Plc_Numero = @Str_Vacio and @Plc_Nombre = @Str_Vacio begin	
	select	Plc_Numero,	Plc_Nombre
		from SOPLACEC noholdlock
			order by Plc_Nombre
end else begin
	if @Plc_Nombre = @Str_Vacio begin 
		select	Plc_Numero,		Plc_Nombre
				from SOPLACEC noholdlock
				where	Plc_Numero	= @Plc_Numero
	end else begin
		select	@Plc_Nombre	= ltrim(rtrim(@Plc_Nombre)) + '%' 
	
		select	Plc_Numero, Plc_Nombre
			from SOPLACEC noholdlock
			where	Plc_Nombre	like @Plc_Nombre
			order by Plc_Nombre
	end
end
