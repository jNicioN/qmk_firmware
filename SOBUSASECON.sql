create procedure SOBUSASECON (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************
*** REFERENCIAS: 														****
****************************************************************************
** Creo:	Pedro de los Reyes											****
** Fecha:		17/Marzo/2019											****
****************************************************************************/

select SoAgenteID,Usu_Clave,Usu_Nombre from SOREAGAS
inner join SOUSUARI on SOREAGAS.SoUsuariID= SOUSUARI.SoUsuariID