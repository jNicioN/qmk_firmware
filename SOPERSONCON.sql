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
		@Rpp_PerRel	char(8),
		@Ent_PreCom	int,
		@Loc_Pais	char(3),
		@Busqueda	varchar(100),
		@Suc_Numero	varchar(3)

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
		@Str_Tres	char(1),
		@Per_RFCSH	varchar(15),
		@Tip_FisAE	char(1),
		@Msj_MasInf	varchar(41),
		@Sin_Direcc varchar(50),
		@Sta_Termin char(1),
		@Str_Usuari varchar(10)

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
		@Tip_FisAE = '3',			-- Tipo de Persona Fisica con Act. Emp.
		@Per_Fisica	= 'FISICA',
		@Per_Moral	= 'MORAL',
		@Str_Tres	= '3',
		@Msj_MasInf	= 'Capture más información para la busqueda',
		@Sin_Direcc = 'Sin Direcci&oacuten',
		@Sta_Termin	= 'T',			-- Status de Terminado
		@Str_Usuari = 'USUARIO'		-- String Usuario
		
select	@Busqueda	= @Per_Comple
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin
	if @Tip_ConCon	= '1' begin
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
	if @Tip_ConCon	= '2' begin
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
	if @Tip_ConCon	= '3' begin
		select	Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE
			from SOPERSON noholdlock
			where	Per_Tipo	= @Per_Tipo
	end
	if @Tip_ConCon	= '4' begin			/* Consulta De Ejecutivo en Base A Su RFC	*/
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
	if @Tip_ConCon = '5' begin				/*	Consulta De Ejecutivos De Arrendadora	*/
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
	if @Tip_ConCon = '6' begin	/*	Consulta persona por RFC*/
		select	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RFC,	Per_Calle,
				Per_CalNum,	Per_Coloni,	Per_Locali,	Per_CodPos,	Per_Telefo,
				Per_EstCiv,	Per_Nacion,	Per_ActEmp,	Per_Activi,
				Per_FecNac	= Adi_FecNac
			from SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Per_Numero	*= Adi_PerNum
			  and	Per_RFC		= @Per_RFC
	end
	if @Tip_ConCon = '7' begin	/*	Consulta persona Toda la inf por RFC*/
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
			into #Soperson
			from SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Per_Numero	*= Adi_PerNum
			  and	Per_RFC		= @Per_RFC

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
			order by  PerPersoID desc

		select	Per_Numero,	Adi_EntPri,	Adi_EntSeg
			from #Soperson

		drop table #Soperson
	end
	if @Tip_ConCon	= '8' begin /* C8 Consulta con Informacion de adicional */
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
	if @Tip_ConCon	= '9' begin
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
	end else if @Tip_ConCon	= 'A' begin   /* Consulta Móvil por RFC **/
		select Peu_Grupo as Per_Numero, Per_Comple, Per_ComOrd, Per_RFC, Per_CURP
		  from SOPERSON noholdlock
		  join SOUNIPER noholdlock on Per_Numero = Peu_Person 
		 where Per_RFC = @Per_RFC
	end else if @Tip_ConCon	= 'B' begin   /* Consulta Móvil por Nombre Completo**/
		select Peu_Grupo as Per_Numero, Per_Comple, Per_ComOrd, Per_RFC, Per_CURP
		  from SOPERSON noholdlock
		  join SOUNIPER noholdlock on Per_Numero = Peu_Person 
		  where Per_Comple like @Per_Comple + '%'
	end
end else begin
	select	@Per_Comple	= ltrim(rtrim(@Per_Comple)) + @Str_Porcen

	if @Tip_ConCon = '1' begin

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

	if @Tip_ConCon = '2' begin

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

	if @Tip_ConCon = '3' begin		/*	Lista de Ejecutivos de ArrendaRegio para contrato */

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
	if @Tip_ConCon = '4' begin
		if @Per_Comple = @Str_Vacio begin
			select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_Entida,	Per_Locali,	Per_Coloni,	Per_CodPos,	Per_Calle,
					Per_CalNum,	Per_Telefo,	Per_RFC,	Adi_FecNac,	Adi_CaNuIn,
					day(Adi_FecNac) DiaNac, month(Adi_FecNac) as MesNac, year(Adi_FecNac) as AnioNac,
					Per_Titulo,	Adi_NacExt
				from SOPERSON noholdlock,
					 SOPERADI noholdlock
				where	Per_Numero	*= Adi_PerNum
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

	if @Tip_ConCon = '5' begin

		if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= @Msj_MasInf,
						Err_Variab	= 'Per_Comple'
				return 1
		end

		/*Consultar SOPRAPCO*/
		exec SOPRAPCOCON
		 @Pre_Prefij 	= @Per_Comple,
		 @Existencia	= @Ent_PreCom output,
		 @NumTransac	= @NumTransac,
		 @Transaccio	= @Transaccio,
		 @Usuario		= @Usuario,
		 @FechaSis		= @FechaSis,
		 @SucOrigen		= @SucOrigen,
		 @SucDestino	= @SucDestino,
		 @Modulo		= @Modulo

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
	if @Tip_ConCon = '6' begin /* L6 - Busqueda por Nombre y/o RFC */
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
			_Tipo	char(1),
			_ActEmp	char(1),
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
			Adi_FecNac = case when _Tipo <> @Tip_Moral then SOPERADI.Adi_FecNac
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
				Adi_FecNac,	Per_Ciudad, Per_Estado,	_Tipo,	_ActEmp,
				Per_Tipo	= case _Tipo when @Tip_Moral then @Per_Moral else @Per_Fisica end,
				Per_ActEmp	= case 
								when _Tipo = @Tip_Moral then @Str_Vacio
								when _Tipo <> @Tip_Moral and _ActEmp = @Sta_Si then @Str_Si
								when _Tipo <> @Tip_Moral and _ActEmp <> @Sta_Si then @Str_No  end
			from #Personas
			order by Per_Comple

		drop table #Personas
	end
	if @Tip_ConCon = '7' begin /* L7 - Valida existencias por Per_RFC y Per_Comple
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
			print 'entre 1'
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
			
			print 'entre 2'
		end

		select	Per_Numero,	Per_Comple,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
				Per_RazSoc,	Per_RFC,	Per_Coinci
			from #PersonasExis
			order by Per_Coinci desc, Per_Numero

		drop table #PersonasExis 
	end
	if @Tip_ConCon = '8' begin /* busqueda de personas-apertura nueva cuenta-sibamex3 */
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin--Busqueda por numero de cliente/persona 
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return 1
			end
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end

			select	Cli_Numero as Per_Numero,
					Cli_Numero as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(3) as Per_Nacion,
					Cli_RFC as Per_RFC,
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(1) + Cli_CalNum + @Str_Coma + space(1) + Cli_Coloni + @Str_Coma + space(1) +
					Loc_Nombre + @Str_Coma + space(1) + Ent_Nombre as Per_Calle,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(con.Con_FeEsCl, cla.Adi_FecNac)
					else
						cla.Adi_FecNac
					end as Adi_FecNac,
					con.Con_TipIde as Adi_TipIde,
					con.Con_NumIde as Adi_NumIde,
					cla.Adi_NumPer as Per_NumPer
					into #ClientesPorNumero
			from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
					left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
			where	Cli_Numero = @Busqueda and Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti)
			
			--Obtener las personas por el numero
			select	Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasPorNumeroRecientes
				from SOPERSON noholdlock
				where	Per_Numero	= @Busqueda
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC, 					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(1) + Per_CalNum 
					+ @Str_Coma + space(1) + Per_Coloni + @Str_Coma + space(1) +
					Loc_Nombre + @Str_Coma + space(1) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle ,
					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		@Str_Vacio as Clp_TipSoc, @Str_Vacio as Clp_NomSoc,  per.Per_Nacion
				into #PersonaPorNumero
				from #PersonasPorNumeroRecientes per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum					
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
				select Per_Numero,	Per_ComOrd,	Per_RFC, Per_Calle ,					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc,  Clp_NomSoc,  Per_Nacion,
					DaP_CoVeDi 
				into #PersonaNumero
				from #PersonaPorNumero
					left join SOPEDACO noholdlock on DaP_Person = Per_Numero

			--Agrupar Clientes y Personas por numero 			
			select	Per_Numero, Per_NumTra, Per_Titulo, Per_ComOrd, Per_RFC, 
			Per_Calle, Per_Tipo, Per_Nombre, Per_ApePat, Per_ApeMat, 
			Per_RazSoc, Adi_FecNac, Adi_TipIde, Adi_NumIde, Per_Nacion,
			Per_NumPer
			from  #ClientesPorNumero
			union all
			select distinct Per_Numero, case when DaP_CoVeDi=@Sta_Termin then @Str_Usuari else @Str_Prospe 	end as Per_NumTra, 
			@Tip_Fisica as Per_Titulo, 
			Per_ComOrd, Per_RFC, Per_Calle, Per_Tipo, Per_Nombre, 
			Per_ApePat, Per_ApeMat, @Str_Vacio as Per_RazSoc, Adi_FecNac, 
			Adi_TipIde, Adi_NumIde, Per_Nacion, Per_Numero as Per_NumPer
			from  #PersonaNumero
				
					
			drop table #PersonasPorNumeroRecientes
			drop table #PersonaPorNumero
			drop table #ClientesPorNumero
			drop table #PersonaNumero
			
		end else begin-- Busqueda por nombre cliente/persona
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 4 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return 1
			end
			
			--Se busca al cliente por el nombre
			select	Cli_Numero,	Cli_ComOrd,	Cli_RFC,	Cli_Calle,	Cli_CalNum,
					Cli_Coloni,	Cli_Locali,	Cli_Entida,	Cli_Tipo,	Cli_ActEmp,
					Cli_Nombre,	Cli_ApePat,	Cli_ApeMat,	Adi_FecNac,	Con_NomSoc,
					Con_TipSoc,	Con_FeEsCl,	Con_TipIde,	Con_NumIde, Adi_NumPer as Per_NumPer
				into #Clientes
				from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
				where	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) and Cli_Comple	like @Per_Comple

			select	Cli_Numero as Per_Numero,
					Cli_Numero + space(1) as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(3) as Per_Nacion, 
					Cli_RFC as Per_RFC,
					(CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(1) + Cli_CalNum + @Str_Coma + space(1) + Cli_Coloni + @Str_Coma + space(1) +
					Loc_Nombre + @Str_Coma + space(1) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle ,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_FeEsCl, Adi_FecNac)
					else
						Adi_FecNac
					end as Adi_FecNac,
					Con_TipIde as Adi_TipIde,
					Con_NumIde as Adi_NumIde,
					cli.Per_NumPer
				into #ClientesProspectos
				from #Clientes cli
					inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					
					
					--Se busca se a la persona por el nombre
			select	Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasRecientes
				from SOPERSON noholdlock
				where	Per_Comple	like @Per_Comple
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC,	Per_Calle,	Per_CalNum,
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc, Clp_NomSoc,  per.Per_Nacion 
				into #Persona
				from #PersonasRecientes per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum
					left join SOCLCAPE cla noholdlock on spe.Per_Numero =  Clp_NumPer
			
			--Se inserta al prospecto
			insert into #ClientesProspectos
			select	Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					Per_RFC,
					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(1) + Per_CalNum + @Str_Coma + space(1) + Per_Coloni + @Str_Coma + space(1) +
					Loc_Nombre + @Str_Coma + space(1) + Ent_Nombre  ELSE @Sin_Direcc END) as Per_Calle ,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
					end as Per_Tipo,
					case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
					end as Per_Nombre,
					Per_ApePat,
					Per_ApeMat,
					isnull(Clp_TipSoc, @Str_Vacio) as Per_RazSoc,
					Adi_FecNac,
					Adi_TipIde,
					Adi_NumIde,
					Per_Numero as Per_NumPer
				from #Persona
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
					
					--se inserta al usuario de compra venta si existe
		insert into #ClientesProspectos
			select	Per_Numero,
					@Str_Usuari as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					Per_RFC,
					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(1) + Per_CalNum + @Str_Coma + space(1) + Per_Coloni + @Str_Coma + space(1) +
					Loc_Nombre + @Str_Coma + space(1) + Ent_Nombre  ELSE @Sin_Direcc END) as Per_Calle ,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
					end as Per_Tipo,
					case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
					end as Per_Nombre,
					Per_ApePat,
					Per_ApeMat,
					isnull(Clp_TipSoc, @Str_Vacio) as Per_RazSoc,
					Adi_FecNac,
					Adi_TipIde,
					Adi_NumIde,
					Per_Numero as Per_NumPer
				from #Persona
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					left join SOPEDACO noholdlock on DaP_Person = Per_Numero
					    where DaP_CoVeDi in (@Sta_Termin)
			
			select	distinct
					Per_Numero,	Per_NumTra,	Per_Titulo,	Per_ComOrd,	Per_RFC,
					Per_Calle,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_RazSoc,	Adi_FecNac,	Adi_TipIde,	Adi_NumIde, Per_Nacion, 
					Per_NumPer
				from #ClientesProspectos
				
			drop table #ClientesProspectos
			drop table #Clientes
			drop table #Persona
			drop table #PersonasRecientes
		end
		
	end
	if @Tip_ConCon = '9' begin /* L9 - Busqueda y/o RFC que incluye el numero de cliente */
	
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
				if exists(select 1 from SOPERSON noholdlock
								where Per_RFC = @Per_RFC
								and ((@Per_Tipo = @Tip_Moral and Per_Tipo = @Per_Tipo)
								or (Per_Tipo = @Tip_Fisica or Per_Tipo = @Tip_FisAE)))
					begin
						insert into #PersonasRfc
							select	Per_Numero,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
									Per_RazSoc,	Per_Comple,	Per_RFC,	Per_Calle,	Per_CalNum,	
									Per_Entida,	Per_Locali,	Per_CodPos,	Per_Coloni,	Per_LadTel,
									Per_Telefo,	Per_Email,	Per_ActEmp,	@Fec_Vacio,	@Str_Vacio,
									null,		Per_NumTra,	Per_Fecha,	null,		null
						from SOPERSON noholdlock
							where Per_RFC = @Per_RFC
							and ((@Per_Tipo = @Tip_Moral and Per_Tipo = @Per_Tipo)
							or (Per_Tipo = @Tip_Fisica or Per_Tipo = @Tip_FisAE))
							
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
							where	Per_RFC	like @Per_RFC
							and ((@Per_Tipo = @Tip_Moral and Per_Tipo = @Per_Tipo)
							or (Per_Tipo = @Tip_Fisica or Per_Tipo = @Tip_FisAE))
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
	end	
end