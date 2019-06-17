create procedure SOBIDIPECON (
	@PerPersoID		int,
	@Bdp_TipDir		int,
	@ClClientID		int,		
	@Bdp_FecCam		smalldatetime,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Consulta de Bitacora de Direcciones de Persona					****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		05-05-2017									****
** Help:		00946339										****
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
		@Por_LlaPri	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Por_LlaPri	= '1'				/* Por llave principal */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a Catalogo de Tipo de Telefono */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Consulta por llave principal */

		select	PerPersoID, Bdp_TipDir, ClClientID,	Bdp_Calle, Bdp_NumExt,	Bdp_NumInt,	Bdp_NumCP, /*Consulta de Direcciones por persona, tipo de direccion y fecha*/
				Bdp_EntCa1,	 Bdp_EntCa2, Bdp_Refere, Bdp_Status, Bdp_FecCam
			from SOBIDIPE noholdlock
			where	PerPersoID	= @PerPersoID
			  and	Bdp_TipDir	= @Bdp_TipDir
			  and 	ClClientID  = @ClClientID
			  and	Bdp_FecCam	= @Bdp_FecCam
			  

	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Lista por llave principal */

		select	PerPersoID, Bdp_TipDir, ClClientID, Bdp_Calle, Bdp_NumExt,	Bdp_NumInt,	Bdp_NumCP, 
				Bdp_EntCa1,	 Bdp_EntCa2, Bdp_Refere, Bdp_Status, Bdp_FecCam
			from SOBIDIPE noholdlock

	end

end
