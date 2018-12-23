create procedure SOUNIPERBAJ (
	@Peu_Grupo	char(8),
	@Peu_Person	char(8),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/* Descripcion											****
************************************************************
**	Baja de Unificacion de Personas 					****
************************************************************
** Referencias											****
************************************************************
**		STORE CONVERTIDO								****
**		Convirio: David Ruiz							****
**		Fecha:	08/10/2013								****
************************************************************
**	Creo:	David Ruiz									****
**	Help:	00599444									****
**	Fecha:	08-Oct-2013									****
***********************************************************/

delete	SOUNIPER
	where	Peu_Grupo = @Peu_Grupo
	  and	Peu_Person = @Peu_Person
