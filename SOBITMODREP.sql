create procedure SOBITMODREP (
	@Bit_FecIni	smalldatetime,
	@Bit_FecFin	smalldatetime,
	
	@Tip_Report char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

select 	Usu_Nombre,	Bit_Fecha,	Bit_Hora,	Bit_Nombre,
		Bit_Refere,	Bit_Coment,	Bit_RegIni,	Bit_RegCar,
		Bit_RegFin,	Bit_Tipo,	Bit_Archiv
	from SOBITMOD bit,
		 SOUSUARI usu
	where 	Usu_Numero = Bit_Usuari
		and bit.FechaSis between @Bit_FecIni and @Bit_FecFin
	order by bit.FechaSis


