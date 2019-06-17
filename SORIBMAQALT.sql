create procedure SORIBMAQALT (
   @Rim_Numero int,
   @Rim_NumRib int,
   @Rim_TipMaq int,
   @Rim_ReMeMa numeric(12,2),
   @Rim_ArrMaq varchar(50),
   @Rim_AnCoMa int,
   @Rim_FVCoMa datetime,
   @Rim_AseMaq bit,
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
/* DESCRIPCION: Alta de registros de Maquinaria de RIB			*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Descripcion: se validan campos nulos						*/
/** Help:		1147681					 						*/
/****************************************************************/
/* Modifico:	Felipe Castillo Rendon							*/
/* Fecha:		11/04/2018										*/
/* Descripcion:	Se cambia tipo de dato Rim_AseMaq				*/
/* Help:		1105258											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Constantes */

DECLARE @Int_Uno int,     /*ENTERO UNO*/
	    @Int_Menos1 int,  /*ENTERO MENOS UNO*/
	    @Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
	    
SELECT  @Int_Uno = 1,
	    @Int_Menos1=-1,
	    @Int_DMenos1=-1.00

if (@Rim_PlPoMa = @Int_Menos1) begin
		select @Rim_PlPoMa=null
end

if (@Rim_MoCoMa = @Int_DMenos1) begin
		select @Rim_MoCoMa=null
end


Insert Into SORIBMAQ 
	(Rim_NumRib,	Rim_TipMaq,		Rim_ReMeMa,		Rim_ArrMaq,		Rim_AnCoMa, 
	Rim_FVCoMa,		Rim_AseMaq,		Rim_AraMaq,		Rim_PlPoMa,		Rim_VePoMa, 
	Rim_MoCoMa,		Rim_MCMaMo,		Rim_RMMaMo,		NumTransac,		Transaccio, 
	Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Rim_NumRib,    @Rim_TipMaq,    @Rim_ReMeMa,    @Rim_ArrMaq,    @Rim_AnCoMa, 
	@Rim_FVCoMa,    @Rim_AseMaq,    @Rim_AraMaq,    @Rim_PlPoMa,    @Rim_VePoMa, 
	@Rim_MoCoMa,    @Rim_MCMaMo,    @Rim_RMMaMo,    @NumTransac,    @Transaccio, 
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino) 

select @Rim_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rim_Numero= @Rim_Numero 
end
