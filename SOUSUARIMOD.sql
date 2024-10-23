create procedure SOUSUARIMOD	(
	@Usu_Numero	char(6),
	@Usu_Nombre	varchar(50),
	@Usu_Clave	char(15),
	@Usu_PassWo	char(345),
	@Usu_Autori	char(15),
	@Usu_Nivel	char(2),
	@Usu_EMail	varchar(50),
	@Usu_Sucurs	char(3),
	@Usu_ImEsCu	char(1),
	@Usu_CoEsCu	char(1),
	@Usu_Activo	char(1),
	@SaPerfilID	int,
	@Usu_Perfil	char(3),
	@Usu_DisAct	char(1),
	@Usu_DisAcc	char(10),
	@Usu_Depart	char(3),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Usr 		char(6),		/* Declaracion de Variables */
		@Clave		char(15),
		@Password	char(32),		/* Contraseña con 32 caracteres Encriptados por RACAL */
		@Usu_FeAcPa	smalldatetime,
		@Status 	int,
		@Rol_CamPas	int

declare	@Tab_Nombre char(8),		/* Declaracion de Constantes */
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Fec_Vacia	smalldatetime,
		@No_Activo	char(1),
		@Si_Activo	char(1),
		@Sta_Cancel	char(1)
		
/* Asignación de Constantes */
select	@Tab_Nombre = 'SOUSUARI',
		@Str_Vacio	= '',
		@Ent_Cero	= 0,			/* Campo entero en ceros */
		@Fec_Vacia	= '1900-01-01',	/* Fecha Vacía */
		@Si_Activo	= 'S',			/* Usuario Activo */
		@No_Activo	= 'N',			/* Usuario No Activo */
		@Sta_Cancel	= 'C'			/* Status Cancelado */

select 	@Usr		= Usu_Numero,
		@Clave		= Usu_Clave,
		@Password	= Usu_PassWo,
		@Usu_FeAcPa	= Usu_FeAcPa
	from SOUSUARI noholdlock
	where	ltrim(rtrim(Usu_Numero))	= ltrim(rtrim(@Usu_Numero))	

select	@Usr = isnull(@Usr, @Str_Vacio)

if @Usu_Activo not in (@Si_Activo, @No_Activo) begin
	select 	Err_Codigo = '000003',
			Err_Mensaj = 'Status de Activo Invalido',
			Err_Variab = 'Usu_Clave',
			Err_Foco   = 'txtUsu_Clave'
	rollback
	return 1
end

select	@Usu_DisAct	= isnull(@Usu_DisAct, @No_Activo)
select	@Usu_DisAcc	= isnull(@Usu_DisAcc, @Str_Vacio)

/*if @Usu_DisAct not in (@Si_Activo, @No_Activo) begin
	select 	Err_Codigo = '000004',
			Err_Mensaj = 'No especificado status de Dispositivo',
			Err_Variab = 'Usu_DisAct',
			Err_Foco   = 'txtUsu_DisAct'
	rollback
	return 1
end*/

if @Usr <> @Str_Vacio begin
	if 	@Clave <> @Usu_Clave and (select	count(Usu_Numero)
									from SOUSUARI noholdlock
									where	Usu_Clave	= @Usu_Clave) > 0 begin
		select 	Err_Codigo = '000001',
				Err_Mensaj = 'La nueva clave del usuario ya existe',
				Err_Variab = 'xUsu_Clave',
				Err_Foco   = 'txtUsu_Clave'
		rollback
		return 1
	end

	if @Password <> @Usu_PassWo begin
		select	@Rol_CamPas	= proc_role('sso_role')
		if @Rol_CamPas <= @Ent_Cero begin
			select 	Err_Codigo = '000002',
					Err_Mensaj = 'No tiene privilegios para modificar un password',
					Err_Variab = 'xUsu_Clave',
					Err_Foco   = 'txtUsu_Clave'
			rollback
			return 1
		end

		select	@Usu_FeAcPa	= @Fec_Vacia
	end

	select	@Usu_Perfil	= rtrim(ltrim(convert(char, @SaPerfilID)))

	exec UTCERIZQ
		@Valor		= @Usu_Perfil output,
		@Longitud	= 3
	
	update SOUSUARI set
		Usu_Nombre 	= @Usu_Nombre,
		Usu_Clave 	= @Usu_Clave,
		Usu_PassWo 	= @Usu_PassWo,
		Usu_FeAcPa	= @Usu_FeAcPa,
		Usu_Autori 	= ltrim(rtrim(@Usu_Autori)),
		Usu_Nivel  	= @Usu_Nivel,
		Usu_EMail 	= @Usu_EMail,
		Usu_Sucurs	= @Usu_Sucurs,
		Usu_ImEsCu	= @Usu_ImEsCu,
		Usu_CoEsCu	= @Usu_CoEsCu,
		Usu_Activo	= @Usu_Activo,
		SaPerfilID	= @SaPerfilID,
		Usu_Perfil	= @Usu_Perfil,
		Usu_Depart	= @Usu_Depart,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Numero	= @Usu_Numero

	execute @Status =  SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end
	select 	Err_Codigo	= '000000', 
			Err_Mensaj	= 'El usuario fue modificado',
			Rol_CamPas	= @Rol_CamPas

end else begin
	select 	Err_Codigo = '000002', 
			Err_Mensaj = 'El usuario no existe' + @Usr, 
			Err_Variab = 'xUsu_Clave',
			Err_Foco   = 'txtUsu_Numero'
	rollback
	return 1
end
