create procedure SOUSUSUCMOD (
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
	@Modulo		char(2) )

as

/****************************************************************************/
/* DESCRIPCION:	Modificación de relación de usuarios con sucursales			*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Creo:		Fernando Del Angel Sánchez								  ****
** Fecha:		28/Mayo/2013											  ****
** Descripción:	Store de Modificación de rel. de usuarios con sucursales  ****
** Help Desk:	539205													  ****
******************************************************************************/

update SOUSUSUC set 
	Usl_Usuari	= @Usl_Usuari,
	Usl_Sucurs	= @Usl_Sucurs,
	Usl_Activo	= @Usl_Activo,
	Usl_FecIna	= @Usl_FecIna,

	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Usl_Numero	= @Usl_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Actualizado'
