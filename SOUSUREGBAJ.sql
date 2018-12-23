create procedure SOUSUREGBAJ (
    @Usr_Numero	int,
	@Usr_Usuari	char(6),
	@Usr_Region	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Baja de Usuario-Regiones					  */
/******************************************************************/
/* Modifica:	Jorge A. Garcia Leal							****
** Fecha:		05/12/2016										****
** Help:		931787 											****
** Modifica:	Se cambia estructura de tabla 					***/
/******************************************************************/
/* DESCRIPCION: Baja de Usuario-Regiones					  */
/******************************************************************/
/* Creo:		Claudia V Sandoval P							****
** Fecha:		04/10/2016										****
** Help:		903360 											****
********************************************************************/
/* Asignacion de Constantes */


delete from SOUSUREG 
	where	Usr_Numero = @Usr_Numero
	
if @@nestlevel = 1 begin
	select 	Err_Codigo = '000000',
			Err_Mensaj = 'La Relacion Usuario-Region ha sido eliminada'
end
