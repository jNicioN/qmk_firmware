create procedure SOPLACECBAJ (
	@Plc_Numero char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

if not exists (select	Plc_Numero
				from SOPLACEC noholdlock
				where	Plc_Numero	= @Plc_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La plaza no existe',
			Err_Variab 	= 'Plc_Numero'
	rollback
	return 1
end

delete from SOPLACEC
	where	Plc_Numero	= @Plc_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Borrado'

