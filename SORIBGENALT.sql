create procedure SORIBGENALT (
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
/* DESCRIPCION: Alta de registros de Generalidades asociados a RIB	*/
/********************************************************************/
/* Creo:		Raul Muniz											*/
/* Fecha:		03/11/2020											*/
/* Help:		1433413												*/
/********************************************************************/
/* Declaracion de constantes */
declare @Int_Uno int

/* Asignacion de valores a constantes */
select  @Int_Uno = 1

insert into SORIBGEN
	(Rig_Numero,	Rig_NumRib,		Rig_ActCre,		Rig_TiDeGo,		Rig_DepGob,
	Rig_TieExp,		Rig_Export,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,
	NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
	SucDestino)
	values (
	@Rig_Numero,	@Rig_NumRib,	@Rig_ActCre,	@Rig_TiDeGo,	@Rig_DepGob,
	@Rig_TieExp,	@Rig_Export,	@Rig_TiGeDi,	@Rig_GeCoMa,	@Rig_Activo,
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
	@SucDestino)

select @Rig_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Ric_Numero = @Rig_Numero 
end