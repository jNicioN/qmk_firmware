create procedure SOTMPPROALT (
	@Pro_Numero	int,
	@Pro_Nombre	varchar(70),
	@Pro_Abrevi	varchar(15),
	@Pro_SubPro	smallint,
	@Pro_Activo	bit,
	@Pro_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo  producto				****
****************************************************************************
** Creó:			Frank canul				****
** Fecha:		20-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPRO values(
	@Pro_Numero,		@Pro_Nombre,		@Pro_Abrevi,		@Pro_SubPro,		@Pro_Activo,
	@Pro_FecCon)