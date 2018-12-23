create procedure SOPERFISALT (
	@Per_Numero	char(1),
	@Per_Descri	varchar(50),
	@Per_ActEmp	char(1),
	@Per_Status	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* REFERENCIAS
****************************************************************************
** Creó:			Joel Moctezuma Guerrero								****
** Fecha:			20/Agosto/2013										****
** Help-Desk:		00559136											****
** Descripción:		Alta de Tipo de Persona Fiscal			 			****
****************************************************************************
*/

/* Declaración de Variables */
		
/* Declaracion de Constantes */
		
/* Asignacion de Constantes */

insert into SOPERFIS
	values(	@Per_Numero,	@Per_Descri,	@Per_ActEmp,	@Per_Status, 	@NumTransac,
			@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
