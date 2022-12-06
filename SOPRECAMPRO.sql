create procedure SOPRECAMPRO (
    @Prc_Moneda int,
    @Prc_TipCam int,
    @Prc_TiOpCa int,
    @Prc_Precio numeric(10,6),
    @Prc_Fecha  smalldatetime,  
    @Prc_TipCon char(1),
    
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
** Descripcion : Guardar Precios de Cambio                         *
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
        @Str_Vacio  int

select  @Ent_Cero	=  0 			/*	Entero Cero					*/
        
select @Status = 0
select @FechaSis = getdate()
            
select	@Dif_Fechas	= convert(int, datediff(dd, @Prc_Fecha, @FechaSis))

select	Err_Codigo	= '000000',
            Err_Mensaj	= @Dif_Fechas
            
select @Cam_Encont = count(*)
    from SOPRECAM noholdlock
    where Prc_Moneda   = @Prc_Moneda
	  and Prc_TipCam   = @Prc_TipCam
	  and Prc_TiOpCa   = @Prc_TiOpCa

if @Dif_Fechas = 0 begin
    if isnull(@Cam_Encont, @Ent_Cero) = @Ent_Cero begin
        execute @Status = SOPRECAMALT
            @Prc_Moneda,    @Prc_TipCam,    @Prc_TiOpCa,    @Prc_Precio,    @NumTransac,
            @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino,
            @Modulo
    end else begin
        execute @Status = SOPRECAMACT
            @Prc_Moneda,    @Prc_TipCam,    @Prc_TiOpCa,    @Prc_Precio,    @Prc_TipCon,
            @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,
            @SucDestino,    @Modulo
    end
end

if @Status = 0 begin
    select @Prc_Numero = Prc_Numero
    from SOPRECAM noholdlock
    where Prc_Moneda   = @Prc_Moneda
      and Prc_TipCam   = @Prc_TipCam
      and Prc_TiOpCa   = @Prc_TiOpCa
    
    if isnull(@Cam_Encont, @Ent_Cero) <> @Ent_Cero begin
     execute SODIPRCAPRO
        @Prc_Numero,    @Prc_Fecha,     @Prc_Precio,    @NumTransac,    @Transaccio,
        @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino,    @Modulo
    end
end


