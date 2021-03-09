
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
** Modifico:	Adriana Gomez 											****
** Fecha:		05/03/2021												****
** Help Desk:	1468365										 			****
** Descripción:	Se modifica validacion de usuarios y clientes existentes****
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
	select @Persona= @Ent_Cero
	select @Cliente = @Ent_Cero
	select @UsuarioCV = @Ent_Cero
	
	select 	PerPersoID,
			Per_Numero, 
			Per_RFC
			into #Personas 
			from SOPERSON noholdlock 
			inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
			where Adi_FecNac = @Use_FecNac and  Per_Comple = @Use_NoCoUs
			
	select @Persona = count (*) from #Personas noholdlock
			
	/* Si existe un prospecto revisa si tiene un cliente con cuentas activas o bloqueadas*/
	if @Persona > @Ent_Cero begin		
		select Adi_Client 
			into #Clientes
			from #Personas noholdlock
			inner join CLADICIO noholdlock on Per_Numero = Adi_NumPer 
			inner join CHCUENTA noholdlock on Adi_Client = Cue_Client
			where Cue_Status in (@Sta_Bloque, @Sta_Activo) 
			and Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
				
		select @Cliente = count (*) from #Clientes noholdlock
		drop table #Clientes
	end 
	
	/* si no es cliente se procede a buscar como usuario*/
	if @Cliente = @Ent_Cero begin
		/* si es usuario nacional */
		if @Persona = @Ent_Cero begin			
			select  Une_Identi,
					Une_TabOri
				into #UsuariosNacionales
				from #Personas noholdlock
				inner join SOUSNAEX noholdlock on PerPersoID = Une_IdeUsu
				where Une_Estatu = @Sta_Activo
				
			select @UsuarioCV = count (*) from #UsuariosNacionales noholdlock
			drop table #UsuariosNacionales
		end
		
		/* si no lo encontro como usuario nacional y tampoco es cliente busca en extranjeros */
		if( @Cliente = @Ent_Cero and @UsuarioCV = @Ent_Cero ) begin
			select  Une_Identi,
					Une_TabOri
				into #UsuariosExtranjeros
				from SOUSNAEX noholdlock
				inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
				where Use_FecNac = @Use_FecNac 
				and Use_NoCoUs = @Use_NoCoUs
				and Une_Estatu = @Sta_Activo

			select @UsuarioCV = count (*) from #UsuariosExtranjeros noholdlock
			drop table #UsuariosExtranjeros
		end 
	
	end
	
	drop table #Personas
	
	
	/* se checa si el cambio del estatus es activacion o inactivacion, si es inactivacion no hace la validacion de cuenta activa */
	if @Tip_ActAct = @Str_A begin 
	
		if @Cliente > @Ent_Cero  begin
			select	@Mensaje = 'No se ha podido activar porque existe un Cliente con cuentas Activas o Bloqueadas con el nombre ' + @Use_NoCoUs
		end else if @UsuarioCV > @Ent_Cero  begin
			select	@Mensaje = 'No se ha podido activar porque ya existe un Usuario Activo con el nombre ' + @Use_NoCoUs
		end
		
		/* Si encontro algun homonimo usuario activo se evita la activacion*/
		if @UsuarioCV > @Ent_Cero or @Cliente > @Ent_Cero  begin
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

