create procedure SOTMPETCALT (
	@Etc_Numero	int,
	@Etc_TiCaMo	smallint,
	@Etc_NumEle	smallint,
	@Etc_Nombre	varchar(70),
	@Etc_Abrevi	varchar(15),
	@Etc_Descri	varchar(250),
	@Etc_TiVaEl	smallint,
	@Etc_Activo	bit,
	@Etc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo elemento tipo calculo				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		24-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPETC values(
	@Etc_Numero,		@Etc_TiCaMo,		@Etc_NumEle,		@Etc_Nombre,		@Etc_Abrevi,
	@Etc_Descri,		@Etc_TiVaEl,		@Etc_Activo,		@Etc_FecCon)