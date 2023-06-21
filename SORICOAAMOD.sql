create procedure SORICOAAMOD (
   @Rca_Numero int,
   @Rca_NumRib int,
   @Rca_Tipo int,
   @Rca_PoPaMu numeric,
   @Rca_ConMuj int,
   @Rca_PeAlDi int,
   @Rca_MuAlDi int,
   @Rca_DiPrMi bit,
   @Rca_GeDiGe int,
   @Rca_GePrCo int,
   
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
/* Modifico:	Raul Muniz										*/
/* Fecha:		21/06/2023										*/
/* C.Cambios:	29013											*/
/* Descripcion: Se agregan campos de inclusion de la mujer		*/
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
   Rca_PoPaMu = @Rca_PoPaMu,
   Rca_ConMuj = @Rca_ConMuj,
   Rca_PeAlDi = @Rca_PeAlDi,
   Rca_MuAlDi = @Rca_MuAlDi,
   Rca_DiPrMi = @Rca_DiPrMi,
   Rca_GeDiGe = @Rca_GeDiGe,
   Rca_GePrCo = @Rca_GePrCo,
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