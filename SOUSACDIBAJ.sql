create procedure SOUSACDIBAJ (
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
/* DESCRIPCION:	Borrando de la tabla acceso directo (SOUSACDI)				*/
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
** Fecha:			17/09/2013												**
** Modificación:	Correccion de validaciones if con select.				**
** Help Desk:		539205													**
*****************************************************************************/


declare	@Uad_NumAnt		int		/* Declaración de Variables */

declare	@Int_Null		int		/* Declaración de Constantes */
		
/* Asignación de Constantes */
select	@Int_Null	= -1		/* Entero Null*/

select	@Uad_NumAnt = Uad_Numero
	from SOUSACDI noholdlock
	where	Uad_Numero	= @Uad_Numero

if isnull(@Uad_NumAnt, @Int_Null) = @Int_Null begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El Acceso Directo no existe'
	rollback
	return 1
end

delete from SOUSACDI
	where	Uad_Numero	= @Uad_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Borrado'
