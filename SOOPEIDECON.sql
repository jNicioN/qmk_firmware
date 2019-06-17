create procedure SOOPEIDECON (
	@Opi_NuIdOp	int,			/* Número identificador de operación de identificación */
	@Opi_Descri	varchar(200),	/* Descripción de operación de Identificación */
	@Tip_Consul	char(2),		/* Tipo de consulta*/

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de Operaciones de Identificación		  **
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		08/Oct/2018										****
** Help:		01145227										****
** Descripción:	Actualizar L1 con rtrim ltrim a @Opi_Descri		****
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Francisco Javier Carrillo Rojas					****
** Fecha:		10/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		10/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Consulta de Operaciones de Identificación		****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	/* Consulta Tipo C/L*/
		@Tip_ConCon	char(1)		/* Tipo Consecutivo */

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1),
		@Str_Porcie	char(1),
		@Str_Vacio	char(1),
		@Sta_Activa	char(1)

/* Asignacion de Constantes */
select	@Str_C		= 'C',	/* Tipo C */
		@Str_Uno	= '1',	/* Tipo 1 */
		@Str_Dos    = '2',	/* Tipo 2 */
		@Str_Porcie	= '%',	/* String porciento */
		@Str_Vacio	= '',	/* String vacío */
		@Sta_Activa	= 'A'	/* Status de operación de identificación activa */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

create table #PersonasAutorizadas(
	Per_Numero   char(8)  not null)

create table #tmpPerson(
	Per_Person	char(8),
	Per_Grupo	char(8)) 

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin /* C1 - Búsqueda principal por llave primaria */			  			
		select	Opi_NuIdOp,	Opi_TipOpe,	Opi_Descri,	Opi_BasOpe,	Opi_Status
			from SOOPEIDE noholdlock
			where	Opi_NuIdOp	= @Opi_NuIdOp
	end	
end else begin
	if @Tip_ConCon	= @Str_Uno begin /* L1 - Búsqueda de operaciones de identificación de acuerdo a su descripción */
		select	@Opi_Descri	= ltrim(rtrim(isnull(@Opi_Descri, @Str_Vacio))) + @Str_Porcie
		
		select	Opi_NuIdOp,	Opi_TipOpe,	Opi_Descri,	Opi_BasOpe,	Opi_Status
			from SOOPEIDE noholdlock
			where	Opi_Status	= @Sta_Activa
			  and	Opi_Descri	like @Opi_Descri

	end else if @Tip_ConCon	= @Str_Dos begin /* L2 - Búsqueda todas las operaciones de identificación activas*/
		select	Opi_NuIdOp,	Opi_TipOpe,	Opi_Descri,	Opi_BasOpe,	Opi_Status
			from SOOPEIDE noholdlock
			where	Opi_Status	= @Sta_Activa
	end
end
