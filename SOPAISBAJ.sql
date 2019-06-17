create procedure SOPAISBAJ   (
	@Pai_Numero	char(3),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre char(8)

select	@Tab_Nombre = 'SOPAIS'

if not exists (	select	Pai_Numero
					from SOPAIS
					where Pai_Numero = @Pai_Numero) begin
	select	Err_Codigo = '000001', 
			Err_Mensaj = 'El pais <NO> existe',
			Err_Variab = 'Pai_Numero'
	rollback
	return 1
	
end else if exists (select	Ent_Numero
						from CLENTIDA
						where Ent_Pais = @Pai_Numero) begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'El pais existe en estados',
			Err_Variab = 'Pai_Numero'
	rollback
	return 1
	
end else if exists (select	Cli_Numero
						from CLCLIENT
						where Cli_Pais = @Pai_Numero) begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'El pais existe en clientes',
			Err_Variab = 'Pai_numero'
	rollback
	return 1
	
end else begin

	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado'

	delete from SOPAIS 
		where (Pai_Numero = @Pai_Numero)
	
	exec SYTABLOCACT	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
						@SucOrigen,		@SucDestino,	@Modulo
		
end
