create procedure SOPERSONALT(
	@Per_Numero	char(8) output,
	@Per_Fecha	smalldatetime output,
	@Per_NumTra	char(10) output,
	@Per_Tipo	char(1),
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(84),
	@Per_ApePat	varchar(84),
	@Per_ApeMat	varchar(84),
	@Per_RazSoc	varchar(254),	
	@Per_RFC	varchar(15),
	@Per_CURP	varchar(18),
	@Per_Calle	varchar(40),
	@Per_CalNum	varchar(10),
	@Per_Coloni	varchar(150),
	@Per_Entida	char(3),
	@Per_Locali	char(8),
	@Per_CodPos	char(6),
	@Per_ApaPos	char(6),
	@Per_LadTel	varchar(8),
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
	@Cob_Tipo	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as
/* NOTA: Las TABLAS AFECTADAS deben ejecutarse antes compilar el stored procedure*/
/* TABLAS AFECTADAS: */
/*SoPerson*/
/***************************************************************************/
/** DESCRIPCION: ** Altas de Apoderados **						  		   */
/***************************************************************************/
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
** Help:		TRACL-14540										        ****										   */
/****************************************************************************
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
** Help:		TRACL-8294												***/
/****************************************************************************
** Modificó:	Carlos Copto										 	****
** Fecha:		11/03/2024											   	****
** Help: 		38996 											   		****
** Descripcion:	Se aumenta el tamaño de los campos de nombre			****
**				Cli_Nombre,Cli_ApePat,Cli_ApeMat,Cli_RazSoc,Cli_Comple 	****
**				y Cli_ComOrd 											****
****************************************************************************
** Modificó:	Yuridia Santiago									 	****
** Fecha:		23/Sep/2022											   	****
** Help: 		1739140											   		****
** Descripcion:	Se agrega validación para que  							****
**				Per_Tipo acepte sólo 1 o 2								****
***************************************************************************
** Modifico:	Raul Muniz												****
** Fecha:		06/Octubre/2021											****
** Help:		1504301													****
** Descripcion: Se agrega exec a SOPEINCOALT para guardar actividad		****
**				preponderante											****
****************************************************************************
** Modifico:	CODE4U-Eliezer Catalino Xul Canche						****
** Fecha:		06/Febrero/2020											****
** Help:		1343720													****
** Descripcion: Se agrega indentity para el campo PerPersoID			****
****************************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz						****
** Fecha:		26/Junio/2017											****
** Help:		991811													****
** Descripcion: Se elimina la concatenación de Per_Titulo en Per_ComOrd	****
****************************************************************************
** Modifico:	Andrea Ramírez Mondragón								****
** Fecha:		22/Abril/2015											****
** Help:		733855													****
** Descripcion:	Se obtiene datos para cuentas Nivel 2 de OLPARAMS		****
****************************************************************************
** Modificación:	David Alejandro Cantu Treviño						****
** Fecha:			18/Mayo/2015										****
** Help:			766265												****
** Descripción:		Validación para CLLOCALI y CLENTIDA por Pais		****
****************************************************************************
** Modifico:		Edwin E. Pérez Requena								****
** Fecha:		11/Agosto/2014											****
** Help:			673139												****
** Descripcion:	Se agrega NB en condición para Banca 					****
**				Electrónica												****
****************************************************************************
** Modifico:		Claudia V Sandoval P								****
** Fecha:		03/03/2014												****
** Help:			00599444											****
** Descripcion:	Se agrega proceso unificacion							****
****************************************************************************
** Modificó:		Ignacio Ordaz Valtierra								****
** Fecha:		12/Sep/2012												****
** Help:			386371												****
** Descripción:	validar localidad y entidad sean activos				****
****************************************************************************
** Modificó:		Eugenio Chairez Flore     							****
** Fecha:		27/Oct/2011												****
** Help:			00411176											****
** Descripción:	No atraopaba el Error al validar el Telefono			****
****************************************************************************
** Modificó:		Ma. Dolores Hdz.									****
** Fecha:		05/Ene/10												****
** Help:			00224608											****
** Descripción:	Omitir Validación telefonp en modulo FB					****
****************************************************************************
** Modificó:		Jorge Guerrero										****
** Fecha:		08/Dic/2009												****
** Help Desk:	00232160												****
** Descripcion:	validar el la longitud del teléfono, sólo a las 		****				  
**				personas que son titulares (Clientes).		 			**** 		
****************************************************************************
** Modificó:		Jorge Guerrero Perez								****
** Fecha:		19/Oct/2009												****
** Help Desk:	00208986												****
** Descripcion:	Se agregó validación para lada y teléfono 				**** 		
**** **																	****
****************************************************************************
****************************************************************************
** Modificó:		Grisdely Martínez Ramírez							****
** Fecha:		01/Julio/2009											****
** Help Desk:	173833													****
** Descripcion:	Se amplió Per_RazSoc, Per_Comple 	 					****
 **				y Per_ComOrd											****
****************************************************************************
**       			STORE CONVERTIDO                 					****
****************************************************************************
** Modificó:		Karina Chavarría Tovar								****
** Fecha:		27/Febrero/2008											****
** Help:			76754												****
** Descripción:	Eliminar los espacios en blanco a Cli_RazSoc 			****
**				cuando se asigna a Cli_ComOrd y Cli_Comple				**** 
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo								****
** Fecha:		09/Nov/07												****
** Descripción:	Optimizar												****
** Help:			59235												****
****************************************************************************
** Modificó:		Gerardo Valladares									****
** Fecha:		25/Sep/07												****
** Descripción:	Agregar var Err_Descri									****
** Help:			3666												****
****************************************************************************
** 				STORE CONVERTIDO 										****	
** Convirtió : Karina Chavarría Tovar									****	
** Fecha :     23/Julio/07												****	
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo								****
** Fecha:		12/Marzo/07												****
** Descripción:	Agregar campos											****
** Help:			3666 - 7100											****
****************************************************************************
** Modificó:		Ricardo Salinas										****
** Fecha:		27/Oct/06												****
** Descripción:	Si el modulo es BE no hace las validaciones				****
** Help:			3781												****
****************************************************************************
****************************************************************************
** Modificó:		Ricardo Salinas										****
** Fecha:		03/Jul/06												****
** Descripción:	Elimine validacion de CP con ciudad	 					****
****************************************************************************
****************************************************************************
** Modificó:		FCHIA	       										****
** Fecha:		24/Mar/06												****
** Descripción:	Que valide Actividad solo si  <> Vacio					****
****************************************************************************
** Modificó:		Jorge Ortega Rodríguez								****
** Fecha:		28/Octubre/2005											****
** Help:			Corrección											****
** Descripción:	Se cambió la variable Err_Numero por					****
**				Per_Numero en la salida del Store						****
****************************************************************************
** Modificó:		Jorge M. Maldonado González							****
** Fecha:		28/Octubre/2004											****
** Descripción:	Cambio en estructura de SOPERSON						****
****************************************************************************
** Modificó:		Mayra Estrada	  									****
** Fecha:		17/Jun/00												****
** Descripción:	Validación 000002										****
****************************************************************************
** Creó:			FROCHA         										****
** Fecha:		18/Jun/1998												****
****************************************************************************
** Modificó : 	Ing. Laura Elena Cervantes 								****
** Fecha:	 	16/Jul/1998												****
****************************************************************************/

/*	Declaracion de Variables	*/
declare	@Per_Comple	varchar(254),	/* Nombre Completo */
		@Per_ComOrd	varchar(254),	/* Nombre Completo Ordenado */
		@Act_Numero	char(10),		/* Numero Actividad */
		@Act_Status	char(1),		/* Estatus Actividad */
		@Act_ActReg	char(2),		/* Actividad Regulatoria */
		@Status		int,			/* Estatus */
		@PerPersoID	int,			/* ID Persona */
		@PerExist	char(8),		/* Variable Existe Persona */
		@Per_Benefi	char(1),		/* Beneficiario */
		@Err_Descri	char(12),		/* Error Descripcion */
		@Lon_Telefo smallint,		/* Telefono */
		@Tel_Comple	varchar(11),	/* Telefono Completo */
		@Sta_Locali char(1),		/* Localidad */
		@Sta_Entida	char(1),		/* Estatus Entidad */
		@Per_Pais	char(3),		/* Pais */
		@Act_ActPre	int	,			/* Actividad Preponderante */
		@Aux_Sector char (3),		/* Sector */
		@Aux_ActINE	varchar(10),	/* Actividad INEGI */	
		@Aux_Locali	char(8),		/* Localidad */
		@Aux_Entida char(3),		/* Entidad */
		@Aux_Nacion char(3),		/* Nacionalidad */
		@Aux_CodPos char(6),		/* Codigo Postal */
		@Aux_PerNum char(8),		/* Numero persona */
		@Aux_CLPAGECL int			/* Bandera para validar CURP*/

/*	Declaracion de Constantes	*/
declare	@Fec_Vacia	smalldatetime,
        @Str_Vacio	char(1),		
		@Str_Espaci	char(1),
		@Str_DobEsp char(2),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ban_Electr	char(2),
		@Ban_NueBan	char(2),
		@Pro_Intern	char(2),
		@Tip_CueChe	char(2),
		@Tip_CliNom	char(2),
		@Tip_Benefi	char(1),
		@Tip_ProRec	char(1),
		@Tip_ProRea	char(1),
		@Tip_TerAut	char(1),
		@Tip_ApPrRe	char(1),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Per_PaiMex	char(3),
		@Tip_Apode	char(1),
		@Tip_Hered	char(1),
		@RFC_PMExtr	char(12),
		@Tip_Titula char(1),
		@Str_No12	char(6),
		@Str_23		char(4),
		@Mod_FabCon char(2),
		@Sta_Inacti	char(1),
		@Loc_Pais 	char(3),
		@Mod_AplOnl char(2),
		@Tip_PerNum char(1),
		@Ent_180	int,
		@Ent_40		int,
		@Validacion_CURP varchar(14)


select	@Fec_Vacia	= '1900-01-01',	/*	Fecha Vacía*/
		@Str_Vacio	= '',			/*	String Vacio	*/
		@Str_Espaci	= ' ',			/*	String Espacio	*/
		@Str_DobEsp	= '  ',			/*	String Doble Espacio	*/
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS */
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1,			/* Entero en Uno */
		@Ban_Electr	= 'BE',			/* Banca Elctronica */
		@Ban_NueBan	= 'NB',			/* Nueva Banca Electrónica */
		@Pro_Intern	= 'IT',			/* Proceso de Internacional			*/
		@Tip_CueChe	= 'CH',			/* Proceso: Personas relacionadas a Cuenta de cheques*/
		@Tip_CliNom	= 'CN',			/* Proceso: Clientes de Nomina		*/
		@Tip_Benefi	= '4',			/* Beneficiario						*/
		@Tip_ProRec	= '5',			/* Proveedor de Recursos			*/
		@Tip_ProRea	= '6',			/* Propietario Real					*/
		@Tip_TerAut	= '7',			/* Tercero Autorizado				*/
		@Tip_ApPrRe	= '8',			/* Apoderado del Porpietario Real	*/
		@Str_Si		= 'S',			/* String Si						*/
		@Str_No		= 'N',			/* String No						*/
		@Per_PaiMex	= '001',		/* Pais de Nacionalidad: Mexico		*/
		@Tip_Apode	= '2',			/* Apoderado de la Cuenta para Personas Morales de CHCOTBEN	*/
		@Tip_Hered	= 'H',			/* Tipo herederos legales */
		@RFC_PMExtr	= 'EXT990101NI9', /* Rfc para Persona MOral Extranjera */	
		@Tip_Titula	= '1',
		@Str_No12	= '[^12]',
	 	@Str_23		= '[23]',
	 	@Mod_FabCon = 'FB',			/* Modulo de Fabrica de Crédito al Consumo */
	 	@Sta_Inacti	= 'I',			/* Status Inactivo para validar localidad y entidad */
		@Mod_AplOnl	= 'OL',			/* Modulo de Aplicaciones Online*/		
		@Tip_PerNum = 'F',			/*  Tipo proceso para actualizar el numero de folio*/
		@Ent_180 	= 180,			/* Numero 180*/
		@Ent_40 	= 40,			/* Numero 40*/
		@Validacion_CURP = 'ValidacionCURP'

if @Modulo in (@Mod_AplOnl) begin

	select	@Per_Nacion = Par_PaiNac,
			@Per_ActEmp	= Par_ActEmp,
			@Per_Tipo	= Par_TipPer,
			@Per_Titulo	= Par_Titulo,
			@Cob_Tipo	= Par_PerCob
	  from OLPARAMS noholdlock
	 where Par_Modulo	= @Mod_AplOnl

	select	@Per_Sector	= @Str_Vacio,
			@Per_Activi	= @Str_Vacio,
			@Per_ActINE	= @Str_Vacio,
			@Per_ApaPos	= @Str_Vacio,
			@Per_ComDom	= @Str_Vacio,
			@Per_EstCiv	= @Str_Vacio,
			@Per_Giro	= @Str_Vacio
			
end	

if @Cob_Tipo	= @Tip_Titula begin
	select	@Tel_Comple	= isnull(ltrim(rtrim(@Per_LadTel)) + ltrim(rtrim(@Per_Telefo)),@Str_Vacio)
	select	@Lon_Telefo	= char_length(@Tel_Comple)

	if @Modulo not in (@Mod_FabCon,@Pro_Intern) begin	
		if @Lon_Telefo <> 10 begin
			select 	Err_Codigo = '000024',
					Err_Mensaj = 'LADA ó Teléfono Incorrecto, favor de verificarlos'				
			rollback
			return @Ent_Uno
		end
	end
end

if @Cob_Tipo	= @Tip_Titula and @Tip_Proces = @Tip_CueChe begin
	select	@Err_Descri	= ' del Cliente'
end else begin
	select	@Err_Descri	= @Str_Vacio
end

/* Estructura Basica para el SOPERSON*/
if (@Per_Tipo like @Str_No12) begin
	
	if @Cob_Tipo	<> @Tip_Titula begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Tipo de Persona incorrecto',
				Err_Variab	= 'Per_Tipo'
		rollback
		return @Ent_Uno
	end else begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Tipo de Cliente incorrecto',
				Err_Variab	= 'Per_Tipo'
		rollback
		return @Ent_Uno
	end
end

if (@Per_Tipo = @Per_Moral) and (@Per_RazSoc = @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Proporcione la Razon social' + @Err_Descri,
			Err_Variab	= 'Per_RazSoc'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo like @Str_23) and (@Per_Nombre = @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Proporcione el Nombre' + @Err_Descri,
			Err_Variab	= 'Per_Nombre'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo like @Str_23) and (@Per_ApePat = @Str_Vacio) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Proporcione el Apellido paterno' + @Err_Descri,
			Err_Variab	= 'Per_ApePat'
	rollback
	return @Ent_Uno
end
if (@Per_Tipo like @Str_23) and (@Per_ApeMat = @Str_Vacio) and @Cob_Tipo <> @Tip_Hered begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Proporcione el Apellido materno' + @Err_Descri,
			Err_Variab	= 'Per_ApeMat'
	rollback
	return @Ent_Uno
end

if @Per_Tipo = @Per_Moral and @Per_RFC = @Str_Vacio begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Proporcione el RFC' + @Err_Descri,
			Err_Variab	= 'Per_RFC'
	rollback
	return @Ent_Uno
end

/* Si no se captura el RFC debe armarse su estructura a apartir de su nombre y Fecha de nacimiento*/
if (@Per_Tipo like @Str_23) and @Per_RFC = @Str_Vacio begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Proporcione el RFC o la fecha de Nacimiento' + @Err_Descri,
			Err_Variab	= 'Per_RFC'
	rollback
	return @Ent_Uno
end

if @Per_RFC <> @Str_Vacio begin
    select @Per_RFC = UPPER(@Per_RFC)
end

if (Convert(int, @Per_Numero) > @Ent_Cero) begin

	select	@Aux_PerNum = Per_Numero
		from SOPERSON noholdlock
		where	Per_Numero	= @Per_Numero

		if @Aux_PerNum <> @Str_Vacio begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'La persona ya existe',
				Err_Variab	= 'Per_Numero'
		rollback
		return @Ent_Uno
	end
end


/* Validar que la Localidad y la Entidad a dar de alta estan activos */

select @Sta_Locali = Loc_Status,
	   @Loc_Pais   = Loc_Pais
	from CLLOCALI noholdlock
where Loc_Numero	= @Per_Locali
and	  Loc_Entida	= @Per_Entida

select @Sta_Entida = Ent_Status
	from CLENTIDA noholdlock
where Ent_Numero	= @Per_Entida
and	  Ent_Pais 	    = @Loc_Pais

if @Sta_Locali = @Sta_Inacti begin
	select	Err_Codigo	= '000024',
			Err_Mensaj	= 'La Localidad que intenta guardar esta Inactiva',
			Err_Variab	= 'Cli_Locali'
	rollback
	return @Ent_Uno
end
if @Sta_Entida = @Sta_Inacti begin
	select	Err_Codigo	= '000025',
			Err_Mensaj	= 'La Entidad que intenta guardar esta Inactiva',
			Err_Variab	= 'Cli_Entida'
	rollback
	return @Ent_Uno
end	


/* Hasta aqui estructura Basica para el SOPERSON*/

if (@Modulo not in (@Ban_Electr, @Ban_NueBan)) and (@Tip_Proces = @Tip_CueChe and @Cob_Tipo <> @Tip_ApPrRe) begin
	if	@Tip_Proces <> @Tip_CueChe or(@Tip_Proces = @Tip_CueChe and @Per_Nacion = @Per_PaiMex and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered)) begin
		select	@PerExist	= Per_Numero
			from SOPERSON noholdlock
			where	Per_RFC		= @Per_RFC
			  and	Per_Nacion	= @Per_PaiMex
			  and	(Per_Tipo	= @Per_Moral
			  or	(Per_Tipo	= @Per_Fisica
			  and	Per_ActEmp	= @Str_Si))

		select	@PerExist	= isnull(@PerExist, @Str_Vacio)

		if @PerExist <> @Str_Vacio begin
			select	Err_Codigo	= '000010',
					Err_Mensaj	= 'La persona ' + @PerExist + ' ya tiene este RFC. (Alta)',
					Err_Variab	= 'Per_RFC'
			rollback
			return @Ent_Uno
		end
	end	

	if @Per_Sector <> @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) and (@Tip_Proces != @Pro_Intern) begin
		select	@Aux_Sector	= Sec_Numero
							from CLSECTOR noholdlock
							where	Sec_Numero	= @Per_Sector
		if isnull( @Aux_Sector, @Str_Vacio)  = @Str_Vacio begin
			select	Err_Codigo	= '000012',
					Err_Mensaj	= 'Proporcione el sector' + @Err_Descri,
					Err_Variab	= 'Per_Sector'
			rollback
			return @Ent_Uno
		end
	end

	if @Per_Activi <> @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) begin

		select	@Act_Numero	= Act_Numero,
				@Act_Status	= Act_Status,
				@Act_ActReg	= Act_ActReg
			from CLACTIVI noholdlock
			where	Act_Numero	= @Per_Activi

		select	@Act_Numero	= isnull(@Act_Numero, @Str_Vacio)

		if @Act_Numero = @Str_Vacio begin
			select	Err_Codigo	= '000013',
					Err_Mensaj	= 'Proporcione la Actividad' + @Err_Descri,
					Err_Variab	= 'Per_Activi'
			rollback
			return @Ent_Uno
		end

		if @Act_Status = @Sta_ActIna begin
			select	Err_Codigo	= '000014',
					Err_Mensaj	= 'La actividad' + @Err_Descri + ' esta inactiva',
					Err_Variab	= 'Per_Activi'
			rollback
			return @Ent_Uno
		end

		if @Per_Tipo = @Per_Fisica and @Per_ActEmp in (@Str_No, @Str_Si) begin
			if isnull(@Act_ActReg, '') <> '04' begin
				select	Err_Codigo	= '000026',
						Err_Mensaj	= 'Personas fisicas solo pueden registrar actividades de tipo comercial',
						Err_Variab	= 'Per_Activi'
				rollback
				return @Ent_Uno
			end
		end
	end

	if @Per_ActINE <> @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) and (@Tip_Proces != @Pro_Intern) begin
		
		select	@Aux_ActINE	= Act_Numero
			from CLACTINE noholdlock
			where	Act_Numero	= @Per_ActINE

		if isnull(@Aux_ActINE, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000015',
					Err_Mensaj	= 'La actividad INEGI' + @Err_Descri + ' no existe' + @Per_ActINE + 'VACIO',
					Err_Variab	= 'Per_ActINE'
			rollback
			return @Ent_Uno
		end
	end
	
	if @Per_Nacion = @Per_PaiMex and @Cob_Tipo not in (@Tip_Apode,@Tip_Hered) begin
		if @Per_Calle = @Str_Vacio begin
			select	Err_Codigo	= '000016',
					Err_Mensaj	= 'Proporcione la calle del domicilio' + @Err_Descri,
					Err_Variab	= 'Per_Calle'
			rollback
			return @Ent_Uno
		end
		if @Per_CalNum = @Str_Vacio begin
			select	Err_Codigo	= '000017',
					Err_Mensaj	= 'Proporcione el numero del Domicilio' + @Err_Descri,
					Err_Variab	= 'Per_CalNum'
			rollback
			return @Ent_Uno
		end

		select	@Aux_Locali = Loc_Numero
							from CLLOCALI noholdlock
							where	Loc_Numero	= @Per_Locali
							and		Loc_Entida	= @Per_Entida
		if isnull(@Aux_Locali, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000018',
					Err_Mensaj	= 'La ciudad' + @Err_Descri + ' no existe' + @Per_Locali,
					Err_Variab	= 'Per_Locali'
			rollback
			return @Ent_Uno
		end
		
		select @Per_Pais = Loc_Pais
			from CLLOCALI noholdlock
				where Loc_Numero = @Per_Locali
				and	  Loc_Entida = @Per_Entida
		
		select	@Aux_Entida = Ent_Numero
			from CLENTIDA noholdlock
			where	Ent_Numero	= @Per_Entida
			and 	Ent_Pais 	= @Per_Pais

		if isnull(@Aux_Entida, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000019',
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

		if (@Per_Tipo like @Str_23) and isnull(@Aux_Nacion, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000020',
					Err_Mensaj	= 'Nacionalidad' + @Err_Descri + ' Incorrecta',
					Err_Variab	= 'Per_Nacion'
			rollback
			return @Ent_Uno
		end
	end
	if	@Tip_Proces = @Tip_CueChe and @Cob_Tipo not in (@Tip_Apode,@Tip_Hered) begin

		select	 @Aux_CodPos = isnull(Cpc_Numero, @Str_Vacio)
			from CLCODPOS noholdlock
			where	Cpc_Entida	= @Per_Entida
				and	Cpc_Locali	= @Per_Locali
				and	Cpc_CodPos	= @Per_CodPos
				
		if (@Per_CodPos = @Str_Vacio or @Aux_CodPos = @Str_Vacio) and @Per_Nacion = @Per_PaiMex begin

			select	Err_Codigo	= '000021',
					Err_Mensaj	= 'Código Postal' + @Err_Descri + ' Incorrecto',
					Err_Variab	= 'Per_CodPos'
			rollback
			return @Ent_Uno
		end

		if @Modulo not in (@Mod_AplOnl) begin
			if @Per_ComDom = @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_CliNom,@Tip_Apode) begin
				select	Err_Codigo	= '000022',
						Err_Mensaj	= 'Comprobante de domicilio' + @Err_Descri + ' incorrecto',
						Err_Variab	= 'Per_ComDom'
				rollback
				return @Ent_Uno
			end
			if (@Per_Tipo like @Str_23) and (@Per_EstCiv = @Str_Vacio) and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_Apode) begin
				select	Err_Codigo	= '000023',
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


/***************************************************************/	
/*       VALIDAR QUE LA CURP PROPORCIONADA SEA VALIDA          */
/***************************************************************/

/*Buscar en CLPAGECL*/
select @Aux_CLPAGECL = convert(int, Pgc_Valor)
    from CLPAGECL noholdlock 
    where Pgc_Nombre = @Validacion_CURP

/* Normalización CURP en mayúsculas - Solo para personas físicas */
if @Per_Tipo <> @Per_Moral begin
	select @Per_CURP = UPPER(@Per_CURP)
end

/*Validar si la Validacion de CURP esta activa*/
if(@Aux_CLPAGECL= @Ent_Uno)begin
	--Validamos que tenga algo en la CURP
	if(@Per_CURP <> @Str_Vacio) begin
		exec @Status = CLCURCLIVAL
			@Per_CURP,  '', '', 1,	@NumTransac, 	
			@Transaccio,	@Usuario,   	@FechaSis,  	@SucOrigen, 	@SucDestino,	
			@Modulo
			
		if @Status <> @Ent_Cero begin
			rollback
			return @Ent_Uno
		end	
	end
end
/***************************************************************/

insert into SOPERSON (
	Per_Numero, Per_Fecha,  Per_NumTra, Per_Tipo,   Per_Benefi,
	Per_NuSeFi, Per_Titulo, Per_Nombre, Per_ApePat, Per_ApeMat,
	Per_RazSoc, Per_Comple, Per_ComOrd, Per_RFC,    Per_CURP,
	Per_Calle,  Per_CalNum, Per_Coloni, Per_Entida, Per_Locali,
	Per_CodPos, Per_ApaPos, Per_LadTel, Per_Telefo, Per_Email,
	Per_ComDom, Per_EstCiv, Per_Nacion, Per_ActEmp, Per_Giro,
	Per_Sector, Per_Activi, Per_ActINE, NumTransac, Transaccio,
	Usuario,	FechaSis,   SucOrigen,  SucDestino) 
	values	(
	@Str_Vacio,	    @Per_Fecha,		@Per_NumTra,	@Per_Tipo,		@Per_Benefi,	
	@Per_NuSeFi,	@Per_Titulo,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,
	@Per_RazSoc,	@Per_Comple,	@Per_ComOrd,	@Per_RFC,		@Per_CURP,
	@Per_Calle,		@Per_CalNum,	@Per_Coloni,	@Per_Entida,	@Per_Locali,	
	@Per_CodPos,	@Per_ApaPos,	@Per_LadTel,	@Per_Telefo,	@Per_Email,		
	@Per_ComDom,	@Per_EstCiv,	@Per_Nacion,	@Per_ActEmp,	@Per_Giro,		
	@Per_Sector,	@Per_Activi,	@Per_ActINE,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @PerPersoID = @@identity

select	@Per_Numero	= right('00000000' + ltrim(rtrim(convert(char, @PerPersoID))), 8)

if @Per_Numero = @Str_Vacio begin
		rollback
		return @Ent_Uno
end

--Si el nombre o apellidos excede los 40 caracteres se guarda en la tabla de nombres largos
if char_length(@Per_Nombre) > @Ent_40 or char_length(@Per_ApePat) > @Ent_40  or char_length(@Per_ApeMat) > @Ent_40 begin
	exec @Status = SONOMLARALT 
		@PerPersoID,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
	    @Per_Comple,	@Per_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
	    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
end

--Si el nombre completo excede los 180 caracteres se guarda en la tabla de nombres largos
if char_length(@Per_Comple) > @Ent_180 or char_length(@Per_RazSoc) > @Ent_180 begin
	exec @Status = SONOMLARALT 
		@PerPersoID,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
	    @Per_Comple,	@Per_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
	    @FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
end

exec @Status = SOPERSONPRO		
			@Per_Numero, @Str_Vacio,  @Str_Vacio,  @Str_Vacio, @Str_Vacio,
			@Fec_Vacia,  @Str_Vacio,  @Str_Vacio,  @Fec_Vacia, @Str_Vacio,
			@Str_Vacio,  @Str_Vacio,  @Fec_Vacia,  @Str_Vacio, @Str_Vacio,
			@Tip_PerNum, @NumTransac, @Transaccio, @Usuario,   @FechaSis,
			@SucOrigen,  @SucDestino, @Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
exec @Status =  SOUNIPERPRO
	@Per_Numero,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo

	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

select	@Act_ActPre	= @Ent_Cero	
select	@Act_ActPre	= isnull(Apc_ActPre, @Ent_Cero)
	from SOACPRCL noholdlock
	where Apc_Activi = @Per_Activi
	
exec @Status	= SOPEINCOALT
	@PerPersoID,	@Act_ActPre,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro agregado ',
			Per_Numero	= @Per_Numero,
			Per_Fecha	= @Per_Fecha,
			Per_NumTra	= @Per_NumTra