create procedure SORILIOTALT (
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
/* DESCRIPCION: Alta de registros de Rib Lineas Autorizadas de	*/
/*				RIB												*/
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
declare	@Int_Activo int,   /*ENTERO ACTIVO*/
		@Int_Uno int,      /*ENTERO UNO*/
		@Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/
		
select	@Int_Activo = 1,
		@Int_Uno = 1,
	    @Int_DMenos1=-1.00
		
if (@Rlo_MonAut = @Int_DMenos1) begin
		select @Rlo_MonAut=null
end

if (@Rlo_Respon = @Int_DMenos1) begin
		select @Rlo_Respon=null
end

if (@Rlo_PagMen = @Int_DMenos1) begin
		select @Rlo_PagMen=null
end


Insert Into SORILIOT(
		Rlo_NumRib,		Rlo_Instit,		Rlo_TipCre,		Rlo_MonAut,		Rlo_Respon,
		Rlo_Moneda,		Rlo_Plazo,		Rlo_Tasa,		Rlo_Avales,		Rlo_Garant,
		Rlo_Total,		Rlo_PagMen,		Rlo_Destin,		Rlo_Activo,		NumTransac,
		Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino) 
values (@Rlo_NumRib,	@Rlo_Instit,	@Rlo_TipCre,	@Rlo_MonAut,	@Rlo_Respon,
		@Rlo_Moneda,	@Rlo_Plazo,		@Rlo_Tasa,		@Rlo_Avales,	@Rlo_Garant,
		@Rlo_Total,		@Rlo_PagMen,	@Rlo_Destin,	@Int_Activo,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @Rlo_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select	Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rlo_Numero= @Rlo_Numero 
end
