create procedure SOMONEDACON(
	@Mon_Numero char(2),
	@Mon_Descri varchar(30),
	@Mon_Fecha	smalldatetime,
	@Tip_Consul	char(2),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))
	
as

/*
****************************************************************************
** ** Consulta alfabetica o numerica de una Moneda **					****
****************************************************************************
*/

/*
****************************************************************************
** Modifico:	Hébel Cruz												****
** Fecha:		11/04/25												****
** HelpDesk:	TCELTO-12900											****
** Descripcion:	Agrega consulta para metales por número   				****				
****************************************************************************
** Modifico:	Joel Barcenas											****
** Fecha:		18/Sep/19												****
** HelpDesk:	1184558													****
** Descripcion:	Agrega consulta de Tipo de cambio para   				****
						Pantallas de Sucursal en L9						****
****************************************************************************
** Modifico:	Francisco Mora											****
** Fecha:		11/Oct/18												****
** HelpDesk:	1071093													****
** Descripcion:	Agrega consulta monedas tradair L8						****
****************************************************************************
** Modifico:	Felipe Castillo Rendon									****
** Fecha:		12/Abr/18												****
** HelpDesk:	1105258													****
** Descripcion:	Agrega campo Mon_FixVen en L1							****
****************************************************************************
** Modifico:	Claudia Sandoval										****
** Fecha:		27/Ene/18												****
** HelpDesk:	00929417												****
** Descripcion:	Agrega abreviacion en L1								****
****************************************************************************
** Modifico:	Juan de Dios Escalera									****
** Fecha:		20/Ene/17										****
** HelpDesk:	00914651												****
** Descripcion:	Se agrega consulta L6 y CR para	Cartas de credito		****
****************************************************************************
** Modifico:	Gregorio Martinez Antonio								****
** Fecha:		16/Febrero/2017											****
** HelpDesk:	00922796												****
** Descri:		Se agrega L7 para Consulta de Monedas de Derivados		****
****************************************************************************
** Modifico:	Ma. Dolores Hdz.										****
** Fecha:		07/Mayo/2015											****
** HelpDesk:	00763425												****
** Descripcion:	Se agrega consulta L5  	 								****
****************************************************************************
** Modifico:	Eugenio Chairez Flores									****
** Fecha:		27/Marzo/2014											****
** HelpDesk:	00644755												****
** Descripcion:	Se agrega consulta para 	Mon_AbrISO 					****
****************************************************************************
** Modifico:	Eugenio Salazar Orta									****
** Fecha:		22/Agosto/2012											****
** HelpDesk:	00452411												****
** Descripcion:	Se agrega consulta para Derivados (SIDE)				***
****************************************************************************
** Modifico:	Claudia V Sandoval P									****
** Fecha:		30/Nov/2011												****
** Help:		00384210												****
** Descripcion:	Monedas utilizadas en Creditos L4 y Consulta de FixVen LB***
****************************************************************************
** Modifico:	Jose M. Hernandez Lugo									****
** Fecha:		10/Noviembre/2011										****
** HelpDesk:    00385031												****
** Descripcion:	Se agrego el campo Mon_AbrISO para la Consulta 'C1'		****
****************************************************************************
** Modifico:	Marco A. Morales Ventura								****
** Fecha:		03/Jun/2011												****
** HelpDesk:	00195888												****
** Descripcion:	Se agrego el campo Mon_RevBal para la Consulta 'C1'		****
****************************************************************************
** Modifico:	Eugenio Salazar Orta									****
** Fecha:		30/Junio/2008											****
** Help:		00066738												****
** Descripcion:	Agregar cons. para ventanilla @Con_LimFac				****
**				y modificar la de Cajeros para tomar Factor				****
****************************************************************************
** Modifico:	Arnoldo Garza Quezada									****
** Fecha:		18/Febrero/2007											****
** Descripcion:	Agregar consulta CT para Cajero Automatico				****
**				para Dispensar Dolares									****
** Requisicion :3619													****
****************************************************************************
** Modifico:	Adrian Labastida										****
** Fecha:		09/Feb/2007												****
** Descripcion:	Agregar consulta C9 para Pizarron TE					****
****************************************************************************
**					STORE CONVERTIDO									****
**	Convirtio:	Perla Judith Abundis Orozco 							****
** 	Fecha:		12/Jun/2006												****
****************************************************************************
** Modifico:	Estela Mendoza											****
** Fecha:		09/Jun/2006												****
** Descripcion:	Agregar consulta CA										****
** Help No.:	j														****
****************************************************************************
**  				Store CONVERTIDO 									****
*** Convirtio:	fcHIA			 										****
*** Fecha:		17/Marzo/2005											****
****************************************************************************
** Modifico:	Fchia													****
** Fecha:		17/MArzo/2005											****
** Descripcion:	Agregar consulta C8										****
** Help No.:	jAVA													****
****************************************************************************
** Modifico:	Laura V. Vazquez Nieto									****
** Fecha:		17/Noviembre/2004										****
** Descripcion:	Agregar consulta de los metales 'L3'.					****
** Help No.:	70434													****
****************************************************************************
** Modifico:	Laura V. Vazquez Nieto									****
** Fecha:		14/Octubre/2004											****
** Descripcion:	Agregar el campo Mon_ForMet								****
****************************************************************************
** Modifico:	Laura V. Vazquez Nieto									****
** Fecha:		30/Septiembre/2004										****
** Descripcion:	Agregar el campo Mon_Tipo a consulta de lista			****
****************************************************************************
**				Store CONVERTIDO										****
** Convirtio: Laura Elena Cervantes Delgadillo							****
** Fecha: 08/Sep/2004													****
****************************************************************************
** Modifico:		Laura V. Vazquez Nieto								****
** Fecha:		01/Septiembre/2004										****
** Descripcion:	Agregar el campo Mon_Tipo a consulta de llave principal.****
**																		****
****************************************************************************
**				Store CONVERTIDO 										****
****************************************************************************
** Modifico:	Laura V. Vazquez Nieto									****
** Fecha:		06/Julio/2004											****
** Descripcion:	Agregar el campo Mon_Tipo								****
****************************************************************************
** Modifico:	Ma de Lourdes Valdes Ramirez							****
** Fecha:		13/Abril/2004											****
** Descripcion:	Agregar el campo Mon_DesLeg								****
****************************************************************************
** Modifico:	Mayra Estrada											****
** Fecha:		11/Marzo/2004											****
** Descripcion:	Quitar asignacion de Str_Vacio a Fecha.					****
****************************************************************************
** Modifico:	Eduardo Salazar Gutierrez								****
** Fecha:		03/Marzo/04												****
** Descripcion:	Considerar fecha en consulta Tipo Fix Val				****
****************************************************************************
** Modifico:	Laura Elena Cervantes D.								****
** Fecha:		10/Noviembre/03											****
** Descripcion:	Agregre Consulta de Tipo Fix Valuacion					****
****************************************************************************
** Modifico:	Eduardo Salazar Gutierrez								****
** Fecha:		28/Octubre/03											****
** Descripcion:	Considerar Mon_Fecha en consulta principal				****
****************************************************************************
** Modifico:	Laura Elena Cervantes D.								****
** Fecha:		24/Octubre/03											****
** Descripcion:	Tomar Mon_FixCom/Ven del FixVal 48h Antes				****
****************************************************************************
** Modifico:	Laura Elena Cervantes D.								****
** Fecha:		16/Octubre/03											****
** Descripcion:	Tomar Mon_FixCom/Ven del FixVal 48h Antes				****
****************************************************************************
** Modifico:	Roberto Gutierrez Sanchesz.								****
** Fecha:		22/Julio/03												****
** Descripcion:	Se agrego el campo Mon_FixVal.							****
****************************************************************************
** Modifico:	Lucina Gonzalez Trejo									****
** Fecha:		16/Julio/2003											****
** Descripcion:	Agregar el campo Mon_DesCor								****
****************************************************************************
** Modifico:	Ricardo Elizondo Guerrero								****
** Fecha:		09/Mayo/2003											****
** Descripcion:	Consulta De Exportador Arrendadora Varios				****
****************************************************************************
** Modifico:	Eduardo Salazar Gtz.									****
** Fecha:		21/Ene/03												****
** Descripcion:	Se agrego el tipo de consulta para precios				****
**				spot para monedas de cambios							****
****************************************************************************
** Modifico:	Eduardo Salazar Gtz.									****
** Fecha:		17/Ene/03												****
** Descripcion:	Se elimino el campo Mon_TasCam y se agrego				****
**				el campo Mon_CieDia										****
****************************************************************************
** Modifico:	Roberto Gutierrez Sanchez								****
** Fecha:		20/Dic/02												****
** Descripcion:	Se agregaron los campos Mon_OpeCam y Mon_TasCam. Se 	****
**				agrego el tipo de consulta de Monedas de Cambios.		****
****************************************************************************
** Modifico:	Ma de Lourdes Valdes Ramirez							****
** Fecha:		09/Diciembre/2002										****
** Descripcion:	Se agrego el campo Mon_EqBaMa							****
****************************************************************************
** Modifico:	Ma de Lourdes Valdes Ramirez							****
** Fecha:		29/Agosot/02											****
** Descripcion:	Se quito el campo Mon_CodISO							****
****************************************************************************
** Modifico:	Roberto Gutierrez Sanchez								****
** Fecha:		21/Agosot/02											****
** Descripcion:	Se elimino el campo Mon_CtaDiv y se agregaron los		****
**				campos Mon_SpoCom, Mon_SpoVen.							****
****************************************************************************
** Modifico:	JLOZANO													****
** Fecha:		15/Marzo/02												****
** Descripcion:	Se agrego el campo Codigo ISO							****
****************************************************************************
** Modifico:	Laura V. Vazquez N.										****
** Fecha:		07/Febrero/2001											****
** Descripcion:	Incluir en la consulta las cuentas contables			****
**				para cobro inmediato y remesas. Estadarizar.			****
****************************************************************************
** Modifico:	Mayra Estrada											****
** Fecha:		21/Julio/1999											****
** Descripcion:	@Tip_Consul p/ Cons. Tipificadas de Visual.				****
****************************************************************************
*/

/* Declaracion de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Fec_48hAnt	smalldatetime,
		@Par_FecAct	smalldatetime,
		@Val_SpoDol	float,
		@Fac_EfeCom	money,
		@Fac_EfeVen	money,
		@Caj_Sucurs	char(3),
		@Status		int			/* Variable para estatus de ejecucion */

/* Declaracion de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Con_TipCon	char(1),
		@Con_LlaPri	char(1),
		@Con_LlaFor	char(1),
		@Con_Simbol	char(1),
		@Con_Cambio	char(1),
		@Con_PreSpo	char(1),
		@Con_FixVal char(1),
		@Con_Ventan	char(1),
		@Con_TodMon	char(1),
		@Con_PizDol	char(1),
		@Con_PreMet char(1),
		@Con_CajAut char(1),
		@Con_LimFac char(1),
		@Con_LisGen	char(1),
		@Con_LisCam	char(1),
		@Con_LisMet	char(1),
		@Con_LisCre	char(1),
		@Ope_MonCam	char(1),
		@Dlb_Cero	double precision,
		@Mon_Cero	money,
		@Mon_Pesos	char(2),
		@Mon_Dolar	char(2),
		@Tip_Metal	char(1),
		@Con_AutoRe	char(1),
		@Mon_Udis	char(2),
		@Con_ConFiV char(1),
		@Con_Deriva char(1),
		@Str_NumMXP char(2),
		@Str_DesMXP char(5),
		@Str_SimMXP char(3),
		@Con_CodISO	char(1),
		@Str_Porcen	char(1),
		@Mon_Euro	char(2),
		@Con_LisDiv	char(1),
		@Con_LiMoDe	char(1),
		@Con_LisCar	char(1),
		@Con_CarCre	char(1),
		@Ent_Cero	int,			/*	Constante de entero cero */
		@Ent_Uno	int,			/*	Constante entero uno	*/
		@Ent_Dos	int,			/*	Constante entero dos	*/
		@Ent_Tres	int,			/*	Constante entero tres	*/
		@Str_N		char(1),		/*	Cadena con valor N	*/
		@Con_LisTra	char(1),
		@Mon_NumMxn	char(2),
		@Tip_CamSuc   char(1)

/* Asignacion de valores a constantes */
select	@Str_Vacio	= '',				/* String Vacio */
		@Fec_Vacia	= '1900-01-01',		/* Fecha Vacia	*/
		@Con_TipCon	= 'C',				/* Tipo consulta (Visual Basic) */
		@Con_LlaPri	= '1',				/* Consulta por llave principal (Visual Basic) */
		@Con_LlaFor	= '2',				/* Consulta por llave foranea (Visual Basic) */
		@Con_Simbol	= '3',				/* Consulta de simbolos (Visual Basic) */
		@Con_Cambio	= '4',				/* Consulta de monedas de cambios (Visual Basic) */
		@Con_PreSpo	= '5',				/* Consulta de precios sopot para monedas de cambios (Visual Basic) */
		@Con_TodMon	= '6',				/* Consulta Todas Las Monedas Para Exportador De ArrendaRegio (FOX) */
		@Con_FixVal	= '7',				/* Consulta de Fix Valuacion */
		@Con_Ventan	= '8',				/* Consulta para Ventanilla */
		@Con_PizDol	= '9',				/* Consulta de cotizacion de Dolares para Pizarron Tesoreria */
		@Con_PreMet	= 'M',				/* Consulta de precios para metal */
		@Con_CajAut	= 'T',				/* Consulta para Cajeros Automaticos (Dispensar Dolares) */
		@Con_LimFac	= 'F',				/* Consulta de limites considerando el Factor TC */
		@Con_LisGen	= '1',				/* Consulta de lista general (Visual Basic) */
		@Con_LisCam	= '2',				/* Consulta de lista de monedas de cambios (Visual Basic) */
		@Con_LisMet	= '3',				/* Consulta de lista de monedas de metales */
		@Con_LisCre	= '4',
		@Ope_MonCam	= 'S',				/* La moneda opera en cambios */
		@Dlb_Cero	= 0.0000,			/* Entero Doble en Cero */
		@Mon_Cero	= $0.00,			/* Entero Corto en Cero */
		@Mon_Pesos	= '01',				/* Numero de la moneda: pesos */
		@Mon_Dolar	= '02',				/* Numero de la moneda: dolar */	
		@Tip_Metal	= 'O',				/* Tipo de moneda es metal */
		@Con_AutoRe	= 'A',				/* Consulta de Autoregio */
		@Mon_Udis	= '99',				/* Numero de la moneda: Udis */
		@Con_ConFiV	= 'B',				/* Consulta de FixVen  */
		@Con_Deriva	= 'D',				/* Consulta para Derivados  */
		@Str_NumMXP	= '01',				/* Numero Moneda Pesos */
		@Str_DesMXP	= 'PESOS',			/* Descripcion Moneda Pesos */
		@Str_SimMXP	= 'MXP',				/* Simbolo Moneda Pesos */
		@Con_CodISO	= 'I',				/* Consulta de AbrISO */
		@Str_Porcen	= '%',				/* String Porcentaje */
		@Mon_Euro	= '28',				/* Numero de la moneda: Euro */	
		@Con_LisDiv	= '5',				/* Consulta de lista de monedas Euro y Dolar */
		@Con_LiMoDe	= '7',				/* Consulta de lista de monedas para Derivados */
		@Con_LisCar	= '6',				/* Consulta de lista de monedas para Cartas de Credito */
		@Con_CarCre	= 'R',				/* Consulta para Cartas de Credito*/
		@Ent_Cero	= 0,
		@Ent_Uno	= 1,
		@Ent_Dos	= 2,
		@Ent_Tres	= 3,
		@Str_N		= 'N',
		@Con_LisTra	= '8',				/* Consulta de lista de monedas de cambio de tradair */
		@Mon_NumMxn	= '01',				/*	Numero de moneda para pesos */
		@Tip_CamSuc = '9'			/*Tipo de cambio para pantallas de sucursal. L9*/
		
/* Inicalizacion Variable*/
select  @NumTransac = isnull(@NumTransac,@Str_Vacio),
        @Transaccio = isnull(@Transaccio,@Str_Vacio),
        @Usuario    = isnull(@Usuario,@Str_Vacio),
        @FechaSis   = isnull(@FechaSis,@Str_Vacio),
        @SucOrigen     = isnull(@SucOrigen,@Str_Vacio),
        @SucDestino    = isnull(@SucDestino,@Str_Vacio),
        @Modulo     = isnull(@Modulo,@Str_Vacio)
		
select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

if isnull(@Mon_Fecha, @Fec_Vacia) = @Fec_Vacia
	select	@Mon_Fecha	= @Par_FecAct

select	@Fec_48hAnt	= @Mon_Fecha

exec @Status = SOANTFECHAB	
	@Fecha		= @Fec_48hAnt output,
	@NumDia		= @Ent_Dos,
	@FinSem 	= @Str_N,
	@Salida_Fox	= @Str_N
	
if @Status <> @Ent_Cero begin
	select	Err_Codigo	= '000001',
	Err_Mensaj	= 'Error durante el proceso de ejecucion'
			
	rollback
	return @Ent_Uno
end

if @Tip_Consul = @Str_Vacio begin	/* Cliente:  FoxPro */
	if (@Mon_Descri = @Str_Vacio) and (@Mon_Numero = @Str_Vacio)
		select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
				Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_FixCom,	Mon_FixVen,
				Mon_Abrevi,	Mon_DesCor,	Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	
				Mon_CtaRem,	Mon_CieCom,	Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	
				Mon_EqBaMa,	Mon_OpeCam,	Mon_CieDia,	Mon_FixVal,	Mon_DesLeg,
				Mon_Tipo,	Mon_ForMet
			from SOMONEDA noholdlock
			order by Mon_Numero
	else if (@Mon_Descri = @Str_Vacio)
		select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
				Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_FixCom,	Mon_FixVen,
				Mon_Abrevi,	Mon_DesCor,	Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	
				Mon_CtaRem,	Mon_CieCom,	Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	
				Mon_EqBaMa,	Mon_OpeCam, Mon_CieDia,	Mon_FixVal,	Mon_DesLeg,
				Mon_Tipo,	Mon_ForMet
			from SOMONEDA noholdlock
			where	Mon_Numero = @Mon_Numero
	else
		select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
				Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_FixCom,	Mon_FixVen,
				Mon_Abrevi,	Mon_DesCor,	Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	
				Mon_CtaRem,	Mon_CieCom,	Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	
				Mon_EqBaMa,	Mon_OpeCam,	Mon_CieDia,	Mon_FixVal,	Mon_DesLeg
			from SOMONEDA noholdlock
			where	Mon_Descri like @Mon_Descri + @Str_Porcen
			order by Mon_Numero
end else begin			/* Cliente:  Visual Basic */
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = @Con_TipCon begin					/* 'C':  Consulta */
		if @Tip_ConCon = @Con_LlaPri begin				/* Consulta de Llave Principal */
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
					Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_Abrevi,	Mon_DesCor,	
					Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	Mon_CtaRem,	Mon_CieCom,	
					Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	Mon_EqBaMa,	Mon_OpeCam, 
					Mon_CieDia,	Mon_FixVal, Mon_DesLeg,	Mon_Tipo,	Mon_ForMet,
					Mon_AbrISO,
					Mon_FixCom	= @Dlb_Cero,
					Mon_FixVen 	= @Dlb_Cero,
					Mon_RevBal	= @Dlb_Cero
				into #Moneda
				from SOMONEDA noholdlock
				where	Mon_Numero 	= @Mon_Numero
				
			if @Mon_Fecha <> @Par_FecAct
				update #Moneda set
					Mon_Fecha	= Him_Fecha,
					Mon_EfeCom	= Him_EfeCom,
					Mon_EfeVen	= Him_EfeVen,
					Mon_DocCom	= Him_DocCom,
					Mon_DocVen	= Him_DocVen,
					Mon_CieCom	= Him_CieCom,
					Mon_CieVen	= Him_CieVen,
					Mon_SpoCom	= Him_SpoCom,
					Mon_SpoVen	= Him_SpoVen,
					Mon_CieDia	= Him_CieDia,
					Mon_FixVal	= Him_FixVal
					from SOHISMON noholdlock
					where	Mon_Numero	= Him_Moneda
					  and	Him_Fecha	= @Mon_Fecha
					  
			update #Moneda set
				Mon_FixCom	= Him_FixVal,
				Mon_FixVen 	= Him_FixVal
				from SOHISMON noholdlock
				where 	Mon_Numero 	= Him_Moneda
				  and	Him_Fecha	= @Fec_48hAnt
				  
			update #Moneda set
				Mon_RevBal 	= isnull(Him_RevBal, @Dlb_Cero)
				from SOHISMON noholdlock
				where 	Mon_Numero 	= Him_Moneda
				  and	Him_Fecha	= @Mon_Fecha
			
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
					Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_Abrevi,	Mon_DesCor,	
					Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	Mon_CtaRem,	Mon_CieCom,	
					Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	Mon_EqBaMa,	Mon_OpeCam, 
					Mon_CieDia,	Mon_FixVal,	Mon_FixCom,	Mon_FixVen,	Mon_DesLeg,
					Mon_Tipo,	Mon_ForMet,	Mon_RevBal,	Mon_AbrISO
				from #Moneda
				
			drop table #Moneda
		end else if @Tip_ConCon = @Con_LlaFor begin		/* Consulta de Llave Foranea */
			select	Mon_Numero,	Mon_Descri, Mon_Abrevi, Mon_DesLeg
				from SOMONEDA noholdlock
				where 	Mon_Numero	= @Mon_Numero
		end else if @Tip_ConCon = @Con_Simbol begin		/* Consulta de Simbolos */
			select	Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Abrevi
				from SOMONEDA noholdlock
				where 	Mon_Numero	= @Mon_Numero
		end else if @Tip_ConCon	= @Con_Cambio begin		/* Consulta de Moneda de Cambios */
			select	Mon_Numero,	Mon_Descri,	Mon_Simbol
				from SOMONEDA noholdlock
				where 	Mon_Numero 	= @Mon_Numero
				  and	Mon_OpeCam	= @Ope_MonCam
		end else if @Tip_ConCon	= @Con_PreSpo begin		/* Consulta de Precios Spot para Moneda de Cambios */
			select	Mon_Numero,	Mon_Descri,	Mon_Simbol, Mon_SpoCom, Mon_SpoVen
				from SOMONEDA noholdlock
				where 	Mon_Numero 	= @Mon_Numero				
				  and	Mon_OpeCam	= @Ope_MonCam	
		end else if @Tip_ConCon	= @Con_TodMon begin		/* Consulta De Todas Las Monedas Para Arrendadora FOX */
			select	Mon_Numero,	Mon_Descri,	Mon_Simbol, Mon_EfeCom, Mon_EfeVen
				from SOMONEDA noholdlock
		end else if @Tip_ConCon	= @Con_FixVal begin		/* Consulta de Fix Val */
			select	Mon_Numero,	Mon_Descri,	Mon_Simbol,
					Mon_FixVal = Him_FixVal
				from SOHISMON noholdlock,
					 SOMONEDA noholdlock
				where 	Him_Moneda 	= @Mon_Numero
				  and	Him_Fecha	= @Mon_Fecha
				  and	Mon_Numero	= Him_Moneda
		end else if @Tip_ConCon	= @Con_Ventan begin		/* Consulta para Ventanilla */
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Abrevi,	Mon_OpeCam, 
					Mon_Tipo
				from SOMONEDA noholdlock
				where	Mon_Numero 	= @Mon_Numero
		end else if @Tip_ConCon	= @Con_AutoRe begin		/* Consulta para Autoregio */

		select  Mon_EfeCom,	Mon_EfeVen,	Mon_Numero
			from SOMONEDA noholdlock
			where 	Mon_Numero 	= @Mon_Dolar			/*  Dolares*/
		union all
			select  Mon_EfeCom,	Mon_EfeVen,	Mon_Numero		/*  Udis */
				from SOMONEDA noholdlock
				where	Mon_Numero 	= @Mon_Udis				
		
		end else if @Tip_ConCon	= @Con_PizDol begin		/* Consulta de Moneda para Pizarron Tesoreria */
			select   Mon_FixCom, Mon_FixVen 
				from SOMONEDA noholdlock
				where 	Mon_Numero 	= @Mon_Dolar			/*  Dolares*/
	
		end else if @Tip_ConCon = @Con_CajAut begin		/* Consulta para Cajeros Automaticos (Dispensar Dolares) */

			select	@Caj_Sucurs	= Caj_Sucurs
				from CTCAJERO noholdlock
				where	Caj_Numero	= right(@Usuario, @Ent_Tres)

			select 	@Fac_EfeCom	= Dtc_Compra,
					@Fac_EfeVen	= Dtc_Venta
				from SOPARAMS	noholdlock,
					 ITDETICA	noholdlock
				where	Par_Sucurs	= @Caj_Sucurs
				  and	Par_TiCaDi	= Dtc_Numero
				  and	Dtc_Moneda	= @Mon_Dolar

			select 	@Fac_EfeCom	= isnull(@Fac_EfeCom, @Mon_Cero),
					@Fac_EfeVen	= isnull(@Fac_EfeVen, @Mon_Cero)

			select  Err_Codigo	= '000000',
					Err_Mensaj	= 'Consulta Correcta',
					Mon_Numero,
					Mon_EfeCom	= round(convert(decimal(7, 2), Mon_EfeCom) + convert(decimal(7, 2), @Fac_EfeCom), @Ent_Dos),
					Mon_EfeVen	= round(convert(decimal(7, 2), Mon_EfeVen) + convert(decimal(7, 2), @Fac_EfeVen), @Ent_Dos)
				from SOMONEDA noholdlock
				where 	Mon_Numero 	= @Mon_Dolar			/*  Dolares */

		end  else if @Tip_ConCon = @Con_LimFac begin		/* Consulta de limites considerando el Factor TC */
		
			select 	@Fac_EfeCom	= Dtc_Compra,
					@Fac_EfeVen	= Dtc_Venta
				from SOPARAMS noholdlock,
					 ITDETICA noholdlock
				where Par_Sucurs	= @SucOrigen
				  and	Par_TiCaDi	= Dtc_Numero
				  and	Dtc_Moneda	= @Mon_Numero

			select 	@Fac_EfeCom	= isnull(@Fac_EfeCom, @Mon_Cero),
					@Fac_EfeVen	= isnull(@Fac_EfeVen, @Mon_Cero)

			select 	Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Abrevi,	Mon_OpeCam,
					Mon_EfeCom	= round(convert(decimal(7, 2), Mon_EfeCom) + convert(decimal(7, 2), @Fac_EfeCom), @Ent_Dos),
					Mon_EfeVen	= round(convert(decimal(7, 2), Mon_EfeVen) + convert(decimal(7, 2), @Fac_EfeVen), @Ent_Dos),
					Mon_DocCom,	Mon_DocVen,	Mon_Tipo
				from SOMONEDA	noholdlock
				where	Mon_Numero	= @Mon_Numero
				
		end else if @Tip_ConCon = @Con_ConFiV begin		/* Consulta de Moneda Mon_FixVen actual*/
			select  Mon_Numero,	Mon_Descri,	Mon_Abrevi, Mon_FixVen, Mon_Simbol
				from SOMONEDA noholdlock
				where	Mon_Numero 	= @Mon_Numero
				
		end else if @Tip_ConCon = @Con_Deriva begin		/* Consulta Derivados */
			select	Mon_Numero	= @Str_NumMXP, 
					Mon_Descri	= @Str_DesMXP, 
					Mon_Simbol	= @Str_SimMXP
			union all
				select	Mon_Numero,	Mon_Descri,	Mon_Simbol
					from SOMONEDA noholdlock
					where 	Mon_OpeCam	= @Ope_MonCam
	
		/* - Cambio para Multimoneda -*/ 
		end else if @Tip_ConCon = @Con_CodISO begin		/* Consulta de Codigo ISO */
			select	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Numero 	= @Mon_Numero

		/* - Monedas de Cartas de Credito-*/ 
		end else if @Tip_ConCon = @Con_CarCre begin		/* Consulta de Codigo ISO */
			create table #Monedas (
				Mon_Numero   char(2) default '',
				Mon_Descri   varchar(30)  default '',
				Mon_Simbol   varchar(10) default '',
				Mon_AbrISO   varchar(3) default '',
			)
			
			insert into #Monedas (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_OpeCam	= @Ope_MonCam
				   
			insert into #Monedas (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Pesos
				
			select Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO 
				from #Monedas
				where Mon_Numero = @Mon_Numero
				
			drop table #Monedas
		end else if @Tip_ConCon = @Con_PreMet begin		/* Consulta de Metales */
			select	@Val_SpoDol	= Mon_SpoVen
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Dolar
				
			select  Mon_Numero,	Mon_Descri,
					Mon_ValMet	= Mon_EfeCom,
					Val_SpoDol	= @Val_SpoDol
				from SOMONEDA noholdlock
				where	Mon_Tipo	= @Tip_Metal
				  and   Mon_Numero	= @Mon_Numero
				order by Mon_Numero
		end
		

	end else begin					/* 'L':  Lista */
		select	@Mon_Descri	= ltrim(rtrim(@Mon_Descri)) + @Str_Porcen
		
		if @Tip_ConCon = @Con_LisGen begin				/* Lista General */
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,  Mon_FixVen, Mon_Abrevi
				from SOMONEDA noholdlock
				where	Mon_Descri like @Mon_Descri
				order by Mon_Numero
		end else if @Tip_ConCon = @Con_LisCam begin		/* Lista de Moneda de Cambios */
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol
				from SOMONEDA noholdlock
				where	Mon_Descri like @Mon_Descri
				  and	Mon_OpeCam	= @Ope_MonCam
				order by Mon_Numero
		end else if @Tip_ConCon = @Con_LisMet begin		/* Lista de Metales */
			select	@Val_SpoDol	= Mon_SpoVen
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Dolar
				
			select  Mon_Numero,	Mon_Descri,
					Mon_ValMet	= Mon_EfeCom,
					Val_SpoDol	= @Val_SpoDol
				from SOMONEDA noholdlock
				where	Mon_Tipo	= @Tip_Metal
				order by Mon_Numero
		end	else if @Tip_ConCon = @Con_LisCre begin		/* Lista de Moneda de Creditos disponibles*/
			select  Mon_Numero,	Mon_Descri,	Mon_Abrevi, Mon_FixVen, Mon_Simbol
				from SOMONEDA noholdlock
				where	Mon_Numero 	in (@Mon_Pesos, @Mon_Dolar, @Mon_Udis)
				order by Mon_Numero
		end else if @Tip_ConCon = @Con_LisDiv begin		/* Lista de Moneda de Cambios */
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol
				from SOMONEDA noholdlock
				where	Mon_Descri like @Mon_Descri
				  and	Mon_OpeCam	= @Ope_MonCam
				  and	Mon_Numero	in (@Mon_Dolar, @Mon_Euro)
				order by Mon_Numero

		end else if @Tip_ConCon = @Con_LiMoDe begin		/* Lista de Moneda de Derivados */
				
			select	Mon_Numero	= @Str_NumMXP, 
					Mon_Descri	= @Str_DesMXP, 
					Mon_Simbol	= @Str_SimMXP
			union all
				select	Mon_Numero,	Mon_Descri,	Mon_Simbol
					from SOMONEDA noholdlock
					where 	Mon_OpeCam	= @Ope_MonCam
					  and	Mon_Descri like @Mon_Descri
					  
		end else if @Tip_ConCon = @Con_LisCar begin		/* Lista de Moneda de Cartas de Credito */
			create table #MonedasL (
				Mon_Numero   char(2) default '',
				Mon_Descri   varchar(30)  default '',
				Mon_Simbol   varchar(10) default '',
				Mon_AbrISO   varchar(3) default '',
			)
			
			insert into #MonedasL (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Descri like @Mon_Descri
				and 	Mon_OpeCam	= @Ope_MonCam
				   
			insert into #MonedasL (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Pesos
		
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from #MonedasL 
				order by Mon_Numero
				
			drop table #MonedasL
		end else if @Tip_ConCon = @Con_LisTra begin		/* Lista de monedas de cambio de tradair */
			create table #MonedasT (
				Mon_Numero   char(2) default '',
				Mon_Descri   varchar(30)  default '',
				Mon_Simbol   varchar(10) default '',
				Mon_AbrISO   varchar(3) default '',
			)
			
			insert into #MonedasT (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Descri like @Mon_Descri
				and 	Mon_OpeCam	= @Ope_MonCam
				   
			insert into #MonedasT (Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO)
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_NumMxn
		
			select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_AbrISO
				from #MonedasT 
				order by Mon_Numero
				
			drop table #MonedasT
		end else if @Tip_ConCon = @Tip_CamSuc begin
			select Mon_Numero, Mon_Descri,	Mon_EfeCom,	Mon_EfeVen, Mon_Simbol
			from SOMONEDA noholdlock
			where  Mon_OpeCam = @Ope_MonCam
			and Mon_Numero in (@Mon_Dolar,@Mon_Euro)
		end
	end
end