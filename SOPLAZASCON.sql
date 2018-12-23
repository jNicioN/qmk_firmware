create procedure SOPLAZASCON (
	@Pla_Numero char(3),
	@Pla_Nombre varchar(70),
	
	@NumTransac char(10), 
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

if (@Pla_Numero = '') and (@Pla_Nombre = '')
	select	Pla_Numero,	Pla_Nombre,	Pla_Abrevi,	Pla_CenPro, Pla_PlaCec,
			Pla_Clabe,	Pla_ClaMin
		from SOPLAZAS noholdlock
		order by Pla_Nombre
else if (@Pla_Nombre = '')
	select	Pla_Numero,	Pla_Nombre,	Pla_Abrevi,	Pla_CenPro, Pla_PlaCec,
			Pla_Clabe,	Pla_ClaMin
		from SOPLAZAS noholdlock
		where	Pla_Numero	= @Pla_Numero
else begin
	select	@Pla_Nombre	= ltrim(rtrim(@Pla_Nombre)) + '%'
	
	select	Pla_Numero,	Pla_Nombre, Pla_PlaCec, Pla_Clabe,	Pla_ClaMin
		from SOPLAZAS noholdlock
		where	Pla_Nombre	like @Pla_Nombre
		order by Pla_Nombre
end
