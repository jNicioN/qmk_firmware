create procedure SOTMPPCOALT (
	@Pco_Numero	int,
	@Pco_TipCre	char(2),
    @Pco_Produc	int,
	@Pco_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto  credito comercial       		****
****************************************************************************
** Creó:			Frank Canul				                            ****
** Fecha:		05-10-2021									            ****
** Help:												            ****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPCO values(
	@Pco_Numero,		@Pco_TipCre,		@Pco_Produc,		@Pco_FecCon,	@NumTransac)