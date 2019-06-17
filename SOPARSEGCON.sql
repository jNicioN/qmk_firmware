create procedure SOPARSEGCON (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************Consulta de Parámetros de Seguridad************************/

/*
****************************************************************************
** Creó:			Manuel Martínez Muñoz 						****
** Fecha:		16/Mayo/2012								****
** Help:		      462064										****
****************************************************************************
*/

select Pas_HoInAC, Pas_HoFiAC
	from SOPARSEG noholdlock
