create procedure SODIAINHMOD (
	@Din_Pais	char(3),
	@Din_Fecha	smalldatetime,
	@Din_Descri	char(20),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

select	@FechaSis = getdate()

/* Validación de la Existencia del País */
if not exists (select	Pai_Numero
				from SOPAIS noholdlock
				where	Pai_Numero	=	@Din_Pais)		begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Este País <NO> existe en el Catálogo de Países',
			Err_Variab	= ''
	rollback
	return 1
end

/* Validar si la Fecha para ese País <YA> Existe */
if not exists (select	Din_Pais
			from SODIAINH noholdlock
			where	Din_Pais	= @Din_Pais
			  and	Din_Fecha	= @Din_Fecha) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Este Día Inhábil <NO> existe para ese País',
			Err_Variab	= ''
	rollback
	return 1
end


/* Modifica el Día Inhábil */
update SODIAINH set 
	Din_Descri	= @Din_Descri,

	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Din_Pais	= @Din_Pais
	  and	Din_Fecha	= @Din_Fecha

select 	Err_Codigo = '000000', 
		Err_Mensaj  = 'Registro Modificado'
