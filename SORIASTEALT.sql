create procedure SORIASTEALT (
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
/* DESCRIPCION: Alta de Rib Aspectos Tecnicos					*/
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

DECLARE @Int_Uno int,     /*ENTERO UNO*/
	    @Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
	    
SELECT  @Int_Uno = 1,
	    @Int_DMenos1=-1.00

if (@Rat_BaCaIn = @Int_DMenos1) begin
		select @Rat_BaCaIn=null
	end

if (@Rat_CaInPo = @Int_DMenos1) begin
		select @Rat_CaInPo = null
	end

Insert Into SORIASTE 
	(Rat_NumRib,	Rat_CapIns,		Rat_BaCaIn,		Rat_TipMed,		Rat_OtBaCa,
	Rat_TurTra,		Rat_CaInPo,		Rat_ApCaAs,		Rat_CamAsp,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Rat_NumRib,    @Rat_CapIns,    @Rat_BaCaIn,    @Rat_TipMed,    @Rat_OtBaCa, 
	@Rat_TurTra,    @Rat_CaInPo,    @Rat_ApCaAs,    @Rat_CamAsp,    @NumTransac, 
	@Transaccio,    @Usuario,    	@FechaSis,    	@SucOrigen,    	@SucDestino) 

select @Rat_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select	Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rat_Numero= @Rat_Numero 
end
