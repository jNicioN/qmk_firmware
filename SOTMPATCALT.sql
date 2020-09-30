create procedure SOTMPATCALT (
	@Atc_TipMov	int,
	@Atc_Modulo	char(2),
	@Atc_ApCoPe	bit,
	@Atc_TiCaMo	smallint,
	@Atc_PeApTi	smallint,
	@Atc_Proces	smallint,
	@Atc_StoPro	char(11),
	@Atc_Activo	bit,
	@Atc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo dato adicional tipo movimiento **				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPATC values(
	@Atc_TipMov,		@Atc_Modulo,		@Atc_ApCoPe,		@Atc_TiCaMo,		@Atc_PeApTi,
	@Atc_Proces,		@Atc_StoPro,		@Atc_Activo,		@Atc_FecCon)