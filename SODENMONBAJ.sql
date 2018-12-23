create procedure SODENMONBAJ (
	@Dem_Moneda	char(2),
	@Dem_Denomi	money,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaración de variables */
declare	@Bil_Cantid	money

/* Declaración de constantes */
declare	@Mon_Cero	money

/* Asignación de valores a constantes */
select	@Mon_Cero	= $0.00 		/* Campo money en ceros */

if not exists (	select	Dem_Moneda
					from SODENMON noholdlock
					where	Dem_Moneda	= @Dem_Moneda
					  and	Dem_Denomi	= @Dem_Denomi) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La denominacion no existe',
			Err_Variab	= 'Dem_Denomi'
	rollback
	return 1
end
	
if exists (	select	Dme_Moneda
				from ESDENMET noholdlock
				where	Dme_Moneda	= @Dem_Moneda
				  and	Dme_Denomi	= @Dem_Denomi) begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'Esta moneda todavía existe en el catálogo de denominaciones de metales',
			Err_Variab	= 'Dem_Denomi'
	rollback
	return 1
end 

select	@Bil_Cantid	= Bil_Cantid
	from VEBILLET noholdlock
	where	Bil_Moneda	= @Dem_Moneda
	  and	Bil_Denomi	= @Dem_Denomi
select	@Bil_Cantid	= isnull(@Bil_Cantid,@Mon_Cero)  

if @Bil_Cantid <> @Mon_Cero begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'La ventanilla tiene existencia de esa moneda y esa denominación',
			Err_Variab	= 'Dem_Denomi'
	rollback
	return 1
end 
	
delete from SODENMON
	where	Dem_Moneda	= @Dem_Moneda
	  and	Dem_Denomi	= @Dem_Denomi

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Borrado'

