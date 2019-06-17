create procedure SOPROAUTACT (
	@Fecha	smalldatetime,
	@Reporte varchar(11),
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))
 
as	
/******************************************************************
**	Autor: Héctor Silva López									***
**	Fecha: 06/02/2015											***
**	Descripción: Actualiza fecha de ejecución ***
**  Requisición: 739123											***
*******************************************************************/
	
	update SOPROAUT set Pro_FecEje = @Fecha
		where Pro_Nombre = @Reporte
