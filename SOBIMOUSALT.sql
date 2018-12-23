create procedure SOBIMOUSALT (
	@Bmu_Numero	int,
	@Bmu_Usuari	char(6),
	@Bmu_Motivo	char(1),
	@Bmu_TipMov	char(1),
	@Bmu_FecIni	smalldatetime,
	@Bmu_FecFin	smalldatetime,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/***************************************************************************
** DESCRIPCION: 														****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creo:			Carlos Adrian Bermea								****
** Fecha:			08/Febrero/2016										****
** Descripcion: 	Alta de BitÃ¡cora de Movimientos						****
** Help Desk:		837755 												****
***************************************************************************/
	insert into SOBIMOUS ( Bmu_Usuari, Bmu_Motivo, Bmu_TipMov, Bmu_FecIni, Bmu_FecFin, NumTransac, Transaccio, Usuario, FechaSis, SucOrigen, SucDestino, Modulo )
	values ( @Bmu_Usuari, @Bmu_Motivo, @Bmu_TipMov, @Bmu_FecIni, @Bmu_FecFin, @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo )
