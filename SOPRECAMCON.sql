create procedure SOPRECAMCON (
    @Prc_Moneda int,
    @Prc_TipCam int,
    @Prc_TiOpCa int,
	@Prc_Fecha	smalldatetime,
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
** Descripcion : Consulta Precios de Cambio                        *
********************************************************************
** REFERENCIAS:
********************************************************************
** Creó:          Hébel Cruz          						 	   *
** Fecha:         11/04/2025									   *
** Help Desk: 	  TCELTO-12900                                     *  
** Descripción:	  Se añade lista general para precios cambios	   *                     
********************************************************************
** Creó:          Shaila Palafox          						   *
** Fecha:         05/12/2022									   *
** Help Desk: 	  TCELTO-2037                                      *
********************************************************************/

                                    	/*Declaracion de variables*/
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1),
		@Par_FecAct	smalldatetime
										/*Declaracion de Constantes*/
declare	@Ent_Uno	int,
		@Ent_Dos	int,
		@Str_C		char(1),
		@Str_L		char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Fec_Vacia	smalldatetime
												/*Asignacion de Constantes*/												
select  @Ent_Uno	= 1,						/*Entero Uno*/
		@Ent_Dos	= 2,						/*Entero Dos*/
		@Str_C		= 'C',
		@Str_L		= 'L',
		@Str_Uno	= '1',
		@Str_Dos	= '2',
		@Fec_Vacia	= '1900-01-01'

select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

if isnull(@Prc_Fecha, @Fec_Vacia) = @Fec_Vacia
	select	@Prc_Fecha	= @Par_FecAct

select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)


if @Tip_ConTip = @Str_C begin						/*Consulta*/
	if @Tip_ConCon = @Str_Uno begin					/*Consulta por Moneda, Tipo de cambio y Operacion*/
		select Prc_Numero, Prc_Precio
			into #Precio
			from SOPRECAM noholdlock
			where Prc_Moneda = @Prc_Moneda
              and Prc_TipCam = @Prc_TipCam
              and Prc_TiOpCa = @Prc_TiOpCa
		
		if @Prc_Fecha <> @Par_FecAct
			update #Precio set
				Prc_Precio	=  Dpc_Precio
				from SODIPRCA noholdlock
					where Prc_Numero = Dpc_PreCam
					  and Dpc_Fecha  = @Prc_Fecha
		
		select Prc_Precio
			from #Precio
		
		drop table #Precio
				

	end
end else if @Tip_ConTip = @Str_L begin				/*Consulta por Lista*/
	if @Tip_ConCon = @Str_Uno begin					/*Consulta por Moneda*/
		select Prc_Precio 
			from SOPRECAM noholdlock
			where Prc_Moneda = @Prc_Moneda
	end else if @Tip_ConCon = @Str_Dos begin		/*Consulta General (Registros Activos)*/
		select Prc_Moneda, Prc_Precio 
			from SOPRECAM noholdlock	
			where Prc_Activo = @Ent_Uno
	end
end