create procedure SOBIACDICON(
	@Bad_MovNum	char(10),
	@Bad_Client	char(8),
	@Bad_Cuenta	char(12),
	@Bad_NumTar	char(16),
	@Bad_Cantid	money,
	@Bad_Moneda	char(2),
	@Bad_FecTra	smalldatetime,
	@Bad_TipTar	char(4),
	@Bad_TipOpe	char(1),
	@Bad_Sucurs	char(3),
	@Bad_Accion	char(1),
	@CoI_NuIdCo int, 
	@Tip_Consul char(2),
	@Tip_TipPer char(1),
	@Tip_CliVIP char(1),
	@Tip_TitAdi char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/* *****************************************************************
** DESCRIPCION: Consulta de bitácora de acumulados diarios		  **
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		25/Oct/2018										****
** Help:		01091555										****
** Descripcion:	Para adicionales TD, no considerar que tope es	****
** 				igual a monto excento							****
********************************************************************
**					STORE CONVERTIDO							****
** Convirtió:	Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
********************************************************************
** Creó:		Brandon Hernandez Rada							****
** Fecha:		06/Jun/2018										****
** Help:		01088831										****
** Descripcion:	Consulta de bitácora de acumulados diarios		****
********************************************************************/

							/******Declaracion de variables******/
declare @Tip_ConTip char(1),
		@Tip_ConCon char(1),
		@Sum_Movimi money,
		@Sum_Revers money,
		@Tip_CamUdi money,
		@Tip_CamMon money,
		@Lim_Udis   money,
		@CoI_AcDiEx money,
		@CoI_AcDiLi money,
		@ClClientID int,
		@TaP_TitAdi char(1),
		@Cli_Numero char(12),
		@Cli_Tipo   char(1),
		@Opi_NuIdOp	int
		
							/******Declaracion de constantes******/
declare @Str_Consul char(1),
		@Str_Uno    char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Udis   char(2),
		@Sta_ConAct char(1),
		@Str_Activo char(1),
		@Str_Revers char(1),
		@Str_AccRev char(1),
		@Str_Vacio  char(1),
		@Str_TipAdi char(1),
		@Int_Nueves money,
		@Str_PerMor char(1),
		@Opi_DiTaDe	int
		
select  @Str_Consul = 'C',	/* Consulta			*/
		@Str_Uno    = '1',	/* String Uno		*/
		@Str_Dos	= '2',	/* String dos		*/
		@Str_Tres	= '3',	/* String tres		*/
		@Str_Udis	= '99',	/* String UDIS		*/
		@Sta_ConAct = 'A',	/* Status de configuración Activa */
		@Str_Activo = 'A',	/* Registro de bitácora de actividad */
		@Str_Revers = 'R',	/* Registro de bitácora de reversa */
		@Str_AccRev = '5',	/* Acción de reversa */
		@Str_Vacio  = '',	/* String en vacío */
		@Str_TipAdi = 'A',	/* Tipo de medio de disposición adicional */
		@Int_Nueves = 999999999,	/* Entero en nueves */
		@Str_PerMor = '1',	/* String persona moral */
		@Opi_DiTaDe	= 1		/* Operación disposición de tarjeta de débito */
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)


select	@ClClientID = ClClientID
	from CLCLIENT noholdlock
	where	Cli_Numero	= @Bad_Client

if @Tip_ConTip = @Str_Consul begin

	if @Tip_ConCon = @Str_Uno begin /**Consulta por el numero de transaccion**/
		select	Bad_MovNum, ClClientID, Bad_Cuenta, Bad_NumTar, Bad_Cantid, 
				Bad_Moneda, Bad_FecTra, Bad_TipTar, Bad_TipOpe, Bad_Sucurs, 
				Bad_Accion
			from SOBIACDI noholdlock
			where	Bad_MovNum = @Bad_MovNum
	end
	
	if @Tip_ConCon = @Str_Dos begin /**Consulta por Cliente**/
	
	    if @Bad_NumTar != @Str_Vacio begin
	    	select	@TaP_TitAdi	= TaP_TitAdi 
				from CTTARPRO noholdlock
				where	TaP_Tarjet	= @Bad_NumTar
	    end	    
	    --Al ser el tipo de dato de Cio_TiMeDi char(1), se requiere inicializar el valor de la variable @TaP_TitAd para que pueda hacer match con la tabla en SOCOIDOP
	    select	@TaP_TitAdi	= isnull(@TaP_TitAdi, @Str_Vacio)

		select	@CoI_AcDiEx = isnull(Cio_AcDiEx,00.00),	/*Consultas*/
				@CoI_AcDiLi = isnull(Cio_AcDiLi,00.00)
			from SOCOIDOP con noholdlock
				 inner join SOOPEIDE ope noholdlock on con.Cio_NuIdOp = ope.Opi_NuIdOp
			where	con.Cio_NuIdOp	= @CoI_NuIdCo	
			  and	con.Cio_Status	= @Sta_ConAct
			  and	con.Cio_TipPer	= @Tip_TipPer
			  and	con.Cio_CliVIP	= @Tip_CliVIP
			--Se cambia @Tip_TitAdi por valor consultado aquí mismo (@TaP_TitAdi), se consultó con Brandon Rada
			  and	con.Cio_TiMeDi	= @TaP_TitAdi
			
						
		select	@CoI_AcDiEx = isnull((@CoI_AcDiEx *  Mon_EfeVen),00.00),
				@CoI_AcDiLi = isnull((@CoI_AcDiLi *  Mon_EfeVen),00.00)
			from SOMONEDA noholdlock
			where	Mon_Numero = @Str_Udis 

		if @TaP_TitAdi =  @Str_TipAdi begin
			select @CoI_AcDiLi = @CoI_AcDiEx
		end		

	    select	distinct @Sum_Movimi	= isnull(sum(Bad_Cantid),00.00),
				@Bad_Moneda = Bad_Moneda
			from SOBIACDI noholdlock 
			where	ClClientID	= @ClClientID
			  and	Bad_NumTar	= @Bad_NumTar 
			  and	Bad_FecTra	= @Bad_FecTra 
			  and	Bad_TipOpe	= @Str_Activo
			  and	Bad_Accion	= @Bad_Accion
	    
	    select	@Sum_Movimi = (@Sum_Movimi * Mon_EfeVen)
			from SOMONEDA noholdlock
			where	Mon_Numero	= @Bad_Moneda
	    
	    select	distinct @Sum_Revers	= isnull(sum(Bad_Cantid),00.00),
				@Bad_Moneda	= Bad_Moneda
			from SOBIACDI noholdlock 
	    where	ClClientID = @ClClientID
		  and	Bad_NumTar = @Bad_NumTar 
		  and	Bad_FecTra = @Bad_FecTra 
		  and	Bad_TipOpe = @Str_Revers
		  and	Bad_Accion = @Bad_Accion
		
	    select	@Sum_Revers = (@Sum_Revers * Mon_EfeVen)
			from SOMONEDA noholdlock
			where	Mon_Numero	= @Bad_Moneda
			
		select  @CoI_AcDiEx as CoI_AcDiEx,
				@CoI_AcDiLi as CoI_AcDiLi,
				@Sum_Movimi as Sum_Movimi,
				@Sum_Revers as Sum_Revers
	end
	
	if @Tip_ConCon = @Str_Tres begin /**Consulta por Cuenta**/
	    
	    if @Bad_NumTar != @Str_Vacio begin
	    	select	@TaP_TitAdi	= TaP_TitAdi
				from CTTARPRO
				where  TaP_Tarjet	= @Bad_NumTar
	    end	    
	    
	    --Al ser el tipo de dato de Cio_TiMeDi char(1), se requiere inicializar el valor de la variable @TaP_TitAd para que pueda hacer match con la tabla en SOCOIDOP
	    select	@TaP_TitAdi	= isnull(@TaP_TitAdi, @Str_Vacio)
	    
	    select	@Cli_Numero	= Cue_Client
			from CHCUENTA
			where	Cue_Numero	= @Bad_Cuenta
	    
	    select	@Cli_Tipo	=  Cli_Tipo
			from CLCLIENT
			where	Cli_Numero	= @Cli_Numero 
	    
	    if(@Cli_Tipo != @Str_PerMor)begin
			select	@CoI_AcDiEx = isnull(Cio_AcDiEx,00.00),	
					@CoI_AcDiLi = isnull(Cio_AcDiLi,00.00),
					@Opi_NuIdOp	= Opi_NuIdOp
				from SOCOIDOP con noholdlock
					inner join SOOPEIDE ope noholdlock on con.Cio_NuIdOp = ope.Opi_NuIdOp
				where	con.Cio_NuIdOp	= @CoI_NuIdCo	
				  and	con.Cio_Status  = @Sta_ConAct
				  and	con.Cio_TipPer  = @Tip_TipPer
				  and	con.Cio_CliVIP  = @Tip_CliVIP
				  and	con.Cio_TiMeDi  = @TaP_TitAdi	

	    end else begin
	    	select	@CoI_AcDiEx	= @Int_Nueves,	
					@CoI_AcDiLi	= @Int_Nueves
	    end
	       			
		select	@CoI_AcDiEx = (@CoI_AcDiEx *  Mon_EfeVen),
				@CoI_AcDiLi = (@CoI_AcDiLi *  Mon_EfeVen)
			from SOMONEDA noholdlock			
			where	Mon_Numero = @Str_Udis


		/* Para operaciones de tarjeta de débito adicionales no aplicará el tope de dispo diaria sin opción a huella disponer más con la huella */
		if @Opi_NuIdOp != @Opi_DiTaDe begin
			if @TaP_TitAdi =  @Str_TipAdi begin
				select	@CoI_AcDiLi	= @CoI_AcDiEx
			end		
		end
			
	    select	distinct @Sum_Movimi	= isnull(sum(Bad_Cantid),00.00),
				@Bad_Moneda = Bad_Moneda
			from SOBIACDI noholdlock 
			where	Bad_Cuenta	= @Bad_Cuenta
			  and	Bad_FecTra	= @Bad_FecTra 
			  and	Bad_Accion	= @Bad_Accion
			  and	Bad_TipOpe	= @Str_Activo

	    select	@Sum_Movimi	= (@Sum_Movimi * Mon_EfeVen)
			from SOMONEDA noholdlock
			where	Mon_Numero	= @Bad_Moneda
	    
	    select	distinct @Sum_Revers	= isnull(sum(Bad_Cantid),00.00),
				@Bad_Moneda = Bad_Moneda
			from SOBIACDI noholdlock 
			where	Bad_Cuenta	= @Bad_Cuenta
			  and	Bad_FecTra	= @Bad_FecTra 
			  and	Bad_Accion	= @Bad_Accion
			  and	Bad_TipOpe	= @Str_Revers
		
	    select	@Sum_Revers	= (@Sum_Revers * Mon_EfeVen)
			from SOMONEDA noholdlock
			where	Mon_Numero	= @Bad_Moneda
			
		select 	@CoI_AcDiEx as CoI_AcDiEx,
				@CoI_AcDiLi as CoI_AcDiLi,
				@Sum_Movimi as Sum_Movimi,
				@Sum_Revers as Sum_Revers
	end
end
