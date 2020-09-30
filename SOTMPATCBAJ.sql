create procedure SOTMPATCBAJ (
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
** Descripción:	 Baja de Catalogo dato adicional tipo_movimiento		****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		27-05-2020									****
** Help:		1286068										****
****************************************************************************/



/* Baja de Catalogo */
delete from SOTMPATC