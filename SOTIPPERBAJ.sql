create procedure SOTIPPERBAJ (
	@Tpe_Numero	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if not exists (	select	Tpe_Numero
					from SOTIPPER noholdlock
					where Tpe_Numero	= @Tpe_Numero ) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Tipo de apoderado no existe',
			Err_Variab	= 'Tpe_Numero'
	rollback
	return 1
	
end else begin

	delete from SOTIPPER
		where	Tpe_Numero 	= @Tpe_Numero
		
	select 	Err_Codigo	= '000000',
			Err_Mensaj = 'Registro Borrado'
end
