create procedure SOPENOFEPRO (
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_Fecha	smalldatetime,

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
** DESCRIPCION: ** Consulta de persona unica por nombre y 			    ****
** 				   fecha de nacimiento									****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		Carlos Copto											****
** Fecha:		10/07/2020   											****
** Help Desk:	1376175										 			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Str_Comple	char(180),
		@Per_ID char(8),
		@Per_RFC char(15),
		@Tab_Ori char(1),
		@Control int
								
								/* Declaracion de constantes */
declare	@Str_Vacio 	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int

								/* Asignacion de valores a constantes */
select	@Str_Vacio  = '',		/* String vacio */
		@Ent_Cero	= 0,		/* Entero cero */
		@Ent_Uno	= 1			/* Entero uno */

if isnull(@Per_Nombre, @Str_Vacio) = @Str_Vacio  begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'Ingrese un nombre'
	rollback
	return @Ent_Uno
end

if isnull(@Per_ApePat, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'Ingrese el apellido paterno'
	rollback
	return @Ent_Uno
end 

if isnull(@Per_ApeMat, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'Ingrese el apellido materno'
	rollback
	return @Ent_Uno
end 

if isnull(@Per_Fecha, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'Ingrese la fecha de nacimiento'
	rollback
	return @Ent_Uno
end 
	
select @Str_Comple = (ltrim(rtrim(@Per_ApePat))+' '+ltrim(rtrim(@Per_ApeMat))+' '+ltrim(rtrim(@Per_Nombre)))

/* primero busca en SOPERSON si existe la persona */
select 	@Per_ID = Per_Numero, 
		@Per_RFC = Per_RFC,
		@Control = @Ent_Uno			/* variable de control para indicar que es nacional en caso de ser compra venta*/
		from SOPERSON noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where Adi_FecNac = @Per_Fecha and  Per_Comple = @Str_Comple

/* si no lo encontro en SOPERSON busca en SOUSUEXT */
if( isnull(@Per_ID, @Str_Vacio) = @Str_Vacio or isnull(@Per_RFC, @Str_Vacio) = @Str_Vacio ) begin

	select  @Per_ID = convert(char, Une_Identi),
			@Tab_Ori = Une_TabOri 
			from SOUSNAEX noholdlock
			inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
			where Use_FecNac = @Per_Fecha and Use_NoCoUs = @Str_Comple
			
end 

/* Si control es 1 existe la persona y se procede a validar si es de compra venta */
if @Control = @Ent_Uno begin 

	select  @Per_ID = convert(char, Une_Identi),
			@Tab_Ori = Une_TabOri 
		from SOUSNAEX noholdlock
		where Une_IdeUsu = convert(int, str_replace(ltrim(str_replace( @Per_ID , '0', ' ')),' ', '0') )
		
end

if 	@Per_ID <> @Str_Vacio and @Per_ID is not null begin
	
	select	Err_Codigo	= '000000',
			Err_Mensaj = 'Ya existe un Cliente/Usuario con el nombre ' + @Per_Nombre + ' ' + @Per_ApePat + ' ' + @Per_ApeMat,
			Per_Numero	= ltrim(rtrim(@Per_ID)),
			Tab_Ori = @Tab_Ori,
			rfc = ltrim(rtrim(@Per_RFC))
	return @Ent_Uno
		
end	else begin
	
	select	Err_Codigo	= '000006',
			Err_Mensaj = 'No se encuentra la persona'
	return @Ent_Uno

end 
		