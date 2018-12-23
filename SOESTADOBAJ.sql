create procedure SOESTADOBAJ	(
	@Est_Numero	char(2),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8)
select	@Tab_Nombre = 'SOESTADO'

if not exists ( select Est_Numero
				from SOESTADO
				where Est_Numero = @Est_Numero) begin
	select Err_Codigo = '000001', Err_Mensaj = 'Estado no existe'
	rollback
	return 1
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Borrado'
	delete from SOESTADO 
		where Est_Numero = @Est_Numero
	
	exec SYTABLOCACT	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,
						@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
end
