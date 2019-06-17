create procedure SOPRORESBAJ (
	@ProcId varchar(11),
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
**	Fecha: 02/03/2015											***
**	Descripción: Se cambia a tabla SOTMPRES ***
**  Requisición: 739123							***
*******************************************************************/
/******************************************************************
**	Autor: Héctor Silva López									***
**	Fecha: 22/12/2014											***
**	Descripción: Stored Procedure que borra en tabla 	SOPRORES***
**  Requisición: 721650											***
*******************************************************************/

delete from SOTMPRES
	where Res_Proced = @ProcId
