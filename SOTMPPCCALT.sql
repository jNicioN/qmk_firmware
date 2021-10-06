create procedure SOTMPPCCALT (
	@Pcc_Numero	int,
	@Pcc_TipCre	char(2),
    @Pcc_Produc	int,
	@Pcc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto  credito consumo       		****
****************************************************************************
** Creó:			Frank Canul				                            ****
** Fecha:		05-10-2021									            ****
** Help:												            ****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPCC values(
	@Pcc_Numero,		@Pcc_TipCre,		@Pcc_Produc,		@Pcc_FecCon)