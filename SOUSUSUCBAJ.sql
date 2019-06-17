create procedure SOUSUSUCBAJ (
	@Usl_Numero	int,
	@Usl_Usuari	char(6),
	@Usl_Sucurs	char(3),
	@Usl_Activo	char(1),
	@Usl_FecIna	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/* DESCRIPCION:	Baja de relación de usuarios con sucursales					*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Creo:		Fernando Del Angel Sánchez								  ****
** Fecha:		28/Mayo/2013											  ****
** Descripción:	Store de Baja de rel. de usuario con sucursales			  ****
** Help Desk:	539205													  ****
******************************************************************************/

delete from SOUSUSUC
	where	Usl_Numero	= @Usl_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Eliminado'
