create procedure SOCORPERBAJ (
	@PerPersoID		int,
	@Cop_TipCor		int,
	@ClClientID		int,	

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Baja de Baja de Correos de Persona					****
****************************************************************************
** Modifico:		Norma Tijerina										****
** Fecha:		16-05-2017												****
** Help:		00946339												****
** Descripción: Se agrega condicion por cliente y persona			****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		05-05-2017									****
** Help:		00946339										****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Bcp_Status	char(1),
		@Bcp_Correo varchar(100),
		@Bcp_FecCam smalldatetime, 
		@Bcp_NumTra	char(10), 
		@Bcp_Transa char(3), 
		@Bcp_Usuari char(6), 
		@Bcp_FecSis smalldatetime, 
		@Bcp_SucOri	char(3),
		@Bcp_SucDes	char(3),
		@Bcp_Modulo char(2)

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Cop_Status char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,					/* Entero en uno */
		@Cop_Status = 'B'				/*Estatus de Baja	*/

/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersoID.',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno

end

if @Cop_TipCor = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Cop_TipCor.',
			Err_Variab	= '@Cop_TipCor'
	rollback
	return @Ent_Uno

end

select 
	@Bcp_Correo = Cop_Correo,
	@Bcp_Status	= Cop_Status, 
	@Bcp_FecCam = @FechaSis, 
	
	@Bcp_NumTra	= NumTransac, 
	@Bcp_Transa = Transaccio, 
	@Bcp_Usuari = Usuario, 
	@Bcp_FecSis = FechaSis, 
	@Bcp_SucOri	= SucOrigen,
	@Bcp_SucDes	= SucDestino,
	@Bcp_Modulo = @Modulo
	from SOCORPER noholdlock 
	where PerPersoID	= @PerPersoID
		and Cop_TipCor	= @Cop_TipCor
		and ClClientID	= @ClClientID
		
/*Agregamos a registro a la bitacora de Correos de Persona*/
exec @Status = SOBICOPEALT 
	@PerPersoID, @Cop_TipCor, @ClClientID, @Bcp_Correo, @Bcp_Status, @Bcp_FecCam, @Bcp_NumTra, 
	@Bcp_Transa, @Bcp_Usuari, @Bcp_FecSis, @Bcp_SucOri, @Bcp_SucDes, @Bcp_Modulo

if @Status <> @Ent_Cero begin
		rollback
		return 1
	end

/*Modifica Correo de Persona */
update SOCORPER set
	Cop_Status	= @Cop_Status, 
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	PerPersoID	= @PerPersoID
		and Cop_TipCor	= @Cop_TipCor
		and ClClientID	= @ClClientID
