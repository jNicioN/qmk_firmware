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
** Modifico:	Juan Jose Sandoval Marin								****
** Fecha:		22/Julio/2021											****
** Help Desk:	1376175										 			****
** Descripción:	Se cambia para que usuario nazca con estatus inactivo	****
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
		@Status		int
		
								/* Declaracion de constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Cero	varchar(1),
		@Str_LetraI varchar(1),
		@Biu_Canal	int,
		@Biu_DesEst	varchar(180)

								/* Asignacion de valores a constantes */
select	@Str_Vacio	= '',		/* String Vacio */
		@Ent_Cero	= 0,			/* Entero cero */
		@Ent_Uno	= 1,			/* Entero uno */
		@Str_Cero	= '0',		/* String Cero */
		@Str_LetraI	= 'I',		/* String Letra I */
		@Biu_Canal	= 5,			/* Canal de originacion del usuario correspondiente a Apertura*/
		@Biu_DesEst	= 'Creacion de Usuario de compra venta'  /* Descripcion para la bitacora */

select @Une_IdeInt = (convert(int, str_replace(ltrim(str_replace(@Une_IdeUsu , '0', ' ')),' ', '0') ))

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

/*  Revisar si ya existe la relacion  */	
select	@Ent_Existe	= @Ent_Cero
select	@Ent_Existe	= @Ent_Uno
	from SOUSNAEX noholdlock
	where	Une_IdeUsu	= @Une_IdeInt 
	  and	Une_TabOri = @Une_TabOri
	
if @Ent_Existe = @Ent_Uno begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'No se puede dar de alta usuario, favor aperturar cliente'
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