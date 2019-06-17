create procedure SODIRPERALT (
	@PerPersoID int,
	@Dip_TipDir	int,
	@ClClientID	int,
	@Dip_Calle	char(40),
	@Dip_NumExt	char(10),
	@Dip_NumInt	char(10),
	@Dip_NumCP	char(6),
	@Dip_EntCa1	varchar(255),
	@Dip_EntCa2	varchar(255),
	@Dip_Refere	varchar(255),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***********************************************************
** Descripción:	 Alta de Dirección Persona				****
************************************************************
** Modifico:		Norma Tijerina						****
** Fecha:		04-05-2017								****
** Help:		00946339								****
************************************************************
** Creó:		Roberto Saldivar						****
** Fecha:		17-03-2017								****
** Help:		00909908								****
************************************************************/
										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Dip_Status	char(1),
		@Tim_Vigenc int,
		@Tip_Vigenc char(2)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Tim_Vigenc = 12,				/* Cantidad de meses de vigencia*/
		@Tip_Vigenc = 'mm',				/* Tipo de tiempo para aumentar la fecha de Viegencia (meses)*/
		@Dip_Status = 'A'
		
/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersonID .',
			Err_Variab	= '@PerPersonID'
	rollback
	return @Ent_Uno

end


if @Dip_TipDir = @Ent_Cero begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Dip_TipDir.',
			Err_Variab	= '@Dip_TipDir'
	rollback
	return @Ent_Uno

end

if isnull(@Dip_Calle, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error con el parámetro: @Dip_Calle.',
			Err_Variab	= '@Dip_Calle'
	rollback
	return @Ent_Uno

end

if isnull(@Dip_NumCP, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Error con el parámetro: @Dip_NumCP.',
			Err_Variab	= '@Dip_NumCP'
	rollback
	return @Ent_Uno

end


/* Alta de Descripcion */
insert into SODIRPER values(
	@PerPersoID,		@Dip_TipDir,		@ClClientID,		@Dip_Calle,			@Dip_NumExt,
	@Dip_NumInt,		@Dip_NumCP,			@Dip_EntCa1,		@Dip_EntCa2,		@Dip_Refere,
	@Dip_Status,		@NumTransac,		@Transaccio,		@Usuario,			@FechaSis,			
	@SucOrigen,			@SucDestino)
