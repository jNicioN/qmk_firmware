create procedure SORIASTEACT (
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
    @Tip_Actual char(1),
    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario char(6),
    @FechaSis smalldatetime,
    @SucOrigen char(3),
    @SucDestino char(3),
    @Modulo char(2)) 
as
/****************************************************************/
/* DESCRIPCION: Actualizacion de RIB Aspectos Tecnicos			*/
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

/* Declaracion de constantes */
declare	@Tip_ActA char(1), /*	Actualiza los valores del Panel Aspectos Tecnicos Capacidad Instalada*/
		@Tip_ActB char(1), /*	Actualiza los valores del Panel Aspectos Tecnicos Cambios Tecnicos Produccion*/
	    @Int_DMenos1 int  /*ENTERO MENOS UNO CON DECIMALES*/

/* Asignacion de constantes */
select	@Tip_ActA = 'A',	
		@Tip_ActA = 'B',	
	    @Int_DMenos1=-1.00
	    
	    
if (@Rat_BaCaIn = @Int_DMenos1) begin
		select @Rat_BaCaIn=null
	end

if (@Rat_CaInPo = @Int_DMenos1) begin
		select @Rat_CaInPo = null
	end
		
if @Tip_Actual = @Tip_ActA begin
	
	update SORIASTE set 
		Rat_CapIns	= @Rat_CapIns, 
		Rat_BaCaIn	= @Rat_BaCaIn,
		Rat_TipMed	= @Rat_TipMed,
		Rat_OtBaCa	= @Rat_OtBaCa,
		Rat_TurTra	= @Rat_TurTra, 
		Rat_CaInPo	= @Rat_CaInPo,
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
		where Rat_Numero = @Rat_Numero
	
	select	Err_Codigo	= '000000',	Err_Mensaj	= 'Registro Actualizado'
end

if @Tip_Actual = @Tip_ActB begin
	update SORIASTE set 
		Rat_ApCaAs	= @Rat_ApCaAs, 
		Rat_CamAsp	= @Rat_CamAsp,
		NumTransac = @NumTransac, 
		Transaccio = @Transaccio, 
		Usuario    = @Usuario, 
		FechaSis   = @FechaSis, 
		SucOrigen  = @SucOrigen, 
		SucDestino = @SucDestino
		where Rat_Numero = @Rat_Numero

	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end
