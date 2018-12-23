create procedure SOTELPERALT (
	@PerPersoID		int,
	@Tep_TipTel		int, 
	@ClClientID		int,	
	@Tep_Lada		int, 
	@Tep_Telefo		bigint,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Telefonos de Personas									****
****************************************************************************
** Midificó:	Daniel Bautista Gomez									****
** Fecha:		08-03-2018												****
** Help:		01090212												****
** Descipcion : Se quita uso del campo Tep_Status en SOTELPER			****
****************************************************************************
** Modifico:		Norma Tijerina										****
** Fecha:		16-05-2017												****
** Help:		00946339												****
** Descripción: Se cambia tipo de dato de telefono						****
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
		@Ent_Uno	int,
		@Tep_Status char(1)


										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Tep_Status = 'A'				/* Estatus de Activo */	
		

/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersoID.',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno

end

if @Tep_TipTel = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Tep_TipTel.',
			Err_Variab	= '@Tep_TipTel'
	rollback
	return @Ent_Uno

end

if @Tep_Lada = @Ent_Cero begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Tep_Lada.',
			Err_Variab	= '@Tep_Lada'
	rollback
	return @Ent_Uno

end


if @Tep_Telefo = @Ent_Cero begin

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error con el parámetro: @Tep_Telefo.',
			Err_Variab	= '@Tep_Telefo'
	rollback
	return @Ent_Uno

end



/* Alta de Telefonos de Personas	 */
insert into SOTELPER values(
	@PerPersoID,		@Tep_TipTel,		@ClClientID,		@Tep_Lada,			@Tep_Telefo,		
	@NumTransac,		@Transaccio,		@Usuario,			@FechaSis,			@SucOrigen,			
	@SucDestino)
