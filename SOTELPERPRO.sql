create procedure SOTELPERPRO (
	@PerPersoID		int,
	@Tep_TipTel		int, 
	@ClClientID		int,	
	@Tep_Lada		int, 
	@Tep_Telefo		bigint,
	@Tip_Proces		char(2),

	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))

as

/****************************************************************************
** Descripción:	 Procesar Telefonos de Personas							****
****************************************************************************
** Modificó:	Francisco Javier Carrillo Rojas							****
** Fecha:		05/Dic/2018												****
** Help:		01171269												****
** Descripción:	cambiar insert directo a exec de SOTELPERALT		 	****
**				incluir proceso de actualización de teléfono verifica-	****
**				dos para el tipo teléfono principal						****
****************************************************************************
** Midificó:	Daniel Bautista Gomez									****
** Fecha:		08-03-2018												****
** Help:		01090212												****
** Descipcion : Se quita uso del campo Tep_Status en SOTELPER			****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		03-05-2017												****
** Help:		00982757												****
****************************************************************************/
										/* Declaración de variables */
declare	@Status		int,
		@Cvt_IdCoVe	int

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Tep_Status char(1),
		@Sta_SinVer	int,
		@Sta_CodCon	int,
		@Tip_TelPri	int,
		@Act_TelVer	char(1),
		@Tip_BajId	char(1)


										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Tep_Status = 'A',				/* Estatus de Activo */	
		@Sta_SinVer	= 0,				/* Estatus de teléfono sin verificar */
		@Sta_CodCon	= 1,				/* Estatus de código confirmado */
		@Tip_TelPri	= 1,				/* Tipo de teléfono principal */	
		@Act_TelVer	= 'V',				/* Tipo de actualización : teléfono verificado */ 
		@Tip_BajId	= 'I'				/* Tipo de baja por id */

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

if @Ent_Cero < (  select 	count(1)  from 
	SOTELPER noholdlock
	where 	PerPersoID = @PerPersoID 
		and Tep_TipTel	= @Tep_TipTel 
		and ClClientID	= @ClClientID ) begin		
		exec @Status =	SOTELPERMOD @PerPersoID, @Tep_TipTel, @ClClientID, @Tep_Lada, @Tep_Telefo,
								@NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, 
								@SucDestino, @Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return @Ent_Uno
		end
end else begin
		/* Alta de Telefonos de Personas	 */
	exec @Status =	SOTELPERALT
		@PerPersoID,	@Tep_TipTel,	@ClClientID,	@Tep_Lada,	@Tep_Telefo,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen, 
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno		
	end
end


/* Buscar si existe el código de verificación del teléfono asociado al cliente para proceder a su actualización de status */
if @Tep_TipTel = @Tip_TelPri begin
	select @Cvt_IdCoVe	= Cvt_IdCoVe
		from	CLCOVETE noholdlock
		where	ClClientID	= @ClClientID
		  and	Cvt_Lada	= @Tep_Lada
		  and	Cvt_Telefo	= @Tep_Telefo
		  and	Cvt_TipTel	= @Tep_TipTel
		  and	Cvt_StaVer	= @Sta_CodCon
			
	if isnull(@Cvt_IdCoVe, @Ent_Cero) != @Ent_Cero begin
		/* Actualizar a verificado el celular */
		exec @Status =	SOTELPERACT
			@PerPersoID,	@Tep_TipTel,	@ClClientID,	@Tep_Lada,		@Tep_Telefo,
			@Ent_Cero,		@Act_TelVer,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen, 	@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return @Ent_Uno		
		end

		exec  @Status =	CLCOVETEBAJ
			@Cvt_IdCoVe,	@Ent_Cero,		@Ent_Cero,		@Ent_Cero,	@Ent_Cero,
			@Tip_BajId,		@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
			@SucOrigen,		@SucDestino,	@Modulo
			
		if @Status <> @Ent_Cero begin
			select	Err_Codigo	= '000005',
					Err_Mensaj	= 'No se pudo realizar la baja del códgo de verificación del teléfono y cliente especificado'
			rollback
			return @Ent_Uno		
		end			
	end
end