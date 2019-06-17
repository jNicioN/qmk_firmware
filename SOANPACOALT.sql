create procedure SOANPACOALT (
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

/*******************************************************************
** DESCRIPCION: alta de registros de analitica pasivo concepto    **
********************************************************************
** Modifico:    Edwin Santiago		                     	      **
** Fecha:		15/06/2018                               		  **
** Descripcion: se elimina el campo Apc_FecVen y se agrega        **
**				Apc_Vencim   			    				      **
** Help:		1114960 				 						  **
********************************************************************
** Creo:		Felipe Castillo		                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
********************************************************************/

/* Declaracion de Variables */
DECLARE @Int_Uno int /* Entero Uno */
SELECT  @Int_Uno = 1

insert into SOANPACO 
	(Apc_AnaPas,	Apc_Concep,		Apc_MonOri,		Apc_Vencim,		Apc_Cp, 
	Apc_Lp,    		Apc_Total,    	Apc_Observ,    	Apc_Banreg,    	NumTransac, 
	Transaccio,    	Usuario,    	FechaSis,    	SucOrigen,    	SucDestino) 
	values (   
	@Apc_AnaPas,	@Apc_Concep,	@Apc_MonOri,	@Apc_Vencim,	@Apc_Cp, 
	@Apc_Lp,		@Apc_Total,		@Apc_Observ,	@Apc_Banreg,	@NumTransac, 
	@Transaccio,    @Usuario,    	@FechaSis,    	@SucOrigen,    	@SucDestino) 

select @Apc_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Apc_Numero= @Apc_Numero 
end
