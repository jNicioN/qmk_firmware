create procedure SOREPEPEMOD (
	@Rpp_Person	char(8),
	@Rpp_PerRel char(8),
	@Rpp_TiPeRe char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if not exists ( select	Rpp_Person
				from SOREPEPE noholdlock
				where	Rpp_Person	= @Rpp_Person
				  and	Rpp_PerRel	= @Rpp_PerRel
				  and	Rpp_TiPeRe	= @Rpp_TiPeRe	) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La relación No existe',
			Err_Variab	= 'Rpp_Person'
	rollback
	return 1
end

	if not exists ( select	Per_Numero
						from SOPERSON noholdlock
						where	Per_Numero	= @Rpp_Person	) begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'La persona a la que se relaciona no existe',
				Err_Variab	= 'Rpp_Person'
		rollback
		return 1	
	end

	if not exists ( select	Per_Numero
						from SOPERSON noholdlock
						where	Per_Numero	= @Rpp_PerRel	) begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'La persona a relacionar no existe',
				Err_Variab	= 'Rpp_PerRel'
		rollback
		return 1	
	end

if not exists ( select	Tpe_Numero
					from SOTIPPER noholdlock
					where	Tpe_Numero	= @Rpp_TiPeRe	) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'El tipo de persona no existe',
			Err_Variab	= 'Rpp_TiPeRe'
	rollback
	return 1
end

update SOREPEPE set
	Rpp_PerRel	= @Rpp_PerRel,
	Rpp_TiPeRe	= @Rpp_TiPeRe,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Rpp_Person	= @Rpp_Person

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro modificado '
