create procedure SOREAGCABAJ (
	@Tip_Consul int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************
*** REFERENCIAS: 														****
****************************************************************************
** Creo:	Pedro de los Reyes											****
** Descripcion:	Baja de Agentes											****
** Folio:		1230668													****
** Fecha:		05/AGOSTO/2019  										****
****************************************************************************/
declare	@Ent_Uno 	int				/* Declaracion de constantes*/

select @Ent_Uno		= 1				/* Entero en Uno*/

if @Tip_Consul = @Ent_Uno	begin
	delete from SOREAGCA
end