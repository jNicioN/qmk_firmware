create procedure SOREPRESBAJ (
	@Rep_Cuenta	char(15),
	@Rep_Tipo	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

if @Rep_Cuenta <> '' and @Rep_Tipo <> '' begin
	if exists (Select Rep_Cuenta from SOREPRES
					where	Rep_Cuenta 	= @Rep_Cuenta
						and Rep_Tipo	= @Rep_Tipo)
		Delete	SOREPRES
			where	Rep_Cuenta 	= @Rep_Cuenta
				and Rep_Tipo	= @Rep_Tipo
end
