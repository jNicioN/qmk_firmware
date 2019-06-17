create procedure SORIASMEALT (
   @Ram_Numero int,
   @Ram_NumRib int,
   @Ram_ParMer numeric(10,2),
   @Ram_TiCaDi varchar(10),
   @Ram_MerCon varchar(6),
   @Ram_MedUti varchar(8),
   @Ram_LocVen numeric(10,2),
   @Ram_RegVen numeric(10,2),
   @Ram_NacVen numeric(10,2),
   @Ram_ExpVen numeric(10,2),

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de RIB Aspectos Mercado					*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Descripcion: se validan campos nulos						*/
/** Help:		1147681					 						*/
/****************************************************************/
/* Modifico:	Victor Osorio									*/
/* Fecha:		07/12/2017										*/
/* Descripcion:	Se cambia tipo de dato al parametro Ram_ParMer	*/
/* Help:		929417											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Constantes */
DECLARE @Int_Uno int,		/* Constante Entero Uno */
		@Int_DMenos1 int /*ENTERO MENOS UNO CON DECIMALES*/
		
		
SELECT  @Int_Uno = 1,
		@Int_DMenos1=-1.00
		
if (@Ram_ParMer = @Int_DMenos1) begin
		select @Ram_ParMer=null
end

if (@Ram_LocVen = @Int_DMenos1) begin
		select @Ram_LocVen=null
end

if (@Ram_RegVen = @Int_DMenos1) begin
		select @Ram_RegVen=null
end

if (@Ram_NacVen = @Int_DMenos1) begin
		select @Ram_NacVen=null
end

if (@Ram_ExpVen = @Int_DMenos1) begin
		select @Ram_ExpVen=null
end

Insert Into SORIASME 
	(Ram_NumRib,	Ram_ParMer,		Ram_TiCaDi,		Ram_MerCon,		Ram_MedUti,
	Ram_LocVen,		Ram_RegVen,		Ram_NacVen,		Ram_ExpVen,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
	values (
	@Ram_NumRib,    @Ram_ParMer,	@Ram_TiCaDi,    @Ram_MerCon,    @Ram_MedUti,
	@Ram_LocVen, 	@Ram_RegVen,    @Ram_NacVen,    @Ram_ExpVen,    @NumTransac,
	@Transaccio, 	@Usuario,    	@FechaSis,    	@SucOrigen,    	@SucDestino) 

select @Ram_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Ram_Numero= @Ram_Numero 
end
