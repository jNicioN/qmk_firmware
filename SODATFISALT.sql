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
** Fecha:	    19/03/2026      					                    ****
** Help:	    TRACL-16526  						                    ****
** Descripción:	Validaciones de regimen/CFDI y separacion de campos		****
** por tipo de personalidad												****
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
		@Ent_Existe	int,
		@Ent_Regime	int,
		@Ent_UsoCfd	int,
		@Ent_UcrId	int,
		@Tip_Person char(1)

								/* Declaracion de constantes */
declare	@Str_Vacio char(1),
		@Str_PM     char(1),
		@Str_PF     char(1),
		@Str_PFAE   char(1),
		@Str_Descri char(254),
		@Ent_Cero  int,
		@Ent_Uno   int


								/* Asignacion de valores a constantes */
select	@Str_Vacio = '',		/* String Vacio */
		@Str_PM	   = '1',		/* Persona Moral */
		@Str_PF	   = '2',		/* Persona Fisica */
		@Str_PFAE  = '3',		/* Persona Fisica AE */
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

if isnull(@Daf_UsoCfd, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'El Uso de CFDI no puede ser vacio.'
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

-- Obtenemos tipo de personalidad
SELECT @Tip_Person = Per_Tipo 
FROM SOPERSON noholdlock 
WHERE PerPersoID = @PerPersoID

if isnull(@Tip_Person, '') = '' begin
	select	Err_Codigo = '000015',
			Err_Mensaj = 'No se pudo obtener el tipo de personalidad'
	rollback
	return @Ent_Uno
end

-- Validamos catalogo FSREGFIS por tipo de persona
if @Tip_Person = @Str_PM begin
	select @Ent_Regime = Rfi_Id from FSREGFIS noholdlock 
	where Rfi_Moral = @Ent_Uno and Rfi_Id = @Daf_Regime and Rfi_Activo = @Ent_Uno
	
	if isnull(@Ent_Regime, @Ent_Cero) = @Ent_Cero begin
		
		select @Str_Descri = Rfi_Descri from FSREGFIS noholdlock where Rfi_Id = @Daf_Regime

		select	Err_Codigo = '000016',
				Err_Mensaj = 'No esta permitido para PM el regimen '+@Str_Descri
		rollback
		return @Ent_Uno
	end
	
	select @Ent_UsoCfd = Ucf_Id from FSUSOCFD noholdlock 
	where Ucf_Moral = @Ent_Uno and Ucf_Id = @Daf_UsoCfd and Ucf_Activo = @Ent_Uno
	
	if isnull(@Ent_UsoCfd, @Ent_Cero) = @Ent_Cero begin
		
		select @Str_Descri = Ucf_Descri from FSUSOCFD noholdlock where Ucf_Id = @Daf_UsoCfd

		select	Err_Codigo = '000017',
				Err_Mensaj = 'No esta permitido para PM el uso de CFDI '+@Str_Descri
		rollback
		return @Ent_Uno
	end
	
end else if (@Tip_Person = @Str_PF or @Tip_Person = @Str_PFAE) begin
	select @Ent_Regime = Rfi_Id from FSREGFIS noholdlock 
	where Rfi_Fisica = @Ent_Uno and Rfi_Id = @Daf_Regime and Rfi_Activo = @Ent_Uno
	
	if isnull(@Ent_Regime, @Ent_Cero) = @Ent_Cero begin
		
		select @Str_Descri = Rfi_Descri from FSREGFIS noholdlock where Rfi_Id = @Daf_Regime

		select	Err_Codigo = '000018',
				Err_Mensaj = 'No esta permitido para PF/PFAE el regimen '+@Str_Descri
		rollback
		return @Ent_Uno
	end
	
	select @Ent_UsoCfd = Ucf_Id from FSUSOCFD noholdlock 
	where Ucf_Fisica = @Ent_Uno and Ucf_Id = @Daf_UsoCfd and Ucf_Activo = @Ent_Uno
	
	if isnull(@Ent_UsoCfd, @Ent_Cero) = @Ent_Cero begin
		
		select @Str_Descri = Ucf_Descri from FSUSOCFD noholdlock where Ucf_Id = @Daf_UsoCfd

		select	Err_Codigo = '000019',
				Err_Mensaj = 'No esta permitido para PF/PFAE el uso de CFDI '+@Str_Descri
		rollback
		return @Ent_Uno
	end
end

--Validamos que tipos de regimenes fiscales pueden usar ciertos usos de CFDI
select @Ent_UcrId = Ucr_Id from FSUSOREG noholdlock 
where Ucr_RegFis = @Daf_Regime 
and Ucr_UsoCfd = @Daf_UsoCfd 
and Ucr_Activo = @Ent_Uno
	
if isnull(@Ent_UcrId, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo = '000020',
			Err_Mensaj = 'No esta permitido el regimen fiscal para ese uso de CFDI '
	rollback
	return @Ent_Uno
end

-- Separacion de campos por tipo de personalidad
if @Tip_Person = @Str_PM begin
	-- Para Persona Moral: Solo RazSoc, limpiar nombres
	if isnull(@Daf_RazSoc, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo = '000021',
				Err_Mensaj = 'Para Persona Moral la Razon Social es obligatoria'
		rollback
		return @Ent_Uno
	end
	-- Limpiar campos que no corresponden a PM
	select @Daf_Nombre = @Str_Vacio,
		   @Daf_ApePat = @Str_Vacio,
		   @Daf_ApeMat = @Str_Vacio
		   
end else if (@Tip_Person = @Str_PF or @Tip_Person = @Str_PFAE) begin
	-- Para Persona Fisica: Solo nombres/apellidos, limpiar RazSoc
	if isnull(@Daf_Nombre, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo = '000022',
				Err_Mensaj = 'Para Persona Fisica el Nombre es obligatorio'
		rollback
		return @Ent_Uno
	end
	
	-- Limpiar campo que no corresponde a PF
	select @Daf_RazSoc = @Str_Vacio
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
