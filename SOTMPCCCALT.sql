create procedure SOTMPCCCALT (
	@Ccc_CoTiMo	int,
	@Ccc_Clasif	int,
	@Ccc_Activo	bit,
	@Ccc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configracion clasificacion cliente **				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCCC values(
	@Ccc_CoTiMo,		@Ccc_Clasif,		@Ccc_Activo,		@Ccc_FecCon)