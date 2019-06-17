create procedure SOREPBANCON (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

select Rep_Nombre, Rep_ApePat, Rep_ApeMat
    from SOREPRES
    where Rep_Tipo = '01'

