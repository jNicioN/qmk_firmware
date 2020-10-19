create procedure SOTMPCZOALT (
	@Czo_CoTiMo	int,
	@Czo_Zonas	smallint,
	@Czo_Activo	bit,
	@Czo_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion zona				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCZO values(
	@Czo_CoTiMo,		@Czo_Zonas,			@Czo_Activo,		@Czo_FecCon)