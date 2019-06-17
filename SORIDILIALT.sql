create procedure SORIDILIALT (
   @Rdl_Numero int,
   @Rdl_NumRib int,
   @Rdl_Tipo int,
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Diversificacion Lineas RIB */
/****************************************************************/
/* Modifico:    Edwin Santiago Marcial	          				*/
/* Fecha:		05/12/2017										*/
/* Descripción: Modificación de parametros,se elimino Rdl_Activo*/
/* Help:		929417											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int,	/* Variable entero uno */
		@Rdl_Activo bit	/* Variable bit 1 para estatus activo */
SELECT  @Int_Uno = 1,
		@Rdl_Activo = 1


Insert Into SORIDILI 
	(Rdl_NumRib,	Rdl_Tipo,	Rdl_Activo,		NumTransac,		Transaccio,
	Usuario,		FechaSis,	SucOrigen,		SucDestino) 
	values (
	@Rdl_NumRib,	@Rdl_Tipo,	@Rdl_Activo,	@NumTransac,    @Transaccio,
	@Usuario,		@FechaSis,	@SucOrigen,		@SucDestino) 

select @Rdl_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rdl_Numero= @Rdl_Numero 
end
