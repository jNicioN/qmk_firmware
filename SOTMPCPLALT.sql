create procedure SOTMPCPLALT (
	@Cpl_CoTiMo	int,
	@Cpl_Plazas	int,
	@Cpl_Activo	bit,
	@Cpl_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion plaza**				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCPL values(
	@Cpl_CoTiMo,		@Cpl_Plazas,		@Cpl_Activo,		@Cpl_FecCon)