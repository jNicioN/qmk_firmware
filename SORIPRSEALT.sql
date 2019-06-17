create procedure SORIPRSEALT (
   @Rps_Numero int,
   @Rps_NumRib int,
   @Rps_ProSer varchar(50),
   @Rps_MarCom varchar(50),
   @Rps_PoVeIn numeric(10,2),
   @Rps_Activo bit,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Productos Servicios de RIB	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIPRSE 
	(Rps_NumRib,    Rps_ProSer,		Rps_MarCom,		Rps_PoVeIn,		Rps_Activo,
	NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
	SucDestino) 
	values (
	@Rps_NumRib,    @Rps_ProSer,    @Rps_MarCom,    @Rps_PoVeIn,    @Rps_Activo,
	@NumTransac,    @Transaccio,    @Usuario,		@FechaSis,		@SucOrigen, 
	@SucDestino) 

select @Rps_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
			Err_Mensaj = 'Relacion agregada correctamente', 
			Rps_Numero= @Rps_Numero 
end
