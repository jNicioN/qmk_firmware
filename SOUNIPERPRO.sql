create procedure SOUNIPERPRO (
	@Peu_Person	char(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************
** DESCRIPCION: Unifica la persona o crea su nuevo grupo		  **
********************************************************************
** REFERENCIAS: 												  **
********************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz					****
** Fecha:		28/Mayo/2019									****
** Help:		1214398											****
** Descripcion:	Se considera la asignacion de la persona del 	****
**				Cliente Unico en caso de existir.				****
********************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz					****
** Fecha:		22/Sep/17										****
** Help:		1020500											****
** Descripcion:	Se agrega la actualizacion de unificación    	****
**              grupos.											****
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		19/Mar/15										****
** Help:		0744849											****
** Descripcion:	Se Valida por RFC Corto y Nombre				****
********************************************************************
** Creo:		Claudia V Sandoval P							****
** Fecha:		11-Mar-2014										****
** Help:		00599444										****
*******************************************************************/
/*Declaración constantes*/
declare	@Str_Vacios	char(1),
		@Rfc_Moral  int,
		@RFC_Fisic  int

/*Declaración variables*/
declare	@Per_RFC	varchar(15),
		@Per_Comple	varchar(180),
		@Peu_Grupo	char(8),
		@Per_Grupo  char(8),
		@Ent_Cero	int,
		@Status		int,
		@Peu_CliUni char(8)
		
select	@Str_Vacios	= '',			-- String Vacio
		@Rfc_Moral	= 12,			-- Longitud Persona Moral
		@RFC_Fisic	= 13,			-- Longitud Persona Fisica
		@Ent_Cero	= 0				-- Entero en Cero

select	@Per_Grupo	= isnull(Peu_Grupo,	@Str_Vacios)
	from SOUNIPER noholdlock 
	where  Peu_Person	= @Peu_Person

select	@Per_RFC	= Per_RFC,
		@Per_Comple	= Per_Comple
	from SOPERSON noholdlock
	where	 Per_Numero	= @Peu_Person

if char_length(ltrim(rtrim(@Per_RFC))) = @Rfc_Moral or char_length(ltrim(rtrim(@Per_RFC))) = @RFC_Fisic
	select	@Peu_Grupo	= min(Peu_Grupo)
		from SOUNIPER (index SOUNIPERPER) noholdlock
			where Peu_Person	in (select	Per_Numero
										from SOPERSON noholdlock 
										where	Per_RFC		= @Per_RFC) /* RFC Completo */
else
	select	@Peu_Grupo	= min(Peu_Grupo)
		from SOUNIPER (index SOUNIPERPER) noholdlock
			where Peu_Person	in (select	Per_Numero
										from SOPERSON noholdlock 
										where	Per_Comple	= @Per_Comple
										  and	Per_RFC		like @Per_RFC) /* RFC Corto y Nombre */
										  
										  
select @Peu_CliUni = AdiUni.Adi_NumPer
  from SOUNIPER as UniOuter noholdlock 
 inner join CLADICIO as AicionalOuter noholdlock on UniOuter.Peu_Person = AicionalOuter.Adi_NumPer
 inner join CLCLIUNI as CliOuter noholdlock on CliOuter.Clu_Client = AicionalOuter.Adi_Client
 inner join CLADICIO as AdiUni   noholdlock on CliOuter.Clu_Grupo = AdiUni.Adi_Client
 where AicionalOuter.Adi_NumPer = @Peu_Grupo
 group by AdiUni.Adi_NumPer
  
/*Si encuentra un número de persona dado al cliente unico entonces se asigna*/
if isnull(@Peu_CliUni, @Str_Vacios) <> @Str_Vacios begin
	select @Peu_Grupo = @Peu_CliUni
end
	
if ltrim(@Per_Grupo) <> ltrim(@Str_Vacios) begin							/* Actualizar grupo*/
	if @Per_Grupo <> @Peu_Grupo and isnull(ltrim(@Peu_Grupo), @Str_Vacios) <> @Str_Vacios begin 
	    update SOUNIPER set
		       Peu_Grupo  = @Peu_Grupo,
			   
			   NumTransac  = @NumTransac,
			   Transaccio  = @Transaccio,
			   Usuario	   = @Usuario,
			   FechaSis	   = @FechaSis,
			   SucOrigen   = @SucOrigen,
			   SucDestino  = @SucDestino
		 where Peu_Person  = @Peu_Person
	end 
end else begin																/* Alta de grupo*/
	if isnull(ltrim(@Peu_Grupo), @Str_Vacios) = @Str_Vacios
		select	@Peu_Grupo = @Peu_Person

		exec @Status =  SOUNIPERALT
			@Peu_Grupo,	@Peu_Person,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,	@SucOrigen,		@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
		return 1
	end
end