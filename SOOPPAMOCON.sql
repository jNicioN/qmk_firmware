create procedure SOOPPAMOCON (
	@Opm_Numero	int,
    @Opm_MonBas int,
    @Opm_MonCot int,
    @Opm_OpePar int,
	@Tip_Consul char(2),

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
** Descripcion : Consulta de Operacion par de Moneda    	       *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         25/05/2023									   *
** Help Desk: 	  TCELTO-4796                                      *
********************************************************************/

declare @Tip_ConTip char(1),		/*Declaracion de variables*/
        @Tip_ConCon char(1)


declare	@Ent_Uno    int,         	/* Declaración de Constantes */
		@Ent_Dos    int,
		@Str_L		char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

select  @Ent_Uno	=  1,			/*	Entero Cero	    */
		@Ent_Dos	=  2,
		@Str_L		= 'L',
		@Str_Uno	= '1',
		@Str_Dos	= '2'
		
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno) 

if @Tip_ConTip = @Str_L begin
	if @Tip_ConCon = @Str_Uno begin

		select Opm_Numero, Opm_MonBas, Opm_MonCot,  Opm_OpePar 
		from SOOPPAMO 
		inner join SOOPEPAR on Opm_OpePar =  Opp_Numero 
		where Opm_OpePar = @Opm_OpePar

	end

	if @Tip_ConCon = @Str_Dos begin

		select Opm_Numero, Opm_MonBas, Opm_MonCot,  Opm_OpePar 
		from SOOPPAMO 
		inner join SOOPEPAR on Opm_OpePar =  Opp_Numero 
		where Opm_MonBas = @Opm_MonBas
		
	end
end
