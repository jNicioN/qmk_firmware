create procedure SONIVELEMOD	(
	@Niv_Numero	char(2),
	@Niv_Descri	varchar(30),
	@Niv_Acceso	char(1),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8)
select	@Tab_Nombre = 'SONIVELE'

if not exists (select	Niv_Numero
					from SONIVELE noholdlock
					where	Niv_Numero	= @Niv_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Nivel no existe',
			Err_Variab	= 'Niv_Numero',
			Err_Foco	= 'txtNiv_Numero'
	rollback
	return 1
end else if @Niv_Descri = '' begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripción incorrecta',
			Err_Variab	= 'Niv_Descri',
			Err_Foco	= 'txtNiv_Descri'
	rollback
	return 1
end else if (@Niv_Acceso <> 'S' and @Niv_Acceso <> 'N') begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Acceso Incorrecto',
			Err_Variab	= 'vNiv_Acceso',
			Err_Foco	= 'txtNiv_Acceso'
	rollback
	return 1
end else begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Modificado'
	
	update SONIVELE set
		Niv_Descri	= @Niv_Descri,
		Niv_Acceso	= @Niv_Acceso
		where	Niv_Numero	= @Niv_Numero
	
	exec SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
end
