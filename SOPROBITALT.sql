create procedure SOPROBITALT (
	@Bit_Fecha  smalldatetime,
    @Bit_Paso   int,
    @Bit_Proced char(11),
    @Bit_Estado bit,
    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Migracion de la Información de Configuracion Producto****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		Alan Santamaria                           			****
** Fecha:		    06/10/2021  								        ****
** Help:			          									        ****
** Descripción:	    Procedimiento padre de Sincronizacion.              ****
****************************************************************************/

insert into SOPROBIT(
	Bit_Fecha,	Bit_Paso,	Bit_Proced,	Bit_Estado,	NumTransac,
	Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
values(
    @Bit_Fecha,     @Bit_Paso,  @Bit_Proced,    @Bit_Estado,   @NumTransac,
	@Transaccio,    @Usuario,   @FechaSis,      @SucOrigen,    @SucDestino)