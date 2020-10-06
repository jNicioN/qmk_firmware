create procedure SOTMPTMCALT (
	@Tmc_Numero	numeric,
	@Tmc_PrPeCo	int,
	@Tmc_PrTiMo	int,
	@Tmc_Aplica	bit,
	@Tmc_Termin	bit,
	@Tmc_Activo	bit,
	@Tmc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo tipo movimiento configuracion		****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPTMC values(
	@Tmc_Numero,		@Tmc_PrPeCo,		@Tmc_PrTiMo,		@Tmc_Aplica,		@Tmc_Termin,
	@Tmc_Activo,		@Tmc_FecCon)