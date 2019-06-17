create procedure SOCATIDIALT (
	@Ctd_Nombre   char(40),
    @Ctd_Descri   varchar(255),
    @Ctd_Activo   char(1),
    @Ctd_Principal   char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** Descripciýn:	** Alta de Catalogo Tipo Direccion **					****
****************************************************************************
** Creý:		Roberto Saldivar										****
** Fecha:		21-03-2017												****
** Help:		00909908												****
****************************************************************************/										

/* Alta de Catalogo Tipo Direccion */

insert into dbo.SOCATIDI ( 	Ctd_Nombre, Ctd_Descri, Ctd_Activo, Ctd_Principal, NumTransac,
							Transaccio, Usuario, FechaSis, SucOrigen, SucDestino )
	values (@Ctd_Nombre, @Ctd_Descri, @Ctd_Activo, @Ctd_Principal, @NumTransac, 
			@Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino )
