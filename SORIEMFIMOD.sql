create procedure SORIEMFIMOD (
   @Ref_Numero int,
   @Ref_NumRib int,
   @Ref_NumPer char(8),
   @Ref_PriAct varchar(50),
   @Ref_TiReNe int,
   @Ref_TiReOt varchar(50),
   @Ref_PeSiRf int,
   @Ref_Activo bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Empresas Filiales	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Ref_Numero
                   from SORIEMFI noholdlock
                   where Ref_Numero = @Ref_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Ref_Numero) + ' No Existe',
           Err_Variab	= 'Ref_Numero'
   rollback
   return 1
end

Update SORIEMFI set 
   Ref_NumRib = @Ref_NumRib, 
   Ref_NumPer = @Ref_NumPer, 
   Ref_PriAct = @Ref_PriAct, 
   Ref_TiReNe = @Ref_TiReNe, 
   Ref_TiReOt = @Ref_TiReOt, 
   Ref_PeSiRf = @Ref_PeSiRf, 
   Ref_Activo = @Ref_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Ref_Numero = @Ref_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ref_Numero = @Ref_Numero
