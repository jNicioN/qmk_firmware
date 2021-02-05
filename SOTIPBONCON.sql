create procedure SOTIPBONCON (
	@Tib_Consec int,
	@Tib_Nombre	varchar(20),
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
** Descripción:	** Consulta de Tipo de Bonos							****
****************************************************************************
** Creó:	Andrea Ramírez M											****
** Fecha:	2021-01-20													****
** Help:	1468954														****
****************************************************************************/

										/* Declaración de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Con_Consul	char(1),
		@Con_Listas	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío			*/
		@Ent_Cero	= 0,				/* Entero en cero		*/
		@Ent_Uno	= 1,				/* Entero en uno		*/
		@Con_Consul	= 'C',				/* Tipo: Consulta		*/
		@Con_Listas	= 'L',				/* Tipo: Lista			*/
		@Str_Uno	= '1',				/* Cadena: Valor uno	*/
		@Str_Dos	= '2'				/* Cadena: Valor dos	*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

/* Consulta a tipos de bonos */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */
	if @Tip_ConCon = @Str_Uno begin	/* Consulta por llave principal */
		select	Tib_Consec,	Tib_Nombre,	Tib_Descri,	Tib_Folio,	Tib_Valor
			from SOTIPBON noholdlock
			where	Tib_Consec	= @Tib_Consec
	end
	else if @Tip_ConCon = @Str_Dos begin	/* Consulta por nombre */
		select	Tib_Consec,	Tib_Nombre,	Tib_Descri,	Tib_Folio,	Tib_Valor
			from SOTIPBON noholdlock
			where	Tib_Nombre	= @Tib_Nombre
	end
end
else if @Tip_ConTip = @Con_Listas begin	/* Listas */
	if @Tip_ConCon = @Str_Uno begin	/* Lista por llave principal */
		select	Tib_Consec,	Tib_Nombre,	Tib_Descri,	Tib_Folio,	Tib_Valor
			from SOTIPBON noholdlock
	end
end