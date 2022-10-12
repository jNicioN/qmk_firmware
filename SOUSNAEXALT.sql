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
** Modifico:	Martin Adonis Lopez Mendoza								****
** Fecha:		01/09/2022												****
** Help Desk:	1643006										 			****
** Descripción:	Se agrega estatus cancelado								****
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
declare	@Ent_Existe	int,
		@Une_IdeInt	int,
		@Status		int,
		@Fec_Actual  	smalldatetime,	
		@Fec_IniMes		smalldatetime,
		@Fec_FinMes 	smalldatetime
		
								/* Declaracion de constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Cero	varchar(1),
		@Str_LetraI varchar(1),
		@Biu_Canal	int,
		@Biu_DesEst	varchar(180),
		@Sta_Inacti varchar(1)


								/* Asignacion de valores a constantes */
select	@Str_Vacio	= '',		/* String Vacio */
		@Ent_Cero	= 0,			/* Entero cero */
		@Ent_Uno	= 1,			/* Entero uno */
		@Str_Cero	= '0',		/* String Cero */
		@Str_LetraI	= 'I',		/* String Letra I */
		@Biu_Canal	= 5,			/* Canal de originacion del usuario correspondiente a Apertura*/
		@Biu_DesEst	= 'Creacion de Usuario de compra venta',  /* Descripcion para la bitacora */
		@Sta_Inacti = 'I'		/* Estatus inactivo */


select @Une_IdeInt = (convert(int, str_replace(ltrim(str_replace(@Une_IdeUsu , '0', ' ')),' ', '0') ))

/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct
from SOPARAMS noholdlock
where Par_Sucurs = @SucOrigen

/*Fecha de inicio y fin de mes*/
select @Fec_IniMes = dateadd(dd, 1 - datepart(dd, @Fec_Actual), @Fec_Actual)
select @Fec_FinMes = dateadd(dd, -1, dateadd(mm,  1, @Fec_IniMes))

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

insert into SOUSNAEX ( 
	Une_Identi,	Une_IdeUsu,	Une_TabOri,	Une_Estatu, Une_Migrad,	
	Une_FecReg,	Une_FecEst,	NumTransac,	Transaccio,	Usuario,	
	FechaSis,	SucOrigen,	SucDestino)
	values (
	@Une_Identi,	@Une_IdeInt,	@Une_TabOri,	@Str_LetraI,	@Str_Cero, 
	@FechaSis,		@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,	   
	@FechaSis,		@SucOrigen,		@SucDestino)

exec @Status = SOBITUSUALT 
	@Une_Identi,	@Str_LetraI,	@FechaSis,		@Usuario,		@SucOrigen,  
	@Biu_Canal,		@Biu_DesEst,	@NumTransac,	@Transaccio,	@Usuario,	  
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'