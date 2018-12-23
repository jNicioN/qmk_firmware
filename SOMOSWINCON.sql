create procedure SOMOSWINCON (
	@Mon_Numero char(3),
	@Mon_AbrISO	char(3),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCIÓN:	Consulta para obtener el numero de Moneda				****
***************************************************************************/

/* REFERENCIAS	************************************************************
****************************************************************************
** Modificó:	Rolando J. Bernal González								****
** Fecha:		11/Abril/2012											****
** Descripción:	Correción palabra NOHOLDLOCK							****
** Help			00455984												****
****************************************************************************
** Creó:		Gerardo Elizondo     									****
** Fecha:		11/May/10												****
** Help:		258191													****
***************************************************************************/	

declare @Tip_ConTip char(1), 	/* Declaracion de Variables */
		@Tip_ConCon char(1)

select 	@Tip_ConTip = substring(@Tip_Consul, 1, 1),
		@Tip_ConCon = substring(@Tip_Consul, 2, 1)


if @Tip_ConTip = 'C' begin  		/* 'C' = Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta por Abreviacion ISO 4217 */
		select 	Mon_Numero
			from SOMONEDA noholdlock
			where	Mon_AbrISO	= @Mon_AbrISO
	end	
end
