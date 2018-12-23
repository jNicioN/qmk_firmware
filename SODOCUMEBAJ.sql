create procedure SODOCUMEBAJ (
	@Doc_Cuenta	char(15),
	@Doc_Tipo	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

if @Doc_Cuenta <> '' and @Doc_Tipo <> '' begin
	if exists (Select Doc_Cuenta from SODOCUME
					where	Doc_Cuenta 	= @Doc_Cuenta
						and Doc_Tipo	= @Doc_Tipo)
		Delete	SODOCUME
			where	Doc_Cuenta 	= @Doc_Cuenta
				and Doc_Tipo	= @Doc_Tipo
end
