create procedure SOANTECOMOD (
   @Atc_Numero int,
   @Atc_AnaTer int,
   @Atc_BieInm int,
   @Atc_EstAna bit,
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)
) 
 as

/*************************************************************************
** DESCRIPCION: Modificacion de registros analitica terreno concepto	**
**************************************************************************
** Creo:			Felipe Castillo Rendon                    			**
** Fecha:			22/08/2017                               			**
** Help:			929417 					 							**
**************************************************************************/

update SOANTECO set
   Atc_AnaTer = @Atc_AnaTer,
   Atc_BieInm = @Atc_BieInm,
   Atc_EstAna = @Atc_EstAna,
   
   NumTransac = @NumTransac,
   Transaccio = @Transaccio,
   Usuario    = @Usuario,
   FechaSis   = @FechaSis,
   SucOrigen  = @SucOrigen,
   SucDestino = @SucDestino
where Atc_Numero = @Atc_Numero

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Atc_Numero = @Atc_Numero
