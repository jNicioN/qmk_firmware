create procedure SOPERUNIALT (
	@Per_Numero	char(8) output,
	@Per_Fecha	smalldatetime,
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
	@Per_Telefo	char(15),
	@Per_Email	varchar(50),
	@Per_ComDom	char(1),
	@Per_EstCiv	varchar(20),
	@Per_Nacion	char(3),
	@Per_ActEmp	char(1),
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
	@Adi_Fax	varchar(20),
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
	@Adi_EntPri	varchar(40),
	@Adi_EntSeg	varchar(40),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Alta de Personas Unicas (por sistemas externos)	  */
/******************************************************************/
/** REFERENCIAS: 
********************************************************************
** Modificó:	Francisco Euan          						****
** Fecha:		14/Marzo/2025							        ****
** Help:		TCELNC-23684								    ****
** Descripción:	Comprobación de valores para Adi_Sexo           ****
********************************************************************
** Modifico:	Raul Muniz										****
** Fecha:		06/Octubre/2021									****
** Help:		1504301											****
** Descripcion: Se agrega exec a SOPEINCOALT para guardar		****
**				actividad preponderante							****
********************************************************************
** Modifico:	CODE4U-Eliezer Catalino Xul Canche				****
** Fecha:		06/Febrero/2020									****
** Help:		1343720											****
** Descripcion: Se agrega indentity para el campo PerPersoID	****												  
********************************************************************
** Modifico:	Erika Báez										****
** Fecha:		04/Marzo/2019									****
** Help:		1191883											****
** Descripcion: Se modifica mensaje cuando el RFC ya existe		****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:		26/Junio/2017									****
** Help:		991811											****
** Descripcion: Se elimina la concatenación de Per_Titulo en 	****
**				Per_ComOrd										****
/*******************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		31/10/2016										****
** Help:		903360											****
** Descripcion:	Se agrega validacion de RFC repetido			****
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		03/03/2014										****
** Help:		00599444										****
** Descripcion:	Se agrega proceso unificacion					****
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		26/Jun/13										****
** Help:	   	00384210										****
** Descripcion:	Se agrega @Per_Numero de tipo salida			****
********************************************************************
** Modifico:	Alba Leonor Lara Torres							****
** Fecha:		28/Dic/11										****
** Help:	   	388789											****
** Descripcion:	Se inicializa parametro de Actividad INEGI y	****
** 				se condiciona generacion de @NumTransac			****
********************************************************************
** Modifico:	Vanesa Herrera    								****
** Fecha:		21/Jun/11										****
** Help:	   	388789											****
** Descripcion:	Alta Personas Unicas							****
********************************************************************
** Creo:		Alba Leonor Lara Torres							****
** Fecha:		21/Ago/11										****
** Help:	   	371155											****
** Help:		Condicionar generacion de Transaccion			****
******************************************************************/*/

/*	Declaracion de Variables	*/
declare	@Per_NumTra	char(10),		/*Numero de transaccion*/
		@Per_Comple	varchar(180),	/*Nombre completo*/
		@Per_ComOrd	varchar(180),	/*Nombre completo ordenado*/
		@Status		int,			/*Status*/
		@PerPersoID	int,			/*Id de persona*/
		@Per_ActINE	char(6),		/*Numero de actividad INE*/
		@Existe		char(1),		/*Bandera de si existe persona*/
		@Act_ActPre	int				/* Actividad Preponderante */

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Str_DobEsp char(2),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Sta_ActIna	char(1),
		@Tab_Nombre	char(8),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Si		char(1),
		@Str_No		char(1),
		@Tip_Titula	char(1),
		@Str_No123	char(6),
		@Str_23		char(4),
		@Lon_Fisica	int,
		@Lon_Moral	int,
		@Str_Ceros	char(8),
		@Ent_Ocho	int,
		@Usu_Prueba	char(6),
		@Fec_Vacia	smalldatetime,
		@Tip_PerNum char(1),
		@Ent_180	int,
		@Ent_40		int,
		@Tip_Hombre char(1),
        @Tip_Mujer  char(1)

/*Asignacion de constantes*/
select	@Str_Vacio	= '',			/* String Vacio	*/
		@Str_Espaci	= ' ',			/* String Espacio */
		@Str_DobEsp	= '  ',			/*	String Doble Espacio	*/
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna	= 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS */
		@Fec_Vacia	= '1900-01-01',	/*	Fecha Vacía*/
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1,			/* Entero en Uno */
		@Tip_Titula	= '1',			/* Titular */
		@Str_Si		= 'S',			/* String Si */
		@Str_No		= 'N',			/* String No */
		@Str_No123	= '[^123]',		/*String 1 2 3*/
		@Str_23		= '[23]',		/*String 2 3*/
		@Lon_Fisica	= 13,			/*Longitud RFC perosna fisica*/
		@Lon_Moral	= 12,			/*Longitud RFC persona moral*/
		@Str_Ceros	='00000000',	/*String ceros*/
		@Ent_Ocho	= 8,			/*Entero ocho*/
		@Usu_Prueba	= '009999',		/*Usuario Pruebas*/
		@Tip_PerNum = 'F',			/*  Tipo proceso para actualizar el numero de folio*/
		@Ent_180 	= 180,			/* Numero 180*/
		@Ent_40 	= 40,			/* Numero 40*/
		@Tip_Hombre = 'M',          /*  Valor para sexo Hombre */
        @Tip_Mujer  = 'H'           /*  Valor para sexo Mujer */


if (@NumTransac	= @Str_Vacio or isnull(@NumTransac, @Str_Vacio)	= @Str_Vacio) begin
	/***** Genera el @NumTransac *****/
	exec @Status = SYINITRANSA
		@NumTransac output,	@SucOrigen
	if @Status <> 0 begin
		rollback
		return 1
	end
end

select	@Per_NumTra	= @NumTransac

if (@Per_Tipo	= @Per_Moral) and (@Per_RazSoc	= @Str_Vacio) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Proporcione la Razon social'
	rollback
	return 1
end

if (@Per_Tipo like @Str_23) and (@Per_Nombre	= @Str_Vacio) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Proporcione el Nombre'
	rollback
	return 1
end

if (@Per_Tipo like @Str_23) and (@Per_ApePat	= @Str_Vacio) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Proporcione el Apellido paterno'
	rollback
	return 1
end

if @Per_Tipo	= @Per_Moral and @Per_RFC	= @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Proporcione el RFC'
	rollback
	return 1
end

if (@Per_Tipo	= @Per_Fisica and len(ltrim(rtrim(@Per_RFC)))	= @Lon_Fisica) OR
	(@Per_Tipo	= @Per_Moral and len(ltrim(rtrim(@Per_RFC)))	= @Lon_Moral) begin
	select	@Existe	= @Str_No
	select	@Existe	= @Str_Si
		from SOPERSON noholdlock
		where	Per_RFC	= ltrim(rtrim(@Per_RFC))
	
	if @Existe	= @Str_Si begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'Ya existe el RFC ' + @Per_RFC + ', favor de buscar por el nombre completo a la persona capturada' 
		rollback
		return 1
	end
end

if @Adi_Sexo not in (@Tip_Hombre, @Tip_Mujer) begin
	select	Err_Codigo	= '000005',
			Err_Mensaj 	= 'Sexo no válido'
	rollback
	return 1
end


if @Per_Tipo	= @Per_Moral begin
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

select	@Per_ActINE	= @Str_Vacio
if isnull(@Per_Activi, @Str_Vacio) != @Str_Vacio begin
	select	@Per_ActINE	= Act_NumINE
		from CLACTIVI noholdlock
		where	Act_Numero	= @Per_Activi
end

select	@Per_ActINE	= isnull(@Per_ActINE, @Str_Vacio)

/* Datos Personales */
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

if @Per_Numero = @Str_Vacio begin
		rollback
		return 1
end

exec @Status = SOPERSONPRO		
			@Per_Numero, @Str_Vacio,  @Str_Vacio,  @Str_Vacio, @Str_Vacio,
			@Fec_Vacia,  @Str_Vacio,  @Str_Vacio,  @Fec_Vacia, @Str_Vacio,
			@Str_Vacio,  @Str_Vacio,  @Fec_Vacia,  @Str_Vacio, @Str_Vacio,
			@Tip_PerNum, @NumTransac, @Transaccio, @Usuario,   @FechaSis,
			@SucOrigen,  @SucDestino, @Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end

/* Datos Adicionales */
insert into SOPERADI values (
	@Per_Numero,	@Per_Fecha,		@Per_NumTra,	@Adi_LugNac,	@Adi_Sexo,
	@Adi_FecNac,	@Adi_RegMat,	@Adi_VivCas,	@Adi_TieRes,	@Adi_Fax,
	@Adi_NumDep,	@Adi_Puesto,	@Adi_Ocupac,	@Adi_AntLab,	@Adi_LugTra,
	@Adi_TelTra,	@Adi_CalTra,	@Adi_NuCaTr,	@Adi_ColTra,	@Adi_Locali,
	@Adi_CPTra,		@Adi_FecCon,	@Adi_CaNuIn,	@Adi_NacExt,	@Adi_Reside,
	@Adi_DocEst,	@Adi_OtDoEs,	@Adi_FeExDo,	@Adi_CalInm,	@Adi_CalExt,
	@Adi_CaNuEx,	@Adi_ColExt,	@Adi_LocExt,	@Adi_EntExt,	@Adi_PaiExt,
	@Adi_CoPoEx,	@Adi_TelExt,	@Adi_TipIde,	@Adi_OtrIde,	@Adi_NumIde,
	@Adi_FeExId,	@Adi_FeVeId,	@Adi_NuIdFi,	@Adi_EntPri,	@Adi_EntSeg,
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
	@SucDestino)

exec @Status	= SOUNIPERPRO
	@Per_Numero,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
	@SucOrigen,		@SucDestino,	@Modulo
	
if @Status <> 0 begin
	rollback
	return 1
end

select	@Act_ActPre	= @Ent_Cero
select	@Act_ActPre	= isnull(Apc_ActPre, @Ent_Cero)
	from SOACPRCL noholdlock
	where Apc_Activi = @Per_Activi
	
exec @Status	= SOPEINCOALT
	@PerPersoID,	@Act_ActPre,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
if @Status <> 0 begin
	rollback
	return 1
end

if @@nestlevel	= @Ent_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro agregado',
			Per_Numero	= @Per_Numero,
			Per_Fecha	= @Per_Fecha,
			Per_NumTra	= @Per_NumTra
end

if @Usuario	= @Usu_Prueba begin
	select	Per_Fecha	= @Per_Fecha,
			Per_NumTra	= @Per_NumTra
end