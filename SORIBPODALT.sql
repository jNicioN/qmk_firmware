create procedure SORIBPODALT (
	@Rip_Numero int,
	@Rip_NumRib int,
	@Rip_TipPod int,
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Alta de registros de RIB Poderes PM				*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		02/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Variables */

DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

insert into SORIBPOD 
	(Rip_NumRib,	Rip_TipPod,		Rip_Activo,		NumTransac,		Transaccio,
	Usuario,		FechaSis,		SucOrigen,		SucDestino)
	values (
	@Rip_NumRib,    @Rip_TipPod,    @Int_Uno,		@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @Rip_Numero = @@IDENTITY

if @@nestlevel = @Int_Uno begin
     select Err_Codigo = '000000',
			Err_Mensaj = 'Registro agregada correctamente',
			Rip_Numero = @Rip_Numero
end
