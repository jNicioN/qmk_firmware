create procedure SOPEESPUACT (
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

declare @Status	int 

if exists ( select	Pes_Person
				from SOPEESPU noholdlock
				where	Pes_Person	= @Pes_Person
				  and	Pes_EscPub	= @Pes_EscPub )
	select	@Status = 0
else
	exec @Status = SOPEESPUALT
		@Pes_Person,	@Pes_EscPub,	@NumTransac,	@Transaccio,		@Usuario,		
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

if @Status <> 0 begin
	select	Err_Codigo	= '000015',
			Err_Mensaj 	= 'Error al actualizar',
			Err_Variab 	= 'Esc_Numero'
	rollback	
	return 1
end	

