create procedure SOPERADIBAJ (
	@Adi_PerNum	char(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if not exists ( select Adi_PerNum
				from SOPERADI noholdlock
				where Adi_PerNum = @Adi_PerNum) begin
	select 	Err_Codigo	= '000001', 
			Err_Mensaj	= 'La persona no existe' 
	rollback
	return 1
end

delete from SOPERADI
	where Adi_PerNum= @Adi_PerNum

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Borrado'

