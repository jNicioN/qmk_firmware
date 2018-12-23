create procedure SOMONEDABAJ (
	@Mon_Numero char(2),
	
	@NumTransac char(10), 
	@Transaccio char(3), 
	@Usuario 	char(6), 
	@FechaSis 	smalldatetime, 
	@SucOrigen 	char(3), 
	@SucDestino char(3), 
	@Modulo 	char(2))

as

if not exists (select	Mon_Numero
				   from SOMONEDA noholdlock
				   where	Mon_Numero	= @Mon_Numero) begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj 	= 'La moneda no existe', 
			Err_Variab 	= 'Mon_Numero'
	rollback
	return 1
end

if exists (	select	Dme_Moneda
				from ESDENMET noholdlock
				where	Dme_Moneda	= @Mon_Numero) begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Esta moneda todavía existe en el catálogo de denominaciones de metales',
			Err_Variab	= 'Mon_Numero'
	rollback
	return 1
end 

delete from SOMONEDA 
	where	Mon_Numero	= @Mon_Numero

delete from SOHISMON 
	where 	Him_Moneda 	= @Mon_Numero

select	Err_Codigo	= '000000', 
		Err_Mensaj 	= 'Registro Borrado'


