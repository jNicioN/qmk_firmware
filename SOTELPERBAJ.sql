create procedure SOTELPERBAJ (
	@PerPersoID		int,
	@Tep_TipTel		int, 
	@ClClientID	 	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	 Baja de Telefono de Persona							****
* **************************************************************************
** Modifico:	Alberto Pineda Carbajal									****
** Fecha:		23-05-2023												****
** Help:		TRACL-4754												****
** Descipcion : Se agrega una validacion despues de la consulta en la	****
				tabla SOTELPER, ya que si no traee información y se		****
				ejecuta el SP SOBITEPEALT muestra un error 				****
****************************************************************************
** Modifico:	Daniel Bautista Gomez									****
** Fecha:		08-03-2018												****
** Help:		01090212												****
** Descipcion : Se quita validación del campo Tep_Status en SOTELPER	****
				y en SOBITEPEALT se registran parametros de control		****
				enviados en el SP										****
****************************************************************************
** Modifico:		Norma Tijerina										****
** Fecha:		16-05-2017												****
** Help:		00946339												****
** Descripción: Se cambia tipo de dato de telefono						****
****************************************************************************
** Creó:			Norma Tijerina										****
** Fecha:		05-05-2017												****
** Help:		00946339												****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Btp_TipTel		int, 
		@Btp_Lada		int, 
		@Btp_Telefo		bigint
		
										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int, 
		@Tep_StaBaj char(1)

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

if @Tep_TipTel = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Tep_TipTel.',
			Err_Variab	= '@Tep_TipTel'
	rollback
	return @Ent_Uno

end

select 
	@Btp_TipTel	= Tep_TipTel, 
	@Btp_Lada	= Tep_Lada, 
	@Btp_Telefo	= Tep_Telefo
	from SOTELPER noholdlock 
	where PerPersoID	= @PerPersoID
		and Tep_TipTel	= @Tep_TipTel
		and ClClientID	= @ClClientID

if isnull(@Btp_TipTel, @Ent_Cero) = @Ent_Cero begin
	select 	Err_Codigo 	= '000003',
			Err_Mensaj 	= 'No se encontro el valor Btp_TipTel'
	rollback
	return @Ent_Uno
end

if isnull(@Btp_Lada, @Ent_Cero) = @Ent_Cero begin
	select 	Err_Codigo 	= '000004',
			Err_Mensaj 	= 'No se encontro el valor Btp_Lada'
	rollback
	return @Ent_Uno
end

if isnull(@Btp_Telefo, @Ent_Cero) = @Ent_Cero begin
	select 	Err_Codigo 	= '000005',
			Err_Mensaj 	= 'No se encontro el valor Btp_Telefo'
	rollback
	return @Ent_Uno
end

/*Agregamos a registro a la bitacora de Telefonos de Persona*/
exec @Status = 	SOBITEPEALT 	
	@PerPersoID, 	@Btp_TipTel,	@ClClientID, 	@Btp_Lada, 		@Btp_Telefo,		
	@FechaSis,	 	@NumTransac, 	@Transaccio, 	@Usuario,		@FechaSis,
	@SucOrigen, 	@SucDestino, 	@Modulo

if @Status <> @Ent_Cero begin
		rollback
		return 1
	end

/*Baja de Telefono de Persona */
delete from SOTELPER 
	  where	PerPersoID	= @PerPersoID
		and Tep_TipTel	= @Tep_TipTel
		and ClClientID	= @ClClientID
