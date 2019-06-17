create procedure SOPROMATALT (
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
**	Descripción: Cambio de tabla a SOTMPMAT ***
**  Requisición: 739123											***
*******************************************************************/
/******************************************************************
**	Autor: Héctor Silva López									***
**	Fecha: 22/12/2014											***
**	Descripción: Stored Procedure que inserta en tabla SOPROMAT ***
**  Requisición: 721650											***
*******************************************************************/

insert into SOTMPMAT 
		(Mat_NumTra,Mat_NomRep,	Mat_FecEje,	Mat_Result,	Mat_Campos)
select	NumTransac, Pro_NomRep,	Pro_FecEje,	Pro_Result,	Pro_Campos
	from #SOPROMAT
