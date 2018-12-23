create procedure SOPEESPUALT (
	@Pes_Person	char(8),
	@Pes_EscPub	char(4),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if exists ( select	Pes_Person
				from SOPEESPU noholdlock
				where	Pes_Person	= @Pes_Person
				  and	Pes_EscPub	= @Pes_EscPub ) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La relación persona - escritura ya existe',
			Err_Variab	= 'Esc_Numero'
	rollback
	return 1
end

if not exists ( select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Pes_Person	) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La persona no existe',
			Err_Variab	= 'Esc_Numero'
	rollback
	return 1					
end

if not exists ( select	Esc_Numero
					from CLESCPUB noholdlock
					where	Esc_Numero	= @Pes_EscPub	) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La escritura pública no ha sido capturada',
			Err_Variab	= 'Esc_Numero'
	rollback
	return 1
end

insert into SOPEESPU values	(
	@Pes_Person,	@Pes_EscPub,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino	)
	
