create procedure SOPARAMSALT (
	@Par_Sucurs	char(3),	
	@Par_CheCaj	int,			
	@Par_IVA	smallmoney,
 	@Par_ISR	smallmoney,	
 	@Par_DiBaIn	int, 			
 	@Par_DiBaCr	int, 
	@Par_DiBaCh	int,		
	@Par_ChLey1	varchar(80),	
	@Par_ChLey2	varchar(80),
 	@Par_ChLey3	varchar(80),	
 	@Par_CheCer	char(2),	
 	@Par_DiaRem	smallint,
 	@Par_LimAut	money,		
 	@Par_TranBR	char(11),		
 	@Par_CliInd	int,	 
 	@Par_BanFol	int,		
 	@Par_FecAct	smalldatetime,	
 	@Par_CoCoIn	smallmoney,
 	@Par_CoReme	smallmoney,	
 	@Par_OpeBan	int,		
 	@Par_ConPap	int,
 	@Par_MonCom	char(2),	
 	@Par_LinSob	char(20),		
 	@Par_EnvSPE	int,
 	@Par_Banco	char(3),	
 	@Par_ComRem	char(12),		
 	@Par_IvaRem	char(12),
 	@Par_RemExt	char(12),	
 	@Par_IVAREX	char(12),		
 	@Par_GiBaEx	char(12),
 	@Par_GiBaNa	char(12),	
 	@Par_IVAGBN	char(12),		
 	@Par_IVAGBE	char(12),
 	@Par_ComSPE	char(12),	
 	@Par_IVASPE	char(12),		
 	@Par_NumTes	char(3),
 	@Par_IncISR	char(12),	
 	@Par_InsISR	char(12),		
 	@Par_SPEUA	char(12),
 	@Par_SIAC	char(12),	
 	@Par_CobInm	char(12),		
 	@Par_IntBan char(15),
 
 	@NumTransac	char(10),	
 	@Transaccio	char(3), 		
 	@Usuario	char(6), 
 	@FechaSis	smalldatetime,	
 	@SucOrigen	char(3), 	
 	@SucDestino	char(3),
 	@Modulo		char(2))

as

/* Declaración de Variables */
declare	@Status		int,
		@Par_HorEnv smalldatetime

/* Declaración de Constantes */
declare	@Cue_Compan	char(3),
		@Tip_Actual	char(1),
		@Fec_Vacia	smalldatetime,
		@Par_Compan	char(2),
		@Par_Messen	char(1),
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Anio	int,
		@Fec_MilNov	smalldatetime

/* Asignación de Constantes */
select	@Cue_Compan	= '001',			/* Compañia Contable BANREGIO */
		@Tip_Actual	= 'A',				/* Tipo de Actualizacion	  */
		@Fec_Vacia	= '1900/01/01',		/* Fecha Vacia				  */
		@Par_Compan = '01',				/* Parametro de Compañia 	  */
		@Par_Messen	= 'N',				/* Parametro Messenger: No    */
		@Str_Vacio	= '',				/* String Vacio				  */
		@Ent_Cero	= 0,				/* Entero en Cero			  */
		@Ent_Anio	= 360,				/* Anio */
		@Fec_MilNov	= '1990-01-01'		/* Fecha 1990 */

select @Par_HorEnv	= Par_HorEnv
	from SPPARAMS noholdlock

if @Par_IVA <= @Ent_Cero begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'IVA incorrecto', 
			Err_Variab	= 'Par_IVA'
	rollback 
	return 1
	
end else if @Par_ISR <= @Ent_Cero begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'ISR incorrecto', 
			Err_Variab	= 'Par_ISR'
	rollback 
	return 1
	
end else if @Par_CheCaj < @Ent_Cero begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'El num. de cheques de caja está incorrecto', 
			Err_Variab	= 'Par_CheCaj'
	rollback 
	return 1
	
end else if @Par_DiBaIn < @Ent_Anio begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'Número de días base de inversiones incorrecto', 
			Err_Variab	= 'Par_DiBaIn'
	rollback 
	return 1
	
end else if @Par_DiBaCr < @Ent_Anio  begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'Número de días base de créditos incorrecto', 
			Err_Variab	= 'Par_DiBaCr'
	rollback 
	return 1
	
end else if @Par_DiBaCh < @Ent_Anio begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'Número de días base de cheques incorrecto', 
			Err_Variab	= 'Par_DiBaCh'
	rollback 
	return 1
	
end else if convert(int, @Par_CheCer) < @Ent_Cero begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'Número de Cheques certificados incorrecto',
			Err_Variab	= 'Par_CheCer'
	rollback 
	return 1
	
end else if @Par_DiaRem < @Ent_Cero begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'Número de días de remesa incorrecto', 
			Err_Variab	= 'Par_DiaRem'
	rollback 
	return 1
	
end else if @Par_LimAut < @Ent_Cero begin
	select	Err_Codigo	= '000009', 
			Err_Mensaj	= 'Cantidad de límite autorizado incorrecta', 
			Err_Variab	= 'Par_LimAut'
	rollback 
	return 1
	
end else if convert(float, @Par_TranBR) <= @Ent_Cero begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'Tránsito BanRegio está en ceros', 
			Err_Variab	= 'Par_TranBR'
	rollback 
	return 1
	
end else if @Par_CliInd < @Ent_Cero begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'Número de cliente indeseables incorrecto', 
			Err_Variab	= 'Par_CliInd'
	rollback 
	return 1
	
end else if @Par_BanFol <= @Ent_Cero begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'El folio está incorrecto', 
			Err_Variab	= 'Par_BanFol'
	rollback 
	return 1
	
end else if @Par_FecAct < @Fec_MilNov begin
	select	Err_Codigo	= '000012', 
			Err_Mensaj	= 'Fecha actual incorrecta', 
			Err_Variab	= 'Par_FecAct'
	rollback 
	return 1
	
end else if @Par_CoCoIn <= @Ent_Cero begin
	select	Err_Codigo	= '000013', 
			Err_Mensaj	= 'Cantidad para Devolución Cobro Inmediato incorrecta', 
			Err_Variab	= 'Par_CoCoIn'
	rollback 
	return 1
	
end else if @Par_CoReme < @Ent_Cero begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'Cantidad de Remesa en falso incorrecta', 
			Err_Variab	= 'Par_CoReme'
	rollback 
	return 1
	
end else if @Par_OpeBan < @Ent_Cero begin
	select	Err_Codigo	= '000015', 
			Err_Mensaj	= 'Número de operaciones incorrecto', 
			Err_Variab	= 'Par_OpeBan'
	rollback 
	return 1
	
end else if @Par_ConPap < @Ent_Cero begin
	select	Err_Codigo	= '000016', 
			Err_Mensaj	= 'Número de papel de mesa de dinero incorrecto', 
			Err_Variab	= 'Par_ConPap'
	rollback 
	return 1
	
end else if convert(int, @Par_MonCom) <= @Ent_Cero begin
	select	Err_Codigo	= '000017', 
			Err_Mensaj	= 'Número de Moneda de comisiones incorrecto', 
			Err_Variab	= 'Par_MonCom'
	rollback 
	return 1
	
end else if @Par_EnvSPE < @Ent_Cero begin
	select	Err_Codigo	= '000019', 
			Err_Mensaj	= 'Número de folio de SPEUA incorrecto', 
			Err_Variab	= 'Par_EnvSPE'
	rollback 
	return 1
	
end else if convert(int, @Par_Banco) <= @Ent_Cero begin
	select	Err_Codigo	= '000020', 
			Err_Mensaj	= 'Número de Banco incorrecto', 
			Err_Variab	= 'Par_Banco'
	rollback 
	return 1
	
end else if convert(int, @Par_NumTes) = @Ent_Cero begin
	select	Err_Codigo	= '000021', 
			Err_Mensaj	= 'El NumTes est  en ceros', 
			Err_Variab	= 'Par_NumTes'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_ComRem
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000022', 
			Err_Mensaj	= 'La cuenta para Com. Rem. no existe', 
			Err_Variab	= 'Par_ComRem'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IvaRem
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000023', 
			Err_Mensaj	= 'La cuenta para Iva. Rem. no existe', 
			Err_Variab	= 'Par_IvaRem'
	rollback 
	return 1

end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_RemExt
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000024', 
			Err_Mensaj	= 'La cuenta para Rem. Ext. no existe', 
			Err_Variab	= 'Par_RemExt'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAREX
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000025', 
			Err_Mensaj	= 'La cuenta para IVA. REX. no existe', 
			Err_Variab	= 'Par_IVAREX'
	rollback 
	return 1

end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_GiBaEx
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000026', 
			Err_Mensaj	= 'La cuenta para Gir. Ban. Ex. no existe', 
			Err_Variab	= 'Par_GiBaEx'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_GiBaNa
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000027', 
			Err_Mensaj	= 'La cuenta para Gir. Ban. Na. no existe', 
			Err_Variab	= 'Par_GiBaNa'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAGBN
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000028', 
			Err_Mensaj	= 'La cuenta para IVA Gir.Ban Na. no existe', 
			Err_Variab	= 'Par_IVAGBN'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVAGBE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000029', 
			Err_Mensaj	= 'La cuenta para IVA Gir. Be. no existe', 
			Err_Variab	= 'Par_IVAGBE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock	
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_ComSPE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000030', 
			Err_Mensaj	= 'La cuenta para Comisión SPEUA no existe', 
			Err_Variab	= 'Par_ComSPE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IVASPE
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000031', 
			Err_Mensaj	= 'La cuenta para IVA SPEUA no existe', 
			Err_Variab	= 'Par_IVASPE'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_IncISR
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000032', 
			Err_Mensaj	= 'La cuenta para Inc ISR no existe', 
			Err_Variab	= 'Par_IncISR'
	rollback 
	return 1
	
end else if not exists (select	Cue_Descri 
							from COCUENTA noholdlock
							where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @Par_InsISR
							  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000033', 
			Err_Mensaj	= 'La cuenta para Ins ISR no existe', 
			Err_Variab	= 'Par_InsISR'
	rollback 
	return 1
	
end else begin
	insert into SOPARAMS values (
		@Par_Sucurs,	@Par_CheCaj,	@Par_IVA,		@Par_ISR,		@Par_DiBaIn,
		@Par_DiBaCr, 	@Par_DiBaCh,	@Par_ChLey1,	@Par_ChLey2,	@Par_ChLey3,
		@Par_CheCer,	@Par_DiaRem,	@Par_LimAut,	@Par_TranBR,	@Par_CliInd,
		@Par_BanFol,	@Par_FecAct,	@Par_CoCoIn,	@Par_CoReme,	@Par_OpeBan,
		@Par_ConPap,	@Par_MonCom,	@Par_LinSob,	@Par_EnvSPE,	@Par_Banco,
		@Par_ComRem,	@Par_IvaRem,	@Par_RemExt,	@Par_IVAREX,	@Par_GiBaEx,
	 	@Par_GiBaNa,	@Par_IVAGBN,	@Par_IVAGBE,	@Par_ComSPE,	@Par_IVASPE,
	 	@Par_NumTes,	@Par_IncISR,	@Par_InsISR,	@Par_SPEUA,		@Par_SIAC,
	 	@Par_CobInm,	@Par_FecAct,	@Par_IntBan,	@Par_HorEnv,	@Par_Compan,
	 	@Par_Messen,	@Str_Vacio,		@NumTransac, 	@Transaccio,	@Usuario,
	 	@FechaSis,	 	@SucOrigen, 	@SucDestino )

	exec @Status = SOSUCURSACT
		@Par_Sucurs,	@Par_IVA,	@Tip_Actual,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo

	if @Status <> 0 begin
		rollback
		return 1
	end
end

