create procedure SOPRORESALT (
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
**	Fecha:	02/03/2015										***
**	Descripción: Se Cambia  a tabla SOTMPRES ***
**  Requisición: 	739123										***
*******************************************************************/
/******************************************************************
**	Autor: Héctor Silva López									***
**	Fecha: 22/12/2014											***
**	Descripción: Stored Procedure que inserta en tabla SOPRORES ***
**  Requisición: 721650											***
*******************************************************************/

insert into SOTMPRES
		(Res_NumTra,	Res_Campos,		Res_Posici, Res_Valor,				Res_Proced,	
		Res_Grupo)
select	NumTransac,		Pro_Campos,		Pro_Posici,	isnull(Pro_Valor,''),	Pro_Proced,	
		Pro_Grupo
	from #SOPRORES
