create procedure SOOPPAMOACT (
	@Opm_Numero	int,
    @Opm_MonBas int,
    @Opm_MonCot int,
    @Opm_OpePar int,
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
** Descripcion : Actualización de Operacion par de Moneda          *
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
		@Act_Operad char(1)

select  @Ent_Cero	=  0,			/*	Entero Cero	    */
		@Act_Operad = 'O'


select @Ope_Encont = count(*)
    from SOOPPAMO noholdlock
    where Opm_Numero = @Opm_Numero
if isnull(@Ope_Encont, @Ent_Cero) = @Ent_Cero begin
    select 	Err_Codigo = '000003', 
			Err_Mensaj = 'El Operador de Paridad de la Moneda no Existe',
			Err_Foco   = 'Opm_OpePar'
	rollback 
	return 1
end 

if @Tip_Actual = @Act_Operad begin
	 update SOOPPAMO set
	    Opm_OpePar = @Opm_OpePar,
	    NumTransac = @NumTransac,
	    Transaccio = @Transaccio,
	    Usuario = @Usuario,
	    FechaSis = @FechaSis,
	    SucOrigen = @SucOrigen,
	    SucDestino = @SucDestino
        where Opm_Numero   = @Opm_Numero
end



if @@error != @Ent_Cero begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Ocurrió un error inesperado, por favor vuelva a intentar.'
	rollback
	return 1
end

select	Err_Codigo	= '000000',
        Err_Mensaj	= 'Operación actualizada exitosamente'