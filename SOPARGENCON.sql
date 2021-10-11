create procedure SOPARGENCON (
	@Par_Consec	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************/
/* DESCRIPCIÓN: Consulta de parámetros generales						   */
/***************************************************************************/ 

/* REFERENCIAS:
****************************************************************************
** Creó: Mariel Morfín													****
** Fecha: 30/septiembre/2021											****
** HelpDesk: 1568050													****
****************************************************************************/

declare	@Tip_ConTip	char(1),	/* Declaración de variables */
		@Tip_ConCon	char(1)
								
declare	@Tip_ConInd	char(1),	/* Declaración de constantes */
		@Tip_ConUno	char(1),
		@Ent_Uno	int,
		@Ent_Dos	int

/* Asignación de constantes */
select	@Tip_ConInd	= 'C',		/* Tipo Consulta Individual*/
		@Tip_ConUno	= '1',		/* Tipo Consulta Uno */
		@Ent_Uno	= 1,		/* Entero Uno */
		@Ent_Dos	= 2			/* Entero Dos */
										
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)
		
if @Tip_ConTip = @Tip_ConInd begin
	if @Tip_ConCon = @Tip_ConUno begin
		select	Par_Valor
			from SOPARGEN noholdlock
			where	Par_Consec	= @Par_Consec
	end
end