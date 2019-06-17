create procedure SOREPENIBAJ (
	@Rel_Numero	char(5),
	@Rel_Perfil	char(3),
	@Rel_Nivel	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Baja de Relacion Perfil Nivel **				****
****************************************************************************
** 					STORE CONVERTIDO					****
** Fecha:		24-08-2015									****
** Convirtío:		David Cantu				****
****************************************************************************
** Creó:			David Cantu				****
** Fecha:		24-08-2015									****
** Help:		00749260										****
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
if isnull(@Rel_Numero, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error con el parámetro: @Rel_Numero.',
			Err_Variab	= '@Rel_Numero'
	rollback
	return @Ent_Uno

end

if isnull(@Rel_Perfil, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error con el parámetro: @Rel_Perfil.',
			Err_Variab	= '@Rel_Perfil'
	rollback
	return @Ent_Uno

end

if isnull(@Rel_Nivel, @Str_Vacio) = @Str_Vacio begin

	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error con el parámetro: @Rel_Nivel.',
			Err_Variab	= '@Rel_Nivel'
	rollback
	return @Ent_Uno

end

/* Baja de Relacion Perfil Nivel */
delete SOREPENI
	where	Rel_Numero	= @Rel_Numero
	  and	Rel_Perfil	= @Rel_Perfil
	  and	Rel_Nivel	= @Rel_Nivel
