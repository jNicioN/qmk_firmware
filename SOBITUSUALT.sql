create procedure SOBITUSUALT (
	@Biu_FolUsu		int,				
	@Biu_Estatus	char(1),				
	@Biu_FecEst		smalldatetime,		
	@Biu_Usuari		char(6),			
	@Biu_Sucurs		char(3),			
	@Biu_Canal 		int,			
	@Biu_DesEst 	char(180),		
		
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
** DESCRIPCION: ** Alta de Bitacora de Usuarios						    ****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		Carlos Copto											****
** Fecha:		09/12/2020   											****
** Help Desk:	1376175										 			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Ent_Existe	int,
		@Une_IdeInt int
		
								/* Declaracion de constantes */
declare	@Str_Vacio char(1),
		@Ent_Cero  int,
		@Ent_Uno   int

								/* Asignacion de valores a constantes */
select	@Str_Vacio = '',		/* String Vacio */
		@Ent_Cero  = 0,			/* Entero cero */
		@Ent_Uno   = 1			/* Entero uno */

/* Validacion general de parametros vacios */

if isnull(@Biu_FolUsu, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000001',
			Err_Mensaj = 'El Folio del Usuario no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Biu_Estatus, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'El Estatus no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if @Biu_FecEst <= 'Jan 1 1990' begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Fecha de Estatus incorrecta',
			Err_Variab  = 'Biu_FecEst'
	rollback
	return @Ent_Uno
end

if isnull(@Biu_Usuari, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'El Usuario no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Biu_Sucurs, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'La Sucursal no puede ir vacia.'
	rollback
	return @Ent_Uno
end 

if isnull(@Biu_Canal, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000006',
			Err_Mensaj = 'El Canal no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Biu_DesEst, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000007',
			Err_Mensaj = 'La Descripcion de la bitacora no puede ir vacia.'
	rollback
	return @Ent_Uno
end 

insert into SOBITUSU ( 
	Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari, Biu_Sucurs, 
	Biu_Canal,   Biu_DesEst, NumTransac, Transaccio, Usuario,	 
	FechaSis,	 SucOrigen,	 SucDestino)
	values (
	@Biu_FolUsu, @Biu_Estatus, 	@Biu_FecEst, @Biu_Usuari, @Biu_Sucurs, 
	@Biu_Canal,  @Biu_DesEst, 	@NumTransac, @Transaccio, @Usuario,	 
	@FechaSis,	 @SucOrigen,	@SucDestino)
	
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'