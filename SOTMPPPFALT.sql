create procedure SOTMPPPFALT (
	@Ppf_Numero	int,
	@Ppf_Produc	int,
	@Ppf_PerFis	smallint,
	@Ppf_Activo	bit,
	@Ppf_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto personalidad fiscal 		****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		20-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPPF values(
	@Ppf_Numero,		@Ppf_Produc,		@Ppf_PerFis,		@Ppf_Activo,		@Ppf_FecCon)