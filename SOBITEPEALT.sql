create procedure SOBITEPEALT (
	@PerPersoID	int,
	@Btp_TipTel		int, 
	@ClClientID	 	int,	
	@Btp_Lada		int, 
	@Btp_Telefo		bigint,
	@Btp_FecCam		smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Alta Bitacora de Telefonos de Personas					****
****************************************************************************
** Modifico:	Daniel Bautista Gomez									****
** Fecha:		15-03-2018												****
** Help:		1090212													****
** Descripción: Se quita uso de Btp_Status por nueva estructura de tabla****
****************************************************************************
** Modifico:		Norma Tijerina										****
** Fecha:		16-05-2017												****
** Help:		00946339												****
** Descripción: Se cambia tipo de dato de telefono						****
****************************************************************************
** Creó:			Norma Tijerina										****
** Fecha:		04-05-2017												****
** Help:		00946339												****
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

if @Btp_TipTel = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Btp_TipTel.',
			Err_Variab	= '@Btp_TipTel'
	rollback
	return @Ent_Uno

end

if isnull(@Btp_FecCam, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error con el parámetro: @Btp_FecCam.',
			Err_Variab	= '@Btp_FecCam'
	rollback
	return @Ent_Uno

end



/* Alta de Bitacora de Telefonos de Personas	 */
insert into SOBITEPE values(
	@PerPersoID,		@Btp_TipTel,		@ClClientID,		@Btp_Lada,			@Btp_Telefo,
	@Btp_FecCam, 		@NumTransac,		@Transaccio,		@Usuario,			@FechaSis,			
	@SucOrigen,			@SucDestino)
