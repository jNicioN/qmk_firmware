create procedure SOPEESPUBAJ (
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

declare	@Str_Vacio	char(1)			/*	Declaración de constantes	*/

/*	Asignación de constantes	*/
select	@Str_Vacio	= ''			/*	String Vacio	*/

if @Pes_Person <> @Str_Vacio
	delete SOPEESPU
		where	Pes_Person	= @Pes_Person
		  and	Pes_EscPub	= @Pes_EscPub
else
	delete SOPEESPU
		where	Pes_EscPub	= @Pes_EscPub
		
