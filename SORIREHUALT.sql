create procedure SORIREHUALT (
   @Rrh_Numero int,
   @Rrh_NumRib int,
   @Rrh_NumEmp int,
   @Rrh_NumObr int,
   @Rrh_NumEve int,
   @Rrh_Otros int,
   @Rrh_Sindic varchar(50),
   @Rrh_AmbLab varchar(50),
   @Rrh_NumPer char(8),
   @Rrh_AniGir int,
   @Rrh_AniEmp int,
   @Rrh_Admini int,
   @Rrh_Ventas int,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Recursos Humanos de RIB	*/
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
		@Int_Menos1 int  /*ENTERO MENOS UNO*/
		
SELECT  @Int_Uno = 1,
		@Int_Menos1=-1
		
if (@Rrh_NumEmp = @Int_Menos1) begin
		select @Rrh_NumEmp=null
	end

if (@Rrh_NumObr = @Int_Menos1) begin
		select @Rrh_NumObr=null
	end	

if (@Rrh_NumEve = @Int_Menos1) begin
		select @Rrh_NumEve=null
	end	
	
if (@Rrh_Otros = @Int_Menos1) begin
		select @Rrh_Otros=null
	end	
	
if (@Rrh_AniGir = @Int_Menos1) begin
		select @Rrh_AniGir=null
	end	

if (@Rrh_AniEmp = @Int_Menos1) begin
		select @Rrh_AniEmp=null
	end	
	
if (@Rrh_Admini = @Int_Menos1) begin
		select @Rrh_Admini=null
	end

if (@Rrh_Ventas = @Int_Menos1) begin
		select @Rrh_Ventas=null
	end
	
Insert Into SORIREHU 
	(Rrh_NumRib,	Rrh_NumEmp,		Rrh_NumObr,		Rrh_NumEve,		Rrh_Otros,
	Rrh_Sindic,		Rrh_AmbLab,		Rrh_NumPer,		Rrh_AniGir,		Rrh_AniEmp,
	Rrh_Admini,		Rrh_Ventas,		NumTransac,		Transaccio,		Usuario, 
	FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Rrh_NumRib,    @Rrh_NumEmp,    @Rrh_NumObr,    @Rrh_NumEve,    @Rrh_Otros, 
	@Rrh_Sindic,    @Rrh_AmbLab,    @Rrh_NumPer,    @Rrh_AniGir,    @Rrh_AniEmp, 
	@Rrh_Admini,    @Rrh_Ventas,    @NumTransac,    @Transaccio,    @Usuario, 
	@FechaSis,		@SucOrigen,		@SucDestino) 

select @Rrh_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rrh_Numero= @Rrh_Numero 
end
