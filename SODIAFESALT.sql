create procedure SODIAFESALT (
	@Dfe_Fecha	smalldatetime,
	@Dfe_Coment	varchar(255),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino	char(3),
	@Modulo 	char(2))

as

declare	@Ent_Cero	int,				/* Declaración de Constantes */
		@Sta_Proces	char(1),
		@Sta_Cancel	char(1),
		@Sta_Vencid	char(1),
		@Ope_Direct	char(1),
		@Ope_Report	char(1)

/* Asignacion de Constantes */
select	@Ent_Cero	= 0,				/* Entero en Cero */
		@Sta_Proces	= 'N',				/* Status de Procesado */
		@Sta_Cancel	= 'C',				/* Status de Cancelado */
		@Sta_Vencid	= 'V',				/* Status de Vencido */
		@Ope_Direct	= 'D',				/* Tipo de Operación en Directo */
		@Ope_Report	= 'R'				/* Tipo de Operación en Reporto */

if exists (select	Dfe_Fecha
			from SODIAFES noholdlock
			where	Dfe_Fecha	=	@Dfe_Fecha) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No se puede dar de alta, Fecha ya existe en dias festivos',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Creditos */
if (select	count(Amo_FecPag)
		from CRAMORTI noholdlock
		where	Amo_FecPag	= @Dfe_Fecha
		  and	Amo_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de los creditos con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Arrenda */
if (select	count(Amo_FecPag)
		from ABAMORTI noholdlock
		where	Amo_FecPag	= @Dfe_Fecha
		  and	Amo_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Credito de Arrendamientos con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Paa_FecPag)
		from ABPASAMO noholdlock
		where	Paa_FecPag	= @Dfe_Fecha
		  and	Paa_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Pasivos de Arrendadora con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Factoraje */
if (select	count(Paa_FecPag)
		from FAPASAMO noholdlock
		where	Paa_FecPag	= @Dfe_Fecha
		  and	Paa_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Pasivos de Factoraje con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Fac_FecVen)
		from FAFACTOR noholdlock
		where	Fac_FecVen	= @Dfe_Fecha
		  and	Fac_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'No se puede dar de alta, existen Factorajes con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Doc_FecPag)
		from FADOCUME noholdlock
		where	Doc_FecPag	= @Dfe_Fecha
		  and	Doc_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'No se puede dar de alta, existen Documentos del Factoraje con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Amp_FecIni)
		from ITPASAMO noholdlock
		where	Amp_FecIni	= @Dfe_Fecha
		  and	Amp_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000008',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Pasivos en Dolares con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación CC */
if (select	count(Amo_FecPag)
		from CCAMORTI noholdlock
		where	Amo_FecPag	= @Dfe_Fecha
		  and	Amo_Status	in (@Sta_Proces, @Sta_Vencid)) > @Ent_Cero begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Creditos al Consumo con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Tarjeta de Crédito */
if (select	count(Cor_Fecha)
		from TACORTCR noholdlock
		where	Cor_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000010',
			Err_Mensaj	= 'No se puede dar de alta, existen Pagos de Tarjeta de Credito con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Sav_FecVen)
		from TASALVEN noholdlock
		where	Sav_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'No se puede dar de alta, existen Pagos Vencidos de Tarjeta de Credito con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Tarjeta de Crédito CC */
if (select	count(Cor_Fecha)
		from MFCORTCR noholdlock
		where	Cor_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000012',
			Err_Mensaj	= 'No se puede dar de alta, existen Pagos de Tarjeta de Credito de CC con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Sav_FecVen)
		from MFSALVEN noholdlock
		where	Sav_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'No se puede dar de alta, existen Pagos Vencidos de Tarjeta de Credito de CC con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Pagare */
if (select	count(Inv_FecVen)
		from ININVERS noholdlock
		where	Inv_FecVen	= @Dfe_Fecha
		  and	Inv_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000014',
			Err_Mensaj	= 'No se puede dar de alta, existen Inversiones Pagare con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Mesa de Dinero */
if (select	count(Inv_FecVen)
		from MDINVERS noholdlock
		where	Inv_FecVen	= @Dfe_Fecha
		  and	Inv_Status	= @Sta_Proces) > @Ent_Cero begin
	select	Err_Codigo	= '000015',
			Err_Mensaj	= 'No se puede dar de alta, existen Inversiones de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Inc_Invers)
		from MDINVERS noholdlock,
			 MDINVCUP noholdlock
		where	Inc_Invers	= Inv_Numero
		  and	Inv_Operac	= @Ope_Direct
		  and	Inv_Status	= @Sta_Proces
  		  and	Inc_FecIni	<= @Dfe_Fecha
		  and	Inc_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000016',
			Err_Mensaj	= 'No se puede dar de alta, existen Cupones de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Pap_Numero)
		from MDPAPEL noholdlock
		where	Pap_FecVen	= @Dfe_Fecha
		  and	Pap_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000017',
			Err_Mensaj	= 'No se puede dar de alta, existen Papeles de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Pac_Papel)
		from MDPAPEL noholdlock,
			 MDPAPCUP noholdlock
		where	Pap_Numero	= Pac_Papel
		  and	Pap_Operac	= @Ope_Direct
		  and	Pap_PerCup	<> @Ent_Cero
		  and	Pap_Status	<> @Sta_Cancel
		  and	Pac_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000018',
			Err_Mensaj	= 'No se puede dar de alta, existen Cupones de Papel de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Emc_Emisio)
		from MDPAPEL noholdlock,
			 MDEMISIO noholdlock,
			 MDEMICUP noholdlock
		where	Pap_Emisio	= Emi_Numero
		  and	Emi_Numero	= Emc_Emisio
		  and	Pap_Status	<> @Sta_Cancel
		  and	Pap_Operac	= @Ope_Report
		  and	Emc_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000019',
			Err_Mensaj	= 'No se puede dar de alta, existen Emisiones que cortan Cupon de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Vei_Numero)
		from MDVENINS noholdlock
		where	Vei_FecIni	<= @Dfe_Fecha	/* Se agrego para que usara el indice */
		  and	Vei_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000020',
			Err_Mensaj	= 'No se puede dar de alta, existen Venta a Instituciones de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Cut_Numero)
		from MDCUSTIT noholdlock
		where	Cut_FecIni	<= @Dfe_Fecha	/* Se agrego para que usara el indice */
		  and	Cut_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000021',
			Err_Mensaj	= 'No se puede dar de alta, existen Custodia de Titulos de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Cuc_FecIni)
		from MDCUSCUP noholdlock
		where	Cuc_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000022',
			Err_Mensaj	= 'No se puede dar de alta, existen Cupones de Custodia de Titulos de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Ofv_Numero)
		from MDOPFEVA noholdlock
		where	Ofv_FecIni	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000023',
			Err_Mensaj	= 'No se puede dar de alta, existen Operaciones Fecha Valor de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Dea_Numero)
		from MDDEAL noholdlock
		where	Dea_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000024',
			Err_Mensaj	= 'No se puede dar de alta, existen Deals de MD con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Derivados */
if (select	count(Ope_FecLiq)
		from DEOPERAC noholdlock
		where	Ope_FecLiq	= @Dfe_Fecha
		  and	Ope_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000025',
			Err_Mensaj	= 'No se puede dar de alta, existen Operaciones de Derivados con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Amo_FecLiq)
		from DEOPERAC noholdlock,
			 DEAMORTI noholdlock
		where	Ope_Numero	= Amo_Operac
		  and	Ope_Status	<> @Sta_Cancel
		  and	Amo_FecLiq	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000026',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizciones de Derivados con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validación Tesoreria */
if (select	count(Pap_FecVen)
		from TEPAPEL noholdlock
		where	Pap_FecVen	= @Dfe_Fecha
		  and	Pap_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000027',
			Err_Mensaj	= 'No se puede dar de alta, existen Papeles con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Emi_FecVen)
		from TEEMISIO noholdlock
		where	Emi_FecVen	= @Dfe_Fecha
		  and	Emi_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000028',
			Err_Mensaj	= 'No se puede dar de alta, existen Emisiones Propias (Deuda) con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Ofv_FecIni)
		from TEOPFEVA noholdlock
		where	dateadd(dd, Ofv_Plazo, Ofv_FecIni)	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000029',
			Err_Mensaj	= 'No se puede dar de alta, existen Capturas de Operaciones Fecha Valor con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Pac_FecVen)
		from TEPAPEL noholdlock,
			 TEPAPCUP noholdlock
		where	Pap_Numero	= Pac_Papel
		  and	Pap_Status	<> @Sta_Cancel
		  and	Pac_FecVen	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000030',
			Err_Mensaj	= 'No se puede dar de alta, existen Cupones del Papel con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validacion de Internacional */
if (select	count(Orp_FecVen)
		from ITORDPAG noholdlock
		where	Orp_FecVen	= @Dfe_Fecha
		  and	Orp_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000031',
			Err_Mensaj	= 'No se puede dar de alta, existen Ordenes de Pago a Bancos del Extranjero con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Cov_FecVen)
		from ITCOMVEN noholdlock
		where	Cov_FecVen	= @Dfe_Fecha
		  and	Cov_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000032',
			Err_Mensaj	= 'No se puede dar de alta, existen Compra/Venta de Cambios con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Par_Fec24h)
		from ITPARAMS noholdlock
		where	Par_Fec24h	= @Dfe_Fecha
		   or	Par_Fec48h	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000033',
			Err_Mensaj	= 'No se puede dar de alta, existen Parametros de Internacional con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Amp_FecVen)
		from ITPASAMO noholdlock
		where	Amp_FecVen	= @Dfe_Fecha
		  and	Amp_Status	<> @Sta_Cancel) > @Ent_Cero begin
	select	Err_Codigo	= '000034',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de Pasivos con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Validacion de CEDES */
if (select	count(Inv_FecVen)
		from CEINVERS noholdlock
		where	Inv_FecVen	= @Dfe_Fecha
		   or	Inv_FecIni	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000035',
			Err_Mensaj	= 'No se puede dar de alta, existen Inversiones de Certificados de Deposito con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Amo_FecVen)
		from CEAMORTI noholdlock
		where	Amo_FecVen	= @Dfe_Fecha
		   or	Amo_FecIni	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000036',
			Err_Mensaj	= 'No se puede dar de alta, existen Amortizaciones de CEDES con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

if (select	count(Reg_FecCon)
		from CSREGTRA noholdlock
		where	Reg_FecCon	= @Dfe_Fecha) > @Ent_Cero begin
	select	Err_Codigo	= '000037',
			Err_Mensaj	= 'No se puede dar de alta, existen Registro de Transacciones (Corresponsales) con esa fecha ',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end

/* Registra dia festivo */
insert into SODIAFES values(
	@Dfe_Fecha,		@Dfe_Coment,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis, 		@SucOrigen, 	@SucDestino)

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
