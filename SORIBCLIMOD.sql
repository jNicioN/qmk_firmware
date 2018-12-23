create procedure SORIBCLIMOD (
   @Ric_Numero int,
   @Ric_NumRib int,
   @Ric_Nombre varchar(100),
   @Ric_Filial int,
   @Ric_Ventas numeric(5,2),
   @Ric_Carter numeric(5,2),
   @Ric_Antigu varchar(30),
   @Ric_Plazo int,
   @Ric_Ubicac varchar(255),
   @Ric_Varios bit,
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
/* DESCRIPCION: Modificacion de registros de Clientes de RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Ric_Numero
                   from SORIBCLI noholdlock
                   where Ric_Numero = @Ric_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Ric_Numero) + ' No Existe',
           Err_Variab	= 'Ric_Numero'
   rollback
   return 1
end

Update SORIBCLI set 
   Ric_NumRib = @Ric_NumRib, 
   Ric_Nombre = @Ric_Nombre, 
   Ric_Filial = @Ric_Filial, 
   Ric_Ventas = @Ric_Ventas, 
   Ric_Carter = @Ric_Carter, 
   Ric_Antigu = @Ric_Antigu, 
   Ric_Plazo  = @Ric_Plazo, 
   Ric_Ubicac = @Ric_Ubicac, 
   Ric_Varios = @Ric_Varios, 
   Ric_Activo = @Ric_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Ric_Numero = @Ric_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ric_Numero = @Ric_Numero
