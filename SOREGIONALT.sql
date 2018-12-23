create procedure SOREGIONALT (
	@Reg_Numero	int,
	@Reg_Descri	varchar(35),
	@Reg_Status	char(1),
	@Reg_SegNum	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************/
/* DESCRIPCION: Altas de Regiones     			                            */
/****************************************************************************/
/* REFERENCIAS: 															*/
/*****************************************************************************
**Creo  :    	  Erick Gloria                                  	       ****
**Fecha:          26/03/2018                                              ****
**				      										    		   ****
**Help Desk:      1093350                                                  ****
*****************************************************************************/

/* Declaracion de Constantes */
declare @Est_ValEst	char(1)		/*Estatus */
declare @Val_Return	int		/*Return */
/* Declaracion de Variables */
declare @Reg_NumMax	int		/*Variable Id AI */

/* Asignación de valores a constantes */
select @Est_ValEst	= '1' 				/*Valor Estatus*/
select @Val_Return	= -1 				/*Valor Return*/


if exists (select  Reg_Descri 
				from SOREGION noholdlock
				where  Reg_Descri	= @Reg_Descri) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Zona ya existe',
			Err_Variab	= 'Reg_Descri'
	return @Val_Return
end

select @Reg_NumMax = MAX(Reg_Numero + 1) From SOREGION

insert into SOREGION	(	Reg_Numero, Reg_Descri, Reg_Status,	Reg_SegNum, 	NumTransac,		
							Transaccio,	Usuario, FechaSis, SucOrigen, SucDestino )		
			  values	(	@Reg_NumMax, @Reg_Descri, @Reg_Status, @Reg_SegNum, @NumTransac,	
			  				@Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino)
	
select	Reg_Numero	= @@identity,
		Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
