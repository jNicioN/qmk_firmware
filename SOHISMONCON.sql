create procedure SOHISMONCON (
	@Moneda		char(2),
	@Fecha		smalldatetime,
	@Tipo		char(1),
	@Valor		real output,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************
** Descripcion: ** Consulta a historico de monedas 							**
****************************************************************************
** REFERENCIAS:
*****************************************************************************
** Modificó:	Norman Valenzuela										****
** Fecha:		06/Octubre/2014											****
** Help:		00469845												****
** Descripción:	Devolver Resultado si @Tipo = 'Z'						****
****************************************************************************
** Modificó:		Eugenio Chairez Flores 		    					****
** Fecha:		18/07/2012												****
** Help:			00457954											****
** Descripción:	Se agrega Tipo de Consulta para validacion 				****
** 				de tipo de Cambio FIX 									****
****************************************************************************
** Modificó:		Gerardo Avila				    					****
** Fecha:		28/Enero/2008											****
** Help:			22090												****
** Descripción:	Se agrego el tipo de consulta, compra para				****
** 				cierres (Him_Cie_Com)									****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo								****
** Fecha:		05/Julio/07												****
** Help:			36301												****
** Descripción:	if @@nestlevel = 1										****
**				select	Valor	= @Valor								****
****************************************************************************
**                           Store CONVERTIDO 							****
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchesz.							****
** Fecha:		22/Julio/03												****
** Descripción:	Se agregó el campo Him_FixVal.							****
****************************************************************************
****************************************************************************
** Modificó:		Eduardo Salazar Gtz.		    					****
** Fecha:		17/Enero/2003											****
** Descripción:	Se agrego el tipo de consulta cierre del dia			****
****************************************************************************
****************************************************************************
** Modificó:		Roberto Gutiérrez Sánchez    						****
** Fecha:		27/Agosto/2002											****
** Descripción:	Se agregaron los tipos de consulta para 				****
**				los valores SPOT.										****
****************************************************************************
****************************************************************************
** Modificó:		FCHIA          										****
** Fecha:		27/Abr/01												****
** Descripción:	Estandarización											****
****************************************************************************
** Modificó:		CLAZARIN       										****
** Fecha:		06/Jul/98												****
** Descripción:	Escribir Breve Descripción								****
****************************************************************************/
declare	@Him_Fecha	smalldatetime			/* Declaración de Variables */		

declare	@Mon_Cero	money,					/* Declaración de Constantes */
		@Con_EfeCom	char(1),				
		@Con_EfeVen	char(1),				
		@Con_DocCom	char(1),				
		@Con_DocVen	char(1),										
		@Con_FIX	char(1),
		@Con_SpoCom	char(1),				
		@Con_SpoVen	char(1),
		@Con_CieDia	char(1),
		@Con_FixVal	char(1),
		@Con_CieCom	char(1),
		@Con_ValFix char(1),
		@Con_LlaMar char(1)

/* Asignación de Constantes */
select	@Mon_Cero	= $0.00,				/* Moneda en Cero */
		@Con_EfeCom	= '1',					/* Tipo de Consulta: Efectivo Compra */
		@Con_EfeVen	= '2',					/* Tipo de Consulta: Efectivo Compra */
		@Con_DocCom	= '3',					/* Tipo de Consulta: Documento Compra */
		@Con_DocVen	= '4',					/* Tipo de Consulta: Documento Venta */
		@Con_FIX	= '5',					/* Tipo de Consulta: FIX */
		@Con_SpoCom	= '6',					/* Tipo de Consulta: SPOT Compra */	
		@Con_SpoVen	= '7',					/* Tipo de Consulta: SPOT Venta */
		@Con_CieDia	= '8',					/* Tipo de Consulta: Cierre del dia */
		@Con_FixVal	= '9',					/* Tipo de Consulta: Fix de Valuación */
		@Con_CieCom	= 'A',					/* Tipo de Consulta: Compra, para cierres */
		@Con_ValFix	= 'B',					/* Tipo de Validacion al FixVal para cierres*/
		@Con_LlaMar = 'Z'					/* Tipo de Validacion para Llamadas de Margen*/		


select	@Him_Fecha	= max(Him_Fecha)
	from SOHISMON noholdlock
	where	Him_Fecha	<= @Fecha
	  and	Him_Moneda	= @Moneda

if @Tipo = @Con_EfeCom
	select	@Valor		= Him_EfeCom
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
		
else if @Tipo = @Con_EfeVen
	select	@Valor		= Him_EfeVen
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
		  
else if @Tipo = @Con_DocCom
	select	@Valor 		= Him_DocCom
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
		  
else if @Tipo = @Con_DocVen
	select	@Valor		= Him_DocVen 
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
		  
else if @Tipo = @Con_FIX
	select	@Valor		= Him_FixVen
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda 
		  and	Him_Fecha	= @Him_Fecha

else if @Tipo = @Con_SpoCom
	select	@Valor 		= Him_SpoCom
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha

else if @Tipo = @Con_SpoVen
	select	@Valor 		= Him_SpoVen
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
		  
else if @Tipo = @Con_CieDia
	select	@Valor 		= Him_CieDia
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha

else if @Tipo = @Con_FixVal
	select	@Valor 		= Him_FixVal
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
else if @Tipo = @Con_CieCom
	select	@Valor 		= Him_CieCom
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Him_Fecha
else if @Tipo = @Con_ValFix
	select	@Valor 		= Him_FixVal
		from SOHISMON noholdlock
		where	Him_Moneda	= @Moneda
		  and	Him_Fecha	= @Fecha

		  
select	@Valor	= isnull(@Valor, @Mon_Cero)

if @@nestlevel = 1 or @Tipo = @Con_LlaMar
	select	Valor	= @Valor
