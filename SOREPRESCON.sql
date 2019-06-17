create procedure SOREPRESCON (
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

	Select	Rep_Cuenta, Rep_NumApo, Rep_Numero, Rep_Tipo, Rep_Nombre,
		  	Rep_ApePat,	Rep_ApeMat
			from SOREPRES (index SOREPRES)
				where	Rep_Cuenta 	= @Rep_Cuenta
					and Rep_Tipo 	= @Rep_Tipo
					
