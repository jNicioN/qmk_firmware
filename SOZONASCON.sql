create procedure SOZONASCON  (
	@Zon_Numero	char(2),
	@Zon_Descri	varchar(35),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaracion de Variables */
declare @Tip_ConTip char(1),
		@Tip_ConCon char(1)

select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = 'C' begin  		/* 'C' = Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta de llave Principal */
		select Zon_Numero, Zon_Descri,	Zon_IVA,	Zon_RetIVA
			from SOZONAS noholdlock
			where	Zon_Numero	= @Zon_Numero
	end
end else begin						/* 'L' = Lista */
	if @Tip_ConCon = '1' begin				/* Lista por Fecha */
		select	@Zon_Descri	= '%' + @Zon_Descri + '%'
		
		select Zon_Numero, Zon_Descri,	Zon_IVA,	Zon_RetIVA
			from SOZONAS noholdlock
			where	Zon_Descri	like @Zon_Descri
	end
end
