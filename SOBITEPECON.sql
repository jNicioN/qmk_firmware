create procedure SOBITEPECON (
	@PerPersoID int,
	@Btp_TipTel	 int,
	@ClClientID	 int,	
	@Btp_FecCam	 smalldatetime, 
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
** Descripción:	 Consulta a Bitacora de Telefonos de Persona			****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		04-05-2017									****
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
		@Por_LlaPri	char(1),
		@Str_A		char(1)				

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Por_LlaPri	= '1',				/* Por llave principal */
		@Str_A		= 'A'		

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a Catalogo de Tipo de Direccion */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Consulta por llave principal */

		select	PerPersoID, Btp_TipTel, ClClientID, Btp_Lada, Btp_Telefo, Btp_FecCam /*Consulta de telefonos por Tipo de Telefono y persona y fecha*/
			from SOBITEPE noholdlock
			where	PerPersoID	= @PerPersoID
			  and	Btp_TipTel	= @Btp_TipTel
			  and 	ClClientID	= @ClClientID
			  and	Btp_FecCam	= @Btp_FecCam
			  


	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Lista por llave principal */

		select	PerPersoID, Btp_TipTel, ClClientID, Btp_Lada, Btp_Telefo, Btp_FecCam
			from SOBITEPE noholdlock

	end

end
