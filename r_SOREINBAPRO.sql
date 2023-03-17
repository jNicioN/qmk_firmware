create procedure SOREINBAPRO (
	@Rib_Numero int,
	@Rib_NumPer char(8),
	@Rib_NumInt int,
	@Rib_NumSol int,
	@Tip_Proces char(1),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Procesamiento de copia de registros de Reporte	*/
/*				de Informacion Basica							*/
/****************************************************************/
/** Modifico:		Jose Romeo Rodriguez Zenteno				*/
/** Descripcion:    Se corrige busqueda de RIB base         	*/
/** Fecha:			01/09/2022                               	*/
/** Help:			1643668					 					*/
/****************************************************************/
/** Modifico:		Raul Muniz									*/
/** Descripcion:	Se agregan generalidades a la copia de RIB	*/
/** Fecha:			06/01/2021                               	*/
/** Help:			1433413					 					*/
/****************************************************************/
/** Modifico:		Claudia Sandoval							*/
/** Descripcion:	Corrige copia si es RIB Base				*/
/** Fecha:			07/06/2019                               	*/
/** Help:			1229452					 					*/
/****************************************************************/
/** Modifico:		Victor Osorio								*/
/** Descripcion:	Se agrega condiciones a la copia de RIB		*/
/**					Numero de Interviniente = 0					*/
/** Fecha:			30/01/2018                               	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Modifico:		Victor Osorio								*/
/** Descripcion:	Se considera nuevo campo Rib_LugCon			*/
/** Fecha:			24/04/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Creo:			Victor Osorio								*/
/** Fecha:			24/04/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/

/* Declaracion de Constantes */
declare @Str_A		char(1),		/* Constante con valor de A */
		@Ent_Cero	int,			/* Constante con valor de 0 */
		@Ent_Uno	int,			/* Constante con valor de 1 */
		@Str_Vacio	char(1),		/* Constante con valor de vacio */
		@Fec_Null	smalldatetime,	/* Constante con valor de la fecha null */
		@Status		 int		/* Campo de retorno */

select	@Str_A		= 'A',
		@Ent_Cero	= 0,
		@Ent_Uno	= 1,
		@Str_Vacio	= '',
		@Fec_Null	= null

/* Declaracion de Variables */
declare @Int_RibBas	int,
		@Int_RibCop	int

if @Tip_Proces	= @Str_A begin /* 'A': Proceso para realizar la copia de RIB cuando se da de alta un Interviniente por solicitud. */

	select @Int_RibBas = @Ent_Cero 
	select @Int_RibBas = Rib_Numero 
		from SORIB noholdlock 
		where Rib_NumPer = @Rib_NumPer 
		  and Rib_NumSol = @Ent_Cero 
		  and Rib_NumInt = @Ent_Cero
		  and Rib_FecEla <> @Str_Vacio
			
	if @Int_RibBas <> @Ent_Cero  begin
		
		if @Rib_NumInt = @Ent_Cero and @Rib_NumSol = @Ent_Cero and @Int_RibBas <> @Ent_Cero begin
			select		Err_Codigo	= '000001',
						Err_Mensaj	= 'Ya existe un RIB BASE'
			return @Ent_Uno
		end
				
		/* Si existe Rib Persona Base, se crea copia */
		insert into SORIB (
				Rib_NumPer,    	Rib_NumInt,		Rib_NumSol,    	Rib_TipSol,		Rib_TipRib,
				Rib_FecEla,		Rib_SucSol,    	Rib_ConNom,		Rib_ConPue,    	Rib_PagWeb,
				Rib_ActCat,		Rib_ActEsp,    	Rib_MerObj,		Rib_LlViOc,    	Rib_UsuCap,
				Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,		Rib_EmOtCr,
				Rib_EmSuRe,		Rib_FeInOp,		Rib_DurSoc,		Rib_CotBol,		Rib_NumApo,
				Rib_NumCon,		Rib_CliSuc,		Rib_ZonUsu,		Rib_EdoCiv,		Rib_NumExt,
				Rib_LugCon,		NumTransac,		Transaccio,		Usuario,		FechaSis,
				SucOrigen,		SucDestino
		)
		select	Rib_NumPer,		@Rib_NumInt,	@Rib_NumSol,	Rib_TipSol,		Rib_TipRib,
				Rib_FecEla,		Rib_SucSol,		Rib_ConNom,		Rib_ConPue,		Rib_PagWeb,
				Rib_ActCat,		Rib_ActEsp,		Rib_MerObj,		Rib_LlViOc,		Rib_UsuCap,
				Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,		Rib_EmOtCr,
				Rib_EmSuRe,		Rib_FeInOp,		Rib_DurSoc,		Rib_CotBol,		Rib_NumApo,
				Rib_NumCon,		Rib_CliSuc,		Rib_ZonUsu,		Rib_EdoCiv,		Rib_NumExt,
				Rib_LugCon,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
				@SucOrigen,		@SucDestino
		from SORIB noholdlock
		where Rib_Numero = @Int_RibBas
		select @Int_RibCop = @@IDENTITY

		/* Se crean copias de los registros de otras tablas asociadas al Rib Base */

		insert into SORIREIN (
				Rri_NumRib,		Rri_Instit,		Rri_Produc,		Rri_PorPar,		Rri_FePrC1,
				Rri_MoPrC1,		Rri_FePrC2,		Rri_MoPrC2,		Rri_FePrC3,		Rri_MoPrC3,
				Rri_Activo,		NumTransac,		Transaccio,		Usuario,		FechaSis,
				SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rri_Instit,		Rri_Produc,		Rri_PorPar,		Rri_FePrC1,
				Rri_MoPrC1,		Rri_FePrC2,		Rri_MoPrC2,		Rri_FePrC3,		Rri_MoPrC3,
				Rri_Activo,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
				@SucOrigen,		@SucDestino
		from SORIREIN noholdlock
		where Rri_NumRib = @Int_RibBas
		  and Rri_Activo = @Ent_Uno


		insert into SORILIOT (
				Rlo_NumRib,		Rlo_Instit,		Rlo_TipCre,		Rlo_MonAut,		Rlo_Respon,
				Rlo_Moneda,		Rlo_Plazo,		Rlo_Tasa,		Rlo_Avales,		Rlo_Garant,
				Rlo_Total,		Rlo_PagMen,		Rlo_Destin,		Rlo_Activo,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rlo_Instit,		Rlo_TipCre,		Rlo_MonAut,		Rlo_Respon,
				Rlo_Moneda,		Rlo_Plazo,		Rlo_Tasa,		Rlo_Avales,		Rlo_Garant,
				Rlo_Total,		Rlo_PagMen,		Rlo_Destin,		Rlo_Activo,		@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORILIOT noholdlock
		where Rlo_NumRib = @Int_RibBas
		  and Rlo_Activo = @Ent_Uno

		insert into SORIBPOD (
				Rip_NumRib,    	Rip_TipPod,		Rip_Activo,		NumTransac,		Transaccio,		
				Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,    Rip_TipPod,		Rip_Activo,		@NumTransac,	@Transaccio,	
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIBPOD noholdlock
		where Rip_NumRib = @Int_RibBas
		and Rip_Activo = @Ent_Uno


		insert into SORIBACC (
				Ria_NumRib,		Ria_NumPer,		Ria_PorPar,		Ria_Activo,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Ria_NumPer,		Ria_PorPar,		Ria_Activo,		@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIBACC noholdlock
		where Ria_NumRib = @Int_RibBas
		  and Ria_Activo = @Ent_Uno

		insert into SORIDILF (
				Rdf_NumRib,		Rdf_Tipo,		NumTransac,		Transaccio,		Usuario,
				FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rdf_Tipo,		@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino
		from SORIDILF noholdlock
		where Rdf_NumRib = @Int_RibBas


		insert into SORIPOFI (
				Rpf_NumRib,		Rpf_Politi,		Rpf_DCPoCo,		Rpf_DiaInv,		Rpf_DiaPro,
				Rpf_PerPic,		Rpf_PerRec,		Rpf_ComCic,		Rpf_PolInv,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rpf_Politi,		Rpf_DCPoCo,		Rpf_DiaInv,		Rpf_DiaPro,
				Rpf_PerPic,		Rpf_PerRec,		Rpf_ComCic,		Rpf_PolInv,		@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIPOFI noholdlock
		where Rpf_NumRib = @Int_RibBas


		insert into SORIBMAQ (
				Rim_NumRib,		Rim_TipMaq,		Rim_ReMeMa,		Rim_ArrMaq,		Rim_AnCoMa,
				Rim_FVCoMa,		Rim_AseMaq,		Rim_AraMaq,		Rim_PlPoMa,		Rim_VePoMa,
				Rim_MoCoMa,		Rim_MCMaMo,		Rim_RMMaMo,		NumTransac,		Transaccio,
				Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rim_TipMaq,		Rim_ReMeMa,		Rim_ArrMaq,		Rim_AnCoMa,
				Rim_FVCoMa,		Rim_AseMaq,		Rim_AraMaq,		Rim_PlPoMa,		Rim_VePoMa,
				Rim_MoCoMa,		Rim_MCMaMo,		Rim_RMMaMo,		@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIBMAQ noholdlock
		where Rim_NumRib = @Int_RibBas


		insert into SORIBCOM (
				Ric_NumRib,		Ric_Nombre,		Ric_Ubicac,		Ric_Ventaj,		Ric_Desven,
				Ric_Activo,		NumTransac,		Transaccio,		Usuario,		FechaSis,
				SucOrigen,		SucDestino)
		select	@Int_RibCop,	Ric_Nombre,		Ric_Ubicac,		Ric_Ventaj,		Ric_Desven,
				Ric_Activo,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
				@SucOrigen,		@SucDestino
		from SORIBCOM noholdlock
		where Ric_NumRib = @Int_RibBas
		  and Ric_Activo = @Ent_Uno


		insert into SORIPRSE (
				Rps_NumRib,		Rps_ProSer,		Rps_MarCom,		Rps_PoVeIn,		Rps_Activo,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Rps_ProSer,		Rps_MarCom,		Rps_PoVeIn,		Rps_Activo,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIPRSE noholdlock
		where Rps_NumRib = @Int_RibBas
		  and Rps_Activo = @Ent_Uno


		insert into SORIASME (
				Ram_NumRib,		Ram_TiCaDi,		Ram_MerCon,		Ram_MedUti,		Ram_LocVen,
				Ram_RegVen,		Ram_NacVen,		Ram_ExpVen,		NumTransac,		Transaccio,
				Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Ram_TiCaDi,		Ram_MerCon,		Ram_MedUti,		Ram_LocVen,
				Ram_RegVen,		Ram_NacVen,		Ram_ExpVen,		@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIASME noholdlock
		where Ram_NumRib = @Int_RibBas


		insert into SORIBREF (
				Rir_NumRib,		Rir_Fecha,		Rir_Banco,		Rir_NoEmCo,		Rir_Coment,
				Rir_NomRef,		Rir_TipRef,		Rir_Activo,		NumTransac,		Transaccio,
				Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rir_Fecha,		Rir_Banco,		Rir_NoEmCo,		Rir_Coment,
				Rir_NomRef,		Rir_TipRef,		Rir_Activo,		@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIBREF noholdlock
		where Rir_NumRib = @Int_RibBas
		  and Rir_Activo = @Ent_Uno


		insert into SORIBJUI (
				Rij_NumRib,		Rij_TipJui,		Rij_FecAct,		Rij_Descri,		Rij_Activo,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Rij_TipJui,		Rij_FecAct,		Rij_Descri,		Rij_Activo,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIBJUI noholdlock
		where Rij_NumRib = @Int_RibBas
		  and Rij_Activo = @Ent_Uno


		insert into SORIPLES (
				Rpe_NumRib,		Rpe_Coloca,		Rpe_Captac,		Rpe_Servic,		Rpe_Atribu,
				Rpe_Riesgo,		Rpe_TipEst,		Rpe_Moneda,		Rpe_TiCaCo,		Rpe_TiCaVe,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Rpe_Coloca,		Rpe_Captac,		Rpe_Servic,		Rpe_Atribu,
				Rpe_Riesgo,		Rpe_TipEst,		Rpe_Moneda,		Rpe_TiCaCo,		Rpe_TiCaVe,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIPLES noholdlock
		where Rpe_NumRib = @Int_RibBas


		insert into SORIEMFI (
				Ref_NumRib,		Ref_NumPer,		Ref_PriAct,		Ref_TiReNe,		Ref_TiReOt,
				Ref_PeSiRf,		Ref_Activo,		NumTransac,		Transaccio,		Usuario,
				FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Ref_NumPer,		Ref_PriAct,		Ref_TiReNe,		Ref_TiReOt,
				Ref_PeSiRf,		Ref_Activo,		@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino
		from SORIEMFI noholdlock
		where Ref_NumRib = @Int_RibBas
		  and Ref_Activo = @Ent_Uno


		insert into SORIBPRO (
				Rip_NumRib,		Rip_Nombre,		Rip_Filial,		Rip_PorCom,		Rip_Antigu,
				Rip_Insumo,		Rip_Plazo,		Rip_TipPro,		Rip_Varios,		Rip_Activo,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Rip_Nombre,		Rip_Filial,		Rip_PorCom,		Rip_Antigu,
				Rip_Insumo,		Rip_Plazo,		Rip_TipPro,		Rip_Varios,		Rip_Activo,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIBPRO noholdlock
		where Rip_NumRib = @Int_RibBas
		  and Rip_Activo = @Ent_Uno


		insert into SORIBCLI (
				Ric_NumRib,		Ric_Nombre,		Ric_Filial,		Ric_Ventas,		Ric_Carter,
				Ric_Antigu,		Ric_Plazo,		Ric_Ubicac,		Ric_Varios,		Ric_Activo,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Ric_Nombre,		Ric_Filial,		Ric_Ventas,		Ric_Carter,
				Ric_Antigu,		Ric_Plazo,		Ric_Ubicac,		Ric_Varios,		Ric_Activo,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIBCLI noholdlock
		where Ric_NumRib = @Int_RibBas
		  and Ric_Activo = @Ent_Uno


		insert into SORIDILI (
				Rdl_NumRib,		Rdl_Tipo,		Rdl_Activo,		NumTransac,		
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		
				SucDestino)
		select	@Int_RibCop,	Rdl_Tipo,		@Ent_Uno,		@NumTransac,	
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
				@SucDestino
		from SORIDILI noholdlock
		where Rdl_NumRib = @Int_RibBas


		insert into SORICOAA (
				Rca_NumRib,		Rca_Tipo,		NumTransac,		Transaccio,		Usuario,
				FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rca_Tipo,		@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino
		from SORICOAA noholdlock
		where Rca_NumRib = @Int_RibBas


		insert into SORICOAC (
				Rca_NumRib,		Rca_CoPaGP,		Rca_TipAdm,		Rca_NuCoTo,		Rca_NuCoIn,
				Rca_TiAdUn,		Rca_PlaSuc,		Rca_OrAdSe,		Rca_ArACIn,		Rca_PrCuAd,
				Rca_CuExBa,		Rca_CuExPr,		Rca_EdFiAu,		Rca_PrExBa,		Rca_ExPoPr,
				Rca_InArRi,		NumTransac,		Transaccio,		Usuario,		FechaSis,
				SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rca_CoPaGP,		Rca_TipAdm,		Rca_NuCoTo,		Rca_NuCoIn,
				Rca_TiAdUn,		Rca_PlaSuc,		Rca_OrAdSe,		Rca_ArACIn,		Rca_PrCuAd,
				Rca_CuExBa,		Rca_CuExPr,		Rca_EdFiAu,		Rca_PrExBa,		Rca_ExPoPr,
				Rca_InArRi,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
				@SucOrigen,		@SucDestino
		from SORICOAC noholdlock
		where Rca_NumRib = @Int_RibBas


		insert into SORIREHU (
				Rrh_NumRib,		Rrh_NumEmp,		Rrh_NumObr,		Rrh_NumEve,		Rrh_Otros,
				Rrh_Sindic,		Rrh_AmbLab,		Rrh_NumPer,		Rrh_AniGir,		Rrh_AniEmp,
				Rrh_Admini,		Rrh_Ventas,		NumTransac,		Transaccio,		Usuario,
				FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rrh_NumEmp,		Rrh_NumObr,		Rrh_NumEve,		Rrh_Otros,
				Rrh_Sindic,		Rrh_AmbLab,		Rrh_NumPer,		Rrh_AniGir,		Rrh_AniEmp,
				Rrh_Admini,		Rrh_Ventas,		@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino
		from SORIREHU noholdlock
		where Rrh_NumRib = @Int_RibBas


		insert into SORIASTE (
				Rat_NumRib,		Rat_CapIns,		Rat_BaCaIn,		Rat_TipMed,		Rat_OtBaCa,
				Rat_TurTra,		Rat_CaInPo,		Rat_ApCaAs,		Rat_CamAsp,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rat_CapIns,		Rat_BaCaIn,		Rat_TipMed,		Rat_OtBaCa,
				Rat_TurTra,		Rat_CaInPo,		Rat_ApCaAs,		Rat_CamAsp,		@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIASTE noholdlock
		where Rat_NumRib = @Int_RibBas


		insert into SORIBINS (
				Rii_NumRib,		Rii_TipIns,		Rii_Por,		Rii_ReMeIn,		Rii_RMInMo,
				Rii_ArrIns,		Rii_AnCoIn,		Rii_VeCoIn,		Rii_AseIns,		Rii_AraIns,
				Rii_PlPoIn,		Rii_VePoIn,		Rii_MoCoIn,		Rii_MCInMo,		Rii_CubInc,
				Rii_CubTer,		Rii_CubHur,		Rii_CubInu,		Rii_CubOtr,		Rii_CuOtEs,
				Rii_PrePor,		Rii_RMInVa,		Rii_RMIVaM,		Rii_RMInPa,		Rii_RMIPaM,
				NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
				SucDestino)
		select	@Int_RibCop,	Rii_TipIns,		Rii_Por,		Rii_ReMeIn,		Rii_RMInMo,
				Rii_ArrIns,		Rii_AnCoIn,		Rii_VeCoIn,		Rii_AseIns,		Rii_AraIns,
				Rii_PlPoIn,		Rii_VePoIn,		Rii_MoCoIn,		Rii_MCInMo,		Rii_CubInc,
				Rii_CubTer,		Rii_CubHur,		Rii_CubInu,		Rii_CubOtr,		Rii_CuOtEs,
				Rii_PrePor,		Rii_RMInVa,		Rii_RMIVaM,		Rii_RMInPa,		Rii_RMIPaM,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino
		from SORIBINS noholdlock
		where Rii_NumRib = @Int_RibBas
		
		
		insert into SORIBGEN (
				Rig_NumRib,		Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,		Rig_Export,
				Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
		select	@Int_RibCop,	Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,		Rig_Export,
				Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,		@NumTransac,
				@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
		from SORIBGEN noholdlock
		where Rig_NumRib = @Int_RibBas

	end else begin
	/* Si no existe Rib Persona Base, se crea Rib Base y copia para Rib Persona por Solicitud */
		exec @Status = SORIBALT
			@Ent_Cero,		@Rib_NumPer,    @Ent_Cero,		@Ent_Cero,   	@Ent_Cero,
			@Ent_Cero,		@Fec_Null,		@Str_Vacio,    	@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,    	@Ent_Cero,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Ent_Cero,		@Ent_Cero,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,
			@Str_Vacio,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,
			@Str_Vacio,		@Str_Vacio,		@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
			
		if @Status <> @Ent_Cero begin
			select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de alta de Rib BASE'

			rollback
			return @Ent_Uno
		end
		
		if @Rib_NumInt = @Ent_Cero and @Rib_NumSol = @Ent_Cero 
			return @Ent_Uno
		
		exec @Status = SORIBALT
			@Ent_Cero,		@Rib_NumPer,    @Rib_NumInt,	@Rib_NumSol,   	@Ent_Cero,
			@Ent_Cero,		@Fec_Null,		@Str_Vacio,    	@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,    	@Ent_Cero,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Ent_Cero,		@Ent_Cero,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,
			@Str_Vacio,		@Str_Vacio,		@Ent_Cero,		@Ent_Cero,		@Ent_Cero,
			@Str_Vacio,		@Str_Vacio,		@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
			
		if @Status <> @Ent_Cero begin
			select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de alta de Rib'

			rollback
			return @Ent_Uno
		end
	end
end

select		Err_Codigo	= '000000',
			Err_Mensaj	= 'Se ha procesado la copia de registros de forma correcta'