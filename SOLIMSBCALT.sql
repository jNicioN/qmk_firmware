create procedure SOLIMSBCALT (
	@Lim_EdoSuc	char(2),
	@Lim_CiuSuc	char(3),	
	@Lim_PlaSuc	char(3),		
	@Lim_EdoSbc	char(2),	
	@Lim_CiuSbc	char(3),
	@Lim_PlaSbc char(3),

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
***	Alta de Ciudades para SBC
****************************************************************************
*/

/*
****************************************************************************
** Creó:			Roberto Pascuale Morales Chavez			****
** Fecha:		29/Mar/12									****
** Help:			453782										****
****************************************************************************
*/

insert into SOLIMSBC values (
	@Lim_EdoSuc,	@Lim_CiuSuc,	@Lim_PlaSuc,	@Lim_EdoSbc,	@Lim_CiuSbc,
	@Lim_PlaSbc,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino)
