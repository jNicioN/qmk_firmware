create procedure SORELESTBAJ (
	@Rel_Numero char(8),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

delete SORELEST
	where 	Rel_Numero 	= @Rel_Numero

select 	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Modificado'
