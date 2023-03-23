create procedure SOPECUTACON (
	@Pct_PerUni	char(8),
	@Tip_Consul	char(2),




	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as




/*******************************************************************
** DESCRIPCION: Consulta de cuentas y tarjetas de una persona	****
********************************************************************
** Creo:		Marcelo Bautista Hernandez				        ****
** Fecha:		24/Marzo/2023									****
** Help:		TCELID-13293											****
** Descripcion:	Creacion consulta cuentas y tarjetas por persona****
*******************************************************************/




/* Declaracion de Variables */
declare	@Tip_ConTip	char(1), /* Consulta Tipo C/L*/
		@Tip_ConCon	char(1)




/* Declaracion de Constantes */
declare	@Str_Vacio			char(1), /* Vacio */
		@Str_C				char(1), /* Tipo C */
		@Str_Uno			char(1), /* Tipo 1 */
		@Cli_ClaBR			smallint,
		@Int_Cero			smallint,
		@Sta_Activa			char(1),
		@Cue_RegInd			char(1),
		/*Tipos de tarjetas*/
		@Tar_Tradicional	char(4), /*TRADICIONAL*/
		@Tar_Preferente    	char(4), /*PREFERENTE*/
		@Tar_Nar    		char(4), /*NARANJA*/
		@Tar_TraDolar    	char(4), /*TRADICIONAL DOLARES*/
		@Tar_PrefDolar    	char(4), /*PREFERENTE DOLARES*/
		@Tar_NarDolar    	char(4), /*NARANJA DOLARES */
		@Tar_FronDOlar    	char(4) /*FRONTERIZA DOLARES */




/* Asignacion de Constantes */
select	@Str_Vacio			= '',
		@Str_C				= 'C',
		@Str_Uno			= '1',
		@Cli_ClaBR			= 2,

		@Int_Cero			= 0,
		@Sta_Activa			= 'A',
		@Cue_RegInd			= 'I',
		@Tar_Tradicional	= '0101',
		@Tar_Preferente    	= '0102',
		@Tar_Nar    		= '0135',
		@Tar_TraDolar    	= '0301',
		@Tar_PrefDolar    	= '0302',
		@Tar_NarDolar    	= '0303',
		@Tar_FronDOlar		= '0316'


/* Asignacion de Variables */
select	@Tip_ConTip	= substring(@Tip_Consul,1 , 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)




if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin




		create table #PersonaCueTar (
			Pct_PerUni	char(8),
			Pct_Person	char(8),
			Pct_CliID	int,
			Pct_ClaCli	int,
			Pct_NumCta	char(12),
			Pct_CueSta	char(1),
			Pct_CueNiv	int,
			Pct_CueReg	char(1),
			Pct_NumTar	char(16),
			Pct_TitAdi	char(1),
			Pct_TipTar	char(4),
			Pct_StaTar	char(1)
		)
		insert into #PersonaCueTar
		select	Peu_Grupo,	Peu_Person,	ClClientID,	@Int_Cero,	Cue_Numero,
				Cue_Status,	@Int_Cero,	@Str_Vacio,	TaP_Tarjet,	TaP_TitAdi,
				TaP_TipTar,TaP_StaTar
		from SOUNIPER uni noholdlock
		inner join CLADICIO adc noholdlock on Peu_Person=Adi_NumPer
		inner join CHCUENTA cue noholdlock on Adi_Client=Cue_Client
		inner join CTTARPRO tap noholdlock on Adi_Client=TaP_Client
		where	Peu_Grupo	=	@Pct_PerUni
			and Cue_Status	=	@Sta_Activa
			and TaP_StaTar	=	@Sta_Activa
			AND TaP_TipTar IN (
				@Tar_Tradicional,
				@Tar_Preferente ,
				@Tar_Nar,
				@Tar_TraDolar,
				@Tar_PrefDolar,
				@Tar_NarDolar,
				@Tar_FronDOlar
			)




		update #PersonaCueTar set
			Pct_CueReg	=	Sol_Regime
		from #PersonaCueTar pct
		inner join CHSOLICI sol noholdlock on Pct_NumCta = Sol_Cuenta




		update #PersonaCueTar set
			Pct_ClaCli	=	Clc_Clasif
		from #PersonaCueTar pct
		inner join CLCLACLI noholdlock on pct.Pct_CliID = Clc_Client




		update #PersonaCueTar set
			Pct_CueNiv	=	Cun_NivCue
		from #PersonaCueTar pct
		inner join CHCUENIV noholdlock on Pct_NumCta = Cun_Cuenta
		
		select	Pct_PerUni,	Pct_Person,	Pct_CliID,	Pct_ClaCli,	Pct_NumCta,
				Pct_CueSta,	Pct_CueNiv,	Pct_CueReg,	Pct_NumTar,	Pct_TitAdi,
				Pct_TipTar,	Pct_StaTar
		from #PersonaCueTar pct




		drop table #PersonaCueTar
	end
end
