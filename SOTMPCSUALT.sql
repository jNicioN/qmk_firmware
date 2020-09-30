create procedure SOTMPCSUALT (
	@Csu_CoTiMo	int,
	@Csu_Sucurs	int,
	@Csu_Activo	bit,
	@Csu_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion sucursal				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCSU values(
	@Csu_CoTiMo,		@Csu_Sucurs,		@Csu_Activo,		@Csu_FecCon)