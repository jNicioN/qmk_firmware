create procedure SOPAISALT(
	@Pai_Nombre	varchar(30),
	@Pai_Abrevi	varchar(10),
	@Pai_ISR	smallmoney,
	@Pai_Gentil	varchar(30),	
	@Pai_IdeBMX	char(3),
	@Pai_IdCNBV	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @SoPaisID	int,					/* Declaracion de Variables */
		@Pai_Numero	char(3),
		@Status		int

declare	@Str_Vacio	char(1),				/* Declaración de Constantes */
		@Tab_Nombre	char(8)		


/* Asignación de Constantes */
select	@Str_Vacio	= '',				/* String Vacío */
		@Tab_Nombre	= 'SOPAIS'			/* Nombre de la Tabla */

select	@FechaSis = getdate()

/* Validación del Nombre */
if isnull(@Pai_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error.- Descripcion del Nombre incorrecta',
			Err_Variab	= 'Pai_Nombre'
	rollback
	return 1
end


/* Validación de la Abreviación */
if isnull(@Pai_Abrevi, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error.- Abreviación incorrecta',
			Err_Variab	= 'Pai_Abrevi'
	rollback
	return 1
end


/* Validación  del ISR */
if @Pai_ISR < 0 or @Pai_ISR > 100 begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error.- ISR incorrecto', 
			Err_Variab	= 'Pai_ISR'
	rollback
	return 1
end 


/* Validación del Gentilicio */
if isnull(@Pai_Gentil, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error.- Gentilicio incorrecto',
			Err_Variab	= 'Pai_Gentil'
	rollback
	return 1
end


/* Validación del País Identificador de BMX */
if isnull(@Pai_IdeBMX, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error.- Pais Identificador de BMX incorrecto',
			Err_Variab	= 'Pai_IdeBMX'
	rollback
	return 1
end

/* Validación del País Identificador de CNBV */
if not exists (select Pac_Clave from SOPAICNB
						where Pac_Clave = @Pai_IdCNBV) or 
			isnull(@Pai_IdCNBV, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error.- Pais Identificador de CNBV incorrecto',
			Err_Variab	= 'Pai_IdCNBV'
	rollback
	return 1
end

execute @Status = SOFOLIOSACT
	@Fol_Tabla  = @Tab_Nombre,
	@Fol_Numero = @SoPaisID output

if @Status <> 0 begin
	rollback
	return 1
end

select	@Pai_Numero	= right('000' + ltrim(rtrim(convert(char, @SoPaisID))), 3)

select	@SoPaisID	= convert(int, @Pai_Numero)

/* Agrega a la Tabla SOPAIS */
insert into SOPAIS values (
	@SoPaisID,		@Pai_Numero,	@Pai_Nombre,	@Pai_Abrevi,	@Pai_ISR,
	@Pai_Gentil,	@Pai_IdeBMX,	@Pai_IdCNBV,	@NumTransac,	@Transaccio,	
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
	

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado',
		Pai_Numero	= @Pai_Numero
