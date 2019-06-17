create procedure SOREPEPEALT (
	@Rpp_Person	char(8),
	@Rpp_PerRel	char(8),
	@Rpp_TiPeRe	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Mod_BanEle	char(2)			/* Declaracion de Constantes */
		
				
/* Asignacion de Constantes */		
select	@Mod_BanEle	= 'BE'			/* Modulo de Banca Electronica */
		
		
if @Modulo <> @Mod_BanEle begin
	if not exists ( select	Per_Numero
						from SOPERSON noholdlock
						where	Per_Numero	= @Rpp_Person	) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La persona a la que se relaciona no existe',
				Err_Variab	= 'Rpp_Person'
		rollback
		return 1	
	end
end

if not exists ( select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Rpp_PerRel	) begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La persona a relacionar no existe',
			Err_Variab	= 'Rpp_PerRel'
	rollback
	return 1	
end

if not exists ( select	Tpe_Numero
					from SOTIPPER noholdlock
					where	Tpe_Numero	= @Rpp_TiPeRe	) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El tipo de persona no existe',
			Err_Variab	= 'Rpp_TiPeRe'
	rollback
	return 1
end

if exists ( select	Rpp_Person
				from SOREPEPE noholdlock
				where	Rpp_Person	= @Rpp_Person
				  and	Rpp_PerRel	= @Rpp_PerRel
				  and	Rpp_TiPeRe	= @Rpp_TiPeRe	) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'La relación ya existe',
			Err_Variab	= 'Rpp_Person'
	rollback
	return 1
end

insert into SOREPEPE values	(
	@Rpp_Person,	@Rpp_PerRel,	@Rpp_TiPeRe,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino	)
	
if  @Modulo= @Mod_BanEle
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado'

