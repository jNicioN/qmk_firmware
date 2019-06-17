create procedure SOANAPASMOD (
   @Anp_Numero int,
   @Anp_EFTiCu int,
   @Anp_VariCp numeric(10,2),
   @Anp_VariLp numeric(10,2),
   @Anp_VarTot numeric(10,2),
   @Anp_Total numeric(10,2),
   @Anp_VarObs varchar(50),
   @Anp_EstAna int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Modificacion de registros de analitica pasivo  	  **
********************************************************************
** Creo:		Felipe Castillo Rendon                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

update SOANAPAS set 
   Anp_EFTiCu = @Anp_EFTiCu, 
   Anp_VariCp = @Anp_VariCp, 
   Anp_VariLp = @Anp_VariLp, 
   Anp_VarTot = @Anp_VarTot, 
   Anp_Total  = @Anp_Total, 
   Anp_VarObs = @Anp_VarObs, 
   Anp_EstAna = @Anp_EstAna, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Anp_Numero = @Anp_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Anp_Numero = @Anp_Numero
