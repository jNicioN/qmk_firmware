create procedure SOANESCOALT (
   @Aec_Numero numeric,
   @Aec_AnaEst int,
   @Aec_Concep varchar(100),
   @Aec_Monto numeric(10,2),
   @Aec_Porcen numeric(10,2),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2))  
 as

/*********************************************************************
** DESCRIPCION: alta de registros de analitica estandar concepto	**
**********************************************************************
** Creo:		Felipe Castillo Rendon                     			**
** Fecha:		19/05/2017                               			**
** Help:		929417 					 							**
*********************************************************************/

/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SOANESCO 
	(Aec_AnaEst,	Aec_Concep,		Aec_Monto,		Aec_Porcen,		NumTransac,
	Transaccio, 	Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Aec_AnaEst,	@Aec_Concep,	@Aec_Monto,		@Aec_Porcen,	@NumTransac,
	@Transaccio, 	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino) 

select @Aec_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Aec_Numero= @Aec_Numero 
end
