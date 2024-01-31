create procedure SOPERUNIACT (
	@Per_Numero	char(8),
	@Per_Fecha	smalldatetime,
	@Per_NumTra	char(10),
	@Per_Tipo	char(1),
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
	@Per_LadTel	varchar(8),
	@Per_Telefo	char(15),
	@Per_Email	varchar(50),
	@Per_EstCiv	varchar(20),
	
	@Per_ActEmp char(1),
	@Per_Sector	char(3),
	@Per_Activi	char(10),
	@Adi_FecNac	smalldatetime,
	@Adi_Fax	varchar(20),
	
	@Adi_Ocupac	varchar(50),
	@Adi_TelTra	varchar(20),
	@Adi_FecCon	smalldatetime,
	@Adi_Sexo char(1),
	@Adi_LugNac varchar(50),
	@Adi_TipIde char(1),
	@Adi_NumIde varchar(30),
	@Adi_NacExt char(1),
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as
/*******************************************************************
*** DESCRIPCION: Actualiza Datos de Persona Unificada			  **
********************************************************************
*** REFERENCIAS: 												  **
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		10/01/2024										****
** Help: 		36841 											****
** Descripcion:	Se aumenta el tamaño de los campos de nombre	****
**				se agrega validacion si el nombre excede 180	****
**				caracteres se guarda en la tabla de nombres largos**
********************************************************************
** Modifico:	Erika Báez										****
** Fecha:		26/Junio/2019									****
** Help:		1215830											****
** Descripcion:	Tipo de actualizacion de tarjetas adicionales 	****
**				@Act_TarAdi										****
********************************************************************
** Modifico:	Esthepny Aguilar								****
** Fecha:		18/Septiembre/18								****
** Help:		1134677											****
** Descripcion:	Tipo de actualizacion @Act_GenPer incluye 		****
**              Adi_TipIde, Adi_NumIde y Adi_NacExt				****
********************************************************************
** Modifico:	Ricardo Garcia Cerda							****
** Fecha:		15/Agosto/17									****
** Help:		929417											****
** Descripcion:	Tipo de actualizacion @Act_PerSb3 incluye 		****
**              Adi_Sexo y Adi_LugNac							****
********************************************************************
** Modifico:	Armando Alexis Sepúlveda Cruz					****
** Fecha:		26/Junio/2017									****
** Help:		991811											****
** Descripcion: Se elimina la concatenación de Per_Titulo en 	****
**				Per_ComOrd										****
********************************************************************
** Modifica:	Benjamín Eduardo García Villegas				****
** Fecha:		11/Abril/16										****
** Help:		856451											****
** Descripcion:	Tipo de actualizaciÃ³n @Act_PerCRM incluye 		****
**              Adi_TelTra y Adi_FecCon							****
********************************************************************
** Modifica:	Benjamín Eduardo García Villegas				****
** Fecha:		02/Mar/16										****
** Help:		846999											****
** Descripcion:	Agrega actualizacion para CRM					****
********************************************************************
** Modifica:	Claudia V Sandoval P							****
** Fecha:		21/Sep/15										****
** Help:		0805477											****
** Descripcion:	Agrega actualizacion para NEC					****
********************************************************************
** Creo:		Claudia V Sandoval P							****
** Fecha:		18/Mar/15										****
** Help:		0744849											****
*******************************************************************/
declare	@Per_Comple	varchar(254),	/*	Declaracion de Variables	*/
		@Per_ComOrd	varchar(254),	/* Persona nombre Ordenado*/
		@Per_ActINE	char(6),		/* Persona Actividad según INEGI */
		@Per_Titulo varchar(10),	/* Persona titulo */
		@Status		int,			/* Status */
		@Bit_Fecha	smalldatetime,	/* Bitacora Fecha */
		@Bit_NumTra	char(10),		/* Bitacora Numero de transaccion */
		@Bit_Tipo	char(1),		/* Bitacora tipo */
		@Bit_NuSeFi	varchar(30),	/* Bitacora Numero de serie de la Firma Electronica Avanzada */
		@Bit_Titulo	varchar(10),	/* Bitacora titulo */
		@Bit_Nombre	varchar(40),	/* Bitacora Nombre */
		@Bit_ApePat	varchar(40),	/* Bitacora apellido paterno */
		@Bit_ApeMat	varchar(40),	/* Bitacora Apellido Materno */
		@Bit_RazSoc	varchar(254),	/* Bitacora Razon social */
		@Bit_Comple	varchar(254),	/* Bitacora nombre completo */
		@Bit_ComOrd	varchar(254),	/* Bitacora nombre ordenado */
		@Bit_RFC	char(15),		/* Bitacora RFC */
		@Bit_CURP	char(18),		/* Bitacora CURP */
		@Bit_Calle	char(40),		/* Bitacora Calle */
		@Bit_CalNum	varchar(10),	/* Bitacora Calle numero */
		@Bit_Coloni	varchar(150),	/* Bitacora Colonia */
		@Bit_Entida	char(3),		/* Bitacora Identidad */
		@Bit_Locali	char(8),		/* Bitacora Localidad */
		@Bit_CodPos	char(6),		/* Bitacora Codigo Postal */
		@Bit_ApaPos	char(6),		/* Bitacora Apartado Postal */
		@Bit_LadTel	varchar(5),		/* Bitacora lada telefono */
		@Bit_Telefo	char(15),		/* Bitacora telefono */
		@Bit_Email	varchar(50),	/* Bitacora email */	
		@Bit_ComDom	char(1),		/* Bitacora Comprobante de domicilio */
		@Bit_EstCiv	varchar(20),	/* Bitacora Estado civil */
		@Bit_Nacion	char(3),		/* Bitacora nacionalidad */
		@Bit_ActEmp	char(1),		/* Bitacora Actividad Empresarial */
		@Bit_Giro	char(30),		/* Bitacora giro */

		@Bit_Sector	char(3),		/* Bitacora sector */
		@Bit_Activi	char(10),		/* Bitacora actividad */
		@Bit_ActINE	varchar(10),	/* Bitacora Actividad según INEGI */	
		@Bit_LugNac	varchar(50),	/* Bitacora Lugar Nacimiento */
		@Bit_Sexo	char(1),		/* Bitacora Sexo */
		@Bit_FecNac	smalldatetime,	/* Bitacora Fecha Nacimiento */
		@Bit_RegMat	char(1),		/* Bitacora Rrgimen matrimonial Mancomunados, Separados */
		@Bit_VivCas	char(1),		/* Bitacora Vive en casa  Propia, Renta , Casa*/
		@Bit_TieRes	int,			/* Bitacora Tiempo de residencia */
		@Bit_Fax    varchar(20),	/* Bitacora Fax */
		@Bit_NumDep	int,			/* Bitacora Numero de dependientes */
		@Bit_Puesto	varchar(50),	/* Bitacora Puesto */
		@Bit_Ocupac	varchar(50),	/* Bitacora Ocupacion */
		@Bit_AntLab	int,			/* Bitacora Antiguedad laboral  */
		@Bit_LugTra	varchar(50),	/* Bitacora Lugar trabajo */
		@Bit_TelTra	varchar(20),	/* Bitacora Telefono trabajo */
		@Bit_CalTra	varchar(20),	/* Bitacora Calle de Trabajo */
		@Bit_NuCaTr	varchar(30),	/* Bitacora Numero de calle del  Trabajo*/
		@Bit_ColTra	varchar(50),	/* Bitacora Numero trabajo */
		@Bit_CPTra	varchar(50),	/* Bitacora Codigo postal trabajo */
		@Bit_FecCon	smalldatetime,	/* Bitacora Fecha  */
		@Bit_CaNuIn	varchar(10),	/* Bitacora Numero ineterior */
		@Bit_NacExt	char(1),		/* Bitacora Nacionalidad Extranjera */
		@Bit_Reside char(1),		/* Bitacora Recidente */
		@Bit_DocEst	char(3),		/* Bitacora Documento  */
		@Bit_OtDoEs varchar(50),	/* Bitacora Otro Documento que Acredita Estancia Legal */
		@Bit_FeExDo	smalldatetime,	/* Bitacora Fecha de expiracion o expedicion del documento que acredita la estancia legal */
		@Bit_CalInm	char(1),		/* Bitacora  Calidad de Inmigrante */
		@Bit_CalExt	varchar(40),	/* Bitacora Calle  del Domicilio en el extranjero en caso de extranjero */
		@Bit_CaNuEx	varchar(10),	/* Bitacora Calle numero exteriro */
		@Bit_ColExt	varchar(150),	/* Bitacora Colonia Extranjero */
		@Bit_LocExt	varchar(40),	/* Bitacora Localidad Extranjero */
		@Bit_EntExt	varchar(40),	/* Bitacora Entidad Extranjero */
		@Bit_PaiExt	varchar(3),		/* Bitacora Pais Extranjero */
		@Bit_CoPoEx	char(6),		/* Bitacora Codigo Postak Extranjero */
		@Bit_TipIde	char(1),		/* Bitacora Tipo de identificacion */
		@Bit_OtrIde	varchar(50),	/* Bitacora Otra identificacion */
		@Bit_NumIde	varchar(30),	/* Bitacora numero identificacion */
		@Bit_FeExId	smalldatetime,	/* Bitacora Fecha de expedicion de la identificacion */
		@Bit_FeVeId	smalldatetime,	/* Bitacora Fecha de vencimiento de la identificacion */
		@Bit_NuIdFi	varchar(20),	/* Bitacora Numero de Identificacion Fiscal */
		@Bit_EntPri char(40), 		/* Bitacora Entre Calle Primera */
		@Bit_EntSeg char(40),		/* Bitacora Entre Calle Segunda */
		@PerPersoID int

declare	@Str_Vacio	char(1),	/*	Declaracion de Constantes	*/
		@Per_Moral	char(1),	/* Persona Moral */
		@Str_23		char(4),	/* Cadena 23 */
		@Ent_Cero	int,		/* Numero entero 0 */
		@Fec_Vacia	smalldatetime,	/* Fecha vacia */
		@Act_PerIW	char(1),		/* Actualizacion persona IW */
		@Act_PerNEC	char(1),		/* Actualizacion persona NEC */
		@Str_Vacios	char(10),		/* Cadena vacia */
		@Act_PerCRM char(1),		/* Actualizacion persona CRM */
		@Act_PerSb3 char(1),		/* Actualizacion persona SB3 */
		@Act_GenPer char(1),		/* Actualizacion para generacion de persona */
		@Str_Vacio1 char(1),		/* Cadena vacia con un espacio */
		@Act_TarAdi	char(1),		/*Actualizacion tarjetas adicionales*/
		@Ent_Uno	int,
		@Ent_180	int

select	@Str_Vacio	= '',			/* String Vacio	*/
		@Per_Moral	= '1',			/* Persona Moral */
		@Ent_Cero	= 0,			/* Entero en Cero */
	 	@Str_23		= '[23]',		/*String 2 3*/
	 	@Fec_Vacia	= '1900-01-01',	/*Fecha Vacia*/
		@Act_PerIW	= 'A',			/*Actualizacion persona IW*/
		@Act_PerNEC	= 'B',			/*Actualizacion persona NEC*/
		@Act_PerCRM	= 'C',			/*Actualizacion persona CRM*/
		@Str_Vacios	= '',			/*String vacio*/
		@Act_PerSb3 = 'D',			/*Actualizacion persona SB3*/
		@Act_GenPer = 'G',			/*Actualizacion para generacion de persona */
		@Str_Vacio1 = ' ',			/*String vacio*/
		@Act_TarAdi	= 'H',			/*Actualizacion tarjetas adicionales*/
		@Ent_Uno	= 1,
		@Ent_180	= 180

if not exists (	select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Per_Numero ) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La persona no existe',
			Err_Variab	= 'Per_RazSoc'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo = @Per_Moral) and (@Per_RazSoc = @Str_Vacio) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Proporcione la Razon social'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo like @Str_23) and (@Per_Nombre = @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Proporcione el Nombre'
	rollback
	return @Ent_Uno
end

if (@Per_Tipo like @Str_23) and (@Per_ApePat = @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Proporcione el Apellido paterno'
	rollback
	return @Ent_Uno
end

if @Per_Tipo = @Per_Moral and @Per_RFC = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Proporcione el RFC'
	rollback
	return @Ent_Uno
end

select	@Per_Titulo = Per_Titulo,
		@PerPersoID = PerPersoID
	from SOPERSON noholdlock
	where	Per_Numero	= @Per_Numero
	  and	Per_NumTra	= @Per_NumTra
	  and	Per_Fecha	= @Per_Fecha

if (@NumTransac =  @Str_Vacio or isnull(@NumTransac, @Str_Vacio) = @Str_Vacio) begin /***** Genera el @NumTransac *****/
	exec @Status = SYINITRANSA
		@NumTransac output,	@SucOrigen
	if @Status <> 0 begin
		rollback
		return @Ent_Uno
	end
end

if @FechaSis = @Fec_Vacia
	select	@Fec_Vacia = getdate()

if not exists (	select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Per_Numero
					  and	Per_NumTra	= @Per_NumTra
					  and	Per_Fecha	= @Per_Fecha ) begin

	select	@PerPersoID = PerPersoID,
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

	exec @Status = SOBITPERALT
		@Per_Numero,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
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

	select	@Bit_Fecha	= Adi_Fecha,
			@Bit_NumTra	= Adi_NumTra,
			@Bit_LugNac	= Adi_LugNac,
			@Bit_Sexo	= Adi_Sexo,
			@Bit_FecNac	= Adi_FecNac,
			@Bit_RegMat	= Adi_RegMat,
			@Bit_VivCas	= Adi_VivCas,
			@Bit_TieRes	= Adi_TieRes,
			@Bit_Fax	= Adi_Fax,
			@Bit_NumDep	= Adi_NumDep,
			@Bit_Puesto	= Adi_Puesto,
			@Bit_Ocupac	= Adi_Ocupac,
			@Bit_AntLab	= Adi_AntLab,
			@Bit_LugTra	= Adi_LugTra,
			@Bit_TelTra	= Adi_TelTra,
			@Bit_CalTra	= Adi_CalTra,
			@Bit_NuCaTr	= Adi_NuCaTr,
			@Bit_ColTra	= Adi_ColTra,
			@Bit_Locali	= Adi_Locali,
			@Bit_CPTra	= Adi_CPTra,
			@Bit_FecCon	= Adi_FecCon,
			@Bit_CaNuIn	= Adi_CaNuIn,
			@Bit_NacExt	= Adi_NacExt,
			@Bit_Reside	= Adi_Reside,
			@Bit_DocEst	= Adi_DocEst,
			@Bit_OtDoEs	= Adi_OtDoEs,
			@Bit_FeExDo	= Adi_FeExDo,
			@Bit_CalInm	= Adi_CalInm,
			@Bit_CalExt	= Adi_CalExt,
			@Bit_CaNuEx	= Adi_CaNuEx,
			@Bit_ColExt	= Adi_ColExt,
			@Bit_LocExt	= Adi_LocExt,
			@Bit_EntExt	= Adi_EntExt,
			@Bit_PaiExt	= Adi_PaiExt,
			@Bit_CoPoEx	= Adi_CoPoEx,
			@Bit_TipIde	= Adi_TipIde,
			@Bit_OtrIde	= Adi_OtrIde,
			@Bit_NumIde	= Adi_NumIde,
			@Bit_FeExId	= Adi_FeExId,
			@Bit_FeVeId	= Adi_FeVeId,
			@Bit_NuIdFi	= Adi_NuIdFi,
			@Bit_EntPri	= Adi_EntPri,
			@Bit_EntSeg	= Adi_EntSeg
		from SOPERADI noholdlock
		where	Adi_PerNum	= @Per_Numero

		exec @Status =	SOBIPEADALT
			@Per_Numero,	@Bit_Fecha,		@Bit_NumTra,	@Bit_LugNac,	@Bit_Sexo,
			@Bit_FecNac,	@Bit_RegMat,	@Bit_VivCas,	@Bit_TieRes,	@Bit_Fax,
			@Bit_NumDep,    @Bit_Puesto,	@Bit_Ocupac,	@Bit_AntLab,	@Bit_LugTra,
			@Bit_TelTra,	@Bit_CalTra,	@Bit_NuCaTr,	@Bit_ColTra,	@Bit_Locali,
			@Bit_CPTra,		@Bit_FecCon,	@Bit_CaNuIn,	@Bit_NacExt,	@Bit_Reside,
			@Bit_DocEst,	@Bit_OtDoEs,	@Bit_FeExDo,	@Bit_CalInm,	@Bit_CalExt,
			@Bit_CaNuEx,	@Bit_ColExt,	@Bit_LocExt,	@Bit_EntExt,	@Bit_PaiExt,
			@Bit_CoPoEx,	@Bit_TipIde,	@Bit_OtrIde,	@Bit_NumIde,	@Bit_FeExId,
			@Bit_FeVeId,	@Bit_NuIdFi,	@Bit_EntPri,	@Bit_EntSeg,	@NumTransac,
			@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
			@Modulo

		if @Status <> 0 begin
			rollback
			return @Ent_Uno
		end
end

if @Per_Tipo = @Per_Moral begin
	select	@Per_Comple	= LTrim(RTrim(@Per_RazSoc))
	select	@Per_ComOrd	= LTrim(RTrim(@Per_RazSoc))
end else begin
	select	@Per_Comple	= LTrim(RTrim(@Per_ApePat)) + @Str_Vacio1 + LTrim(RTrim(@Per_ApeMat)) + @Str_Vacio1 + LTrim(RTrim(@Per_Nombre))
	select	@Per_ComOrd	= LTrim(RTrim(@Per_Nombre)) + @Str_Vacio1 + LTrim(RTrim(@Per_ApePat)) + @Str_Vacio1 + LTrim(RTrim(@Per_ApeMat))
end

/* Actividad de Inegi */ 
if isnull(@Per_Activi, @Str_Vacio) != @Str_Vacio begin
	select @Per_ActINE	= Act_NumINE 
	  from CLACTIVI noholdlock
	 where Act_Numero	= @Per_Activi
end

select	@Per_ActINE	= isnull(@Per_ActINE, @Str_Vacio)

/* Datos Personales */
if @Tip_Actual = @Act_PerIW begin

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
		Per_Tipo	= @Per_Tipo,
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
		Per_EstCiv	= @Per_EstCiv,
		Per_ActEmp	= @Per_ActEmp,
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

	/* Datos Adicionales */
	update SOPERADI set
		Adi_Fecha	= @Per_Fecha,
		Adi_NumTra	= @Per_NumTra,
		Adi_FecNac	= @Adi_FecNac,
		Adi_FecCon	= @Adi_FecCon,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero
end

/* Datos Personales */
if @Tip_Actual = @Act_PerNEC begin

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
		Per_Calle	= @Per_Calle,
		Per_CalNum	= @Per_CalNum,
		Per_Coloni	= @Per_Coloni,
		
		Per_Entida	= @Per_Entida,
		Per_Locali	= @Per_Locali,
		Per_CodPos	= @Per_CodPos,
		Per_LadTel	= @Per_LadTel, 
		Per_Telefo	= @Per_Telefo, /* telefono de casa */
		
		Per_Email	= @Per_Email,
		Per_EstCiv	= @Per_EstCiv,
		Per_ActEmp	= @Per_ActEmp,
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

	/* Datos Adicionales */
	update SOPERADI set
		Adi_Fecha	= @Per_Fecha,
		Adi_NumTra	= @Per_NumTra,
		Adi_Fax		= @Adi_Fax,     /* Telefono Celular */
		Adi_Ocupac	= @Adi_Ocupac, /* actividad especifica */
		Adi_TelTra	= @Adi_TelTra,  /* Telefono Oficina: lada, tel y ext */
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero

end
/* Datos Personales */
if @Tip_Actual = @Act_PerCRM begin

	select 
		@Per_Fecha = @FechaSis,
		@Per_NumTra = @NumTransac

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
		Per_Tipo	= @Per_Tipo,
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
		Per_LadTel	= @Per_LadTel, 
		Per_Telefo	= @Per_Telefo, /* telefono de casa */
		Per_Email	= @Per_Email,
		Per_ActEmp	= @Per_ActEmp,
	
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Per_Numero	= @Per_Numero

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

	/* Datos Adicionales */
	update SOPERADI set
		Adi_Fecha	= @Per_Fecha,
		Adi_NumTra	= @Per_NumTra,
		Adi_FecNac	= @Adi_FecNac,
		Adi_FecCon	= @Adi_FecCon,
		Adi_TelTra	= @Adi_TelTra,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero
	
end

/* Datos Personales */
if @Tip_Actual = @Act_PerSb3 begin

	select 
		@Per_Fecha = @FechaSis,
		@Per_NumTra = @NumTransac

	update SOPERSON set
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra,
	
		Per_Calle	= @Per_Calle,
		Per_CalNum	= @Per_CalNum,
		Per_Coloni	= @Per_Coloni,
		Per_Entida	= @Per_Entida,
		Per_Locali	= @Per_Locali,
	
		Per_CodPos	= @Per_CodPos,
		Per_LadTel	= @Per_LadTel, 
		Per_Telefo	= @Per_Telefo, /* telefono de casa */
		Per_Email	= @Per_Email,
		Per_EstCiv  = @Per_EstCiv,
	
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Per_Numero	= @Per_Numero

	/* Datos Adicionales */
	update SOPERADI set
		Adi_Fecha	= @Per_Fecha,
		Adi_NumTra	= @Per_NumTra,
		Adi_Fax		= @Adi_Fax, /* Celular */
		Adi_FecNac	= @Adi_FecNac,
		Adi_FecCon	= @Adi_FecCon,
		Adi_TelTra	= @Adi_TelTra,
		Adi_Sexo 	= @Adi_Sexo,
		Adi_LugNac	= @Adi_LugNac,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero
	
end

if @Tip_Actual = @Act_GenPer begin

	select 
		@Per_Fecha = @FechaSis,
		@Per_NumTra = @NumTransac
	
	update SOPERSON set
		Per_CURP	= @Per_CURP,
	
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Per_Numero	= @Per_Numero
	
	update SOPERADI set
		Adi_TipIde	= @Adi_TipIde,
		Adi_NumIde	= @Adi_NumIde,
		Adi_Sexo 	= @Adi_Sexo,
		Adi_NacExt	= @Adi_NacExt,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,

		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero

end

if @Tip_Actual	= @Act_TarAdi begin 

	update SOPERSON set 
		Per_RFC		= @Per_RFC, 
		Per_CURP	= @Per_CURP,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Per_Numero	= @Per_Numero
	
	update SOPERADI set 
		Adi_FecNac	= @Adi_FecNac, 
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero

end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Actualizado',
		Per_Numero	= @Per_Numero,
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra
		
