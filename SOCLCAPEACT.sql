create procedure SOCLCAPEACT (
	@Clp_NumPer char(8),
	@Clp_InsReg char(1),
	@Clp_OtoCre char(1),
	@Clp_Bancar char(1),
	@Clp_SubBan char(1),
	@Clp_Fideic char(1),
	@Clp_TipSoc char(3),
	@Clp_NomSoc varchar(180),
	@Clp_EntFin	char(1),
	@Clp_UsBuCr	char(1),
	@Clp_LocINE	char(3),
	@Clp_EntINE	char(2),
	@Clp_ActPre	int,
	@Tip_Actual	char(1),
   
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION: ** Actualizacion de Clasificacion de Cartera de Personas ***/
/**************************************************************************/
/* REFERENCIAS:															***/
/****************************************************************************
** Creo:		Raul Muniz												****
** Fecha:		15/Septiembre/2021										****
** Help:		1504301													****
** Descripción	Se crea SP con tipo de proceso A para actualizar 		****
**				actividad preponderante									****
****************************************************************************/

/*	Declaracion de constantes */
declare	@Tip_ActPre	char(1)			/* Tipo Actualizacion Actividad Preponderante */

/*	Asignacion de constantes	*/
select	@Tip_ActPre	= 'A'			/* Tipo Actualizacion Actividad Preponderante */

if @Tip_Actual = @Tip_ActPre begin
	update SOCLCAPE set
		Clp_ActPre	= @Clp_ActPre
	where	Clp_NumPer	= @Clp_NumPer

	select	Err_Codigo	= '000000', 
			Err_Mensaj	= 'Registro Actualizado'
end