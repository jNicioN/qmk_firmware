create procedure SODIPRCAPRO (
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
** Descripcion : Procedimiento para almacenar Diario de Precios    * 
                    de Cambio                                      *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         02/12/2022									   *
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
    
    select @Dia_Encont = count(*)
	    from SODIPRCA noholdlock
	    where Dpc_PreCam = @Dpc_PreCam
          and Dpc_Fecha  = @Dpc_Fecha
    if isnull(@Dia_Encont, @Ent_Cero) = @Ent_Cero begin

        execute SODIPRCAALT @Dpc_PreCam, @Dpc_Fecha, @Dpc_Precio, @NumTransac,
            @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo

    end else begin

        execute SODIPRCAACT @Dpc_PreCam, @Dpc_Fecha, @Dpc_Precio, @NumTransac,
            @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo

    end
end