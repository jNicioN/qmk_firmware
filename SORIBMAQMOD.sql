create procedure SORIBMAQMOD (
   @Rim_Numero int,
   @Rim_NumRib int,
   @Rim_TipMaq int,
   @Rim_ReMeMa numeric(12,2),
   @Rim_ArrMaq varchar(50),
   @Rim_AnCoMa int,
   @Rim_FVCoMa datetime,
   @Rim_AseMaq int,
   @Rim_AraMaq varchar(50),
   @Rim_PlPoMa int,
   @Rim_VePoMa datetime,
   @Rim_MoCoMa numeric(12,2),
   @Rim_MCMaMo varchar(3),
   @Rim_RMMaMo varchar(3),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Maquinaria de RIB	*/
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

if not exists (select Rim_Numero
                   from SORIBMAQ noholdlock
                   where Rim_Numero = @Rim_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rim_Numero) + ' No Existe',
           Err_Variab	= 'Rim_Numero'
   rollback
   return 1
end

if (@Rim_PlPoMa = @Int_Menos1) begin
		select @Rim_PlPoMa=null
end

if (@Rim_MoCoMa = @Int_DMenos1) begin
		select @Rim_MoCoMa=null
end

Update SORIBMAQ set 
   Rim_NumRib = @Rim_NumRib, 
   Rim_TipMaq = @Rim_TipMaq, 
   Rim_ReMeMa = @Rim_ReMeMa, 
   Rim_ArrMaq = @Rim_ArrMaq, 
   Rim_AnCoMa = @Rim_AnCoMa, 
   Rim_FVCoMa = @Rim_FVCoMa, 
   Rim_AseMaq = @Rim_AseMaq, 
   Rim_AraMaq = @Rim_AraMaq, 
   Rim_PlPoMa = @Rim_PlPoMa, 
   Rim_VePoMa = @Rim_VePoMa, 
   Rim_MoCoMa = @Rim_MoCoMa, 
   Rim_MCMaMo = @Rim_MCMaMo, 
   Rim_RMMaMo = @Rim_RMMaMo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rim_Numero = @Rim_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rim_Numero = @Rim_Numero
