create procedure SOBIDIPEALT (
	@PerPersoID		int,
	@Bdp_TipDir 	int,
	@ClClientID		int,	
	@Bdp_Calle		char(60), 
	@Bdp_NumExt    	char(10),
	@Bdp_NumInt    	char(10),
	@Bdp_NumCP     	char(6),
	@Bdp_EntCa1    	varchar(255),
	@Bdp_EntCa2    	varchar(255),
	@Bdp_Refere    	varchar(255),
	@Bdp_Status		char(1),	
	@Bdp_FecCam		smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	 Alta Bitacora de Direcciones de Persona				****
****************************************************************************
** Modifico:		Alberto Pineda										****
** Fecha:			15-07-2022											****
** Help:			TRACL-5312											****
** Descripcion: 	Se agregan mas caracteres al campo Bdp_Calle        ****
**                  De 40 se pasa a 60, se agregan los valores a insertar****
**					En SOBIDIPE 										****
****************************************************************************
** Modifico:		Adriana Gomez										****
** Fecha:			06-05-2022											****
** Help:			1621179												****
** Descripcion: 	validacion de cliente y persona						****
****************************************************************************
** Creó:			Norma Tijerina										****
** Fecha:			05-05-2017											****
** Help:			00946339											****
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
if @PerPersoID = @Ent_Cero and @ClClientID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro:@PerPersoID o  @ClClientID.',
			Err_Variab	= '@ClClientID'
	rollback
	return @Ent_Uno

end

if @Bdp_TipDir = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Bdp_TipDir.',
			Err_Variab	= '@Bdp_TipDir'
	rollback
	return @Ent_Uno

end

if isnull(@Bdp_FecCam, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'Error con el parámetro: @Bdp_FecCam.',
			Err_Variab	= '@Bdp_FecCam'
	rollback
	return @Ent_Uno

end

/* Alta de Bitacora de Direcciones de Persona */
insert into SOBIDIPE (PerPersoID, Bdp_TipDir, ClClientID, Bdp_Calle, Bdp_NumExt, 
Bdp_NumInt, Bdp_NumCP, Bdp_EntCa1, Bdp_EntCa2, Bdp_Refere, Bdp_Status, Bdp_FecCam, NumTransac, 
Transaccio, Usuario,FechaSis, SucOrigen, SucDestino) 
values(
	@PerPersoID,		@Bdp_TipDir,	@ClClientID,	@Bdp_Calle,		@Bdp_NumExt,	@Bdp_NumInt,	@Bdp_NumCP,
	@Bdp_EntCa1,		@Bdp_EntCa2,	@Bdp_Refere,    @Bdp_Status,	@Bdp_FecCam,	@NumTransac,	@Transaccio,		
	@Usuario,			@FechaSis,		@SucOrigen,		@SucDestino)