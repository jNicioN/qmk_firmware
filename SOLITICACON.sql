create procedure SOLITICACON (
    @Ltc_Moneda int,
    @Ltc_TipCam int,
    @Ltc_LimInf numeric(10,6),
    @Ltc_LimSup numeric(10,6), 
	@Ltc_Activo bit,
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
** Descripcion : Consulta Limites de Tipo de Cambio                *
********************************************************************
** REFERENCIAS:                       
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         13/11/2023									   *
** Help Desk: 	  TCELTO-6348                                      *
********************************************************************/

                                    	/*Declaracion de variables*/
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1)
										/*Declaracion de Constantes*/
declare	@Ent_Uno	int,
		@Ent_Dos	int,
		@Str_C		char(1),
		@Str_L		char(1),
		@Str_Uno	char(1)
												/*Asignacion de Constantes*/												
select  @Ent_Uno	= 1,						/*Entero Uno*/
		@Ent_Dos	= 2,						/*Entero Dos*/
		@Str_C		= 'C',
		@Str_L		= 'L',
		@Str_Uno	= '1'

select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Str_C begin						/*Consulta*/
	if @Tip_ConCon = @Str_Uno begin					/*Consulta por Moneda y Tipo de cambio*/
		select Ltc_TipCam, Ltc_Moneda, Ltc_LimInf, Ltc_LimSup
			from SOLITICA
			where Ltc_TipCam = @Ltc_TipCam
			  and Ltc_Moneda = @Ltc_Moneda
			  and Ltc_Activo = @Ent_Uno
	end
end else if @Tip_ConTip = @Str_L begin				/*Consulta por Lista*/
	if @Tip_ConCon = @Str_Uno begin					/*Consulta por Tipo de Cambio*/
		select Ltc_TipCam, Ltc_Moneda, Ltc_LimInf, Ltc_LimSup
			from SOLITICA
			where Ltc_TipCam = @Ltc_TipCam
			  and Ltc_Activo = @Ent_Uno
	end
end