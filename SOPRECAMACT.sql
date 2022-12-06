create procedure SOPRECAMACT (
    @Prc_Moneda int,
    @Prc_TipCam int,
    @Prc_TiOpCa int,
    @Prc_Precio numeric(10,6),
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
** Descripcion : Actualizacion de Precios de Cambio                *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         05/12/2022									   *
** Help Desk: 	  TCELTO-2037                                      *
********************************************************************/

declare @Mon_Encont int,            /* Declaración de Variables */
        @Tip_Encont int,
        @Ope_Encont int


declare	@Ent_Cero   int,         	/* Declaración de Constantes */
        @Num_Cero   numeric,
        @Prc_Activo bit,
        @Tip_Precio char(1),
        @Tip_Estatu char(1)

select  @Ent_Cero	=  0,				    /*	Entero Cero					*/
        @Num_Cero	=  0,				    /*	Numerico Uno				*/
        @Prc_Activo =  1,                   /*  Status de activo            */
        @Tip_Precio = 'P',                  /*  Actualizacion de Precio     */
        @Tip_Estatu = 'E'                   /*  Actualizacion de Estatus    */



select @Mon_Encont = count(*)
    from SOMONEDA noholdlock
    where SoMonedaID = @Prc_Moneda
if isnull(@Mon_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000001', 
			Err_Mensaj = 'La moneda no Existe',
			Err_Foco   = 'Prc_Moneda'
	rollback 
	return 1
end 

select @Tip_Encont = count(*)
    from SOTIPCAM noholdlock
    where Tic_Numero = @Prc_TipCam
if isnull(@Tip_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000002', 
			Err_Mensaj = 'El tipo de Cambio no existe',
			Err_Foco   = 'Prc_TipCam'
	rollback 
	return 1
end 

select @Ope_Encont = count(*)
    from SOTIOPCA  noholdlock
    where Toc_Numero  = @Prc_TiOpCa
if isnull(@Ope_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000003', 
			Err_Mensaj = 'El tipo de Cambio no existe',
			Err_Foco   = 'Prc_TiOpCa'
	rollback 
	return 1
end

if @Prc_TipCon = @Tip_Precio begin
    if @Prc_Precio <= @Num_Cero begin
    select 	Err_Codigo = '000004', 
			Err_Mensaj = 'El precio debe ser mayor a 0',
			Err_Foco   = 'Prc_TiOpCa'
	rollback 
	return 1
    end

    update SOPRECAM set
	    Prc_Precio = @Prc_Precio,
	    NumTransac = @NumTransac,
	    Transaccio = @Transaccio,
	    Usuario = @Usuario,
	    FechaSis = @FechaSis,
	    SucOrigen = @SucOrigen,
	    SucDestino = @SucDestino
        where Prc_Moneda   = @Prc_Moneda
	      and Prc_TipCam   = @Prc_TipCam
	      and Prc_TiOpCa   = @Prc_TiOpCa
end

if @Prc_TipCon = @Tip_Estatu begin
    update SOPRECAM set
	    Prc_Activo = @Prc_Activo,
	    NumTransac = @NumTransac,
	    Transaccio = @Transaccio,
	    Usuario = @Usuario,
	    FechaSis = @FechaSis,
	    SucOrigen = @SucOrigen,
	    SucDestino = @SucDestino
        where Prc_Moneda   = @Prc_Moneda
	      and Prc_TipCam   = @Prc_TipCam
	      and Prc_TiOpCa   = @Prc_TiOpCa
end


if @@error != @Ent_Cero begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Ocurrió un error inesperado, por favor vuelva a intentar.'
	rollback
	return 1
end

select	Err_Codigo	= '000000',
        Err_Mensaj	= 'Actualizado exitosamente'