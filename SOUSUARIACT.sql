create procedure SOUSUARIACT (
	@Usu_Numero	char(6),
	@Usu_Clave	char(15),
	@Usu_PassWo	char(32),			/*	Contraseña con 32 caracteres Encriptados por RACAL 				*/
	@Usu_FeAcPa	smalldatetime,
	@Usu_IPSesi	char(15),
	@Tip_Actual	char(1),			/*  P. Cambio de Password, I. Inactivar Usuario, A. Activar Usuario
										U. Fecha Ultimo Acceso, B. Baja de Usuario  
										L. Limpiar Sesiones de Usuario, R. Reactivar Usuario 			*/
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION:	Actualización de Usuarios								  */
/**************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Si se compila este stored en Prod, dar acceso a BLOQUEAR				****
****************************************************************************
** Modificó:	Francisco Alejandro Bernal Castro						****
** Fecha:		02/07/2013												****
** Descripción:	Se agrego el tipo de actualizacion 'Z' para el cambio	****
**				de sucursal para Sibamex 3								****
** Help Desk:	539205													****
****************************************************************************
** Modificó:	Rolando J. Bernal González								****
** Fecha:		29/10/2012												****
** Help:		499777													****
** Descripción:	Modificar Tipo de Actualización 'Fecha de				****
**				Último Acceso' - 'U' para validar si el Usuario			****
**				tiene Multisesión.										****
**				Agregar Tipo de Actualización 'Multisesión',			****
**				'Hab. Multi.' - 'M', 'Deshab. Multi.' - 'Q'.			****
****************************************************************************
** Modificó:	Roberto Pascuale Morales Chavez							****
** Fecha:		13/10/2011												****
** Help:		414099													****
** Descripción:	Se agrego el tipo de actualizacion de					****
**				Reactivar Usuario Cancelado								****
****************************************************************************
** Modificó:	Abraham Sanchez											****
** Fecha:		08/12/2010												****
** Help:		343893													****
** Descripción:	Se comentarizo en el tipo de actualizacion U			****
** 				la actualizacion a SYTABLOC ya que provoca bloqueos		****
****************************************************************************
** Modificó:	Estela Mendoza G										****
** Fecha:		17/09/2009												****
** Help:		202946													****
** Descripción:	Fecha Ultimo Acceso Intranet							****
****************************************************************************
** Modificó:	Andrés Grande Díaz										****
** Fecha:		01/09/2008												****
** Help:		113835													****
** Descripción:	Agregado tipo de actualizacion por Sucursal				****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió:	Alfonso Ramos Peña										****
** Fecha:		27/09/07												****
****************************************************************************
** Modificó:	Alfonso Ramos Peña										****
** Fecha:		27/09/2007												****
** Help:		47295													****
** Descripción:	ejecución de RHASIGRAALT en ultimo acc.					****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió:	Perla Judith Abundis Orozco								****
** Fecha:		19/Jul/06												****
****************************************************************************
** Modificó:	ABRAHAM ROSAS DECANINI									****
** Fecha:		17/Juliol/2006											****
** Help:		00139833												****
** Descripción:	Agregar la act, de Limpiar Sesion de Usuario			****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió:	Perla Judith Abundis Orozco								****
** Fecha:		15/May/06												****
****************************************************************************
** Modificó:	Fernando Martinez Miramontes 							****
** Fecha:		28/Abril/2006											****
** Help:		88197													****
** Descripción:	Agregar la act, de Baja, y cambiar la inactiva,			****
**				y activacion del usuario al campo Usu_Activo			****
****************************************************************************
** Modificó:	Arnoldo Garza Quezada									****
** Fecha:		05/Abril/2006											****
** Help:		Observación CNBV										****
** Descripción:	Cambio en Contraseña para 32 caracteres 				****
**				Encriptados por RACAL									****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió:	Perla Judith Abundis Orozco								****
** Fecha:		14/Mar/06												****
****************************************************************************
**					STORE CONVERTIDO									****
** Convirtió:	Perla Judith Abundis Orozco								****
** Fecha:		09/Mar/06												****
****************************************************************************
** Modificó:	Sandra Almaguer											****
** Fecha:		09/Marzo/2006											****
** Help:		Observación CNBV										****
** Descripción:	Agregue campos StaSes, IPSesi a C3						****
****************************************************************************
** 				STORE CONVERTIDO										****
** Convirtió:	Eduardo Salazar Gtz.									****
** Fecha:		31/Mar/04												****
****************************************************************************
** Modificó:	Sandra Almaguer											****
** Fecha:		29/Marzo/2005											****
** Help:		85294													****
** Descripción:	Agregar el cambio de Password en el Historico			****
****************************************************************************
** 					STORE CONVERTIDO									****
** Convirtió:	Perla J. Abundis Orozco									****
** Fecha:		23/Sept/2004											****
****************************************************************************
** Modificó:	Sandra Almaguer											****
** Fecha:		15/Marzo/2004											****
** Descripción:	Agregué Act. Ultimo Acceso al Sistema					****
****************************************************************************
** Modificó:	Eduardo Salazar Gtz.									****
** Fecha:		28/Ene/03												****
** Descripción:	Se agrego el tipo de actualizacion Activacion			****
****************************************************************************
** Creó:		Mayra Estrada											****
** Fecha:		10/Dic/02												****
***************************************************************************/

declare	@Status		int,			/* Declaracion de Variables */
		@Num_Usuari	char(6),
		@Usu_CanSes	int,
		@Usu_MulSes	char(1),
		@Sta_SesAct	char(1),
		@IP_SesAct	char(15),
		@Par_FecAct	smalldatetime

declare	@Tab_Nombre char(8),		/* Declaracion de Constantes */
		@Str_Vacio	char(1),
		@Str_Si		char(1),
		@Str_No		char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Si_Activo	char(1),
		@No_Activo	char(1),
		@Sta_Inacti	char(1),
		@Sta_Activo	char(1),
		@Sta_Cancel	char(1),
		@Fec_Vacia	smalldatetime,
		@Act_CamPas	char(1),
		@Act_InaUsu	char(1),
		@Act_ActUsu	char(1),
		@Act_UltAcc	char(1),
		@Act_BajSes	char(1),
		@Act_Baja	char(1),
		@Act_Limpia	char(1),
		@Act_Sucurs	char(1),
		@Act_Reacti	char(1),
		@Act_UlAcIn	char(1),
		@Act_MuSeAc	char(1),
		@Act_MuSeIn	char(1),
		@Act_CamSuc	char(1),
		@Mod_Ventan	char(2)

/* Asignación de Constantes */
select	@Tab_Nombre	= 'SOUSUARI',	/* Nombre de la Tabla Local que se va actualizar	*/
		@Str_Vacio	= '',			/* String Vacío										*/
		@Str_Si		= 'S',			/* String Si										*/
		@Str_No		= 'N',			/* String No										*/
		@Ent_Cero	= 0,			/* Entero en Cero									*/
		@Ent_Uno	= 1,			/* Entero en Uno									*/
		@Si_Activo	= 'S',			/* Usuario Activo									*/
		@No_Activo	= 'N',			/* Usuario No Activo								*/
		@Sta_Inacti	= 'I',			/* Status de Usuario Inactivo						*/
		@Sta_Activo	= 'A',			/* Status de Usuario Activo							*/
		@Sta_Cancel	= 'C',			/* Status de Cancelado								*/
		@Fec_Vacia	= '1900-01-01',	/* Fecha Vacía										*/
		@Act_CamPas	= 'P',			/* Actualización de Cambio de Password				*/
		@Act_InaUsu	= 'I',			/* Actualización de Inactivar Usuario				*/
		@Act_ActUsu	= 'A',			/* Actualización de Activar Usuario					*/
		@Act_UltAcc	= 'U',			/* Actualización de Fecha de último acceso			*/
		@Act_BajSes	= 'S',			/* Actualización por Baja de Sesión					*/
		@Act_Baja	= 'B',			/* Baja del Sistema									*/
		@Act_Limpia	= 'L',			/* Actualización de Inicializacion de Sesión		*/
		@Act_Sucurs	= 'C',			/* Actualización de Sucursal						*/
		@Act_Reacti	= 'R',			/* Actualización de Reactivar Usuario Cancelado		*/
		@Act_UlAcIn	= 'D',			/* Actualización de Fecha de último acceso Intranet	*/
		@Act_MuSeAc	= 'M',			/* Actualización de Multisesión (Activar)			*/
		@Act_MuSeIn	= 'Q',			/* Actualización de Multisesión (Desactivar)		*/
		@Act_CamSuc	= 'Z',			/* Actualización de Cambio de Sucursal Sibamex3		*/
		@Mod_Ventan	= 'VE'			/* Módulo Ventanilla								*/

select	@FechaSis	= getdate()

if @Tip_Actual = @Act_CamPas begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario ' + @Usu_Numero + ' no existe'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_PassWo	= @Usu_PassWo,
		Usu_FeAcPa	= @Usu_FeAcPa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	exec @Status = SOHISPASALT
		@Usu_Numero,	@Usu_PassWo,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'El Password fue Actualizado'

end else if @Tip_Actual = @Act_InaUsu begin

	if not exists (select	Usu_Clave
					from SOUSUARI noholdlock
					where	Usu_Clave	= @Usu_Clave) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario con Clave ' + @Usu_Clave + ' no existe'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_Activo	= @No_Activo,
		Usu_FecDes	= @FechaSis,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Clave	= @Usu_Clave

	exec @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Desactivado'

end else if @Tip_Actual = @Act_ActUsu begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'Usu_Numero'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_Activo	= @Si_Activo,
		Usu_FecDes	= @Fec_Vacia,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Activado'

end else if @Tip_Actual = @Act_UltAcc begin

	select	@Num_Usuari	= isnull(Usu_Numero, @Str_Vacio),
			@Sta_SesAct	= isnull(Usu_StaSes, @Str_Vacio),
			@Usu_MulSes	= isnull(Usu_MulSes, @Str_No),
			@IP_SesAct	= isnull(Usu_IPSesi, @Str_Vacio)
		from SOUSUARI noholdlock
		where	Usu_Numero	= @Usu_Numero

	if @Num_Usuari = @Str_Vacio begin
		select	Err_Codigo	= '000001', 
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'Usu_Numero'
		rollback
		return 1
	end

	if @Usu_Numero <> '000001' and @Usu_Numero <> '000662' and @Usu_Numero <> '001104' begin

		/* Sacar la IP si no se mandó de parámetro (en Fox no se envía) */
		if isnull(@Usu_IPSesi, @Str_Vacio) = @Str_Vacio
			select	@Usu_IPSesi	= ipaddr
				from master..sysprocesses
				where	spid	= @@spid

		if @Sta_SesAct = @Sta_Activo begin

			/* Multisesión */
			if rtrim(ltrim(@Usu_IPSesi)) <> rtrim(ltrim(@IP_SesAct)) and (@Usu_MulSes = @Str_No or @Modulo = @Mod_Ventan) begin
				select	Err_Codigo	= '000002',
						Err_Mensaj	= 'El usuario ya está conectado en otra Computadora, si no es así, favor de comunicarse con Sistemas',
						Err_Variab	= 'Usu_Numero'
				rollback
				return 1
			end

		end

	end

	update SOUSUARI set
		Usu_StaSes	= @Sta_Activo,
		Usu_IPSesi	= @Usu_IPSesi,
		Usu_CanSes	= Usu_CanSes + @Ent_Uno,
		Usu_FeUlAc	= @FechaSis,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	@Par_FecAct	= Par_FecAct
		from SOPARAMS noholdlock
		where	Par_Sucurs	= @SucOrigen

	execute @Status = RHASIGRAALT
		@Usu_Numero,	@Par_FecAct,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'

end else if @Tip_Actual = @Act_BajSes begin

	select	@Usu_CanSes	= isnull(Usu_CanSes, @Ent_Cero)
		from SOUSUARI noholdlock
		where	Usu_Numero	= @Usu_Numero

	if @Usu_CanSes > @Ent_Uno
		update SOUSUARI set
			Usu_CanSes	= Usu_CanSes - @Ent_Uno,

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
			where	Usu_Numero	= @Usu_Numero
	else
		update SOUSUARI set
			Usu_StaSes	= @Sta_Inacti,
			Usu_IPSesi	= @Str_Vacio,
			Usu_CanSes	= @Ent_Cero,

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
			where	Usu_Numero	= @Usu_Numero

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'

end else if @Tip_Actual = @Act_Baja begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'Usu_Numero'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_Status	= @Sta_Cancel,
		Usu_Activo	= @No_Activo,
		Usu_FecDes	= @FechaSis,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario dado de Baja'

end else if @Tip_Actual = @Act_Limpia begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'Usu_Numero'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_StaSes	= @Sta_Inacti,
		Usu_IPSesi	= @Str_Vacio,
		Usu_CanSes	= @Ent_Cero,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Sesion de Usuario Inicializada'

end else if @Tip_Actual = @Act_Sucurs begin

	if exists ( select	Sol_Numero
					from FBSOLICI noholdlock
					where	Sol_Origen	= @Usu_Numero
					  and	Sol_Status	= @Sta_Activo) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario aun tiene solicitudes, el cambio no puede ser realizado'
		rollback
		return 1
	end

	if exists ( select	Sol_Numero
					from FBSOLICI noholdlock
					where	Sol_Atiend	= @Usu_Numero
					  and	Sol_Status	= @Sta_Activo) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El Usuario aun tiene solicitudes asignadas, el cambio no puede ser realizado: '
		rollback
		return 1
	end

	if isnull(@Usu_Clave,@Str_Vacio) = @Str_Vacio or
			not exists (select	Suc_Numero
							from SOSUCURS noholdlock
							where	Suc_Numero	= rtrim(ltrim(@Usu_Clave))) begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'La Sucursal destino es incorrecta o no existe'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_Sucurs	= rtrim(ltrim(@Usu_Clave)),

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Se ha actualizado la sucursal correctamente'

	return 0

end else if @Tip_Actual = @Act_UlAcIn begin

	select	@Num_Usuari	= isnull(Usu_Numero, @Str_Vacio)
		from SOUSUARI noholdlock
		where	Usu_Numero	= @Usu_Numero

	if @Num_Usuari = @Str_Vacio begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario no existe',
				Err_Variab	= 'Usu_Numero'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_FeUlAc	= @FechaSis,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'

end else if @Tip_Actual = @Act_Reacti begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario ' + @Usu_Numero + ' no existe'
		rollback
		return 1
	end

	update SOUSUARI set
		Usu_Status	= @Sta_Activo,
		Usu_Activo	= @Si_Activo,
		Usu_FecDes	= @Fec_Vacia,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario reactivado'

end else if @Tip_Actual = @Act_MuSeAc begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario ' + @Usu_Numero + ' no existe'
		rollback
		return 1
	end

	/* Actualizar */
	update SOUSUARI set
		Usu_MulSes	= @Str_Si,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'

end else if @Tip_Actual = @Act_MuSeIn begin

	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario ' + @Usu_Numero + ' no existe'
		rollback
		return 1
	end

	/* Actualizar */
	update SOUSUARI set
		Usu_MulSes	= @Str_No,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'

end else if @Tip_Actual	= @Act_CamSuc begin
	
	if not exists (select	Usu_Numero
					from SOUSUARI noholdlock
					where	Usu_Numero	= @Usu_Numero) begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El Usuario ' + @Usu_Numero + ' no existe'
		rollback
		return 1
	end
	
	if not exists (select	Suc_Numero
					from SOSUCURS noholdlock
					where	Suc_Numero	= @Usu_Clave) begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'La Sucursal ' + RTRIM(@Usu_Clave) + ' no existe'
		rollback
		return 1
	end
	
	if not exists (select	Usl_Numero
					from SOUSUSUC noholdlock
					where	Usl_Usuari	= @Usu_Numero
					  and	Usl_Sucurs	= @Usu_Clave) begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Prohibido: No tiene asignada la sucursal ' + @Usu_Clave
		rollback
		return 1
	end

	/* Actualizar */
	update SOUSUARI set
		Usu_Sucurs	= @Usu_Clave,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Usuario Actualizado'
end
