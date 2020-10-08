create procedure SOTMPCGCALT (
	@Cgc_CoTiMo	int,
	@Cgc_Grupos	smallint,
	@Cgc_Activo	bit,
	@Cgc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion grupo cliente**				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCGC values(
	@Cgc_CoTiMo,		@Cgc_Grupos,		@Cgc_Activo,		@Cgc_FecCon)