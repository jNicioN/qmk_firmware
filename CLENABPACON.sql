create procedure CLENABPACON (
	@Ent_Pais	char(3),			/* País */
	@Ent_Abrevi	char(2),			/* Abreviación de entidad */
	@Ent_Status	char(1),			/* Status */

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de entidades por Abreviación y país	 **
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		10/Jun/2018										****
** Help:		01278846										****
** Descripcion:	Consulta de entidades por País y clave de entidad***
********************************************************************/

select	Ent_Numero,	Ent_Nombre,	Ent_Abrevi,	Ent_Pais,	Ent_Status
	from CLENTIDA noholdlock
	where	Ent_Status	= @Ent_Status
	  and	Ent_Pais	= @Ent_Pais
	  and	Ent_Abrevi	= @Ent_Abrevi
