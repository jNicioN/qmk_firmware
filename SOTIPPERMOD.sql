create procedure SOTIPPERMOD (
	@Tpe_Numero	char(2),
	@Tpe_Descri varchar(30),
	@Tpe_Abrevi	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if not exists (	select	Tpe_Numero
					from SOTIPPER
					where	Tpe_Numero	= @Tpe_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Tipo de apoderado no existe',
			Err_Variab	= 'Tpe_Numero'
	rollback
	return 1
end else if @Tpe_Descri = '' begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripcion incorrecta',
			Err_Variab	= 'Tpe_Descri'
	rollback
	return 1
end else begin

	update SOTIPPER set
		Tpe_Descri	= @Tpe_Descri 
		where Tpe_Numero	= @Tpe_Numero
		
	select	Err_Codigo	= '000000',
			Err_Mensaj 	= 'Registro Modificado'
end
