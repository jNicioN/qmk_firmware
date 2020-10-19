create procedure SOTMPPTMALT (
	@Ptm_PrTiMo	int,
	@Ptm_NivEnt	smallint,
	@Ptm_Priori	smallint,
	@Ptm_Activo	bit,
	@Ptm_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo nivel tipo movimiento personalidad	****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */

/* Alta de Catalogo */
insert into SOTMPPTM values(
	@Ptm_PrTiMo,		@Ptm_NivEnt,		@Ptm_Priori,		@Ptm_Activo,		@Ptm_FecCon)