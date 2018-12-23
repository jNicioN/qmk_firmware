create procedure SORIPRSEMOD (
   @Rps_Numero int,
   @Rps_NumRib int,
   @Rps_ProSer varchar(50),
   @Rps_MarCom varchar(50),
   @Rps_PoVeIn numeric(10,2),
   @Rps_Activo bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Productos Servicios*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Rps_Numero
                   from SORIPRSE noholdlock
                   where Rps_Numero = @Rps_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rps_Numero) + ' No Existe',
           Err_Variab	= 'Rps_Numero'
   rollback
   return 1
end

Update SORIPRSE set 
   Rps_NumRib = @Rps_NumRib, 
   Rps_ProSer = @Rps_ProSer, 
   Rps_MarCom = @Rps_MarCom, 
   Rps_PoVeIn = @Rps_PoVeIn, 
   Rps_Activo = @Rps_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rps_Numero = @Rps_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rps_Numero = @Rps_Numero
