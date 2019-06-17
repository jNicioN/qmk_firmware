create procedure SOUSUPREALT (
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
/* DESCRIPCION:	Altas de la tabla preferencias de usuario (SOUSUPRE)		*/
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

declare	@Upr_UsuAnt	char(6)					/* Declaración de Variables */

declare @Str_Vacio	char(1)				/* Declaración de Constantes */
		
/* Asignación de Constantes */
select	@Str_Vacio	= ''				/* String Vacio */


select	@Upr_UsuAnt	= Usu_Numero
	from SOUSUARI noholdlock
	where	Usu_Numero	= @Upr_Usuari
	
if isnull(@Upr_UsuAnt,@Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Usuario no existe'
	rollback
	return 1
end

if isnull(@Upr_Nombre, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'El Nombre es Incorrecto'
	rollback
	return 1
end

if isnull(@Upr_Valor, @Str_Vacio)	= @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'El Valor es Incorrecto'
	rollback
	return 1
end

insert into SOUSUPRE values(
	@Upr_Usuari,	@Upr_Nombre,	@Upr_Valor,		@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado',
		Upr_Numero	= @@identity
