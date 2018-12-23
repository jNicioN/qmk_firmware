create procedure SOCATICOALT (
	@Ctc_Nombre	char(40),
	@Ctc_Descri	varchar(255),
	@Ctc_Activo	char(1),
	@Ctc_Principal	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	 Alta de Catalogo de Tipos de Correo					****
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
if isnull(@Ctc_Nombre, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Ctc_Nombre.',
			Err_Variab	= '@Ctc_Nombre'
	rollback
	return @Ent_Uno

end

if isnull(@Ctc_Descri, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Ctc_Descri.',
			Err_Variab	= '@Ctc_Descri'
	rollback
	return @Ent_Uno

end

if isnull(@Ctc_Activo, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error con el parámetro: @Ctc_Activo.',
			Err_Variab	= '@Ctc_Activo'
	rollback
	return @Ent_Uno

end

if isnull(@Ctc_Principal, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error con el parámetro: @Ctc_Principal.',
			Err_Variab	= '@Ctc_Principal'
	rollback
	return @Ent_Uno

end

/* Alta de Catalogo de Tipos de Correo */
insert into SOCATICO values(
	@Ctc_Nombre,		@Ctc_Descri,		@Ctc_Activo,		@Ctc_Principal,		@NumTransac,
	@Transaccio,		@Usuario,			@FechaSis,			@SucOrigen,			@SucDestino)
