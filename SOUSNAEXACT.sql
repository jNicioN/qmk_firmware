create procedure SOUSNAEXACT (
	@Une_Identi	int,
	@Une_Estatu	varchar(1),
	@Tip_Actual	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*****************************************************************************
** DESCRIPCION: ** Actualizacion de Tabla Usuarios Nacionales y Extranjeros **
******************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Modifico:	Carlos Copto 											****
** Fecha:		15/Diciembre/2020										****
** Help Desk:	1376175										 			****
** Descripción:	Se agrega registro a Bitacora							****
****************************************************************************
** Creo:		Carlos Copto 											****
** Fecha:		11/Noviembre/2020										****
** Help Desk:	1376175										 			****
** Descripción:	Se crea SP y tipo de actualizacion del campo Une_Status	****
****************************************************************************
**/
declare	@Use_NoCoUs 	varchar(150),			/* Declaración de Variables */
		@Use_FecNac		smalldatetime,
		@Une_TabOri		char(1),
		@Per_ID 		char(8),
		@Persona		int,
		@Tab_Ori		char(1),
		@Cliente		int,
		@UsuarioCV		int,
		@Estatus		char(1),
		@Per_RFC 		char(15),
		@Mensaje		varchar(150),
		@Status			int,
		@Tip_ActTip		char(1),
		@Tip_ActAct		char(1),
		@Biu_DesEst		varchar(180)

declare	@Tip_ActEst 	varchar(1),			/* Declaración de Constantes */
		@Str_Vacio	 	varchar(1),			
		@Ent_Cero	 	int,
		@Ent_Uno	 	int,
		@Sta_Activo	 	varchar(1),
		@Sta_Bloque		varchar(1),
		@Cue_CashBa		char(2),
		@Cue_Refere		char(2),
		@Biu_Canal		int,
		@Str_Uno		char(1),
		@Str_Dos		char(1),
		@Str_A			char(1),
		@Str_I			char(1)

											-- Asignación de valores a constantes 	
select	@Tip_ActEst	= 'A',					--	Tipo Act Estatus de Usuario								
		@Str_Vacio	= '',					--	String Vacio							
		@Ent_Cero	= 0,					--	Entero Cero								
		@Ent_Uno	= 1,					--	Entero Uno							
		@Sta_Activo = 'A',					--	Status Activo						
		@Sta_Bloque	= 'B',					--	Status Bloqueado					
		@Cue_CashBa = '31',					-- Tipo de Cuenta: Cashback
		@Cue_Refere = '50',					-- Tipo de Cuenta: Referenciado
		@Biu_Canal  = 5,					-- Canal de actualizacion del usuario correspondiente a Apertura
		@Str_Uno	= '1',					-- String 1
		@Str_Dos	= '2',					-- String 2
		@Str_A		= 'A',					-- Letra I
		@Str_I		= 'I'					-- Leta A

select @FechaSis = getdate()

if isnull(@Tip_Actual, @Str_Vacio) = @Str_Vacio  begin
		select	Err_Codigo = '000001',
				Err_Mensaj = 'Ingrese un tipo de Actualizacion'
		rollback
		return @Ent_Uno
end

select	@Tip_ActTip	= substring(@Tip_Actual, 1, 1),
		@Tip_ActAct	= substring(@Tip_Actual, 2, 1)

if @Tip_ActTip = @Tip_ActEst begin
	
	if isnull(@Une_Identi, @Ent_Cero) = @Ent_Cero  begin
		select	Err_Codigo = '000002',
				Err_Mensaj = 'Ingrese un numero de Usuario'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Une_Estatu, @Str_Vacio) = @Str_Vacio  begin
		select	Err_Codigo = '000003',
				Err_Mensaj = 'Ingrese un Estatus'
		rollback
		return @Ent_Uno
	end
	
	/* Se obtiene la tabla origen del usuario para consultar su nombre y fecha*/
	select @Une_TabOri = Une_TabOri
	from SOUSNAEX noholdlock 
	where Une_Identi = @Une_Identi
	
	/* Se obtiene el nombre y fecha de nacimiento en su tabla de origen para buscar despues si hay homonimo activo */
	if @Une_TabOri = @Str_Uno begin
		select @Use_NoCoUs = Per_Comple,
			   @Use_FecNac = Adi_FecNac
		from SOUSNAEX noholdlock 
		join SOPERSON noholdlock on PerPersoID = Une_IdeUsu  
		join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where Une_TabOri = @Une_TabOri
		and Une_Identi = @Une_Identi
	end
	
	if @Une_TabOri = @Str_Dos begin
		select @Use_NoCoUs = Use_NoCoUs,
			   @Use_FecNac = Use_FecNac
		from SOUSNAEX noholdlock 
		join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx  
		where Une_TabOri = @Une_TabOri
		and  Une_Identi = @Une_Identi
	end
	
		/* primero busca en SOPERSON si existe la persona */
	select 	@Per_ID = Per_Numero, 
			@Per_RFC = Per_RFC,
			@Persona = @Ent_Uno			/* si lo encuentra en este punto signfica que al menos existe como prospecto */
			from SOPERSON noholdlock 
			inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
			where Adi_FecNac = @Use_FecNac and  Per_Comple = @Use_NoCoUs
			
	/* Si existe un prospecto revisa si tiene un cliente con cuentas activas o bloqueadas*/
	if( @Persona = @Ent_Uno ) begin
		select  @Cliente = @Ent_Uno
			from CLCLIENT noholdlock
			inner join CHCUENTA noholdlock on Cli_Numero = Cue_Client
			where Cli_RFC	= @Per_RFC
			and Cue_Status in (@Sta_Bloque, @Sta_Activo) 
			and Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)	
	end 
	
	/* si no es cliente se procede a buscar como usuario*/
	if ( @Cliente <> @Ent_Uno ) begin
		
		/* si es usuario nacional */
		if ( @Persona = @Ent_Uno) begin
			select  @Per_ID = convert(char, Une_Identi),
					@Tab_Ori = Une_TabOri,
					@Estatus = Une_Estatu,
					@UsuarioCV = @Ent_Uno
			from SOUSNAEX noholdlock
			where Une_IdeUsu = convert(int, str_replace(ltrim(str_replace( @Per_ID , '0', ' ')),' ', '0') )
		end
		
		/* si no lo encontro como usuario nacional y tampoco es cliente busca en extranjeros */
		if( @Cliente <> @Ent_Uno and @UsuarioCV <> @Ent_Uno ) begin
			select  @Per_ID = convert(char, Une_Identi),
					@Tab_Ori = Une_TabOri,
					@Estatus = Une_Estatu,
					@UsuarioCV = @Ent_Uno
			from SOUSNAEX noholdlock
			inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
			where Use_FecNac = @Use_FecNac and Use_NoCoUs = @Use_NoCoUs
		end 
	
	end
	
	/* se checa si el cambio del estatus es activacion o inactivacion, si es inactivacion no hace la validacion de cuenta activa */
	if @Tip_ActAct = @Str_A begin 
	
		if @Cliente = @Ent_Uno begin
			select	@Mensaje = 'No se ha podido activar porque existe un Cliente con cuentas Activas o Bloqueadas con el nombre ' + @Use_NoCoUs
		end else if @UsuarioCV = @Ent_Uno and @Estatus = @Sta_Activo begin
			select	@Mensaje = 'No se ha podido activar porque ya existe un Usuario Activo con el nombre ' + @Use_NoCoUs
		end
		
		/* Si encontro algun homonimo usuario activo se evita la activacion*/
		if @UsuarioCV = @Ent_Uno and @Estatus = @Sta_Activo or @Cliente = @Ent_Uno begin
			select	Err_Codigo	= '000004',
					Err_Mensaj = @Mensaje	
			rollback
			return @Ent_Uno
		end
		
	select @Biu_DesEst = 'Reactivacion de estatus de Usuario de compra venta'  /* Descripcion para la bitacora */
	
	end else if @Tip_ActAct = @Str_I begin 
		
		select @Biu_DesEst = 'Inactivacion de Usuario de compra venta por actvacion de Cuenta'  /* Descripcion para la bitacora */
	
	end
	
	update SOUSNAEX set 
		Une_Estatu  = @Une_Estatu,
		NumTransac  = @NumTransac,
		Transaccio  = @Transaccio, 
		Usuario 	= @Usuario,	  
		FechaSis	= @FechaSis,	
		SucOrigen	= @SucOrigen,	
		SucDestino	= @SucDestino
	where	Une_Identi	= @Une_Identi
	
	exec SOBITUSUALT 
	@Une_Identi, @Une_Estatu, @FechaSis,   @Usuario,    @SucOrigen,  
	@Biu_Canal,  @Biu_DesEst, @NumTransac, @Transaccio, @Usuario,	  
	@FechaSis,	 @SucOrigen,  @SucDestino, @Modulo
	
	if @@nestlevel = @Ent_Uno and @Une_Estatu = @Sta_Activo
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Usuario Activado',
				Use_Numero	= @Une_Identi
		return @Ent_Uno
		
end
