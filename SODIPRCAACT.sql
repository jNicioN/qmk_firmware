create procedure SODIPRCAACT (
    @Dpc_PreCam int,
    @Dpc_Fecha  smalldatetime,
    @Dpc_Precio numeric(10,6),
    @Tip_Actual char(1),

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
** Descripcion : Actualizacion del Diario de Precios de Cambio     *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         02/12/2022									   *
** Help Desk: 	  TCELTO-2037                                      *
********************************************************************/

declare @Pre_Encont int,             /* Declaración de Variables */
        @Dia_Encont int

declare	@Ent_Cero   int,         	/* Declaración de Constantes */
        @Act_Precio char(1)

/* Asignación de Constantes */
select	@Ent_Cero   = 0,			/* Entero cero */
        @Act_Precio = 'P'           /*  Actualizacion de Precio     */

if @Tip_Actual = @Act_Precio begin
    select @Pre_Encont = count(*)
        from SOPRECAM noholdlock
        where Prc_Numero = @Dpc_PreCam
        
    if isnull(@Pre_Encont, @Ent_Cero) <> @Ent_Cero begin
        update SODIPRCA set
            Dpc_Precio = @Dpc_Precio,
            NumTransac = @NumTransac,
            Transaccio = @Transaccio,
            Usuario    = @Usuario,
            FechaSis   = @FechaSis,
            SucOrigen  = @SucOrigen,
            SucDestino = @SucDestino
            where Dpc_PreCam = @Dpc_PreCam
                and Dpc_Fecha  = @Dpc_Fecha
        
        if @@error != @Ent_Cero begin
            select	Err_Codigo	= '000005',
                    Err_Mensaj	= 'Ocurrió un error inesperado, por favor vuelva a intentar.'
            rollback
            return 1
        end

        select	Err_Codigo	= '000000',
                Err_Mensaj	= 'Diario Actualizado exitosamente'
    end
end