create procedure SORIEMFIALT (
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
/* DESCRIPCION: Alta de registros de Empresas Filiales de RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIEMFI 
	(Ref_NumRib,	Ref_NumPer,		Ref_PriAct,		Ref_TiReNe,		Ref_TiReOt, 
	Ref_PeSiRf,		Ref_Activo,		NumTransac,		Transaccio,		Usuario,
	FechaSis,		SucOrigen,		SucDestino) 
	values (   
	@Ref_NumRib,    @Ref_NumPer,    @Ref_PriAct,    @Ref_TiReNe,    @Ref_TiReOt,
	@Ref_PeSiRf,    @Ref_Activo,    @NumTransac,    @Transaccio,    @Usuario, 
	@FechaSis,    @SucOrigen,    @SucDestino) 

select @Ref_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Ref_Numero= @Ref_Numero 
end
