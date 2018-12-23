create procedure SOUNIPERALT (
	@Peu_Grupo char(8),
	@Peu_Person char(8),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/* Descripcion											****
************************************************************
**	Alta de Unificacion de Personas 					****
************************************************************
** Referencias											****
************************************************************
** Modifico:	Claudia V Sandoval P					****
** Fecha:		03/03/2014								****
** Help:		00599444								****
** Descripcion:	Se agrega opcional salida Peu_Grupo		****
************************************************************
**		STORE CONVERTIDO								****
**		Convirio: David Ruiz							****
**		Fecha:	08/10/2013								****
************************************************************
************************************************************
**	Creo:	David Ruiz									****
**	Help:	00599444									****
**	Fecha:	08-Oct-2013									****
***********************************************************/
insert into SOUNIPER values (
	@Peu_Grupo,	@Peu_Person,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,	@SucOrigen,		@SucDestino)


if @@nestlevel = 1 begin
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Agregado',
			Peu_Grupo	= @Peu_Grupo
end
