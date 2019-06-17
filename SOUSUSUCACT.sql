create procedure SOUSUSUCACT (
	@Usl_Numero  int,
	@Usl_Usuari  char(6),
	@Usl_Sucurs  char(3),
	@Usl_Activo  char(1),
	@Usl_FecIna  smalldatetime,
	@Tip_Actual	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************/
/* DESCRIPCION:	Actualización de relación de usuarios con sucursales		*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Creo:		Fernando Del Angel Sánchez								  ****
** Fecha:		28/Mayo/2013											  ****
** Descripción:	Store de Actualización de rel. de usuario con sucursales  ****
** Help Desk:	539205													  ****
******************************************************************************/
declare	@Status	int			/* Declaracion de Variables */

declare	@Ent_Cero	int,	/* Declaracion de constanstes */
		@Gru_Status	char(1),
		@Act_Estatu	char(2)

select	@Ent_Cero	= 0,
		@Gru_Status	= 'I',
		@Act_Estatu	= 'C1'

if @Tip_Actual	= @Act_Estatu begin
	update SOUSUSUC set
		Usl_Activo	= @Usl_Activo,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usl_Numero	= @Usl_Numero
end

if	@@nestlevel	= 1 begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Modificado'
end
