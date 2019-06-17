create procedure SOULHESPALT (
	@Uhs_Fecha	smalldatetime,
	@Uhs_Moneda	char(2),
	@Uhs_Valor	double precision,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

insert into SOULHESP values (
	@Uhs_Fecha,	@Uhs_Moneda,	@Uhs_Valor)
