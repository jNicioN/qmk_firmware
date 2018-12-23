create procedure SOUSUARIBAJ	(
	@Usu_Numero	char(6),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8),
		@Status 	int

select	@Tab_Nombre = 'SOUSUARI'

if  exists (select Usu_Numero 
				from SOUSUARI 
				where ltrim(rtrim(Usu_Numero)) = ltrim(rtrim(@Usu_Numero)))	begin
	delete from SOUSUARI
		where Usu_Numero = @Usu_Numero

	execute @Status = SYTABLOCACT	
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,		
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end
	select 	Err_Codigo = '000000', 
			Err_Mensaj = 'El usuario fue dado de baja' 

end else begin
	select 	Err_Codigo = '000001', 
			Err_Mensaj = 'El usuario no existe', 
			Err_Variab = 'xUsu_Clave',
			Err_Foco   = 'txtUsu_Numero'
	rollback
	return 1
end
