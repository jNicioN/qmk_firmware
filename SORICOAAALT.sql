create procedure SORICOAAALT (
   @Rca_Numero int,
   @Rca_NumRib int,
   @Rca_Tipo int,
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
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORICOAA 
	(Rca_NumRib,	Rca_Tipo,	NumTransac,		Transaccio,		Usuario, 
	FechaSis,		SucOrigen,	SucDestino) 
	values (
	@Rca_NumRib,	@Rca_Tipo,	@NumTransac,	@Transaccio,	@Usuario, 
	@FechaSis,		@SucOrigen,	@SucDestino) 

select @Rca_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rca_Numero= @Rca_Numero 
end
