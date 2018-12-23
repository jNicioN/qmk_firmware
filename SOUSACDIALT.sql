create procedure SOUSACDIALT (
	@Uad_Numero	int,
	@Uad_Usuari	char(6),
	@Uad_Pantal	int,
	@Uad_Indice	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************/
/* DESCRIPCION:	Altas de la tabla acceso directo (SOUSACDI)					*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Modificó:		Evijair Núñez Jordán									**
** Fecha:			21/06/2013												**
** Modificación:	Creación del store procedure.							**
** Help Desk:		539205													**
*****************************************************************************/
/*****************************************************************************
** Modificó:		Adaías Fuentes Martínez									**
** Fecha:			13/09/2013												**
** Modificación:	Correccion de validaciones if con select.				**
** Help Desk:		539205													**
*****************************************************************************/

declare	@Uad_UsuAnt		char(6),		/* Declaración de Variables */
		@Pan_NumAnt		int,
		@Uad_NumAnt		int

declare	@Str_Vacio	char(6),			/* Declaración de Constantes */
		@Int_Null	int

/* Asignación de Constantes */
select	@Str_Vacio	= ''		/* String Vacio */
select	@Int_Null	= -1		/* Entero Null*/

select @FechaSis	= getdate()

select	@Uad_UsuAnt = Usu_Numero
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Uad_Usuari
				
if isnull(@Uad_UsuAnt, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Usuario no existe'
	rollback
	return 1
end

select	@Pan_NumAnt = Pan_Numero
	from SAPANPLA noholdlock
	where	Pan_Numero	= @Uad_Pantal

if isnull(@Pan_NumAnt, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'La Pantalla no existe'
	rollback
	return 1
end

if isnull(@Uad_Indice, @Int_Null)	= @Int_Null begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El Indice es Incorrecto'
	rollback
	return 1
end

select	@Uad_NumAnt = Uad_Numero
	from SOUSACDI noholdlock
	where	Uad_Usuari	= @Uad_Usuari
	and	Uad_Pantal	= @Uad_Pantal

if isnull(@Uad_NumAnt, @Int_Null) <> @Int_Null begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'El usuario ya tien la pantalla asignada'
	rollback
	return 1
end

insert into SOUSACDI values(
	@Uad_Usuari,	@Uad_Pantal,	@Uad_Indice,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado',
		Uad_Numero	= @@identity
