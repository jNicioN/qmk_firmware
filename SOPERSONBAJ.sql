create procedure SOPERSONBAJ (
	@Per_Numero	char(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if @Per_Numero <> ''
	if exists (select	Per_Numero
					from SOPERSON
					where	Per_Numero	= @Per_Numero) begin
		delete SOPERSON
			where	Per_Numero	= @Per_Numero
		
		update SOFOLIOS set
			Fol_Numero	= Fol_Numero - 1
			where	Fol_Tabla	= 'SOPERSON'
		
		if exists ( select	Pes_Person
						from SOPEESPU noholdlock
						where	Pes_Person	= @Per_Numero ) 
			delete SOPEESPU
				where	Pes_Person	= @Per_Numero
	end

	

