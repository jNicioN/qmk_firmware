create procedure SOPARCATCON (
	@Pac_Numero	int,
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
** Descripción:	 Consulta a parametros de cliente preferentes	****
****************************************************************************
** Creó:		Pedro A. Perez											****
** Fecha:		02-08-2021												****
** Help:		1444409													****
****************************************************************************/

										/* Declaración de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

										/* Declaración de constantes */
declare	@Con_Consul	char(1),
		@Con_Listas	char(1),
		@Tip_ConUno	char(1)

										/* Asignación de constantes */
select  @Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Tip_ConUno	= '1'				/* Por llave principal */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a parametros de cliente prefenrente */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */

	if @Tip_ConCon = @Tip_ConUno begin	/* Consulta por llave principal */

		select	Pac_Numero,	Pac_Parame,	Pac_Catego, Pac_Cantid
			from SOPARCAT noholdlock
			where	Pac_Numero	= @Pac_Numero

	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */

	if @Tip_ConCon = @Tip_ConUno begin	/* Lista de todos los datos */

		select	Pac_Numero,	Pac_Parame,	Pac_Catego, Pac_Cantid
			from SOPARCAT noholdlock

	end

end
