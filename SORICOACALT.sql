create procedure SORICOACALT (
   @Rca_Numero int,
   @Rca_NumRib int,
   @Rca_CoPaGP int,
   @Rca_TipAdm int,
   @Rca_NuCoTo int,
   @Rca_NuCoIn int,
   @Rca_TiAdUn int,
   @Rca_PlaSuc varchar(130),
   @Rca_OrAdSe int,
   @Rca_ArACIn int,
   @Rca_PrCuAd int,
   @Rca_CuExBa int,
   @Rca_CuExPr int,
   @Rca_EdFiAu int,
   @Rca_PrExBa int,
   @Rca_ExPoPr int,
   @Rca_InArRi int,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Composicion Accionaria de	*/
/*				RIB												*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Help:		1147681					 						*/
/** Descripcion: se validan campos nulos						*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/

/* Declaracion de Constantes */
DECLARE @Int_Uno int,    /*Entero Uno*/
	    @Int_Menos1 int  /*Entero Menos Uno*/
		 
SELECT  @Int_Uno = 1,
		@Int_Menos1=-1


if (@Rca_CuExBa = @Int_Menos1) begin
	select @Rca_CuExBa=null
end

if (@Rca_NuCoTo = @Int_Menos1) begin
	select @Rca_NuCoTo=null
end

if (@Rca_NuCoIn = @Int_Menos1) begin
	select @Rca_NuCoIn=null
end

if (@Rca_CuExPr = @Int_Menos1) begin
	select @Rca_CuExPr=null
end

if (@Rca_CoPaGP = @Int_Menos1) begin
	select @Rca_CoPaGP=null
end

if (@Rca_ExPoPr = @Int_Menos1) begin
	select @Rca_ExPoPr=null
end

if (@Rca_InArRi = @Int_Menos1) begin
	select @Rca_InArRi=null
end

Insert Into SORICOAC 
	(Rca_NumRib,	Rca_CoPaGP,		Rca_TipAdm,		Rca_NuCoTo,		Rca_NuCoIn, 
	Rca_TiAdUn,		Rca_PlaSuc,		Rca_OrAdSe,		Rca_ArACIn,		Rca_PrCuAd,
	Rca_CuExBa,		Rca_CuExPr,		Rca_EdFiAu,		Rca_PrExBa,		Rca_ExPoPr,
	Rca_InArRi,		NumTransac,		Transaccio,		Usuario,		FechaSis,
	SucOrigen,		SucDestino) 
	values(
	@Rca_NumRib,    @Rca_CoPaGP,    @Rca_TipAdm,    @Rca_NuCoTo,    @Rca_NuCoIn,
	@Rca_TiAdUn,	@Rca_PlaSuc,	@Rca_OrAdSe,	@Rca_ArACIn,	@Rca_PrCuAd,
	@Rca_CuExBa,	@Rca_CuExPr,	@Rca_EdFiAu,	@Rca_PrExBa,	@Rca_ExPoPr,
	@Rca_InArRi,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino) 

select @Rca_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rca_Numero= @Rca_Numero 
end
