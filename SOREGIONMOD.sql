create procedure SOREGIONMOD (
    @Reg_Numero	int,
	@Reg_Descri	varchar(35),
	@Reg_SegNum	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as	
/*********************************************************************************/
/* DESCRIPCION:  Modificacion de Regiones 								        */
/*********************************************************************************/
/* REFERENCIAS: 																*/
/**********************************************************************************
**Creo  :         Erick Gloria                                      	       ****
**Fecha:          26/03/2018                                           	       ****
**Help Desk:      1093350                                                  	   ****
***********************************************************************************/

update SOREGION set Reg_Descri = @Reg_Descri,
                    Reg_SegNum = @Reg_SegNum  
                where Reg_Numero = @Reg_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Region Actualizada'
