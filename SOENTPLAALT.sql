create procedure SOENTPLAALT (
	@Enp_Entida	char(3),			/* CLENTIDA:ClEntidaID: Identificador de entidad */
	@Enp_Plaza 	char(3),			/* SOPLAZAS:SoPlazaID: Identificador de plaza */

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** DESCRIPCION: Alta relación entidad - plaza							****
****************************************************************************
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creó:		Adrian Said Dawn R.    									****
** Fecha:		27/Marzo/2024											****
** Help:		TCELCV-000000											****
***************************************************************************/

										/* Declaración de variables */
declare	@Status		int,
		@Tmp_BenPro	int
										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int
										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1					/* Entero en uno */

select @Enp_Entida = Ent_Numero 
	from CLENTIDA noholdlock
	where Ent_Numero = @Enp_Entida

if isnull(@Enp_Entida, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No se encontró la entidad.',
			Err_Variab	= 'Enp_Entida'
	rollback
	return @Ent_Uno
end

select @Enp_Plaza = Pla_Numero 
	from SOPLAZAS noholdlock
	where Pla_Numero = @Enp_Plaza

if isnull(@Enp_Plaza, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'No se encontró la plaza.',
			Err_Variab	= 'Enp_Plaza'
	rollback
	return @Ent_Uno
end

insert into SOENTPLA 
	(Enp_Entida,	Enp_Plaza,		NumTransac,		Transaccio,		Usuario,		
	FechaSis,		SucOrigen, 		SucDestino)
values 
	(@Enp_Entida, 	@Enp_Plaza,		@NumTransac,	@Transaccio,	@Usuario,		
	@FechaSis,		@SucOrigen,  	@SucDestino)