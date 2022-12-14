create procedure SOPRECAMPRO (
    @Prc_Moneda int,
    @Prc_TipCam int,
    @Prc_TiOpCa int,
    @Prc_Precio numeric(10,6),
    @Prc_Fecha  smalldatetime,  
    @Tip_Proces char(1),
    
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
** Descripcion : Proceso de Precios de Cambio                      *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         05/12/2022									   *
** Help Desk: 	  TCELTO-2037                                      *
********************************************************************/

declare @Cam_Encont int,            /* Declaración de Variables */
        @Prc_Numero int,
        @Status     int,
        @Dif_Fechas	int

declare	@Ent_Cero   int,         	/* Declaración de Constantes */
        @Str_Vacio  int,
        @Pro_Precio char(1),
        @Prc_Activo bit

select  @Ent_Cero	=  0, 			/*	Entero Cero				 */
        @Pro_Precio = 'P',          /*  Proceso de Precio        */
        @Prc_Activo =  1            /*  Status Ativo             */

if @Tip_Proces = @Pro_Precio begin
    select @Status      = @Ent_Cero
    select @FechaSis    = getdate()
    select @Dif_Fechas	= convert(int, datediff(dd, @Prc_Fecha, @FechaSis))

    select @Cam_Encont = count(*)
        from SOPRECAM noholdlock
        where Prc_Moneda   = @Prc_Moneda
            and Prc_TipCam   = @Prc_TipCam
            and Prc_TiOpCa   = @Prc_TiOpCa

    if @Dif_Fechas = @Ent_Cero begin
        if isnull(@Cam_Encont, @Ent_Cero) = @Ent_Cero begin
            execute @Status = SOPRECAMALT
                @Prc_Moneda,    @Prc_TipCam,    @Prc_TiOpCa,    @Prc_Precio,    @NumTransac,
                @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino,
                @Modulo
        end else begin
            execute @Status = SOPRECAMACT
                @Prc_Moneda,    @Prc_TipCam,    @Prc_TiOpCa,    @Prc_Precio,    @Prc_Activo,     @Tip_Proces,
                @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,
                @SucDestino,    @Modulo
        end
    end

    if @Status = @Ent_Cero begin
        select @Prc_Numero = Prc_Numero
        from SOPRECAM noholdlock
        where Prc_Moneda   = @Prc_Moneda
            and Prc_TipCam   = @Prc_TipCam
            and Prc_TiOpCa   = @Prc_TiOpCa

        if isnull(@Prc_Numero, @Ent_Cero) <> @Ent_Cero begin
            execute SODIPRCAPRO
            @Prc_Numero,    @Prc_Fecha,     @Prc_Precio,    @NumTransac,    @Transaccio,
            @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino,    @Modulo
        end
    end
end

