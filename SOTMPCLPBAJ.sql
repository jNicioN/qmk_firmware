create procedure SOTMPCLPBAJ (
@NumTransac   char(10),
@Transaccio   char(3),
@Usuario      char(6),
@FechaSis     smalldatetime,
@SucOrigen    char(3),
@SucDestino   char(3),
@Modulo       char(2) 
)
as

/****************************************************************************
** Descripción:	 Baja de Catalogo	clasificacion producto	 	****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		05-10-2021									****
** Help:												****
****************************************************************************/



/* Baja de Catalogo */
delete from SOTMPCLP	