create procedure SOUSACDIMOD (
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
/* DESCRIPCION:	Modificaciones de la tabla acceso directo (SOUSACDI)		*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Modificó:		Evijair Núñez Jordán								  ****
** Fecha:			21/06/2013											  ****
** Modificación:	Creación del store procedure.						  ****
** Help Desk:		539205												  ****
******************************************************************************/
/*****************************************************************************
** Modificó:		Adaías Fuentes Martínez									**
** Fecha:			17/09/2013												**
** Modificación:	Correccion de validaciones if con select.				**
** Help Desk:		539205													**
*****************************************************************************/

declare @Uad_NumAnt		int,				/* Declaración de Variables */
		@Uad_PanAnt		int,
		@Uad_UsuAnt		char(6)
		

declare @Int_Null		int,				/* Declaración de Constantes */
		@Str_Vacio		char(1)

/* Asignación de Constantes */
select	@Int_Null	= -1			/* Entero Null*/
select 	@Str_Vacio	= ''			/* String Null*/

select	@Uad_NumAnt = Uad_Numero
	from SOUSACDI noholdlock
	where	Uad_Numero	= @Uad_Numero
				
if isnull(@Uad_NumAnt, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Acceso Directo no existe'
	rollback
	return 1
end

select @Uad_UsuAnt = Usu_Numero
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Uad_Usuari
	
if isnull(@Uad_UsuAnt, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Usuario no existe'
	rollback
	return 1
end

select @Uad_PanAnt = Pan_Numero
	from SAPANPLA noholdlock
	where	Pan_Numero	= @Uad_Pantal
	
if isnull(@Uad_PanAnt, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'La Pantalla no existe'
	rollback
	return 1
end

if isnull(@Uad_Indice, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'El Indice es Incorrecto'
	rollback
	return 1
end

update SOUSACDI set
	Uad_Numero	= @Uad_Numero,
	Uad_Usuari	= @Uad_Usuari,
	Uad_Pantal	= @Uad_Pantal,
	Uad_Indice	= @Uad_Indice,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino,
	Modulo		= @Modulo
	where Uad_Numero = @Uad_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'
