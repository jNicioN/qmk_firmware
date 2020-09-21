create procedure SOCOMBITALT (
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
** Descripción:    Migracion de la Información de Modalidades           ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		CODE4U Jonathan Perez                      			****
** Fecha:		    12/01/2020									        ****
** Help:			1286068  									        ****
** Descripción:	    Procedimiento padre de Sincronizacion.              ****
****************************************************************************/

insert into SOCOMBIT(
	Bit_Fecha,	Bit_Paso,	Bit_Proced,	Bit_Estado,	NumTransac,
	Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
values(
    @Bit_Fecha,     @Bit_Paso,  @Bit_Proced,    @Bit_Estado,   @NumTransac,
	@Transaccio,    @Usuario,   @FechaSis,      @SucOrigen,    @SucDestino)