create procedure SOTMPCPRALT (
	@Cpr_CoTiMo	int,
	@Cpr_Produc	int,
	@Cpr_Activo	bit,
	@Cpr_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo  configuracion producto				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCPR values(
	@Cpr_CoTiMo,		@Cpr_Produc,		@Cpr_Activo,		@Cpr_FecCon)