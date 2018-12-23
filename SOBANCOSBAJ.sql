create procedure SOBANCOSBAJ	(
	@Ban_Numero	char(3),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Ban_EdoSuc char(2),
		@Ban_CiuSuc char(3),
		@Tab_Nombre char(8)

select	@Tab_Nombre = 'SOBANCOS'
	
select	@Ban_EdoSuc = substring(Par_TranBR,3,2),
		@Ban_CiuSuc = substring(Par_TranBR,5,3)
from	SOPARAMS noholdlock
where	Par_Sucurs = @SucOrigen

if not exists ( select Ban_Numero
				from SOBANCOS
				where Ban_Numero = @Ban_Numero) begin
	select Err_Codigo = '000001', Err_Mensaj = 'Numero no existe', Err_Variab = 'Ban_Numero'
	rollback
	return 1
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Borrado'
	delete	from SOBANCOS
		where	Ban_Numero = @Ban_Numero
	delete	SOBANSBC
		where	Ban_EdoSuc = @Ban_EdoSuc 
		and		Ban_CiuSuc = @Ban_CiuSuc 
		and		Ban_Numero = @Ban_Numero
	
	exec SYTABLOCACT	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,
						@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
end
