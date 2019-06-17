create procedure SOBIACDIBAJ(
	@Bad_FecTra	smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/* *****************************************************************
** DESCRIPCION: Baja de bitácora de acumulado diario			  **
********************************************************************
** Creó:		Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Baja de bitácora de acumulado diario			****
********************************************************************/

delete from SOBIACDI 
	where	Bad_FecTra	<= @Bad_FecTra
