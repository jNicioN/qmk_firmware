create procedure SOTMPPROALT (
	@Pro_Numero	int,
	@Pro_Nombre	varchar(70),
	@Pro_Abrevi	varchar(15),
	@Pro_Activo	bit,
	@Pro_FecCon	smalldatetime,
	@Pro_NivAut int,
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
** Elaboró: 		Frank Canul						                    ****
** Fecha:		    22/09/2021									        ****
** Help:			1286068  									        ****
** Descripción:	    Se agrega campo Pro_NivAut y se elimna el			****
** 					campo de subproducto								 ****
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
	@Pro_Numero,		@Pro_Nombre,		@Pro_Abrevi,		@Pro_Activo,
	@Pro_FecCon,		@Pro_NivAut,		@NumTransac)