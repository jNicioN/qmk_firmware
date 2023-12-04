create procedure SOLITICAPRO (
    @Ltc_Moneda int,
    @Ltc_TipCam int,
    @Ltc_LimInf numeric(10,6),
    @Ltc_LimSup numeric(10,6),
    @Ltc_Precio float,
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
** Descripcion : Proceso de Limites de Tipo de Cambio              *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         13/11/2023									   *
** Help Desk: 	  TCELTO-6348                                      *
********************************************************************/

declare @Lim_Encont int,            /* Declaración de Variables */
        @Ltc_Numero int,
        @Status     int,
        @Ltc_PreNum numeric(10,6)

declare	@Ent_Cero   int,         	/* Declaración de Constantes */
        @Str_Vacio  int,
        @Pro_Almace char(1),
        @Pro_CieDol char(1),
        @Ltc_Activo bit,
        @Str_L      char(1)

select  @Ent_Cero	=  0, 			/*	Entero Cero				            */
        @Pro_Almace = 'A',          /*  Proceso de almacenar                */
        @Pro_CieDol = 'D',          /*  Proceso de validar cierre dolares   */
        @Ltc_Activo =  1 ,          /*  Status Ativo                        */
        @Str_L      = 'L'           /*  Actualizacion de Limites            */

if @Tip_Proces = @Pro_Almace begin
    select @Status      = @Ent_Cero

    select @Lim_Encont = count(*)
        from SOLITICA noholdlock
        where   Ltc_Moneda   = @Ltc_Moneda
            and Ltc_TipCam   = @Ltc_TipCam

    if isnull(@Lim_Encont, @Ent_Cero) = @Ent_Cero begin
        exec @Status = SOLITICAALT
            @Ltc_TipCam,    @Ltc_Moneda,    @Ltc_LimInf,    @Ltc_LimSup,    @NumTransac,
            @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino,
            @Modulo
        if @Status <> 0 begin
            rollback
            return 1
        end
    end else begin
        exec @Status = SOLITICAACT
            @Ltc_Moneda,    @Ltc_TipCam,    @Ltc_LimInf,    @Ltc_LimSup,    @Ltc_Activo,
            @Str_L,         @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,
            @SucOrigen,     @SucDestino,    @Modulo
        if @Status <> 0 begin
            rollback
            return 1
        end
    end
end else if @Tip_Proces = @Pro_CieDol begin
    select @Ltc_PreNum = convert( numeric(10,6), @Ltc_Precio)

    select  @Ltc_LimInf = Ltc_LimInf,
            @Ltc_LimSup = Ltc_LimSup
        from SOLITICA noholdlock
        where   Ltc_Moneda   = @Ltc_Moneda
          and Ltc_TipCam   = @Ltc_TipCam
    if @Ltc_LimInf <> convert( numeric(10,6), @Ent_Cero) and @Ltc_LimSup <> convert( numeric(10,6), @Ent_Cero) begin
        if @Ltc_PreNum < @Ltc_LimInf or @Ltc_PreNum > @Ltc_LimSup begin
	        rollback
	        return 1
        end
    end
end