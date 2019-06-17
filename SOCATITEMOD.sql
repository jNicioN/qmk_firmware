create procedure SOCATITEMOD (
	@Ctt_Numero	int,
	@Ctt_Nombre	char(40),
	@Ctt_Descri	varchar(255),
	@Ctt_Activo	char(1),
	@Ctt_Principal	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Modificación de Catalogo de Tipo de Telefono					****
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
		@Ent_Uno	int

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1					/* Entero en uno */

/* Validaciones */
if @Ctt_Numero = @Ent_Cero begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @Ctt_Numero.',
			Err_Variab	= '@Ctt_Numero'
	rollback
	return @Ent_Uno

end

if isnull(@Ctt_Nombre, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Ctt_Nombre.',
			Err_Variab	= '@Ctt_Nombre'
	rollback
	return @Ent_Uno

end

if isnull(@Ctt_Descri, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Ctt_Descri.',
			Err_Variab	= '@Ctt_Descri'
	rollback
	return @Ent_Uno

end

if isnull(@Ctt_Activo, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error con el parámetro: @Ctt_Activo.',
			Err_Variab	= '@Ctt_Activo'
	rollback
	return @Ent_Uno

end

if isnull(@Ctt_Principal, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error con el parámetro: @Ctt_Principal.',
			Err_Variab	= '@Ctt_Principal'
	rollback
	return @Ent_Uno

end

/* Modificación de Catalogo de Tipo de Telefono */
update SOCATITE set
	Ctt_Nombre	= @Ctt_Nombre,
	Ctt_Descri	= @Ctt_Descri,
	Ctt_Activo	= @Ctt_Activo,
	Ctt_Principal	= @Ctt_Principal,

	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Ctt_Numero	= @Ctt_Numero
