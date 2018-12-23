create procedure SORICOAAMOD (
   @Rca_Numero int,
   @Rca_NumRib int,
   @Rca_Tipo int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Composicion		*/
/*				Accionaria Adicional de RIB						*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Rca_Numero
                   from SORICOAA noholdlock
                   where Rca_Numero = @Rca_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rca_Numero) + ' No Existe',
           Err_Variab	= 'Rca_Numero'
   rollback
   return 1
end

Update SORICOAA set 
   Rca_NumRib = @Rca_NumRib, 
   Rca_Tipo   = @Rca_Tipo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rca_Numero = @Rca_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rca_Numero = @Rca_Numero
