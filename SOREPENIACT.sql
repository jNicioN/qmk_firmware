create procedure SOREPENIACT (
	@Rel_Numero	char(5),
	@Rel_Perfil	char(3),
	@Rel_Nivel	char(2),
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Actualización de Relacion Perfil Nivel **				****
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
		@Ent_Uno	int,
		@Tip_Activa	char(1),
		@Tip_Cancel	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Tip_Activa	='A',				/* Tipo de actualización: Activar. */
		@Tip_Cancel	='C'				/* Tipo de actualización: Cancelar. */

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

if not exists(select Per_Numero from SAPERFIL noholdlock
				where Per_Numero = @Rel_Perfil) begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'El perfil no existe',
			Err_Variab	= '@Rel_Perfil'
	rollback
	return @Ent_Uno
end

if not exists(select Niv_Numero from SONIVELE noholdlock
				where Niv_Numero = @Rel_Nivel) begin
	select  Err_Codigo  = '000005',
			Err_Mensaj  = 'El nivel no existe',
			Err_Variab  = '@Rel_Nivel'
	rollback
	return @Ent_Uno
end

if exists(select Rel_Numero from SOREPENI noholdlock
				where Rel_Perfil = @Rel_Perfil
				  and Rel_Nivel  = @Rel_Nivel) begin
	select  Err_Codigo  = '000006',
			Err_Mensaj  = 'Ya existe la relacion',
			Err_Variab  = '@Rel_Nivel'
	rollback
	return @Ent_Uno
end

/* Actualización de Relacion Perfil Nivel */
if @Tip_Actual = @Tip_Activa begin		/* Tipo de actualización: Activar. */

	update SOREPENI set
		Rel_Numero	= @Rel_Numero,
		Rel_Perfil	= @Rel_Perfil,
		Rel_Nivel	= @Rel_Nivel,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Rel_Numero	= @Rel_Numero

end if @Tip_Actual = @Tip_Cancel begin		/* Tipo de actualización: Cancelar. */

	update SOREPENI set
		Rel_Numero	= @Rel_Numero,
		Rel_Perfil	= @Rel_Perfil,
		Rel_Nivel	= @Rel_Nivel,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Rel_Numero	= @Rel_Numero

end
