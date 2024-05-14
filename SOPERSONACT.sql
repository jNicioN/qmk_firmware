create procedure SOPERSONACT (
	@Per_Numero	char(8),
	@Per_Tipo	char(1),
	@Per_Benefi	char(1),
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_RazSoc	varchar(180),	
	@Per_RFC	varchar(15),
	@Per_CURP	char(18),
	@Per_Calle	char(40),
	@Per_CalNum	varchar(10),
	@Per_Coloni	varchar(150),
	@Per_Entida	char(3),
	@Per_Locali	char(8),
	@Per_CodPos	char(6),
	@Per_ApaPos	char(6),
	@Per_LadTel	varchar(5),
	@Per_Telefo char(15),
	@Per_Email	varchar(50),
	@Per_ComDom	char(1),
	@Per_EstCiv	varchar(20),
	@Per_Nacion	char(3),
	@Per_ActEmp char(1),
	@Per_Giro	char(30),
	@Per_Sector	char(3),
	@Per_Activi	char(10),
	@Per_ActINE	varchar(10),
	@Tip_Proces	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as
/**************************************************************************
** Modifico:	Alberto Pineda											****
** Fecha:		24/04/2024												****
** Descripcion:	Mandamos a llamar al SP CLCURCLIVAL para validar que    ****
				la CURP proporcionada sea valida						****
** Help:		TRACL-8294												***/
/***************************************************************************
** Modificó:	Yuridia Santiago									 	****
** Fecha:		23/Sep/2022											   	****
** Help: 		1739140											   		****
** Descripcion:	Se modifica validación para que Per_Tipo acepte 		****
**				 sólo 1 o 2, se estandariza SP 							****
****************************************************************************
** Modificó:		Azael Adan Gutierrez Castruita						****
** Fecha:		31/Mayo/2012											****
** Help Desk:	461298													****
** Descripcion:	Optimizacion se eliminan rtrim y ltrim   				**** 
****************************************************************************
** Modificó:		Grisdely Martínez Ramírez							****
** Fecha:		01/Julio/2009											****
** Help Desk:	173833													****
** Descripcion:	Se amplió Per_RazSoc, Per_Comple 	 					**** 
**				y Per_ComOrd											****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo								****
** Fecha:		12/Marzo/07												****
** Help:			3666												****
** Descripción:	Agregar parametros a SOPERSONALT y a 					****
**				SOPERSONMOD						 						****
****************************************************************************
** Creó:			JMALDONADO     										****
** Fecha:		29/Oct/04												****
****************************************************************************/

declare	@Per_Comple	varchar(180),	/*	Declaracion de Variables	*/
		@Per_ComOrd	varchar(180),
		@Act_Numero	char(10),
		@Act_Status	char(1),
		@Status		int,
		@PerPersoID	int,
		@PerExist	char(8),
		@Aux_Sector char (3),
		@Aux_ActINE	varchar(10),
		@Aux_Locali	char(8),
		@Aux_Entida char(3),
		@Aux_Nacion char(3),
		@Aux_CodPos char(6)

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Ent_Uno 	int,
		@Tip_ActCot	char(2),
		@Per_PaiMex	char(3),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Str_12		char(5)

/* Asignacion de constantes */
select	@Str_Vacio	= '',			/*	String Vacio	*/
		@Str_Espaci	= ' ',			/*	String Espacio	*/
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS	*/
		@Ent_Cero	= 0,			/* Entero en Cero			*/
		@Ent_Uno	= 1,			/* Entero uno */
		@Tip_ActCot	= 'AC',
		@Per_PaiMex	= '001',
		@Str_Si		= 'S',
		@Str_No		= 'N',
	 	@Str_12		= '[12]'


if (@Per_Tipo not like @Str_12) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Tipo de persona incorrecto',
			Err_Variab	= 'Per_Tipo'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo = @Per_Moral) and (@Per_RazSoc = @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Razon social incorrecta',
			Err_Variab	= 'Per_RazSoc'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo like @Per_Fisica) and (@Per_Nombre = @Str_Vacio) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Nombre incorrecto',
			Err_Variab	= 'Per_Nombre'
	rollback
	return @Ent_Uno
end
if (@Per_Tipo like @Per_Fisica) and (@Per_ApePat = @Str_Vacio) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Apellido paterno incorrecto',
			Err_Variab	= 'Per_ApePat'
	rollback
	return @Ent_Uno
end
if (@Per_Tipo like @Per_Fisica) and (@Per_ApeMat = @Str_Vacio) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Apellido materno incorrecto',
			Err_Variab	= 'Per_ApeMat'
	rollback
	return @Ent_Uno
end


select	@Aux_Sector	= Sec_Numero
	from CLSECTOR noholdlock
	where	Sec_Numero	= @Per_Sector

if isnull(@Aux_Sector, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'El sector no existe',
			Err_Variab	= 'Per_Sector'
	rollback
	return @Ent_Uno
end

select	@Act_Numero	= Act_Numero,
		@Act_Status	= Act_Status
	from CLACTIVI noholdlock
	where	Act_Numero	= @Per_Activi

select @Act_Numero	= isnull(@Act_Numero, @Str_Vacio)

if @Act_Numero = @Str_Vacio begin
	select	Err_Codigo	= '000008',
			Err_Mensaj	= 'La actividad no existe',
			Err_Variab	= 'Per_Activi'
	rollback
	return @Ent_Uno
end

if @Act_Status = @Sta_ActIna begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'La actividad esta inactiva',
			Err_Variab	= 'Per_Activi'
	rollback
	return @Ent_Uno
end

select	@Aux_ActINE	= Act_Numero
	from CLACTINE noholdlock
	where	Act_Numero	= @Per_ActINE

if isnull(@Aux_ActINE, @Str_Vacio) = @Str_Vacio  begin
	select	Err_Codigo	= '000010',
			Err_Mensaj	= 'La actividad del INEGI no existe',
			Err_Variab	= 'Per_ActINE'
	rollback
	return @Ent_Uno
end

select	@Aux_Locali = Loc_Numero
	from CLLOCALI noholdlock
	where	Loc_Numero	= @Per_Locali

if isnull(@Aux_Locali, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'La ciudad no existe' + @Per_Locali,
			Err_Variab	= 'Per_Locali'
	rollback
	return @Ent_Uno
end

select @Aux_Entida = Ent_Numero
	from CLENTIDA noholdlock
	where	Ent_Numero	= @Per_Entida

if isnull(@Aux_Entida, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000012',
			Err_Mensaj	= 'El estado no existe',
			Err_Variab	= 'Per_Locali'
	rollback
	return @Ent_Uno
end

select	@Aux_Nacion = Pai_Numero
	from SOPAIS noholdlock
	where	Pai_Numero	= @Per_Nacion

if isnull(@Aux_Nacion, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Nacionalidad Incorrecta',
			Err_Variab	= 'Per_Nacion'
	rollback
	return @Ent_Uno
end

if 	@Per_RFC = @Str_Vacio begin
	select	Err_Codigo	= '000014',
			Err_Mensaj 	= 'Proporcione el R.F.C.',
			Err_Variab 	= 'Per_RFC'
	rollback
	return @Ent_Uno
end

select	@PerExist	= Per_Numero
	from SOPERSON noholdlock
	where	Per_Numero	<>	@Per_Numero
	  and	Per_RFC					= @Per_RFC
	  and	Per_Nacion				= @Per_PaiMex
	  and	(Per_Tipo				= @Per_Moral
	  or	(Per_Tipo				= @Per_Fisica
	  and	 Per_ActEmp				= @Str_Si))

select	@PerExist	= isnull(@PerExist, @Str_Vacio)

if @PerExist <> @Str_Vacio begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'La persona ' + @PerExist + ' ya tiene este RFC. (Mod)',
			Err_Variab	= 'Per_RFC'
	rollback
	return @Ent_Uno
end


exec @Status = CLVALRFCPRO	/* Valida RFC */
	@Per_RFC,		@Per_Tipo,		@Per_ActEmp,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

if @Status <> @Ent_Cero begin
	select	Err_Codigo	= '000015',
			Err_Mensaj 	= 'R.F.C. incorrecto',
			Err_Variab 	= 'Per_RFC'
	rollback	
	return @Ent_Uno	
end	

/**/
if @Per_Calle = @Str_Vacio begin
	select	Err_Codigo	= '000016',
			Err_Mensaj	= 'Proporcione la calle',
			Err_Variab	= 'Per_Calle'
	rollback
	return @Ent_Uno
end
if @Per_CalNum = @Str_Vacio begin
	select	Err_Codigo	= '000017',
			Err_Mensaj	= 'Proporcione el numero',
			Err_Variab	= 'Per_CalNum'
	rollback
	return @Ent_Uno
end

select @Aux_CodPos = Cpc_Numero 
	from CLCODPOS noholdlock
	where	Cpc_Entida	= @Per_Entida
		and	Cpc_Locali	= @Per_Locali
		and	Cpc_CodPos	= @Per_CodPos

select @Aux_CodPos = isnull(@Aux_CodPos, @Str_Vacio)

if @Per_CodPos = @Str_Vacio or  @Aux_CodPos = @Str_Vacio begin
	select	Err_Codigo	= '000018',
			Err_Mensaj	= 'CÃ³digo Postal Incorrecto',
			Err_Variab	= 'Per_CodPos'
	rollback
	return @Ent_Uno
end

select @Per_Titulo	= isnull(@Per_Titulo, @Str_Vacio)

if (@Per_Tipo = @Per_Moral) begin
	select	@Per_Comple	= @Per_RazSoc
	select	@Per_ComOrd	= @Per_RazSoc
end else begin

	if @Per_Titulo = @Str_Vacio begin
		select	@Per_ComOrd	= ltrim(RTrim(@Per_Nombre)) +' '+ ltrim(RTrim(@Per_ApePat)) + ' ' + ltrim(RTrim(@Per_ApeMat))
	end else begin
		select	@Per_ComOrd	= ltrim(RTrim(@Per_Titulo)) +' '+ ltrim(RTrim(@Per_Nombre)) +' '+ ltrim(RTrim(@Per_ApePat)) + ' ' + ltrim(RTrim(@Per_ApeMat))
	end
	
	select	@Per_Comple	= LTrim(RTrim(@Per_ApePat)) + ' ' + LTrim(RTrim(@Per_ApeMat)) + ' ' + LTrim(RTrim(@Per_Nombre))
	
end

if @Tip_Proces = @Tip_ActCot begin

	select	@Per_Tipo	= Per_Tipo,
			@Per_Benefi	= Per_Benefi,
			@Per_NuSeFi	= Per_NuSeFi,
			@Per_Titulo	= Per_Titulo,
			@Per_Nombre	= Per_Nombre,
			@Per_ApePat	= Per_ApePat,
			@Per_ApeMat	= Per_ApeMat,
			@Per_RazSoc	= Per_RazSoc,
			@Per_Calle	= Per_Calle,
			@Per_CalNum	= Per_CalNum,
			@Per_Coloni	= Per_Coloni,
			@Per_Entida	= Per_Entida,
			@Per_Locali	= Per_Locali,
			@Per_CodPos	= Per_CodPos,
			@Per_ApaPos	= Per_ApaPos,
			@Per_LadTel	= Per_LadTel,
			@Per_Telefo	= Per_Telefo,
			@Per_Email	= Per_Email,
			@Per_ComDom	= Per_ComDom,
			@Per_EstCiv	= Per_EstCiv,
			@Per_Nacion	= Per_Nacion,
			@Per_ActEmp	= Per_ActEmp,
			@Per_Giro	= Per_Giro,
			@Per_Sector	= Per_Sector,
			@Per_Activi	= Per_Activi,
			@Per_ActINE	= Per_ActINE
		from SOPERSON noholdlock
		where	Per_Numero	= @Per_Numero
end

/***************************************************************/	
/*       VALIDAR QUE LA CURP PROPORCIONADA SEA VALIDA          */
/***************************************************************/
if(@Per_Tipo <> @Per_Moral) begin	
	exec @Status = CLCURCLIVAL
		@Per_CURP,  '', '', 1,	@NumTransac, 	
		@Transaccio,	@Usuario,   	@FechaSis,  	@SucOrigen, 	@SucDestino,	
		@Modulo
		
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end	
end
/***************************************************************/
exec @Status = SOPERSONMOD
		@Per_Numero,		@FechaSis,		@NumTransac,	@Per_Tipo,		@Per_NuSeFi,
		@Per_Titulo,		@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
		@Per_RFC,			@Per_CURP,		@Per_Calle,		@Per_CalNum,	@Per_Coloni,
		@Per_Entida,		@Per_Locali,	@Per_CodPos,	@Per_ApaPos,	@Per_LadTel,
		@Per_Telefo,		@Per_Email,		@Per_ComDom,	@Per_EstCiv,	@Per_Nacion,
		@Per_ActEmp,		@Per_Giro,		@Per_Sector,	@Per_Activi,	@Per_ActINE,
		@Tip_Proces,		@Str_Vacio,		@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,			@SucOrigen,		@SucDestino,	@Modulo			

if @Status <> @Ent_Cero begin
	select	Err_Codigo	= '000015',
			Err_Mensaj 	= 'Error al actualizar',
			Err_Variab 	= 'Per_Numero'
	rollback	
	return @Ent_Uno
end