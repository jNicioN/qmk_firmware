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
	@Dip_Colonia varchar(255),
	@Tipo_Registro varchar(255),
	@Cli_Numero char(8),


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
** Modifico:	Aldo Ignacio Teoba Sanchez				****
** Fecha:		22-08-2023								****
** Help:		1621179									****
** Descripcion: Se agregan validaciones para carga 		****
** 				manual									****
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
declare	@Val_Existe	int,
		@Val_Cp CHAR(6),
		@Val_PersonId INT,
		@Val_ClientId INT
/*	Declaración de Constantes	*/
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Dip_Status	char(1),
		@Tim_Vigenc int,
		@Tip_Vigenc char(2),
		@Tip_Registro varchar(255)

/* Asignación de constantes */
select @Str_Vacio	= '', /* String vacío */
	@Ent_Cero	= 0, /* Entero en cero */
	@Ent_Uno	= 1, /* Entero en uno */
	@Tim_Vigenc = 12, /* Cantidad de meses de vigencia*/
	@Tip_Vigenc = 'mm', /* Tipo de tiempo para aumentar la fecha de Viegencia (meses)*/
	@Dip_Status = 'A',
	@Tip_Registro = 'MANUAL'




if @Dip_TipDir = @Ent_Cero begin
	select Err_Codigo	= '000003',
		Err_Mensaj	= 'Error con el parámetro: @Dip_TipDir.',
		Err_Variab	= '@Dip_TipDir'
	rollback
	return @Ent_Uno
end

/*Carga Manual*/
IF @Tipo_Registro = @Tip_Registro BEGIN
	SELECT @Val_Cp = (SELECT Cpc_Numero
		FROM CLCODPOS noholdlock
		WHERE Cpc_CodPos = @Dip_NumCP
			AND Cpc_Nombre = @Dip_Colonia)
	IF @Val_Cp = NULL BEGIN
		SELECT Err_Codigo = '000008',
			Err_Mensaj = 'El parámetro @Dip_NumCP no es valido.',
			Err_Variab = '@Dip_NumCP'
		ROLLBACK
		RETURN @Ent_Uno
	end

	SELECT @Val_PersonId =
	(SELECT P.PerPersoID
		FROM CLCLIENT C noholdlock
			INNER JOIN CLADICIO CA noholdlock  ON C.ClClientID = CA.ClClientID
			INNER JOIN SOPERSON P noholdlock  ON CA.Adi_NumPer = P.Per_Numero
		WHERE C.Cli_Numero = @Cli_Numero)

	IF @Val_PersonId = NULL BEGIN
		SELECT Err_Codigo = '000008',
			Err_Mensaj = 'El parámetro @Cli_Numero no es valido.',
			Err_Variab = '@Cli_Numero'
		ROLLBACK
		RETURN @Ent_Uno
	end

	SELECT @Val_ClientId =
	(SELECT C.ClClientID
		FROM CLCLIENT C noholdlock
		WHERE C.Cli_Numero = @Cli_Numero)

	IF @Val_ClientId = NULL BEGIN
		SELECT Err_Codigo = '000008',
			Err_Mensaj = 'El parámetro @Cli_Numero no es valido.',
			Err_Variab = '@Cli_Numero'
		ROLLBACK
		RETURN @Ent_Uno
	end

	insert into SODIRPER
		(PerPersoID, Dip_TipDir, ClClientID, Dip_Calle, Dip_NumExt,
		Dip_NumInt, Dip_NumCP, Dip_EntCa1, Dip_EntCa2, Dip_Refere,
		Dip_Status, NumTransac, Transaccio, Usuario, FechaSis,
		SucOrigen, SucDestino)
	values(
			@Val_PersonId, @Dip_TipDir, @Val_ClientId, @Dip_Calle, @Dip_NumExt,
			@Dip_NumInt, @Val_Cp, @Dip_EntCa1, @Dip_EntCa2, @Dip_Refere,
			@Dip_Status, @NumTransac, @Transaccio, @Usuario, @FechaSis,
			@SucOrigen, @SucDestino)
	return @Ent_Uno
end 
ELSE BEGIN
	/* Validaciones */
	if @PerPersoID = @Ent_Cero and @ClClientID = @Ent_Cero begin

		select Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersonID o @ClClientID .',
			Err_Variab	= '@PerPersonID'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Dip_NumCP, @Str_Vacio) = @Str_Vacio begin
		select Err_Codigo	= '000007',
			Err_Mensaj	= 'El parámetro @Dip_NumCP no puede ir vacio.',
			Err_Variab	= '@Dip_NumCP'
		rollback
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
	return @Ent_Uno
end