-- drop procedure SOTMPCGCALT
create procedure SOTMPCGCALT (
	@Cgc_CoTiMo	int,
	@Cgc_Grupos	char(4),
	@Cgc_Activo	bit,
	@Cgc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo configuracion grupo cliente**		****
****************************************************************************
**  Modificó:  Frank canul                                                          ****
**  Fecha:     23/12/2020                                                              ****
**  Help:      1286068                                                          ****
**  Descripción: Se cambia el tipo de dato para Cgc_Grupos de int        ****   
**   a char(4)                                                           ****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		22-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPCGC
		(Cgc_CoTiMo,		Cgc_Grupos,		Cgc_Activo,		Cgc_FecCon)
		values
		(@Cgc_CoTiMo,	@Cgc_Grupos,	@Cgc_Activo,	@Cgc_FecCon)