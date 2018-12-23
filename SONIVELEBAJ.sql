create procedure SONIVELEBAJ	(
	@Niv_Numero	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Tab_Nombre = 'SONIVELE'	/* Nombre de la Tabla */

if not exists (select	Niv_Numero
				from SONIVELE noholdlock
				where	Niv_Numero	= @Niv_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El nivel no existe',
			Err_Variab	= 'Niv_Numero',
			Err_Foco	= 'txtNiv_Numero'
	rollback
	return 1

end else if exists (select	Usu_Numero
						from SOUSUARI noholdlock
						where	Usu_Nivel	= @Niv_Numero) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El nivel existe en usuarios',
			Err_Variab	= 'Niv_Numero',
			Err_Foco	= 'txtNiv_Numero'
	rollback
	return 1
	
end else begin
	
	delete from SONIVELE
		where	Niv_Numero	= @Niv_Numero

	delete from SYFORNIV
		where	Fni_Nivel	= @Niv_Numero
	
	exec SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Borrado'

end
