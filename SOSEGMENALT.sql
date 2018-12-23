create procedure SOSEGMENALT (
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
/****************************************************************************/
/* DESCRIPCION: Altas de  Segmentos     			                        */
/****************************************************************************/
/* REFERENCIAS: 															*/
/*****************************************************************************
**Creo  :    	  Erick Gloria                                  	       ****
**Fecha:          26/03/2018                                              ****
**				      										    		   ****
** Help Desk: 1093350 											           ****
*****************************************************************************/

/* Declaracion de Constantes */
declare @Est_ValEst	char(1)		/*Estatus */
declare @Val_Return	int		/*Return */

/* Asignación de valores a constantes */
select @Est_ValEst	= '1' 				/*Valor Estatus*/
select @Val_Return	= -1 				/*Valor Return*/

if exists (select  Seg_Nombre 
				from SOSEGMEN noholdlock
				where  Seg_Nombre	= @Seg_Nombre) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Segmento ya existe',
			Err_Variab	= 'Seg_Nombre'
	return @Val_Return
end

insert into SOSEGMEN	(	Seg_Nombre,  Seg_Status,		NumTransac,		Transaccio,		Usuario,
							FechaSis,		SucOrigen,		SucDestino )		
			  values	(	@Seg_Nombre,     @Seg_Status, 	@NumTransac,	@Transaccio,	@Usuario,
							@FechaSis,		@SucOrigen,		@SucDestino)
	
select	Seg_Numero	= @@identity,
		Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
