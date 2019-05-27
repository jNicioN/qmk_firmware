create procedure SORIPOFIMOD (
   @Rpf_Numero int,
   @Rpf_NumRib int,
   @Rpf_Politi varchar(75),
   @Rpf_DCPoCo varchar(4),
   @Rpf_DiaInv varchar(4),
   @Rpf_DiaPro varchar(4),
   @Rpf_PerPic varchar(50),
   @Rpf_PerRec varchar(50),
   @Rpf_ComCic varchar(2),
   @Rpf_PolInv varchar(75),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Politica Financiera*/
/****************************************************************/
/* Modifico:	Edwin Santiago Marcial							*/
/* Descripcion:	Se modifica longitud de parametros de entrada	*/
/* Rpf_DCPoCo, Rpf_DiaInv, Rpf_DiaPro 							*/
/* Fecha:		03/05/2019										*/
/* Help:		1240903											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/

/* Declaracion de Variables */

if not exists (select Rpf_Numero
                   from SORIPOFI noholdlock
                   where Rpf_Numero = @Rpf_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Numero de ID: ' +  convert(varchar,@Rpf_Numero) + ' No Existe',
           Err_Variab	= 'Rpf_Numero'
   rollback
   return 1
end

Update SORIPOFI set 
   Rpf_NumRib = @Rpf_NumRib, 
   Rpf_Politi = @Rpf_Politi, 
   Rpf_DCPoCo = @Rpf_DCPoCo, 
   Rpf_DiaInv = @Rpf_DiaInv, 
   Rpf_DiaPro = @Rpf_DiaPro, 
   Rpf_PerPic = @Rpf_PerPic, 
   Rpf_PerRec = @Rpf_PerRec, 
   Rpf_ComCic = @Rpf_ComCic, 
   Rpf_PolInv = @Rpf_PolInv, 
   NumTransac = @NumTransac, 
   Transaccio = @Transaccio, 
   Usuario 	  = @Usuario, 
   FechaSis   = @FechaSis, 
   SucOrigen  = @SucOrigen, 
   SucDestino = @SucDestino
where Rpf_Numero = @Rpf_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rpf_Numero = @Rpf_Numero