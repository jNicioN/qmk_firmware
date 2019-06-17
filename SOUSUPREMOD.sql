create procedure SOUSUPREMOD (
	@Upr_Numero	int,
	@Upr_Usuari	char(6),
	@Upr_Nombre	varchar(50),
	@Upr_Valor	varchar(100),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************/
/* DESCRIPCION:	Modificaciones de las preferencias del usuario				*/
/****************************************************************************/
/* REFERENCIAS:																*/
/*****************************************************************************
** Modificó:		Evijair Núñez Jordán								  ****
** Fecha:			21/06/2013											  ****
** Modificación:	Creación del store procedure.						  ****
** Help Desk:		539205												  ****
*****************************************************************************/
/*****************************************************************************
** Modificó:		Adaías Fuentes Martínez									**
** Fecha:			17/09/2013												**
** Modificación:	Correccion de validaciones if con select.				**
** Help Desk:		539205													**
*****************************************************************************/

declare	@Upr_NumAnt	int,					/* Declaración de Variables */
		@Upr_UsuAnt	char(6)
		
declare @Str_Vacio	char(1),			/* Declaración de Constantes */
		@Int_Null	int

/* Asignación de Constantes */
select	@Str_Vacio	= ''			/* String Vacio */
select	@Int_Null	= -1			/* Entero Null */

select	@Upr_NumAnt	= Upr_Numero
	from SOUSUPRE noholdlock
	where	Upr_Numero	= @Upr_Numero
				
if isnull(@Upr_NumAnt, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La preferencia no existe'
	rollback
	return 1
end

select	@Upr_UsuAnt	= Usu_Numero
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Upr_Usuari
				
if isnull(@Upr_UsuAnt, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Usuario no existe'
	rollback
	return 1
end

if isnull(@Upr_Nombre, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El Nombre es Incorrecto'
	rollback
	return 1
end

if isnull(@Upr_Valor, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'El valor es Incorrecto'
	rollback
	return 1
end

update SOUSUPRE set
	Upr_Usuari	= @Upr_Usuari,
	Upr_Nombre	= @Upr_Nombre,
	Upr_Valor	= @Upr_Valor,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino,
	Modulo		= @Modulo
	where Upr_Numero = @Upr_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'
