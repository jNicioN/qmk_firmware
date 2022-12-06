create procedure SODIPRCAALT (
    @Dpc_PreCam int,
    @Dpc_Fecha  smalldatetime,
    @Dpc_Precio numeric(10,6),

    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)

as

/*******************************************************************
** Descripcion : Alta de Diario de Precios de Cambio    		   *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         02/12/20									       *
** Help Desk: 	  TCELTO-2037                                      *
********************************************************************/

declare @Pre_Encont int,             /* Declaración de Variables */
        @Dia_Encont int

declare	@Ent_Cero   int         	/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Ent_Cero   = 0				/* Entero cero */


select @Pre_Encont = count(*)
	from SOPRECAM noholdlock
	where Prc_Numero = @Dpc_PreCam
if isnull(@Pre_Encont, @Ent_Cero) <> @Ent_Cero begin
    
    insert into SODIPRCA (
        Dpc_PreCam,     Dpc_Fecha,      Dpc_Precio,     NumTransac,     Transaccio,
        Usuario,        FechaSis,       SucOrigen,      SucDestino
    )
    values ( 
            @Dpc_PreCam,   @Dpc_Fecha,     @Dpc_Precio,    @NumTransac,    @Transaccio,
            @Usuario,      @FechaSis,      @SucOrigen,     @SucDestino 
    )
    
end