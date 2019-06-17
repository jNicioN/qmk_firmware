create procedure SOPLAEXTCON (
	@Pla_Banco	char(4),
	@Pla_Numero char(3),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

	if @Pla_Numero = '' 
		select 	Pla_Banco,	Pla_Numero,	Pla_Descri,	Pla_Ubicac,	Pla_Contac,
				Pla_NumTel,	Pla_Fax
			from SOPLAEXT
			where Pla_Banco = @Pla_Banco		
	else
		select 	Pla_Banco,	Pla_Numero,	Pla_Descri,	Pla_Ubicac,	Pla_Contac,
				Pla_NumTel,	Pla_Fax
			from SOPLAEXT
			where 	Pla_Banco  = @Pla_Banco
			and 	Pla_Numero = @Pla_Numero
	
