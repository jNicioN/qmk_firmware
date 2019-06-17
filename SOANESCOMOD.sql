create procedure SOANESCOMOD (
   @Aec_Numero numeric,
   @Aec_AnaEst int,
   @Aec_Concep varchar(100),
   @Aec_Monto numeric(10,2),
   @Aec_Porcen numeric(10,2),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*************************************************************************
** DESCRIPCION: Modificacion de registros analitica estandar concepto	**
**************************************************************************
** Creo:		Felipe Castillo Rendon                   		  		**
** Fecha:		19/05/2017                               		  		**
** Help:		929417 					 						  		**
*************************************************************************/

update SOANESCO set 
   Aec_AnaEst = @Aec_AnaEst, 
   Aec_Concep = @Aec_Concep, 
   Aec_Monto = @Aec_Monto, 
   Aec_Porcen = @Aec_Porcen,
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario = @Usuario, 
   FechaSis = @FechaSis, 
   SucOrigen = @SucOrigen, 
   SucDestino = @SucDestino
where Aec_Numero = @Aec_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Aec_Numero = @Aec_Numero
