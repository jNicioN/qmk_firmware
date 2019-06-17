create procedure SOANPACOMOD (
   @Apc_Numero numeric,
   @Apc_AnaPas int,
   @Apc_Concep varchar(85),
   @Apc_MonOri numeric(10,2),
   @Apc_Vencim varchar(30),
   @Apc_Cp numeric(10,2),
   @Apc_Lp numeric(10,2),
   @Apc_Total numeric(10,2),
   @Apc_Observ varchar(50),
   @Apc_Banreg bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as

/*************************************************************************
** DESCRIPCION: Modificacion de registros de analitica pasivo concepto	**
*************************************************************************
** Modifico:    Edwin Santiago		                     	            **
** Fecha:		15/06/2018                               		        **
** Descripcion: se elimina el campo Apc_FecVen y se agrega        		**
**				Apc_Vencim   			    				      		** 
** Help:		1114960 				 						        **
**************************************************************************
** Creo:		Felipe Castillo		                    				**
** Fecha:		19/05/2017                               				**
** Help:		929417 					 								**
*************************************************************************/

update SOANPACO set 
   Apc_AnaPas = @Apc_AnaPas, 
   Apc_Concep = @Apc_Concep, 
   Apc_MonOri = @Apc_MonOri, 
   Apc_Vencim = @Apc_Vencim, 
   Apc_Cp 	  = @Apc_Cp, 
   Apc_Lp     = @Apc_Lp, 
   Apc_Total  = @Apc_Total, 
   Apc_Observ = @Apc_Observ, 
   Apc_Banreg = @Apc_Banreg, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
	where Apc_Numero = @Apc_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Apc_Numero = @Apc_Numero
