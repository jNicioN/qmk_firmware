create procedure SODIAFESPRO (
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


/***************************************************************************
** DESCRIPCION: Proceso de actualización de dias festivos				****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Modificó:	Jovani Duque											****
** Fecha:		29/Dic/2025												****
** Jira Key:	TCPC-22363												****
** Descripción:	Se agrega tabla AUAMORTI,CRPAGAMO & CRAMOHIP y para 	****
				CRAMORTI se cambia filtro a not in (P,Q) 				****
****************************************************************************
** Modificó:	Denisse Castillo										****
** Fecha:		21/Feb/2025												****
** Jira Key:	TCPC-17633												****
** Descripción:	Se agrega tabla AURENMAS								****
****************************************************************************
** Modificó:	Manuel Can Tamay        								****
** Fecha:		25/Sep/2024												****
** Help:		TCELA2-575												****
** Descripcion:	Se agrega tabla ABPRCOAM          				    	****
****************************************************************************
** Modificó:	Julio Cesar Diaz Lopez	 								****
** Fecha:		20/Sep/2024												****
** Help:		TCELTO-9552												****
** Descripcion:	Se actualiza los plazos y fecha de liquidacion de Call	****
**				Money (TECALMON) y Subastas (TESUBAST) del modulo de	****
**				tesoreria al dia siguiente habil si dia festivo es igual****
****************************************************************************
** Modificó:	Julio Cesar Diaz Lopez	 								****
** Fecha:		06/Sep/2024												****
** Help:		TCELTO-9303												****
** Descripcion:	Se actualiza la fecha apertura de Tesoreria (TEPARAMS)	****
**				al dia siguiente habil si el dia festivo es igual.		****
****************************************************************************
** Modificó:	Juan Jose Sandoval Marin								****
** Fecha:		07/Ene/2021												****
** Help:		1381544													****
** Descripcion:	Se elimina begin tran en final del SP					****
****************************************************************************
** Modificó:	Juan Jose Sandoval Marin								****
** Fecha:		02/Oct/2019												****
** Help:		1306640													****
** Descripcion:	Se agrega tabla BEFADOCU								****
****************************************************************************
** Creó:		Andrea Ramirez M.										****
** Fecha:		30/Dic/2017												****
** Help:		1038263													****
****************************************************************************
*/

commit

-- Declaración de Variables
declare	@Status		int,
		@Var_Contin	char(1),
		@Pro_Descri	varchar(50),
		@Pro_Tiempo	int,
		@Fec_Sistem	smalldatetime,
		@Fec_IniPro	datetime,
		@Fec_SiDiHa	smalldatetime,
		@Dfe_DiaFes	smalldatetime,
		@Par_Fecha 	smalldatetime,
		@Par_FecApe smalldatetime

-- Declaración de Constantes
declare	@Ent_Cero	int,
		@Ent_Uno	int,
		@Ent_MenUno	int,
		@Str_No		char(1),
		@Str_Vacio	char(1),
		@Str_Espaci	char(1),
		@Des_IniPro	varchar(33),
		@Des_Actual	char(23),
		@Des_Respal	char(23),
		@Pai_Mexico	char(3),
		
		@Sta_Si		char(1),
		@Sta_F		char(1),
		@Sta_N		char(1),
		@Sta_M		char(1),
		@Sta_A		char(1),
		@Sta_Q		char(1),
		@Sta_V		char(1),
		@Sta_W		char(1),
		@Sta_P		char(1),
		@Sta_R		char(1),
		@Sta_C		char(1),
		@Amo_TipAut	char(1),
		@Amo_TipSeg char(1),
		@Sta_Pagado char(1),
		@Sta_PagCas char(1),
		
		@Tip_IniPro	char(3),
		@Tip_Respa1	char(3),
		@Tip_Remesa	char(3),
		@Tip_Respa2	char(3),
		@Tip_ABAMOR	char(3),
		@Tip_Respa3	char(3),
		@Tip_ABPASA	char(3),
		@Tip_Respa4	char(3),
		@Tip_ABAMOT	char(3),
		@Tip_Respa5	char(3),
		@Tip_FAFACT	char(3),
		@Tip_Respa6	char(3),
		@Tip_FADOCU	char(3),
		@Tip_Respa7	char(3),
		@Tip_CRAMOR	char(3),
		@Tip_Respa8	char(3),
		@Tip_CRCRED	char(3),
		@Tip_Respa9	char(3),
		@Tip_CRREGA	char(3),
		@Tip_CCAMOR	char(3),
		@Tip_Resp10	char(3),
		@Tip_CRINCR	char(3),
		@Tip_Resp11	char(3),
		@Tip_FDINVE	char(3),
		@Tip_Resp12	char(3),
		@Tip_CEINVE	char(3),
		@Tip_Resp13	char(3),
		@Tip_CEAMOR	char(3),
		@Tip_Resp14	char(3),
		@Tip_CSREGT	char(3),
		@Tip_Resp15	char(3),
		@Tip_ININVE	char(3),
		@Tip_Resp16	char(3),
		@Tip_MDINVE	char(3),
		@Tip_Resp17	char(3),
		@Tip_MDINVC	char(3),
		@Tip_Resp18	char(3),
		@Tip_MDPAPE	char(3),
		@Tip_Resp19	char(3),
		@Tip_MDPAPC	char(3),
		@Tip_Resp20	char(3),
		@Tip_MDEMIS	char(3),
		@Tip_Resp21	char(3),
		@Tip_MDEMIC	char(3),
		@Tip_Resp22	char(3),
		@Tip_MDVENI	char(3),
		@Tip_Resp23	char(3),
		@Tip_MDCUST	char(3),
		@Tip_Resp24	char(3),
		@Tip_MDCUSC	char(3),
		@Tip_Resp25	char(3),
		@Tip_MDOPFE	char(3),
		@Tip_Resp26	char(3),
		@Tip_MDDEAL	char(3),
		@Tip_Resp27	char(3),
		@Tip_DEOPER	char(3),
		@Tip_Resp28	char(3),
		@Tip_DEAMOR	char(3),
		@Tip_Resp29	char(3),
		@Tip_TEPAPE	char(3),
		@Tip_Resp30	char(3),
		@Tip_TEEMIS	char(3),
		@Tip_Resp31	char(3),
		@Tip_TEOPFE	char(3),
		@Tip_Resp32	char(3),
		@Tip_TEPAPC	char(3),
		@Tip_Resp33	char(3),
		@Tip_TECURE	char(3),
		@Tip_Resp34	char(3),
		@Tip_ITORDP	char(3),
		@Tip_Resp35	char(3),
		@Tip_ITCOMV	char(3),
		@Tip_Resp36	char(3),
		@Tip_ITPASA	char(3),
		@Tip_Resp38	char(3),
		@Tip_TACORT	char(3),
		@Tip_Resp39	char(3),
		@Tip_TASALV	char(3),
		@Tip_Resp40	char(3),
		@Tip_SGSEGT	char(3),
		@Tip_Resp41	char(3),
		@Tip_SGDOSE	char(3),
		@Tip_Resp42	char(3),
		@Tip_Resp43	char(3),
		@Tip_BEFADO char(3),
		@Tip_SODIFE	char(3),
		@Tip_Resp44	char(3),
		@Tip_TEPARA	char(3),
		@Tip_Resp45	char(3),
		@Tip_TECAMO	char(3),
		@Tip_Resp46	char(3),
		@Tip_TESUBA	char(3),
		@Tip_Resp47	char(3),
		@Tip_ABPRCO char(3),
		@Tip_Resp48	char(3),
		@Tip_AUREMA char(3),
		@Tip_Resp49	char(3),
		@Tip_AUAMOR char(3),
		@Tip_Resp50	char(3),
		@Tip_CRPAGA char(3),
		@Tip_Resp51	char(3),
		@Tip_CRAMOH char(3),

		@Des_SODIFE	varchar(33),
		@Tab_SODIFE	char(8),
		
		@Tab_CHREME	char(8),
		@Tab_ABAMOR	char(8),
		@Tab_ABPASA	char(8),
		@Tab_ABAMOT	char(8),
		
		@Cam_FePaFi	char(10),
		@Cam_CueRem	char(10),
		@Cam_NumChe	char(10),
		@Cam_ABFePa	char(10),
		@Cam_ABAmCr	char(10),
		@Cam_ABAmNu	char(10),
		@Cam_ABPaFe	char(10),
		@Cam_ABPasi	char(10),
		@Cam_ABPaNu	char(10),
		@Cam_ABAmor	char(10),
		@Cam_MovFec	char(10),
		@Cam_MovCre	char(10),
		@Cam_MovAmo	char(10),
		@Cam_CreNum	char(10),
		@Cam_CrFeVe	char(10),
		@Cam_CriFeV	char(10),
		@Cam_CriCre	char(10),
		@Cam_CriInv	char(10),
		@Cam_FaFeVe	char(10),
		@Cam_FaNume	char(10),
		@Cam_FaCont	char(10),
		@Cam_DoFePa	char(10),
		@Cam_DoFact	char(10),
		@Cam_DoNume	char(10),		
		@Cam_InFeIn	char(10),
		@Cam_InFeVe	char(10),
		@Cam_InFeLi	char(10),
		@Cam_InnCon	char(10),
		@Cam_InvNum	char(10),
		@Cam_ReFeCo	char(10),
		@Cam_AmFeIn	char(10),
		@Cam_AmFeVe	char(10),
		@Cam_AmoInv	char(10),
		@Cam_ReNuAu	char(10),
		@Cam_RegFol	char(10),
		@Cam_IcFeIn	char(10),
		@Cam_IcFeVe	char(10),
		@Cam_IcFeLi	char(10),
		@Cam_IncInv	char(10),
		@Cam_IncNum	char(10),
		@Cam_PaFeIn	char(10),
		@Cam_PaFeVe	char(10),
		@Cam_PaFeLi	char(10),
		@Cam_PapNum	char(10),
		@Cam_PcFeIn	char(10),
		@Cam_PcFeVe	char(10),
		@Cam_PcFeLi	char(10),
		@Cam_PacPap	char(10),
		@Cam_PacNum	char(10),
		@Cam_EmFeVe	char(10),
		@Cam_EmiNum	char(10),
		@Cam_EcFeIn	char(10),
		@Cam_EcFeLi	char(10),
		@Cam_EcFeVe	char(10),
		@Cam_EcEmis	char(10),
		@Cam_EcNume	char(10),
		@Cam_ViFeLi	char(10),
		@Cam_ViFeVe	char(10),
		@Cam_VeiNum	char(10),
		@Cam_VeiIns	char(10),
		@Cam_CuFeLi	char(10),
		@Cam_CuFeVe	char(10),
		@Cam_CutNum	char(10),
		@Cam_CcFeIn	char(10),
		@Cam_CcFeVe	char(10),
		@Cam_CcFeLi	char(10),
		@Cam_CucTit	char(10),
		@Cam_CucNum	char(10),
		@Cam_OfFeIn	char(10),
		@Cam_OfvNum	char(10),
		@Cam_DeaNum	char(10),
		@Cam_DeFeLi	char(10),
		@Cam_OpFeLS	char(10),
		@Cam_OpFeLi	char(10),
		@Cam_OpFeVe	char(10),
		@Cam_OpeNum	char(10),
		@Cam_OpeFon	char(10),
		@Cam_AmoOpe	char(10),
		@Cam_AmFeLi	char(10),
		@Cam_TeFeIn	char(10),
		@Cam_TeFeVe	char(10),
		@Cam_TeFeLi	char(10),
		@Cam_OrpTra	char(10),
		@Cam_OrpNum	char(10),
		@Cam_OrFeVe	char(10),
		@Cam_CovNum	char(10),
		@Cam_CvFeVe	char(10),
		@Cam_CovTip	char(10),
		@Cam_PaFe24	char(10),
		@Cam_PaFe48	char(10),
		@Cam_PaFe72	char(10),
		@Cam_PaFe96	char(10),
		@Cam_AmpNum	char(10),
		@Cam_AmPaDo	char(10),
		@Cam_AmFePa	char(10),
		@Cam_ApFeVe	char(10),
		@Cam_CorLin	char(10),
		@Cam_CorNum	char(10),
		@Cam_CoFeVe	char(10),
		@Cam_SavLin	char(10),
		@Cam_SavCor	char(10),
		@Cam_SaFeVe	char(10),
		@Cam_SeNuPo	char(10),
		@Cam_SeFeFi	char(10),
		@Cam_DoFeVe	char(10),
		@Cam_DocPol	char(10),
		@Cam_DocDoc	char(10),
		@Cam_DocCon	char(10),
		@Cam_DocNum	char(10),
		@Cam_PaFeAp	char(10),
		@Cam_ParFec	char(10),
		@Cam_CamNum	char(10),
		@Cam_CamPla	char(10),
		@Cam_CaFeLi	char(10),
		@Cam_SubNum	char(10),
		@Cam_SubPla	char(10),
		@Cam_SuFeLi	char(10),
		@Cam_PrFeDe char(10),
        @Cam_ProCon char(10),
        @Cam_ProAmor char(10),
        @Cam_ReaCon char(10),
		@Cam_FecRen char(10),
		@Cam_ConCre	char(10),
		@Cam_PAPaga	char(10),
		@Cam_PANume	char(10),
		@Cam_PAFePa	char(10),
		@Cam_HICont	char(10),
		@Cam_HINume	char(10),
		@Cam_HIFePa	char(10),


		@Tab_FAFACT	char(8),
		@Tab_FADOCU	char(8),
		@Tab_CRAMOR	char(8),
		@Tab_CRCRED	char(8),
		@Tab_CRREGA	char(8),
		@Tab_CCAMOR	char(8),
		@Tab_CRINCR	char(8),
		@Tab_FDINVE	char(8),
		@Tab_CEINVE	char(8),
		@Tab_CEAMOR	char(8),
		@Tab_CSREGT	char(8),
		@Tab_ININVE	char(8),
		@Tab_MDINVE	char(8),
		@Tab_MDINVC	char(8),
		@Tab_MDPAPE	char(8),
		@Tab_MDPAPC	char(8),
		@Tab_MDEMIS	char(8),
		@Tab_MDEMIC	char(8),
		@Tab_MDVENI	char(8),
		@Tab_MDCUST	char(8),
		@Tab_MDCUSC	char(8),
		@Tab_MDOPFE	char(8),
		@Tab_MDDEAL	char(8),
		@Tab_DEOPER	char(8),
		@Tab_DEAMOR	char(8),
		@Tab_TEPAPE	char(8),
		@Tab_TEEMIS	char(8),
		@Tab_TEOPFE	char(8),
		@Tab_TEPAPC	char(8),
		@Tab_TECURE	char(8),
		@Tab_ITORDP	char(8),
		@Tab_ITCOMV	char(8),
		@Tab_ITPASA	char(8),
		@Tab_TACORT	char(8),
		@Tab_TASALV	char(8),
		@Tab_SGSEGT	char(8),
		@Tab_SGDOSE	char(8),
		@Tab_BEFADO	char(8),
		@Tab_TEPARA	char(8),
		@Tab_TECAMO	char(8),
		@Tab_TESUBA	char(8),
		@Tab_ABPRCO char(8),
		@Tab_AUREMA char(8),
		@Tab_AUAMOR char(8),
		@Tab_CRPAGA char(8),
		@Tab_CRAMOH char(8),
		@Ent_CieOch	smallint

-- Asignación de Constantes
select	@Ent_Cero	= 0,				-- Entero Cero
		@Ent_Uno	= 1,				-- Entero Uno
		@Ent_MenUno	= -1,				-- Entero menos uno
		@Str_No		= 'N',				/* String: No	*/
		@Str_Vacio	= '',				/* String vacio */
		@Str_Espaci	= ' ',				/* Espacio */
		@Des_IniPro	= 'Inicio Proceso de Actualización ',
		@Des_Actual	= 'Actualización de tabla ',
		@Des_Respal	= 'Respaldamos Información de tabla ',
		@Des_SODIFE	= 'Registro del dia SODIAFES',
		@Pai_Mexico	= '001',
		
		@Sta_Si		= 'S',				/* Status: Si	*/
		@Sta_F		= 'F',				/* Estatus: F - Aplicado en firme*/
		@Sta_N		= 'N',				/* Estatus: N - Proceso*/
		@Sta_M		= 'M',				/* Estatus: M - Proceso Castigado*/		
		@Sta_A		= 'A',				/* Estatus: A - Dia habil anterior*/
		@Sta_Q		= 'Q',				/* Estatus: Q - QUIROGRAFARIO*/
		@Sta_V		= 'V',				/* Estatus: V - Vencido */
		@Sta_W		= 'W',				/* Estatus: W - Vencido Castigado*/
		@Sta_P		= 'P',				/* Estatus: P - Pendiente */
		@Sta_R		= 'R',				/* Estatus: R - Registrado*/
		@Sta_C		= 'C',				/* Estatus: C - Cancelado */
		--@Amo_TipAut	= 'A',				/* Tipo de Amortizacion: A - Auto */
		--@Amo_TipSeg	= 'S',				/* Tipo de Amortizacion: S - Seguro */
		@Sta_Pagado = 'P',				/* Estatus Credito: P - Pagado */
		@Sta_PagCas = 'Q',				/* Estatus Credito: Q - Pagado Castigado */

		@Tip_IniPro	= '000',			-- Inicio del Proceso de Actualizacion
		@Tip_SODIFE	= '001',			-- Registro del dia SODIAFES
		@Tip_Respa1	= '002',			-- Respaldo CHREMESA
		@Tip_Remesa	= '003',			-- Actualización CHREMESA
		@Tip_Respa2	= '004',			-- Respaldo ABAMORTI
		@Tip_ABAMOR	= '005',			-- Actualización ABAMORTI
		@Tip_Respa3	= '006',			-- Respaldo ABPASAMO
		@Tip_ABPASA	= '007',			-- Actualización ABPASAMO
		@Tip_Respa4	= '008',			-- Respaldo ABAMOTCA
		@Tip_ABAMOT	= '009',			-- Actualización ABAMOTCA
		@Tip_Respa5	= '010',			-- Respaldo FAFACTOR
		@Tip_FAFACT	= '011',			-- Actualización FAFACTOR
		@Tip_Respa6	= '012',			-- Respaldo FADOCUME
		@Tip_FADOCU	= '013',			-- Actualización FADOCUME
		@Tip_Respa7	= '014',			-- Respaldo CRAMORTI
		@Tip_CRAMOR	= '015',			-- Actualización CRAMORTI
		@Tip_Respa8	= '016',			-- Respaldo CRCREDIT
		@Tip_CRCRED	= '017',			-- Actualización CRCREDIT
		@Tip_Respa9	= '018',			-- Respaldo CRREGAMO
		@Tip_CRREGA	= '019',			-- Actualización CRREGAMO
		@Tip_Resp10	= '020',			-- Respaldo CCAMORTI
		@Tip_CCAMOR	= '021',			-- Actualización CCAMORTI
		@Tip_Resp11	= '022',			-- Respaldo CRINVCRE
		@Tip_CRINCR	= '023',			-- Actualización CRINVCRE
		@Tip_Resp12	= '024',			-- Respaldo FDINVERS
		@Tip_FDINVE	= '025',			-- Actualización FDINVERS
		@Tip_Resp13	= '026',			-- Respaldo CEAMORTI
		@Tip_CEAMOR	= '027',			-- Actualización CEAMORTI
		@Tip_Resp14	= '028',			-- Respaldo CEINVERS
		@Tip_CEINVE	= '029',			-- Actualización CEINVERS
		@Tip_Resp15	= '030',			-- Respaldo CSREGTRA
		@Tip_CSREGT	= '031',			-- Actualización CSREGTRA
		@Tip_Resp16	= '032',			-- Respaldo ININVERS
		@Tip_ININVE	= '033',			-- Actualización ININVERS
		@Tip_Resp17	= '034',			-- Respaldo MDINVERS
		@Tip_MDINVE	= '035',			-- Actualización MDINVERS
		@Tip_Resp18	= '036',			-- Respaldo MDINVCUP
		@Tip_MDINVC	= '037',			-- Actualización MDINVCUP
		@Tip_Resp19	= '038',			-- Respaldo MDPAPEL
		@Tip_MDPAPE	= '039',			-- Actualización MDPAPEL
		@Tip_Resp20	= '040',			-- Respaldo MDPAPCUP
		@Tip_MDPAPC	= '041',			-- Actualización MDPAPCUP
		@Tip_Resp21	= '042',			-- Respaldo MDEMISIO
		@Tip_MDEMIS	= '043',			-- Actualización MDEMISIO
		@Tip_Resp22	= '044',			-- Respaldo MDEMICUP
		@Tip_MDEMIC	= '045',			-- Actualización MDEMICUP
		@Tip_Resp23	= '046',			-- Respaldo MDVENINS
		@Tip_MDVENI	= '047',			-- Actualización MDVENINS
		@Tip_Resp24	= '048',			-- Respaldo MDCUSTIT
		@Tip_MDCUST	= '049',			-- Actualización MDCUSTIT
		@Tip_Resp25	= '050',			-- Respaldo MDCUSCUP
		@Tip_MDCUSC	= '051',			-- Actualización MDCUSCUP
		@Tip_Resp26	= '052',			-- Respaldo MDOPFEVA
		@Tip_MDOPFE	= '053',			-- Actualización MDOPFEVA
		@Tip_Resp27	= '054',			-- Respaldo MDDEAL
		@Tip_MDDEAL	= '055',			-- Actualización MDDEAL
		@Tip_Resp28	= '056',			-- Respaldo DEOPOERAC
		@Tip_DEOPER	= '057',			-- Actualización DEOPERAC
		@Tip_Resp29	= '058',			-- Respaldo DEAMORTI
		@Tip_DEAMOR	= '059',			-- Actualización DEAMORTI
		@Tip_Resp30	= '060',			-- Respaldo TEPAPEL
		@Tip_TEPAPE	= '061',			-- Actualización TEPAPEL
		@Tip_Resp31	= '062',			-- Respaldo TEEMISO
		@Tip_TEEMIS	= '063',			-- Actualización TEEMISIO
		@Tip_Resp32	= '064',			-- Respaldo TEOPFEVA
		@Tip_TEOPFE	= '065',			-- Actualización TEOPFEVA
		@Tip_Resp33	= '066',			-- Respaldo TEPAPCUP
		@Tip_TEPAPC	= '067',			-- Actualización TEPAPCUP
		@Tip_Resp34	= '068',			-- Respaldo TECUREMO
		@Tip_TECURE	= '069',			-- Actualización TECUREMO
		@Tip_Resp35	= '070',			-- Respaldo ITORDPAG
		@Tip_ITORDP	= '071',			-- Actualización ITORDPAG
		@Tip_Resp36	= '072',			-- Respaldo ITCOMVEN
		@Tip_ITCOMV	= '073',			-- Actualización ITCOMVEN
		@Tip_Resp38	= '074',			-- Respaldo ITPASAMO
		@Tip_ITPASA	= '075',			-- Actualización ITPASAMO
		@Tip_Resp39	= '076',			-- Respaldo TACORTCR
		@Tip_TACORT	= '077',			-- Actualización TACORTCR
		@Tip_Resp40	= '078',			-- Respaldo TASALVEN
		@Tip_TASALV	= '079',			-- Actualización TASALVEN
		@Tip_Resp41	= '080',			-- Respaldo SGSEGTEL
		@Tip_SGSEGT	= '081',			-- Actualización SGSEGTEL
		@Tip_Resp42	= '082',			-- Respaldo SGDOSETE
		@Tip_SGDOSE	= '083',			-- Actualización SGDOSETE	
		@Tip_Resp43	= '084',			-- Respaldo BEFADOCU
		@Tip_BEFADO	= '085',			-- Actualización BEFADOCU	
		@Tip_Resp44	= '086',			-- Respaldo TEPARMS
		@Tip_TEPARA	= '087',			-- Actualización TEPARMS
		@Tip_Resp45	= '088',			-- Respaldo TECALMON
		@Tip_TECAMO	= '089',			-- Actualización TECALMON
		@Tip_Resp46	= '090',			-- Respaldo TESUBAST
		@Tip_TESUBA	= '091',			-- Actualización TESUBAST
		@Tip_Resp47	= '092',			-- Respaldo ABPRCOAM
		@Tip_ABPRCO	= '093',			-- Actualización ABPRCOAM		
		@Tip_Resp48	= '094',			-- Respaldo AURENMAS
		@Tip_AUREMA	= '095',			-- Actualización AURENMAS	
		@Tip_Resp49	= '096',			-- Respaldo AUAMORTI
		@Tip_AUAMOR	= '097',			-- Actualización AUAMORTI
		@Tip_Resp50	= '098',			-- Respaldo CRPAGAMO
		@Tip_CRPAGA	= '099',			-- Actualización CRPAGAMO
		@Tip_Resp51	= '100',			-- Respaldo CRAMOHIP
		@Tip_CRAMOH	= '101',			-- Actualización CRAMOHIP

		
		@Tab_CHREME	= 'CHREMESA',
		@Tab_ABAMOR	= 'ABAMORTI',
		@Tab_ABPASA	= 'ABPASAMO',
		@Tab_ABAMOT	= 'ABAMOTCA',
		@Tab_FAFACT	= 'FAFACTOR',
		@Tab_FADOCU	= 'FADOCUME',
		@Tab_CRAMOR	= 'CRAMORTI',
		@Tab_CRCRED	= 'CRCREDIT',
		@Tab_CRREGA	= 'CRREGAMO',
		@Tab_CCAMOR	= 'CCAMORTI',
		@Tab_CRINCR	= 'CRINVCRE',
		@Tab_FDINVE	= 'FDINVERS',
		@Tab_CEINVE	= 'CEINVERS',
		@Tab_CEAMOR	= 'CEAMORTI',
		@Tab_CSREGT	= 'CSREGTRA',
		@Tab_ININVE	= 'ININVERS',
		@Tab_MDINVE	= 'MDINVERS',
		@Tab_MDINVC	= 'MDINVCUP',
		@Tab_MDPAPE	= 'MDPAPEL',
		@Tab_MDPAPC	= 'MDPAPCUP',
		@Tab_MDEMIS	= 'MDEMISIO',
		@Tab_MDEMIC	= 'MDEMICUP',
		@Tab_MDVENI	= 'MDVENINS',
		@Tab_MDCUST	= 'MDCUSTIT',
		@Tab_MDCUSC	= 'MDCUSCUP',
		@Tab_MDOPFE	= 'MDOPFEVA',
		@Tab_MDDEAL	= 'MDDEAL',
		@Tab_DEOPER	= 'DEOPERAC',
		@Tab_DEAMOR	= 'DEAMORTI',
		@Tab_TEPAPE	= 'TEPAPEL',
		@Tab_TEEMIS	= 'TEEMISIO',
		@Tab_TEOPFE	= 'TEOPFEVA',
		@Tab_TEPAPC	= 'TEPAPCUP',
		@Tab_TECURE	= 'TECUREMO',
		@Tab_ITORDP	= 'ITORDPAG',
		@Tab_ITCOMV	= 'ITCOMVEN',
		@Tab_ITPASA	= 'ITPASAMO',
		@Tab_TACORT	= 'TACORTCR',
		@Tab_TASALV	= 'TASALVEN',
		@Tab_SGSEGT	= 'SGSEGTEL',
		@Tab_SGDOSE	= 'SGDOSETE',
		@Tab_BEFADO	= 'BEFADOCU',
		@Tab_TEPARA	= 'TEPARAMS',
		@Tab_TECAMO	= 'TECALMON',
		@Tab_TESUBA	= 'TESUBAST',
		@Tab_ABPRCO	= 'ABPRCOAM',
		@Tab_SODIFE	= 'SODIAFES',
		@Tab_AUREMA	= 'AURENMAS',
		@Tab_AUAMOR	= 'AUAMORTI',
		@Tab_CRPAGA	= 'CRPAGAMO',
		@Tab_CRAMOH	= 'CRAMOHIP',

		@Cam_FePaFi	= 'Rem_FePaFi',
		@Cam_CueRem	= 'Rem_CueRem',
		@Cam_NumChe	= 'Rem_NumChe',
		@Cam_ABFePa	= 'Amo_FecPag',
		@Cam_ABAmCr	= 'Amo_Credit',
		@Cam_ABAmNu	= 'Amo_Numero',
		@Cam_ABPaFe	= 'Paa_FecPag',
		@Cam_ABPasi	= 'Paa_Pasivo',
		@Cam_ABPaNu	= 'Paa_Numero',
		@Cam_ABAmor	= 'Amo_Amorti',
		@Cam_MovFec	= 'Mov_Fecha',
		@Cam_MovCre	= 'Mov_Credit',
		@Cam_MovAmo	= 'Mov_Amorti',
		@Cam_CreNum	= 'Cre_Numero',
		@Cam_CrFeVe	= 'Cre_FecVen',
		@Cam_CriFeV	= 'Cri_FecVen',
		@Cam_CriCre	= 'Cri_Credit',
		@Cam_CriInv	= 'Cri_Invers',
		@Cam_FaFeVe	= 'Fac_FecVen',
		@Cam_FaNume	= 'Fac_Numero',
		@Cam_FaCont	= 'Fac_Contra',
		@Cam_DoFePa	= 'Doc_FecPag',
		@Cam_DoFact	= 'Doc_Factor',
		@Cam_DoNume	= 'Doc_Numero',
		@Cam_InFeIn	= 'Inv_FecIni',
		@Cam_InFeVe	= 'Inv_FecVen',
		@Cam_InFeLi	= 'Inv_FecLiq',
		@Cam_InnCon	= 'Inv_Contra',
		@Cam_InvNum	= 'Inv_Numero',
		@Cam_ReFeCo	= 'Reg_FecCon',
		@Cam_AmFeIn	= 'Amo_FecIni',
		@Cam_AmFeVe	= 'Amo_FecVen',
		@Cam_AmoInv	= 'Amo_Invers',
		@Cam_ReNuAu	= 'Reg_NumAut',
		@Cam_RegFol	= 'Reg_Folio',
		@Cam_IcFeIn	= 'Inc_FecIni',
		@Cam_IcFeVe	= 'Inc_FecVen',
		@Cam_IcFeLi	= 'Inc_FecLiq',
		@Cam_IncInv	= 'Inc_Invers',
		@Cam_IncNum	= 'Inc_Numero',
		@Cam_PaFeIn	= 'Pap_FecIni',
		@Cam_PaFeVe	= 'Pap_FecVen',
		@Cam_PaFeLi	= 'Pap_FecLiq',
		@Cam_PapNum	= 'Pap_Numero',
		@Cam_PcFeIn	= 'Pac_FecIni',
		@Cam_PcFeVe	= 'Pac_FecVen',
		@Cam_PcFeLi	= 'Pac_FecLiq',
		@Cam_PacPap	= 'Pac_Papel',
		@Cam_PacNum	= 'Pac_Numero',
		@Cam_EmFeVe	= 'Emi_FecVen',
		@Cam_EmiNum	= 'Emi_Numero',
		@Cam_EcFeIn	= 'Emc_FecIni',
		@Cam_EcFeLi	= 'Emc_FecLiq',
		@Cam_EcFeVe	= 'Emc_FecVen',
		@Cam_EcEmis	= 'Emc_Emisio',
		@Cam_EcNume	= 'Emc_Numero',
		@Cam_ViFeLi = 'Vei_FecLiq',
		@Cam_ViFeVe = 'Vei_FecVen',
		@Cam_VeiNum	= 'Vei_Numero',
		@Cam_VeiIns	= 'Vei_Instit',
		@Cam_CuFeLi	= 'Cut_FecLiq',
		@Cam_CuFeVe	= 'Cut_FecVen',
		@Cam_CutNum	= 'Cut_Numero',
		@Cam_CcFeIn = 'Cuc_FecIni',
		@Cam_CcFeVe	= 'Cuc_FecVen',
		@Cam_CcFeLi	= 'Cuc_FecLiq',
		@Cam_CucTit	= 'Cuc_CusTit',
		@Cam_CucNum	= 'Cuc_Numero',
		@Cam_OfFeIn	= 'Ofv_FecIni',
		@Cam_OfvNum	= 'Ofv_Numero',
		@Cam_DeaNum	= 'Dea_Numero',
		@Cam_DeFeLi	= 'Dea_FecLiq',
		@Cam_OpFeLS	= 'Ope_FeLiSV',
		@Cam_OpFeLi	= 'Ope_FecLiq',
		@Cam_OpFeVe	= 'Ope_FecVen',
		@Cam_OpeNum	= 'Ope_Numero',
		@Cam_OpeFon	= 'Ope_Fondo',
		@Cam_AmoOpe	= 'Amo_Operac',
		@Cam_AmFeLi	= 'Amo_FecLiq',
		@Cam_TeFeIn	= 'Crm_FecIni',
		@Cam_TeFeVe	= 'Crm_FecVen',
		@Cam_TeFeLi	= 'Crm_FecLiq',
		@Cam_OrpTra	= 'Orp_Transa',
		@Cam_OrpNum	= 'Orp_Numero',
		@Cam_OrFeVe	= 'Orp_FecVen',
		@Cam_CovNum	= 'Cov_Numero',
		@Cam_CvFeVe	= 'Cov_FecVen',
		@Cam_CovTip	= 'Cov_Tipo',
		@Cam_PaFe24	= 'Par_Fec24h',
		@Cam_PaFe48	= 'Par_Fec48h',
		@Cam_PaFe72	= 'Par_Fec72h',
		@Cam_PaFe96	= 'Par_Fec96h',
		@Cam_AmpNum	= 'Amp_Numero',
		@Cam_AmPaDo	= 'Amp_PasDol',
		@Cam_AmFePa	= 'Amp_FecPag',
		@Cam_ApFeVe	= 'Amp_FecVen',
		@Cam_CorNum	= 'Cor_Numero',
		@Cam_CorLin	= 'Cor_Linea',
		@Cam_CoFeVe	= 'Cor_FecVen',
		@Cam_SavLin	= 'Sav_Linea',
		@Cam_SavCor	= 'Sav_Corte',
		@Cam_SaFeVe	= 'Sav_FecVen',
		@Cam_SeNuPo	= 'Seg_NumPol',
		@Cam_SeFeFi	= 'Seg_FecFin',
		@Cam_DoFeVe	= 'Doc_FecVen',
		@Cam_DocPol	= 'Doc_Poliza',
		@Cam_DocDoc	= 'Doc_Docume',
		@Cam_DocCon = 'Doc_Contra',
		@Cam_DocNum	= 'Doc_Numero',
		@Cam_PaFeAp = 'Par_FecApe',
		@Cam_ParFec = 'Par_Fecha',
		@Cam_CamNum = 'Cam_Numero',
		@Cam_CamPla = 'Cam_Plazo',
		@Cam_CaFeLi = 'Cam_FecLiq',
		@Cam_SubNum = 'Sub_Numero',
		@Cam_SubPla = 'Sub_Plazo',
		@Cam_SuFeLi = 'Sub_FecLiq',
		@Cam_PrFeDe = 'Pro_FePrDe',
        @Cam_ProCon = 'Pro_Consec',
        @Cam_ProAmor = 'Pro_Amorti',
        @Cam_ReaCon = 'Rea_Contra',
		@Cam_FecRen = 'Rea_FecRen',
		@Cam_ConCre = 'Amo_Contra',
		@Cam_PAPaga	= 'Pam_Pagare',
		@Cam_PANume	= 'Pam_Numero',
		@Cam_PAFePa	= 'Pam_FecPag',
		@Cam_HICont	= 'Amh_Contra',
		@Cam_HINume	= 'Amh_Numero',
		@Cam_HIFePa	= 'Amh_FecPag',
		@Ent_CieOch = 108

select	@Fec_IniPro	= getdate(),
		@Fec_SiDiHa	= @Dfe_Fecha

exec SOSIGFECHAB 
	@Fecha		= @Fec_SiDiHa output, 
	@NumDia		= @Ent_Uno, 
	@FinSem		= @Str_No, 
	@Salida_Fox	= @Str_No

/*Inicio de proceso*/

exec @Status = SOBIDIFECON
	@Tip_IniPro,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	select	@Pro_Descri	= @Des_IniPro + @Str_Espaci + ltrim(rtrim(convert(char,getdate(),@Ent_CieOch))),
			@Fec_Sistem	= getdate(),
			@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_IniPro,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
end

/** Actualización de SODIAFES y SODIAINH **/
exec @Status = SOBIDIFECON
	@Tip_SODIFE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_SODIFE,
			@Fec_IniPro	= getdate()
			
	select	@Dfe_DiaFes = Dfe_Fecha
	from SODIAFES noholdlock
	where	Dfe_Fecha	=	@Dfe_Fecha
			
	if isnull(@Dfe_DiaFes, @Str_Vacio) = @Str_Vacio begin
		/* Registra dia festivo */
		insert into SODIAFES values(
			@Dfe_Fecha,		@Dfe_Coment,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis, 		@SucOrigen, 	@SucDestino)
		
	end
	
	select 	@Dfe_DiaFes	= @Str_Vacio
	
	select	@Dfe_DiaFes = Din_Fecha
	from SODIAINH noholdlock
	where	Din_Fecha	= @Dfe_Fecha
	  and	Din_Pais	= @Pai_Mexico
			
	if isnull(@Dfe_DiaFes, @Str_Vacio) = @Str_Vacio begin
		/* Registra dia festivo */
		insert into SODIAINH values(
			@Pai_Mexico,	@Dfe_Fecha,		@Dfe_Coment,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis, 		@SucOrigen, 	@SucDestino)
		
	end

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_SODIFE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end
/** Respaldamos de REMESAS **/
exec @Status = SOBIDIFECON
	@Tip_Respa1,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CHREME,
			@Fec_IniPro	= getdate()
	
	-- respaldamos
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CHREME, 	@Cam_CueRem,	Rem_CueRem,		@Cam_NumChe,	Rem_NumChe,
			@Cam_FePaFi,	Rem_FePaFi,		@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CHREMESA noholdlock
	where Rem_FePaFi = @Dfe_Fecha
	  and Rem_Status <> @Sta_F
	
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))
	
	exec @Status = SOBIDIFEALT
		@Tip_Respa1,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de REMESAS **/
exec @Status = SOBIDIFECON
	@Tip_Remesa,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CHREME,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	update CHREMESA set
		Rem_FePaFi	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Rem_FePaFi = @Dfe_Fecha
	  and Rem_Status <> @Sta_F
	
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))
	
	exec @Status = SOBIDIFEALT
		@Tip_Remesa,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ABAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Respa2,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ABAMOR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ABAMOR, 	@Cam_ABAmCr,	Amo_Credit,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_ABFePa,	Amo_FecPag,		@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ABAMORTI noholdlock
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa2,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ABAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_ABAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ABAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ABAMORTI set
		Amo_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ABAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ABPASAMO  **/
exec @Status = SOBIDIFECON
	@Tip_Respa3,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ABPASA,
			@Fec_IniPro	= getdate()
	
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ABPASA, 	@Cam_ABPasi,	Paa_Pasivo,		@Cam_ABPaNu,	Paa_Numero,
			@Cam_ABPaFe,	Paa_FecPag,		@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ABPASAMO noholdlock
	where Paa_FecPag = @Dfe_Fecha
	  and Paa_Status = @Sta_N	
	
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))
			
	exec @Status = SOBIDIFEALT
		@Tip_Respa3,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ABPASAMO  **/
exec @Status = SOBIDIFECON
	@Tip_ABPASA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ABPASA,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	update ABPASAMO set
		Paa_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Paa_FecPag = @Dfe_Fecha
	  and Paa_Status = @Sta_N
	
	
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))
			
	exec @Status = SOBIDIFEALT
		@Tip_ABPASA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ABAMOTCA **/
exec @Status = SOBIDIFECON
	@Tip_Respa4,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ABAMOT,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ABAMOT, 	@Cam_ABAmCr,	Amo_Credit,		@Cam_ABAmor,	Amo_Amorti,
			@Cam_ABFePa,	Amo_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ABAMOTCA noholdlock
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa4,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ABAMOTCA **/
exec @Status = SOBIDIFECON
	@Tip_ABAMOT,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ABAMOT,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ABAMOTCA set
		Amo_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ABAMOT,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de FAFACTOR **/
exec @Status = SOBIDIFECON
	@Tip_Respa5,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_FAFACT,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_FAFACT, 	@Cam_FaNume,	Fac_Numero,		@Cam_FaCont,	Fac_Contra,
			@Cam_FaFeVe,	Fac_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from FAFACTOR noholdlock
	where Fac_FecVen = @Dfe_Fecha
	  and Fac_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa5,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de FAFACTOR **/
exec @Status = SOBIDIFECON
	@Tip_FAFACT,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_FAFACT,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update FAFACTOR set
		Fac_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Fac_FecVen = @Dfe_Fecha
	  and Fac_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_FAFACT,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de FADOCUME **/
exec @Status = SOBIDIFECON
	@Tip_Respa6,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_FADOCU,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE
	select	@Tab_FADOCU, 	@Cam_DoFact,	Doc_Factor,		@Cam_DoNume,	Doc_Numero,
			@Cam_DoFePa,	Doc_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from FADOCUME noholdlock
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N
	  
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa6,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de FADOCUME **/
exec @Status = SOBIDIFECON
	@Tip_FADOCU,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_FADOCU,
			@Fec_IniPro	= getdate()
			
	-- Actualizamos
	Update FADOCUME set
		Doc_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_FADOCU,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CRAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Respa7,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRAMOR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CRAMOR, 	@Cam_ABAmCr,	Amo_Credit,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_ABFePa,	Amo_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRAMORTI noholdlock
		 inner join CRCREDIT noholdlock on Cre_Numero = Amo_Credit and Cre_AjDiPa <> @Sta_A
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status not in (@Sta_Pagado, @Sta_PagCas)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa7,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CRAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_CRAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CRAMORTI set
		Amo_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from CRAMORTI noholdlock
		 inner join CRCREDIT noholdlock on Cre_Numero = Amo_Credit and Cre_AjDiPa <> @Sta_A
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status not in (@Sta_Pagado, @Sta_PagCas)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CRCREDIT **/
exec @Status = SOBIDIFECON
	@Tip_Respa8,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRCRED,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE
	select	@Tab_CRCRED, 	@Cam_CreNum,	Cre_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_CrFeVe,	Cre_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRCREDIT noholdlock
	where Cre_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa8,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CRCREDIT **/
exec @Status = SOBIDIFECON
	@Tip_CRCRED,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRCRED,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CRCREDIT set
		Cre_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cre_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRCRED,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CRREGAMO **/
exec @Status = SOBIDIFECON
	@Tip_Respa9,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRREGA,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CRREGA, 	@Cam_ABAmCr,	Amo_Credit,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_ABFePa,	Amo_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRREGAMO noholdlock
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Respa9,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CRREGAMO **/
exec @Status = SOBIDIFECON
	@Tip_CRREGA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRREGA,
			@Fec_IniPro	= getdate()
			
	-- Actualizamos
	Update CRREGAMO set
		Amo_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRREGA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CCAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Resp10,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CCAMOR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CCAMOR, 	@Cam_ABAmCr,	Amo_Credit,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_ABFePa,	Amo_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CCAMORTI noholdlock
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_V, @Sta_W, @Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp10,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CCAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_CCAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CCAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CCAMORTI set
		Amo_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecPag = @Dfe_Fecha
	  and Amo_Status in (@Sta_V, @Sta_W, @Sta_N, @Sta_M)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CCAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CRINVCRE **/
exec @Status = SOBIDIFECON
	@Tip_Resp11,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRINCR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CRINCR, 	@Cam_CriCre,	Cri_Credit,		@Cam_CriInv,	Cri_Invers,
			@Cam_CriFeV,	Cri_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRINVCRE noholdlock
	where Cri_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp11,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CRINVCRE **/
exec @Status = SOBIDIFECON
	@Tip_CRINCR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRINCR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CRINVCRE set
		Cri_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cri_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRINCR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de FDINVERS **/
exec @Status = SOBIDIFECON
	@Tip_Resp12,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_FDINVE,
			@Fec_IniPro	= getdate()

	-- Respaldo Inv_FecIni
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_FDINVE, 	@Cam_InnCon,	Inv_Contra,		@Cam_InvNum,	Inv_Numero,
			@Cam_InFeIn,	Inv_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from FDINVERS noholdlock
	where Inv_FecIni = @Dfe_Fecha
	  and Inv_Status in (@Sta_N, @Sta_M, @Sta_P, @Sta_R)

	-- Respaldo Inv_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_FDINVE, 	@Cam_InnCon,	Inv_Contra,		@Cam_InvNum,	Inv_Numero,
			@Cam_InFeVe,	Inv_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from FDINVERS noholdlock
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status in (@Sta_N, @Sta_M, @Sta_P, @Sta_R)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp12,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de FDINVERS **/
exec @Status = SOBIDIFECON
	@Tip_FDINVE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_FDINVE,
			@Fec_IniPro	= getdate()

	-- Actualizamos Inv_FecIni
	Update FDINVERS set
		Inv_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecIni = @Dfe_Fecha
	  and Inv_Status in (@Sta_N, @Sta_M, @Sta_P, @Sta_R)

	-- Actualizamos Inv_FecVen
	Update FDINVERS set
		Inv_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status in (@Sta_N, @Sta_M, @Sta_P, @Sta_R)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_FDINVE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldo de CEAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Resp13,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CEAMOR,
			@Fec_IniPro	= getdate()
			
	-- Respaldo Amo_FecIni
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CEAMOR, 	@Cam_AmoInv,	Amo_Invers,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_AmFeIn,	Amo_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CEAMORTI noholdlock
	where Amo_FecIni = @Dfe_Fecha
	  and Amo_Status = @Sta_N
			
	-- Respaldo Amo_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CEAMOR, 	@Cam_AmoInv,	Amo_Invers,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_AmFeVe,	Amo_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CEAMORTI noholdlock
	where Amo_FecVen = @Dfe_Fecha
	  and Amo_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp13,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CEAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_CEAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CEAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos Amo_FecIni
	Update CEAMORTI set
		Amo_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecIni = @Dfe_Fecha
	  and Amo_Status = @Sta_N
	
	-- Actualizamos Amo_FecVen
	Update CEAMORTI set
		Amo_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecVen = @Dfe_Fecha
	  and Amo_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CEAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CEINVERS **/
exec @Status = SOBIDIFECON
	@Tip_Resp14,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CEINVE,
			@Fec_IniPro	= getdate()

	-- Respaldo Inv_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CEINVE, 	@Cam_InvNum,	Inv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_InFeVe,	Inv_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CEINVERS noholdlock
	where Inv_FecVen = @Dfe_Fecha
	
	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp14,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CEINVERS **/
exec @Status = SOBIDIFECON
	@Tip_CEINVE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CEINVE,
			@Fec_IniPro	= getdate()

	-- Actualizamos Inv_FecVen
	Update CEINVERS set
		Inv_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CEINVE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de CSREGTRA **/
exec @Status = SOBIDIFECON
	@Tip_Resp15,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CSREGT,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CSREGT, 	@Cam_ReNuAu,	Reg_NumAut,		@Cam_RegFol,	Reg_Folio,
			@Cam_ReFeCo,	Reg_FecCon, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CSREGTRA noholdlock
	where Reg_FecCon = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp15,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de CSREGTRA **/
exec @Status = SOBIDIFECON
	@Tip_CSREGT,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CSREGT,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CSREGTRA set
		Reg_FecCon	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Reg_FecCon = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CSREGT,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end
/** Respaldamos de ININVERS **/
exec @Status = SOBIDIFECON
	@Tip_Resp16,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ININVE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ININVE, 	@Cam_InvNum,	Inv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_InFeVe,	Inv_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ININVERS noholdlock
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp16,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ININVERS **/
exec @Status = SOBIDIFECON
	@Tip_ININVE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ININVE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ININVERS set
		Inv_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ININVE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDINVERS **/
exec @Status = SOBIDIFECON
	@Tip_Resp17,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDINVE,
			@Fec_IniPro	= getdate()

	-- Respaldo  Inv_FecIni
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVE, 	@Cam_InvNum,	Inv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_InFeIn,	Inv_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVERS noholdlock
	where Inv_FecIni = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	-- Respaldo Inv_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVE, 	@Cam_InvNum,	Inv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_InFeVe,	Inv_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVERS noholdlock
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	-- Respaldo Inv_FecLiq
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVE, 	@Cam_InvNum,	Inv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_InFeLi,	Inv_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVERS noholdlock
	where Inv_FecLiq = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp17,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDINVERS **/
exec @Status = SOBIDIFECON
	@Tip_MDINVE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDINVE,
			@Fec_IniPro	= getdate()

	-- Actualizamos Inv_FecIni
	Update MDINVERS set
		Inv_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecIni = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	-- Actualizamos Inv_FecVen
	Update MDINVERS set
		Inv_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecVen = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	-- Actualizamos Inv_FecVen
	Update MDINVERS set
		Inv_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inv_FecLiq = @Dfe_Fecha
	  and Inv_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDINVE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDINVCUP **/
exec @Status = SOBIDIFECON
	@Tip_Resp18,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDINVC,
			@Fec_IniPro	= getdate()
			
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVC,	@Cam_IncInv,	Inc_Invers,		@Cam_IncNum,	Inc_Numero,	
			@Cam_IcFeIn,	Inc_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVCUP noholdlock
	where Inc_FecIni = @Dfe_Fecha
			
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVC, 	@Cam_IncInv,	Inc_Invers,		@Cam_IncNum,	Inc_Numero,
			@Cam_IcFeVe,	Inc_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVCUP noholdlock
	where Inc_FecVen = @Dfe_Fecha
			
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDINVC, 	@Cam_IncInv,	Inc_Invers,		@Cam_IncNum,	Inc_Numero,
			@Cam_IcFeLi,	Inc_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDINVCUP noholdlock
	where Inc_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp18,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDINVCUP **/
exec @Status = SOBIDIFECON
	@Tip_MDINVC,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDINVC,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDINVCUP set
		Inc_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inc_FecIni = @Dfe_Fecha

	-- Actualizamos
	Update MDINVCUP set
		Inc_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inc_FecVen = @Dfe_Fecha

	-- Actualizamos
	Update MDINVCUP set
		Inc_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Inc_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDINVC,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDPAPEL **/
exec @Status = SOBIDIFECON
	@Tip_Resp19,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDPAPE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDPAPE, 	@Cam_PapNum,	Pap_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_PaFeIn,	Pap_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPEL noholdlock
	where Pap_FecIni = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDPAPE, 	@Cam_PapNum,	Pap_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_PaFeVe,	Pap_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPEL noholdlock
	where Pap_FecVen = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDPAPE, 	@Cam_PapNum,	Pap_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_PaFeLi,	Pap_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPEL noholdlock
	where Pap_FecLiq = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp19,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDPAPEL **/
exec @Status = SOBIDIFECON
	@Tip_MDPAPE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDPAPE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDPAPEL set
		Pap_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pap_FecIni = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	-- Actualizamos
	Update MDPAPEL set
		Pap_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pap_FecVen = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	-- Actualizamos
	Update MDPAPEL set
		Pap_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pap_FecLiq = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDPAPE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDPAPCUP **/
exec @Status = SOBIDIFECON
	@Tip_Resp20,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDPAPC,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDPAPC, 	@Cam_PacPap,	Pac_Papel,		@Cam_PacNum,	Pac_Numero,
			@Cam_PcFeIn,	Pac_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPCUP noholdlock
	where Pac_FecIni = @Dfe_Fecha

	-- Respaldo Pac_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDPAPC, 	@Cam_PacPap,	Pac_Papel,		@Cam_PacNum,	Pac_Numero,
			@Cam_PcFeVe,	Pac_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPCUP noholdlock
	where Pac_FecVen = @Dfe_Fecha

	-- Respaldo @Cam_PcFeLi
	insert into SOREDIFE
	select	@Tab_MDPAPC, 	@Cam_PacPap,	Pac_Papel,		@Cam_PacNum,	Pac_Numero,
			@Cam_PcFeLi,	Pac_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDPAPCUP noholdlock
	where Pac_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp20,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDPAPCUP **/
exec @Status = SOBIDIFECON
	@Tip_MDPAPC,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDPAPC,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDPAPCUP set
		Pac_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pac_FecIni = @Dfe_Fecha

	-- Actualizamos Pac_FecVen
	Update MDPAPCUP set
		Pac_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pac_FecVen = @Dfe_Fecha

	-- Actualizamos Pac_FecVen
	Update MDPAPCUP set
		Pac_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pac_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDPAPC,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDEMISIO **/
exec @Status = SOBIDIFECON
	@Tip_Resp21,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDEMIS,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDEMIS, 	@Cam_EmiNum,	Emi_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_EmFeVe,	Emi_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDEMISIO noholdlock
	where Emi_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp21,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDEMISIO **/
exec @Status = SOBIDIFECON
	@Tip_MDEMIS,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDEMIS,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDEMISIO set
		Emi_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Emi_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDEMIS,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDEMICUP **/
exec @Status = SOBIDIFECON
	@Tip_Resp22,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDEMIC,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDEMIC, 	@Cam_EcEmis,	Emc_Emisio,		@Cam_EcNume,	Emc_Numero,
			@Cam_EcFeIn,	Emc_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDEMICUP noholdlock
	where Emc_FecIni = @Dfe_Fecha

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDEMIC, 	@Cam_EcEmis,	Emc_Emisio,		@Cam_EcNume,	Emc_Numero,
			@Cam_EcFeLi,	Emc_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDEMICUP noholdlock
	where Emc_FecLiq = @Dfe_Fecha

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDEMIC, 	@Cam_EcEmis,	Emc_Emisio,		@Cam_EcNume,	Emc_Numero,
			@Cam_EcFeVe,	Emc_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDEMICUP noholdlock
	where Emc_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp22,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDEMICUP **/
exec @Status = SOBIDIFECON
	@Tip_MDEMIC,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDEMIC,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDEMICUP set
		Emc_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Emc_FecIni = @Dfe_Fecha

	-- Actualizamos
	Update MDEMICUP set
		Emc_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Emc_FecLiq = @Dfe_Fecha

	-- Actualizamos
	Update MDEMICUP set
		Emc_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Emc_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDEMIC,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldo de MDVENINS **/
exec @Status = SOBIDIFECON
	@Tip_Resp23,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDVENI,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDVENI, 	@Cam_VeiNum,	Vei_Numero,		@Cam_VeiIns,	Vei_Instit,
			@Cam_ViFeLi,	Vei_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDVENINS noholdlock
	where Vei_FecLiq = @Dfe_Fecha

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDVENI, 	@Cam_VeiNum,	Vei_Numero,		@Cam_VeiIns,	Vei_Instit,
			@Cam_ViFeVe,	Vei_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDVENINS noholdlock
	where Vei_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp23,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDVENINS **/
exec @Status = SOBIDIFECON
	@Tip_MDVENI,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDVENI,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDVENINS set
		Vei_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Vei_FecLiq = @Dfe_Fecha

	-- Actualizamos
	Update MDVENINS set
		Vei_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Vei_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDVENI,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldo de MDCUSTIT **/
exec @Status = SOBIDIFECON
	@Tip_Resp24,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDCUST,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDCUST, 	@Cam_CutNum,	Cut_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_CuFeLi,	Cut_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDCUSTIT noholdlock
	where Cut_FecLiq = @Dfe_Fecha
	  and Cut_Status <> @Sta_C
	   
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDCUST, 	@Cam_CutNum,	Cut_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_CuFeVe,	Cut_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDCUSTIT noholdlock
	where Cut_FecVen = @Dfe_Fecha
	  and Cut_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp24,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDCUSTIT **/
exec @Status = SOBIDIFECON
	@Tip_MDCUST,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDCUST,
			@Fec_IniPro	= getdate()
	  
	-- Actualizamos
	Update MDCUSTIT set
		Cut_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cut_FecLiq = @Dfe_Fecha
	  and Cut_Status <> @Sta_C

	-- Actualizamos
	Update MDCUSTIT set
		Cut_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cut_FecVen = @Dfe_Fecha
	  and Cut_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDCUST,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldo de MDCUSCUP **/
exec @Status = SOBIDIFECON
	@Tip_Resp25,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDCUSC,
			@Fec_IniPro	= getdate()

	-- Respaldo Cuc_FecIni
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDCUSC, 	@Cam_CucTit,	Cuc_CusTit,		@Cam_CucNum,	Cuc_Numero,
			@Cam_CcFeIn,	Cuc_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDCUSCUP noholdlock
	where Cuc_FecIni = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	-- Respaldo Cuc_FecVen
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDCUSC, 	@Cam_CucTit,	Cuc_CusTit,		@Cam_CucNum,	Cuc_Numero,
			@Cam_CcFeVe,	Cuc_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDCUSCUP noholdlock
	where Cuc_FecVen = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	-- Respaldo Cuc_FecLiq
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDCUSC, 	@Cam_CucTit,	Cuc_CusTit,		@Cam_CucNum,	Cuc_Numero,
			@Cam_CcFeLi,	Cuc_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDCUSCUP noholdlock
	where Cuc_FecLiq = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp25,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDCUSCUP **/
exec @Status = SOBIDIFECON
	@Tip_MDCUSC,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDCUSC,
			@Fec_IniPro	= getdate()

	-- Actualizamos Cuc_FecIni
	Update MDCUSCUP set
		Cuc_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cuc_FecIni = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	-- Actualizamos Cuc_FecVen
	Update MDCUSCUP set
		Cuc_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cuc_FecVen = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	-- Actualizamos Cuc_FecLiq
	Update MDCUSCUP set
		Cuc_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cuc_FecLiq = @Dfe_Fecha
	  and Cuc_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDCUSC,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldo de MDOPFEVA **/
exec @Status = SOBIDIFECON
	@Tip_Resp26,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDOPFE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDOPFE, 	@Cam_OfvNum,	Ofv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_OfFeIn,	Ofv_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDOPFEVA noholdlock
	where Ofv_FecIni = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp26,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDOPFEVA **/
exec @Status = SOBIDIFECON
	@Tip_MDOPFE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDOPFE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDOPFEVA set
		Ofv_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Ofv_FecIni = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDOPFE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de MDDEAL **/
exec @Status = SOBIDIFECON
	@Tip_Resp27,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_MDDEAL,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_MDDEAL, 	@Cam_DeaNum,	Dea_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_DeFeLi,	Dea_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from MDDEAL noholdlock
	where Dea_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp27,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de MDDEAL **/
exec @Status = SOBIDIFECON
	@Tip_MDDEAL,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_MDDEAL,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update MDDEAL set
		Dea_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Dea_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_MDDEAL,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de DEOPERAC **/
exec @Status = SOBIDIFECON
	@Tip_Resp28,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_DEOPER,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_DEOPER, 	@Cam_OpeNum,	Ope_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_OpFeLi,	Ope_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from DEOPERAC noholdlock
	where Ope_FecLiq = @Dfe_Fecha
	  and Ope_Status <> @Sta_C

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_DEOPER, 	@Cam_OpeNum,	Ope_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_OpFeVe,	Ope_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from DEOPERAC noholdlock
	where Ope_FecVen = @Dfe_Fecha
	  and Ope_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp28,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de DEOPERAC **/
exec @Status = SOBIDIFECON
	@Tip_DEOPER,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_DEOPER,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update DEOPERAC set
		Ope_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Ope_FecLiq = @Dfe_Fecha
	  and Ope_Status <> @Sta_C

	-- Actualizamos
	Update DEOPERAC set
		Ope_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Ope_FecVen = @Dfe_Fecha
	  and Ope_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_DEOPER,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de DEAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Resp29,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_DEAMOR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_DEAMOR, 	@Cam_AmoOpe,	Amo_Operac,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_AmFeIn,	Amo_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from DEAMORTI noholdlock
	where Amo_FecIni = @Dfe_Fecha
	  and Amo_Status <> @Sta_C
	  
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_DEAMOR, 	@Cam_AmoOpe,	Amo_Operac,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_AmFeLi,	Amo_FecLiq,		@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from DEAMORTI noholdlock
	where Amo_FecLiq = @Dfe_Fecha
	  and Amo_Status <> @Sta_C

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_DEAMOR, 	@Cam_AmoOpe,	Amo_Operac,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_AmFeVe,	Amo_FecVen,		@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from DEAMORTI noholdlock
	where Amo_FecVen = @Dfe_Fecha
	  and Amo_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp29,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de DEAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_DEAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_DEAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update DEAMORTI set
		Amo_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecIni = @Dfe_Fecha
	  and Amo_Status <> @Sta_C

	-- Actualizamos
	Update DEAMORTI set
		Amo_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecLiq = @Dfe_Fecha
	  and Amo_Status <> @Sta_C

	-- Actualizamos
	Update DEAMORTI set
		Amo_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amo_FecVen = @Dfe_Fecha
	  and Amo_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_DEAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TEPAPEL **/
exec @Status = SOBIDIFECON
	@Tip_Resp30,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TEPAPE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE
	select	@Tab_TEPAPE, 	@Cam_PapNum,	Pap_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_PaFeVe,	Pap_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TEPAPEL noholdlock
	where Pap_FecVen = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp30,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de TEPAPEL **/
exec @Status = SOBIDIFECON
	@Tip_TEPAPE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TEPAPE,
			@Fec_IniPro	= getdate()
			
	-- Actualizamos
	Update TEPAPEL set
		Pap_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pap_FecVen = @Dfe_Fecha
	  and Pap_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TEPAPE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TEEMISIO **/
exec @Status = SOBIDIFECON
	@Tip_Resp31,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TEEMIS,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TEEMIS, 	@Cam_EmiNum,	Emi_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_EmFeVe,	Emi_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TEEMISIO noholdlock
	where Emi_FecVen = @Dfe_Fecha
	  and Emi_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp31,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de TEEMISIO **/
exec @Status = SOBIDIFECON
	@Tip_TEEMIS,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TEEMIS,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TEEMISIO set
		Emi_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Emi_FecVen = @Dfe_Fecha
	  and Emi_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TEEMIS,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TEOPFEVA **/
exec @Status = SOBIDIFECON
	@Tip_Resp32,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TEOPFE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TEOPFE, 	@Cam_OfvNum,	Ofv_Numero,		@Str_Vacio,		@Str_Vacio,
			@Cam_OfFeIn,	Ofv_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TEOPFEVA noholdlock
	where Ofv_FecIni = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp32,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de TEOPFEVA **/
exec @Status = SOBIDIFECON
	@Tip_TEOPFE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TEOPFE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TEOPFEVA set
		Ofv_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Ofv_FecIni = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TEOPFE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TEPAPCUP **/
exec @Status = SOBIDIFECON
	@Tip_Resp33,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TEPAPC,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TEPAPC, 	@Cam_PacPap,	Pac_Papel,		@Cam_PacNum,	Pac_Numero,
			@Cam_PcFeVe,	Pac_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TEPAPCUP noholdlock
	where Pac_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp33,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de TEPAPCUP **/
exec @Status = SOBIDIFECON
	@Tip_TEPAPC,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TEPAPC,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TEPAPCUP set
		Pac_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pac_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TEPAPC,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TECUREMO **/
exec @Status = SOBIDIFECON
	@Tip_Resp34,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TECURE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TECURE, 	@Str_Vacio, 	@Str_Vacio,		@Str_Vacio, 	@Str_Vacio,
			@Cam_TeFeIn,	Crm_FecIni, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TECUREMO noholdlock
	where Crm_FecIni = @Dfe_Fecha
	
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TECURE, 	@Str_Vacio, 	@Str_Vacio,		@Str_Vacio, 	@Str_Vacio,
			@Cam_TeFeVe,	Crm_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TECUREMO noholdlock
	where Crm_FecVen = @Dfe_Fecha
	
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TECURE, 	@Str_Vacio, 	@Str_Vacio,		@Str_Vacio, 	@Str_Vacio,
			@Cam_TeFeLi,	Crm_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TECUREMO noholdlock
	where Crm_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp34,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de TECUREMO **/
exec @Status = SOBIDIFECON
	@Tip_TECURE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TECURE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TECUREMO set
		Crm_FecIni	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Crm_FecIni = @Dfe_Fecha

	-- Actualizamos
	Update TECUREMO set
		Crm_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Crm_FecVen = @Dfe_Fecha

	-- Actualizamos
	Update TECUREMO set
		Crm_FecLiq	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Crm_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TECURE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ITORDPAG **/
exec @Status = SOBIDIFECON
	@Tip_Resp35,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ITORDP,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ITORDP, 	@Cam_OrpTra,	Orp_Transa,		@Cam_OrpNum,	Orp_Numero,
			@Cam_OrFeVe,	Orp_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ITORDPAG noholdlock
	where Orp_FecVen = @Dfe_Fecha
	  and Orp_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp35,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ITORDPAG **/
exec @Status = SOBIDIFECON
	@Tip_ITORDP,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ITORDP,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ITORDPAG set
		Orp_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Orp_FecVen = @Dfe_Fecha
	  and Orp_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ITORDP,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ITCOMVEN **/
exec @Status = SOBIDIFECON
	@Tip_Resp36,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ITCOMV,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ITCOMV, 	@Cam_CovNum,	Cov_Numero,		@Cam_CovTip,		Cov_Tipo,
			@Cam_CvFeVe,	Cov_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ITCOMVEN noholdlock
	where Cov_FecVen = @Dfe_Fecha
	  and Cov_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp36,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ITCOMVEN **/
exec @Status = SOBIDIFECON
	@Tip_ITCOMV,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ITCOMV,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ITCOMVEN set
		Cov_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cov_FecVen = @Dfe_Fecha
	  and Cov_Status <> @Sta_C

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ITCOMV,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ITPASAMO **/
exec @Status = SOBIDIFECON
	@Tip_Resp38,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ITPASA,
			@Fec_IniPro	= getdate()
		
	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ITPASA, 	@Cam_AmPaDo,	Amp_PasDol,		@Cam_AmpNum,	Amp_Numero,
			@Cam_AmFePa,	Amp_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ITPASAMO noholdlock
	where Amp_FecPag = @Dfe_Fecha
	  and Amp_Status = @Sta_N

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ITPASA, 	@Cam_AmPaDo,	Amp_PasDol,		@Cam_AmpNum,	Amp_Numero,
			@Cam_ApFeVe,	Amp_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ITPASAMO noholdlock
	where Amp_FecVen = @Dfe_Fecha
	  and Amp_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp38,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Actualización de ITPASAMO **/
exec @Status = SOBIDIFECON
	@Tip_ITPASA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ITPASA,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ITPASAMO set
		Amp_FecPag	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amp_FecPag = @Dfe_Fecha
	  and Amp_Status = @Sta_N

	-- Actualizamos
	Update ITPASAMO set
		Amp_FecVen	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Amp_FecVen = @Dfe_Fecha
	  and Amp_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ITPASA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TACORTCR **/
exec @Status = SOBIDIFECON
	@Tip_Resp39,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TACORT,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TACORT,	@Cam_CorLin,	Cor_Linea,		@Cam_CorNum,	Cor_Numero,
			@Cam_CoFeVe,	Cor_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TACORTCR noholdlock
	where Cor_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp39,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de TACORTCR **/
exec @Status = SOBIDIFECON
	@Tip_TACORT,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TACORT,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TACORTCR set
		Cor_FecVen	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cor_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TACORT,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Respaldamos de TASALVEN **/
exec @Status = SOBIDIFECON
	@Tip_Resp40,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TASALV,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TASALV,	@Cam_SavLin,	Sav_Linea,		@Cam_SavCor,	Sav_Corte,
			@Cam_SaFeVe,	Sav_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TASALVEN noholdlock
	where Sav_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp40,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de TASALVEN **/
exec @Status = SOBIDIFECON
	@Tip_TASALV,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TASALV,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TASALVEN set
		Sav_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Sav_FecVen = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TASALV,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Respaldamos de SGSEGTEL **/
exec @Status = SOBIDIFECON
	@Tip_Resp41,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_SGSEGT,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_SGSEGT,	@Cam_SeNuPo,	Seg_NumPol,		@Str_Vacio,		@Str_Vacio,
			@Cam_SeFeFi,	Seg_FecFin, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from SGSEGTEL noholdlock
	where Seg_FecFin = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp41,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de SGSEGTEL **/
exec @Status = SOBIDIFECON
	@Tip_SGSEGT,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_SGSEGT,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update SGSEGTEL set
		Seg_FecFin	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Seg_FecFin = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_SGSEGT,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Respaldamos de SGDOSETE **/
exec @Status = SOBIDIFECON
	@Tip_Resp42,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_SGDOSE,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_SGDOSE, 	@Cam_DocPol,	Doc_Poliza,		@Cam_DocDoc,	Doc_Docume,
			@Cam_DoFePa,	Doc_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from SGDOSETE noholdlock
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_SGDOSE, 	@Cam_DocPol,	Doc_Poliza,		@Cam_DocDoc,	Doc_Docume,
			@Cam_DoFeVe,	Doc_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from SGDOSETE noholdlock
	where Doc_FecVen = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp42,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de SGDOSETE **/
exec @Status = SOBIDIFECON
	@Tip_SGDOSE,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_SGDOSE,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update SGDOSETE set
		Doc_FecPag	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	-- Actualizamos
	Update SGDOSETE set
		Doc_FecVen	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Doc_FecVen = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_SGDOSE,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de BEFADOCU **/
exec @Status = SOBIDIFECON
	@Tip_Resp43,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_BEFADO,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_BEFADO, 	@Cam_DocCon,	Doc_Contra,		@Cam_DocNum,	convert(varchar, Doc_Numero),
			@Cam_DoFePa,	Doc_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from BEFADOCU noholdlock
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_BEFADO, 	@Cam_DocCon,	Doc_Contra,		@Cam_DocNum,	convert(varchar, Doc_Numero),
			@Cam_DoFeVe,	Doc_FecVen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from BEFADOCU noholdlock
	where Doc_FecVen = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp43,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de BEFADOCU **/
exec @Status = SOBIDIFECON
	@Tip_BEFADO,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_BEFADO,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update BEFADOCU set
		Doc_FecPag	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Doc_FecPag = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	-- Actualizamos
	Update BEFADOCU set
		Doc_FecVen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Doc_FecVen = @Dfe_Fecha
	  and Doc_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_BEFADO,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end

select  @Par_FecApe = Par_FecApe,
		@Par_Fecha  = Par_Fecha
  from TEPARAMS noholdlock

/** Proceso solo se ejecuta si fecha apertura de tesoreria se esta registrando como dia festivo **/
if datediff(dd, @Par_FecApe, @Dfe_Fecha) = 0 begin 
	/** Respaldamos de TEPARAMS **/
	exec @Status = SOBIDIFECON
		@Tip_Resp44,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	if @Var_Contin = @Sta_Si begin	
		begin transaction
		select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TEPARA,
				@Fec_IniPro	= getdate()

		-- Respaldo
		insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
		select	@Tab_TEPARA, 	@Cam_PaFeAp,	Par_FecApe,		@Cam_ParFec,	Par_Fecha,
				@Cam_PaFeAp,	Par_FecApe, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from TEPARAMS noholdlock

		select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

		exec @Status = SOBIDIFEALT
			@Tip_Resp44,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
			@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
			@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return @Ent_Uno
		end
		commit
	end

	/** Actualización de TEPARAMS **/
	exec @Status = SOBIDIFECON
		@Tip_TEPARA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	if @Var_Contin = @Sta_Si begin	
		begin transaction
		select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TEPARA,
				@Fec_IniPro	= getdate()

		-- Actualizamos
		Update TEPARAMS set
			Par_FecApe	= @Fec_SiDiHa,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino

		select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

		exec @Status = SOBIDIFEALT
			@Tip_TEPARA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
			@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
			@SucDestino,	@Modulo
		if @Status <> @Ent_Cero begin
			rollback
			return @Ent_Uno
		end
		
		commit
	end
end

/** Respaldamos de TECALMON **/
exec @Status = SOBIDIFECON
	@Tip_Resp45,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TECAMO,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_TECAMO, 	@Cam_CamNum,	Cam_Numero,		@Cam_CamPla,	convert(varchar, Cam_Plazo),
			@Cam_CaFeLi,	Cam_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TECALMON noholdlock
	where Cam_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp45,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de TECALMON **/
exec @Status = SOBIDIFECON
	@Tip_TECAMO,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TECAMO,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TECALMON set
		Cam_FecLiq	= @Fec_SiDiHa,
		Cam_Plazo 	= convert(int, datediff(dd, Cam_FecIni, @Fec_SiDiHa)),

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Cam_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TECAMO,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de TESUBAST **/
exec @Status = SOBIDIFECON
	@Tip_Resp46,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_TESUBA,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE
	select	@Tab_TESUBA, 	@Cam_SubNum,	convert(varchar, Sub_Numero),	@Cam_SubPla,	convert(varchar, Sub_Plazo),
			@Cam_SuFeLi,	Sub_FecLiq, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from TESUBAST noholdlock
	where Sub_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp46,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de TESUBAST **/
exec @Status = SOBIDIFECON
	@Tip_TESUBA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_TESUBA,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update TESUBAST set
		Sub_FecLiq	= @Fec_SiDiHa,
		Sub_Plazo 	= convert(int, datediff(dd, Sub_FecIni, @Fec_SiDiHa)),

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Sub_FecLiq = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_TESUBA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	
	commit
end

/** Respaldamos de ABPRCOAM **/
exec @Status = SOBIDIFECON
	@Tip_Resp47,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_ABPRCO,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_ABPRCO, 	@Cam_ProCon,	convert(varchar,Pro_Consec),	@Cam_ProAmor,	Pro_Amorti,
			@Cam_PrFeDe,	Pro_FePrDe, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from ABPRCOAM noholdlock
	where Pro_FePrDe = @Dfe_Fecha
	  and Pro_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp47,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de ABPRCOAM **/
exec @Status = SOBIDIFECON
	@Tip_ABPRCO,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_ABPRCO,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update ABPRCOAM set
		Pro_FePrDe	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Pro_FePrDe = @Dfe_Fecha
	  and Pro_Status = @Sta_N

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_ABPRCO,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,	
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Respaldamos AURENMAS **/
exec @Status = SOBIDIFECON
	@Tip_Resp48,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin	
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_AUREMA,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE
		(Rdf_NomTab, Rdf_NoClPr, Rdf_VaClPr, Rdf_NoClSe, Rdf_VaClSe,
		Rdf_NoCaMo, Rdf_FecOri, Rdf_FecMod, NumTransac, Transaccio,
		Usuario,    FechaSis,   SucOrigen,  SucDestino)
	select	@Tab_AUREMA, 	@Cam_ReaCon,	Rea_Contra,		@Cam_FecRen,	convert(varchar,Rea_FecRen),
			@Cam_FecRen,	Rea_FecRen, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from AURENMAS noholdlock
	where Rea_FecRen = @Dfe_Fecha
	  and Rea_Status in (@Sta_N, @Sta_A)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp48,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Actualización de AURENMAS **/
exec @Status = SOBIDIFECON
	@Tip_AUREMA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin 
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_AUREMA,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update AURENMAS set
		Rea_FecRen	= @Fec_SiDiHa,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Rea_FecRen = @Dfe_Fecha
	  and Rea_Status in (@Sta_N, @Sta_A)

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_AUREMA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end
	commit
end

/** Respaldamos de AUAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_Resp49,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_AUAMOR,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_AUAMOR, 	@Cam_ConCre,	Amo_Contra,		@Cam_ABAmNu,	Amo_Numero,
			@Cam_ABFePa,	Amo_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from AUAMORTI noholdlock
	where Amo_FecPag = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp49,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end

/** Actualización de AUAMORTI **/
exec @Status = SOBIDIFECON
	@Tip_AUAMOR,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_AUAMOR,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update AUAMORTI set
		Amo_FecPag	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from AUAMORTI
	where Amo_FecPag = @Dfe_Fecha


	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_AUAMOR,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end


/** Respaldamos de CRPAGAMO **/
exec @Status = SOBIDIFECON
	@Tip_Resp50,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRPAGA,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CRPAGA, 	@Cam_PAPaga,	Pam_Pagare,		@Cam_PANume,	Pam_Numero,
			@Cam_PAFePa,	Pam_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRPAGAMO noholdlock
	where Pam_FecPag = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp50,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end

/** Actualización de CRPAGAMO **/
exec @Status = SOBIDIFECON
	@Tip_CRPAGA,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRPAGA,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CRPAGAMO set
		Pam_FecPag	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from CRPAGAMO
	where Pam_FecPag = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRPAGA,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end


/** Respaldamos de CRAMOHIP **/
exec @Status = SOBIDIFECON
	@Tip_Resp51,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Respal + @Str_Espaci + @Tab_CRAMOH,
			@Fec_IniPro	= getdate()

	-- Respaldo
	insert into SOREDIFE(Rdf_NomTab,	Rdf_NoClPr,	Rdf_VaClPr,	Rdf_NoClSe,	Rdf_VaClSe,
						 Rdf_NoCaMo,	Rdf_FecOri,	Rdf_FecMod,	NumTransac,	Transaccio,
						 Usuario,		FechaSis,	SucOrigen,	SucDestino)
	select	@Tab_CRAMOH, @Cam_HICont,	Amh_Contra,	@Cam_HINume,	Amh_Numero,
			@Cam_HIFePa,	Amh_FecPag, 	@Fec_SiDiHa,	@NumTransac,	@Transaccio,
			@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
	from CRAMOHIP
	where Amh_FecPag = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_Resp51,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end

/** Actualización de CRAMOHIP **/
exec @Status = SOBIDIFECON
	@Tip_CRAMOH,	@Dfe_Fecha,		@Var_Contin output,	@NumTransac,	@Transaccio,
	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
if @Status <> @Ent_Cero begin
	rollback
	return @Ent_Uno
end

if @Var_Contin = @Sta_Si begin
	begin transaction
	select	@Pro_Descri	= @Des_Actual + @Str_Espaci + @Tab_CRAMOH,
			@Fec_IniPro	= getdate()

	-- Actualizamos
	Update CRAMOHIP set
		Amh_FecPag	= @Fec_SiDiHa,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from CRAMOHIP
	where Amh_FecPag = @Dfe_Fecha

	select	@Pro_Tiempo	= convert(int, datediff(ss, @Fec_IniPro, getdate()))

	exec @Status = SOBIDIFEALT
		@Tip_CRAMOH,	@Pro_Descri,	@Pro_Tiempo,	@Dfe_Fecha,		@Fec_IniPro,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end

	commit
end
