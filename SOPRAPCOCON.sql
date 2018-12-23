create procedure SOPRAPCOCON (
	@Pre_Prefij	char(20),
	@Existencia	int output,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare @Pre_Existe varchar(20)

/*Remover % que viene de SOPERSONCON*/

	
select @Pre_Existe	= Pre_Prefij
			from SOPRAPCO noholdlock
			where	Pre_Prefij	like @Pre_Prefij

select @Pre_Existe	= isnull(@Pre_Existe, '')

if @Pre_Existe <> ''
	select	@Existencia	= 1
	
if @@nestlevel = 1
	select Existencia = @Existencia
