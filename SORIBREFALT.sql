create procedure SORIBREFALT (
   @Rir_Numero int,
   @Rir_NumRib int,
   @Rir_Fecha datetime,
   @Rir_Banco varchar(100),
   @Rir_NoEmCo varchar(75),
   @Rir_Coment varchar(255),
   @Rir_NomRef varchar(75),
   @Rir_TipRef int,
   @Rir_Activo bit,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Referencias de RIB			*/
/****************************************************************/
/** Modifico:	Edwin Dennis									*/
/** Fecha:		01/11/2018                               		*/
/** Descripcion: se validan fechas por default					*/
/** Help:		1147681					 						*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int,         /*ENTERO UNO*/
		@Date_Vacia datetime /*FECHA VACIA*/
SELECT  @Int_Uno = 1,
		@Date_Vacia='Jan  1 1900 12:00AM'
		
if(@Rir_Fecha = @Date_Vacia)begin
	select @Rir_Fecha=null
end	

Insert Into SORIBREF 
	(Rir_NumRib,	Rir_Fecha,		Rir_Banco,		Rir_NoEmCo,		Rir_Coment, 
	Rir_NomRef,		Rir_TipRef,		Rir_Activo,		NumTransac,		Transaccio,
	Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Rir_NumRib,	@Rir_Fecha,		@Rir_Banco,		@Rir_NoEmCo,	@Rir_Coment,
	@Rir_NomRef,    @Rir_TipRef,    @Rir_Activo,    @NumTransac,    @Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino) 

select @Rir_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rir_Numero= @Rir_Numero 
end
