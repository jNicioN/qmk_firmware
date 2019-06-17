create procedure SODENMONALT	(
	@Dem_Moneda char(2),	@Dem_Denomi money,	@Dem_Descri varchar(30),
	@NumTransac char(10),	@Transaccio char(3),@Usuario char(6),
	@FechaSis smalldatetime,@SucOrigen char(3),	@SucDestino char(3),
	@Modulo char(2))

as

if @Dem_Denomi = 0 begin
	select Err_Codigo = '000001', Err_Mensaj = 'Denominacion incorrecta'
	rollback
	return 1
end else if not exists (select Mon_Numero
						from SOMONEDA
						where Mon_Numero = @Dem_Moneda) begin
	select Err_Codigo = '000002', Err_Mensaj = 'La Moneda no existe', Err_Variab = 'Dem_Moneda'
	rollback
	return 1
end else if exists (select Dem_Denomi
					from SODENMON
					where Dem_Moneda = @Dem_Moneda and Dem_Denomi = @Dem_Denomi) begin
	select Err_Codigo = '000003', Err_Mensaj = 'La denominacion ya existe', Err_Variab = 'Dem_Denomi'
	rollback
	return 1
end else if @Dem_Descri = '' begin
	select Err_Codigo = '000004', Err_Mensaj = 'Descripcion incorrecta', Err_Variab = 'Dem_Descri'
	rollback
	return 1	
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Agregado'
	insert into SODENMON values (@Dem_Moneda, @Dem_Denomi, @Dem_Descri,@NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)
end
