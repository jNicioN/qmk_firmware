create procedure SOSEGMENMOD (
    @Seg_Numero	int,
	@Seg_Nombre	varchar(35),
	@Seg_Status	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as	
/*********************************************************************************/
/* DESCRIPCION:  Modificacion de Segmentos	 								*/
/*********************************************************************************/
/* REFERENCIAS: 																*/
/**********************************************************************************
**Creo  :         Erick Gloria                                      	   ****
**Fecha:          26/03/2018                                           	   ****
** Help Desk: 1093350 											           ****
***********************************************************************************/

update SOSEGMEN set Seg_Nombre = @Seg_Nombre where Seg_Numero = @Seg_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Segmento Actualizado'
