create procedure SOOPPAMOPRO (
	@Opm_Numero	int,
    @Opm_MonBas int,
    @Opm_MonCot int,
    @Opm_OpePar int,
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
** Descripcion : Procesos Operacion par de Moneda          *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         25/05/2023									   *
** Help Desk: 	  TCELTO-4796                                      *
********************************************************************/

declare @Ope_Encont int,			/* Declaración de Variables */		
		@Status     int


declare	@Ent_Cero   int,         	/* Declaración de Constantes */
		@Pro_Operad char(1)

select  @Ent_Cero	=  0,			/*	Entero Cero	    */
		@Pro_Operad = 'O'


if @Tip_Proces = @Pro_Operad begin
	select @Status	 = @Ent_Cero

	select @Ope_Encont = count(*)
    	from SOOPPAMO noholdlock
    	where Opm_Numero = @Opm_Numero

	if isnull(@Ope_Encont, @Ent_Cero) = @Ent_Cero begin
		exec @Status = SOOPPAMOALT
			@Opm_MonBas, 	@Opm_MonCot,	@Opm_OpePar,	@NumTransac,	@Transaccio,
			@Usuario, 		@FechaSis, 		@SucOrigen,		@SucDestino, 	@Modulo
		if @Status <> 0 begin
                rollback
                return 1
        end	
	end else begin
		execute SOOPPAMOACT
			@Opm_Numero,	@Opm_MonBas,	@Opm_MonCot,	@Opm_OpePar,	@Pro_Operad,
			@NumTransac, 	@Transaccio, 	@Usuario, 		@FechaSis, 		@SucOrigen,
			@SucDestino, 	@Modulo
		if @Status <> 0 begin
                rollback
                return 1
        end
	end
end




