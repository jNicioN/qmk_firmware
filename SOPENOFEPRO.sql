use BANREGIO
go
if exists(select 1
		from sysobjects
		where id=object_id('dbo.SOPENOFEPRO')
		and type='P')
	drop procedure dbo.SOPENOFEPRO
go
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
** Modifico:	Carlos Copto											****
** Fecha:		27/11/2020   											****
** Descripcion: Se agrego validacion de estatus 'B' bloqueado			****
**				para validacion de cuentas de cliente.				    ****
**			 	Se agrego validacion para filtrar por usuarios activos  ****
**  			y se agregaron mensajes especificos para cliente 		****
**				usuario y prospecto  									****
** Help Desk:	1376175										 			****
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
		@Cliente int,
		@UsuarioCV int,
		@Persona int,
		@Estatus varchar(1),
		@Mensaje varchar(150)
								
								/* Declaracion de constantes */
declare	@Str_Vacio 	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Sta_Activo varchar(1),
		@Cue_CashBa	char(2),
		@Cue_Refere	char(2),
		@Sta_Bloqueado varchar(1)		

								/* Asignacion de valores a constantes */
select	@Str_Vacio  = '',		/* String vacio */
		@Ent_Cero	= 0,		/* Entero cero */
		@Ent_Uno	= 1,		/* Entero uno */
		@Sta_Activo = 'A',		/* Estatus activo */
		@Cue_CashBa = '31',		-- Tipo de Cuenta: Cashback
		@Cue_Refere = '50',		-- Tipo de Cuenta: Referenciado
		@Sta_Bloqueado = 'B'	/* Estatus bloqueado */

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
		@Persona = @Ent_Uno			/* si lo encuentra en este punto signfica que al menos existe como prospecto */
		from SOPERSON noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where Adi_FecNac = @Per_Fecha and  Per_Comple = @Str_Comple
		
/* Si existe un prospecto revisa si tiene un cliente con cuentas activas */
if( @Persona = @Ent_Uno ) begin

	select  @Cliente = @Ent_Uno
		from CLCLIENT noholdlock
		inner join CHCUENTA noholdlock on Cli_Numero = Cue_Client
		where Cli_RFC	= @Per_RFC
		and Cue_Status = @Sta_Activo
		and Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
			
end 

/* si no es cliente se procede a buscar como usuario*/
if ( @Cliente <> @Ent_Uno ) begin
	
	/* si es usuario nacional */
	if ( @Persona = @Ent_Uno) begin
		select  @Per_ID = convert(char, Une_Identi),
				@Tab_Ori = Une_TabOri,
				@Estatus = Une_Estatu,
				@UsuarioCV = @Ent_Uno
		from SOUSNAEX noholdlock
		where Une_IdeUsu = convert(int, str_replace(ltrim(str_replace( @Per_ID , '0', ' ')),' ', '0') )
	end
	
	/* si no lo encontro como usuario nacional y tampoco es cliente busca en extranjeros */
	if( @Cliente <> @Ent_Uno and @UsuarioCV <> @Ent_Uno ) begin
		select  @Per_ID = convert(char, Une_Identi),
				@Tab_Ori = Une_TabOri,
				@Estatus = Une_Estatu,
				@UsuarioCV = @Ent_Uno
		from SOUSNAEX noholdlock
		inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
		where Use_FecNac = @Per_Fecha and Use_NoCoUs = @Str_Comple
	end 

end

if @Cliente = @Ent_Uno begin
	select	@Mensaje = 'Ya existe un Cliente con el nombre ' + @Per_Nombre + ' ' + @Per_ApePat + ' ' + @Per_ApeMat
end else if @UsuarioCV = @Ent_Uno and @Estatus = @Sta_Activo begin
	select	@Mensaje = 'Ya existe un Usuario activo con el nombre ' + @Per_Nombre + ' ' + @Per_ApePat + ' ' + @Per_ApeMat + ' favor de dar salida como Cliente.'
end

if @Cliente = @Ent_Uno or @UsuarioCV = @Ent_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj  = @Mensaje,
			Per_Numero	= ltrim(rtrim(@Per_ID)),
			Tab_Ori = @Tab_Ori,
			rfc = ltrim(rtrim(@Per_RFC))
	return @Ent_Uno
end else begin
	select	Err_Codigo	= '000006',
			Err_Mensaj = 'No se encuentra la persona'
	return @Ent_Uno
end 
		
go
grant exec on dbo.SOPENOFEPRO to public
go
