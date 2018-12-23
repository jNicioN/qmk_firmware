create procedure SORIPLESMOD (
   @Rpe_Numero int,
   @Rpe_NumRib int,
   @Rpe_Coloca numeric(10,2),
   @Rpe_Captac numeric(10,2),
   @Rpe_Servic varchar(100),
   @Rpe_Atribu varchar(250),
   @Rpe_Riesgo varchar(250),
   @Rpe_TipEst int,
   @Rpe_Moneda varchar(3),
   @Rpe_TiCaCo numeric(10,4),
   @Rpe_TiCaVe numeric(10,4),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Plan Estrategia	*/
/*				Cuenta de RIB									*/
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
DECLARE @Int_DMenos1 int, /*ENTERO MENOS UNO CON DECIMALES*/
		@Int_Menos1 int  /*ENTERO MENOS UNO*/
		
SELECT  @Int_DMenos1=-1.00,
		@Int_Menos1=-1

if not exists (select Rpe_Numero
                   from SORIPLES noholdlock
                   where Rpe_Numero = @Rpe_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rpe_Numero) + ' No Existe',
           Err_Variab	= 'Rpe_Numero'
   rollback
   return 1
end

if (@Rpe_Coloca = @Int_DMenos1) begin
		select @Rpe_Coloca=null
end

if (@Rpe_Captac = @Int_DMenos1) begin
		select @Rpe_Captac=null
end


if (@Rpe_TiCaCo = @Int_DMenos1) begin
		select @Rpe_TiCaCo=null
end

if (@Rpe_TiCaVe = @Int_DMenos1) begin
		select @Rpe_TiCaVe=null
end

if (@Rpe_TipEst = @Int_Menos1) begin
		select @Rpe_TipEst=null
end

Update SORIPLES set 
   Rpe_NumRib = @Rpe_NumRib, 
   Rpe_Coloca = @Rpe_Coloca, 
   Rpe_Captac = @Rpe_Captac, 
   Rpe_Servic = @Rpe_Servic, 
   Rpe_Atribu = @Rpe_Atribu, 
   Rpe_Riesgo = @Rpe_Riesgo, 
   Rpe_TipEst = @Rpe_TipEst, 
   Rpe_Moneda = @Rpe_Moneda, 
   Rpe_TiCaCo = @Rpe_TiCaCo, 
   Rpe_TiCaVe = @Rpe_TiCaVe, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario 	  = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rpe_Numero = @Rpe_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rpe_Numero = @Rpe_Numero
