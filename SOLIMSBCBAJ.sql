create procedure SOLIMSBCBAJ (
	@Lim_EdoSuc	char(2),
	@Lim_CiuSuc	char(3),
	@Lim_EdoSbc	char(2),
	@Lim_CiuSbc	char(3),	

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
***	Eliminacion de Ciudades para SBC
****************************************************************************
*/

/*
****************************************************************************
** Creó:			Roberto Pascuale Morales Chavez			****
** Fecha:		29/Mar/12									****
** Help:			453782										****
****************************************************************************
*/

delete from SOLIMSBC
	where	Lim_EdoSuc	= @Lim_EdoSuc
	  and	Lim_CiuSuc	= @Lim_CiuSuc
	  and	Lim_EdoSbc	= @Lim_EdoSbc
	  and	Lim_CiuSbc	= @Lim_CiuSbc
