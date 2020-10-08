create procedure SOTMPCCUALT (
	@Ccu_CoTiMo	int,
	@Ccu_Cuenta	char(12),
	@Ccu_Activo	bit,
	@Ccu_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion cuenta**				****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCCU values(
	@Ccu_CoTiMo,		@Ccu_Cuenta,		@Ccu_Activo,		@Ccu_FecCon)