create procedure SOESFITIMOD (
   @Eft_Numero int,
   @Eft_EstFin int,
   @Eft_TipCue int,
   @Eft_Valor numeric(17,4),
   @Eft_Porcen numeric(10,2),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/****************************************************************/
/** DESCRIPCION: Modificacion de los registros de estado		*/
/**				financiero tipo cuenta en la tabla SOESFITI		*/
/****************************************************************/
/** Modifico:		Raul Muniz									*/
/** Fecha:			12/12/2019                             		*/
/** Help:			1318047				 						*/
/** Descripcion:	Se modifico parametro @Eft_Valor a numeric	*/
/**					(17,4)										*/
/****************************************************************/
/** Creo:			Felipe Castillo								*/
/** Fecha:			19/05/2017                             		*/
/** Help:			929417 				 						*/
/****************************************************************/

update SOESFITI set 
   Eft_EstFin = @Eft_EstFin, 
   Eft_TipCue = @Eft_TipCue, 
   Eft_Valor  = @Eft_Valor, 
   Eft_Porcen = @Eft_Porcen, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Eft_Numero = @Eft_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Eft_Numero = @Eft_Numero