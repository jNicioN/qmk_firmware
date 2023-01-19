create procedure SOUSNAEXACT (
	@Une_Identi	int,
	@Une_Estatu	varchar(1),
	@Tip_Actual	char(2),
	@Biu_descri	varchar(150),

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
** Modifico:	Francisco Minajas										****
** Fecha:		13/01/2023												****
** Help Desk:	1643006										 			****
** Descripción:	Se agrega consulta de fecha x sucursal					****
****************************************************************************
** Modifico:	Martin Adonis Lopez Mendoza								****
** Fecha:		30/08/2022												****
** Help Desk:	1643006 									 			****
** DescripciÃ³n:	Se agrega mensaje retorno al cancelar usuarios			****
****************************************************************************
** Modifico:	Adriana Gomez 											****
** Fecha:		24/03/2021												****
** Help Desk:	1376175 									 			****
** DescripciÃ³n:	Se corrige validacion 									****
****************************************************************************
** Modifico:	Adriana Gomez 											****
** Fecha:		05/03/2021												****
** Help Desk:	1376175 									 			****
** DescripciÃ³n:	Se agrega validaciÃ³n para reactivar usuario				****
****************************************************************************
** Modifico:	Adriana Gomez 											****
** Fecha:		05/03/2021												****
** Help Desk:	1468365										 			****
** DescripciÃ³n:	Se modifica validacion de usuarios y clientes existentes****
****************************************************************************
** Modifico:	Carlos Copto 											****
** Fecha:		15/Diciembre/2020										****
** Help Desk:	1376175										 			****
** DescripciÃ³n:	Se agrega registro a Bitacora							****
****************************************************************************
** Creo:		Carlos Copto 											****
** Fecha:		11/Noviembre/2020										****
** Help Desk:	1376175										 			****
** DescripciÃ³n:	Se crea SP y tipo de actualizacion del campo Une_Status	****
****************************************************************************
**/
declare	@Use_NoCoUs 	varchar(150),			/* DeclaraciÃ³n de Variables */
		@Use_FecNac		smalldatetime,
		@Une_TabOri		char(1),
		@Persona		int,
		@Cliente		int,
		@UsuarioCV		int,
		@Mensaje		varchar(150),
		@Status			int,
		@Tip_ActTip		char(1),
		@Tip_ActAct		char(1),
		@Biu_DesEst		varchar(180),
		@Fec_Actual  	smalldatetime,	
		@Fec_IniMes		smalldatetime,
		@Fec_FinMes 	smalldatetime,
		@CliIna			int,
		@Acumul			int,
		@Per_Numero		char(8),
		@PerPersoID		int

		

declare	@Tip_ActEst 	varchar(1),			/* DeclaraciÃ³n de Constantes */
		@Str_Vacio	 	varchar(1),			
		@Ent_Cero	 	int,
		@Ent_Uno	 	int,
		@Sta_Activo	 	varchar(1),
		@Sta_Inacti	 	varchar(1),
		@Sta_Cancelado	varchar(1),
		@Sta_Bloque		varchar(1),
		@Cue_CashBa		char(2),
		@Cue_Refere		char(2),
		@Biu_Canal		int,
		@Str_Uno		char(1),
		@Str_Dos		char(1),
		@Str_A			char(1),
		@Str_I			char(1),
		@Une_TaOrNa		char(1),	
		@Une_TaOrEx		char(1), 
		@Tip_Client		char(1),
		@Tip_Nomina		char(1),
		@Ent_CieDos		smallint,
		@Str_Punto		char(1),
		@Str_Guion		char(1),
		@Sta_Cancel		char(1),
		@Str_Divisas   	char(8),
		@Str_Status 	char(1)
		

											-- AsignaciÃ³n de valores a constantes 	
select	@Tip_ActEst	= 'A',					--	Tipo Act Estatus de Usuario								
		@Str_Vacio	= '',					--	String Vacio							
		@Ent_Cero	= 0,					--	Entero Cero								
		@Ent_Uno	= 1,					--	Entero Uno							
		@Sta_Activo = 'A',					--	Status Activo						
		@Sta_Inacti = 'I',					--	Status Inactivo	
		@Sta_Cancelado = 'C',					-- Status Cancelado
		@Sta_Bloque	= 'B',					--	Status Bloqueado					
		@Cue_CashBa = '31',					-- Tipo de Cuenta: Cashback
		@Cue_Refere = '50',					-- Tipo de Cuenta: Referenciado
		@Biu_Canal  = 5,					-- Canal de actualizacion del usuario correspondiente a Apertura
		@Str_Uno	= '1',					-- String 1
		@Str_Dos	= '2',					-- String 2
		@Str_A		= 'A',					-- Letra I
		@Str_I		= 'I',					-- Leta A
		@Une_TaOrNa	= '1',					/*tabla origen nacionales SOPERSON */
		@Une_TaOrEx	= '2',					/*tabla origen extranjeros SOUSUEXT*/
		@Tip_Client	= 'C',					/* Tipo: Cliente					*/
		@Tip_Nomina	= 'N',					/* Tipo: Cliente Nomina				*/
		@Ent_CieDos	= 102,					/* Entero: CientoDos						*/
		@Str_Punto	= '.',					/* String: Punto							*/
		@Str_Guion	= '-',					/* String: Guion							*/
		@Sta_Cancel = 'C',
		@Str_Status = 'I'
/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct
from SOPARAMS noholdlock
where Par_Sucurs = @SucOrigen

/*Fecha de inicio y fin de mes*/
select @Fec_IniMes = dateadd(dd, 1 - datepart(dd, @Fec_Actual), @Fec_Actual)
select @Fec_FinMes = dateadd(dd, -1, dateadd(mm,  1, @Fec_IniMes))					

--activar cambio de divisas
select @Str_Divisas=Par_Valor from  SOPARGEN where Par_Nombre = 'UsuarioDivisas'				

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
	select	@Une_TabOri	= Une_TabOri
	from SOUSNAEX noholdlock 
	where	Une_Identi	= @Une_Identi
	
	/* Se obtiene el nombre y fecha de nacimiento en su tabla de origen para buscar despues si hay homonimo activo */
	if @Une_TabOri = @Str_Uno begin
		
		select	@PerPersoID	=  Une_IdeUsu  
			from SOUSNAEX noholdlock 
			where	Une_Identi	= @Une_Identi 
			  and	Une_TabOri	= @Une_TabOri
			
		select	@Use_NoCoUs	= Per_Comple,
				@Per_Numero	= Per_Numero 
			from SOPERSON noholdlock 
			where	PerPersoID	= @PerPersoID
			
		select	@Use_FecNac	= Adi_FecNac
			from SOPERADI noholdlock 
			where	Adi_PerNum	= @Per_Numero 
		
	end
	
	if @Une_TabOri = @Str_Dos begin
		select	@Use_NoCoUs	= Use_NoCoUs,
				@Use_FecNac	= Use_FecNac
		from SOUSNAEX noholdlock 
		join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
		where	Une_Identi	= @Une_Identi 
		  and	Une_TabOri	= @Une_TabOri
	end
	
		/* primero busca en SOPERSON si existe la persona */
	select	@Persona= @Ent_Cero
	select	@Cliente = @Ent_Cero
	select	@UsuarioCV = @Ent_Cero
		
		select	PerPersoID,
			Per_Numero, 
			Per_RFC
		into #PersonasMismoNombre
		from SOPERSON noholdlock 
		where	Per_Comple	= @Use_NoCoUs
		and Per_Numero = @Per_Numero	
		
	select	PerPersoID,
			Per_Numero, 
			Per_RFC
		into #Personas 
		from #PersonasMismoNombre noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where	Adi_FecNac	= @Use_FecNac 

	drop table #PersonasMismoNombre
	
	select	@Persona	= count (*) from #Personas noholdlock
			
	/* Si existe un prospecto revisa si tiene un cliente con cuentas activas o bloqueadas*/
	if @Persona > @Ent_Cero begin		
		select	Adi_Client 
			into #Clientes
			from #Personas noholdlock
			inner join CLADICIO noholdlock on Per_Numero = Adi_NumPer 
			inner join CHCUENTA noholdlock on Adi_Client = Cue_Client
			where	Cue_Status in (@Sta_Bloque, @Sta_Activo) 
			  and	Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
				
		select	@Cliente	= count (*) 
			from #Clientes noholdlock
		
		if @Cliente = @Ent_Cero begin	
			select	Adi_Client 
				into #ClientesInactivos
				from #Personas noholdlock
				inner join CLADICIO noholdlock on Per_Numero = Adi_NumPer 
				inner join CHCUENTA noholdlock on Adi_Client = Cue_Client
				where	Cue_Status	= @Sta_Cancel
				  and	Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
				
			select	@CliIna	= count (*) 
				from #ClientesInactivos noholdlock
				
			if @CliIna > @Ent_Cero begin	
				select	Clu_Grupo,
						Clu_Client
					into #GrupoClientes
					from CLCLIUNI noholdlock
					inner join #ClientesInactivos on Clu_Client = Adi_Client
				
				select	@Acumul	= count(*)
					from VEACUDLL noholdlock
					inner join #GrupoClientes noholdlock on Adl_Fecha >= @Fec_IniMes
					  and	Adl_Fecha	<= @Fec_FinMes and Clu_Client = Adl_NumCli
					  and	Adl_TipCli	in (@Tip_Client, @Tip_Nomina)
					  
				if @Acumul > @Ent_Cero begin	
					select	Err_Codigo	= '000006',
							Err_Mensaj = 'No se puede activar/reactivar usuario hasta el prÃ³ximo mes calendario'	
					rollback
					return @Ent_Uno
				end 				
		
			end
		
		end 
		
		drop table #Clientes
	end 
	
	/* si no es cliente se procede a buscar como usuario*/
	if @Cliente = @Ent_Cero begin
		/* si es usuario nacional */
		if @Persona = @Ent_Cero begin			
			select	Une_Identi,
					Une_TabOri
				into #UsuariosNacionales
				from #Personas noholdlock
				inner join SOUSNAEX noholdlock on PerPersoID = Une_IdeUsu and Une_TabOri = @Une_TaOrNa
				where	Une_Estatu	= @Sta_Activo
				
			select	@UsuarioCV	= count (*) from #UsuariosNacionales noholdlock
			drop table #UsuariosNacionales
		end
		
		/* si no lo encontro como usuario nacional y tampoco es cliente busca en extranjeros */
		if( @Cliente = @Ent_Cero and @UsuarioCV = @Ent_Cero ) begin
			select  Une_Identi,
					Une_TabOri
				into #UsuariosExtranjeros
				from SOUSUEXT noholdlock
				inner join SOUSNAEX noholdlock on Une_IdeUsu = Use_IdUsEx and Une_TabOri = @Une_TaOrEx
				where	Use_FecNac	= @Use_FecNac 
				  and	Use_NoCoUs	= @Use_NoCoUs
				  and	Une_Estatu	= @Sta_Activo

			select	@UsuarioCV	= count (*)
				from #UsuariosExtranjeros noholdlock
				
			drop table #UsuariosExtranjeros
		end 
	
	end
	
	drop table #Personas
	
	
if @Str_Divisas = @Str_Uno begin 
	/* se checa si el cambio del estatus es activacion o inactivacion, si es inactivacion no hace la validacion de cuenta activa */
	if @Tip_ActAct = @Str_A begin 
	
		if @Cliente > @Ent_Cero  begin
			select	@Mensaje	= 'No se ha podido activar porque existe un Cliente con cuentas Activas o Bloqueadas con el nombre ' + @Use_NoCoUs
		end else if @UsuarioCV > @Ent_Cero  begin
			select	@Mensaje	= 'No se ha podido activar porque ya existe un Usuario Activo con el nombre ' + @Use_NoCoUs
		end
		
		/* Si encontro algun homonimo usuario activo se evita la activacion*/
		if @UsuarioCV > @Ent_Cero or @Cliente > @Ent_Cero  begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= @Mensaje	
			rollback
			return @Ent_Uno
		end
		
	select	@Biu_DesEst	= 'Activacion de estatus de Usuario de compra venta'  /* Descripcion para la bitacora */
	
	end else if @Tip_ActAct = @Str_I begin 
	
		select	@Biu_DesEst	= 'Creacion de cuenta de usuario de compra venta'  /* Descripcion para la bitacora */
	
	end else if @Tip_ActAct = @Sta_Cancelado begin
		
		select	@Biu_DesEst	=  @Biu_descri /* Descripcion para la bitacora */
		
		end
end else begin 
		/* se checa si el cambio del estatus es activacion o inactivacion, si es inactivacion no hace la validacion de cuenta activa */
	if @Tip_ActAct = @Str_A begin 
	
		if @Cliente > @Ent_Cero  begin
			select	@Mensaje	= 'No se ha podido activar porque existe un Cliente con cuentas Activas o Bloqueadas con el nombre ' + @Use_NoCoUs
		end else if @UsuarioCV > @Ent_Cero  begin
			select	@Mensaje	= 'No se ha podido activar porque ya existe un Usuario Activo con el nombre ' + @Use_NoCoUs
		end
		
		/* Si encontro algun homonimo usuario activo se evita la activacion*/
		if @UsuarioCV > @Ent_Cero or @Cliente > @Ent_Cero  begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= @Mensaje	
			rollback
			return @Ent_Uno
		end
		
	select	@Biu_DesEst	= 'Reactivacion de estatus de Usuario de compra venta'  /* Descripcion para la bitacora */
	
	end else if @Tip_ActAct = @Str_I begin 
		
		select	@Biu_DesEst	= 'Inactivacion de Usuario de compra venta por actvacion de Cuenta'  /* Descripcion para la bitacora */
	
	end
	end
	
	update SOUSNAEX set 
		Une_Estatu	= @Une_Estatu,
		Une_FecEst  = @Fec_Actual,
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio, 
		Usuario 	= @Usuario,	  
		FechaSis	= @FechaSis,	
		SucOrigen	= @SucOrigen,	
		SucDestino	= @SucDestino
	where	Une_Identi	= @Une_Identi
	
	exec @Status = SOBITUSUALT 
	@Une_Identi,	@Une_Estatu,	@Fec_Actual,	@Usuario,		@SucOrigen,  
	@Biu_Canal,		@Biu_DesEst,	@NumTransac,	@Transaccio,	@Usuario,	  
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status = @Ent_Uno begin
		rollback
		return @Ent_Uno
	end
	
	if @@nestlevel = @Ent_Uno and @Une_Estatu = @Sta_Activo begin
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Usuario Activado',
				Use_Numero	= @Une_Identi
		return @Ent_Uno
	end
	
	if @@nestlevel = @Ent_Uno and @Une_Estatu = @Sta_Inacti and  @Str_Divisas = @Str_Uno begin
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Usuario Inactivo',
				Use_Numero	= @Une_Identi
		return @Ent_Uno
	end
	
	if @@nestlevel = @Ent_Uno and @Une_Estatu = @Sta_Cancelado and  @Str_Divisas = @Str_Uno begin
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Usuario Cancelado',
				Use_Numero	= @Une_Identi
		return @Ent_Uno
	end
end