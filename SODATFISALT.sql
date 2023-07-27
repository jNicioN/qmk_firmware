create procedure SODATFISALT (
	@PerPersoID		int,	
	@Daf_Nombre		varchar(254),
	@Daf_Regime		int,
	@Daf_UsoCfd		int,
	@Daf_ApePat		varchar(254),
	@Daf_ApeMat		varchar(254),
	@Daf_RazSoc		varchar(254),
		
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
** DESCRIPCION: ** Alta en la tabla  SODATFISALT   ****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Modificó:	Javier Eduardo Ceron Rangel		                    	****
** Fecha:	    28/07/2023      					                    ****
** Help:	    TRACL-5359 						                        ****
** Descripción:	Se agrega UPPER para guardar informacion en MAYUSCULAS	****
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

if isnull(@Daf_Regime, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'El Regimen no puede ser vacio.'
	rollback
	return @Ent_Uno
end 

if isnull(@Daf_Nombre, @Str_Vacio) = @Str_Vacio and isnull(@Daf_RazSoc, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000006',
			Err_Mensaj = 'El Nombre o Razon Social no puede ser vacio.',
			Err_Variab = 'Daf_Nombre Daf_RazSoc'
	rollback
	return @Ent_Uno	
end 


/*  Revisar si ya existe la relacion  */
select	@Ent_Existe	= @Ent_Cero
select	@Ent_Existe	= @Ent_Uno
from    SODATFIS noholdlock
where 	 PerPersoID = @PerPersoID

if @Ent_Existe = @Ent_Uno begin
	select	Err_Codigo = '000008',
			Err_Mensaj = 'Ya existe registro con el mismo PersonID'
	rollback
	return @Ent_Uno
end

select  @Daf_Nombre = UPPER(@Daf_Nombre),
		@Daf_ApePat = UPPER(@Daf_ApePat),
		@Daf_ApeMat = UPPER(@Daf_ApeMat),
		@Daf_RazSoc = UPPER(@Daf_RazSoc)

insert into SODATFIS (PerPersoID,  Daf_Nombre , Daf_Regime, Daf_UsoCfd, Daf_ApePat, 
					Daf_ApeMat, Daf_RazSoc, NumTransac,	Transaccio, Usuario, 
					FechaSis, SucOrigen, SucDestino)
	values (@PerPersoID, @Daf_Nombre, @Daf_Regime, @Daf_UsoCfd, @Daf_ApePat, 
			@Daf_ApeMat, @Daf_RazSoc, @NumTransac, @Transaccio, @Usuario, 
			@FechaSis, @SucOrigen, @SucDestino)
	
exec @Status = SOBIDAFIALT 
	@PerPersoID, @Daf_Nombre, @Daf_Regime, @Daf_UsoCfd, 
	@Daf_ApePat, @Daf_ApeMat, @Daf_RazSoc,	@NumTransac,	
	@Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo
	

	
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @@nestlevel = @Ent_Uno
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro realizado'
