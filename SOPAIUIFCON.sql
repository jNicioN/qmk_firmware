create procedure SOPAIUIFCON (
	@Pau_Clave	char(2),
	@Pau_Descri	char(50),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
** Consulta de Paises provisto por la UIF								****
****************************************************************************
*/

/*
****************************************************************************
** Creó:		Wilfrido Ortiz Prieto									****
** Fecha:		16/Mayo/2014											****
** HelpDesk:	00649315												****
****************************************************************************
*/

declare @Tip_ConTip char(1),				/* Declaración de Variables */
		@Tip_ConCon char(1)

select 	@Tip_ConTip = substring(@Tip_Consul, 1, 1),
		@Tip_ConCon = substring(@Tip_Consul, 2, 1)

if	@Tip_ConTip = 'C' begin  	/* 'C' = Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta General */
		select	Pau_ID, Pau_Clave, Pau_Descri, Pau_ClaSib, Pau_ClSiSo
			from SOPAIUIF noholdlock
			where	Pau_Clave	= @Pau_Clave
	end
end else begin					/* 'L' = Lista */
	select	@Pau_Descri	= rtrim(ltrim(@Pau_Descri)) + '%'

	if @Tip_ConCon = '1' begin				/* Lista General */
		select	Pau_ID, Pau_Clave, Pau_Descri, Pau_ClaSib, Pau_ClSiSo
			from SOPAIUIF noholdlock
			where 	Pau_Descri	like @Pau_Descri
			order by Pau_Descri
	end
end
