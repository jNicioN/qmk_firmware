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
** Descripcion:	Busqueda de asesor call center							****
** Folio:		1230668													****
** Fecha:		05/AGOSTO/2019											****
****************************************************************************/

select SoAgenteID,Usu_Clave,Usu_Nombre from SOREAGCA
inner join SOUSUARI on SOREAGCA.SoUsuariID= SOUSUARI.SoUsuariID