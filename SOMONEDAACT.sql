create procedure SOMONEDAACT (
	@Mon_Numero	char(2),
	@Mon_SpoCom	double precision,
	@Mon_SpoVen	double precision,
	@Mon_ValMet	double precision,
	@Mon_AbrISO	varchar(3),
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: ***Actualización por tipo de proceso.*** */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modificó:	Marco Pardo												****
** Fecha:		10/07/2017												****
** Descripción:	Validación con valor superior e inferior de metales 	****
** Help			1002506													****
****************************************************************************
** Modificó:		Eugenio Chairez Flores				****
** Fecha:		27/Marzo/2014					****
** Descripción:	Agregar Tipo Actualizacion para AbrISO			****
** Help			00644755					****
****************************************************************************
** Modificó:		Gustavo Cruz						****
** Fecha:		09/Abril/2013								****
** Descripción:	se modificó SOMONEDAMOD		****
** Help			538421									****
****************************************************************************
** Modificó:		Eugenio Salazar Orta						****
** Fecha:		21/Enero/2011								****
** Descripción:	Agregar Tipo Actualizacion para OpeCam		****
** Help			00340159									****
****************************************************************************
** Modificó:		Sandra Almaguer							****
** Fecha:		30/Agosto/2004								****
** Descripción:	Agregar parametro a SOMONEDAMOD.		****
****************************************************************************
** Modificó:		Laura V. Vázquez Nieto						****
** Fecha:		27/Agosto/2004								****
** Descripción:	Agregar actualización de valor de metales.	****
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
** Modificó:		Lucina Gonzalez trejo.						****
** Fecha:		17/Julio/03									****
** Descripción:	Agregar el campo Mon_DesCor				****
****************************************************************************
** Modificó:		Eduardo Salazar Gtz.						****
** Fecha:		17/Enero/03								****
** Descripción:	Se elimino el campo Mon_TasCam y se agrego****
**				el Mon_CieDia								****
****************************************************************************
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchez					****
** Fecha:		26/Diciembre/02							****
** Descripción:	Se agrego el tipo de modificación de  tasa de 	****
**				moneda de cambios.							****
****************************************************************************
****************************************************************************
** Modificó:		Ma de Lourdes Valdés Ramírez				****
** Fecha:		27/Noviembre/02							****
** Descripción:	Se agrego el campo Mon_EqBaMa  			****
****************************************************************************
** Creó:			RGUTIERREZ     							****
** Fecha:		21/Ago/02									****
******************************************************************************/

/* Declaración de Variables */
declare	@Mon_Descri varchar(30),
		@Mon_Simbol varchar(10),
		@Mon_Tipo	char(1),
		@Mon_EqBaMa	varchar(35),
		@Mon_CodISO	char(3),
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
		@Mon_CieDia	float,
		@Mon_FixVal	float,		
		@Status		int,
		@Mon_ForMet	char(2),
		@Mon_MetSup double precision,
		@Mon_MetInf double precision,
		@Est_Activo char(1),
		@Res_Dato int

/* Declaración de Constantes */
declare	@Tip_SPOT	char(1),
		@Tip_MonCam	char(1),
		@Ope_MonCam	char(1),
		@Ope_MoSiCa	char(1),
		@Ope_MoNoCa	char(1),
		@Tip_ValMet	char(1),
		@Tip_CodISO	char(1),
		@Tip_ActISO	char(1),
		@Str_Vacio	char(1),
		@Est_NoActi char(1),
		@Tip_MonMet char(1),
		@Ent_Cero int,
		@Str_CerTre char(2)

/* Asignación de Constantes */
select	@Tip_SPOT	= 'S',				/* Proceso de Actualización de SPOT */
		@Tip_MonCam	= 'C',				/* Proceso de Actualización de Tasa de Cambios */
		@Tip_MonMet = 'O',				/* Tipo Moneda Metal */
		@Ope_MonCam	= 'O',				/* La Moneda Opera con Cambios */
		@Ope_MoSiCa	= 'S',				/* La Moneda Si Opera con Cambios */
		@Ope_MoNoCa	= 'N',				/* La Moneda No Opera con Cambios */
		@Tip_ValMet	= 'M',				/* Actualicación de valor de metales */
		@Tip_CodISO	= 'I',				/* Proceso de Actualización de Código ISO */
		@Tip_ActISO	= 'L',				/* Proceso para Limpiar Mon_AbrISO */
		@Str_Vacio	= '',				/* String Vacio */
		@Ent_Cero = 0,					/* Entero Cero */
		@Est_NoActi = 'N',				/* Estado no activo */
		@Str_CerTre = '03'				/* Cero tres */

select	@Mon_Fecha	= Par_FecHoy
	from ITPARAMS noholdlock

if @Tip_Actual = @Tip_SPOT begin

	select 	@Mon_Descri	= Mon_Descri, 
			@Mon_Simbol	= Mon_Simbol, 
			@Mon_EqBaMa	= Mon_EqBaMa,
			@Mon_EfeCom	= Mon_EfeCom, 
			@Mon_EfeVen	= Mon_EfeVen, 
			@Mon_DocCom	= Mon_DocCom, 
			@Mon_DocVen	= Mon_DocVen, 
			@Mon_FixCom	= Mon_FixCom, 
			@Mon_FixVen	= Mon_FixVen, 
			@Mon_Abrevi	= Mon_Abrevi, 
			@Mon_DesCor	= Mon_DesCor,
			@Mon_DesLeg	= Mon_DesLeg,
			@Mon_CtaEfe	= Mon_CtaEfe, 
			@Mon_CtaBM	= Mon_CtaBM, 
			@Mon_CtaSBC	= Mon_CtaSBC, 
			@Mon_CtaRem	= Mon_CtaRem, 
			@Mon_CieCom	= Mon_CieCom, 
			@Mon_CieVen	= Mon_CieVen,
			@Mon_CieDia	= Mon_CieDia,
			@Mon_FixVal	= Mon_FixVal,
			@Mon_Tipo	= Mon_Tipo,
			@Mon_ForMet	= Mon_ForMet
		from SOMONEDA noholdlock
		where	Mon_Numero	= @Mon_Numero
	
	if @Mon_Tipo <> @Tip_MonMet and @Mon_ForMet <> @Str_CerTre begin
		execute @Status = SOMONEDAMOD
			@Mon_Numero,	@Mon_Descri,	@Mon_Simbol, 	@Mon_Tipo,		@Mon_EqBaMa,	
			@Mon_Fecha,		@Mon_EfeCom, 	@Mon_EfeVen, 	@Mon_DocCom, 	@Mon_DocVen, 	
			@Mon_FixCom, 	@Mon_FixVen, 	@Mon_Abrevi, 	@Mon_DesCor,	@Mon_DesLeg,	
			@Mon_CtaEfe,	@Mon_CtaBM, 	@Mon_CtaSBC, 	@Mon_CtaRem, 	@Mon_CieCom, 	
			@Mon_CieVen,	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_CieDia,	@Mon_FixVal,	
			@Mon_ForMet,	@NumTransac,	@Transaccio, 	@Usuario, 		@FechaSis,
			@SucOrigen,		@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end
	end
end else if @Tip_Actual = @Tip_ValMet begin
	select 	@Mon_Descri	= Mon_Descri, 
			@Mon_Simbol	= Mon_Simbol, 
			@Mon_EqBaMa	= Mon_EqBaMa,
			@Mon_DocCom	= Mon_DocCom, 
			@Mon_DocVen	= Mon_DocVen, 
			@Mon_FixCom	= Mon_FixCom, 
			@Mon_FixVen	= Mon_FixVen, 
			@Mon_Abrevi	= Mon_Abrevi, 
			@Mon_DesCor	= Mon_DesCor,
			@Mon_DesLeg	= Mon_DesLeg,
			@Mon_CtaEfe	= Mon_CtaEfe, 
			@Mon_CtaBM	= Mon_CtaBM, 
			@Mon_CtaSBC	= Mon_CtaSBC, 
			@Mon_CtaRem	= Mon_CtaRem, 
			@Mon_CieCom	= Mon_CieCom, 
			@Mon_CieVen	= Mon_CieVen,
			@Mon_SpoCom	= Mon_SpoCom,
			@Mon_SpoVen	= Mon_SpoVen,	
			@Mon_CieDia	= Mon_CieDia,
			@Mon_FixVal	= Mon_FixVal,
			@Mon_Tipo	= Mon_Tipo,
			@Mon_ForMet	= Mon_ForMet
		from SOMONEDA noholdlock
		where	Mon_Numero	= @Mon_Numero
	
	/*Validación con valor superior e inferior de metal*/
		select @Res_Dato = count(Cvm_Moneda) 
			from ESCOVAME noholdlock 
			where Cvm_Moneda = @Mon_Numero
			
	if isnull(@Res_Dato,@Ent_Cero) = @Ent_Cero begin
		select 	Err_Codigo = '000010', 
				Err_Mensaj = 'No se puede efectuar la venta dado que el valor de venta no está dentro de los límites de precios establecidos.'
		rollback
		return 1
	end else begin
		select 	@Mon_MetSup = Cvm_VaVeSu, 
				@Mon_MetInf	=  Cvm_VaVeIn,
				@Est_Activo =  Cvm_Estado
			from ESCOVAME noholdlock
			where  Cvm_Moneda = @Mon_Numero
			
		if @Mon_ValMet < @Mon_MetInf or @Mon_ValMet > @Mon_MetSup or @Est_Activo = @Est_NoActi begin
			select 	Err_Codigo = '000013', 
					Err_Mensaj = 'No se puede efectuar la venta dado que el valor de venta no está dentro de los límites de precios establecidos.'
			rollback
			return 1
		end
	end
	
	execute @Status = SOMONEDAMOD
		@Mon_Numero,	@Mon_Descri,	@Mon_Simbol, 	@Mon_Tipo,		@Mon_EqBaMa,	
		@Mon_Fecha,		@Mon_ValMet, 	@Mon_ValMet, 	@Mon_DocCom, 	@Mon_DocVen, 	
		@Mon_FixCom, 	@Mon_FixVen, 	@Mon_Abrevi, 	@Mon_DesCor,	@Mon_DesLeg,	
		@Mon_CtaEfe,	@Mon_CtaBM, 	@Mon_CtaSBC, 	@Mon_CtaRem, 	@Mon_CieCom, 	
		@Mon_CieVen,	@Mon_SpoCom,	@Mon_SpoVen,	@Mon_CieDia,	@Mon_FixVal,	
		@Mon_ForMet,	@NumTransac,	@Transaccio, 	@Usuario, 		@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end
end else if @Tip_Actual = @Ope_MonCam begin
	update 	SOMONEDA set
		Mon_OpeCam	= @Ope_MoSiCa,
		
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario	= @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
		where	Mon_Numero	= @Mon_Numero
end else if @Tip_Actual = @Ope_MoNoCa begin
	update 	SOMONEDA set
		Mon_OpeCam	= @Ope_MoNoCa,
		
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario	= @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
		where	Mon_Numero	= @Mon_Numero
end else if @Tip_Actual = @Tip_CodISO begin
	update 	SOMONEDA set
		Mon_AbrISO	= @Mon_AbrISO,
		
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario	= @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
		where	Mon_Numero	= @Mon_Numero
end else if @Tip_Actual = @Tip_ActISO begin
	update 	SOMONEDA set
		Mon_AbrISO	= @Str_Vacio,
		
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario	= @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
		where	Mon_Numero	= @Mon_Numero
end
