create procedure SODIAFESMOD (

@Dfe_Fecha smalldatetime, @Dfe_Coment varchar(255),@NumTransac char(10), @Transaccio char(3), @Usuario char(6), @FechaSis smalldatetime, @SucOrigen char(3), @SucDestino char(3), @Modulo char(2))

as

if not exists (	select Dfe_Fecha
				from SODIAFES
				where Dfe_Fecha = @Dfe_Fecha) begin
	select Err_Codigo = '000001', Err_Mensaj = 'Fecha no existe en dias festivos', Err_Variab = 'Dfe_Fecha'
	rollback
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Modificado'
	update SODIAFES set
		Dfe_Fecha = @Dfe_Fecha, Dfe_Coment = @Dfe_Coment
	where Dfe_Fecha = @Dfe_Fecha
end
