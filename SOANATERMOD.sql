create procedure SOANATERMOD (
   @Ant_Numero int,
   @Ant_EFTiCu int,
   @Ant_Varios numeric(14,2),
   @Ant_Total numeric(14,2),
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*********************************************************************
** DESCRIPCION: Modificacion de registros analitica terreno  		**
**********************************************************************
** Modifico:		Felipe Castillo Rendon                    		**
** Fecha:			03/09/2017                               		**
** Descripcion:		Se quitan los campos Ant_BieInm y Ant_EstAna  	**
** Help:			929417 					 						**
**********************************************************************
** Creo:		Felipe Castillo Rendon                    			**
** Fecha:		19/05/2017                               			**
** Help:		929417 					 							**
*********************************************************************/

update SOANATER set
   Ant_EFTiCu = @Ant_EFTiCu,
   Ant_Varios = @Ant_Varios,
   Ant_Total  = @Ant_Total,
   
   NumTransac = @NumTransac,
   Transaccio = @Transaccio,
   Usuario    = @Usuario,
   FechaSis   = @FechaSis,
   SucOrigen  = @SucOrigen,
   SucDestino = @SucDestino
where Ant_Numero = @Ant_Numero

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ant_Numero = @Ant_Numero
