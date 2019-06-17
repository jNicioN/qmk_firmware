create procedure SORIBPROMOD (
   @Rip_Numero int,
   @Rip_NumRib int,
   @Rip_Nombre varchar(100),
   @Rip_Filial int,
   @Rip_PorCom numeric(5,2),
   @Rip_Antigu varchar(30),
   @Rip_Insumo varchar(30),
   @Rip_Plazo int,
   @Rip_TipPro int,
   @Rip_Varios bit,
   @Rip_Activo bit,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Proveedores de RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

if not exists (select Rip_Numero
                   from SORIBPRO noholdlock
                   where Rip_Numero = @Rip_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El NÃºmero de ID: ' +  convert(varchar,@Rip_Numero) + ' No Existe',
           Err_Variab	= 'Rip_Numero'
   rollback
   return 1
end

Update SORIBPRO set 
   Rip_NumRib = @Rip_NumRib, 
   Rip_Nombre = @Rip_Nombre, 
   Rip_Filial = @Rip_Filial, 
   Rip_PorCom = @Rip_PorCom, 
   Rip_Antigu = @Rip_Antigu, 
   Rip_Insumo = @Rip_Insumo, 
   Rip_Plazo  = @Rip_Plazo, 
   Rip_TipPro = @Rip_TipPro, 
   Rip_Varios = @Rip_Varios,
   Rip_Activo = @Rip_Activo, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario    = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rip_Numero = @Rip_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rip_Numero = @Rip_Numero
