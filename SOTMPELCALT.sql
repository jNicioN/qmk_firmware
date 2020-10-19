create procedure SOTMPELCALT (
	@Elc_Numero	numeric,
	@Elc_TiMoAs	int,
	@Elc_ElTiMo	smallint,
	@Elc_Valor	decimal,
	@Elc_Activo	bit,
	@Elc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo elemento configuracion				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPELC values(
	@Elc_Numero,		@Elc_TiMoAs,		@Elc_ElTiMo,		@Elc_Valor,			@Elc_Activo,
	@Elc_FecCon)