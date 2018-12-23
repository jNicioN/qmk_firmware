create procedure SORILIOTMOD (
   @Rlo_Numero int,
   @Rlo_NumRib int,
   @Rlo_Instit varchar(50),
   @Rlo_TipCre varchar(50),
   @Rlo_MonAut numeric(10,2),
   @Rlo_Respon numeric(10,2),
   @Rlo_Moneda varchar(2),
   @Rlo_Plazo varchar(50),
   @Rlo_Tasa varchar(50),
   @Rlo_Avales varchar(75),
   @Rlo_Garant varchar(75),
   @Rlo_Total numeric(10,2),
   @Rlo_PagMen numeric(10,2),
   @Rlo_Destin varchar(100),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Rib Lineas			*/
/*				Autorizadas en la tabla SORILIOT				*/
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
declare	@Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
		
select	@Int_DMenos1=-1.00

if not exists (select Rlo_Numero
                   from SORILIOT noholdlock
                   where Rlo_Numero = @Rlo_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rlo_Numero) + ' No Existe',
           Err_Variab	= 'Rlo_Numero'
   rollback
   return 1
end

if (@Rlo_MonAut = @Int_DMenos1) begin
		select @Rlo_MonAut=null
end

if (@Rlo_Respon = @Int_DMenos1) begin
		select @Rlo_Respon=null
end

if (@Rlo_PagMen = @Int_DMenos1) begin
		select @Rlo_PagMen=null
end

Update SORILIOT set 
   Rlo_NumRib	= @Rlo_NumRib, 
   Rlo_Instit	= @Rlo_Instit, 
   Rlo_TipCre	= @Rlo_TipCre, 
   Rlo_MonAut	= @Rlo_MonAut, 
   Rlo_Respon	= @Rlo_Respon, 
   Rlo_Moneda	= @Rlo_Moneda, 
   Rlo_Plazo	= @Rlo_Plazo, 
   Rlo_Tasa		= @Rlo_Tasa, 
   Rlo_Avales	= @Rlo_Avales, 
   Rlo_Garant	= @Rlo_Garant, 
   Rlo_Total	= @Rlo_Total, 
   Rlo_PagMen	= @Rlo_PagMen, 
   Rlo_Destin	= @Rlo_Destin, 
   NumTransac	= @NumTransac, 
   Transaccio	= @Transaccio, 
   Usuario		= @Usuario, 
   FechaSis		= @FechaSis, 
   SucOrigen	= @SucOrigen, 
   SucDestino	= @SucDestino
where Rlo_Numero = @Rlo_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rlo_Numero = @Rlo_Numero
