create procedure SODATFISMOD (
	@PerPersoID	    int,
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
** DESCRIPCION: ** Modificacion en la tabla SODATFIS por PerPersoID ****
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
declare @Status		int

/*Declaración Constantes*/
declare	@Ent_Cero   int,        /* Entero en Cero */
		@Ent_Uno	int,		/* Entero uno     */
		@Str_Vacio	char(1)

/*Asignación Constantes*/
select	@Str_Vacio = '',		/* String Vacio */
		@Ent_Cero   = 0,		/* Entero en Cero	*/
		@Ent_Uno	= 1			/* Entero uno		*/

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

select  @Daf_Nombre = UPPER(@Daf_Nombre),
		@Daf_ApePat = UPPER(@Daf_ApePat),
		@Daf_ApeMat = UPPER(@Daf_ApeMat),
		@Daf_RazSoc = UPPER(@Daf_RazSoc)

update SODATFIS  set
	Daf_Nombre = @Daf_Nombre,
	Daf_Regime = @Daf_Regime,
	Daf_UsoCfd = @Daf_UsoCfd,
	Daf_ApePat = @Daf_ApePat,
	Daf_ApeMat = @Daf_ApeMat,
	Daf_RazSoc = @Daf_RazSoc,	
	NumTransac = @NumTransac,
	Transaccio = @Transaccio,
	Usuario = @Usuario,
	FechaSis = @FechaSis,
	SucOrigen = @SucOrigen,
	SucDestino = @SucDestino
where PerPersoID = @PerPersoID

exec @Status = SOBIDAFIALT 
	@PerPersoID, @Daf_Nombre, @Daf_Regime, @Daf_UsoCfd, 
	@Daf_ApePat, @Daf_ApeMat, @Daf_RazSoc,	@NumTransac,	
	@Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo

if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Modificado'
	
