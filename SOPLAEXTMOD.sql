create procedure SOPLAEXTMOD (
	@Pla_Banco  char(4),
	@Pla_Numero char(3),
	@Pla_Descri varchar(30),
	@Pla_Ubicac varchar(50),
	@Pla_Contac	varchar(30),
	@Pla_NumTel	varchar(20),
	@Pla_Fax	varchar(20),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))
as

if not exists(select  Ban_NumSis 
				from SOBANCOS noholdlock
				where	Ban_NumSis	= @Pla_Banco) begin
	select 	Err_Codigo	= '000001', 
			Err_Mensaj	= 'El Banco no existe', 
			Err_Variab	= 'Pla_Banco'
	rollback 
	return 1
end 

if not exists (select	Pla_Numero
				from SOPLAEXT noholdlock
				where	Pla_Numero	= @Pla_Numero
				  and	Pla_Banco	= @Pla_Banco) begin
	select 	Err_Codigo 	= '000002', 
			Err_Mensaj	= 'La plaza no existe', 
			Err_Variab 	= 'Pla_Numero'
	rollback
	return 1	
end 

update SOPLAEXT	set
	Pla_Descri	= @Pla_Descri,	
	Pla_Ubicac	= @Pla_Ubicac,	
	Pla_Contac	= @Pla_Contac,	
	Pla_NumTel	= @Pla_NumTel,	
	Pla_Fax   	= @Pla_Fax
	where 	Pla_Numero	= @Pla_Numero
	  and	Pla_Banco 	= @Pla_Banco

select 	Err_Codigo 	= '000000', 
		Err_Mensaj	= 'Registro Modificado'
