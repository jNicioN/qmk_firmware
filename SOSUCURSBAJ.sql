create procedure SOSUCURSBAJ(
	@Suc_Numero	char(3),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tip_Sucurs char(1),
		@Tab_Nombre char(8)

									/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacío */
		@Tip_Sucurs = 'B',			/* Tipo de Alta de Sucursal para las leyendas */
		@Tab_Nombre = 'SOSUCURS'


if not exists (	select Suc_Numero
				from SOSUCURS
				where Suc_Numero = @Suc_Numero) begin
	select Err_Codigo = '000001', Err_Mensaj = 'La sucursal no existe', Err_Variab = 'Suc_Numero'
	rollback
	return 1
end else if exists (select Cli_Numero
					from CLCLIENT
					where Cli_Sucurs = @Suc_Numero) begin
	select Err_Codigo = '000002', Err_Mensaj = 'La sucursal tiene clientes', Err_Variab = 'Suc_Numero'
	rollback
	return 1
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Borrado'
	delete SOSUCURS 
		where Suc_Numero = @Suc_Numero
	
	exec CHLEESCUBAJ	@Str_Vacio,		@Suc_Numero,	@Str_Vacio,		@Str_Vacio,		@Tip_Sucurs,
						@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
						@SucDestino,	@Modulo

	exec SYTABLOCACT	@Tab_Nombre,	@NumTransac,	@Transaccio,
						@Usuario,		@FechaSis,		@SucOrigen,
						@SucDestino,	@Modulo		

end

