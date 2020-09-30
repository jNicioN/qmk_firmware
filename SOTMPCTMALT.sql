create procedure SOTMPCTMALT (
	@Ctm_Numero	int,
	@Ctm_NivEnt	smallint,
	@Ctm_Descri	varchar(70),
	@Ctm_Vigenc	bit,
	@Ctm_Activo	bit,
	@Ctm_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion tipo movimiento		****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCTM values(
	@Ctm_Numero,		@Ctm_NivEnt,		@Ctm_Descri,		@Ctm_Vigenc,		@Ctm_Activo,
	@Ctm_FecCon)