create procedure SORIBPROALT (
   @Rip_Numero int,
   @Rip_NumRib int,
   @Rip_Nombre varchar(100),
   @Rip_Filial int,
   @Rip_PorCom numeric(5,2),
   @Rip_Antigu varchar(30),
   @Rip_Insumo varchar(30),
   @Rip_Plazo int,
   @Rip_TipPro int,
   @Rip_Varios bit,
   @Rip_Activo bit,

   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Alta de registros de Proveedores de RIB			*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
/* Declaracion de Variables */
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

Insert Into SORIBPRO 
	(Rip_NumRib,	Rip_Nombre,		Rip_Filial,		Rip_PorCom,		Rip_Antigu,
	Rip_Insumo,		Rip_Plazo,		Rip_TipPro,		Rip_Varios,		Rip_Activo,
	NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
	SucDestino) 
	values (
	@Rip_NumRib,	@Rip_Nombre,    @Rip_Filial,    @Rip_PorCom,    @Rip_Antigu,
	@Rip_Insumo,    @Rip_Plazo,		@Rip_TipPro,    @Rip_Varios,	@Rip_Activo,
	@NumTransac,	@Transaccio,    @Usuario,		@FechaSis,		@SucOrigen,
	@SucDestino) 

select @Rip_Numero = @@IDENTITY 

if @@nestlevel = @Int_Uno begin 
     select 	Err_Codigo = '000000', 
				Err_Mensaj = 'Relacion agregada correctamente', 
				Rip_Numero= @Rip_Numero 
end
