CREATE PROCEDURE SOCORPERCON (
	@PerPersoID		int,
	@Cop_TipCor		int,
	@ClClientID		int,
	@Tip_Consul		char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	 Consulta de Correos Persona							****
*****************************************************************************
** Modificó:	Aldo Ignacio Teoba Sanchez								****
** Fecha:		14/08/2023												****
** HelpDesk:	31604													****
** Descripción:	Se agrega condición en estatus al buscar por cliente	****
*****************************************************************************
** Modificó:	Joel Barcenas											****
** Fecha:		15/02/2020												****
** HelpDesk:	1179955													****
** Descripción:	se agrega consulta por Persona 	L4						****
****************************************************************************
** Modificó:	Ezequiel Cruz											****
** Fecha:		03/08/2018											****
** HelpDesk:	001013960												****
** Descripción:	se agrega consulta por Persona y Tipo de Correo	L3		****
****************************************************************************
** Modificó:	Gio Asencio												****
** Fecha:		18-07-2018												****
** Help:		01134946												****
** Descipcion:	Se agrega el tipo de consulta L2 para CRM SF	 		****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		06-06-2017												****
** Help:		00982757												****
** Descripcion:	Se agrega C2, para consultar sin requerir estatus		****
****************************************************************************
** Creó:		Norma Tijerina											****
** Fecha:		03-05-2017												****
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
		@Str_A		char(1),
		@Por_PerTip char(1),
		@Str_Dos	char(1),
		@Str_Cuatro	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Por_LlaPri	= '1',				/* Por llave principal */
		@Str_A		= 'A',
		@Por_PerTip = '3',				/* Por Persona y Tipo de Correo */
		@Str_Dos	= '2',
		@Str_Cuatro = '4'				/*Por Persona*/


select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a Catalogo de Tipos de Correo */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */
	if @Tip_ConCon = @Por_LlaPri begin	/* Consulta por llave principal */
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo
			from SOCORPER noholdlock
			where	PerPersoID	= @PerPersoID
			and		ClClientID	= @ClClientID
			and 	Cop_TipCor 	= @Cop_TipCor
			and		Cop_Status  = @Str_A
	end

	if @Tip_ConCon = '2' begin	/* Consulta por llave principal confirmar existencia..*/
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo
			from SOCORPER noholdlock
			where	PerPersoID	= @PerPersoID
			and		ClClientID	= @ClClientID
			and 	Cop_TipCor 	= @Cop_TipCor
	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */
	if @Tip_ConCon = @Por_LlaPri begin	/* Lista que regresa todo registro activo */
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo
			from SOCORPER noholdlock
			where	Cop_Status  = @Str_A
	end

	if @Tip_ConCon = '2' begin	/* Lista por Id Cliente */
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo
			from SOCORPER noholdlock
			where	ClClientID	= @ClClientID
			and Cop_Status  = @Str_A
	end
	
	if @Tip_ConCon = @Por_PerTip begin /* Lista por Persona y Tipo de Correo */
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo  
			from SOCORPER noholdlock
			where PerPersoID = @PerPersoID
			and Cop_TipCor = @Cop_TipCor
			and Cop_Status  = @Str_A
	end
	
	if @Tip_ConCon = @Str_Cuatro begin /* Lista por Persona*/
		select	PerPersoID, Cop_TipCor, ClClientID, Cop_Correo  
			from SOCORPER noholdlock
			where PerPersoID = @PerPersoID
			and Cop_Status  = @Str_A
	end
end