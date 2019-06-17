create procedure SOESTRUCBAJ (
	@Est_Numero	char(8),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @UsuNumero char(6)		/* Declaracion de Variables */ 

if exists (select	Est_Numero
				from SOESTRUC noholdlock
				where	Est_Depend	= @Est_Numero) begin
	if @@nestlevel = 1	begin		
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Tiene Dependientes',
				Err_Variab	= 'Est_Numero'
	end
	rollback
	return 1
end

select @UsuNumero = Est_Usuari
  from SOESTRUC noholdlock
 where Est_Numero	= @Est_Numero
 
If @UsuNumero = @Usuario begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'No Puede Eliminarse a si Mismo'
	rollback
	return 1
end

delete from SOESTRUC
	where	Est_Numero	= @Est_Numero
	
select	Err_Codigo = '000000', 
		Err_Mensaj = 'Registro Borrado'

