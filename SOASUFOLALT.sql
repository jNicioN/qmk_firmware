create procedure SOASUFOLALT (
	@Sap_FecApe	smalldatetime,
	@Sap_Consec	int output,


	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Fas_Numero	int,		/* Declaracion de Variables */
		@Numero		char(10),
		@fecha	smalldatetime

declare @Ent_Vacio 	int			/* Declaracion de Constantes */			

/* Asignacion de Constantes */
select	@Ent_Vacio 	= 0

select 	@FechaSis 	= getdate()


select @fecha =(convert(char, @Sap_FecApe, 101))

select @Fas_Numero	= max (Sap_NumApe) 
	from SOSUCAPE noholdlock 	
		where Sap_FecApe=@fecha

if isnull(@Fas_Numero, @Ent_Vacio) = @Ent_Vacio begin
	select	@Fas_Numero = 1


end else
	
	select	@Fas_Numero	= @Fas_Numero + 1 
		

select @Numero	= convert(char, @Fas_Numero)

execute UTCERIZQ
		@Numero output, 10
		
select 	@Sap_Consec	= @Fas_Numero
select	Mov_Numero	= @Numero,
		Mov_NumInt 	= @Fas_Numero
	

