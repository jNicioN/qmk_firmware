create procedure SOREPEPEBAJ (
	@Rpp_Person	char(8),
	@Rpp_PerRel	char(8),
	@Rpp_TiPeRe	char(2),
	@Tip_Baja	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Str_Vacio	char(1),
		@Tip_FabCre	char(1)		

select @Str_Vacio 	= '',
		@Tip_FabCre	= '1'			/* Baja: Fabrica de Creditos */

if @Tip_Baja = @Str_Vacio begin
	delete SOREPEPE
		where	Rpp_Person	= @Rpp_Person
		
end else if @Tip_Baja = @Tip_FabCre begin		/* Baja para Fabrica de Creditos */
	delete SOREPEPE
		where	Rpp_Person	= @Rpp_Person
		  and	Rpp_PerRel	= @Rpp_PerRel
		  and	Rpp_TiPeRe	= @Rpp_TiPeRe
end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Borrado'

