create procedure SOPLAZASCON (
	@Pla_Numero char(3),
	@Pla_Nombre varchar(70),
	
	@NumTransac char(10), 
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as
/****************************************************************************/
/* DESCRIPCION: 	Store de Consulta de Plazas							*/
/****************************************************************************/
/* REFERENCIAS: 															*/
/***************************************************************************
** Modifico:	Christian Didier Almaraz Mesta		    				****
** Fecha:		11/May/2023											    ****
** Help:		1662542													****
** Descripcion:	Se da salida a Pla_Region					            ****
****************************************************************************
** Modifico:	Gerardo Arturo Hernández Torres							****
** Fecha:		13/04/2023												****
** Descripción:	Se agrega campo SoPlazaID para consultas				****
** Help Desk:	25528													****
*****************************************************************************/
if (@Pla_Numero = '') and (@Pla_Nombre = '')
	select	Pla_Numero,	Pla_Nombre,	Pla_Abrevi,	Pla_CenPro, Pla_PlaCec,
			Pla_Clabe,	Pla_ClaMin, SoPlazaID, Pla_Region
		from SOPLAZAS noholdlock
		order by Pla_Nombre
else if (@Pla_Nombre = '')
	select	Pla_Numero,	Pla_Nombre,	Pla_Abrevi,	Pla_CenPro, Pla_PlaCec,
			Pla_Clabe,	Pla_ClaMin, SoPlazaID, Pla_Region
		from SOPLAZAS noholdlock
		where	Pla_Numero	= @Pla_Numero
else begin
	select	@Pla_Nombre	= ltrim(rtrim(@Pla_Nombre)) + '%'
	
	select	Pla_Numero,	Pla_Nombre, Pla_PlaCec, Pla_Clabe,	Pla_ClaMin,
			SoPlazaID, Pla_Region
		from SOPLAZAS noholdlock
		where	Pla_Nombre	like @Pla_Nombre
		order by Pla_Nombre
end