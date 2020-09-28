create procedure SOTMPCTCALT (
	@Ctc_Numero	smallint,
	@Ctc_Nombre	varchar(70),
	@Ctc_Abrevi	varchar(15),
	@Ctc_Activo	bit,
	@Ctc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo categoria cliente				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCTC values(
	@Ctc_Numero,		@Ctc_Nombre,		@Ctc_Abrevi,		@Ctc_Activo,		@Ctc_FecCon)