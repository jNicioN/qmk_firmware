create procedure SOPERSONCON (
	@Per_Numero	char(8),
	@Per_Comple	varchar(181),
	@Per_Tipo	char(1),
	@Per_RFC	varchar(15),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Consulta de Personas **						****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Angel Encalada									****
** Fecha:		06/05/2025									   	****
** Help: 		TCELNC-24329									****
** Descripcion:	Ajuste en consulta LB por rfc de persona	    ****
********************************************************************
** Modificó:	Jesus Hernandez									****
** Fecha:		14/04/2025									   	****
** Help: 		TCELNC-24119									****
** Descripcion:	Consulta por numero de cliente y numero de      ****
**				persona para optener a l persona principal      ****
**              Se agrega consulta CI, CJ y LK					****
********************************************************************
** Modificó:	Angel Encalada									****
** Fecha:		05/04/2025									   	****
** Help: 		TCELNC-23481									****
** Descripcion:	Se modifica la consulta C6 para devolver campos ****
**				campos de soperadi								****
********************************************************************
** Modificó:	Francisco Euan									****
** Fecha:		14/11/2024									   	****
** Help: 		TCELNC-21872									****
** Descripcion:	Se optimizan las consultas C6 y C7				****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		11/03/2024									   	****
** Help: 		38996 											****
** Descripcion:	Se aumenta el tamanio del parametro de entrada 	****
**				Per_Comple y se cre nueva consulta CH para 		****
**				personas con nombre largo						****
********************************************************************
**	Modifico:		Ricardo de la Fuente Segovia				****
**  Fecha:			03/04/2023									****
**  Help:			TCELTO-4381									****
**	Descripcion:	Se modifican las consultas CD y LA 			****
**					relacionadas a SMS							****
********************************************************************
**	Modifico:	Luis Enrique Ramirez Ortiz						****
**  Fecha:		06/10/2021										****
**  Help:		1179955											****
**	Descripcion: Se modifican las consultas relacionadas a SMS	****
********************************************************************
**	Modifico:	Marcelo Bautista Hernandez						****
**  Fecha:		03/06/2021										****
**  Help:		1482775											****
**	Descripcion: optimizar CB, L9, quitar L8, LB	 			****
********************************************************************
**	Modificó:	Frank canul										****
**  Fecha:		23/12/2020										****
**  Help:		1286068											****
**	Descripción: se elimina el convert para la columna 			****
**  Ptc_TipCue ya que ahora son char y no se necesita           ****
**  las conversiones  									        ****																
********************************************************************
** Modifico:		Adriana Gomez								****
** Fecha:			30/10/2020									****
** Help:			1376175 									****
** Descripcion:		Se modifica LB para quitar consulta de      ****
**                  usuarios C/V con estructura viejita			****
********************************************************************
** Modifico:		Juan Sandoval								****
** Fecha:			29/10/2020									****
** Help:			1417267 									****
** Descripcion:		Se agrega LB								****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:			07/10/2020									****
** Help:			1379522 									****
** Descripcion:		Se modifical la consulta CA y CB para 		****
**					optimizar las búsquedas						****
*********************************************************************
** Modifico:		Luis Enrique Ramirez Ortiz					****
** Fecha:			25/09/2020									****
** Help:			1179955 									****
** Descripcion:		Se modifica la consulta CG, para validar que****
**					un registro de persona le pertenezca a un 	****
**					cliente										****
********************************************************************
** Modifico:		Luis Enrique Ramirez Ortiz					****
** Fecha:			15/09/2020									****
** Help:			1179955 									****
** Descripcion:		Se agrega LA, busqueda con like por RFC		****
********************************************************************
** Modifico:		Joel Barcenas								****
** Fecha:			25/06/2020									****
** Help:			1179955 									****
** Descripcion:		Se agrega CD, CF, CG						****
********************************************************************
** Modifico:		Joel Barcenas								****
** Fecha:			25/02/2020									****
** Help:			1179955 									****
** Descripcion:		Se cambia CC para poder filtrar por cliente	****
********************************************************************
** Modifico:		Carlos Ramirez								****
** Fecha:			04/Octubre/2019								****
** Help:			1179955 									****
** Descripcion:		Se crea CC, consulta para busqueda de   	****
**					personas que puedan ser integradas como un 	****
**					tercero autorizado de internacional			****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:			26/Septiembre/2019							****
** Help:			1202239	 									****
** Descripcion:		Se modifica la consulta L8 para retornar	****
**					La CURP										****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:			31/Julio/2019								****
** Help:			1202239	 									****
** Descripcion:		Se modifican consultas CA, CB para retornar	****
**					el nombre y apellidos de la persona			****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:			09/Enero/2019								****
** Help:			1147468	 									****
** Descripcion:		Se modifican consultas CA, CB para retornar	****
**					el número del grupo y optimizar las 		****
**					búsquedas									****
********************************************************************
** Modifico:		Armando Alexis Sepúlveda Cruz				****
** Fecha:			22/Nov/2018									****
** Help:			1147468	 									****
** Descripcion:		Se agregan consultas CA, CB y CC para		****
**					servicios movil								****
********************************************************************
** Modifico:		Leonardo Rodriguez							****
** Fecha:			05/Noviembre/2018							****
** Help:			1096630	 									****
** Descripcion:		En C1 se da salida a PerPersoID             ****
********************************************************************
** Modifico:		Angel Cisneros								****
** Fecha:			01/Agosto/2018								****
** Help:			1138771	 									****
** Descripcion:		En C7 se da salida a PerPersoID             ****
********************************************************************
** Modifico:		Daniel Bautista								****
** Fecha:			24/enero/2018								****
** Help:			1044393	 									****
** Descripcion:		Se agrega numero de persona para la consulta****
					L8											****
********************************************************************
** Modifico:		Brandon Garcia								****
** Fecha:			24/Diciembre/2017							****
** Help:			1044393	 									****
** Descripcion:		Se agrega consulta C9 y se agrega consulta	****
**					de persona L8 por Numero					****
********************************************************************
** Modifico:		Roberto Saldivar							****
** Fecha:			24/Febrero/2017								****
** Help:			946338	 									****
** Descripcion:		Mostrar personas de todas las sucursales L8	****
**					En caso de no recibir la sucursal			****
********************************************************************
** Modifico:		Armando Alexis Sepulveda Cruz				****
** Fecha:			09/Febrero/2017								****
** Help:			956782	 									****
** Descripcion:		Modificacion en la condicion se intercambia	****
** 					Cli_Sucurs por Cli_SucAti					****
********************************************************************
** Modifico:		Marcelo Bautista Hernandez					****
** Fecha:			12/Octubre/2016								****
** Help:			895469	 									****
** Descripcion:		Mostrar registro mas reciente en lista L8	****
********************************************************************
** Modificacion:	Benjamin Eduardo Garcia Villegas			****
** Fecha:			20/Abril/2016								****
** Help:			856451	 									****
** Descripcion:		Se agrego a L9 Adi_TelTra y Adi_FecCon		****
********************************************************************
** Modificacion:	Benjamin Eduardo Garcia Villegas			****
** Fecha:			14/Abril/2016								****
** Help:			864242	 									****
** Descripcion:		Se removieron las consultas a CLCLIENT y 	****
** 					CLADICIO en la consulta L9					****
********************************************************************
** Modificacion:	Benjamin Eduardo Garcia Villegas			****
** Fecha:			15/Marzo/2016								****
** Help:			854839	 									****
** Descripcion:		Optimizacion de Consulta L9 				****
********************************************************************
** Modificacion:	Benjamin Eduardo Garcia Villegas			****
** Fecha:			26/Febrero/2016								****
** Help:			846999										****
** Descripcion:		Consulta L9 ahora busca el RFC completo     ****
**					en CLCLIENT, luego el SOPERSON y finalmente ****
**					realiza la busqueda por LIKE				****
**					en Per_ComOrd								****
********************************************************************
** Modificacion:	Marcelo Bautista							****
** Fecha:			17/Febrero/2016								****
** Help:			801121										****
** Descripcion:		Busqueda por numero de cliente en L8		****
** 					y se cambio el mensaje de error 			****
********************************************************************
** Modificacion:	Marcelo Bautista							****
** Fecha:			12/Febrero/2016								****
** Help:			801121										****
** Descripcion:		Se quitan ultimos 13 campos en consulta C1	****
********************************************************************
** Modificacion:	Benjamin Eduardo Garcia Villegas			****
** Fecha:			29/Enero/2016								****
** Help:			834594										****
** Descripcion:		Se agrego la consulta L9					****
**					en Per_ComOrd								****
********************************************************************
** Modificacion:	Andrea Ramirez								****
** Fecha:			07/Ene/2016									****
** Help:			00801121									****
** Descripcion:		Agregar campos Adi_DocEst C1				****
********************************************************************
** Modificacion:	Andrea Ramirez								****
** Fecha:			24/Nov/2015									****
** Help:			00801121									****
** Descripcion:		Agregar campos Adi_FeVeId, Adi_OtrIde,		****
**					Adi_OtDoEs y Adi_FeExDo al Tipo de Consulta	****
**					C1											****
********************************************************************
** Modificacion:	Marcelo Bautista Hernandez					****
** Fecha:			12/Octubre/2015								****
** Help:			801121										****
** Descripcion:		se agrega lista L8							****
********************************************************************
** Modificacion:	Ricardo Alberto Chi Garcia					****
** Fecha:			31/Julio/2015								****
** Help:			758614										****
** Descripcion:		Mejora de busqueda en L6, se agrega busqueda****
**					en Per_ComOrd								****
********************************************************************
** Modificacion:	David Alejandro Cantu Trevino				****
** Fecha:			18/Mayo/2015								****
** Help:			766265										****
** Descripcion:		Validacion para CLLOCALI y CLENTIDA por Pais****
********************************************************************
** Modifico:		Claudia V Sandoval P						****
** Fecha:			18/Mar/15									****
** Help:			0744849										****
** Descripcion:		Se cambia L7 y C8							****
********************************************************************
** Modifico:		Claudia V Sandoval P						****
** Fecha:			09/05/2014									****
** Help:			00657814									****
** Descripcion:		Se cambio Act_ActReg a 2 posiciones			****
********************************************************************
** Modifico:		Claudia V Sandoval P						****
** Fecha:			28/01/2014									****
** Help:			0597751										****
** Descripcion:		Se agrego C8, L6, L7						****
********************************************************************
** Modifico:		Eugenio Salazar Orta						****
** Fecha:			26/Agosto/2013								****
** Help Desk:		00584113									****
** Descripcion:		Agregar campo Per_ComOrd a la C1	   		****
********************************************************************
** Modifico:		Azael Adan Gutierrez Castruita				****
** Fecha:			01/Junio/2012								****
** Help Desk:		461298										****
** Descripcion:		Modifica Tipo de dato para RFC		   		**** 
********************************************************************
** Modifico:		David Alberto Ramos Barba					****
** Fecha:			31/Mayo/2010								****
** Descripcion:		Validacion de prefijos comunes en L5		****
** Help:			00294882									****
********************************************************************
** Modifico:		Lucina Gonzalez Trejo						****
** Fecha:			30/Octubre/2009								****
** Descripcion:		Validar en consultas por nombre en listas	****
**					1 y 2 q se capturen por lo menos 4 car		****
** Help:			198358										****
********************************************************************
** Modifico:		Sergio Trevino Jasso						****
** Fecha:			10/Marzo/2009								****
** Descripcion:		Dividir en 2 resultados la consulta C7		****
** Help:			100187										****
********************************************************************
**					STORE CONVERTIDO							****
********************************************************************
** Modifico:		Karina Chavarria Tovar						****
** Fecha:			06/Octubre/2008								****
** Descripcion:		Agregar campo Adi_EntPri, Adi_EntSeg a  C1	****
**					y C7										****
** Help:			100187										****
********************************************************************
** Modifico:		Karina Chavarria Tovar						****
** Fecha:			02/Octubre/2007								****
** Descripcion:		Agregar campo Adi_FeExId al  C1 			****
** Help:			3666 										****
********************************************************************
** Modifico:		Lucina Gonzalez Trejo						****
** Fecha:			12/Marzo/07									****
** Descripcion:		Agregar campos	C1 y Agregar C7, L5			****
** Help:			3666 - 7100									****
********************************************************************
**						STORE CONVERTIDO						****
** Convirtio: 		Alfonso Ramos Pena							****
** Fecha:			30/Enero/2007								****
********************************************************************
** Modifico:		Ricardo Salinas								****
** Fecha:			03/Nov/06									****
** Descripcion:		Se agrego C6								****
** Help:			3781										****
********************************************************************
** Modifico:		Estela MG									****
** Fecha:			25/Ago/06									****
** Help:			Fabrica Ontime 								****
** Descripcion:		Se agrego Cons. L4							****
********************************************************************
** Modifico:		FCHIA										****
** Fecha:			26/Ene/06									****
** Help:			Fabrica Comercial							****
** Descripcion:		Se agrego SOPERADI							****
********************************************************************
** Modifico:		Jorge Ortega Rodriguez						****
** Fecha:			26/Octubre/2005								****
** Help Desk:		00104056.002								****
** Descripcion:		Se cambio la consulta C4 para buscar por	****
**					RFC y C5 para filtrar unicamente los		****
**					ejecutivos									****
********************************************************************
** Modifico:		Jorge Ortega Rodriguez						****
** Fecha:			13/Octubre/2005								****
** Help Desk:		00104056.002								****
** Descripcion:		Se agrego la consulta C4					****
********************************************************************
** Modifico:		Jorge M. Maldonado Gonzalez					****
** Fecha:			28/Octubre/2004								****
** Descripcion:		Cambio en estructura de SOPERSON			****
********************************************************************
** 						STORE CONVERTIDO						****
** Convirtio:		LCervantes									****
** Fecha:			13/Ago/04									****
********************************************************************
** Modifico:		Hugo Perez									****
** Fecha:			01/Nov/00									****
** Descripcion:		Estandarizacion y orden por Numero Persona	****
********************************************************************
** Creo:			FROCHA										****
** Fecha:			18/Jun/1998									****
********************************************************************
** Modifico:		Ing. Laura Elena Cervantes 					****
** Fecha:			14/Jul/1998									****
*******************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Ent_PreCom	int,
		@Loc_Pais	char(3),
		@Busqueda	varchar(100),
		@Int_Client	int,
		@Rfc_Like	varchar(15),
		@Ent_NumReg	int,
		@Status		int,
		@Peu_Grupo char(8),
		@Cli_Numero char(8),
		@Adi_NumPer char(8)

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Porcen	char(1),
		@Str_Coma	char(1),
		@Str_Prospe	varchar(25),
		@Fec_Vacio	smalldatetime,
		@Sta_Si		char(1),
		@Sta_No		char(1),
		@Str_Si		char(2),
		@Str_No		char(2),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ent_Cinco	int,
		@Ent_Ocho	int,
		@Ent_Diez	int,
		@Ent_Doce	int,
		@Ent_Trece	int,
		@Coi_Total	char(1),
		@Coi_Parcia	char(1),
		@Tip_Moral	char(1),
		@Tip_Fisica	char(1),
		@Per_Fisica	varchar(10),
		@Per_Moral	varchar(10),
		@Per_RFCSH	varchar(15),
		@Tip_FisAE	char(1),
		@Msj_MasInf	varchar(41),
		@Sin_Direcc varchar(50),
		@Sta_Termin char(1),
		@Str_Usuari varchar(10),
		@Str_A		char(1),
		@Len_RFCOrd	int,
		@Len_RFCHom int,
		@Str_B		char(1),
		@Str_CuaCer	char(4),
		@Cla_Banreg	int,
		@Cue_HeyBiz	char(2),
		@Cue_CashBa	char(2),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Cuatro	char(1),
		@Str_Cinco	char(1),
		@Str_Seis	char(1),
		@Str_Siete	char(1),
		@Str_Ocho	char(1),
		@Str_Nueve	char(1),
		@Str_LetraA	char(1),
		@Str_LetraB	char(1),
		@Str_LetraC	char(1),
		@Str_LetraD	char(1),
		@Str_LetraF	char(1),
		@Str_LetraG	char(1),
		@Str_LetraH	char(1),
		@Str_LetraI	char(1),
		@Str_LetraJ	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Str_Porcen	= '%',			-- String Porcentaje
		@Str_Coma	= ',',			-- String Coma
		@Str_Prospe	= 'PROSPECTO',	-- String Prospecto
		@Fec_Vacio	= '1900-01-01',
		@Sta_Si		= 'S',			-- Status : Si
		@Sta_No		= 'N',			-- Status : No
		@Str_Si		= 'SI',
		@Str_No		= 'NO',
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1,			-- Entero : 1
		@Ent_Cinco	= 5,			-- Entero : 5
		@Ent_Ocho	= 8,			-- Entero : 8
		@Ent_Diez	= 10,			-- Entero : 10
		@Ent_Doce	= 12,			-- Entero : 12
		@Ent_Trece	= 13,			-- Entero : 13
		@Coi_Total	= 'T',
		@Coi_Parcia	= 'P',
		@Tip_Moral	= '1',			-- Tipo de Persona Moral
		@Tip_Fisica	= '2',			-- Tipo de Persona Fisica
		@Tip_FisAE  = '3',			-- Tipo de Persona Fisica con Act. Emp.
		@Per_Fisica	= 'FISICA',
		@Per_Moral	= 'MORAL',
		@Msj_MasInf	= 'Capture más información para la busqueda',
		@Sin_Direcc = 'Sin Direcci&oacuten',
		@Sta_Termin	= 'T',			-- Status de Terminado
		@Str_Usuari = 'USUARIO',		-- String Usuario
		@Str_A		= 'A',
		@Len_RFCOrd	= 10,			/* Longitud de rfc ordinario*/
		@Len_RFCHom = 13,			/* Longitud de rfc ordinario*/
		@Str_B		= 'B',
		@Str_CuaCer	= '0000',		/* String: cuatro ceros */
		@Cla_Banreg = 2,			/* Clasificacion: Banregio */
		@Cue_HeyBiz = '47',			/* Tipo de Cuenta: Cashback */
		@Cue_CashBa = '31',			/* Tipo de Cuenta: Cashback */
		@Str_Uno 	= '1',			/* Cadena uno */
		@Str_Dos 	= '2',			/* Cadena dos */
		@Str_Tres 	= '3',			/* Cadena tres */
		@Str_Cuatro = '4',			/* Cadena cuatro */
		@Str_Cinco 	= '5',			/* Cadena cinco */
		@Str_Seis 	= '6',			/* Cadena seis */
		@Str_Siete 	= '7',			/* Cadena siete */
		@Str_Ocho 	= '8',			/* Cadena Ocho */
		@Str_Nueve 	= '9',			/* Cadena Nueve */
		@Str_LetraA = 'A',			/* Cadena letra A */
		@Str_LetraB = 'B',			/* Cadena letra B */
		@Str_LetraC = 'C',			/* Cadena letra C */	
		@Str_LetraD = 'D',			/* Cadena letra D */
		@Str_LetraF = 'F',			/* Cadena letra F */
		@Str_LetraG = 'G',			/* Cadena letra G */		
		@Str_LetraH = 'H',			/* Cadena letra H */
		@Str_LetraI = 'I',			/* Cadena letra I */
		@Str_LetraJ = 'J'			/* Cadena letra J */
		
select	@Busqueda	= @Per_Comple
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_LetraC begin
	if @Tip_ConCon	= @Str_Uno begin
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_EstCiv,	Per_Email,	Per_ComDom,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_RegMat,
				Adi_VivCas,	Adi_TieRes,	Adi_Fax,	Adi_NumDep,	Adi_Puesto,
				Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_CalTra,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,
				Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt,	Adi_NuIdFi,	Adi_TipIde,
				Adi_NumIde,	Adi_FeExId,	Adi_EntPri,	Adi_EntSeg,	PerPersoID
			from SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Per_Numero	=  @Per_Numero
			 and	Per_Numero	*= Adi_PerNum
	end
	if @Tip_ConCon	= @Str_Dos begin
		select	Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE
			from SOPERSON noholdlock
			where	Per_Numero	= @Per_Numero
			  and	Per_Tipo	= @Per_Tipo
	end
	if @Tip_ConCon	= @Str_Tres begin
		select	Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE
			from SOPERSON noholdlock
			where	Per_Tipo	= @Per_Tipo
	end
	if @Tip_ConCon	= @Str_Cuatro begin			/* Consulta De Ejecutivo en Base A Su RFC	*/
		select	Per_Existe	= @Sta_Si,
				Eje_Existe	= @Sta_No,
				Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,
				Eje_Extens	= space(4),
				Eje_Celula	= space(15),
				Eje_Depart	= space(50),
				Eje_Email	= space(20)
			into #Person
			from SOPERSON noholdlock  
			where	Per_RFC	= @Per_RFC

		update #Person set
			Eje_Existe	= @Sta_Si,
			#Person.Eje_Extens	= ABEJECUT.Eje_Extens,
			#Person.Eje_Celula	= ABEJECUT.Eje_Celula,
			#Person.Eje_Depart	= ABEJECUT.Eje_Depart,
			#Person.Eje_Email	= ABEJECUT.Eje_Email
			from ABEJECUT noholdlock
			where	Per_Numero	= Eje_Numero

		select	Per_Existe,	Eje_Existe,	Per_Numero,	Per_Tipo,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_Telefo,	Per_EstCiv,	Per_Nacion,	Per_ActEmp,	Per_Giro,
				Per_Sector,	Per_Activi,	Per_ActINE,	Eje_Extens,	Eje_Celula,
				Eje_Depart,	Eje_Email
			from #Person

		drop table #Person
	end
	if @Tip_ConCon = @Str_Cinco begin				/*	Consulta De Ejecutivos De Arrendadora	*/
		select	Per_Existe	= @Sta_Si,
				Eje_Existe	= @Sta_Si,
				Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Eje_Extens,	Eje_Celula,	Eje_Depart,	Eje_Email
			from SOPERSON noholdlock,
				 ABEJECUT noholdlock
			where	Per_Numero	= Eje_Numero
			  and	Eje_Numero	= @Per_Numero
			  and	len(rtrim(ltrim(Per_Numero)))	= @Ent_Ocho
	end
	if @Tip_ConCon = @Str_Seis begin	/*	Consulta persona por RFC*/
		select	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RFC,	Per_Calle,
				Per_CalNum,	Per_Coloni,	Per_Locali,	Per_CodPos,	Per_Telefo,
				Per_EstCiv,	Per_Nacion,	Per_ActEmp,	Per_Activi,
				Per_FecNac	= Adi_FecNac,
				PerPersoID, Per_Tipo, 	Adi_Sexo,	Per_CURP,	Per_Comple,
				Per_Entida, Per_LadTel, Adi_FecCon, Per_ActINE, Adi_FecCon,
				Per_RazSoc, Per_Numero 
			from SOPERSON noholdlock
			left join SOPERADI noholdlock on Per_Numero	= Adi_PerNum
			where	Per_RFC		= @Per_RFC
	end
	if @Tip_ConCon = @Str_Siete begin	/*	Consulta persona Toda la inf por RFC*/
		
		create table #Soperson(
			Per_Numero	char(8),	
			Per_Tipo 	char(1),	
			Per_Benefi	char(1),	
			Per_NuSeFi	varchar(30),	
			Per_Titulo 	varchar(10),
			Per_Nombre 	varchar(40),	
			Per_ApePat 	varchar(40),	
			Per_ApeMat 	varchar(40),	
			Per_RazSoc 	varchar(180),
			Per_Comple 	varchar(180),
			Per_ComOrd 	varchar(180),
			Per_RFC 	varchar(15),
			Per_CURP 	char(18),
			Per_Calle 	char(40),
			Per_CalNum 	varchar(10),
			Per_Coloni 	varchar(150),
			Per_Entida 	char(3),
			Per_Locali 	char(8),
			Per_CodPos 	char(6),
			Per_ApaPos 	char(6),
			Per_LadTel 	varchar(8),
			Per_Telefo 	char(15),
			Per_Email 	varchar(50),
			Per_ComDom 	char(1),
			Per_EstCiv 	varchar(20),
			Per_Nacion 	char(3),
			Per_ActEmp 	char(1),
			Per_Giro 	char(30),
			Per_Sector 	char(3),
			Per_Activi 	char(10),
			Per_ActINE 	varchar(10),
			Adi_LugNac 	varchar(50),
			Adi_Sexo 	char(1),
			Adi_FecNac 	smalldatetime,
			Adi_Fax 	varchar(20),
			Adi_Puesto 	varchar(50),
			Adi_Ocupac 	varchar(50),
			Adi_LugTra 	varchar(50),
			Adi_TelTra  varchar(20),
			Adi_CalTra 	varchar(40),
			Adi_NuCaTr 	varchar(30),
			Adi_ColTra 	varchar(50),
			Adi_Locali 	char(8),
			Adi_CPTra 	varchar(50),
			Adi_NacExt 	char(1),
			Adi_DocEst 	char(3),
			Adi_FeExDo 	smalldatetime,
			Adi_CalInm 	char(1),
			Adi_CalExt 	varchar(40),
			Adi_CaNuEx 	varchar(10),
			Adi_ColExt 	varchar(150),
			Adi_LocExt 	varchar(40),
			Adi_EntExt 	varchar(40),
			Adi_PaiExt 	char(3),
			Adi_CoPoEx 	char(6),
			Adi_TipIde 	char(1),
			Adi_OtrIde 	varchar(50),
			Adi_NumIde 	varchar(30),
			Adi_FeExId 	smalldatetime,
			Adi_FeVeId 	smalldatetime,
			Adi_NuIdFi 	varchar(20),
			Adi_TieRes 	int,
			Adi_NumDep 	int,
			Adi_AntLab 	int,
			Adi_FecCon 	smalldatetime,
			Adi_CaNuIn 	varchar(10),
			Adi_EntPri 	varchar(40),
			Adi_EntSeg 	varchar(40),
			PerPersoID 	int
		)
		
		insert into #Soperson(Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn,	Adi_EntPri,	Adi_EntSeg, PerPersoID)
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn,	Adi_EntPri,	Adi_EntSeg, PerPersoID 
			from SOPERSON noholdlock
			left join SOPERADI noholdlock on Per_Numero	= Adi_PerNum
			where	Per_RFC		= @Per_RFC

		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn, PerPersoID
			from #Soperson
			where Per_RFC = @Per_RFC
			order by  PerPersoID desc

		select	Per_Numero,	Adi_EntPri,	Adi_EntSeg
			from #Soperson
		where Per_RFC = @Per_RFC

		drop table #Soperson
	end
	if @Tip_ConCon	= @Str_Ocho begin /* C8 Consulta con Informacion de adicional */
		select	Per_Numero,	Per_Fecha,	Per_NumTra,	Per_Tipo,	Per_Sector,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ComDom,
				Per_EstCiv,	Per_ActEmp,	Per_Activi,	Per_ActINE,	Clp_NumPer,
				Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,	Clp_Fideic,
				Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,	Per_Titulo,
				Per_NuSeFi
			into #InformacionPer
			from SOPERSON noholdlock
				left join SOCLCAPE noholdlock on Clp_NumPer = Per_Numero
			where	Per_Numero	= @Per_Numero

		select	Num_Person	= Per_Numero,
				Loc_Nombre	= replicate(@Str_Vacio, 40),
				Ent_Nombre	= replicate(@Str_Vacio, 30),
				Act_Descri	= replicate(@Str_Vacio, 200),
				Act_NumINE	= replicate(@Str_Vacio, 6),
				Act_DesINE	= replicate(@Str_Vacio, 100),
				Act_SubSec	= replicate(@Str_Vacio, 3),
				Sus_Descri	= replicate(@Str_Vacio, 200),
				Act_Genera	= replicate(@Str_Vacio, 2),
				Act_Restri	= @Str_Vacio,
				Act_ActReg	= replicate(@Str_Vacio, 2),
				Acg_Descri	= replicate(@Str_Vacio, 100),
				Tis_Abrevi	= replicate(@Str_Vacio, 30),
				Tis_EntFin	= @Str_Vacio,
				Cli_Numero	= replicate(@Str_Vacio, 8)
			into #InformacionAdi
			from #InformacionPer

		update #InformacionAdi set
			Cli_Numero = Adi_Client
			from CLADICIO noholdlock
			where	Adi_NumPer	= Num_Person

		update #InformacionAdi set
			Loc_Nombre = CLLOCALI.Loc_Nombre
			from CLLOCALI noholdlock,
				 #InformacionPer
			where	Loc_Numero	= Per_Locali
			and		Loc_Entida	= Per_Entida
		
		select @Loc_Pais = Loc_Pais
				from CLLOCALI noholdlock,
					#InformacionPer
				where	Loc_Numero	= Per_Locali
				  and	Loc_Entida	= Per_Entida

		update #InformacionAdi set
			Ent_Nombre = CLENTIDA.Ent_Nombre
			from CLENTIDA noholdlock,
				 #InformacionPer
			where	Ent_Numero	= Per_Entida
			and		Ent_Pais	= @Loc_Pais

		update #InformacionAdi set
			Act_Descri	= CLACTIVI.Act_Descri,
			Act_NumINE	= CLACTIVI.Act_NumINE,
			Act_SubSec	= CLACTIVI.Act_SubSec,
			Act_Genera	= CLACTIVI.Act_Genera,
			Act_Restri	= CLACTIVI.Act_Restri,
			Act_ActReg 	= CLACTIVI.Act_ActReg
			from CLACTIVI noholdlock,
				 #InformacionPer
			where	Act_Numero	= Per_Activi

		update #InformacionAdi set
			Act_DesINE = CLACTINE.Act_Descri
			from CLACTINE noholdlock,
				 #InformacionPer
			where	Act_NumINE	= Act_Numero

		update #InformacionAdi set
			Sus_Descri = CLSUBSEC.Sus_Descri
			from CLSUBSEC noholdlock,
				 #InformacionPer
			where	Act_SubSec	= Sus_Numero

		update #InformacionAdi set
			Acg_Descri	= Gen_Descri 
			from CLGENERA noholdlock,
				 #InformacionPer
			where	Act_Genera = Gen_Numero

		update #InformacionAdi set
			Tis_Abrevi	= CLTIPSOC.Tis_Abrevi,
			Tis_EntFin	= CLTIPSOC.Tis_EntFin
			from CLTIPSOC noholdlock,
				 #InformacionPer
			where	Tis_Numero = Clp_TipSoc

		update #InformacionPer set
			Per_Tipo	= case when Per_Tipo <> @Tip_Moral then @Tip_Fisica else Per_Tipo end

		select	Per_Numero,	Per_Fecha,	Per_NumTra,	Per_Tipo,	Per_Sector,
				Per_Nombre,	Per_ApePat,	Per_ApeMat, Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ComDom,
				Per_EstCiv,	Per_ActEmp,	Per_Activi,	Per_ActINE,	Adi_PerNum,
				Adi_Fecha,	Adi_NumTra,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,
				Adi_RegMat,	Adi_VivCas,	Adi_TieRes,	Adi_Fax,	Adi_NumDep,
				Adi_Puesto,	Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	Adi_TelTra,
				Adi_CalTra,	Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,
				Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt,	Adi_Reside,	Adi_DocEst,
				Adi_OtDoEs,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TelExt,	Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,
				Adi_FeVeId,	Adi_NuIdFi,	Adi_EntPri,	Adi_EntSeg,	Loc_Nombre,
				Ent_Nombre,	Act_Descri,	Act_DesINE,	Sus_Descri,	Acg_Descri,
				Clp_NumPer,	Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,
				Clp_Fideic,	Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,
				Tis_Abrevi,	Tis_EntFin,	Act_Restri,	Act_ActReg,	Cli_Numero,
				Per_Titulo,	Per_NuSeFi
			from #InformacionPer
				join #InformacionAdi on Num_Person = Per_Numero
				join SOPERADI noholdlock on Per_Numero = Adi_PerNum

		drop table #InformacionPer, #InformacionAdi
	end
	if @Tip_ConCon	= @Str_Nueve begin
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_EstCiv,	Per_Email,	Per_ComDom,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_RegMat,
				Adi_VivCas,	Adi_TieRes,	Adi_Fax,	Adi_NumDep,	Adi_Puesto,
				Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_CalTra,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,
				Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt,	Adi_NuIdFi,	Adi_TipIde,
				Adi_NumIde,	Adi_FeExId,	Adi_EntPri,	Adi_EntSeg,	Adi_CalInm,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalExt,	Adi_CaNuEx,	Adi_ColExt,
				Adi_CoPoEx,	Adi_LocExt,	Adi_EntExt,	DaP_CoVeDi
			from SOPERSON noholdlock,
				 SOPERADI noholdlock,
				 SOPEDACO noholdlock
			where	Per_Numero	=  @Per_Numero
			 and	Per_Numero	*= Adi_PerNum
			 and	Per_Numero	*= DaP_Person 
	end else if @Tip_ConCon	= @Str_LetraA begin   /* Consulta Móvil por RFC **/
		create table #PersonasRFC (
			Per_Numero	char(8)
		)

		create index #PersonasRFC on #PersonasRFC(Per_Numero)

		if isnull(@Per_RFC, @Str_Vacio) <> @Str_Vacio and len(@Per_RFC) = @Len_RFCHom begin
			insert into #PersonasRFC
			select Per_Numero
			  from SOPERSON noholdlock
			 where Per_RFC = @Per_RFC
		end else if isnull(@Per_RFC, @Str_Vacio) <> @Str_Vacio and len(@Per_RFC) >= @Len_RFCOrd begin
			select @Per_RFC = @Per_RFC + @Str_Porcen

			insert into #PersonasRFC
			select Per_Numero
			  from SOPERSON noholdlock
			 where Per_RFC like @Per_RFC
		end

		select top 100 Peu_Grupo
		  into #MovilPersonaRFC
	  	  from #PersonasRFC
	  	 inner join SOUNIPER noholdlock on Per_Numero = Peu_Person
	  	 group by Peu_Grupo
        order by Peu_Grupo

		select Per_Numero, Per_Comple, Per_ComOrd, Per_RFC, Per_CURP,
			   Per_Nombre, Per_ApePat, Per_ApeMat
		  from #MovilPersonaRFC
		 inner join SOPERSON noholdlock on Peu_Grupo = Per_Numero

		drop table #PersonasRFC, #MovilPersonaRFC
	end else if @Tip_ConCon	= @Str_LetraB begin   /* Consulta Móvil por Nombre Completo**/
		select @Per_Comple = @Per_Comple + @Str_Porcen -- El porcentaje se debe poner antes de usarse en la consulta para que sea rapido
		
		select distinct top 100 Peu_Grupo Per_Numero, Per_Comple, Per_ComOrd, Per_RFC, Per_CURP,
			   Per_Nombre, Per_ApePat, Per_ApeMat
		  from SOPERSON noholdlock
	  	 inner join SOUNIPER noholdlock on Per_Numero = Peu_Grupo
		 where Per_Comple like @Per_Comple
		 order by Peu_Grupo

	end else if @Tip_ConCon = @Str_LetraC begin /*Consulta por persona registrada en internacional para tercero autorizado*/
		 select	sp.Per_Numero,	sp.Per_Tipo,	sp.Per_Benefi,	sp.Per_NuSeFi,	sp.Per_Titulo,
				sp.Per_Nombre,	sp.Per_ApePat,	sp.Per_ApeMat,	sp.Per_RazSoc,	sp.Per_Comple,
				sp.Per_ComOrd,	sp.Per_RFC,		sp.Per_CURP
			from SOPERSON sp noholdlock
			inner join ITPETEAU pe noholdlock on sp.PerPersoID = pe.Pta_PerId 
			where Per_Tipo in (@Tip_Fisica,@Tip_FisAE)
			  and Per_RFC = @Per_RFC
	end else if @Tip_ConCon = @Str_LetraD begin /*Consulta para personas que no existen en lIsta negra de Tercero autorizado*/
				select	sp.Per_Numero,	sp.Per_Tipo,	sp.Per_Benefi,	sp.Per_NuSeFi,	sp.Per_Titulo,
						sp.Per_Nombre,	sp.Per_ApePat,	sp.Per_ApeMat,	sp.Per_RazSoc,	sp.Per_Comple,
						sp.Per_ComOrd,	sp.Per_RFC,		sp.Per_CURP,	sp.PerPersoID
				from SOPERSON sp noholdlock
				where Per_Tipo	in (@Tip_Fisica,@Tip_FisAE)
				  and Per_RFC	= @Per_RFC	
				order by  PerPersoID desc
	end else if @Tip_ConCon = @Str_LetraF begin /*Consulta para obtener a todas las personas con el mismo RFC*/
		select @Per_RFC	= Per_RFC
		from SOPERSON noholdlock
		where Per_Numero = @Per_Numero
		if isnull(@Per_RFC,@Str_Vacio) = @Str_Vacio begin
			select	sp.Per_Numero,	sp.Per_Tipo,	sp.Per_Benefi,	sp.Per_NuSeFi,	sp.Per_Titulo,
				sp.Per_Nombre,	sp.Per_ApePat,	sp.Per_ApeMat,	sp.Per_RazSoc,	sp.Per_Comple,
				sp.Per_ComOrd,	sp.Per_RFC,		sp.Per_CURP
			from SOPERSON sp noholdlock
			where Per_Tipo in (@Tip_Fisica,@Tip_FisAE)
			and PerPersoID = @Ent_Cero
		end else begin
			select	sp.Per_Numero,	sp.Per_Tipo,	sp.Per_Benefi,	sp.Per_NuSeFi,	sp.Per_Titulo,
				sp.Per_Nombre,	sp.Per_ApePat,	sp.Per_ApeMat,	sp.Per_RazSoc,	sp.Per_Comple,
				sp.Per_ComOrd,	sp.Per_RFC,		sp.Per_CURP
			from SOPERSON sp noholdlock
			where Per_Tipo in (@Tip_Fisica,@Tip_FisAE)
			and Per_RFC = @Per_RFC	
		end 
	end else if @Tip_ConCon = @Str_LetraG begin /*Consulta para personas que no existen en lIsta negra de Tercero autorizado*/
	
		if @Per_RFC = @Str_Vacio begin
			select @Str_Vacio
			return 0
		end
		
		create table #PersonasBloqueadas(
			Per_Id 	   int identity,
			Per_Numero char(8)
		)
		create table #RFCBloqueados(
			Per_RFC varchar(15)
		)
		insert into #RFCBloqueados
		select Per_RFC
		from ITTELINE noholdlock 
		inner join SOPERSON noholdlock on PerPersoID = Tel_Person
		where Tel_Estatu = @Str_A
		
		insert into #PersonasBloqueadas
		select per.Per_Numero
		from #RFCBloqueados bloc 
		inner join SOPERSON per noholdlock on per.Per_RFC = bloc.Per_RFC
		
		select	per.Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn,	Adi_EntPri,	Adi_EntSeg, PerPersoID 
			from SOPERSON per noholdlock 
			inner join ITPETEAU pe noholdlock on per.PerPersoID = pe.Pta_PerId 
			left join #PersonasBloqueadas bloc noholdlock on bloc.Per_Numero = per.Per_Numero
			left join  SOPERADI noholdlock on per.Per_Numero	= Adi_PerNum
			where bloc.Per_Id is null	
			and Per_RFC		= @Per_RFC
		
		drop table #PersonasBloqueadas
		drop table #RFCBloqueados

	end else if @Tip_ConCon = @Str_LetraH begin --Consulta de personas con nombre largo

		select	PerPersoID, Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	
				Per_Titulo, Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	
				Per_Comple, Per_ComOrd,	Nol_Nombre,	Nol_ApePat,	Nol_ApeMat, 
				Nol_RazSoc,	Nol_Comple,	Nol_ComOrd,	Per_RFC,	Per_CURP,	
				Per_Calle,	Per_CalNum, Per_Coloni,	Per_Entida,	Per_Locali,	
				Per_CodPos,	Per_ApaPos, Per_LadTel,	Per_Telefo,	Per_EstCiv,	
				Per_Email, 	Per_ComDom, Per_Nacion,	Per_ActEmp,	Per_Giro,	
				Per_Sector,	Per_Activi, Per_ActINE,	Adi_LugNac,	Adi_Sexo,	
				Adi_FecNac,	Adi_RegMat, Adi_VivCas,	Adi_TieRes,	Adi_Fax,	
				Adi_NumDep,	Adi_Puesto, Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	
				Adi_TelTra,	Adi_CalTra, Adi_NuCaTr,	Adi_CalTra,	Adi_ColTra,	
				Adi_Locali,	Adi_CPTra, 	Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt,	
				Adi_NuIdFi,	Adi_TipIde, Adi_NumIde,	Adi_FeExId,	Adi_EntPri,
				Adi_EntSeg
			from SOPERSON noholdlock 
			inner join SOPERADI noholdlock on Per_Numero = Adi_PerNum
			left outer join SONOMLAR noholdlock on Nol_Person = PerPersoID
			where	Per_Numero	=  @Per_Numero

	end else if @Tip_ConCon = @Str_LetraI begin --Consulta de personas con numero de cliente

		select  @Adi_NumPer = Adi_NumPer from    CLADICIO    noholdlock where   Adi_Client  = @Per_Numero       
		select @Peu_Grupo = Peu_Grupo from SOUNIPER noholdlock where Peu_Person = @Adi_NumPer   

		select  Per_Numero, Per_Tipo,   Per_Benefi, Per_NuSeFi, Per_Titulo,  
				Per_Nombre, Per_ApePat, Per_ApeMat, Per_RazSoc, Per_Comple,
				Per_ComOrd, Per_RFC,    Per_CURP,   Per_Calle,  Per_CalNum,
				Per_Coloni, Per_Entida, Per_Locali, Per_CodPos, Per_ApaPos,
				Per_LadTel, Per_Telefo, Per_EstCiv, Per_Email,  Per_ComDom,    
				Per_Nacion, Per_ActEmp, Per_Giro,   Per_Sector, Per_Activi, 
				Per_ActINE, Adi_LugNac, Adi_Sexo,   Adi_FecNac, Adi_RegMat,    
				Adi_VivCas, Adi_TieRes, Adi_Fax,    Adi_NumDep, Adi_Puesto, 
				Adi_Ocupac, Adi_AntLab, Adi_LugTra, Adi_TelTra, Adi_CalTra,    
				Adi_NuCaTr, Adi_ColTra, Adi_Locali, Adi_CPTra,	Adi_FecCon, 
				Adi_CaNuIn, Adi_NacExt, Adi_NuIdFi, Adi_TipIde, Adi_NumIde,
				Adi_FeExId, Adi_EntPri, Adi_EntSeg, PerPersoID
			from SOPERSON noholdlock 
			left join SOPERADI noholdlock on Per_Numero = Adi_PerNum 
			where   Per_Numero  =  @Peu_Grupo

	end else if @Tip_ConCon = @Str_LetraJ begin --Consulta de personas por numero de persona, retorna persona unica 
		
		select @Peu_Grupo = Peu_Grupo from SOUNIPER noholdlock where Peu_Person = @Per_Numero	

		select	PerPersoID, Per_Numero,	Per_Tipo, Per_Benefi,	Per_NuSeFi,	
				Per_Titulo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	
				Per_Comple,	Per_ComOrd,	Per_RFC, Per_CURP, Per_Calle,	
				Per_CalNum,	Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	
				Per_ApaPos,	Per_LadTel,	Per_Telefo,	Per_EstCiv,	Per_Email,
				Per_ComDom,	Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	
				Per_Activi,	Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	
				Adi_RegMat,	Adi_VivCas, Adi_TieRes,	Adi_Fax,	Adi_NumDep,	
				Adi_Puesto,	Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	Adi_TelTra,	
				Adi_CalTra,	Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,
				Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt,	Adi_NuIdFi,	Adi_TipIde,
				Adi_NumIde,	Adi_FeExId,	Adi_EntPri,	Adi_EntSeg				
				from SOPERSON noholdlock 
				left join SOPERADI noholdlock on Per_Numero = Adi_PerNum 
				where	Per_Numero	=  @Peu_Grupo
	end 

end else begin
	select	@Per_Comple	= ltrim(rtrim(@Per_Comple)) + @Str_Porcen

	if @Tip_ConCon = @Str_Uno begin

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
				return 1
		end

		select	Per_Numero,	Per_Comple,	Per_ComOrd
			from SOPERSON noholdlock
			where	Per_Comple	like @Per_Comple
	end

	if @Tip_ConCon = @Str_Dos begin

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
				return 1
		end

		select	Per_Numero,	Per_Comple
			from SOPERSON noholdlock
			where	Per_Tipo	= @Per_Tipo
			  and	Per_Comple	like @Per_Comple

	end

	if @Tip_ConCon = @Str_Tres begin		/*	Lista de Ejecutivos de ArrendaRegio para contrato */

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_Comple'
			return 1
		end

		select	Per_Numero,	Per_Comple
			from SOPERSON noholdlock,
				 ABEJECUT noholdlock
			where	Per_Numero	= Eje_Numero
			  and	Per_Comple	like @Per_Comple
			  and	len(rtrim(ltrim(Per_Numero)))	= @Ent_Ocho
	end
	if @Tip_ConCon = @Str_Cuatro begin
		if @Per_Comple = @Str_Vacio begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_Comple'
			return 1
		end else begin

			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
				return 1
			end

			select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,	Per_Calle,
					Per_CalNum,	Per_Telefo,	Per_RFC,	Adi_FecNac,	Adi_CaNuIn,
					day(Adi_FecNac) DiaNac, month(Adi_FecNac) as MesNac, year(Adi_FecNac) as AnioNac,
					Per_Titulo, Adi_NacExt
				from SOPERSON noholdlock,
					 SOPERADI noholdlock
				where	Per_Numero	*= Adi_PerNum
				  and	Per_Comple	like @Per_Comple
				order by Per_Comple
		end
	end

	if @Tip_ConCon = @Str_Cinco begin

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
				return 1
		end

		/*Consultar SOPRAPCO*/
		exec @Status = SOPRAPCOCON
		 @Pre_Prefij 	= @Per_Comple,
		 @Existencia	= @Ent_PreCom output,
		 @NumTransac	= @NumTransac,
		 @Transaccio	= @Transaccio,
		 @Usuario		= @Usuario,
		 @FechaSis		= @FechaSis,
		 @SucOrigen		= @SucOrigen,
		 @SucDestino	= @SucDestino,
		 @Modulo		= @Modulo
		 
		 if @Status <> @Ent_Cero  begin
			select	Err_Codigo = '000001', 	
					Err_Mensaj = 'Error en consulta apellidos comunes '
			rollback
			return 1
		end	 

		if @Ent_PreCom  > @Ent_Cero begin
			select	Err_Codigo	= '000002',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
			return 1

		end

		select	Per_Numero,	Per_Comple,	Per_Calle,	Per_CalNum,	Per_Coloni,
				Per_RFC,	Adi_FecNac,	Per_Tipo,	Per_ActEmp
			from SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Per_Numero	= Adi_PerNum
			  and	Per_Comple	like @Per_Comple

	end
	if @Tip_ConCon = @Str_Seis begin /* L6 - Busqueda por Nombre y/o RFC */
		create table #Personas (
			Per_Numero	char(8),
			Per_Comple	varchar(180),
			Per_Nombre	varchar(40),
			Per_ApePat	varchar(40),
			Per_ApeMat	varchar(40),
			Per_RazSoc	varchar(180),
			Per_Entida	char(3),
			Per_Locali	char(8),
			Per_Coloni	varchar(150),
			Per_CodPos	char(6),
			Per_Calle	char(40),
			Per_CalNum	varchar(10),
			Per_RFC		varchar(15),
			Per_LadTel	varchar(8),
			Per_Telefo	char(15),
			Per_StrTip	char(1),
			Per_StAcEm	char(1),
			Adi_FecNac	smalldatetime,
			Per_Ciudad	char(40),
			Per_Estado	char(30))

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco and char_length(ltrim(rtrim(@Per_RFC))) = @Ent_Cero begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_Comple'
			return 1
		end
		if char_length(ltrim(rtrim(@Per_RFC))) < @Ent_Diez and char_length(ltrim(rtrim(@Per_Comple))) = @Ent_Cero begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_RFC'
			return 1
		end

		select	@Per_RFC	= ltrim(rtrim(@Per_RFC)) + @Str_Porcen

		if char_length(ltrim(rtrim(@Per_Comple))) > @Ent_Uno and char_length(ltrim(rtrim(@Per_RFC))) = @Ent_Uno begin
			insert into #Personas
				select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc, Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,
						Per_Calle,	Per_CalNum,	Per_RFC,	Per_LadTel,	Per_Telefo,
						Per_Tipo,	Per_ActEmp, @Fec_Vacio,	@Str_Vacio,	@Str_Vacio
					from SOPERSON noholdlock
					where	Per_Comple like @Per_Comple OR Per_ComOrd like @Per_Comple
		end else if char_length(ltrim(rtrim(@Per_Comple))) = @Ent_Uno and char_length(ltrim(rtrim(@Per_RFC))) > @Ent_Uno begin
			insert into #Personas
				select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc, Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,
						Per_Calle,	Per_CalNum,	Per_RFC,	Per_LadTel,	Per_Telefo,
						Per_Tipo,	Per_ActEmp, @Fec_Vacio, @Str_Vacio,	@Str_Vacio
					from SOPERSON noholdlock
					where	Per_RFC	like @Per_RFC
		end else if char_length(ltrim(rtrim(@Per_Comple))) > @Ent_Uno and char_length(ltrim(rtrim(@Per_RFC))) > @Ent_Uno begin
			insert into #Personas
				select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc, Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,
						Per_Calle,	Per_CalNum,	Per_RFC,	Per_LadTel,	Per_Telefo,
						Per_Tipo,	Per_ActEmp, @Fec_Vacio, @Str_Vacio,	@Str_Vacio
					from SOPERSON noholdlock
					where	(Per_Comple like @Per_Comple OR Per_ComOrd like @Per_Comple)
					  and	Per_RFC	like @Per_RFC
		end

		update #Personas set
			Adi_FecNac = case when Per_StrTip <> @Tip_Moral then SOPERADI.Adi_FecNac
						 else Adi_FecCon end
			from SOPERADI noholdlock 
			where	Per_Numero	= Adi_PerNum

		update #Personas set
			Per_Ciudad = Loc_Nombre
			from CLLOCALI noholdlock
			where	Loc_Numero	= Per_Locali

		update #Personas set
			Per_Estado = Ent_Nombre
			from CLENTIDA noholdlock
			where	Ent_Numero	= Per_Entida

		select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
				Per_RazSoc, Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,
				Per_Calle,	Per_CalNum,	Per_RFC,	Per_LadTel,	Per_Telefo,
				Adi_FecNac,	Per_Ciudad, Per_Estado,	Per_StrTip as _Tipo,	Per_StAcEm as _ActEmp,
				Per_Tipo	= case Per_StrTip when @Tip_Moral then @Per_Moral else @Per_Fisica end,
				Per_ActEmp	= case 
								when Per_StrTip = @Tip_Moral then @Str_Vacio
								when Per_StrTip <> @Tip_Moral and Per_StAcEm = @Sta_Si then @Str_Si
								when Per_StrTip <> @Tip_Moral and Per_StAcEm <> @Sta_Si then @Str_No  end
			from #Personas
			order by Per_Comple

		drop table #Personas
	end
	if @Tip_ConCon = @Str_Siete begin /* L7 - Valida existencias por Per_RFC y Per_Comple
								Donde T: Es Totalmente (RFC Completo) compatible con otra persona
									  P: Es Parcialmente (RFC Parcial) compatible */
		create table #PersonasExis (
			Per_Numero	char(8),
			Per_Comple	varchar(180),
			Per_Nombre	varchar(40),
			Per_ApePat	varchar(40),
			Per_ApeMat	varchar(40),
			Per_RazSoc	varchar(180),
			Per_RFC		varchar(15),
			Per_Coinci	char(1))

		if char_length(ltrim(rtrim(@Per_RFC))) != @Ent_Diez and 
		   char_length(ltrim(rtrim(@Per_RFC))) != @Ent_Doce and
		   char_length(ltrim(rtrim(@Per_RFC))) != @Ent_Trece begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_RFC'
			return 1
		end
		if char_length(ltrim(rtrim(@Per_Comple))) = 1 begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= @Msj_MasInf,
					Err_Variab	= 'Per_Comple'
			return 1
		end

		/* SE BUSCA POR RFC COMPLETO */
		if char_length(ltrim(rtrim(@Per_RFC))) = @Ent_Doce or
		   char_length(ltrim(rtrim(@Per_RFC))) = @Ent_Trece begin
			insert into #PersonasExis
				select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc, Per_RFC,	@Coi_Total
					from SOPERSON noholdlock
					where	Per_RFC		= @Per_RFC
					  and	Per_Numero	<> @Per_Numero
		end

		if @Per_Tipo <> @Tip_Moral begin /* SE BUSCA POR RFC CORTO Y NOMBRES */
			select @Per_RFC = substring(@Per_RFC, 1, 10) + @Str_Porcen

			insert into #PersonasExis
				select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc, Per_RFC,	@Coi_Parcia
					from SOPERSON noholdlock
					where	Per_RFC		like @Per_RFC
					  and	Per_Comple	= @Per_Comple
					  and	Per_Numero	<> @Per_Numero
					  and	Per_Numero	not in (select Per_Numero from #PersonasExis)
			
		end

		select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
				Per_RazSoc,	Per_RFC,	Per_Coinci
			from #PersonasExis
			order by Per_Coinci desc, Per_Numero

		drop table #PersonasExis 
	end
	
	if @Tip_ConCon = @Str_Nueve begin /* L9 - Busqueda y/o RFC que incluye el numero de cliente */
	
		/* Creamos la tabla temporal */
		create table #PersonasRfc (
			Per_Numero	char(8),
			Per_Tipo	char(1) null,
			Per_Nombre	varchar(40) null,
			Per_ApePat	varchar(40) null,
			Per_ApeMat	varchar(40) null,
			Per_RazSoc	varchar(180) null,
			Per_Comple	varchar(180) null,
			Per_RFC		varchar(15) null,
			Per_Calle	char(40) null,
			Per_CalNum	varchar(10) null,
			Per_Entida	char(3) null,
			Per_Locali	char(8) null,
			Per_CodPos	char(6) null,
			Per_Coloni	varchar(150) null,
			Per_LadTel	varchar(8) null,
			Per_Telefo	char(15) null,
			Per_Email	varchar(50) null,
			Per_ActEmp	char(1) null,
			Adi_FecNac	smalldatetime null,
			Adi_Sexo	char(1) null,
			Cli_Numero	char(8) null,
			Per_NumTra	char(10) null,
			Per_Fecha	smalldatetime null,
			Adi_TelTra	varchar(20) null,
			Adi_FecCon	smalldatetime null
		)
		
		/* Si no se encontro en las tablas SOPERSON y CLCLIENT seguimos el proceso normal*/
		if (@Per_Numero is null or @Per_Numero = @Str_Vacio)  
		begin
			
			select @Per_RFC = ltrim(rtrim(@Per_RFC))
			
			/* Validamos que se haya recibido el RFC */
			if @Per_RFC is null or @Per_RFC = @Str_Vacio begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Capture el RFC',
						Err_Variab	= 'Per_RFC'
				return 1
			end
			
				/* Buscamos el RFC completo en SOPERSON */
			select	@Ent_NumReg=1 from SOPERSON noholdlock
			where Per_RFC = @Per_RFC and Per_Tipo in (@Tip_Moral, @Tip_Fisica, @Tip_FisAE)
				if (@Ent_NumReg > 0)
					begin
						insert into #PersonasRfc
							select	Per_Numero,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
									Per_RazSoc,	Per_Comple,	Per_RFC,	Per_Calle,	Per_CalNum,	
									Per_Entida,	Per_Locali,	Per_CodPos,	Per_Coloni,	Per_LadTel,
									Per_Telefo,	Per_Email,	Per_ActEmp,	@Fec_Vacio,	@Str_Vacio,
									null,		Per_NumTra,	Per_Fecha,	null,		null
						from SOPERSON noholdlock
							where Per_RFC = @Per_RFC and Per_Tipo in (@Tip_Moral, @Tip_Fisica, @Tip_FisAE)
							
					end else begin
						
						select @Per_RFC = substring(@Per_RFC, 1, char_length(@Per_RFC) - 3) + @Str_Porcen
						
						/* Realizamos la primer consulta SOPERSON */
						insert into #PersonasRfc
							select	Per_Numero,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
									Per_RazSoc,	Per_Comple,	Per_RFC,	Per_Calle,	Per_CalNum,
									Per_Entida,	Per_Locali,	Per_CodPos,	Per_Coloni,	Per_LadTel,
									Per_Telefo,	Per_Email,	Per_ActEmp,	@Fec_Vacio,	@Str_Vacio,
									null,		Per_NumTra,	Per_Fecha,	null,		null
							from SOPERSON noholdlock
							where	Per_Tipo in (@Tip_Moral, @Tip_Fisica, @Tip_FisAE) and Per_RFC	like @Per_RFC
				end
			end else begin
			insert into #PersonasRfc
				select	Per_Numero,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
						Per_RazSoc,	Per_Comple,	Per_RFC,	Per_Calle,	Per_CalNum,
						Per_Entida,	Per_Locali,	Per_CodPos,	Per_Coloni,	Per_LadTel,
						Per_Telefo,	Per_Email,	Per_ActEmp,	@Fec_Vacio,	@Str_Vacio,
						null,		Per_NumTra,	Per_Fecha,	null,		null
				from SOPERSON noholdlock
				where	Per_Numero	= @Per_Numero
			end
		
		
		update #PersonasRfc set
			Adi_FecNac	= SOPERADI.Adi_FecNac,
			Adi_FecCon	= SOPERADI.Adi_FecCon,
			Adi_Sexo	= SOPERADI.Adi_Sexo,
			Adi_TelTra	= SOPERADI.Adi_TelTra
			from SOPERADI noholdlock 
			where	#PersonasRfc.Per_Numero	= Adi_PerNum
			

		/* Actualizamos la tabla con el nÃºmero de cliente relacionando con CLADICIO */
		update #PersonasRfc set
			Cli_Numero	= Adi_Client
			from CLADICIO noholdlock
			where #PersonasRfc.Per_Numero = Adi_NumPer

		/* Ejecutamos el select para devolver la informacion */
			select	Per_Numero,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_RazSoc,	Per_Comple,	Per_RFC,	Per_Calle,	Per_CalNum,
					Per_Entida,	Per_Locali,	Per_CodPos,	Per_Coloni,	Per_LadTel,
					Per_Telefo,	Per_Email,	Per_ActEmp,	NULLIF(Adi_FecNac,@Fec_Vacio) AS Adi_FecNac,
					Adi_Sexo,	Cli_Numero,	Per_NumTra,	Per_Fecha,	Adi_TelTra,
					Adi_FecCon
			from #PersonasRfc noholdlock
			order by Per_Comple
			
		drop table #PersonasRfc
	end	else if @Tip_ConCon	= @Str_LetraA begin
		
		select	@Rfc_Like	= @Per_RFC	+ @Str_Porcen
		
		if char_length(ltrim(rtrim(@Per_RFC)))	= @Ent_Trece begin
			select	PerPersoID, Per_RFC, Per_Comple		/* LA - Busqueda con RFC completo*/
				from SOPERSON noholdlock
				where	Per_Tipo	<> @Tip_Moral
				  and	Per_RFC		= @Per_RFC
		end else begin 
			select	PerPersoID, Per_RFC, Per_Comple		/* LA - Busqueda con RFC incompleto*/
				from SOPERSON noholdlock
				where	Per_Tipo	<> @Tip_Moral
			  	  and	Per_RFC		like @Rfc_Like
		end
	end else if @Tip_ConCon = @Str_LetraB begin
		
		select PER.Per_Nombre,	PER.Per_ApePat,	PER.Per_ApeMat,	PER.Per_RFC, PER.Per_Calle,
				PER.Per_CalNum,	PER.Per_Coloni,	PER.Per_Locali,	PER.Per_CodPos,	PER.Per_Telefo,
				PER.Per_EstCiv,	PER.Per_Nacion,	PER.Per_ActEmp,	PER.Per_Activi,
				Per_FecNac = PDI.Adi_FecNac,
				PER.PerPersoID, PER.Per_Tipo, PDI.Adi_Sexo,	PER.Per_CURP, PER.Per_Comple,
				PER.Per_Entida, PER.Per_LadTel, PDI.Adi_FecCon, PER.Per_ActINE, PDI.Adi_FecCon,
				PER.Per_RazSoc, PER.Per_Numero, max(isnull(CAD.Adi_Client,@Str_Vacio)) as Adi_Client
			from SOPERSON PER noholdlock
			left join SOPERADI PDI noholdlock on PER.Per_Numero	= PDI.Adi_PerNum
			left join CLADICIO CAD noholdlock on PER.Per_Numero = CAD.Adi_NumPer
			where	PER.Per_RFC	= @Per_RFC
			group by PER.Per_Nombre,    PER.Per_ApePat,    PER.Per_ApeMat,    PER.Per_RFC, PER.Per_Calle,
                PER.Per_CalNum,    PER.Per_Coloni,    PER.Per_Locali,    PER.Per_CodPos,    PER.Per_Telefo,
                PER.Per_EstCiv,    PER.Per_Nacion,    PER.Per_ActEmp,    PER.Per_Activi,
                PDI.Adi_FecNac,
                PER.PerPersoID, PER.Per_Tipo, PDI.Adi_Sexo,    PER.Per_CURP, PER.Per_Comple,
                PER.Per_Entida, PER.Per_LadTel, PDI.Adi_FecCon, PER.Per_ActINE, PDI.Adi_FecCon,
                PER.Per_RazSoc, PER.Per_Numero
	end
	
	
end