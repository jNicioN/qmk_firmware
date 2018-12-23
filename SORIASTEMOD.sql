create procedure SORIASTEMOD (
   @Rat_Numero int,
   @Rat_NumRib int,
   @Rat_CapIns int,
   @Rat_BaCaIn numeric(5,2),
   @Rat_TipMed int,
   @Rat_OtBaCa varchar(20),
   @Rat_TurTra int,
   @Rat_CaInPo numeric(5,2),
   @Rat_ApCaAs int,
   @Rat_CamAsp varchar(255),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de Rib Aspectos Tecnicos			*/
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
/* Declaracion de Variables */

DECLARE @Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
	    
SELECT  @Int_DMenos1=-1.00

if not exists (select Rat_Numero
                   from SORIASTE noholdlock
                   where Rat_Numero = @Rat_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rat_Numero) + ' No Existe',
           Err_Variab	= 'Rat_Numero'
   rollback
   return 1
end

if (@Rat_BaCaIn = @Int_DMenos1) begin
		select @Rat_BaCaIn=null
	end

if (@Rat_CaInPo = @Int_DMenos1) begin
		select @Rat_CaInPo = null
	end

Update SORIASTE set 
   Rat_NumRib = @Rat_NumRib, 
   Rat_CapIns = @Rat_CapIns, 
   Rat_BaCaIn = @Rat_BaCaIn, 
   Rat_TipMed = @Rat_TipMed, 
   Rat_OtBaCa = @Rat_OtBaCa, 
   Rat_TurTra = @Rat_TurTra, 
   Rat_CaInPo = @Rat_CaInPo, 
   Rat_ApCaAs = @Rat_ApCaAs, 
   Rat_CamAsp = @Rat_CamAsp, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario 	  = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rat_Numero = @Rat_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rat_Numero = @Rat_Numero
