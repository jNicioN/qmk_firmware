create procedure SOLITICAALT (
	@Ltc_TipCam int,
    @Ltc_Moneda int,
    @Ltc_LimInf numeric(10,6),
    @Ltc_LimSup numeric(10,6), 

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
** Descripcion : Alta de Limite de Tipo de Cambio                  *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         13/11/2023									   *
** Help Desk: 	  TCELTO-6348                                      *
********************************************************************/

declare @Mon_Encont int,            /* Declaración de Variables */
        @Tip_Encont int

declare	@Ent_Cero   int,         	/* Declaración de Constantes */
        @Num_Cero   numeric,
        @Ltc_Activo bit

select  @Ent_Cero	=  0 ,				    /*	Entero Cero					*/
        @Num_Cero	=  0 ,				    /*	Numerico Uno				*/
        @Ltc_Activo =  1                    /*  Status de activo           */


select @Mon_Encont = count(*)
    from SOMONEDA noholdlock
    where SoMonedaID = @Ltc_Moneda
if isnull(@Mon_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000001', 
			Err_Mensaj = 'La moneda no Existe',
			Err_Foco   = 'Ltc_Moneda'
	rollback 
	return 1
end 

select @Tip_Encont = count(*)
    from SOTIPCAM noholdlock
    where Tic_Numero = @Ltc_TipCam
if isnull(@Tip_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000002', 
			Err_Mensaj = 'El tipo de Cambio no existe',
			Err_Foco   = 'Ltc_TipCam'
	rollback 
	return 1
end 


if @Ltc_LimInf <= @Num_Cero begin
    select 	Err_Codigo = '000003', 
			Err_Mensaj = 'El límite inferior debe ser mayor a 0',
			Err_Foco   = 'Ltc_LimInf'
	rollback 
	return 1
end

if @Ltc_LimSup <= @Num_Cero begin
    select 	Err_Codigo = '000004', 
			Err_Mensaj = 'El límite superior debe ser mayor a 0',
			Err_Foco   = 'Ltc_LimSup'
	rollback 
	return 1
end

if @Ltc_LimSup <= @Ltc_LimInf begin
    select 	Err_Codigo = '000005', 
			Err_Mensaj = 'El límite superior no puede ser menor al Límite Inferior',
			Err_Foco   = 'Ltc_LimSup'
	rollback 
	return 1
end

insert into SOLITICA (
	Ltc_TipCam,		Ltc_Moneda,		Ltc_LimInf,		Ltc_LimSup,		Ltc_Activo,		NumTransac,
	Transaccio, 	Usuario, 		FechaSis, 		SucOrigen, 		SucDestino )
	values (
		@Ltc_TipCam, 	@Ltc_Moneda, 	@Ltc_LimInf,	@Ltc_LimSup, 	@Ltc_Activo,	@NumTransac,
		@Transaccio, 	@Usuario, 		@FechaSis, 		@SucOrigen, 	@SucDestino )


if @@error != @Ent_Cero begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Ocurrió un error inesperado, por favor vuelva a intentar.'
	rollback
	return 1
end

select	Err_Codigo	= '000000',
        Err_Mensaj	= 'Límites guardados exitosamente'