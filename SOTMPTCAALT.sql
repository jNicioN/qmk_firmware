create procedure SOTMPTCAALT (
	@Tca_Numero	smallint,
	@Tca_Nombre	varchar(70),
	@Tca_Abrevi	varchar(15),
	@Tca_Descri	varchar(300),
	@Tca_Activo	bit,
	@Tca_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo tipo calculo				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPTCA values(
	@Tca_Numero,		@Tca_Nombre,		@Tca_Abrevi,		@Tca_Descri,		@Tca_Activo,
	@Tca_FecCon)