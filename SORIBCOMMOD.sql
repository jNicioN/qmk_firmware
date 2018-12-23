create procedure SORIBCOMMOD (
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
/* DESCRIPCION: Modificacion de registros de Competidores de RIB*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Ric_Numero
                   from SORIBCOM noholdlock
                   where Ric_Numero = @Ric_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Ric_Numero) + ' No Existe',
           Err_Variab	= 'Ric_Numero'
   rollback
   return 1
end

Update SORIBCOM set
	Ric_NumRib = @Ric_NumRib, 
	Ric_Nombre = @Ric_Nombre, 
	Ric_Ubicac = @Ric_Ubicac, 
	Ric_Ventaj = @Ric_Ventaj, 
	Ric_Desven = @Ric_Desven, 
	Ric_Activo = @Ric_Activo, 
	NumTransac = @NumTransac, 
	Transaccio = @Transaccio, 
	Usuario = @Usuario, 
	FechaSis = @FechaSis, 
	SucOrigen = @SucOrigen, 
	SucDestino = @SucDestino
	where Ric_Numero = @Ric_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ric_Numero = @Ric_Numero
