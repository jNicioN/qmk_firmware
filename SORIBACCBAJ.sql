create procedure SORIBACCBAJ (
	@Ria_Numero int,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
 as 
/****************************************************************/
/* DESCRIPCION: Baja logica de registros de Accionistas RIB		*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		07/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes */
declare	@Int_Cero int
select	@Int_Cero = 0

update SORIBACC	set	
	Ria_Activo	= @Int_Cero,
	NumTransac = @NumTransac, 
	Transaccio = @Transaccio, 
	Usuario    = @Usuario, 
	FechaSis   = @FechaSis, 
	SucOrigen  = @SucOrigen, 
	SucDestino = @SucDestino
	where Ria_Numero = @Ria_Numero

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Borrado Correctamente'
