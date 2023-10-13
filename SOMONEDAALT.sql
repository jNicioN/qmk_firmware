create procedure SOMONEDAALT(
	@Mon_Numero char(2),
	@Mon_Descri varchar(30), 
	@Mon_Simbol varchar(10),
	@Mon_Tipo	char(1),
	@Mon_EqBaMa	varchar(35),
	@Mon_Fecha  smalldatetime, 
	@Mon_EfeCom double precision,
	@Mon_EfeVen	float,
	@Mon_DocCom	float,
	@Mon_DocVen	float,
	@Mon_FixCom	float,
	@Mon_FixVen	float,
	@Mon_Abrevi varchar(10),
	@Mon_DesCor varchar(6),
	@Mon_DesLeg	varchar(60),
	@Mon_CtaEfe char(12),
	@Mon_CtaBM	char(12),
	@Mon_CtaSBC	char(12),
	@Mon_CtaRem char(12),
	@Mon_CieCom double precision,
	@Mon_CieVen double precision,
	@Mon_SpoCom double precision,
	@Mon_SpoVen double precision,
	@Mon_CieDia double precision,
	@Mon_FixVal double precision,	
	@Mon_ForMet	char(2),
	
	@NumTransac char(10),
	@Transaccio char(3), 
	@Usuario	char(6),
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3), 
	@Modulo		char(2))

as
/*****************************************************************************/
/* DESCRIPCION: Alta de Moneda */
/***************************************************************************/
/** REFERENCIAS:													   	 */	
/***************************************************************************
** Modifico:	Luis Enrique Ramirez Ortiz								****
** Fecha:		30/05/2023												****
** Help:	   	TCELTO-4797												****
** Descripcion:	Se habilita la capacidad de dar de alta una moneda con  ****
** 				tipo de cambio 0.00										****
****************************************************************************
** Modifico:	Stephanie Zatarain Lizarraga							****
** Fecha:		26/Octubre/2018											****
** Help:	   	1142503  												****
** Descripcion:	Se agrega constante @Ent_Uno correspondiente al nivel   ****
**              de riesgo en insert                                     ****          			  
****************************************************************************
** Modificó:		Manuel Martínez Muñoz						****
** Fecha:		13/Diciembre/2011							****
** HelpDesk:	426972										****
** Descripción:	Agregar Mensajes de Error en Validaciones 	****
****************************************************************************
** Modificó:		Marco A. Morales V.							****
** Fecha:		03/Junio/2011								****
** HelpDesk:	00195888									****
** Descripción:	Se Agrega el campo Mon_RevBal	 en cero 	****
**				en el insert del SOMONEDA y al llamar el		****
**				SOHISMONALT.								****
****************************************************************************
** Modificó:		Genoveva Torres							****
** Fecha:		07/AGO/2010								****
** Help:			00258191									****
** Descripción:	Se Agrega campo Mon_AbrISO, Mon_CodISO	****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		14/Octubre/2004							****
** Descripción:	Agregar el campo Mon_ForMet				****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		09/Julio/2004								****
** Descripción:	Agregar el campo Mon_Tipo					****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		13/Abril/2004								****
** Descripción:	Agregar el campo Mon_DesLeg				****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo						****
** Fecha:		11/Noviembre/2003							****
** Descripción:	Cambiar el tipo de dato a  Mon_DesCor		****
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchesz.					****
** Fecha:		22/Julio/03									****
** Descripción:	Se agregó el campo Mon_FixVal.				****
****************************************************************************
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo						****
** Fecha:		16/Julio/2003								****
** Descripción:	Agregar el campo Mon_DesCor				****
****************************************************************************
** Modificó:		Eduardo Salazar Gtz.						****
** Fecha:		17/Ene/03									****
** Descripción:	Se elimino el campo Mon_TasCam y se agrego	****   				**				el campo Mon_CieDia						****
****************************************************************************
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchez					****
** Fecha:		19/Dic/02									****
** Descripción:	Se agregaron el campo Mon_OpeCam con		****   				**				valor N y el campo Mon_TasCam con valor	****
**				0 en el insert de la Tabla SOMONEDA.		****
****************************************************************************
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		27/Noviembre/02							****
** Descripción:	Se agrego el campo Mon_EqBaMa  			****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		29/Agosot/02								****
** Descripción:	Se quito el campo Mon_CodISO	  			****
****************************************************************************
** Modificó:		Roberto Gutièrrez Sànchez					****
** Fecha:		21/Agosot/02								****
** Descripción:	Agregué los campoa Mon_SpoCom y  			****
**				Mon_SpoVen y se eliminò el campo 			****
**				Mon_CtaDiv.								****		****************************************************************************
****************************************************************************
** Modificó:		Sandra Almaguer							****
** Fecha:		21/Mayo/02									****
** Descripción:	Agregué el campo SoMonedaID                     ****
****************************************************************************
** Modificó:		JLOZANO         								****
** Fecha:		15/Marzo/02								****
** Descripción:	Se agrego el campo Codigo ISO                     ****
****************************************************************************
** Modificó:		FCHIA          								****
** Fecha:		27/Abr/01									****
** Descripción:	Solo se guarda un registro por dia en 			****
**				el Historico									****
****************************************************************************
** Modificó:		Laura V. Vázquez   							****
** Fecha:		07/Feb/01									****
** Descripción:	Agregue Mon_CueSBC y Mon_CueRem para la****
				cuenta 	contable para el cobro inmediato	y 	****
				para remesas respectivamente				****
****************************************************************************
** Modificó:		Sandra Almaguer   							****
** Fecha:		26/Sep/00									****
** Descripción:	Agregue Cue_Compan cuando se selecciona	****
**				info de COCUENTA							****
****************************************************************************/

declare	@SoMonedaID	int,				/* Declaración de Variables */
		@Status		int,	
		@Num_EspBla int,
		@Num_Punto	int
		

declare	@Cue_Compan	char(3),			/* Declaración de Constantes */
		@Str_Vacio	char(1),
		@Str_Punto  char(1),
		@Flo_Cero	float,
		@Ent_CorCer	smallint,
		@DPr_Cero	double precision,
		@No_OpeCam	char(1),
		@Cha_Porcen	char(1),
		@Ent_Uno    int

/* Asignación de Constantes */
select	@Cue_Compan	= '001',			/* Compañía contable BANREGIO */
		@Str_Vacio	= '',				/* String Vacío	*/	
		@Str_Punto  = '.',				/* String punto	*/	
		@Flo_Cero	= 0,				/* Float en ceros */
		@Ent_CorCer	= 0,				/* Entero corto en ceros */
		@DPr_Cero	= 0,				/* Double precision en ceros */
		@No_OpeCam	= 'N',				/* No Opera en Cambios */
		@Cha_Porcen	= '%',
		@Ent_Uno    = 1
				
select @FechaSis = getdate()

select	@Mon_DesCor	= isnull(@Mon_DesCor, @Str_Vacio)	

if @Mon_DesCor = @Str_Vacio begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Descripción corta no valida',
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end

select	@Mon_DesCor	= ltrim(@Mon_DesCor)	

select @Num_EspBla	= patindex(@Cha_Porcen + @Str_Vacio + @Cha_Porcen, @Mon_DesCor)

if @Num_EspBla > @Ent_CorCer begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Descripción corta no valida, no debe contener espacios en blanco o algún otro caracter especial',
			Err_Variab	= 'Mon_DesCor'
	rollback
	return 1
end

select @Num_Punto	= patindex(@Cha_Porcen + @Str_Punto + @Cha_Porcen, @Mon_DesCor)

if @Num_Punto > @Ent_CorCer begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'Descripción corta no valida, no debe contener puntos o algún otro caracter especial',
			Err_Variab	= 'Mon_DesCor'
	rollback
	return 1
end
 
if convert(int, @Mon_Numero) = @Ent_CorCer begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'Numero incorrecto', 
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end
if exists (select	Mon_Numero
						from SOMONEDA noholdlock
						where	Mon_Numero	= @Mon_Numero) begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'La moneda ya existe', 
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end
if (@Mon_Descri = @Str_Vacio) begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'Descripción incorrecta', 
			Err_Variab	= 'Mon_Descri'
	rollback
	return 1
end
if (@Mon_EfeCom < @Flo_Cero) begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'Efectivo Compra incorrecto', 
			Err_Variab	= 'Mon_EfeCom'
	rollback
	return 1
end
if (@Mon_EfeVen < @Flo_Cero) begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Efectivo Venta incorrecto', 
			Err_Variab	= 'Mon_EfeVen'
	rollback
	return 1
end
if (@Mon_DocCom < @Flo_Cero) begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Documento Compra incorrecto', 
			Err_Variab	= 'Mon_DocCom'
	rollback
	return 1
end
if (@Mon_DocVen < @Flo_Cero) begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'Documento Venta incorrecto', 
			Err_Variab	= 'Mon_DocVen'
	rollback
	return 1
end
if (@Mon_CieCom < @DPr_Cero) begin
	select	Err_Codigo	= '000013',	
			Err_Mensaj	= 'Cierre Compra incorrecto', 
			Err_Variab	= 'Mon_CieCom'
	rollback
	return 1	
end
if (@Mon_CieVen < @DPr_Cero) begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'Cierre Venta incorrecto', 
			Err_Variab	= 'Mon_CieVen'
	rollback
	return 1	
end
if (@Mon_SpoCom < @DPr_Cero) begin
	select	Err_Codigo	= '000015',	
			Err_Mensaj	= 'Spot Compra incorrecto', 
			Err_Variab	= 'Mon_CieCom'
	rollback
	return 1	
end
if (@Mon_SpoVen < @DPr_Cero) begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Spot Venta incorrecto', 
			Err_Variab	= 'Mon_CieVen'
	rollback
	return 1	
end
if (@Mon_CieDia < @DPr_Cero) begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'Tipo de Cambio al Cierre del dia a Dolares incorrecto', 
			Err_Variab	= 'Mon_CieDia'
	rollback
	return 1	
end
if not exists (select	Cue_Cuenta
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Mon_CtaEfe
							  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaEfe <> @Str_Vacio begin
	select	Err_Codigo	= '000018', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaEfe'
	rollback
	return 1
end
if not exists (select	Cue_Cuenta
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Mon_CtaBM
							  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaBM <> @Str_Vacio begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaBM'
	rollback
	return 1
end
if not exists (select	Cue_Cuenta
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Mon_CtaSBC
							  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaSBC <> @Str_Vacio begin
	select	Err_Codigo	= '000020', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaSBC'
	rollback
	return 1
end
if not exists (select	Cue_Cuenta
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Mon_CtaRem
							  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaRem <> @Str_Vacio begin
	select	Err_Codigo	= '000021', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaRem'
	rollback
	return 1
end
if @Mon_Fecha = convert(smalldatetime, '01/01/1990') begin
	select	Err_Codigo	= '000022', 
			Err_Mensaj	= 'Fecha incorrecta', 
			Err_Variab	= 'Mon_Fecha'
	rollback
	return 1
end
if exists (select	Mon_DesCor
						from SOMONEDA noholdlock
						where	Mon_DesCor	= @Mon_DesCor) begin
	select	Err_Codigo	= '000023', 
			Err_Mensaj	= 'La descripción corta ya existe', 
			Err_Variab	= 'Mon_DesCor'
	rollback
	return 1
end
if (@Mon_FixVal < @DPr_Cero) begin
	select	Err_Codigo	= '000024', 
			Err_Mensaj	= 'Tipo de Cambio FIX utilizado en la Valuación incorrecto', 
			Err_Variab	= 'Mon_FixVal'
	rollback
	return 1	
end
	
if @Mon_DesLeg = @Str_Vacio
	select @Mon_DesLeg	= @Mon_Abrevi
	
select	@SoMonedaID	= convert(int, @Mon_Numero) 
	
insert into SOMONEDA (
	SoMonedaID,	 	Mon_Numero,		Mon_Descri,		Mon_Simbol,		Mon_Tipo,
	Mon_EqBaMa,	 	Mon_Fecha,		Mon_EfeCom,		Mon_EfeVen,		Mon_DocCom,
	Mon_DocVen,	 	Mon_FixCom,		Mon_FixVen,		Mon_Abrevi,		Mon_AbrISO,
	Mon_CodISO ,	Mon_DesCor,		Mon_DesLeg,		Mon_CtaEfe, 	Mon_CtaBM,		
	Mon_CtaSBC,	 	Mon_CtaRem,		Mon_CieCom,		Mon_CieVen,		Mon_SpoCom,	
	Mon_SpoVen,	 	Mon_CieDia,		Mon_OpeCam ,	Mon_FixVal,		Mon_ForMet,	
    Mon_RevBal ,	Mon_NivRie ,    NumTransac,		Transaccio,		Usuario,			
	FechaSis,	    SucOrigen,		SucDestino) 
	values (
		@SoMonedaID,	@Mon_Numero,	@Mon_Descri,	@Mon_Simbol,	@Mon_Tipo,
		@Mon_EqBaMa,	@Mon_Fecha,		@Mon_EfeCom,	@Mon_EfeVen,	@Mon_DocCom,
		@Mon_DocVen,	@Mon_FixCom,	@Mon_FixVen,	@Mon_Abrevi,	@Str_Vacio,
		@Str_Vacio,		@Mon_DesCor,	@Mon_DesLeg,	@Mon_CtaEfe, 	@Mon_CtaBM,		
		@Mon_CtaSBC,	@Mon_CtaRem,	@Mon_CieCom,	@Mon_CieVen,	@Mon_SpoCom,	
		@Mon_SpoVen,	@Mon_CieDia,	@No_OpeCam,		@Mon_FixVal,	@Mon_ForMet,	
    	@DPr_Cero,		@Ent_Uno,       @NumTransac,	@Transaccio,	@Usuario,			
		@FechaSis,	    @SucOrigen,		@SucDestino) 	

/* Alta en el Historico */ 
exec @Status = SOHISMONALT
	@Mon_Numero,	@Mon_Fecha,		@Mon_EfeCom,	@Mon_EfeVen, 	@Mon_DocCom,
	@Mon_DocVen,	@Mon_FixCom,	@Mon_FixVen,	@Mon_CieCom,	@Mon_CieVen,
	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_CieDia,	@Mon_FixVal,	@NumTransac,	
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	
	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end

/* Alta en la Bitacora */
exec @Status = SOBITMONALT
	@Mon_Numero,	@Mon_Fecha,		@Mon_EfeCom,	@Mon_EfeVen, 	@Mon_DocCom,	
	@Mon_DocVen,	@Mon_FixCom,	@Mon_FixVen,	@Mon_CieCom,	@Mon_CieVen,	
	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_CieDia,	@Mon_FixVal,	@NumTransac,	
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	
	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'