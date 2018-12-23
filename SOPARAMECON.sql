create procedure SOPARAMECON (
	@Par_Sucurs	char(3),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

if @Tip_Consul = '' begin	/* Cliente:  FoxPro */	
	select	Par_Sucurs,	Par_CheCaj,	Par_IVA,	Par_ISR,	Par_DiBaIn,
			Par_DiBaCr,	Par_DiBaCh,	Par_ChLey1,	Par_ChLey2,	Par_ChLey3,
			Par_CheCer,	Par_DiaRem,	Par_LimAut,	Par_TranBR,	Par_CliInd,
			Par_BanFol,	Par_FecAct,	Par_CoCoIn,	Par_CoReme,	Par_OpeBan,
			Par_ConPap,	Par_MonCom,	Par_LinSob,	Par_EnvSPE,	Par_Banco,
			Par_ComRem,	Par_IvaRem,	Par_RemExt,	Par_IVAREX,	Par_GiBaEx,
			Par_GiBaNa,	Par_IVAGBN,	Par_IVAGBE,	Par_ComSPE,	Par_IVASPE,
			Par_NumTes,	Par_IncISR,	Par_InsISR,	Par_SPEUA,	Par_SIAC,
			Par_CobInm,	Par_FecRem,	Par_IntBan	
		from SOPARAMS noholdlock
		where	Par_Sucurs	= @Par_Sucurs
end else begin			/* Cliente:  Visual Basic */
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta de Llave Principal */
			select	Par_Sucurs,	Par_CheCaj,	Par_IVA,	Par_ISR,	Par_DiBaIn,
					Par_DiBaCr,	Par_DiBaCh,	Par_ChLey1,	Par_ChLey2,	Par_ChLey3,
					Par_CheCer,	Par_DiaRem,	Par_LimAut,	Par_TranBR,	Par_CliInd,
					Par_BanFol,	Par_FecAct,	Par_CoCoIn,	Par_CoReme,	Par_OpeBan,
					Par_ConPap,	Par_MonCom,	Par_LinSob,	Par_EnvSPE,	Par_Banco,
					Par_ComRem,	Par_IvaRem,	Par_RemExt,	Par_IVAREX,	Par_GiBaEx,
					Par_GiBaNa,	Par_IVAGBN,	Par_IVAGBE,	Par_ComSPE,	Par_IVASPE,
					Par_NumTes,	Par_IncISR,	Par_InsISR,	Par_SPEUA,	Par_SIAC,
					Par_CobInm,	Par_FecRem,	Par_IntBan
				from SOPARAMS noholdlock
				where	Par_Sucurs	= @Par_Sucurs
		end else if @Tip_ConCon = '2' begin		/* Consulta de Parametros Principales */
			select	Par_Sucurs,	Par_IVA,	Par_DiBaCh,	Par_FecAct,	Par_MonCom,	Par_Banco
				from SOPARAMS noholdlock
				where	Par_Sucurs	= @Par_Sucurs
		end else if @Tip_ConCon = '3' begin		/* Consulta datos Adicionales */
			select	Par_Sucurs,	Par_HoEnSp
				from SOPARAMS noholdlock
				where	Par_Sucurs	= @Par_Sucurs
		end


		/* NOTA:  Si se requiere agregar un parameto mas que no tiene nada que ver con los Princiaples para la Entrada del Sistema, de preferencia agregar una opcion mas */
		
/*	end else begin					/* 'L':  Lista */
		select	@Suc_Nombre	= ltrim(rtrim(@Suc_Nombre)) + '%'
		
		if @Tip_ConCon = '1' begin				/* Lista General */
		end*/
	end
end
