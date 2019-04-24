create procedure SOTELPERMOD (
	@PerPersoID		int,
	@Tep_TipTel		int, 
	@ClClientID	 	int,		
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
** Descripción:	 Modifica Telefonos de Persona							****
****************************************************************************
** Modificó:	Raul Minor												****
** Fecha:		24/Abril/2019											****
** Help:		1239991													****
** Descripción:	Se cambia tipo de dato de  @Btp_Telefo por bigint		****
****************************************************************************
** Modificó:	Francisco Javier Carrillo Rojas							****
** Fecha:		09/Dic/2018												****
** Help:		01171269												****
** Descripción:	Setear si el celular perdió su status de verificado	 	****
****************************************************************************
** Midificó:	Daniel Bautista Gomez									****
** Fecha:		08-03-2018												****
** Help:		01090212												****
** Descipcion : Se quita uso del campo Tep_Status en SOTELPER			****
				y en SOBITEPEALT se registran parametros de control		****
				enviados en el SP										****
****************************************************************************
** Modifico:	Roberto Saldivar										****
** Fecha:		16-05-2017												****
** Help:		00982757												****
** Descripción: Al hacer update se activa el telefono					****
****************************************************************************
** Modifico:		Norma Tijerina										****
** Fecha:		16-05-2017												****
** Help:		00946339												****
** Descripción: Se cambia tipo de dato de telefono						****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		04-05-2017									****
** Help:		00946339										****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Btp_TipTel		int, 
		@Btp_Lada		int, 
		@Btp_Telefo		bigint,
		@Str_A			char(1),
		@Tep_Verifi		int
										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Tep_StaMod	char(1),
		@Sta_SinVer	int

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Str_A		= 'A',				/* String A*/
		@Sta_SinVer	= 0					/* Status de verificación, sin verificar */

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


select 
	@Btp_TipTel	= Tep_TipTel, 
	@Btp_Lada	= Tep_Lada, 
	@Btp_Telefo	= Tep_Telefo,
	@Tep_Verifi	= Tep_Verifi
	from SOTELPER noholdlock 
	where PerPersoID	= @PerPersoID
		and Tep_TipTel	= @Tep_TipTel
		and ClClientID	= @ClClientID
		
/*Agregamos a registro a la bitacora de Telefonos de Persona*/
exec @Status = 	SOBITEPEALT 	
	@PerPersoID, 	@Btp_TipTel,	@ClClientID, 	@Btp_Lada, 		@Btp_Telefo,
	@FechaSis, 		@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis,
	@SucOrigen, 	@SucDestino, 	@Modulo

if @Status <> @Ent_Cero begin
		rollback
		return 1
end

if @Tep_Lada <> @Btp_Lada or @Tep_Telefo <> @Btp_Telefo begin
	select @Tep_Verifi = @Sta_SinVer
end else begin
	select @Tep_Verifi = isnull(@Tep_Verifi, @Ent_Cero)
end

/*Modifica Telefono de Persona */
update SOTELPER set 
	Tep_Lada	= @Tep_Lada, 
	Tep_Telefo	= @Tep_Telefo,
	Tep_Verifi	= @Tep_Verifi,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	PerPersoID	= @PerPersoID
		and Tep_TipTel	= @Tep_TipTel
		and ClClientID	= @ClClientID