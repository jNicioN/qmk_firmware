create procedure SOPERUNIMOD (
	@Per_Numero	char(8),
	@Per_Fecha	smalldatetime,
	@Per_NumTra	char(10),
	@Per_Tipo	char(1),
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(84),
	@Per_ApePat	varchar(84),
	@Per_ApeMat	varchar(84),
	@Per_RazSoc	varchar(254),	
	@Per_RFC	varchar(15),
	@Per_CURP	varchar(18),
	@Per_Benefi	char(1),
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
	@Per_TipPar	char(1),
	@Adi_LugNac	varchar(50),	/* Adicionales */
	@Adi_Sexo	char(1),
	@Adi_FecNac	smalldatetime,
	@Adi_RegMat	char(1),
	@Adi_VivCas	char(1),
	@Adi_TieRes	int,
	@Adi_Fax    varchar(20),
	@Adi_NumDep	int,
	@Adi_Puesto	varchar(50),
	@Adi_Ocupac	varchar(50),
	@Adi_AntLab	int,
	@Adi_LugTra	varchar(50),
	@Adi_TelTra	varchar(20),
	@Adi_CalTra	varchar(20),
	@Adi_NuCaTr	varchar(30),
	@Adi_ColTra	varchar(50),
	@Adi_Locali	char(8),
	@Adi_CPTra	varchar(50),
	@Adi_FecCon	smalldatetime,
	@Adi_CaNuIn	varchar(10),
	@Adi_NacExt	char(1),
	@Adi_Reside	char(1),
	@Adi_DocEst	char(3),
	@Adi_OtDoEs	varchar(50),
	@Adi_FeExDo	smalldatetime,
	@Adi_CalInm	char(1),
	@Adi_CalExt	varchar(40),
	@Adi_CaNuEx	varchar(10),
	@Adi_ColExt	varchar(150),
	@Adi_LocExt	varchar(40),
	@Adi_EntExt	varchar(40),
	@Adi_PaiExt	varchar(3),
	@Adi_CoPoEx	char(6),
	@Adi_TelExt	varchar(20),
	@Adi_TipIde	char(1),
	@Adi_OtrIde	varchar(50),
	@Adi_NumIde	varchar(30),
	@Adi_FeExId	smalldatetime,

	@Adi_FeVeId	smalldatetime,
	@Adi_NuIdFi	varchar(20),
	@Adi_EntPri varchar(40), 
	@Adi_EntSeg varchar(40),
	@Tip_Proces	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))

as
/***************************************************************************/
/* DESCRIPCION: Modificacion de Personas Unicas (por sistemas externos)	  */
/***************************************************************************/
/** REFERENCIAS: 												  
****************************************************************************
** Modificó:	Francisco Euan          								****
** Fecha:		14/Marzo/2025							        		****
** Help:		TCELNC-23684								    		****
** Descripción:	Comprobación de valores para Adi_Sexo           		****
****************************************************************************
** Modificó:	Carlos Copto										 	****
** Fecha:		11/03/2024											   	****
** Help: 		38996 											   		****
** Descripcion:	Se aumenta el tamaño de los campos de nombre			****
**				se agrega validacion si el nombre excede los 180 		****
**				caracteres se registra en la tabla de nombres largos	****
****************************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz						****
** Fecha:		26/Junio/2017											****
** Help:		991811													****
** Descripcion: Se elimina la concatenación de Per_Titulo en 			****
**				Per_ComOrd												****
****************************************************************************
** Modificó:	Claudia V Sandoval P									****
** Fecha:		10/11/2011												****
** Help:		00388789												****
** Descripción:	Validación de Actividad vacia							****
****************************************************************************
** Creó:		Fernando Martinez Miramontes							****
** Fecha:		20/Jun/11												****
** Help:		388789	Nuevo Procedimiento								****
**Descripcion:	Modificacion de Personas Unicas							****
****************************************************************************/
declare	@Per_Comple	varchar(254),	/*	Declaracion de Variables	*/
		@Per_ComOrd	varchar(254),
		@Per_ActINE	char(6),
		@Act_Numero	char(10),
		@Act_Status	char(1),
		@Status		int,
		@PerPersoID	int,
		@PerExist	char(8),
		@Lon_Telefo smallint,
		@Tel_Comple	varchar(11),
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
		@Bit_LugNac	varchar(50),
		@Bit_Sexo	char(1),
		@Bit_FecNac	smalldatetime,
		@Bit_RegMat	char(1),
		@Bit_VivCas	char(1),
		@Bit_TieRes	int,
		@Bit_Fax    varchar(20),
		@Bit_NumDep	int,
		@Bit_Puesto	varchar(50),
		@Bit_Ocupac	varchar(50),
		@Bit_AntLab	int,
		@Bit_LugTra	varchar(50),

		@Bit_TelTra	varchar(20),
		@Bit_CalTra	varchar(20),
		@Bit_NuCaTr	varchar(30),
		@Bit_ColTra	varchar(50),
		@Bit_CPTra	varchar(50),
		@Bit_FecCon	smalldatetime,
		@Bit_CaNuIn	varchar(10),
		@Bit_NacExt	char(1),
		@Bit_Reside char(1),
		@Bit_DocEst	char(3),
		@Bit_OtDoEs varchar(50),
		@Bit_FeExDo	smalldatetime,
		@Bit_CalInm	char(1),
		@Bit_CalExt	varchar(40),
		@Bit_CaNuEx	varchar(10),
		@Bit_ColExt	varchar(150),
		@Bit_LocExt	varchar(40),
		@Bit_EntExt	varchar(40),
		@Bit_PaiExt	varchar(3),
		@Bit_CoPoEx	char(6),
		@Bit_TipIde	char(1),
		@Bit_OtrIde	varchar(50),
		@Bit_NumIde	varchar(30),
		@Bit_FeExId	smalldatetime,
		@Bit_FeVeId	smalldatetime,
		@Bit_NuIdFi	varchar(20),
		@Bit_EntPri char(40), 
		@Bit_EntSeg char(40),
		@NumPer		char(8)

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Tip_Benefi	char(1),
		@Tip_ProRec	char(1),
		@Tip_ProRea	char(1),
		@Tip_TerAut	char(1),
		@Tip_ApPrRe	char(1),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Tip_Apode	char(1),
		@Tip_Hered	char(1),
		@RFC_PMExtr	char(12),
		@Tip_Titula char(1),
		@Str_No123	char(6),
		@Str_23		char(4),
		@Ent_180	int,
		@Tip_Mascul char(1),
        @Tip_Femeni char(1)

select	@Str_Vacio	= '',			/* String Vacio	*/
		@Str_Espaci	= ' ',			/* String Espacio */
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS */
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1,			/* Entero en Uno */
		@Tip_Titula	= '1',			/* Titular */
		@Tip_Benefi	= '4',			/* Beneficiario						*/
		@Tip_ProRec	= '5',			/* Proveedor de Recursos			*/
		@Tip_ProRea	= '6',			/* Propietario Real					*/
		@Tip_TerAut	= '7',			/* Tercero Autorizado				*/
		@Tip_ApPrRe	= '8',			/* Apoderado del Porpietario Real	*/
		@Str_Si		= 'S',			/* String Si						*/
		@Str_No		= 'N',			/* String No						*/
		@Tip_Apode	= '2',			/* Apoderado de la Cuenta para Personas Morales de CHCOTBEN	*/
		@Tip_Hered	= 'H',			/* Tipo herederos legales */
		@RFC_PMExtr	= 'EXT990101NI9', /* Rfc para Persona MOral Extranjera */	
		@Str_No123	= '[^123]',
	 	@Str_23		= '[23]',
	 	@Ent_180	= 180,
	 	@Tip_Mascul = 'M',          /*  Valor para sexo Masculino */
        @Tip_Femeni = 'F'           /*  Valor para sexo Femenino */

if (@NumTransac =  @Str_Vacio or isnull(@NumTransac, @Str_Vacio) = @Str_Vacio)  begin
	/***** Genera el @NumTransac *****/
	exec @Status = SYINITRANSA
		@NumTransac output,	@SucOrigen
	if @Status <> 0 begin
		rollback
		return @Ent_Uno
	end
end

select	@Per_NumTra	= @NumTransac

select	@PerPersoID	= PerPersoID,
		@NumPer		= Per_Numero
	from SOPERSON noholdlock
	where	Per_Numero	= @Per_Numero

select	@NumPer	= isnull(@NumPer, @Str_Vacio)

if @NumPer = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La persona no existe',
			Err_Variab	= 'Per_Numero'
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

if @Per_Tipo <> @Per_Moral and @Adi_Sexo not in (@Tip_Mascul, @Tip_Femeni) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj 	= 'Sexo no válido'
	rollback
	return @Ent_Uno
end

if @Per_Tipo = @Per_Moral begin
	select	@Per_Comple	= LTrim(RTrim(@Per_RazSoc))
	select	@Per_ComOrd	= LTrim(RTrim(@Per_RazSoc))
	select	@Adi_Sexo	= @Str_Vacio
end else begin
	select	@Per_Comple	= LTrim(RTrim(@Per_ApePat)) + ' ' + LTrim(RTrim(@Per_ApeMat)) + ' ' + LTrim(RTrim(@Per_Nombre))
	select	@Per_ComOrd	= LTrim(RTrim(@Per_Nombre)) + ' ' + LTrim(RTrim(@Per_ApePat)) + ' ' + LTrim(RTrim(@Per_ApeMat))
end

if @Per_TipPar = @Tip_Benefi begin
	select	@Per_Benefi	= @Str_Si
end else begin
	select	@Per_Benefi	= @Str_No
end

if not exists (	select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Per_Numero
					  and	Per_NumTra	= @Per_NumTra
					  and	Per_Fecha	= @Per_Fecha ) begin

	select	@Per_Numero	= Per_Numero,
			@Per_Fecha	= Per_Fecha,
			@Per_NumTra	= Per_NumTra,
			@Per_Tipo	= Per_Tipo,
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
		@Per_Numero,	@Per_Fecha,		@Per_NumTra,	@Per_Tipo,		@Bit_NuSeFi,
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

	select	@Per_Numero	= Adi_PerNum,
			@Per_Fecha	= Adi_Fecha,
			@Per_NumTra	= Adi_NumTra,
			@Bit_LugNac	= Adi_LugNac,
			@Bit_Sexo	= Adi_Sexo,
			@Bit_FecNac	= Adi_FecNac,
			@Bit_RegMat	= Adi_RegMat,
			@Bit_VivCas	= Adi_VivCas,
			@Bit_TieRes	= Adi_TieRes,
			@Bit_Fax    = Adi_Fax,
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
			@Bit_Reside = Adi_Reside,
			@Bit_DocEst	= Adi_DocEst,
			@Bit_OtDoEs = Adi_OtDoEs,
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
			@Bit_EntPri = Adi_EntPri,
			@Bit_EntSeg = Adi_EntSeg
		from SOPERADI noholdlock
		where	Adi_PerNum	= @Per_Numero

		exec @Status =	SOBIPEADALT
			@Per_Numero,	@Per_Fecha,		@Per_NumTra,	@Bit_LugNac,	@Bit_Sexo,
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

/* Actividad de Inegi */ 
if isnull(@Per_Activi, @Str_Vacio) != @Str_Vacio begin
	
	select	@Per_ActINE	= Act_NumINE 
		from CLACTIVI noholdlock
		where	Act_Numero	= @Per_Activi
	
end
	
select	@Per_ActINE	= isnull(@Per_ActINE, @Str_Vacio)

/* Datos Personales */
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
		Adi_LugNac	= @Adi_LugNac,
		Adi_Sexo	= @Adi_Sexo,
		Adi_FecNac	= @Adi_FecNac,
		Adi_RegMat	= @Adi_RegMat,
		Adi_VivCas	= @Adi_VivCas,
		Adi_TieRes	= @Adi_TieRes,
		Adi_Fax     = @Adi_Fax,
		Adi_NumDep	= @Adi_NumDep,
		Adi_Puesto	= @Adi_Puesto,
		Adi_Ocupac	= @Adi_Ocupac,
		Adi_AntLab	= @Adi_AntLab,
		Adi_LugTra	= @Adi_LugTra,
		Adi_TelTra	= @Adi_TelTra,
		Adi_CalTra	= @Adi_CalTra,
		Adi_NuCaTr	= @Adi_NuCaTr,
		Adi_ColTra	= @Adi_ColTra,
		Adi_Locali	= @Adi_Locali,
		Adi_CPTra	= @Adi_CPTra,
		Adi_FecCon	= @Adi_FecCon,
		Adi_CaNuIn	= @Adi_CaNuIn,
		Adi_NacExt	= @Adi_NacExt,
		Adi_Reside 	= @Adi_Reside,
		Adi_DocEst	= @Adi_DocEst,
		Adi_OtDoEs 	= @Adi_OtDoEs,
		Adi_FeExDo	= @Adi_FeExDo,
		Adi_CalInm	= @Adi_CalInm,
		Adi_CalExt	= @Adi_CalExt,
		Adi_CaNuEx	= @Adi_CaNuEx,
		Adi_ColExt	= @Adi_ColExt,
		Adi_LocExt	= @Adi_LocExt,
		Adi_EntExt	= @Adi_EntExt,
		Adi_PaiExt	= @Adi_PaiExt,
		Adi_CoPoEx	= @Adi_CoPoEx,
		Adi_TelExt	= @Adi_TelExt,

		Adi_TipIde	= @Adi_TipIde,
		Adi_OtrIde	= @Adi_OtrIde,
		Adi_NumIde	= @Adi_NumIde,
		Adi_FeExId	= @Adi_FeExId,
		Adi_FeVeId	= @Adi_FeVeId,
		Adi_NuIdFi	= @Adi_NuIdFi,			
		Adi_EntPri	= @Adi_EntPri,
		Adi_EntSeg	= @Adi_EntSeg,			
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Adi_PerNum	= @Per_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Actualizado',
		Per_Numero	= @Per_Numero,
		Per_Fecha	= @Per_Fecha,
		Per_NumTra	= @Per_NumTra

