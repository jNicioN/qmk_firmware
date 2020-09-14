create procedure SOTMPPPCALT (
	@Ppc_Numero	numeric,
	@Ppc_CoTiMo	int,
	@Ppc_PrPeFi	smallint,
	@Ppc_Activo	bit,
	@Ppc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto personalidad configuracion	****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */

/* Alta de Catalogo */
insert into SOTMPPPC values(
	@Ppc_Numero,		@Ppc_CoTiMo,		@Ppc_PrPeFi,		@Ppc_Activo,		@Ppc_FecCon)