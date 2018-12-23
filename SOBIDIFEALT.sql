create procedure SOBIDIFEALT (
	@Bdf_TipPro	char(3),
	@Bdf_Descri	varchar(50),
	@Bdf_Tiempo	int,
	@Bdf_DiaFes	smalldatetime,
	@Bdf_FecIni	smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: Alta de Bitacora de actualización de Dias Festivos		****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Creó:		Andrea Ramirez Mondragon								****
** Fecha:		27/Dic/2017												****
** Help:		1038263													****
****************************************************************************
*/

insert into SOBIDIFE values(
	@Bdf_TipPro,	@Bdf_Descri,	@Bdf_Tiempo,	@Bdf_DiaFes,	@Bdf_FecIni,
	getDate(),		@NumTransac,	@Transaccio,	@Usuario, 		@FechaSis,
	@SucOrigen,		@SucDestino)
