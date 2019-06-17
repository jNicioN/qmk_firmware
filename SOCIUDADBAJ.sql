create procedure SOCIUDADBAJ	(
	@Ciu_Numero	char(3),
	@Ciu_Estado	char(2),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Lim_EdoSuc char(2),
		@Lim_CiuSuc char(3),
		@Tab_Nombre char(8)

select	@Tab_Nombre = 'SOCIUDAD'
	
select	@Lim_EdoSuc = substring(Par_TranBR,3,2),
		@Lim_CiuSuc = substring(Par_TranBR,5,3)
from	SOPARAMS noholdlock
where	Par_Sucurs = @SucOrigen

if not exists (	select Ciu_Numero
				from SOCIUDAD
				where Ciu_Numero = @Ciu_Numero and Ciu_Estado = @Ciu_Estado) begin
	select Err_Codigo = '000001', Err_Mensaj = 'La ciudad no existe', Err_Variab = 'Ciu_Numero'
	rollback
	return 1
end else begin
	select Err_Codigo = '000000', Err_Mensaj = 'Registro Borrado'
	delete	SOCIUDAD 
		where	Ciu_Numero=@Ciu_Numero 
		and		Ciu_Estado=@Ciu_Estado
	
	exec SYTABLOCACT	@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,
						@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
		
	delete	SOLIMSBC
		where	Lim_EdoSuc = @Lim_EdoSuc 
		and		Lim_CiuSuc = @Lim_CiuSuc 
		and		Lim_EdoSbc = @Ciu_Estado 
		and		Lim_CiuSbc = @Ciu_Numero
end
