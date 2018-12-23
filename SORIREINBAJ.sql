create procedure SORIREINBAJ (
   @Rri_Numero int,
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as 
/****************************************************************/
/* DESCRIPCION: Baja de registros de Relacion de Instituciones	*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/

/* Declaracion de Constantes */
declare	@Int_Cero int
select	@Int_Cero = 0

update SORIREIN set
	Rri_Activo	= @Int_Cero,
		
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino 	= @SucDestino
where Rri_Numero = @Rri_Numero

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Borrado Correctamente'
