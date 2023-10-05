create procedure SOMONEDAMOD(
	@Mon_Numero char(2),
	@Mon_Descri varchar(30), 
	@Mon_Simbol varchar(10),
	@Mon_Tipo	char(1),
	@Mon_EqBaMa	varchar(35),
	@Mon_Fecha  smalldatetime, 
	@Mon_EfeCom float,
	@Mon_EfeVen float,
	@Mon_DocCom float,
	@Mon_DocVen float, 
	@Mon_FixCom float,
	@Mon_FixVen float, 
	@Mon_Abrevi varchar(10),
	@Mon_DesCor varchar(6),
	@Mon_DesLeg	varchar(60),
	@Mon_CtaEfe char(12),
	@Mon_CtaBM	char(12),
	@Mon_CtaSBC	char(12),
	@Mon_CtaRem char(12),
	@Mon_CieCom float,
	@Mon_CieVen float, 
	@Mon_SpoCom float,
	@Mon_SpoVen float, 	
	@Mon_CieDia	float,
	@Mon_FixVal	float,
	@Mon_ForMet char(2),
	
	@NumTransac char(10),
	@Transaccio char(3), 
	@Usuario	char(6),
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3), 
	@Modulo		char(2))

as

/* NOTA: Las TABLAS AFECTADAS deben ejecutarse antes compilar el stored procedure*/
/* TABLAS AFECTADAS: */
/*Modifica la moneda MON_NUMERO = @MON_NUMERO
Actualiza SOHISMON si @MON_VALOR o @MON_FECHA son diferentes a MON_VALOR o MON_FECHA, con @MON_NUMERO, @MON_VALOR y @MON_FECHA*/
/* NOTA: Las SALIDAS deben ejecutarse despues de compilar el stored procedure*/

/* SALIDAS: */
/*Ninguna*/ 
/*****************************************************************************/
/* DESCRIPCION: ***Modificacion de una moneda*** */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modifico:	Luis Enrique Ramirez Ortiz								****
** Fecha:		30/05/2023												****
** Help:	   	TCELTO-4797												****
** Descripcion:	Se habilita la capacidad de modificar una moneda con  	****
** 				tipo de cambio 0.00										****
****************************************************************************
** Modificó:		Gustavo Cruz					****
** Fecha:		09/Abril/2013								****
** Help:			538421									****
** Descripción:	Se agrego Mon_Formet			****
****************************************************************************
** Modificó:		Marco A. Morales Ventura					****
** Fecha:		09/Mayo/2012								****
** Help:			00462740									****
** Descripción:	Eliminar el exec a SOULHESPACT 			****
****************************************************************************
** Modificó:		Roberto Pascuale Morales Chavez			****
** Fecha:		12/Mar/12									****
** Help:			424818										****
** Descripción:	Agregar en el exec a SOULHESPACT los 7	****
**				parámetros generales						****
****************************************************************************
** Modificó:		Eugenio Salazar Orta						****
** Fecha:		24/Febrero/2011							****
** Descripción:	Estandarizar Mensajes de Error				****
** Help:	   	    	00340159									****
****************************************************************************
** Modificó:		Sandra Almaguer  							****
** Fecha:		20/Diciembre/2005							****
** Help:	   	    	Corrección									****
** Descripción:	Cuando se actualic el Fix de Valuación, modi-	****
**				ficar el ultimo hecho spot para Cambios		****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		23/Noviembre/2004							****
** Descripción:	Pasar el valor de spot venta del dolar a la sp. ****
**				para actualizar valores de metales y agregar	****
**				parámetros para el ESDENMETACT.			****
** Help No.:		70434										****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		10/Noviembre/2004							****
** Descripción:	Bloquear la actualización de los valores de 	****
**				metales cuando se actualiza el valor del dolar.****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		30/Agosto/2004								****
** Descripción:	Ejecutar store para actualizar precio de metales**
**				cuando haya una modificación al tipo de cambio**
**				del dólar en ventanilla.						****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		20/Julio/2004								****
** Descripción:	Agregar el campo Mon_Tipo					****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		13/Abril/2004								****
** Descripción:	Se agrego el campo Mon_DesLeg		 		****
****************************************************************************
** Modificó:		Eduardo Salazar Gutiérrez					****
** Fecha:		29/Enero/2004								****
** Descripción:	Se toma Par_FecAct de ITPARAMS	 		****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo						****
** Fecha:		11/Noviembre/2003							****
** Descripción:	Cambiar el tipo de dato a  Mon_DesCor		****
****************************************************************************
** Modificó:		Laura Elena Cervantes D.					****
** Fecha:		08/JOct/03									****
** Descripción:	Permitir registra tipo Fix y Cierre Dia en cero   ****
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
** Fecha:		17/Enero/03								****
** Descripción:	Se elimino el parámetro Mon_TasCam  		****
**				y se agrego el parámetro Mon_CieDia			****
****************************************************************************
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchez					****
** Fecha:		26/Diciembre/02							****
** Descripción:	Se agrego el parámetro Mon_TasCam  		****
****************************************************************************
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		27/Noviembre/02							****
** Descripción:	Se agrego el campo Mon_EqBaMa  			****
****************************************************************************
** Modificó:		Laura Elena Cervantes D.					****
** Fecha:		12/Sep/2002								****
** Descripción:	Que no actualize Bitacora para T.C Sport		****
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		29/Agosot/02								****
** Descripción:	Se quito el campo Mon_CodISO	  			****
****************************************************************************
** Modificó:		Roberto Gutièrrez Sànchez					****
** Fecha:		21/Agosot/02								****
** Descripción:	Agregué los campoa Mon_SpoCom y  			****
**				Mon_SpoVen y se eliminò el campo 			****
**				Mon_CtaDiv.								****		
****************************************************************************
** Modificó:		JLOZANO         								****
** Fecha:		15/Marzo/02								****
** Descripción:	Se agrego el campo Codigo ISO                     ****
****************************************************************************
** Modificó:		FCHIA          								****
** Fecha:		27/Abr/01									****
** Descripción:	Solo se guarda un registro por dia en 			****
**				el Historico									****
***************************************************************************
** Modificó:		Laura V. Vázquez   							****
** Fecha:		07/Feb/01									****
** Descripción:	Agregue Mon_CueSBC y Mon_CueRem para la****
				cuenta 	contable para el cobro inmediato	y 	
********************************************************************************
** Modificó:		Sandra Almaguer   							****
** Fecha:		26/Sep/00									****
** Descripción:	Agregue Cue_Compan cuando se selecciona	****
**				info de COCUENTA							****
******************************************************************************/

declare	@Status		int,				/* Declaración de Variables */
		@Par_FecAct	smalldatetime,
		@Num_EspBla int,
		@Num_Punto  int,
		@Ant_EfeCom float,
		@Ant_EfeVen float,
		@Ant_SpoVen float

declare	@Cue_Compan	char(3),			/* Declaración de Constantes */
		@Str_Vacio	char(1),
		@Str_Punto	char(1),
		@Ent_CorCer	smallint,
		@Flo_Cero	float,
		@Fec_Vacia	smalldatetime,
		@Tra_ActSpo char(3),
		@Mon_Dolar	char(2),
		@Tip_Metal	char(1),
		@Tip_ActCam	char(1),
		@Tip_ActMet	char(1),
		@Mon_Cero	money,
		@Mon_CorCer	smallmoney

/* Asignación de Constantes */
select	@Cue_Compan	= '001',			/* Compañía contable BANREGIO */
		@Str_Vacio	= '',				/* String Vacío		*/	
		@Str_Punto	= '.',				/* String Punto		*/	
		@Ent_CorCer	= 0,				/* Entero corto en cero */	
		@Flo_Cero	= 0,				/* Float en ceros	*/
		@Fec_Vacia	= '1900-01-01',		/* Fecha Vacía */
		@Tra_ActSpo = 'TMO',			/* Transaccion de Actualizacion de Sport */
		@Mon_Dolar	= '02',				/* Número de moneda del dólar */
		@Tip_Metal	= 'O',				/* Tipo de moneda: metal */
		@Tip_ActCam	= 'C',				/* Tipo de actualización de cambios */
		@Tip_ActMet	= 'M',				/* Tipo de actualización por cambio de valor de metal */
		@Mon_Cero	= $0.00,			/* Campo money en ceros */
		@Mon_CorCer	= $0.00				/* Campo smallmoney en ceros */

select	@FechaSis	= getdate()

select	@Mon_DesCor	= isnull(@Mon_DesCor, @Str_Vacio)	

if @Mon_DesCor = @Str_Vacio begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Descripción corta no valida',
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end

select	@Mon_DesCor	= ltrim(@Mon_DesCor)	

select @Num_EspBla	= patindex('%' + @Str_Vacio + '%', @Mon_DesCor)

if @Num_EspBla > @Ent_CorCer begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Descripción corta no valida, no debe contener espacios en blanco o algún otro caracter especial',
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end

select @Num_Punto	= patindex('%' + @Str_Punto + '%', @Mon_DesCor)

if @Num_Punto > @Ent_CorCer begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'Descripción corta no valida, no debe contener puntos o algún otro caracter especial',
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end

select	@Ant_EfeCom = Mon_EfeCom,
		@Ant_EfeVen	= Mon_EfeVen,
		@Ant_SpoVen	= Mon_SpoVen
	from SOMONEDA noholdlock
	where	Mon_Numero	= @Mon_Numero

select	@Ant_EfeCom = isnull(@Ant_EfeCom, @Flo_Cero),
		@Ant_EfeVen = isnull(@Ant_EfeVen, @Flo_Cero),
		@Ant_SpoVen = isnull(@Ant_SpoVen, @Flo_Cero)

if (@Mon_Descri = @Str_Vacio) begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'Descripcion incorrecta', 
			Err_Variab	= 'Mon_Descri'
	rollback
	return 1
end
if (@Mon_EfeCom < @Flo_Cero) begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'Efectivo Compra incorrecto', 
			Err_Variab	= 'Mon_EfeCom'
	rollback
	return 1
end
if (@Mon_EfeVen < @Flo_Cero) begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'Efectivo Venta incorrecto', 
			Err_Variab	= 'Mon_EfeVen'
	rollback
	return 1
	
end
if (@Mon_DocCom < @Flo_Cero) begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Documento Compra incorrecto', 
			Err_Variab	= 'Mon_DocCom'
	rollback
	return 1
end
if (@Mon_DocVen < @Flo_Cero) begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Documento Venta incorrecto', 
			Err_Variab	= 'Mon_DocVen'
	rollback
	return 1
end
if (@Mon_CieCom < @Flo_Cero) and (@Mon_Tipo <> @Tip_Metal) begin
	select	Err_Codigo	= '000012', 
			Err_Mensaj	= 'Cierre Compra incorrecto', 
			Err_Variab	= 'Mon_CieCom'
	rollback
	return 1
end
if (@Mon_CieVen < @Flo_Cero)  and (@Mon_Tipo <> @Tip_Metal)begin
	select	Err_Codigo	= '000013', 
			Err_Mensaj	= 'Cierre Venta incorrecto', 
			Err_Variab	= 'Mon_CieVen'
	rollback
	return 1
end
 if (@Mon_SpoCom < @Flo_Cero)  and (@Mon_Tipo <> @Tip_Metal) begin
	select	Err_Codigo	= '000014',	
			Err_Mensaj	= 'Spot Compra incorrecto', 
			Err_Variab	= 'Mon_CieCom'
	rollback
	return 1	
end
if (@Mon_SpoVen < @Flo_Cero) and (@Mon_Tipo <> @Tip_Metal) begin
	select	Err_Codigo	= '000015', 
			Err_Mensaj	= 'Spot Venta incorrecto', 
			Err_Variab	= 'Mon_CieVen'
	rollback
	return 1	
end
if (@Mon_CieDia < @Flo_Cero) begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Cierre Dia incorrecto', 
			Err_Variab	= 'Mon_CieDia'
	rollback
	return 1	
end
if not exists (select	Cue_Cuenta
				from COCUENTA noholdlock
				where	Cue_Cuenta	= substring(@Mon_CtaEfe, 1, 4)
				  and	Cue_SubCue	= substring(@Mon_CtaEfe, 5, 2)
				  and	Cue_SSCue	= substring(@Mon_CtaEfe, 7, 2)
				  and	Cue_SSSCue	= substring(@Mon_CtaEfe, 9, 2)
				  and	Cue_Concep	= substring(@Mon_CtaEfe, 11, 2)
				  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaEfe <> @Str_Vacio begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaEfe'
	rollback
	return 1
	
end
if not exists (select	Cue_Cuenta
				from COCUENTA noholdlock
				where	Cue_Cuenta	= substring(@Mon_CtaBM, 1, 4)
				  and	Cue_SubCue	= substring(@Mon_CtaBM, 5, 2)
				  and 	Cue_SSCue	= substring(@Mon_CtaBM, 7, 2)
				  and	Cue_SSSCue	= substring(@Mon_CtaBM, 9, 2)
				  and	Cue_Concep	= substring(@Mon_CtaBM, 11, 2)
				  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaBM <> @Str_Vacio begin
	select	Err_Codigo	= '000018', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaBM'
	rollback
	return 1
	
end
if not exists (select	Cue_Cuenta
				from COCUENTA noholdlock
				where	Cue_Cuenta	= substring(@Mon_CtaSBC, 1, 4)
				  and	Cue_SubCue	= substring(@Mon_CtaSBC, 5, 2)
				  and	Cue_SSCue	= substring(@Mon_CtaSBC, 7, 2)
				  and	Cue_SSSCue	= substring(@Mon_CtaSBC, 9, 2)
				  and	Cue_Concep	= substring(@Mon_CtaSBC, 11, 2)
				  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaSBC <> @Str_Vacio begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaSBC'
	rollback
	return 1
end
if not exists (select	Cue_Cuenta
				from COCUENTA noholdlock
				where	Cue_Cuenta	= substring(@Mon_CtaRem, 1, 4)
				  and	Cue_SubCue	= substring(@Mon_CtaRem, 5, 2)
				  and	Cue_SSCue	= substring(@Mon_CtaRem, 7, 2)
				  and	Cue_SSSCue	= substring(@Mon_CtaRem, 9, 2)
				  and	Cue_Concep	= substring(@Mon_CtaRem, 11, 2)
				  and	Cue_Compan	= @Cue_Compan) and @Mon_CtaRem <> @Str_Vacio begin
	select	Err_Codigo	= '000020', 
			Err_Mensaj	= 'La cuenta contable no existe', 
			Err_Variab	= 'Mon_CtaRem'
	rollback
	return 1
	
end
if (@Mon_Fecha <= @Fec_Vacia) begin
	select	Err_Codigo	= '000021', 
			Err_Mensaj	= 'Fecha incorrecta', 
			Err_Variab	= 'Mon_Fecha'
	rollback
	return 1

end
if exists (select	Mon_DesCor
			from SOMONEDA noholdlock
			where	Mon_DesCor	=  @Mon_DesCor
			  and   Mon_Numero	<> @Mon_Numero) begin
	select	Err_Codigo	= '000022', 
			Err_Mensaj	= 'La descripción corta ya existe', 
			Err_Variab	= 'Mon_DesCor'
	rollback
	return 1

end
if (@Mon_FixVal < @Flo_Cero) and (@Mon_Tipo <> @Tip_Metal)  begin
	select	Err_Codigo	= '000023', 
			Err_Mensaj	= 'Fix Valuacion incorrecto', 
			Err_Variab	= 'Mon_FixVal'
	rollback
	return 1	
	
end
	
if @Mon_DesLeg = @Str_Vacio
	select	@Mon_DesLeg	= @Mon_Abrevi
	
select	@Par_FecAct	= Par_FecHoy
	from ITPARAMS noholdlock

if @Mon_Fecha  = @Par_FecAct begin
	update SOMONEDA set
		Mon_Numero	= @Mon_Numero, 
		Mon_Descri	= @Mon_Descri, 
		Mon_Simbol	= @Mon_Simbol,
		Mon_Tipo	= @Mon_Tipo,
		Mon_EqBaMa	= @Mon_EqBaMa,
		Mon_Fecha 	= @Mon_Fecha,  
		Mon_EfeCom	= @Mon_EfeCom, 
		Mon_EfeVen	= @Mon_EfeVen,
		Mon_DocCom	= @Mon_DocCom, 
		Mon_DocVen	= @Mon_DocVen, 
		Mon_FixCom	= @Mon_FixCom, 
		Mon_FixVen	= @Mon_FixVen, 
		Mon_Abrevi	= @Mon_Abrevi, 
		Mon_DesCor	= @Mon_DesCor,
		Mon_DesLeg	= @Mon_DesLeg,
		Mon_CtaEfe	= @Mon_CtaEfe, 
		Mon_CtaBM 	= @Mon_CtaBM,  
		Mon_CtaSBC	= @Mon_CtaSBC,
		Mon_CtaRem	= @Mon_CtaRem,
		Mon_CieCom	= @Mon_CieCom, 
		Mon_CieVen	= @Mon_CieVen,
		Mon_SpoCom	= @Mon_SpoCom,
		Mon_SpoVen	= @Mon_SpoVen,			
		Mon_CieDia	= @Mon_CieDia,
		Mon_FixVal	= @Mon_FixVal,
		Mon_ForMet 	= @Mon_ForMet ,			
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Mon_Numero	= @Mon_Numero
end else
	update SOMONEDA set
		Mon_Descri	= @Mon_Descri, 
		Mon_Simbol	= @Mon_Simbol,
		Mon_Tipo	= @Mon_Tipo,
		Mon_EqBaMa	= @Mon_EqBaMa,
		Mon_Fecha 	= @Mon_Fecha,  
		Mon_Abrevi	= @Mon_Abrevi, 
		Mon_DesCor	= @Mon_DesCor,
		Mon_DesLeg	= @Mon_DesLeg,
		Mon_CtaEfe	= @Mon_CtaEfe, 
		Mon_CtaBM 	= @Mon_CtaBM,  
		Mon_CtaSBC	= @Mon_CtaSBC,
		Mon_CtaRem	= @Mon_CtaRem,
		Mon_ForMet	= @Mon_ForMet
		where	Mon_Numero	= @Mon_Numero
		
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
		
/* No es necesario llevar historia de modifcaciones al tipo de Cambio Spot */
if @Transaccio != @Tra_ActSpo begin
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
end

if @Mon_Tipo = @Tip_Metal and (@Ant_EfeCom <> @Mon_EfeCom or @Ant_EfeVen <> @Mon_EfeVen) begin
	select	@Mon_SpoVen	= Mon_SpoVen
		from SOMONEDA noholdlock
		where	Mon_Numero	= @Mon_Dolar

	select	@Mon_SpoVen	= isnull(@Mon_SpoVen, @Flo_Cero)

	exec @Status = ESDENMETACT 
		@Mon_Numero,	@Mon_Cero,		@Mon_CorCer,	@Mon_CorCer,	@Mon_CorCer,
		@Mon_CorCer,	@Mon_Cero,		@Mon_Cero,		@Mon_Cero,		@Mon_Cero,
		@Mon_SpoVen,	@Mon_Cero,		@Tip_ActMet,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo		
	if @Status <> 0 begin
		select	Err_Codigo	= '000025', 
				Err_Mensaj	= 'No se pudo actulizar el precio de los metales', 
				Err_Variab	= 'Mon_FixVal'
		rollback
		return 1
	end		
end

select	Err_Codigo	= '000000',	
		Err_Mensaj	= 'Registro Modificado'