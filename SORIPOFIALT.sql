create procedure SORIPOFIALT (
   @Rpf_Numero int,
   @Rpf_NumRib int,
   @Rpf_Politi varchar(75),
   @Rpf_DCPoCo varchar(3),
   @Rpf_DiaInv varchar(3),
   @Rpf_DiaPro varchar(3),
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
/* DESCRIPCION: Alta de registros de Politica Financiera de RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIPOFI 
	(Rpf_NumRib,	Rpf_Politi,		Rpf_DCPoCo,		Rpf_DiaInv,		Rpf_DiaPro, 
	Rpf_PerPic,		Rpf_PerRec,		Rpf_ComCic,		Rpf_PolInv,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino) 
	values (
	@Rpf_NumRib,	@Rpf_Politi,	@Rpf_DCPoCo,	@Rpf_DiaInv,	@Rpf_DiaPro,
	@Rpf_PerPic,	@Rpf_PerRec,	@Rpf_ComCic,	@Rpf_PolInv,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @Rpf_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rpf_Numero= @Rpf_Numero 
end
