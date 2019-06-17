create procedure SORIBPODBAJ (
	@Rip_Numero int,
	@Rip_NumRib int,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as
/****************************************************************/
/* DESCRIPCION: Baja fisica de registros de Poderes de RIB PM	*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		10/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes */
declare	@Ina_Cero	int			

/* Asignacion de Constantes */
select	@Ina_Cero	= 0

update SORIBPOD set 
	Rip_Activo = @Ina_Cero,
		
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino 	= @SucDestino
	
	where Rip_NumRib = @Rip_Numero

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Borrado Correctamente'
