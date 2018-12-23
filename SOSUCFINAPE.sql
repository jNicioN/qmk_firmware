create procedure SOSUCFINAPE (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

update SOSUCURS set Suc_Apertu = 'N'
	where Suc_Numero = @SucOrigen
	
select Err_Codigo = '000000', Err_Mensaj = 'Apertura Finalizada'

