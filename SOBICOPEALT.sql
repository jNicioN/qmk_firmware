create procedure SOBICOPEALT (
	@PerPersoID	int,
	@Bcp_TipCor 	int,
	@ClClientID		int,	
	@Bcp_Correo		varchar(100), 
	@Bcp_Status		char(1),
	@Bcp_FecCam		smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Alta Bitacora de Correos de Persona				****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		03-05-2017									****
** Help:		00946339										****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1					/* Entero en uno */

/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersoID.',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno

end

if @Bcp_TipCor = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Bcp_TipCor',
			Err_Variab	= '@Bcp_TipCor'
	rollback
	return @Ent_Uno

end


if isnull(@Bcp_FecCam, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error con el parámetro: @Bcp_FecCam.',
			Err_Variab	= '@Bcp_FecCam'
	rollback
	return @Ent_Uno

end

/* Alta Bitacora de Correos de Persona */
insert into SOBICOPE values(
	@PerPersoID,		@Bcp_TipCor,	@ClClientID,	@Bcp_Correo,	@Bcp_Status,	@Bcp_FecCam, 	
	@NumTransac,		@Transaccio,		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
