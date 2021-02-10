-- drop  procedure SOTMPPTCALT
create procedure SOTMPPTCALT (
    @Ptc_Numero int,
	@Ptc_TipCue	char(2),
	@Ptc_Moneda	char(2),
	@Ptc_Produc	int,
	@Ptc_FecCon	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/****************************************************************************
** Descripción:	** Alta de Catalogo producto tipo cuenta				****
****************************************************************************
** Referencias:															****
****************************************************************************
**	Modificó:	Frank canul												****
**  Fecha:		23/12/2020												****
**  Help:		1286068													****
**	Descripción: se cambia Ptc_TipCue y Ptc_Moneda a char(2). Se agrega ****
**               el campo  Ptc_Numero 									****
****************************************************************************
** Creó:			Frank Canul				****
** Fecha:		20-05-2020									****
** Help:		1286068										****
****************************************************************************/

										/* Declaración de variables */

										/* Declaración de constantes */

										/* Asignación de constantes */


/* Alta de Catalogo */
insert into SOTMPPTC 
		(Ptc_Numero,	Ptc_TipCue,		Ptc_Moneda,		Ptc_Produc,		Ptc_FecCon) 
		values
		(@Ptc_Numero,    @Ptc_TipCue,	@Ptc_Moneda,	@Ptc_Produc,	@Ptc_FecCon)