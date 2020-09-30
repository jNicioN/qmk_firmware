create procedure SOTMPTIMALT (
	@Tim_Numero	int,
	@Tim_PrPeFi	smallint,
	@Tim_TipMov	int,
	@Tim_Activo	bit,
	@Tim_FecCon	smalldatetime
	,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo  tipo movimiento personalidad		****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */

/* Alta de Catalogo */
insert into SOTMPTIM values(
	@Tim_Numero,		@Tim_PrPeFi,		@Tim_TipMov,		@Tim_Activo,		@Tim_FecCon)