create procedure SOTMPCLPALT (
	@Clp_Numero	int,
	@Clp_Clasif	int,
    @Clp_Produc	int,
	@Clp_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo clasificacion producto       		****
****************************************************************************
** Creó:			Frank Canul				                            ****
** Fecha:		05-10-2021									            ****
** Help:		1574028										            ****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCLP values(
	@Clp_Numero,		@Clp_Clasif,		@Clp_Produc,		@Clp_FecCon, 	@NumTransac)