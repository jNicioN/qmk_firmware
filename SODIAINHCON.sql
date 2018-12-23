create procedure SODIAINHCON (
	@Din_Pais	char(3),
	@Din_Fecha	smalldatetime,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),				/* Declaración de Constantes */
		@Tip_ConCon	char(1)


/* Asignación de Constantes */
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/* 'C': Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta General de los Campos de la Tabla */
		select	Din_Pais, Din_Fecha, Din_Descri
			from SODIAINH noholdlock
			where	Din_Pais	= @Din_Pais
			  and	Din_Fecha	= @Din_Fecha
	end
end else begin								/* 'L' = Lista */
	if @Tip_ConCon = '1' begin				/* Lista General */
		select	Din_Pais, Din_Fecha, Din_Descri
			from SODIAINH noholdlock
			where	Din_Pais = @Din_Pais
	end
end
