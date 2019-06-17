create procedure SOCATTRABAJ (
	@Tra_Numero int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
DELETE FROM SOCATTRA WHERE Tra_Numero=@Tra_Numero

