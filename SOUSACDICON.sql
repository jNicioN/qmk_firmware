create procedure SOUSACDICON (
	@Uad_Numero	int,
	@Uad_Usuari	char(6),
	@Uad_Pantal	int,
	@Uad_Indice	int,
	@Uad_IndAnt	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************/
/* DESCRIPCION: ** Consulta de la tabla acceso directo (SOUSACDI)** 		*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Modificó:		Evijair Núñez Jordán									**
** Fecha:			21/06/2013												**
** Modificación:	Creación del store procedure.							**
*****************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1),
		@Uad_Inicio	int,
		@Uad_Fin	int

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',		/* String Vacío */
		@Tra_TipLis	= 'L',		/* Tipo : Lista */
		@Tra_TipCon	= 'C',		/* Tipo : Consulta */
		@Str_Uno	= '1',		/* String para consulta 1 */
		@Str_Dos	= '2',		/* String para consulta 2 */
		@Str_Tres	= '3'		/* String para consultar por rango de indices */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= @Tra_TipCon begin		/* 'C':  Consulta */

	if @Tip_ConCon	= @Str_Uno begin		/* Consulta General */
		select	Uad_Numero, Uad_Usuari, Uad_Pantal
			from SOUSACDI noholdlock
			where	Uad_Numero	= @Uad_Numero
	end

end else if @Tip_ConTip	= @Tra_TipLis begin		/* 'L':  Lista */
	
	if @Tip_ConCon	= @Str_Uno begin		/* Lista General */	
		select	Uad_Numero, Uad_Usuari, Uad_Pantal, Uad_Indice
			from SOUSACDI noholdlock
	end

	if @Tip_ConCon	= @Str_Dos begin		/* Lista General por Usuario*/
		select	Uad_Numero, Uad_Usuari, Uad_Pantal, Uad_Indice
			from SOUSACDI Uad noholdlock
			where	Uad_Usuari = @Uad_Usuari
			order by Uad_Indice
	end
	
	if @Tip_ConCon	= @Str_Tres begin		/* Lista General rango de indices */
		if @Uad_Indice	> @Uad_IndAnt begin
			select	@Uad_Inicio	= @Uad_IndAnt,
					@Uad_Fin	= @Uad_Indice
		end else begin
			select	@Uad_Inicio	= @Uad_Indice,
					@Uad_Fin	= @Uad_IndAnt
		end
		select	Uad_Numero, Uad_Usuari, Uad_Pantal, Uad_Indice
			from SOUSACDI Uad noholdlock
			where	Uad_Indice between @Uad_Inicio and @Uad_Fin
	end
end
