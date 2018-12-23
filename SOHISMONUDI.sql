create procedure SOHISMONUDI(
	@Mon_Numero char(2),
	@Mon_Fecha	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

if (@Mon_Fecha = '') and (@Mon_Numero = '')
	select  Mon_Fecha = Him_Fecha, Mon_EfeCom = Him_EfeCom
		from SOHISMON	
		order by Him_Moneda
else 
	select  Mon_Fecha = Him_Fecha, Mon_EfeCom = Him_EfeCom
		from SOHISMON	
		where	Him_Moneda = @Mon_Numero
		and		Him_Fecha  = @Mon_Fecha
