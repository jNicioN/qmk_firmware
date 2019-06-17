create procedure SOPERFISCON (
	@Per_Numero	char(1),
	@Tip_Consul	char(2),

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
** Descripción:		Consulta de Tipo de Persona Fiscal			 			****
****************************************************************************
*/

/* Declaración de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)
		
/* Declaracion de Constantes */
declare	@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Uno	char(1)
		
/* Asignacion de Constantes */
select	@Tra_TipLis	= 'L',		/* Tipo : Lista */
		@Tra_TipCon	= 'C',		/* Tipo : Consulta */
		@Str_Uno	= '1'		/* String para consulta 1 */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip	= @Tra_TipLis begin		/* 'L':  Lista */
	if @Tip_ConCon	= @Str_Uno begin		/* Lista General */	
		select	Per_Numero,	Per_Descri,	Per_ActEmp,	Per_Status
			from SOPERFIS noholdlock
	end
end else begin
	if @Tip_ConCon	= @Str_Uno begin		/* Consulta Principal */	
		select	Per_Numero,	Per_Descri,	Per_ActEmp,	Per_Status
			from SOPERFIS noholdlock
			where Per_Numero = @Per_Numero
	end
end
