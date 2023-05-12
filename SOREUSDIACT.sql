create procedure SOREUSDIACT (
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
** Creo:	Francisco Minajas										****
** Fecha:		04/05/2023												****
** JIRA:		TRAAC-1450 									 			****
** Descripción:	Se crea sp atomico de actualizacion						****
****************************************************************************
**/
declare	@Use_NoCoUs 	varchar(150),			/* Declaración de Variables */
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
		@Str_I			char(1),
		@Une_TaOrNa		char(1),	
		@Une_TaOrEx		char(1), 
		@Tip_Client		char(1),
		@Tip_Nomina		char(1),
		@Ent_CieDos		smallint,
		@Str_Punto		char(1),
		@Str_Guion		char(1),
		@Sta_Cancel		char(1)
		

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
		@Str_I		= 'I',					-- Leta A
		@Une_TaOrNa	= '1',					/*tabla origen nacionales SOPERSON */
		@Une_TaOrEx	= '2',					/*tabla origen extranjeros SOUSUEXT*/
		@Tip_Client	= 'C',					/* Tipo: Cliente					*/
		@Tip_Nomina	= 'N',					/* Tipo: Cliente Nomina				*/
		@Ent_CieDos	= 102,					/* Entero: CientoDos						*/
		@Str_Punto	= '.',					/* String: Punto							*/
		@Str_Guion	= '-',					/* String: Guion							*/
		@Sta_Cancel = 'C'

/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct from SOPARAMS noholdlock where Par_Sucurs = @SucOrigen
			
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
		
	update SOUSNAEX set 
		Une_Estatu	= @Une_Estatu,
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio, 
		Usuario 	= @Usuario,	  
		FechaSis	= @FechaSis,	
		SucOrigen	= @SucOrigen,	
		SucDestino	= @SucDestino
	where	Une_Identi	= @Une_Identi
	
	exec @Status = SOBITUSUALT 
	@Une_Identi,	@Une_Estatu,	@FechaSis,		@Usuario,		@SucOrigen,  
	@Biu_Canal,		@Biu_DesEst,	@NumTransac,	@Transaccio,	@Usuario,	  
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status = @Ent_Uno begin
		rollback
		return @Ent_Uno
	end
	
	if @@nestlevel = @Ent_Uno and @Une_Estatu = @Sta_Activo
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Usuario Activado',
				Use_Numero	= @Une_Identi
		return @Ent_Uno
		
end
