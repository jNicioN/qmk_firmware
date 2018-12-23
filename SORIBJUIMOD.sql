create procedure SORIBJUIMOD (
   @Rij_Numero int,
   @Rij_NumRib int,
   @Rij_TipJui int,
   @Rij_FecAct datetime,
   @Rij_Descri varchar(50),
   @Rij_Activo bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Juicios de RIB		*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Rij_Numero
                   from SORIBJUI noholdlock
                   where Rij_Numero = @Rij_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rij_Numero) + ' No Existe',
           Err_Variab	= 'Rij_Numero'
   rollback
   return 1
end

Update SORIBJUI set 
   Rij_NumRib = @Rij_NumRib, 
   Rij_TipJui = @Rij_TipJui, 
   Rij_FecAct = @Rij_FecAct, 
   Rij_Descri = @Rij_Descri, 
   Rij_Activo = @Rij_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rij_Numero = @Rij_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rij_Numero = @Rij_Numero
