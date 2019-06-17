create procedure SOUSUPREBAJ (
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
/* DESCRIPCION:	Bajas de las preferencias de Usuario						*/
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

declare	@Upr_NumAnt	int					/* Declaración de Variables */

declare @Int_Null	int					/* Declaración de Constantes */
		
/* Asignación de Constantes */
select	@Int_Null	= -1				/* Entero Null	*/

select	@Upr_NumAnt	= Upr_Numero
	from SOUSUPRE noholdlock
	where	Upr_Numero	= @Upr_Numero

if isnull(@Upr_NumAnt, @Int_Null) = @Int_Null	begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La preferencia no existe'
	rollback
	return 1
end

delete from SOUSUPRE
	where	Upr_Numero	= @Upr_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Borrado'
