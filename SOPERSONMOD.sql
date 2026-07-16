create procedure SOPERSONMOD (
	@Per_Numero	char(8),
	@Per_Fecha	smalldatetime output,
	@Per_NumTra	char(10) output,
	@Per_Tipo	char(1) output,
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(84),
	@Per_ApePat	varchar(84),
	@Per_ApeMat	varchar(84),
	@Per_RazSoc	varchar(254),
	@Per_RFC	varchar(15),
	@Per_CURP	char(18),
	@Per_Calle	char(40),
	@Per_CalNum	varchar(10),
	@Per_Coloni	varchar(150),
	@Per_Entida	char(3),
	@Per_Locali	char(8),
	@Per_CodPos	char(6),
	@Per_ApaPos	char(6),
	@Per_LadTel	varchar(8),
	@Per_Telefo	char(15),
	@Per_Email	varchar(50),
	@Per_ComDom	char(1),
	@Per_EstCiv	varchar(20),
	@Per_Nacion	char(3),
	@Per_ActEmp	char(1),
	@Per_Giro	char(30),
	@Per_Sector	char(3),
	@Per_Activi	char(10),
	@Per_ActINE	varchar(10),
	@Tip_Proces	char(2),
	@Cob_Tipo	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: **Modificación de Apoderados** 							****
***************************************************************************/
/** REFERENCIAS:
 ****************************************************************************
** Modifico:	José Rivera												****
** Fecha:		25/06/2026												****
** Descripcion:	Se agrega validación para tipos de actividades 			****
				económicas válidas para PF y PFAE						****
** Help:		TRACL-17683									            ****
****************************************************************************
** Modifico:	Javier Eduardo Ceron Rangel								****
** Fecha:		04/11/2025												****
** Descripcion:	NORMALIZACION DE CAMPOS  - HOMOLOGACION MAYUSCULAS      ****
** 				Aplicar UPPER() a RFC, CURP, nombres y apellidos      	****
**              para consistencia de datos      						****
** Help:		TRACL-14540										        ****
 ***************************************************************************
** Modifico:	Francisco Euan											****
** Fecha:		14/04/2025												****
** Descripcion:	Se agrega validacion de cliente relacionado a persona 	****
				para modificación por proceso de soporte				****
** Help:		TCELNC-24119											****
****************************************************************************
** Modifico:	Job Martinez											****
** Fecha:		15/04/2025												****
** Descripcion:	se agrega sentencia sea vacio en caso null Aux_Adi_NumPer***
** Help:		TCELNC-24119											****
****************************************************************************
** Modifico:	Javier Ceron											****
** Fecha:		03/07/2024												****
** Descripcion:	Se agrega validacion de tamaño de nombre para guardar 	****
				en CLNOMLAR												****
** Help:		TRACL-9032												****
****************************************************************************
** Modifico:	Alberto Pineda											****
** Fecha:		24/04/2024												****
** Descripcion:	Mandamos a llamar al SP CLCURCLIVAL para validar que    ****
				la CURP proporcionada sea valida						****
** Help:		TRACL-8294												****
****************************************************************************
** Modificó:	Carlos Copto										 	****
** Fecha:		11/03/2024											   	****
** Help: 		38996 											   		****
** Descripcion:	Se aumenta el tamaño de los campos de nombre			****
**				se agrega validacion si el nombre excede los 180 		****
**				caracteres se registra en la tabla de nombres largos	****
****************************************************************************
** Modificó:	Javier Eduardo Ceron Rangel		                    	****
** Fecha:	    04/08/2023      					                    ****
** Help:	    TRACL-5498 						                        ****
** Descripción:	Se hace ajuste para que se guarde bitacora siempre		****
****************************************************************************
** Modificó:	Yuridia Santiago									 	****
** Fecha:		23/Sep/2022											   	****
** Help: 		1739140											   		****
** Descripcion:	Se agrega validación para que  							****
**				Per_Tipo acepte sólo 1 o 2								****
****************************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz						****
** Fecha:		26/Junio/2017											****
** Help:		991811													****
** Descripcion: Se elimina la concatenación de Per_Titulo en Per_ComOrd	****
****************************************************************************
** Modifico:	Rolando Bernal											****
** Fecha:		12/Nov/2015												****
** Help:		00801121												****
** Descripcion:	Seccionar validaciones según el Tipo de Pantalla para	****
**				Sibamex3												****
****************************************************************************
** Modifico:	Andrea Ramírez Mondragón								****
** Fecha:		22/Abril/2015											****
** Help:		733855													****
** Descripcion:	Se obtiene datos para cuentas Nivel 2 de OLPARAMS		****
****************************************************************************
** Modificación:David Alejandro Cantu Treviño							****
** Fecha:		18/Mayo/2015											****
** Help:		766265													****
** Descripción:	Validación para CLLOCALI y CLENTIDA por Pais			****
****************************************************************************
** Modificó:	Azael Adan Gutierrez Castruita							****
** Fecha:		01/Junio/2012											****
** Help Desk:	461298													****
** Descripcion:	Modifica Tipo de dato para RFC							****
****************************************************************************
** Modificó:	Eugenio Chairez Flores									****
** Fecha:		27/Oct/2011												****
** Help:		00411176												****
** Descripción:	Atrapar error de validacion de fecha y omite IT			****
****************************************************************************
** Modificó:	Ma. Dolores Hdz.										****
** Fecha:		05/Ene/10												****
** Help:		00224608												****
** Descripción:	Omitir Validación telefonp en modulo FB					****
****************************************************************************
** Modificó:	Jorge Guerrero Pérez									****
** Fecha:		19/Oct/2009												****
** Help Desk:	00208986												****
** Descripcion:	Se agregó validación para lada y teléfono				****
****************************************************************************
** Modificó:	Grisdely Martínez Ramírez								****
** Fecha:		01/Julio/2009											****
** Help Desk:	173833													****
** Descripcion:	Se amplió Per_RazSoc, Per_Comple						****
**				y Per_ComOrd											****
****************************************************************************
**							STORE CONVERTIDO							****
****************************************************************************
** Modificó:	Karina Chavarría Tovar									****
** Fecha:		27/Febrero/2008											****
** Help:		76754													****
** Descripción:	Eliminar los espacios en blanco a Cli_RazSoc			****
**				cuando se asigna a Cli_ComOrd y Cli_Comple				****
****************************************************************************
** Modificó:	Lucina Gonzalez Trejo									****
** Fecha:		09/Nov/07												****
** Descripción:	Optimizar												****
** Help:		59235													****
****************************************************************************
** Modificó:	Gerardo Valladares										****
** Fecha:		25/Sep/07												****
** Descripción:	Agregar var Err_Descri									****
** Help:		3666													****
****************************************************************************
** 				STORE CONVERTIDO 										****
** Convirtió:	Karina Chavarría Tovar									****
** Fecha:		23/Julio/07												****
****************************************************************************
** Modificó:	Lucina Gonzalez Trejo									****
** Fecha:		12/Marzo/07												****
** Descripción:	Agregar campos											****
** Help:		3666 - 7100												****
****************************************************************************
** Modificó:	Ricardo Salinas											****
** Fecha:		27/Oct/06												****
** Descripción:	Si el modulo es BE no hace las validaciones				****
** Help:		3781													****
****************************************************************************
** Modificó:	Ricardo Salinas											****
** Fecha:		03/Jul/06												****
** Descripción:	Elimine validacion de CP con ciudad						****
****************************************************************************
** Modificó:	FCHIANEW												****
** Fecha:		25/Mar/06												****
** Descripción:	Validar actividad si es <> Vacio						****
****************************************************************************
** Modificó:	Jorge M. Maldonado González								****
** Fecha:		28/Octubre/2004											****
** Descripción:	Cambio en estructura de SOPERSON						****
****************************************************************************
** Modifico:	Sandra Almaguer											****
** Fecha:		01/Julio/2004											****
** Descripción:	Cambiar Err_Mensaje por Err_Mensaj						****
****************************************************************************
** Creó:		FROCHA													****
** Fecha:		18/Jun/1998												****
***************************************************************************/

declare	@Per_Comple	varchar(254),	/*	Declaracion de Variables	*/
		@Per_ComOrd	varchar(254),
		@Act_Numero	char(10),
		@Act_Status	char(1),
		@Act_ActReg	char(2),
		@Status		int,
		@PerPersoID	int,
		@PerExist	char(8),
		@Per_Benefi	char(1),
		@Bit_NumPer	char(8),
		@Bit_Fecha	smalldatetime,
		@Bit_NumTra	char(10),
		@Bit_Tipo	char(1),
		@Bit_NuSeFi	varchar(30),
		@Bit_Titulo	varchar(10),
		@Bit_Nombre	varchar(84),
		@Bit_ApePat	varchar(84),
		@Bit_ApeMat	varchar(84),
		@Bit_RazSoc	varchar(254),
		@Bit_Comple	varchar(254),
		@Bit_ComOrd	varchar(254),
		@Bit_RFC	char(15),
		@Bit_CURP	char(18),
		@Bit_Calle	char(40),
		@Bit_CalNum	varchar(10),
		@Bit_Coloni	varchar(150),
		@Bit_Entida	char(3),
		@Bit_Locali	char(8),
		@Bit_CodPos	char(6),
		@Bit_ApaPos	char(6),
		@Bit_LadTel	varchar(5),
		@Bit_Telefo	char(15),
		@Bit_Email	varchar(50),
		@Bit_ComDom	char(1),
		@Bit_EstCiv	varchar(20),
		@Bit_Nacion	char(3),
		@Bit_ActEmp	char(1),
		@Bit_Giro	char(30),
		@Bit_Sector	char(3),
		@Bit_Activi	char(10),
		@Bit_ActINE	varchar(10),
		@Err_Descri	char(12),
		@Nacion		varchar(3),
		@Numero		char(8),
		@Lon_Telefo	smallint,
		@Tel_Comple	varchar(11),
		@Loc_Pais	char(3),
		@Val_Sucurs	char(3),
		@Cli_Sucurs	char(3),
		@Cli_Numero	char(8),
		@Aux_Sector char (3),
		@Aux_ActINE	varchar(10),
		@Aux_Locali	char(8),		
		@Aux_Entida char(3),		
		@Aux_Nacion char(3),		
		@Aux_CodPos char(6),
		@Aux_PerNum char(8),
		@Aux_Adi_NumPer char (10) /*Ayudara para validar en la busqueda si la persona es cliente*/


declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Str_DobEsp char(2),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ban_Electr	char(2),
		@Pro_Intern	char(2),
		@Tip_Soport	char(2),
		@Tip_CueChe	char(2),
		@Tip_CliNom	char(2),
		@Sta_Benefi	char(1),
		@Tip_Benefi	char(1),
		@Tip_ProRec	char(1),
		@Tip_ProRea	char(1),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Per_PaiMex	char(3),
		@Per_ApoRea	char(1),
		@Tip_Apode	char(1),
		@Tip_Hered	char(1),
		@Tip_Titula	char(1),
		@Str_No12	char(6),
		@Str_23		char(4),
		@Mod_FabCon	char(2),
		@Mod_AplOnl	char(2),
		@Pan_DatPer	char(2),
		@Pan_DatCon	char(2),
		@Pan_Promot	char(2),
		@Pan_PerCli	char(2),
		@Pan_ActFin	char(2),
		@Ent_180	int,
		@Ent_40		int

select	@Str_Vacio	= '',				-- String Vacio
		@Str_Espaci	= ' ',				-- String Espacio
		@Str_DobEsp	= '  ',				-- String Doble Espacio
		@Per_Moral	= '1',				-- Persona Moral
		@Per_Fisica	= '2',				-- Persona Fisica
		@Sta_ActIna	= 'I',				-- Status de actividad inactiva
		@Tab_Nombre	= 'SOPERSON',		-- Tabla que se consulta en SOFOLIOS
		@Ent_Cero	= 0,				-- Entero en Cero
		@Ent_Uno	= 1,				-- Entero en Uno
		@Ban_Electr	= 'BE',				-- Banca Elctronica
		@Tip_CueChe	= 'CH',				-- Proceso: Personas relacionadas a Cuenta de cheques
		@Tip_CliNom	= 'CN',				-- Proceso: Clientes de Nomina
		@Pro_Intern	= 'IT',				-- Proceso de Internacional
		@Tip_Soport = 'SO',				-- Proceso: Modificacion de personas sin registro de cliente
		@Sta_Benefi	= 'S',				-- Status: Beneficiario
		@Tip_Benefi	= '4',				-- Beneficiario
		@Tip_ProRec	= '5',				-- Proveedor de Recursos
		@Tip_ProRea	= '6',				-- Propietario Real
		@Str_Si		= 'S',				-- String Si
		@Str_No		= 'N',				-- String No
		@Per_PaiMex	= '001',			-- Pais de Nacionalidad: Mexico
		@Per_ApoRea	= '8',				-- Apoderado del Propietario Real
		@Tip_Apode	= '2',				-- Apoderado de la Cuenta para Personas Morales de CHCOTBEN
		@Tip_Hered	= 'H',
		@Tip_Titula	= '1',
		@Str_No12	= '[^12]',
		@Str_23		= '[23]',
		@Mod_FabCon	= 'FB',				-- Modulo de Fabrica de Crédito al Consumo
		@Mod_AplOnl	= 'OL',				-- Modulo de Aplicaciones Online
		@Pan_DatPer	= '01',				-- Pantalla Sibamex3: Datos Personales
		@Pan_DatCon	= '02',				-- Pantalla Sibamex3: Datos de Contacto
		@Pan_Promot	= '03',				-- Pantalla Sibamex3: Promotores
		@Pan_PerCli	= '04',				-- Pantalla Sibamex3: Perfilamiento
		@Pan_ActFin	= '05',				-- Pantalla Sibamex3: Actividad Financiera
		@Ent_180	= 180,				-- Entero 180
		@Ent_40		= 40				-- Entero 40

if @Modulo = @Mod_AplOnl begin

	select	@Cli_Numero	= Adi_Client
		from SOPERSON noholdlock,
			 CLADICIO noholdlock
		where	Per_Numero	= Adi_NumPer
		  and	Per_Numero	= @Per_Numero

	select	@Val_Sucurs	= @Str_Vacio

	select	@Cli_Sucurs	= isnull(Cli_Sucurs, @Str_Vacio)
		from CLCLIENT noholdlock
		where	Cli_Numero	= @Cli_Numero

	select	@Val_Sucurs	= isnull(Par_Sucurs,@Str_Vacio) 
		from OLPARAMS noholdlock
		where	Par_Modulo	= @Mod_AplOnl

	if (@Val_Sucurs <> @Cli_Sucurs) begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'El cliente tiene cuentas que requieren de la sucursal para realizar cambios.',
				Err_Variab	= 'Cli_Numero'
		rollback
		return @Ent_Uno
	end

	select	@Per_Titulo	= Per_Titulo,
			@Per_Nombre	= Per_Nombre,
			@Per_ApePat	= Per_ApePat,
			@Per_ApeMat	= Per_ApeMat,
			@Per_RazSoc	= Per_RazSoc,
			@Per_RFC	= Per_RFC,
			@Per_CURP	= Per_CURP,

			@Per_ApaPos	= Per_ApaPos,
			@Per_ComDom	= Per_ComDom,
			@Per_EstCiv	= Per_EstCiv,
			@Per_Nacion	= Per_Nacion,
			@Per_ActEmp	= Per_ActEmp,
			@Per_Giro	= Per_Giro,
			@Per_Sector	= Per_Sector,
			@Per_Activi	= Per_Activi,
			@Per_ActINE	= Per_ActINE,
			@Per_NuSeFi	= Per_NuSeFi,
			@Per_LadTel	= Per_LadTel,
			@Per_Tipo	= Per_Tipo,
			@Per_Benefi	= Per_Benefi
		from SOPERSON noholdlock
		where	Per_Numero	= @Per_Numero

end

if @Cob_Tipo = @Tip_Titula begin

	select	@Tel_Comple	= isnull(ltrim(rtrim(@Per_LadTel)) + ltrim(rtrim(@Per_Telefo)), @Str_Vacio)
	select	@Lon_Telefo	= char_length(@Tel_Comple)

	if @Modulo not in (@Mod_FabCon, @Pro_Intern) begin

		if @Lon_Telefo <> 10 begin
			select	Err_Codigo	= '000023',
					Err_Mensaj	=  'LADA ó Teléfono Incorrecto, favor de verificarlos'
			rollback
			return @Ent_Uno
		end

	end

end

if @Cob_Tipo = @Tip_Titula and @Tip_Proces = @Tip_CueChe begin
	select	@Err_Descri	= ' del Cliente'
end else begin
	select	@Err_Descri	= @Str_Vacio
end

select	@Numero	= Per_Numero,
		@Nacion	= Per_Nacion
	from SOPERSON noholdlock
	where	Per_Numero	= @Per_Numero

select	@Numero	= isnull(@Numero, @Str_Vacio),
		@Nacion	= isnull(@Nacion, @Str_Vacio)

if @Numero = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La persona no existe',
			Err_Variab	= 'Per_Numero'
	rollback
	return @Ent_Uno
end

if @Tip_Proces = @Tip_CueChe and @Cob_Tipo = @Tip_Titula begin
	select	@Per_Nacion	= @Nacion
end

/* Validar Datos Personales */
if @Modulo not in (@Pan_DatCon, @Pan_Promot, @Pan_PerCli, @Pan_ActFin) begin

	/* Datos Personales - Validaciones PM */
	if @Per_Tipo = @Per_Moral begin
		if @Per_RazSoc = @Str_Vacio begin
			select	Err_Codigo	= '000003',
					Err_Mensaj	= 'Proporcione la Razon social' + @Err_Descri,
					Err_Variab	= 'Per_RazSoc'
			rollback
			return @Ent_Uno
		end

		if @Per_RFC = @Str_Vacio begin
			select	Err_Codigo	= '000007',
					Err_Mensaj	= 'Proporcione el RFC' + @Err_Descri,
					Err_Variab	= 'Per_RFC'
			rollback
			return @Ent_Uno
		end
	end

	/* Datos Personales - Validaciones PF */
	if @Per_Tipo like @Str_23 begin
		if @Per_Nombre = @Str_Vacio begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'Proporcione el Nombre' + @Err_Descri,
					Err_Variab	= 'Per_Nombre'
			rollback
			return @Ent_Uno
		end

		if @Per_ApePat = @Str_Vacio begin
			select	Err_Codigo	= '000005',
					Err_Mensaj	= 'Proporcione el Apellido Paterno' + @Err_Descri,
					Err_Variab	= 'Per_ApePat'
			rollback
			return @Ent_Uno
		end

		if (@Per_ApeMat = @Str_Vacio) and @Cob_Tipo <> @Tip_Hered begin
			select	Err_Codigo	= '000006',
					Err_Mensaj	= 'Proporcione el Apellido Materno' + @Err_Descri,
					Err_Variab	= 'Per_ApeMat'
			rollback
			return @Ent_Uno
		end

		/* Si no se captura el RFC debe armarse su estructura a apartir de su nombre y Fecha de nacimiento*/
		if @Per_RFC = @Str_Vacio begin
			select	Err_Codigo	= '000008',
					Err_Mensaj	= 'Proporcione el RFC o la fecha de Nacimiento' + @Err_Descri,
					Err_Variab	= 'Per_RFC'
			rollback
			return @Ent_Uno
		end
	end

	/* Datos Personales - Validaciones Generales */
	if (@Per_Tipo like @Str_No12) begin
		if @Cob_Tipo <> @Tip_Titula begin
			select	Err_Codigo	= '000002',
					Err_Mensaj	= 'Tipo de Persona incorrecto',
					Err_Variab	= 'Per_Tipo'
			rollback
			return @Ent_Uno
		end else begin
			select	Err_Codigo	= '000002',
					Err_Mensaj	= 'Tipo de Cliente incorrecto',
					Err_Variab	= 'Per_Tipo'
			rollback
			return @Ent_Uno
		end
	end

end

if @Per_RFC <> @Str_Vacio begin
    select @Per_RFC = UPPER(@Per_RFC)
end

/* Estructura Basica para el SOPERSON*/
if (@Modulo <> @Ban_Electr) and (@Tip_Proces = @Tip_CueChe and @Cob_Tipo <> @Per_ApoRea) begin

	if @Tip_Proces <> @Tip_CueChe or (@Tip_Proces = @Tip_CueChe and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) and @Per_Nacion = @Per_PaiMex) begin

		select	@PerExist	= Per_Numero
			from SOPERSON noholdlock
			where	Per_RFC		=  @Per_RFC
			  and	Per_Nacion	=  @Per_PaiMex
			  and	Per_Numero	<> @Per_Numero
			  and	(Per_Tipo	=  @Per_Moral
			  or	 (Per_Tipo	=  @Per_Fisica
			  and	  Per_ActEmp	=  @Str_Si))

		select	@PerExist	= isnull(@PerExist, @Str_Vacio)

		if @PerExist <> @Str_Vacio begin
			select	Err_Codigo	= '000009',
					Err_Mensaj	= 'La persona ' + @PerExist + ' ya tiene este RFC. (Mod)',
					Err_Variab	= 'Per_RFC'
			rollback
			return @Ent_Uno
		end

	end

	if @Per_Sector <> @Str_Vacio begin
		select @Aux_Sector	= Sec_Numero
			from CLSECTOR noholdlock
			where	Sec_Numero	= @Per_Sector

		if isnull(  @Aux_Sector, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000011',
					Err_Mensaj	= 'El sector' + @Err_Descri + ' no existe',
					Err_Variab	= 'Per_Sector'
			rollback
			return @Ent_Uno
		end
	end

	if @Per_Activi <> @Str_Vacio begin

		select	@Act_Numero	= Act_Numero,
				@Act_Status	= Act_Status,
				@Act_ActReg	= Act_ActReg
			from CLACTIVI noholdlock
			where	Act_Numero	= @Per_Activi

		select	@Act_Numero	= isnull(@Act_Numero, @Str_Vacio)

		if @Act_Numero = @Str_Vacio begin
			select	Err_Codigo	= '000012',
					Err_Mensaj	= 'La actividad' + @Err_Descri + ' no existe',
					Err_Variab	= 'Per_Activi'
			rollback
			return @Ent_Uno
		end

		if @Act_Status = @Sta_ActIna begin
			select	Err_Codigo	= '000013',
					Err_Mensaj	= 'La actividad' + @Err_Descri + ' esta inactiva',
					Err_Variab	= 'Per_Activi'
			rollback
			return @Ent_Uno
		end

		if @Per_Tipo = @Per_Fisica and @Per_ActEmp in (@Str_No, @Str_Si) begin
			if isnull(@Act_ActReg, '') <> '04' begin
				select	Err_Codigo	= '000024',
						Err_Mensaj	= 'La actividad ecónomica no corresponde al tipo de personalidad del cliente',
						Err_Variab	= 'Per_Activi'
				rollback
				return @Ent_Uno
			end
		end

	end

	if @Per_ActINE <> @Str_Vacio begin

		select @Aux_ActINE = Act_Numero
			from CLACTINE noholdlock
			where	Act_Numero	= @Per_ActINE

		if  isnull(@Aux_ActINE, @Str_Vacio) = @Str_Vacio  begin
			select	Err_Codigo	= '000014',
					Err_Mensaj	= 'La actividad INEGI' + @Err_Descri + ' no existe',
					Err_Variab	= 'Per_ActINE'
			rollback
			return @Ent_Uno
		end
	end

	if @Per_Nacion = @Per_PaiMex and @Cob_Tipo not in (@Tip_Apode, @Tip_Hered) begin

		if @Per_Calle = @Str_Vacio begin
			select	Err_Codigo	= '000015',
					Err_Mensaj	= 'Proporcione la calle del domicilio' + @Err_Descri,
					Err_Variab	= 'Per_Calle'
			rollback
			return @Ent_Uno
		end

		if @Per_CalNum = @Str_Vacio begin
			select	Err_Codigo	= '000016',
					Err_Mensaj	= 'Proporcione el numero del Domicilio' + @Err_Descri,
					Err_Variab	= 'Per_CalNum'
			rollback
			return @Ent_Uno
		end

		select	@Aux_Locali = Loc_Numero
			from CLLOCALI noholdlock
			where	Loc_Numero	= @Per_Locali
				and	Loc_Entida	= @Per_Entida

		if isnull(@Aux_Locali, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000017',
					Err_Mensaj	= 'La ciudad' + @Err_Descri + ' no existe' + @Per_Locali,
					Err_Variab	= 'Per_Locali'
			rollback
			return @Ent_Uno
		end

		select	@Aux_Entida = Ent_Numero
			from CLENTIDA noholdlock,
					CLLOCALI noholdlock
			where	Ent_Numero	= @Per_Entida
			and		Loc_Numero  = @Per_Locali
			and		Loc_Entida	= Ent_Numero
			and		Ent_Pais	= Loc_Pais

		if isnull(@Aux_Entida, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000018',
					Err_Mensaj	= 'El estado'  + @Err_Descri + ' no existe',
					Err_Variab	= 'Per_Locali'
			rollback
			return @Ent_Uno
		end

	end

	if @Per_Nacion <> @Str_Vacio begin

		select	@Aux_Nacion = Pai_Numero
			from SOPAIS noholdlock
			where	Pai_Numero	= @Per_Nacion

		if (@Per_Tipo like @Str_23) and (isnull(@Aux_Nacion, @Str_Vacio)) = @Str_Vacio begin
			select	Err_Codigo	= '000019',
					Err_Mensaj	= 'Nacionalidad' + @Err_Descri + ' Incorrecta',
					Err_Variab	= 'Per_Nacion'
			rollback
			return @Ent_Uno
		end

	end

	if @Tip_Proces = @Tip_CueChe and @Cob_Tipo not in (@Tip_Apode,@Tip_Hered) begin

		select	@Aux_CodPos = Cpc_Numero
			from CLCODPOS noholdlock
			where	Cpc_Entida	= @Per_Entida
				and	Cpc_Locali	= @Per_Locali
				and	Cpc_CodPos	= @Per_CodPos
		if (@Per_CodPos = @Str_Vacio or (isnull(@Aux_CodPos, @Str_Vacio) = @Str_Vacio)) and @Per_Nacion = @Per_PaiMex begin
			select	Err_Codigo	= '000020',
					Err_Mensaj	= 'Código Postal' + @Err_Descri + ' Incorrecto',
					Err_Variab	= 'Per_CodPos'
			rollback
			return @Ent_Uno
		end

		if @Modulo not in (@Mod_AplOnl) begin
			if @Per_ComDom = @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi, @Tip_Hered, @Tip_ProRec, @Tip_ProRea, @Tip_CliNom, @Tip_Apode) begin
				select	Err_Codigo	= '000021',
						Err_Mensaj	= 'Comprobante de domicilio' + @Err_Descri + ' incorrecto',
						Err_Variab	= 'Per_ComDom'
				rollback
				return @Ent_Uno
			end

			if (@Per_Tipo like @Str_23) and (@Per_EstCiv = @Str_Vacio) and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_Apode) begin
				select	Err_Codigo	= '000022',
						Err_Mensaj	= 'Proporcione el estado civil' + @Err_Descri,
						Err_Variab	= 'Per_EstCiv'
				rollback
				return @Ent_Uno
			end

		end

	end

end

if (@Per_Tipo = @Per_Moral) begin
	select  @Per_RazSoc = str_replace(@Per_RazSoc, @Str_DobEsp, @Str_Espaci)
	select  @Per_RazSoc = UPPER(LTrim(RTrim(@Per_RazSoc)))
	select	@Per_Comple	= @Per_RazSoc
	select	@Per_ComOrd	= @Per_RazSoc

end else begin
	--Sanitizamos Nombre y apellidos
	select @Per_ApePat = str_replace(@Per_ApePat, @Str_DobEsp, @Str_Espaci),
		   @Per_ApeMat = str_replace(@Per_ApeMat, @Str_DobEsp, @Str_Espaci),
		   @Per_Nombre = str_replace(@Per_Nombre, @Str_DobEsp, @Str_Espaci)

	select  @Per_ApePat = UPPER(LTrim(RTrim(@Per_ApePat))),
			@Per_ApeMat = UPPER(LTrim(RTrim(@Per_ApeMat))),
			@Per_Nombre = UPPER(LTrim(RTrim(@Per_Nombre)))

	select	@Per_Comple	= @Per_ApePat + @Str_Espaci + @Per_ApeMat + @Str_Espaci + @Per_Nombre
	select	@Per_ComOrd	= @Per_Nombre + @Str_Espaci + @Per_ApePat + @Str_Espaci + @Per_ApeMat
end

if @Cob_Tipo = @Tip_Benefi begin
	select	@Per_Benefi	= @Str_Si
end else begin
	select	@Per_Benefi	= @Str_No
end

if isnull(@Per_NumTra, @Str_Vacio) = @Str_Vacio begin
	select	@Per_Fecha	= @FechaSis,
			@Per_NumTra	= @NumTransac
end

--Se quito condicion para evitar perdida de bitacora
select	@PerPersoID = PerPersoID,
		@Bit_NumPer	= Per_Numero,
		@Bit_Fecha	= Per_Fecha,
		@Bit_NumTra	= Per_NumTra,
		@Bit_Tipo	= Per_Tipo,
		@Bit_NuSeFi	= Per_NuSeFi,
		@Bit_Titulo	= Per_Titulo,
		@Bit_Nombre	= Per_Nombre,
		@Bit_ApePat	= Per_ApePat,
		@Bit_ApeMat	= Per_ApeMat,
		@Bit_RazSoc	= Per_RazSoc,
		@Bit_Comple	= Per_Comple,
		@Bit_ComOrd	= Per_ComOrd,
		@Bit_RFC	= Per_RFC,
		@Bit_CURP	= Per_CURP,
		@Bit_Calle	= Per_Calle,
		@Bit_CalNum	= Per_CalNum,
		@Bit_Coloni	= Per_Coloni,
		@Bit_Entida	= Per_Entida,
		@Bit_Locali	= Per_Locali,
		@Bit_CodPos	= Per_CodPos,
		@Bit_ApaPos	= Per_ApaPos,
		@Bit_LadTel	= Per_LadTel,
		@Bit_Telefo	= Per_Email,
		@Bit_Email	= Per_Email,
		@Bit_ComDom	= Per_ComDom,
		@Bit_EstCiv	= Per_EstCiv,
		@Bit_Nacion	= Per_Nacion,
		@Bit_ActEmp	= Per_ActEmp,
		@Bit_Giro	= Per_Giro,
		@Bit_Sector	= Per_Sector,
		@Bit_Activi	= Per_Activi,
		@Bit_ActINE	= Per_ActINE
	from SOPERSON noholdlock
	where	Per_Numero = @Per_Numero

/***************************************************************/	
/*       VALIDAR QUE LA CURP PROPORCIONADA SEA VALIDA          */
/***************************************************************/
--si el numero de persona esta relacionado con cliente 
select @Aux_Adi_NumPer= Adi_NumPer 
from CLADICIO noholdlock
where Adi_NumPer = @Per_Numero

select @Aux_Adi_NumPer = isnull(@Aux_Adi_NumPer, @Str_Vacio)

/* Normalización CURP en mayúsculas - Solo para personas físicas */
if @Per_Tipo <> @Per_Moral begin
	select @Per_CURP = UPPER(@Per_CURP)
end

if(@Per_Tipo <> @Per_Moral and @Aux_Adi_NumPer <> @Str_Vacio) begin 
	exec @Status = CLCURCLIVAL
		@Per_CURP,  '' , '', 1,	@NumTransac, 	
		@Transaccio,	@Usuario,   	@FechaSis,  	@SucOrigen, 	@SucDestino,	
		@Modulo
		
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end	
end

if @Tip_Proces = @Tip_Soport and isnull(@Aux_Adi_NumPer,@Str_Vacio) <> @Str_Vacio begin
				
	select	Err_Codigo	= '000023',
			Err_Mensaj	= 'La persona está relacionada a un registro de cliente'
	rollback
	return @Ent_Uno
end

/***************************************************************/

exec @Status = SOBITPERALT
	@Bit_NumPer,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
	@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
	@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
	@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
	@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
	@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
	@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Cob_Tipo <> @Per_ApoRea begin

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
		Per_Tipo	= @Per_Tipo,
		Per_Benefi	= @Per_Benefi,
		Per_NuSeFi	= @Per_NuSeFi,
		Per_Titulo	= @Per_Titulo,
		Per_Nombre	= @Per_Nombre,
		Per_ApePat	= @Per_ApePat,
		Per_ApeMat	= @Per_ApeMat,
		Per_RazSoc	= @Per_RazSoc,
		Per_Comple	= @Per_Comple,
		Per_ComOrd	= @Per_ComOrd,
		Per_RFC		= @Per_RFC,
		Per_CURP	= @Per_CURP,
		Per_Calle	= @Per_Calle,
		Per_CalNum	= @Per_CalNum,
		Per_Coloni	= @Per_Coloni,
		Per_Entida	= @Per_Entida,
		Per_Locali	= @Per_Locali,
		Per_CodPos	= @Per_CodPos,
		Per_ApaPos	= @Per_ApaPos,
		Per_LadTel	= @Per_LadTel,
		Per_Telefo	= @Per_Telefo,
		Per_Email	= @Per_Email,
		Per_ComDom	= @Per_ComDom,
		Per_EstCiv	= @Per_EstCiv,
		Per_Nacion	= @Per_Nacion,
		Per_ActEmp	= @Per_ActEmp,
		Per_Giro	= @Per_Giro,
		Per_Sector	= @Per_Sector,
		Per_Activi	= @Per_Activi,
		Per_ActINE	= @Per_ActINE,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Per_Numero	= @Per_Numero

end else begin

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
		Per_Tipo	= @Per_Tipo,
		Per_Titulo	= @Per_Titulo,
		Per_Nombre	= @Per_Nombre,
		Per_ApePat	= @Per_ApePat,
		Per_ApeMat	= @Per_ApeMat,
		Per_Comple	= @Per_Comple,
		Per_ComOrd	= @Per_ComOrd,
		Per_RFC		= @Per_RFC,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Per_Numero	= @Per_Numero

end

--Si el nombre o apellidos excede los 40 caracteres se guarda en la tabla de nombres largos
if char_length(@Per_Nombre) > @Ent_40 or char_length(@Per_ApePat) > @Ent_40  or char_length(@Per_ApeMat) > @Ent_40 begin
	exec @Status = SONOMLARMOD
		@PerPersoID,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
	    @Per_Comple,	@Per_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
	    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
end

--Si el nombre de la persona excede 180 caracteres se manda a modificar en la tabla de nombres largos
if char_length(@Per_Comple) > @Ent_180 or char_length(@Per_RazSoc) > @Ent_180  begin

	exec @Status = SONOMLARMOD
		@PerPersoID,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
	    @Per_Comple,	@Per_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
	    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

end

if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro modificado ',
			Err_Numero	= @Per_Numero,
			Per_Fecha	= @Per_Fecha,
			Per_NumTra	= @Per_NumTra