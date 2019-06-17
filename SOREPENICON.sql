create procedure SOREPENICON (
	@Rel_Numero	char(5),
	@Rel_Perfil	char(3),
	@Rel_Nivel	char(2),
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
** Descripción:	** Consulta a Relacion Perfil Nivel **				****
****************************************************************************
** 					STORE CONVERTIDO					****
** Fecha:		24-08-2015									****
** Convirtío:		David Cantu				****
****************************************************************************
** Creó:			David Cantu				****
** Fecha:		24-08-2015									****
** Help:		00749260										****
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
		@Por_Report char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Por_LlaPri	= '1',				/* Por llave principal */
		@Por_Report = '2'				/* Para generar el reporte */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a Relacion Perfil Nivel */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Consulta por llave principal */

		select	Rel_Numero, Rel_Perfil, Per_Descri,
			   Rel_Nivel, Niv_Descri
			from SOREPENI noholdlock,
				 SAPERFIL noholdlock,
				 SONIVELE noholdlock
			  where	Rel_Perfil	= @Rel_Perfil
			  and	Rel_Nivel	= @Rel_Nivel			  
			  and Rel_Perfil =  Per_Numero		
			  and Rel_Nivel  =  Niv_Numero 

	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */

	if @Tip_ConCon = @Por_LlaPri begin	/* Lista por llave principal */

		select	Rel_Numero, Rel_Perfil, Per_Descri,
			   Rel_Nivel, Niv_Descri
			from SOREPENI noholdlock,
				 SAPERFIL noholdlock,
				 SONIVELE noholdlock
			where Rel_Perfil = @Rel_Perfil	
			  and Rel_Perfil =  Per_Numero		
			  and Rel_Nivel  =  Niv_Numero 

	end else if @Tip_ConCon = @Por_Report begin
		
		select Rel_Perfil, Per_Descri,
			   Rel_Nivel, Niv_Descri
			from SOREPENI noholdlock,
				 SAPERFIL noholdlock,
				 SONIVELE noholdlock
			where Rel_Perfil =  Per_Numero
			  and Rel_Nivel  =  Niv_Numero 
			 order by Rel_Perfil
	end

end
