create procedure SOUSNAEXPRO (
	@Une_Nombre	varchar(180),
	@Une_FecNac	smalldatetime,
	@ClClientID	int,
	@Cli_Numero	char(8),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**
****************************************************************************
** DESCRIPCION: ** Inactiva Usuarios de Compra Venta					****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Modifico:	Ezequiel Gonzalez Cobix									****
** Fecha:		31/08/2023												****
** Key Jira:	TRAAC-2131 									 			****
** DescripciÃ³n:Al activar una cuenta, se asigna el mismo estatus
				que se asigno en SOUSNAEX a SOBITUSU					****
****************************************************************************
** Modifico:	Martin Adonis Lopez										****
** Fecha:		30/08/2022												****
** Help Desk:	1643006 									 			****
** DescripciÃ³n:	Se ajusto la actualizacion de usuarios activos 
					e inactivos a cancelado								****
****************************************************************************
** Modifico:	Adriana Gomez											****
** Fecha:		05/05/2021												****
** Help Desk:	1376175 									 			****
** DescripciÃ³n:	Se  ajusta validacion de fecha de nacimiento			****
****************************************************************************
** Modifico:	Erika BÃ¡ez	 											****
** Fecha:		17/03/2021												****
** Help Desk:	1376175										 			****
** Descri:		Se agregan parametros generales para tabla SOSUNAEX		****
****************************************************************************
** Modifico:	Erika BÃ¡ez	 											****
** Fecha:		17/03/2021												****
** Help Desk:	1376175										 			****
** Descri:		Se agrega insert a bitacora VEBITADD y se actualiza		****
**				VEACUDLL para volver los movientos de usuario a cte		****
****************************************************************************
** Modifico:	Adriana Gomez 											****
** Fecha:		05/03/2021												****
** Help Desk:	1468365										 			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Fec_Actual		smalldatetime,	
		@Fec_IniMes		smalldatetime,
		@Fec_FinMes		smalldatetime
									
								/* Declaracion de constantes */
declare	@Sta_Activo		char(1),
		@Sta_Inacti		char(1),
		@Sta_Cancel		char(1),
		@Une_TaOrNa		char(1),	
		@Une_TaOrEx		char(1)	,
		@Biu_DesEst		varchar(150),
		@Biu_Canal		int,
		@Str_Usuari		char(1),
		@Str_Client		char(1),
		@Ent_CieDos		smallint,
		@Str_Punto		char(1),
		@Str_Guion		char(1),
		@Str_Ceros		char(8),
		@Ent_Ocho		int,
		@Str_Divisas   	char(8),
		@Str_Status 	char(1),
		@Str_Uno		char(1)

								/* Asignacion de valores a constantes */
select	@Sta_Activo	= 'A',		/* Estatus activo */
		@Sta_Inacti	= 'I',		/* Estatus inactivo */
		@Sta_Cancel = 'C',
		@Une_TaOrNa	= '1',		/*tabla origen nacionales SOPERSON */
		@Une_TaOrEx	= '2',		/*tabla origen extranjeros SOUSUEXT*/
		@Biu_DesEst	= 'Inactivacion de Usuario de compra venta por actvacion de Cuenta',  /*descripcion de inactivacion de usuarios de cv */
		@Biu_Canal	= 5,		/* canal */
		@Str_Client	= 'C',		/*Tipo Cliente*/
		@Str_Usuari	= 'U',		/*Tipo Usuario */
		@Ent_CieDos	= 102,		/* Entero: CientoDos						*/
		@Str_Punto	= '.',		/* String: Punto							*/
		@Str_Guion	= '-',		/* String: Guion							*/
		@Str_Ceros	= '00000000',/*String ceros*/
		@Ent_Ocho	= 8,
		@Str_Uno = '1',
		@Str_Status = 'I'

/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct
from SOPARAMS noholdlock
where Par_Sucurs = @SucOrigen
--activar cambio de divisas
select @Str_Divisas=Par_Valor from  SOPARGEN where Par_Nombre = 'UsuarioDivisas'

/*Fecha de inicio y fin de mes*/
select @Fec_IniMes = dateadd(dd, 1 - datepart(dd, @Fec_Actual), @Fec_Actual)
select @Fec_FinMes = dateadd(dd, -1, dateadd(mm,  1, @Fec_IniMes))					

if @Str_Divisas = @Str_Uno begin 
	/*se buscan concidencias en personas */
			insert into SOBITUSU	(Biu_FolUsu,	Biu_Estatu,	Biu_FecEst,	Biu_Usuari,	Biu_Sucurs, 
									 Biu_Canal,	Biu_DesEst,	NumTransac,	Transaccio,	Usuario,	 
									 FechaSis,		SucOrigen,	SucDestino)
				select		Une_Identi,	@Sta_Cancel,	@FechaSis,		@Usuario,	@SucOrigen,
							@Biu_Canal,	@Biu_DesEst,	@NumTransac,	@Transaccio, @Usuario,	
							@FechaSis,	@SucOrigen,		@SucDestino
					from SOPERSON noholdlock 
					inner join SOPERADI noholdlock on	Adi_PerNum	= Per_Numero 
					inner join SOUSNAEX noholdlock on	PerPersoID	= Une_IdeUsu and Une_TabOri	= @Une_TaOrNa
					where	Per_Comple	= @Une_Nombre 
					  and   convert(date, Adi_FecNac) = convert(date, @Une_FecNac)
					  and	(Une_Estatu	= @Sta_Activo or Une_Estatu = @Sta_Inacti)
			  
			  /* se busca en extranjeros el numero de usuario por nombre y fecha de nacimiento*/
			insert into SOBITUSU	(Biu_FolUsu,	Biu_Estatu,	Biu_FecEst,	Biu_Usuari,	Biu_Sucurs, 
									 Biu_Canal,		Biu_DesEst,	NumTransac,	Transaccio,	Usuario,	 
									 FechaSis,	 SucOrigen,		SucDestino)
				select	Une_Identi,	@Sta_Cancel,	@FechaSis,	@Usuario,	@SucOrigen,
						@Biu_Canal,	@Biu_DesEst,	@NumTransac,	@Transaccio, @Usuario,	
						@FechaSis,	@SucOrigen,		@SucDestino
				from SOUSUEXT noholdlock 
				inner join SOUSNAEX noholdlock on	Une_IdeUsu	= Use_IdUsEx and	Une_TabOri =@Une_TaOrEx
				where	Use_NoCoUs	= @Une_Nombre
				  and   convert(date, Use_FecNac)	= convert(date, @Une_FecNac)
				  and	(Une_Estatu	= @Sta_Activo or Une_Estatu = @Sta_Inacti)
	  	  
end else begin
/*se buscan concidencias en personas */
	insert into SOBITUSU	(Biu_FolUsu,	Biu_Estatu,	Biu_FecEst,	Biu_Usuari,	Biu_Sucurs, 
							 Biu_Canal,	Biu_DesEst,	NumTransac,	Transaccio,	Usuario,	 
							 FechaSis,		SucOrigen,	SucDestino)
		select		Une_Identi,	@Sta_Inacti,	@FechaSis,		@Usuario,	@SucOrigen,
					@Biu_Canal,	@Biu_DesEst,	@NumTransac,	@Transaccio, @Usuario,	
					@FechaSis,	@SucOrigen,		@SucDestino
			from SOPERSON noholdlock 
			inner join SOPERADI noholdlock on	Adi_PerNum	= Per_Numero 
			inner join SOUSNAEX noholdlock on	PerPersoID	= Une_IdeUsu and Une_TabOri	= @Une_TaOrNa
			where	Per_Comple	= @Une_Nombre 
			  and   convert(date, Adi_FecNac) = convert(date, @Une_FecNac)
			  and	Une_Estatu	= @Sta_Activo
		  
		  /* se busca en extranjeros el numero de usuario por nombre y fecha de nacimiento*/
	insert into SOBITUSU	(Biu_FolUsu,	Biu_Estatu,	Biu_FecEst,	Biu_Usuari,	Biu_Sucurs, 
							 Biu_Canal,		Biu_DesEst,	NumTransac,	Transaccio,	Usuario,	 
							 FechaSis,	 SucOrigen,		SucDestino)
		select	Une_Identi,	@Sta_Inacti,	@FechaSis,	@Usuario,	@SucOrigen,
				@Biu_Canal,	@Biu_DesEst,	@NumTransac,	@Transaccio, @Usuario,	
				@FechaSis,	@SucOrigen,		@SucDestino
		from SOUSUEXT noholdlock 
		inner join SOUSNAEX noholdlock on	Une_IdeUsu	= Use_IdUsEx and	Une_TabOri =@Une_TaOrEx
		where	Use_NoCoUs	= @Une_Nombre
		  and   convert(date, Use_FecNac)	= convert(date, @Une_FecNac)
		  and	Une_Estatu	= @Sta_Activo

end 

	

/*Buscar movimientos de usuarios para pasarlos a la bitacora*/
insert into VEBITADD	(Bit_Client,	Bit_Usuari,	Bit_NumTra,	Bit_Monto,	Bit_Fecha,
						 Bit_TipOpe,	NumTransac,	Transaccio,		Usuario,	FechaSis,
						 SucOrigen,	SucDestino)
	select	@ClClientID,	Biu_FolUsu,		Adl_NumTra,		Adl_Monto,	Adl_Fecha,
			Adl_TipOpe,		@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	
			@SucOrigen,		@SucDestino	
		from  SOBITUSU s noholdlock 
			 inner join  VEACUDLL noholdlock on Adl_Fecha >= @Fec_IniMes and Adl_Fecha <= @Fec_FinMes  
											 and Adl_NumCli = right(@Str_Ceros + ltrim(rtrim(convert(char, Biu_FolUsu))), @Ent_Ocho) and Adl_TipCli	= @Str_Usuari
		where	s.NumTransac	= @NumTransac 
		  
/*Actulizar movimientos de usuarios a cliente*/  
update VEACUDLL set
	Adl_TipCli	= @Str_Client,
	Adl_NumCli	= @Cli_Numero,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	from VEBITADD v noholdlock 
	where	Adl_NumTra	= Bit_NumTra
	  and  v.NumTransac	= @NumTransac 
	  	

if @Str_Divisas = @Str_Uno begin 
	select @Str_Status = @Sta_Cancel
end 
		
update SOUSNAEX set 
	Une_Estatu	= @Str_Status,
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	from SOBITUSU noholdlock
	inner join SOUSNAEX noholdlock on	Biu_FolUsu	= Une_Identi 
	where	SOBITUSU.NumTransac	= @NumTransac