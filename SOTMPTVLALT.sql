create procedure SOTMPTVLALT (
	@Tvl_Numero	smallint,
	@Tvl_Nombre	varchar(70),
	@Tvl_Abrevi	varchar(15),
	@Tvl_EsEnt	bit,
	@Tvl_EsMon	bit,
	@Tvl_EsDec	bit,
	@Tvl_Logico	bit,
	@Tvl_EsFech	bit,
	@Tvl_Activo	bit,
	@Tvl_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo tipo valor				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPTVL values(
	@Tvl_Numero,		@Tvl_Nombre,		@Tvl_Abrevi,		@Tvl_EsEnt,			@Tvl_EsMon,
	@Tvl_EsDec,			@Tvl_Logico,		@Tvl_EsFech,		@Tvl_Activo,		@Tvl_FecCon)