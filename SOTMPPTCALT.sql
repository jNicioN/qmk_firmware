create procedure SOTMPPTCALT (
	@Ptc_TipCue	smallint,
	@Ptc_Moneda	int,
	@Ptc_Produc	int,
	@Ptc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto tipo cuenta				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		20-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPTC values(
	@Ptc_TipCue,		@Ptc_Moneda,		@Ptc_Produc,		@Ptc_FecCon)