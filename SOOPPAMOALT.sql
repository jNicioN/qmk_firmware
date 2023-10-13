create procedure SOOPPAMOALT (
    @Opm_MonBas  int,
    @Opm_MonCot  int,
    @Opm_OpePar  int,

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
** Descripcion : Alta de Operacion par de Moneda                   *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         25/05/2023									   *
** Help Desk: 	  TCELTO-4796                                      *
********************************************************************/

declare @Mon_BasEnc int,            /* Declaración de Variables */
        @Mon_CotEnc int,
        @Ope_Encont int


declare	@Ent_Cero   int,         	/* Declaración de Constantes */
		@Str_Vacio 	char(1)

select  @Ent_Cero	=  0, 			/*	Entero Cero	    */
		@Str_Vacio 	= ''

select	@Modulo	= isnull(@Modulo, @Str_Vacio)


select @Mon_BasEnc = count(*)
    from SOMONEDA noholdlock
    where SoMonedaID = @Opm_MonBas
if isnull(@Mon_BasEnc, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000001', 
			Err_Mensaj = 'La Moneda Base no Existe',
			Err_Foco   = 'Opm_MonBas'
	rollback 
	return 1
end 


select @Mon_CotEnc = count(*)
    from SOMONEDA noholdlock
    where SoMonedaID = @Opm_MonCot
if isnull(@Mon_CotEnc, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000002', 
			Err_Mensaj = 'La Moneda Cotiza no Existe',
			Err_Foco   = 'Opm_MonCot'
	rollback 
	return 1
end 

select @Ope_Encont = count(*)
    from SOOPEPAR noholdlock
    where Opp_Numero = @Opm_OpePar
if isnull(@Ope_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000003', 
			Err_Mensaj = 'El Operador de Paridad no Existe',
			Err_Foco   = 'Opm_OpePar'
	rollback 
	return 1
end 


insert into SOOPPAMO ( 
    Opm_MonBas,     Opm_MonCot,     Opm_OpePar,     NumTransac,     Transaccio, 
    Usuario,        FechaSis,       SucOrigen,      SucDestino )
	values ( 
        @Opm_MonBas,    @Opm_MonCot,    @Opm_OpePar,    @NumTransac,    @Transaccio,
        @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino )


if @@error != @Ent_Cero begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Ocurrió un error inesperado, por favor vuelva a intentar.'
	rollback
	return 1
end

select	Err_Codigo	= '000000',
        Err_Mensaj	= 'Operación guardada exitosamente'