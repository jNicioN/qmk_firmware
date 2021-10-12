create procedure SOTMPPTAALT (
	@Pta_Numero	int,
	@Pta_TipTar	char(4),
    @Pta_Produc	int,
	@Pta_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto  tarjeta       		****
****************************************************************************
** Creó:			Frank Canul				                            ****
** Fecha:		05-10-2021									            ****
** Help:				1574028								            ****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPTA values(
	@Pta_Numero,		@Pta_TipTar,		@Pta_Produc,		@Pta_FecCon,	@NumTransac)