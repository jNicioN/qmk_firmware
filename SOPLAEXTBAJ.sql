create procedure SOPLAEXTBAJ (
	@Pla_Banco	char(4),
	@Pla_Numero	char(3),

	@NumTransac char(10), 
	@Transaccio char(3), 
	@Usuario 	char(6), 
	@FechaSis 	smalldatetime, 
	@SucOrigen 	char(3), 
	@SucDestino char(3), 
	@Modulo 	char(2))

as

if not exists (select	Pla_Numero
				from SOPLAEXT noholdlock
				where	Pla_Numero	= @Pla_Numero
				  and	Pla_Banco	= @Pla_Banco) begin
	select 	Err_Codigo  = '000001', 
			Err_Mensaj	= 'La plaza no Existe', 
			Err_Variab  = 'Pla_Numero'
	rollback
end

delete from SOPLAEXT 
	where 	Pla_Numero 	= @Pla_Numero
	  and 	Pla_Banco 	= @Pla_Banco 

select 	Err_Codigo  = '000000', 
		Err_Mensaj	= 'Registro Borrado'

