create procedure SORIBACCALT (
	@Ria_Numero int,
	@Ria_NumRib int,
	@Ria_NumPer char(8),
	@Ria_PorPar numeric(10,2),
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Alta de registros de Accionistas SORIBACC		*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		07/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes */
DECLARE	@Int_Activo int
SELECT	@Int_Activo = 1
DECLARE @Int_Uno int
SELECT  @Int_Uno = 1

insert into SORIBACC 
	(Ria_NumRib,	Ria_NumPer,		Ria_PorPar,		Ria_Activo,		NumTransac,
	Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
	values (
	@Ria_NumRib,    @Ria_NumPer,    @Ria_PorPar,	@Int_Activo,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)

select @Ria_Numero = @@IDENTITY

if @@nestlevel = @Int_Uno begin
     select Err_Codigo = '000000',
			Err_Mensaj = 'Relacion agregada correctamente',
			Ria_Numero = @Ria_Numero
end