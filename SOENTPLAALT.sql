create procedure SOENTPLAALT (
	@Enp_Entida	int,			/* CLENTIDA:ClEntidaID: Identificador de entidad */
	@Enp_Plaza 	int,			/* SOPLAZAS:SoPlazaID: Identificador de plaza */

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** DESCRIPCION: Alta plaza entidad										****
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

select @Enp_Entida = ClEntidaID 
	from CLENTIDA noholdlock
	where ClEntidaID = @Enp_Entida

if isnull(@Enp_Entida, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No se encontró la entidad.',
			Err_Variab	= 'Enp_Entida'
	rollback
	return @Ent_Uno
end

select @Enp_Plaza = SoPlazaID 
	from SOPLAZAS noholdlock
	where SoPlazaID = @Enp_Plaza

if isnull(@Enp_Plaza, @Ent_Cero) = @Ent_Cero begin
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