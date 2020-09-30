create procedure SOTMPVIGALT (
	@Vig_CoTiMo	int,
	@Vig_FecIni	smalldatetime,
	@Vig_FecFin	smalldatetime,
	@Vig_Activo	bit,
	@Vig_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo vigencia configuracion	**				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPVIG values(
	@Vig_CoTiMo,		@Vig_FecIni,		@Vig_FecFin,		@Vig_Activo,		@Vig_FecCon)