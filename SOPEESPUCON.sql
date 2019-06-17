create procedure SOPEESPUCON (
	@Pes_Person	char(8),
	@Pes_EscPub	char(4),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),				/*	Declaración de variables	*/
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/* 'C':  Consulta */
	if @Tip_ConCon = '1' 				/* Consulta General */	
		select	Pes_Person,	Pes_EscPub,	Esc_Numero,	Esc_Tipo,	Esc_NumPub
			from SOPEESPU noholdlock,
				 CLESCPUB noholdlock
			where	Esc_Numero	= Pes_EscPub
			  and	Pes_Person	= @Pes_Person

	if @Tip_ConCon = '2' begin				/* Consulta General */			
		select	Pes_Person,	Pes_EscPub,	Esc_Numero,	Esc_Tipo,	Esc_NumPub
			from SOPEESPU noholdlock,
				 CLESCPUB noholdlock
			where	Pes_EscPub	= Esc_Numero
			  and	Pes_EscPub	= @Pes_EscPub
			order by Pes_EscPub, Pes_Person
	end

end else begin								/* 'L':  Lista */	
	if @Tip_ConCon = '1' begin				/* Lista General */
		select	Pes_Person,	Pes_EscPub
			from SOPEESPU noholdlock
	end
end



