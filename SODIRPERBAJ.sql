create procedure SODIRPERBAJ (
	@PerPersoID int,
	@Dip_TipDir	int,
	@ClClientID	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	 Baja de Direcciones Persona					        ****
****************************************************************************
** Modifico:		Alberto Pineda										****
** Fecha:			15-07-2022											****
** Help:			TRACL-5312												****
** Descripcion: 	Se agregan mas caracteres al campo Bdp_Calle        ****
                    De 40 se pasa a 60                          		****
****************************************************************************
** Modifico:	Martin Moreno											****
** Fecha:		15-05-2017												****
** Help:		00979131												****
** Descripcion: Se agrega en condicion PerPersoID y Dip_TipDir 			****
** para la baja.														****	
****************************************************************************
** Modifico:	Norma Tijerina											****
** Fecha:		05-05-2017												****
** Help:		00946339												****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		17-03-2017												****
** Help:		00909908												****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Bdp_TipDir 	int,
		@Bdp_Calle		char(60), 
		@Bdp_NumExt    	char(10),
		@Bdp_NumInt    	char(10),
		@Bdp_NumCP     	char(6),
		@Bdp_EntCa1    	varchar(255),
		@Bdp_EntCa2    	varchar(255),
		@Bdp_Refere    	varchar(255),
		@Bdp_Status		char(1),
		@Bdp_FecCam		smalldatetime,
		@Bdp_NumTra		char(10),
		@Bdp_Transa		char(3),
		@Bdp_Usuari		char(6),
		@Bdp_FecSis		smalldatetime,
		@Bdp_SucOri		char(3),
		@Bdp_SucDes		char(3), 
		@Bdp_Modulo		char(2)

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Dip_Status char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Dip_Status = 'B'				/* Status Baja */

/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersoID.',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno

end

if @ClClientID = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @ClClientID.',
			Err_Variab	= '@ClClientID'
	rollback
	return @Ent_Uno

end

if @Dip_TipDir = @Ent_Cero begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Dip_TipDir.',
			Err_Variab	= '@Dip_TipDir'
	rollback
	return @Ent_Uno

end


select 
	@Bdp_TipDir 	= Dip_TipDir,
	@Bdp_Calle		= Dip_Calle, 
	@Bdp_NumExt    	= Dip_NumExt,
	@Bdp_NumInt    	= Dip_NumInt,
	@Bdp_NumCP     	= Dip_NumCP,
	@Bdp_EntCa1    	= Dip_EntCa1,
	@Bdp_EntCa2    	= Dip_EntCa2,
	@Bdp_Refere    	= Dip_Refere,
	@Bdp_Status		= Dip_Status,
	@Bdp_FecCam		= @FechaSis,
	@Bdp_NumTra		= NumTransac,
	@Bdp_Transa		= Transaccio,
	@Bdp_Usuari		= Usuario,
	@Bdp_FecSis		= FechaSis,
	@Bdp_SucOri		= SucOrigen,
	@Bdp_SucDes		= SucDestino,
	@Bdp_Modulo		= @Modulo	
	from SODIRPER noholdlock 
	where PerPersoID	= @PerPersoID
		and Dip_TipDir	= @Dip_TipDir
		and ClClientID	= @ClClientID
		and Dip_Status  <> @Dip_Status

if isnull(@Bdp_TipDir, @Ent_Cero) = @Ent_Cero begin
	return 1
end

/*Agregamos a registro a la bitacora de Direcciones de Persona*/
exec @Status = 	SOBIDIPEALT 	
	@PerPersoID, 	@Bdp_TipDir,	 @ClClientID, 	@Bdp_Calle, 	 @Bdp_NumExt,	
	@Bdp_NumInt, 	@Bdp_NumCP, 	@Bdp_EntCa1,	 @Bdp_EntCa2, 	@Bdp_Refere,	 
	@Bdp_Status,	@Bdp_FecCam, 	@Bdp_NumTra, 	@Bdp_Transa, 	@Bdp_Usuari,
	@Bdp_FecSis, 	@Bdp_SucOri, 	@Bdp_SucDes, @Bdp_Modulo
	

if @Status <> @Ent_Cero begin
		rollback
		return 1
end

/* Baja de Direccion */
update SODIRPER set
	Dip_Status  = @Dip_Status,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	ClClientID	= @ClClientID
	  and  	PerPersoID	= @PerPersoID
	  and 	Dip_TipDir	= @Dip_TipDir