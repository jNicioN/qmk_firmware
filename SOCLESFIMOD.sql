create procedure SOCLESFIMOD (
   @Cef_Numero int,
   @Cef_Descrip varchar(50),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/****************************************************************/
/* DESCRIPCION: Modificacion de registros de clasificacion		*/
/*				estado financiero								*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

update SOCLESFI set 
   Cef_Descrip = @Cef_Descrip, 
   NumTransac  = @NumTransac, 
   Transaccio  = @Transaccio, 
   Usuario 	   = @Usuario, 
   FechaSis    = @FechaSis, 
   SucOrigen   = @SucOrigen, 
   SucDestino  = @SucDestino
where Cef_Numero = @Cef_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Cef_Numero = @Cef_Numero
