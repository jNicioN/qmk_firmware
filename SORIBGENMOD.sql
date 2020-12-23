create procedure SORIBGENMOD (
   @Rig_Numero int,
   @Rig_NumRib int,
   @Rig_ActCre int,
   @Rig_TiDeGo int,
   @Rig_DepGob int,
   @Rig_TieExp int,
   @Rig_Export int,
   @Rig_TiGeDi int,
   @Rig_GeCoMa int,
   @Rig_Activo bit,
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/********************************************************************/
/* DESCRIPCION: Modificacion de registros de Generalidades de RIB	*/
/********************************************************************/
/* Creo:		Raul Muniz											*/
/* Fecha:		03/11/2020											*/
/* Help:		1433413												*/
/********************************************************************/
/* Declaracion de Variables */

if not exists (select Rig_Numero
                   from SORIBGEN noholdlock
                   where Rig_Numero = @Rig_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Numero de ID: ' +  convert(varchar,@Rig_Numero) + ' No Existe',
           Err_Variab	= 'Rig_Numero'
   rollback
   return 1
end

update SORIBGEN set
	Rig_Numero	= @Rig_Numero,
	Rig_NumRib	= @Rig_NumRib,
	Rig_ActCre	= @Rig_ActCre,
	Rig_TiDeGo	= @Rig_TiDeGo,
	Rig_DepGob	= @Rig_DepGob,
	Rig_TieExp	= @Rig_TieExp,
	Rig_Export	= @Rig_Export,
	Rig_TiGeDi	= @Rig_TiGeDi,
	Rig_GeCoMa	= @Rig_GeCoMa,
	Rig_Activo	= @Rig_Activo,
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
where Rig_Numero = @Rig_Numero

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Ric_Numero = @Rig_Numero