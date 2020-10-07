create procedure SOTMPCACALT (
	@Cac_CoTiMo	int,
	@Cac_CatCli	smallint,
	@Cac_Activo	bit,
	@Cac_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion categoria cliente**				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */



/* Alta de Catalogo */
insert into SOTMPCAC values(
	@Cac_CoTiMo,		@Cac_CatCli,		@Cac_Activo,		@Cac_FecCon)