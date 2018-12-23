create procedure SONIVELECON (
	@Niv_Numero	char(2),
	@Niv_Descri	varchar(30),
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

if @Tip_Consul = '' begin	/* Cliente:  FoxPro */
	if @Niv_Descri = '' and @Niv_Numero = ''
		select	Niv_Numero,	Niv_Descri,	Niv_Acceso
			from SONIVELE noholdlock
			order by	Niv_Descri
	else if @Niv_Descri = ''
		select	Niv_Numero,	Niv_Descri,	Niv_Acceso
			from SONIVELE noholdlock
			where	Niv_Numero	= @Niv_Numero
	else
		select	Niv_Numero,	Niv_Descri,	Niv_Acceso
			from SONIVELE noholdlock
			where	Niv_Descri	like @Niv_Descri + '%'
			order by	Niv_Descri
end else begin			/* Cliente:  Visual Basic */
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta General */
			select	Niv_Numero,	Niv_Descri,	Niv_Acceso
				from SONIVELE noholdlock
				where	Niv_Numero	= @Niv_Numero
		end
	end else begin					/* 'L':  Lista */
		select	@Niv_Descri	= ltrim(rtrim(@Niv_Descri)) + '%'
		
		if @Tip_ConCon = '1' begin				/* Lista General */
			select	Niv_Numero,	Niv_Descri
				from SONIVELE noholdlock
				where	Niv_Descri	like @Niv_Descri
				order by	Niv_Descri
		end
	end
end
