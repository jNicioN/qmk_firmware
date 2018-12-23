create procedure SOCIULOCBAJ (
	@Cil_Numero	char(3),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

delete from SOCIULOC
	where	Cil_Numero	= @Cil_Numero
