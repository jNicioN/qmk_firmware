create procedure SOCATIDIBAJ (
	@Ctd_Numero int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripciýn:	** Baja de Catalogo Tipo Direccion **					****
****************************************************************************
** Creý:		Roberto Saldivar										****
** Fecha:		21-03-2017												****
** Help:		00909908												****
****************************************************************************/
declare @Str_Cero char(1)

select 	@Str_Cero = '0'
		
/* Baja de Catalogo Tipo Direccion */
update  SOCATIDI
	set Ctd_Activo = @Str_Cero,
	
	NumTransac = @NumTransac,
	Transaccio = @Transaccio,
	Usuario = @Usuario,
	FechaSis = @FechaSis,
	SucOrigen = @SucOrigen,
	SucDestino = @SucDestino
 where Ctd_Numero = @Ctd_Numero
