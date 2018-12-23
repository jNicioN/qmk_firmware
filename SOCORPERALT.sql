create procedure SOCORPERALT (
	@PerPersoID	int,
	@Cop_TipCor		int,
	@ClClientID		int,
	@Cop_Correo	varchar(100),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Alta de Correos de Persona					****
****************************************************************************
** Creó:			Norma Tijerina				****
** Fecha:		03-05-2017									****
** Help:		00946339										****
****************************************************************************/

										/* Declaración de variables */
declare	@Status		int

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Cop_Status	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,					/* Entero en uno */
		@Cop_Status	= 'A'					/* Estatus de Activo */	

/* Validaciones */
if @PerPersoID = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @PerPersoID.',
			Err_Variab	= '@PerPersoID'
	rollback
	return @Ent_Uno

end

if @Cop_TipCor = @Ent_Cero begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Cop_TipCor.',
			Err_Variab	= '@Cop_TipCor'
	rollback
	return @Ent_Uno

end

if isnull(@Cop_Correo, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Cop_Correo.',
			Err_Variab	= '@Cop_Correo'
	rollback
	return @Ent_Uno

end


/* Alta de Correos de Persona */
insert into SOCORPER values(
	@PerPersoID,		@Cop_TipCor,		@ClClientID,		@Cop_Correo,		@Cop_Status,
	@NumTransac,		@Transaccio,		@Usuario,			@FechaSis,			@SucOrigen,			@SucDestino)
