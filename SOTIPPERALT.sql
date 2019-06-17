create procedure SOTIPPERALT (
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

if @Tpe_Descri = '' begin
	select	Err_Codigo	= '000001',	
			Err_Mensaj	= 'Descripcion incorrecta',
			Err_Variab	= 'Tpe_Descri'
	rollback
end else begin
	insert into SOTIPPER values (
		@Tpe_Numero,	@Tpe_Descri,	@Tpe_Abrevi,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino	)
		
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Agregado',	
			TPe_Numero	= @Tpe_Numero
end
