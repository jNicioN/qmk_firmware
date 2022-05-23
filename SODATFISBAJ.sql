create procedure SODATFISBAJ (
	@PerPersoID	    int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**
****************************************************************************
** DESCRIPCION: ** Baja en la tabla SODATFIS por PerPersoID ****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		José Antonio Mandujano Salgado							****
** Fecha:		03/05/2022   											****
** Help Desk:	1621179	 									 			****
****************************************************************************
**/

/*Declaración Constantes*/
declare	@Ent_Cero   int,        /* Entero en Cero */
		@Ent_Uno	int			/* Entero uno     */

/*Asignación Constantes*/
select	@Ent_Cero   = 0,		/* Entero en Cero	*/
		@Ent_Uno	= 1			/* Entero uno		*/

if isnull(@PerPersoID, @Ent_Cero) = @Ent_Cero begin 
	select	Err_Codigo	= '000001', 	
			Err_Mensaj	= 'El Id de la persona  no puede ser cero/null',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno
end 

delete from SODATFIS
where  PerPersoID  = @PerPersoID
     
if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Eliminado'
	
