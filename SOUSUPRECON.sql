create procedure SOUSUPRECON (
	@Upr_Numero	int,
	@Upr_Usuari	char(6),
	@Upr_Nombre	varchar(50),
	@Upr_Valor	varchar(100),
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
/* DESCRIPCION:	Consulta de las preferencias del usuario					*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Modificó:		Evijair Núñez Jordán								  ****
** Fecha:			21/06/2013											  ****
** Modificación:	Creación del store procedure.						  ****
** Help Desk:		539205												  ****
*****************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaración de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',			/* String Vacío */
		@Tra_TipLis	= 'L',			/* Tipo : Lista */
		@Tra_TipCon	= 'C',			/* Tipo : Consulta */
		@Str_Uno	= '1',			/* String para consulta 1 */
		@Str_Dos	= '2'			/* String para consulta 2 */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip	= @Tra_TipCon begin			/* 'C':  Consulta */
	if @Tip_ConCon	= @Str_Uno begin				/* Consulta General */
		select	Upr_Numero, Upr_Usuari, Upr_Nombre, Upr_Valor
			from SOUSUPRE Upr noholdlock
			where	Upr_Numero	= @Upr_Numero
	end

end else if @Tip_ConTip	= @Tra_TipLis begin			/* 'L':  Lista */
	if @Tip_ConCon	= @Str_Uno begin					/* Lista General */	
		select	Upr_Numero, Upr_Usuari, Upr_Nombre, Upr_Valor
			from SOUSUPRE Upr noholdlock
	end

	if @Tip_ConCon	= @Str_Dos begin		/* Lista General por Usuario*/
		select	Upr_Numero, Upr_Usuari, Upr_Nombre, Upr_Valor
			from SOUSUPRE Upr noholdlock
			where	Upr_Usuari	= @Upr_Usuari
	end
end
