create procedure SOCLASIFBAJ (
	@Cla_Numero int,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Baja de clasificacion de compania			 	       */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/


select @FechaSis = getdate()

delete SOCLASIF
	where Cla_Numero = @Cla_Numero
