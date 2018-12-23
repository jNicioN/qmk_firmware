create procedure SOCOFIMZCON (
	@Cof_Compan	char(3),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* 	Descripcion							****
**	Tomar parametros de conexion a Mizar por compañia		****
**									***/
/** REFERENCIAS: 
****************************************************************************
** Creó:		David Ruiz	  				****
** Fecha:		21/Jun/12					****
** Help:		452811						****
***************************************************************************/

select	Cof_Compan,	Cof_Server,	Cof_BasDat,	Cof_Usuari,	Cof_Contra,
		Cof_NoOdBc
	from	SOCOFIMZ 	noholdlock
	where	Cof_Compan	= @Cof_Compan
