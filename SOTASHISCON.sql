create procedure SOTASHISCON (
	@Tasa		char(2),
	@FechaIni 	smalldatetime,
	@FechaFin 	smalldatetime,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6), 
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3), 
	@Modulo 	char(2))

AS


select	Hit_Tasa,	Hit_Fecha,	Hit_Valor
	from SOHISTAS noholdlock
	where	Hit_Tasa	= @Tasa
	  and	Hit_Fecha	>= @FechaIni
	  and	Hit_Fecha	<= @FechaFin
	  order by Hit_Fecha
	
