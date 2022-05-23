create procedure SOBIDAFIALT (
	@PerPersoID	    int,	
	@Bdf_Nombre		varchar(254),
	@Bdf_Regime     int,
	@Bdf_UsoCfd		int,
	@Bdf_ApePat		varchar(254),
	@Bdf_ApeMat		varchar(254),
	@Bdf_RazSoc		varchar(254),	
		
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
** DESCRIPCION: ** Alta en la tabla SOBIDAFI							****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		José Antonio Mandujano Salgado							****
** Fecha:		03/05/2022   											****
** Help Desk:	1621179	 									 			****
****************************************************************************
**/

								/* Declaracion de variables */
declare @Status		int,
		@Ent_Existe	int

								/* Declaracion de constantes */
declare	@Str_Vacio char(1),
		@Ent_Cero  int,
		@Ent_Uno   int


								/* Asignacion de valores a constantes */
select	@Str_Vacio = '',		/* String Vacio */
		@Ent_Cero  = 0,			/* Entero cero */
		@Ent_Uno   = 1			/* Entero uno */


/* Validacion general de parametros vacios */

if isnull(@PerPersoID, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000001',
			Err_Mensaj = 'El PersonID no puede ser vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Bdf_Regime, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'El Regimen no puede ser vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Bdf_Nombre, @Str_Vacio) = @Str_Vacio and isnull(@Bdf_RazSoc, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000006',
			Err_Mensaj = 'El Nombre o Razon Social no puede ser vacio.',
			Err_Variab = 'Bdf_Nombre Bdf_RazSoc'
	rollback
	return @Ent_Uno	
end 


insert into SOBIDAFI (
				PerPersoID, Bdf_Nombre, Bdf_Regime, Bdf_UsoCfd, 
				Bdf_ApePat, Bdf_ApeMat, Bdf_RazSoc, NumTransac,	
				Transaccio, Usuario, FechaSis, SucOrigen, SucDestino)
	values (
	@PerPersoID, @Bdf_Nombre, @Bdf_Regime, @Bdf_UsoCfd, 
	@Bdf_ApePat, @Bdf_ApeMat, @Bdf_RazSoc, @NumTransac,	
	@Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'
