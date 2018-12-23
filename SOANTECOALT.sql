create procedure SOANTECOALT (
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
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Alta de registros de analitica terreno concepto	  **
********************************************************************
** Creo:			Felipe Castillo Rendon                    	  **
** Fecha:			22/08/2017                               	  **
** Help:			929417 					 					  **
********************************************************************/

/* Declaracion de Variables */

DECLARE @Int_Uno int		/* Variable de tipo entero con valor 1 */

SELECT  @Int_Uno = 1

insert into SOANTECO 
	(Atc_AnaTer,	Atc_BieInm,		Atc_EstAna, 
	NumTransac,		Transaccio,    Usuario,    		FechaSis,		SucOrigen, 
	SucDestino) 
	values (
	@Atc_AnaTer,    @Atc_BieInm,    @Atc_EstAna, 
	@NumTransac,    @Transaccio,    @Usuario,		@FechaSis,		@SucOrigen, 
	@SucDestino) 

select @Atc_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
     		Err_Mensaj = 'Relacion agregada correctamente', 
     		Atc_Numero= @Atc_Numero 
end
