create procedure SOCIULOCCON (
	@Cil_Numero	char(3),
	@Cil_Ciudad	char(3),
	@Cil_Estado	char(2),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin		/* Consulta por ciudad y estado */
		select	Cil_Estado,	Cil_Ciudad,	
				Cil_Locali	= max(Cil_Locali),
				Loc_Nombre	= max(Loc_Nombre),
				Cil_Numero	= max(Cil_Numero)
			from SOCIULOC noholdlock,
				 CLLOCALI noholdlock
			where	Cil_Locali	= Loc_Numero
			  and	Cil_Ciudad	= @Cil_Ciudad
			  and	Cil_Estado	= @Cil_Estado
			group by Cil_Estado, Cil_Ciudad
	end
	if @Tip_ConCon = '2' begin		/* Consulta sucursal */
		select	Cil_Numero,	Cil_Ciudad,	Cil_Estado,	Cil_Locali,	Loc_Nombre
			from SOCIULOC noholdlock,
				 CLLOCALI noholdlock
			where	Cil_Locali	= Loc_Numero
			  and	Cil_Numero	= @Cil_Numero
	end
end
