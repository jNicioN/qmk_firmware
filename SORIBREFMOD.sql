create procedure SORIBREFMOD (
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
/* DESCRIPCION: Modificacion registros de Referencias de RIB	*/
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
DECLARE @Date_Vacia datetime /*FECHA VACIA*/

SELECT  @Date_Vacia='Jan  1 1900 12:00AM'

if not exists (select Rir_Numero
                   from SORIBREF noholdlock
                   where Rir_Numero = @Rir_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Numero de ID: ' +  convert(varchar,@Rir_Numero) + ' No Existe',
           Err_Variab	= 'Rir_Numero'
   rollback
   return 1
end

if(@Rir_Fecha = @Date_Vacia)begin
	select @Rir_Fecha=null
end	

Update SORIBREF set 
   Rir_NumRib = @Rir_NumRib, 
   Rir_Fecha  = @Rir_Fecha, 
   Rir_Banco  = @Rir_Banco, 
   Rir_NoEmCo = @Rir_NoEmCo, 
   Rir_Coment = @Rir_Coment, 
   Rir_NomRef = @Rir_NomRef, 
   Rir_TipRef = @Rir_TipRef, 
   Rir_Activo = @Rir_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rir_Numero = @Rir_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rir_Numero = @Rir_Numero
