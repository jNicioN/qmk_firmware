create procedure SORICOAAALT (
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
/* DESCRIPCION: Alta de registros de Composicion Accionaria		*/
/*				Adicional de RIB								*/
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
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORICOAA 
	(Rca_NumRib,	Rca_Tipo,	Rca_PoPaMu,	Rca_ConMuj,	Rca_PeAlDi,
	Rca_MuAlDi,		Rca_DiPrMi,	Rca_GeDiGe,	Rca_GePrCo,	NumTransac,
	Transaccio,		Usuario,	FechaSis,	SucOrigen,	SucDestino)
	values (
	@Rca_NumRib,	@Rca_Tipo,		@Rca_PoPaMu,	@Rca_ConMuj,	@Rca_PeAlDi,
	@Rca_MuAlDi,	@Rca_DiPrMi,	@Rca_GeDiGe,	@Rca_GePrCo,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino) 

select @Rca_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rca_Numero= @Rca_Numero 
end