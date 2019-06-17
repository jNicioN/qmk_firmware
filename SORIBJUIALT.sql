create procedure SORIBJUIALT (
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
/* DESCRIPCION: Alta de registros de Juicios de RIB				*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIBJUI
	(Rij_NumRib,	Rij_TipJui,		Rij_FecAct,		Rij_Descri,		Rij_Activo, 
	NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen, 
	SucDestino) 
	values (
	@Rij_NumRib,	@Rij_TipJui,	@Rij_FecAct,	@Rij_Descri,	@Rij_Activo, 
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen, 
	@SucDestino) 

select @Rij_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rij_Numero= @Rij_Numero 
end
