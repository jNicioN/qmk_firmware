create procedure SORIBINSMOD (
   @Rii_Numero int,
   @Rii_NumRib int,
   @Rii_TipIns int,
   @Rii_Por varchar(50),
   @Rii_ReMeIn numeric(12,2),
   @Rii_RMInMo int,
   @Rii_ArrIns varchar(50),
   @Rii_AnCoIn int,
   @Rii_VeCoIn datetime,
   @Rii_AseIns int,
   @Rii_AraIns varchar(50),
   @Rii_PlPoIn int,
   @Rii_VePoIn datetime,
   @Rii_MoCoIn numeric(12,2),
   @Rii_MCInMo int,
   @Rii_CubInc bit,
   @Rii_CubTer bit,
   @Rii_CubHur bit,
   @Rii_CubInu bit,
   @Rii_CubOtr bit,
   @Rii_CuOtEs varchar(20),
   @Rii_PrePor varchar(50),
   @Rii_RMInVa numeric(12,2),
   @Rii_RMIVaM int,
   @Rii_RMInPa numeric(12,2),
   @Rii_RMIPaM int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion registros de Instalaciones de RIB	*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Descripcion: se validan campos nulos						*/
/** Help:		1147681					 						*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Constantes */

DECLARE @Int_Menos1 int,  /*ENTERO MENOS UNO*/
	    @Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
	    
SELECT  @Int_Menos1=-1,
	    @Int_DMenos1=-1.00

if not exists (select Rii_Numero
                   from SORIBINS noholdlock
                   where Rii_Numero = @Rii_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rii_Numero) + ' No Existe',
           Err_Variab	= 'Rii_Numero'
   rollback
   return 1
end

if (@Rii_PlPoIn = @Int_Menos1) begin
		select @Rii_PlPoIn=null
end

if (@Rii_MoCoIn = @Int_DMenos1) begin
		select @Rii_MoCoIn=null
end

if (@Rii_RMInVa = @Int_DMenos1) begin
		select @Rii_RMInVa=null
end

if (@Rii_TipIns = @Int_Menos1) begin
		select @Rii_TipIns=null
end

Update SORIBINS set 
   Rii_NumRib = @Rii_NumRib, 
   Rii_TipIns = @Rii_TipIns, 
   Rii_Por 	  = @Rii_Por, 
   Rii_ReMeIn = @Rii_ReMeIn, 
   Rii_RMInMo = @Rii_RMInMo, 
   Rii_ArrIns = @Rii_ArrIns, 
   Rii_AnCoIn = @Rii_AnCoIn, 
   Rii_VeCoIn = @Rii_VeCoIn, 
   Rii_AseIns = @Rii_AseIns, 
   Rii_AraIns = @Rii_AraIns, 
   Rii_PlPoIn = @Rii_PlPoIn, 
   Rii_VePoIn = @Rii_VePoIn, 
   Rii_MoCoIn = @Rii_MoCoIn, 
   Rii_MCInMo = @Rii_MCInMo, 
   Rii_CubInc = @Rii_CubInc, 
   Rii_CubTer = @Rii_CubTer, 
   Rii_CubHur = @Rii_CubHur, 
   Rii_CubInu = @Rii_CubInu, 
   Rii_CubOtr = @Rii_CubOtr, 
   Rii_CuOtEs = @Rii_CuOtEs, 
   Rii_PrePor = @Rii_PrePor, 
   Rii_RMInVa = @Rii_RMInVa, 
   Rii_RMIVaM = @Rii_RMIVaM, 
   Rii_RMInPa = @Rii_RMInPa, 
   Rii_RMIPaM = @Rii_RMIPaM, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rii_Numero = @Rii_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rii_Numero = @Rii_Numero
