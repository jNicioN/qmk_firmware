create procedure SOHISUSUALT (
	@Hiu_FolUsu		int,					
	@Hiu_Estatus	char(1),			
	@Hiu_FecEst		smalldatetime,		
	@Hiu_Usuari		char(3),				
	@Hiu_Sucurs		char(3),				
	@Hiu_Canal 		char(3),				
	@Hiu_DesEst 	char(180),			
		
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
** DESCRIPCION: ** Alta de Historico de Usuarios						****
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

if isnull(@Hiu_FolUsu, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000001',
			Err_Mensaj = 'El Folio del Usuario no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Hiu_Estatus, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'El Estatus no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if @Hiu_FecEst <= 'Jan 1 1990' begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Fecha de Estatus incorrecta',
			Err_Variab  = 'Biu_FecEst'
	rollback
	return @Ent_Uno
end

if isnull(@Hiu_Usuari, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'El Usuario no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Hiu_Sucurs, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'La Sucursal no puede ir vacia.'
	rollback
	return @Ent_Uno
end 

if isnull(@Hiu_Canal, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000006',
			Err_Mensaj = 'El Canal no puede ir vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Hiu_DesEst, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000007',
			Err_Mensaj = 'La Descripcion de la bitacora no puede ir vacia.'
	rollback
	return @Ent_Uno
end 


insert into SOHISUSU ( 
	Hiu_FolUsu, Hiu_Estatus, Hiu_FecEst, Hiu_Usuari,
	Hiu_Sucurs, Hiu_Canal,   Hiu_DesEst, NumTransac,
	Transaccio, Usuario,	 FechaSis,	 SucOrigen,	 
	SucDestino)
	values (
	@Hiu_FolUsu, @Hiu_Estatus, @Hiu_FecEst, @Hiu_Usuari,
	@Hiu_Sucurs, @Hiu_Canal,   @Hiu_DesEst, @NumTransac,
	@Transaccio, @Usuario,	   @FechaSis,	@SucOrigen,	
	@SucDestino)
	
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'
		