create procedure SOCTAESPMOD (
	@ParComRem	char(12),	
	@ParIvaRem	char(12),	
	@ParRemExt	char(12),
	@ParIVAREX	char(12),
	@ParGiBaEx	char(12),	
	@ParGiBaNa	char(12),
	@ParIVAGBN	char(12),	
	@ParIVAGBE	char(12),	
	@ParComSPE	char(12),
	@ParIVASPE	char(12),	
	@ParIncISR	char(12),	
	@ParInsISR	char(12),
	@ParSPEUA	char(12),	
	@ParSIAC	char(12),	
	@ParCobInm	char(12),

	@NumTransac	char(10),	
	@Transaccio char(3),	
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),	
	@SucDestino	char(3), 
	@Modulo		char(2))

as

declare	@Cue_Compan	char(3)			/* Declaración de Constantes */

/* Asignación de Constantes */
select	@Cue_Compan	= '001'			/* Compañia contable BANREGIO */

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParComRem
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'No existe cuenta comisión por remesa', 
			Err_Variab	= 'Par_ComRem'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIvaRem
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000002', 
			Err_Mensaj	= 'No existe cuenta iva comisión por remesa', 
			Err_Variab	= 'Par_IvaRem'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParRemExt
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000003', 
			Err_Mensaj	= 'No existe cuenta comisión de remesa extranjera', 
			Err_Variab	= 'Par_ComExt'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIVAREX
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000004', 
			Err_Mensaj	= 'No existe cuenta iva comisión de remesa extranjera', 
			Err_Variab	= 'Par_IVAREX'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParGiBaEx
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000005', 
			Err_Mensaj	= 'No existe cuenta comisión de giros bancarios extranjeros', 
			Err_Variab	= 'Par_GiBaEx'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParGiBaNa
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000006', 
			Err_Mensaj	= 'No existe cuenta comisión de giros bancarios nacionales', 
			Err_Variab	= 'Par_GiBaNa'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIVAGBE
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000007', 
			Err_Mensaj	= 'No existe cuenta iva comisión de giros bancarios extranjeros', 
			Err_Variab	= 'Par_IVAGBE'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIVAGBN
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000008', 
			Err_Mensaj	= 'No existe cuenta iva comisión de giros bancarios nacionales', 
			Err_Variab	= 'Par_IVAGBN'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParComSPE
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000010', 
			Err_Mensaj	= 'No existe cuenta comisión de SPEUA', 
			Err_Variab	= 'Par_ComSPE'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIVASPE
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000011', 
			Err_Mensaj	= 'No existe cuenta iva de comisión de SPEUA', 
			Err_Variab	= 'Par_IVASPE'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParIncISR
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000012', 
			Err_Mensaj	= 'No existe cuenta pago de Interes Cuenta de Cheques', 
			Err_Variab	= 'Par_IncISR'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParInsISR
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000013', 
			Err_Mensaj	= 'No existe cuenta pago de Interes Cuenta de Cheques', 
			Err_Variab	= 'Par_InsISR'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParSPEUA
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000014', 
			Err_Mensaj	= 'No existe cuenta transferencia de SPEUA', 
			Err_Variab	= 'Par_SPEUA'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParSIAC
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000015', 
			Err_Mensaj	= 'No existe cuenta transferencia de SIAC', 
			Err_Variab	= 'Par_SIAC'
	rollback
	return 1
end

if not exists (select	Cue_Cuenta 
				from COCUENTA noholdlock
				where	Cue_Cuenta + Cue_SubCue + Cue_SSCue + Cue_SSSCue + Cue_Concep	= @ParCobInm
				  and	Cue_Compan	= @Cue_Compan) begin
	select	Err_Codigo	= '000015', 
			Err_Mensaj	= 'No existe cuenta transferencia de Cobro Inmediato', 
			Err_Variab	= 'Par_CobInm'
	rollback
	return 1
end

if exists (select	*
			from SOPARAMS noholdlock
			where	Par_Sucurs	= @SucOrigen)
	update SOPARAMS set 
		Par_ComRem	= @ParComRem,
		Par_IvaRem	= @ParIvaRem,
		Par_RemExt	= @ParRemExt,
		Par_IVAREX	= @ParIVAREX,
		Par_GiBaEx	= @ParGiBaEx,
		Par_GiBaNa	= @ParGiBaNa,
		Par_IVAGBN	= @ParIVAGBN,
		Par_IVAGBE	= @ParIVAGBE,
		Par_ComSPE	= @ParComSPE,
		Par_IVASPE	= @ParIVASPE,
		Par_IncISR	= @ParIncISR,
		Par_InsISR	= @ParInsISR,
		Par_SPEUA 	= @ParSPEUA,
		Par_SIAC  	= @ParSIAC,
		Par_CobInm	= @ParCobInm
