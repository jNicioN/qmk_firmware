create procedure SOTELPERCON (
	@PerPersoID int,
	@Tep_TipTel	 int,
	@ClClientID	 int,
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
** Descripción:	 Consulta a Telefonos de Persona						****
****************************************************************************
** Modificó:	Gio Asencio												****
** Fecha:		03-09-2018												****
** Help:		01134946												****
** Descipcion:	Se agrega el tipo de consulta L4 para CRM SF	 		****
****************************************************************************
** Modificó:	Gio Asencio												****
** Fecha:		18-07-2018												****
** Help:		01134946												****
** Descipcion:	Se agrega el tipo de consulta L3 para CRM SF	 		****
****************************************************************************
** Midificó:	Daniel Bautista Gomez									****
** Fecha:		08-03-2018												****
** Help:		01090212												****
** Descipcion : Se quita validación del campo Tep_Status en todas 		****
				las consultas											****
****************************************************************************
** Creó:		Roberto Carlos Saldivar									****
** Fecha:		04-05-2017												****
** Help:		00982757												****
** Descipcion : Se agrega el tipo de consulta L2						****
****************************************************************************
** Creó:		Norma Tijerina											****
** Fecha:		04-05-2017												****
** Help:		00946339												****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Con_Consul	char(1),
		@Con_Listas	char(1),
		@Por_LlaPri	char(1),
		@Str_Dos	char(1),
		@Str_A		char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Por_LlaPri	= '1',				/* Por llave principal */
		@Str_Dos	= '2',
		@Str_A		= 'A'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a Catalogo de Tipo de Direccion */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */
	if @Tip_ConCon = @Por_LlaPri begin	/* Consulta por llave principal */
		select	PerPersoID, Tep_TipTel, ClClientID, Tep_Lada, Tep_Telefo /*Consulta de telefonos por Tipo de Telefono y persona*/
			from SOTELPER noholdlock
			where	PerPersoID	= @PerPersoID
				and		ClClientID	= @ClClientID
				and	 	Tep_TipTel	= @Tep_TipTel
	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */
	if @Tip_ConCon = @Por_LlaPri begin	/* Lista que trae todos los registros */
		select	PerPersoID, Tep_TipTel, ClClientID, Tep_Lada, Tep_Telefo
			from SOTELPER noholdlock
	end

	if @Tip_ConCon = @Str_Dos begin	/* Lista por Id Persona */
		select		PerPersoID, Tep_TipTel, ClClientID, Tep_Lada, Tep_Telefo
			from	SOTELPER noholdlock
			where	PerPersoID  = @PerPersoID
			and		ClClientID	= @ClClientID
	end

	if @Tip_ConCon = '3' begin	/* Lista por solo Id Persona, opcional el tipo */
		select		PerPersoID, Tep_TipTel, ClClientID, Tep_Lada, Tep_Telefo
			from	SOTELPER noholdlock
			where	PerPersoID	= @PerPersoID
			and (@Tep_TipTel=0 OR Tep_TipTel=@Tep_TipTel)
	end

	if @Tip_ConCon = '4' begin	/* Lista por solo Id Cliente, opcional el tipo */
		select		PerPersoID, Tep_TipTel, ClClientID, Tep_Lada, Tep_Telefo
			from	SOTELPER noholdlock
			where	ClClientID	= @ClClientID
			and (@Tep_TipTel=0 OR Tep_TipTel=@Tep_TipTel)
	end
end
