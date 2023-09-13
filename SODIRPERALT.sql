create procedure SODIRPERALT
	(
	@PerPersoID int,
	@Dip_TipDir	int,
	@ClClientID	int,
	@Dip_Calle	char(40),
	@Dip_NumExt	char(10),
	@Dip_NumInt	char(10),
	@Dip_NumCP	char(6),
	@Dip_EntCa1	varchar(255),
	@Dip_EntCa2	varchar(255),
	@Dip_Refere	varchar(255),


	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***********************************************************
** Descripción:	 Alta de Dirección Persona				****
************************************************************
** Modifico:	Aldo Teoba							****
** Fecha:		29-08-2023								****
** Help:		31604									****
** Descripcion: se regresa 0 cuando                     ****
**              cumple la validacion			        ****
************************************************************
** Modifico:	Adriana Gomez							****
** Fecha:		06-05-2022								****
** Help:		1621179									****
** Descripcion: validacion de cliente y persona			****
************************************************************
** Modifico:	Jonathan Nicio							****
** Fecha:		14-09-2020								****
** Help:		1399388									****
************************************************************
** Modifico:	Norma Tijerina							****
** Fecha:		04-05-2017								****
** Help:		00946339								****
************************************************************
** Creó:		Roberto Saldivar						****
** Fecha:		17-03-2017								****
** Help:		00909908								****
************************************************************/

/*	Declaración de Variables	*/
declare	@Val_Existe	int

/*	Declaración de Constantes	*/
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Dip_Status	char(1),
		@Tim_Vigenc int,
		@Tip_Vigenc char(2)

/* Asignación de constantes */
select @Str_Vacio	= '', /* String vacío */
	@Ent_Cero	= 0, /* Entero en cero */
	@Ent_Uno	= 1, /* Entero en uno */
	@Tim_Vigenc = 12, /* Cantidad de meses de vigencia*/
	@Tip_Vigenc = 'mm', /* Tipo de tiempo para aumentar la fecha de Viegencia (meses)*/
	@Dip_Status = 'A'





	/* Validaciones */
if @PerPersoID = @Ent_Cero and @ClClientID = @Ent_Cero begin

select Err_Codigo	= '000001',
	Err_Mensaj	= 'Error con el parámetro: @PerPersonID o @ClClientID .',
	Err_Variab	= '@PerPersonID'
	rollback
	return @Ent_Uno
end
if @Dip_TipDir = @Ent_Cero begin
	select Err_Codigo	= '000003',
		Err_Mensaj	= 'Error con el parámetro: @Dip_TipDir.',
		Err_Variab	= '@Dip_TipDir'
	rollback
	return @Ent_Uno
end
	
if isnull(@Dip_NumCP, @Str_Vacio) = @Str_Vacio begin
	select Err_Codigo	= '000007',
		Err_Mensaj	= 'El parámetro @Dip_NumCP no puede ir vacio.',
		Err_Variab	= '@Dip_NumCP'
	rollback
	return @Ent_Uno
end else begin
	select @Val_Existe = @Ent_Cero
	select @Val_Existe = count(Cpc_Numero)
	from CLCODPOS noholdlock
	where	Cpc_Numero	= @Dip_NumCP
	if @Val_Existe <= @Ent_Cero begin
		select Err_Codigo	= '000008',
			Err_Mensaj	= 'El parámetro @Dip_NumCP no es valido.',
			Err_Variab	= '@Dip_NumCP'
		rollback
		return @Ent_Uno
	end
end
	/* Alta de Descripción */
	insert into SODIRPER
		(
		PerPersoID, Dip_TipDir, ClClientID, Dip_Calle, Dip_NumExt,
		Dip_NumInt, Dip_NumCP, Dip_EntCa1, Dip_EntCa2, Dip_Refere,
		Dip_Status, NumTransac, Transaccio, Usuario, FechaSis,
		SucOrigen, SucDestino)
	values(
			@PerPersoID, @Dip_TipDir, @ClClientID, @Dip_Calle, @Dip_NumExt,
			@Dip_NumInt, @Dip_NumCP, @Dip_EntCa1, @Dip_EntCa2, @Dip_Refere,
			@Dip_Status, @NumTransac, @Transaccio, @Usuario, @FechaSis,
			@SucOrigen, @SucDestino)

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
    	Err_Mensaj	= 'Registro realizado'