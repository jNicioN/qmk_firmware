create procedure SORIBCOMALT (
   @Ric_Numero int,
   @Ric_NumRib int,
   @Ric_Nombre varchar(50),
   @Ric_Ubicac varchar(255),
   @Ric_Ventaj varchar(50),
   @Ric_Desven varchar(50),
   @Ric_Activo bit,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Competidor de RIB			*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIBCOM 
	(Ric_NumRib,	Ric_Nombre,		Ric_Ubicac,		Ric_Ventaj,		Ric_Desven, 
	Ric_Activo,		NumTransac,		Transaccio,		Usuario,		FechaSis, 
	SucOrigen,		SucDestino) 
	values (   
	@Ric_NumRib,	@Ric_Nombre,	@Ric_Ubicac,	@Ric_Ventaj,	@Ric_Desven, 
	@Ric_Activo,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,		@SucDestino) 

select @Ric_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select	Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Ric_Numero= @Ric_Numero 
end
