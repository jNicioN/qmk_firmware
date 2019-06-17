create procedure SOPERRELACT (
	@Per_Numero	char(8),
	@Per_Tipo	char(1),
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_RazSoc	varchar(180),
	@Per_RFC	char(15),
	@Per_Calle	char(40),
	@Per_CalNum	varchar(10),
	@Per_Coloni	varchar(150),
	@Per_Entida	char(3),
	@Per_Locali	char(8),
	@Per_CodPos	char(6),
	@Per_Telefo char(15),
	@Per_ActEmp char(1),
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))

as

/********************************************************************************/
/*	DESCRIPCION: ** Actualiza datos de persona, agregada desde Relacionados **	*/
/********************************************************************************/
/**	REFERENCIAS:
****************************************************************************
**							STORE CONVERTIDO							****
****************************************************************************
** Modificación:	David Alejandro Cantu Treviño						****
** Fecha:			18/Mayo/2015										****
** Help:			766265												****
** Descripción:		Validación para CLLOCALI y CLENTIDA por Pais		****
****************************************************************************
** Creó:		Karla Dosal												****
** Fecha:		20/Feb/12												****
** Help:		416571													****
** Descripción:	Actualiza los datos de una persona, la cual				****
**				fue agregada desde Clientes Relacionados				****
****************************************************************************
*/

declare	@Per_Comple	varchar(180),			/*	Declaracion de Variables	*/
		@Per_ComOrd	varchar(180),
		@Status		int,
		@Per_Existe	char(8),
		@Cli_Numero	char(8),
		@Loc_Pais	char(3)

declare	@Str_Vacio	char(1),				/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Ent_Cero	int,
		@Act_Datos	char(1),
		@Ent_Uno	int

select	@Str_Vacio	= '',			/*	String Vacio								*/
		@Str_Espaci	= ' ',			/*	String Espacio								*/
		@Per_Moral	= '1',			/*	Persona Moral								*/
		@Per_Fisica	= '2',			/*	Persona Fisica								*/
		@Ent_Cero	= 0,			/*	Entero en Cero								*/
		@Act_Datos	= 'D',			/*	Tipo de Actualización: Datos de la Persona	*/
		@Ent_Uno	= 1				/*	Entero: Uno									*/

if (@Per_Tipo <> @Per_Moral) and (@Per_Tipo <> @Per_Fisica) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Tipo de persona incorrecto',
			Err_Variab	= 'Per_Tipo'
	rollback
	return 1
end

if (@Per_Tipo = @Per_Moral) and (@Per_RazSoc = @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Razon social incorrecta',
			Err_Variab	= 'Per_RazSoc'
	rollback
	return 1
end

if (@Per_Tipo = @Per_Fisica) and (@Per_Nombre = @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab	= 'Per_Nombre'
	rollback
	return 1
end
if (@Per_Tipo = @Per_Fisica) and (@Per_ApePat = @Str_Vacio) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Apellido paterno incorrecto',
			Err_Variab	= 'Per_ApePat'
	rollback
	return 1
end
if (@Per_Tipo = @Per_Fisica) and (@Per_ApeMat = @Str_Vacio) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Apellido materno incorrecto',
			Err_Variab	= 'Per_ApeMat'
	rollback
	return 1
end

select @Loc_Pais = Loc_Pais
	from CLLOCALI noholdlock
	where Loc_Numero = @Per_Locali
	and   Loc_Entida = @Per_Entida

if isNull(@Loc_Pais,@Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'La ciudad no existe' + @Per_Locali,
			Err_Variab	= 'Per_Locali'
	rollback
	return 1
end

if not exists (select Ent_Numero
					from CLENTIDA noholdlock
					where	Ent_Numero	= @Per_Entida
					and		Ent_Pais 	= @Loc_Pais) begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'El estado no existe',
			Err_Variab	= 'Per_Locali'
	rollback
	return 1
end

if 	@Per_RFC = @Str_Vacio begin
	select	Err_Codigo	= '000008',
			Err_Mensaj 	= 'Proporcione el R.F.C.',
			Err_Variab 	= 'Per_RFC'
	rollback
	return 1
end

select	@Per_Existe	= Per_Numero
	from SOPERSON noholdlock
	where	Per_Numero	<>	@Per_Numero
	  and	Per_RFC		= ltrim(rtrim(@Per_RFC))

select	@Per_Existe	= isnull(@Per_Existe, @Str_Vacio)

if @Per_Existe <> @Str_Vacio begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'La persona ' + @Per_Existe + ' ya tiene este RFC.',
			Err_Variab	= 'Per_RFC'
	rollback
	return 1
end

exec @Status = CLVALRFCPRO	/* Valida RFC */
	@Per_RFC,		@Per_Tipo,		@Per_ActEmp,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

if @Status <> @Ent_Cero begin
	select	Err_Codigo	= '000010',
			Err_Mensaj 	= 'R.F.C. incorrecto',
			Err_Variab 	= 'Per_RFC'
	rollback	
	return 1	
end

if @Per_Calle = @Str_Vacio begin
	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'Proporcione la calle',
			Err_Variab	= 'Per_Calle'
	rollback
	return 1
end
if @Per_CalNum = @Str_Vacio begin
	select	Err_Codigo	= '000012',
			Err_Mensaj	= 'Proporcione el numero',
			Err_Variab	= 'Per_CalNum'
	rollback
	return 1
end

if @Per_CodPos = @Str_Vacio or 
		not exists ( select Cpc_Numero 
						from CLCODPOS noholdlock
							where	Cpc_Entida	= @Per_Entida
							  and	Cpc_Locali	= @Per_Locali
							  and	Cpc_CodPos	= @Per_CodPos) begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Código Postal Incorrecto',
			Err_Variab	= 'Per_CodPos'
	rollback
	return 1
end

select	@Cli_Numero	= Cli_Numero
	from CLCLIENT noholdlock
	where	Cli_RFC	= @Per_RFC

select	@Cli_Numero	= isnull(@Cli_Numero, @Str_Vacio)

if @Cli_Numero <> @Str_Vacio begin
	select	Err_Codigo	= '000014',
			Err_Mensaj 	= 'La persona es un Cliente, sus datos no podrán ser actualizados.',
			Err_Variab 	= 'Per_RFC'
	rollback	
	return 1
end

if (@Per_Tipo = @Per_Moral) begin
	select	@Per_Comple	= @Per_RazSoc
	select	@Per_ComOrd	= @Per_RazSoc
end else begin
	select	@Per_ComOrd	= ltrim(RTrim(@Per_Nombre)) +' '+ ltrim(RTrim(@Per_ApePat)) + ' ' + ltrim(RTrim(@Per_ApeMat))
	select	@Per_Comple	= LTrim(RTrim(@Per_ApePat)) + ' ' + LTrim(RTrim(@Per_ApeMat)) + ' ' + LTrim(RTrim(@Per_Nombre))
end

update SOPERSON set
	Per_Fecha	= @FechaSis,
	Per_NumTra	= @NumTransac,
	Per_Tipo	= @Per_Tipo,
	Per_Nombre	= @Per_Nombre,
	Per_ApePat	= @Per_ApePat,
	Per_ApeMat	= @Per_ApeMat,
	Per_Comple	= @Per_Comple,
	Per_ComOrd	= @Per_ComOrd,
	Per_RazSoc	= @Per_RazSoc,
	Per_Calle	= @Per_Calle,
	Per_CalNum	= @Per_CalNum,
	Per_Coloni	= @Per_Coloni,
	Per_Entida	= @Per_Entida,
	Per_Locali	= @Per_Locali,
	Per_CodPos	= @Per_CodPos,
	Per_Telefo	= @Per_Telefo,
	Per_ActEmp	= @Per_ActEmp,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Per_Numero	= @Per_Numero

if @@nestlevel = @Ent_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro modificado'
end
