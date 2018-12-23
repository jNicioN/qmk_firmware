create procedure SOANATERCON (
   @Ant_Numero int,
   @Ant_EFTiCu int,
   @Tip_Consul char(2),
   
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Consulta de registros de analitica terreno        **
********************************************************************
** Modifico:		Felipe Castillo Rendon                    	  **
** Fecha:			22/08/2017                               	  **
** Descripcion:		Se quitan los campos Ant_BieInm y Ant_EstAna  **
** 					Se agrega C2 y L2  							  **
** Help:			929417 					 					  **
********************************************************************
** Creo:		Felipe Castillo Rendon                    		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),		/* Variable de tipo de consulta */
        @Tip_ConCon char(1), 		/* Variable de consulta o lista */
        @Str_C char(1), 			/* Variable de tipo de consulta */
        @Str_Uno char(1), 			/* Variable tipo cadena con valor 1 */
        @Str_Dos char(1)			/* Variable tipo cadena con valor 2 */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2'
       
if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 Consulta por numero */
     select Ant_Numero,		Ant_EFTiCu,		Ant_Varios,		Ant_Total, 
          	NumTransac,		Transaccio,		Usuario,		FechaSis, 
			SucOrigen,		SucDestino 
     from SOANATER noholdlock 
     where Ant_Numero = @Ant_Numero
   end
   	if @Tip_ConCon = @Str_Dos begin		/* C2 Consulta por estado financiero tipo cuenta */
     select Ant_Numero,		Ant_EFTiCu,		Ant_Varios,		Ant_Total, 
          	NumTransac,		Transaccio,		Usuario,		FechaSis, 
			SucOrigen,		SucDestino 
     from SOANATER noholdlock 
     where Ant_EFTiCu = @Ant_EFTiCu
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 Devuelve la lista de todas las analiticas de terreno */
     select Ant_Numero,		Ant_EFTiCu,		Ant_Varios,		Ant_Total, 
          	NumTransac,		Transaccio,		Usuario,		FechaSis, 
			SucOrigen,		SucDestino 
     from SOANATER noholdlock  
   end
   if @Tip_ConCon = @Str_Dos begin		/* L2 Devuelve la lista por estado financiero tipo cuenta */
     select Ant_Numero,		Ant_EFTiCu,		Ant_Varios,		Ant_Total, 
          	NumTransac,		Transaccio,		Usuario,		FechaSis, 
			SucOrigen,		SucDestino 
     from SOANATER noholdlock
     where Ant_EFTiCu = @Ant_EFTiCu
   end
end
