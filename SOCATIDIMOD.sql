create procedure SOCATIDIMOD (
	@Ctd_Numero     int,
	@Ctd_Nombre     char(40),
    @Ctd_Descri     varchar(255),
    @Ctd_Activo     char(1),
    @Ctd_Principal  char(1),
	
	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))

as

/***************************************************************************
** Descripciýn:	** Modificaciýn de Catalogo Tipo Direccion **			****
****************************************************************************
** Creý:		Roberto Saldivar										****
** Fecha:		21-03-2017												****
** Help:		00909908												****
****************************************************************************/
										
/* Modificaciýn de Catalogo Tipo Direccion */
update dbo.SOCATIDI set	
	Ctd_Nombre = @Ctd_Nombre,
	Ctd_Descri = @Ctd_Descri,
	Ctd_Activo = @Ctd_Activo,
	Ctd_Principal = @Ctd_Principal,
	NumTransac = @NumTransac,
	Transaccio = @Transaccio,
	Usuario = @Usuario,
	FechaSis = @FechaSis,
	SucOrigen = @SucOrigen,
	SucDestino = @SucDestino
 where Ctd_Numero = @Ctd_Numero
