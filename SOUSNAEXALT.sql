create procedure SOUSNAEXALT (
	@Une_Identi		int,								
	@Une_IdeUsu     varchar(8),		                       
	@Une_TabOri		varchar(1),						

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
** DESCRIPCION: ** Alta de Relacion Usuarios Nacionales y Extranjeros   ****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Modifico:	Francisco Minajas										****
** Fecha:		16/06/2023												****
** Jira:	    TRAAC-1542									 			****
** Descripción:	Se elimina select innecesario							****
****************************************************************************
** Modifico:	Francisco Minajas										****
** Fecha:		23/01/2023												****
** Jira:	    TRAAC-1162									 			****
** Descripción:	Se agrega consulta de fecha x sucursal					****
****************************************************************************
** Modifico:	Martin Adonis Lopez Mendoza	/ Francisco Minajas			****
** Fecha:		09/01/2023												****
** Jira:	    TRAAC-1162									 			****
** Descripción:	Se agrega estatus cancelado	y se valida mes calendario	****
****************************************************************************
** Modifico:	Erika Báez	 											****
** Fecha:		17/Marzo/2021											****
** Help Desk:	1376175										 			****
** Descripción:	Se cambia mensaje de error								****
****************************************************************************
** Modifico:	Carlos Copto 											****
** Fecha:		15/Diciembre/2020										****
** Help Desk:	1376175										 			****
** Descripción:	Se agrega registro a Bitacora							****
****************************************************************************
** Creo:		Carlos Copto											****
** Fecha:		10/07/2020   											****
** Help Desk:	1376175										 			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Ent_Existe		int,
		@Ent_Existe_usuario	int,
		@Une_IdeInt		int,
		@Status			int,
		@Fec_Actual  	smalldatetime,	
		@Fec_IniMes		smalldatetime,
		@Fec_FinMes 	smalldatetime,
		@Fec_Cancel 	smalldatetime,
		@Fec_CanInt 	date,
		@Fec_IniInt 	date
		
								/* Declaracion de constantes */
declare	@Str_Vacio		char(1),
		@Ent_Cero		int,
		@Persona 		int,
		@Ent_Existio_activo	int,
		@Ent_Uno		int,
		@Str_Cero		varchar(1),
		@Str_LetraI 	varchar(1),
		@Biu_Canal		int,
		@Biu_DesEst		varchar(180),
		@Sta_Inacti 	varchar(1),		
		@Str_Status 	char(1),
		@Str_StaCan 	char(1),
		@Str_Uno		char(1),
		@Str_Divisas   	char(8),
		@Str_Comple    	varchar(222),
		@UsuDivi		int,
		@Ent_Time   	int
								/* Asignacion de valores a constantes */
select	@Str_Vacio	= '',		/* String Vacio */
		@Ent_Cero	= 0,			/* Entero cero */
		@Ent_Uno	= 1,			/* Entero uno */
		@Str_Cero	= '0',		/* String Cero */
		@Str_LetraI	= 'I',		/* String Letra I */
		@Biu_Canal	= 5,			/* Canal de originacion del usuario correspondiente a Apertura*/
		@Biu_DesEst	= 'Creacion de Usuario de compra venta',  /* Descripcion para la bitacora */
		@Sta_Inacti = 'I',		/* Estatus inactivo */
		@Str_Uno 	= '1',
		@Str_Status = 'A',
		@Str_StaCan = 'C',
		@UsuDivi 	= 0,
		@Ent_Time 	= 0,
		@Ent_Existio_activo	= 0
		
select @Une_IdeInt = (convert(int, str_replace(ltrim(str_replace(@Une_IdeUsu , '0', ' ')),' ', '0') ))
/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct	from SOPARAMS noholdlock where Par_Sucurs = @SucOrigen 
/*Fecha de inicio y fin de mes*/
select @Fec_IniMes = dateadd(dd, 1 - datepart(dd, @Fec_Actual), @Fec_Actual)
select @Fec_FinMes = dateadd(dd, -1, dateadd(mm,  1, @Fec_IniMes))
--activar cambio de divisas
select @Str_Divisas=Par_Valor from SOPARGEN noholdlock where Par_Nombre = 'UsuarioDivisas'

/* Validacion general de parametros vacios */
if isnull(@Une_Identi, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El ID no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Une_IdeUsu, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El ID de la tabla del usuario no puede ir vacio.'
	rollback
	return @Ent_Uno
end

if isnull(@Une_TabOri, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La tabla de Origen no debe ir vacia'
	rollback
	return @Ent_Uno
end 

select @Str_Comple = (ltrim(rtrim(Per_ApePat))+' '+ltrim(rtrim(Per_ApeMat))+' '+ltrim(rtrim(Per_Nombre)))
		from SOPERSON noholdlock 
		where PerPersoID = @Une_IdeInt

select 	Per_ID =   PerPersoID ,
		Per_Numero = Per_Numero,
		Per_RFC = Per_RFC
		into #Personas
		from SOPERSON noholdlock 
		where Per_Comple = @Str_Comple
		
select 	Per_ID =  Per_ID,
		Per_Numero = Per_Numero,
		Per_RFC = Per_RFC
		into #PersonasConMismoNombre
		from #Personas noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero

select  @Persona = count(*) from #PersonasConMismoNombre noholdlock
		
	select	@Ent_Existe_usuario	= @Ent_Cero
	select	@Ent_Existe_usuario	= @Ent_Uno
	from #PersonasConMismoNombre noholdlock
	inner join SOUSNAEX noholdlock on Une_IdeUsu = Per_ID 
	where Une_TabOri=@Str_Uno and  Une_Estatu = @Str_LetraI

drop table 	#Personas
		
if @Ent_Existe_usuario = @Ent_Uno begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'El usuario ya fue creado anteriormente'
	rollback
	return @Ent_Uno
end

/*  Revisar si ya existe la relacion  */	
select	@Ent_Existe_usuario	= @Ent_Cero
select	@Ent_Existe	= @Ent_Uno
	from SOUSNAEX noholdlock
	where	Une_IdeUsu	= @Une_IdeInt 
	  and	Une_TabOri = @Une_TabOri
	  
if @Ent_Existe = @Ent_Uno begin
	
	/*CALCULO DE ACTIVOS*/
	select	@Ent_Existio_activo = count(*) 
	from SOUSNAEX noholdlock
	inner join SOBITUSU noholdlock on  Biu_FolUsu  = Une_Identi 
	where	Une_IdeUsu	= @Une_IdeInt and   Biu_Estatu  = @Str_Status
	
	/*fin de calculo de activos*/
	/*MES CALENDARIO*/
	select	TOP 1 @UsuDivi = Une_Identi
		from SOUSNAEX noholdlock
		where	Une_IdeUsu	= @Une_IdeInt 
		  and	Une_TabOri = @Une_TabOri
		  and  Une_Estatu  = @Str_StaCan
		order by  Une_FecEst DESC
			
	if @UsuDivi <> @Ent_Cero and @Ent_Existio_activo > 0 begin
		
		select @Fec_Cancel = Biu_FecEst from SOBITUSU noholdlock
			where Biu_FolUsu   = @UsuDivi 
			and   Biu_Estatu   = @Str_StaCan
			order by  Biu_FecEst DESC
		
		-- OBtencion de la fecha del siguiente mes calendario
		select @Fec_Cancel = dateadd(dd, 1 - datepart(dd, @Fec_Cancel), @Fec_Cancel)
		select @Fec_Cancel = dateadd(dd, 1, dateadd(mm,  1, @Fec_Cancel))
		select @Fec_Cancel = dateadd(dd, 1 - datepart(dd, @Fec_Cancel), @Fec_Cancel)
		
		-- se elimina la hora de ambas fechas
		select @Fec_CanInt = @Fec_IniMes
		select @Fec_IniInt = @Fec_Cancel
		
		select @Ent_Time = datediff(mm, @Fec_Cancel, @Fec_CanInt)
		
		if @Ent_Time < 0 begin
			select	Err_Codigo = '000004',
				Err_Mensaj = 'No se puede dar de alta como usuario, favor aperturar como cliente o regresar el siguiente mes.'
				rollback
			return @Ent_Uno
		end
	end
end

if @Str_Divisas = @Str_Uno begin 
	select @Str_Status = @Str_LetraI
end 
insert into SOUSNAEX ( 
	Une_Identi,	Une_IdeUsu,	Une_TabOri,	Une_Estatu, Une_Migrad,	
	Une_FecReg,	Une_FecEst,	NumTransac,	Transaccio,	Usuario,	
	FechaSis,	SucOrigen,	SucDestino)
	values (
	@Une_Identi,	@Une_IdeInt,	@Une_TabOri,	@Str_Status,	@Str_Cero, 
	@Fec_Actual,	@Fec_Actual,	@NumTransac,	@Transaccio,	@Usuario,	   
	@FechaSis,		@SucOrigen,		@SucDestino)

exec @Status = SOBITUSUALT 
	@Une_Identi,	@Str_LetraI,	@Fec_Actual,	@Usuario,		@SucOrigen,  
	@Biu_Canal,		@Biu_DesEst,	@NumTransac,	@Transaccio,	@Usuario,	  
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'