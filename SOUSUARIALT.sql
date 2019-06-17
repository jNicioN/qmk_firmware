create procedure SOUSUARIALT(
	@Usu_Numero	char(6),
	@Usu_Nombre	varchar(50),
	@Usu_Clave	char(15),
	@Usu_PassWo	char(32),		/* Contraseña con 32 caracteres Encriptados por RACAL */
	@Usu_Nivel	char(2),
	@Usu_Autori	char(15),
	@Usu_EMail	varchar(50),
	@Usu_Sucurs	char(3),
	@Usu_ImEsCu	char(1),
	@Usu_CoEsCu	char(1),
	@Usu_Activo	char(1),
	@SaPerfilID	int,
	@Usu_DisAct	char(1),
	@Usu_DisAcc	char(10),
	@Usu_Depart	char(3),

	@NumTransac char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************/
/* DESCRIPCION: Alta de un usuario 											*/
/****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Modificó:	Rolando J. Bernal González								****
** Fecha:		29/Octubre/2012											****
** Help:		00499777												****
** Descripción:	Agregar campos Usu_MulSes al INSERT						****
****************************************************************************
** Modificó:	Roberto Pascuale Morales Chavez							****
** Fecha:		28/Septiembre/2011										****
** Help:		364751													****
** Descripción:	Agregar parametro Usu_Depart							****
****************************************************************************
** Modificó:	Andrea Ramírez M.										****
** Fecha:		21/Enero/2010											****
** Help:		00246408												****
** Descripción:	Agregar isNULL a Usu_DisAct, Usu_DisAcc					****
****************************************************************************
** Modificó:	Francisco Javier Cordero Guzman							****
** Fecha:		21/Octubre/2009											****
** Help:		00223296												****
** Descripción:	Agregar parametro Usu_DisAct, Usu_DisAcc				****
****************************************************************************
** Modificó:	Sandra Almaguer											****
** Fecha:		23/Febrero/2007											****
** Help:																****
** Descripción:	Poner Fec_Vacia en Fecha Cambio Passwd					****
***************************************************************************/

declare	@Status		int,		/* Declaracion de Variables */
		@Usu_Perfil	char(3),
		@SoUsuariID	int

declare	@Tab_Nombre	char(8),	/* Declaración de Constantes */
		@Str_Vacio	char(1),
		@Str_No		char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Sta_Inacti	char(1),
		@Usu_PasEsp	char(15),	/* AGQ: Esta contraseña no se utiliza al parecer, no se convirtio a 32 caracteres encriptados hasta que sea utilizado realmente. */
		@Usu_ImNoCl	char(1),
		@Usu_CoInSu	char(1),
		@No_Activo	char(1),
		@Si_Activo	char(1),
		@Sta_Activo	char(1)

/* Asignación de Constantes */
select	@Tab_Nombre	= 'SOUSUARI',	/* Nombre de la Tabla										*/
		@Str_Vacio	= '',			/* String Vacío												*/
		@Str_No		= 'N',			/* String No												*/
		@Fec_Vacia	= '1900-01-01',	/* Fecha Vacía												*/
		@Ent_Cero	= 0,			/* Entero en Cero											*/
		@Sta_Inacti	= 'I',			/* Status de Sesión Inactiva								*/
		@Usu_PasEsp	= '',			/* Password Especial (para el nuevo sistema)				*/
		@Usu_ImNoCl	= '',			/* Imprime Nombre del Cliente (para el nuevo sistema)		*/
		@Usu_CoInSu	= '',			/* Consulta Informacion de Sucursal (para el nuevo sistema)	*/
		@Si_Activo	= 'S',			/* Usuario Activo											*/
		@No_Activo	= 'N',			/* Usuario No Activo										*/
		@Sta_Activo	= 'A'			/* Status de Usuario Activo									*/

select	@SoUsuariID	= convert(int, @Usu_Numero),
		@Usu_Perfil	= rtrim(ltrim(convert(char, @SaPerfilID)))

exec UTCERIZQ
	@Valor		= @Usu_Perfil output,
	@Longitud	= 3

if @Usu_Activo not in (@Si_Activo, @No_Activo) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Status de Activo Invalido',
			Err_Variab	= 'Usu_Clave',
			Err_Foco	= 'txtUsu_Clave'
	rollback
	return 1
end

select	@Usu_DisAct	= isnull(@Usu_DisAct, @No_Activo)
select	@Usu_DisAcc	= isnull(@Usu_DisAcc, @Str_Vacio)

if not exists (select	Usu_Clave
				from SOUSUARI noholdlock
				where	ltrim(rtrim(Usu_Clave))	= ltrim(rtrim(@Usu_Clave))) begin

	select @Usu_Autori = ltrim(rtrim(@Usu_Autori))

	insert into SOUSUARI values (
		@SoUsuariID,	@Usu_Numero,	@Usu_Nombre,	@SaPerfilID,	@Usu_Perfil,
		@Usu_Clave,		@Usu_PassWo,	@Fec_Vacia,		@Usu_Autori,	@Usu_Nivel,
		@Sta_Activo,	@Usu_EMail,		@Usu_Sucurs,	@Usu_ImEsCu,	@Usu_CoEsCu,
		@Usu_PasEsp,	@Usu_ImNoCl,	@Usu_CoInSu,	@Usu_Activo,	@Fec_Vacia,
		@Fec_Vacia,		@Sta_Inacti,	@Str_Vacio,		@Ent_Cero,		@Usu_Depart,
		@Str_No,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen,		@SucDestino)

	execute @Status = SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen, 	@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'El usuario fue dado de alta'
end else begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La clave ya existe para otro usuario',
			Err_Variab	= 'Usu_Clave',
			Err_Foco	= 'txtUsu_Clave'
	rollback
	return 1
end
