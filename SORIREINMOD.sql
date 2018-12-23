create procedure SORIREINMOD (
   @Rri_Numero int,
   @Rri_NumRib int,
   @Rri_Instit varchar(75),
   @Rri_Produc varchar(100),
   @Rri_PorPar int,
   @Rri_FePrC1 datetime,
   @Rri_MoPrC1 numeric(10,2),
   @Rri_MoPrC2 numeric(10,2),
   @Rri_MoPrC3 numeric(10,2),
   @Rri_FePrC2 datetime,
   @Rri_FePrC3 datetime,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Relacion de		*/
/*				Instituciones de RIB							*/
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
DECLARE	@Int_Menos1 int,  /*ENTERO MENOS UNO*/
	    @Date_Vacia datetime /*FECHA VACIA*/

SELECT	@Int_Menos1=-1,
	    @Date_Vacia='Jan  1 1900 12:00AM'

if not exists (select Rri_Numero
                   from SORIREIN noholdlock
                   where Rri_Numero = @Rri_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Numero de ID: ' +  convert(varchar,@Rri_Numero) + ' No Existe',
           Err_Variab	= 'Rri_Numero'
   rollback
   return 1
end


if (@Rri_PorPar = @Int_Menos1) begin
		select @Rri_PorPar=null
	end


if (@Rri_MoPrC1 = @Int_Menos1) begin
		select @Rri_MoPrC1=null
	end

if (@Rri_MoPrC2 = @Int_Menos1) begin
		select @Rri_MoPrC2=null
	end

if (@Rri_MoPrC3 = @Int_Menos1) begin
		select @Rri_MoPrC3=null
	end

if(@Rri_FePrC1 = @Date_Vacia)begin
	select @Rri_FePrC1=null
end	

if(@Rri_FePrC2 = @Date_Vacia)begin
	select @Rri_FePrC2=null
end	

if(@Rri_FePrC3 = @Date_Vacia)begin
	select @Rri_FePrC3=null
end	

Update SORIREIN set 
   Rri_NumRib	= @Rri_NumRib, 
   Rri_Instit	= @Rri_Instit, 
   Rri_Produc	= @Rri_Produc, 
   Rri_PorPar	= @Rri_PorPar, 
   Rri_FePrC1	= @Rri_FePrC1, 
   Rri_MoPrC1	= @Rri_MoPrC1, 
   Rri_MoPrC2	= @Rri_MoPrC2, 
   Rri_MoPrC3	= @Rri_MoPrC3, 
   Rri_FePrC2	= @Rri_FePrC2, 
   Rri_FePrC3	= @Rri_FePrC3, 
   NumTransac	= @NumTransac, 
   Transaccio	= @Transaccio, 
   Usuario		= @Usuario, 
   FechaSis		= @FechaSis, 
   SucOrigen	= @SucOrigen, 
   SucDestino	= @SucDestino
where Rri_Numero = @Rri_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rri_Numero = @Rri_Numero
