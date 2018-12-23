create procedure SORIASMEMOD (
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
/* DESCRIPCION: Modificacion de RIB Aspectos Mercado			*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Descripcion: se validan campos nulos						*/
/** Help:		1147681					 						*/
/****************************************************************/
/* Modifico:	Victor Osorio									*/
/* Fecha:		07/12/2017										*/
/* Help:		929417											*/
/* Descripcion:	Se modifica parametro Ram_ParMer a numeric		*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Constantes */
DECLARE @Int_DMenos1 int /*ENTERO MENOS UNO CON DECIMALES*/
		
SELECT  @Int_DMenos1=-1.00

if not exists (select Ram_Numero
                   from SORIASME noholdlock
                   where Ram_Numero = @Ram_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj = 'El Numero de ID: ' +  convert(varchar,@Ram_Numero) + ' No Existe',
           Err_Variab = 'Ram_Numero'
   rollback
   return 1
end

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

Update SORIASME set 
   Ram_NumRib = @Ram_NumRib,
   Ram_ParMer = @Ram_ParMer,
   Ram_TiCaDi = @Ram_TiCaDi, 
   Ram_MerCon = @Ram_MerCon, 
   Ram_MedUti = @Ram_MedUti, 
   Ram_LocVen = @Ram_LocVen, 
   Ram_RegVen = @Ram_RegVen, 
   Ram_NacVen = @Ram_NacVen, 
   Ram_ExpVen = @Ram_ExpVen, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Ram_Numero = @Ram_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ram_Numero = @Ram_Numero
