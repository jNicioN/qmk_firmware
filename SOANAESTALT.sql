create procedure SOANAESTALT (
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
** DESCRIPCION: Alta de registros de analitica estandar        	  **
********************************************************************
** Creo:		Felipe Castillo Rendon                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SOANAEST 
	(Ane_EsFiCu,	Ane_VarMon,		Ane_Total,		Ane_EstAna,		NumTransac, 
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Ane_EsFiCu,	@Ane_VarMon,	@Ane_Total,		@Ane_EstAna,	@NumTransac, 
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino) 

select @Ane_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
     		Err_Mensaj = 'Relacion agregada correctamente', 
     		Ane_Numero= @Ane_Numero 
end
