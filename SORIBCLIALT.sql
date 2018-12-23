create procedure SORIBCLIALT (
   @Ric_Numero int,
   @Ric_NumRib int,
   @Ric_Nombre varchar(100),
   @Ric_Filial int,
   @Ric_Ventas numeric(5,2),
   @Ric_Carter numeric(5,2),
   @Ric_Antigu varchar(30),
   @Ric_Plazo int,
   @Ric_Ubicac varchar(255),
   @Ric_Varios bit,
   @Ric_Activo bit,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Clientes asociados a RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIBCLI 
	(Ric_NumRib,	Ric_Nombre,		Ric_Filial,		Ric_Ventas,		Ric_Carter, 
	Ric_Antigu,		Ric_Plazo,		Ric_Ubicac,		Ric_Varios,		Ric_Activo, 
	NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
	SucDestino) 
	values (
	@Ric_NumRib,		@Ric_Nombre,    @Ric_Filial,    @Ric_Ventas,    @Ric_Carter, 
	@Ric_Antigu,    @Ric_Plazo,		@Ric_Ubicac,    @Ric_Varios,    @Ric_Activo, 
	@NumTransac,    @Transaccio,    @Usuario,		@FechaSis,		@SucOrigen, 
	@SucDestino) 

select @Ric_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Ric_Numero= @Ric_Numero 
end
