create procedure SOPERUNIALT (
	@Per_Numero	char(8) output,
	@Per_Fecha	smalldatetime,
	@Per_Tipo	char(1),
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_RazSoc	varchar(180),
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
		@Existe		char(1)			/*Bandera de si existe persona*/

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
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
		@Usu_Prueba	char(6)

/*Asignacion de constantes*/
select	@Str_Vacio	= '',			/* String Vacio	*/
		@Str_Espaci	= ' ',			/* String Espacio */
		@Per_Moral	= '1',			/* Persona Moral */
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Sta_ActIna	= 'I',			/* Status de actividad inactiva */
		@Tab_Nombre	= 'SOPERSON',	/* Tabla que se consulta en SOFOLIOS */
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
		@Usu_Prueba	= '009999'		/*Usuario Pruebas*/

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


if @Per_Tipo	= @Per_Moral begin
	select	@Per_Comple	= ltrim(rtrim(@Per_RazSoc))
	select	@Per_ComOrd	= ltrim(rtrim(@Per_RazSoc))
end else begin
	select	@Per_Comple	= ltrim(rtrim(@Per_ApePat)) + ' ' + ltrim(rtrim(@Per_ApeMat)) + ' ' + ltrim(rtrim(@Per_Nombre))
	select	@Per_ComOrd	= ltrim(rtrim(@Per_Nombre)) + ' ' + ltrim(rtrim(@Per_ApePat)) + ' ' + ltrim(rtrim(@Per_ApeMat))
end

exec @Status	= SOFOLIOSACT
	@Fol_Tabla	= @Tab_Nombre,
	@Fol_Numero	= @PerPersoID output
if @Status <> 0 begin
	rollback
	return 1
end

select	@Per_Numero	= right(@Str_Ceros + ltrim(rtrim(convert(char, @PerPersoID))), @Ent_Ocho)

select	@Per_ActINE	= @Str_Vacio
if isnull(@Per_Activi, @Str_Vacio) != @Str_Vacio begin
	select	@Per_ActINE	= Act_NumINE
		from CLACTIVI noholdlock
		where	Act_Numero	= @Per_Activi
end

select	@Per_ActINE	= isnull(@Per_ActINE, @Str_Vacio)

/* Datos Personales */
insert into SOPERSON values	(
	@PerPersoID,	@Per_Numero,	@Per_Fecha,		@Per_NumTra,	@Per_Tipo,
	@Per_Benefi,	@Per_NuSeFi,	@Per_Titulo,	@Per_Nombre,	@Per_ApePat,
	@Per_ApeMat,	@Per_RazSoc,	@Per_Comple,	@Per_ComOrd,	@Per_RFC,
	@Per_CURP,		@Per_Calle,		@Per_CalNum,	@Per_Coloni,	@Per_Entida,
	@Per_Locali,	@Per_CodPos,	@Per_ApaPos,	@Per_LadTel,	@Per_Telefo,
	@Per_Email,		@Per_ComDom,	@Per_EstCiv,	@Per_Nacion,	@Per_ActEmp,
	@Per_Giro,		@Per_Sector,	@Per_Activi,	@Per_ActINE,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

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