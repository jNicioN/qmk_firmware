create procedure SOULHESPACT (
	@Uhs_Fecha	smalldatetime,
	@Uhs_Moneda	char(2),
	@Uhs_Valor	double precision,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Status	int		/* Declaración de variables */

if exists(select	Uhs_Valor
			from SOULHESP noholdlock
				where	Uhs_Moneda	= @Uhs_Moneda) begin
	update SOULHESP set
		Uhs_Fecha	= @Uhs_Fecha,
		Uhs_Valor	= @Uhs_Valor
		where	Uhs_Moneda	= @Uhs_Moneda
			
end else begin
	exec @Status = SOULHESPALT
		@Uhs_Fecha,	@Uhs_Moneda,	@Uhs_Valor,	@NumTransac,	@Transaccio,
		@Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

end
