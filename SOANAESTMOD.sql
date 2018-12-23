create procedure SOANAESTMOD (
   @Ane_Numero int,
   @Ane_EsFiCu int,
   @Ane_VarMon numeric(10,2),
   @Ane_Total numeric(10,2),
   @Ane_EstAna int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Modificacion de registros de analitica estandar   **
********************************************************************
** Creo:		Felipe Castillo Rendon                    		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

update SOANAEST set 
   Ane_EsFiCu = @Ane_EsFiCu, 
   Ane_VarMon = @Ane_VarMon, 
   Ane_Total  = @Ane_Total, 
   Ane_EstAna = @Ane_EstAna, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Ane_Numero = @Ane_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ane_Numero = @Ane_Numero
