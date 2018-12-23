create procedure SOPARAMSREM (
 
 @Par_FecRem smalldatetime, @NumTransac char(10), @Transaccio char(3),
 @Usuario char(6), @FechaSis smalldatetime, @SucOrigen char(3),
 @SucDestino char(3), @Modulo char(2))

as

if @Par_FecRem<'1990-01-01' begin
	select Err_Codigo = '000001', Err_Mensaj = 'Fecha incorrecta', Err_Variab = 'Par_FecRem'
	rollback 
	return 1
end else 
	update SOPARAMS set	 Par_FecRem=@Par_FecRem
	where Par_Sucurs = @SucOrigen

