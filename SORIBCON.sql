create procedure SORIBCON (
	@Rib_Numero int,
	@Rib_NumPer char(8),
	@Rib_NumInt int,
	@Rib_NumSol int,
	@Tip_Consul char(2),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2)) 
as

/****************************************************************/
/* DESCRIPCION: Consulta de Reporte de Informacion Basica		*/
/****************************************************************/
/** Modifica:		Raul Muniz									*/
/** Descripcion:	Se modifica C2 para regresar primer RIB		*/
/**					Base										*/
/** Fecha:			31/08/2023                               	*/
/** C.Cambios:		32339					 					*/
/****************************************************************/
/** Modifica:		Jose R. Rodriguez Zenteno					*/
/** Descripcion:	Se modifica C4 para regresar Tipo de Rib	*/
/** Fecha:			24/02/2021                               	*/
/** Help:			1468599					 					*/
/****************************************************************/
/** Modifica:		Raul Muniz									*/
/** Descripcion:	Se modifican C1, C2, C3 y C4 para regresar	*/
/* 					duracion de sociedad indefinida				*/
/** Fecha:			05/02/2021                               	*/
/** Help:			1468599					 					*/
/****************************************************************/
/** Modifica:		Edwin Dennis								*/
/** Descripcion:	Se agrega campo Adi_FeNaAp					*/
/* 					Modificacion en Consulta Tipo C4			*/
/** Fecha:			09/02/2018                               	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Modifica:		Victor Osorio								*/
/** Descripcion:	Se agrega campo Rib_LugCon					*/
/** Fecha:			18/10/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Creo:			Jorge Armando Garcia						*/
/** Fecha:			30/03/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),		/* Tipo Consulta C/L */
        @Tip_ConCon char(1)			/* Numero Consulta */

/* Declaracion de Constantes */
declare @Str_Uno	char(1),		/* Caracter 1 */
        @Str_Dos	char(1),		/* Caracter 2 */
        @Str_Tres	char(1),		/* Caracter 3 */
        @Str_Cuatro char(1),		/* Caracter 4 */
		@Adm_Consej int,			/* Numero partida Consejo de Administracion */
		@Adm_Unico  int,			/* Numero partida Administrador Unico*/
		@Str_Consej varchar(30),	/* String Consejo de Administracion */
		@Str_Unico  varchar(30),	/* String Administrador Unico */
		@Str_C char(1),				/* Caracter C */
		@Fec_Vacia smalldatetime,	/* Fecha default */
		@Str_ComSim varchar(2),		/* comillas simples */
		@Ent_MenUno int,			/* Entero -1 */
		@Ent_Cero int,				/* Entero 0 */
		@Ent_Uno int				/* Entero 0 */		
		

select @Str_C = 'C',
       @Str_Uno		= '1',
       @Str_Dos		= '2',
       @Str_Tres	= '3',
	   @Str_Cuatro	= '4',
	   @Adm_Consej  = 753,
	   @Adm_Unico   = 754,
	   @Str_Consej  = 'CONSEJO DE ADMINISTRACION',
	   @Str_Unico   = 'ADMINISTRADOR UNICO',
	   @Fec_Vacia   = '1900-01-01',
	   @Str_ComSim  = '',
	   @Ent_MenUno	= -1,
	   @Ent_Cero	= 0,
	   @Ent_Uno		= 1
	   

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1)


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select
			Rib_Numero,		Rib_NumPer,		Rib_NumInt,		Rib_NumSol,		Rib_TipSol,
			Rib_TipRib,		Rib_FecEla,		Rib_SucSol,		Rib_ConNom,		Rib_ConPue,
			Rib_PagWeb,		Rib_ActCat,		Rib_ActEsp,		Rib_MerObj,		Rib_LlViOc,
			Rib_UsuCap,		Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,
			Rib_FeInOp,		Rib_EmOtCr,		Rib_EmSuRe,		
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Cero ELSE Rib_DurSoc END) as Rib_DurSoc,
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Uno ELSE @Ent_Cero END) as Rib_DurInd,
			Rib_CotBol,		Rib_NumApo,		Rib_NumCon,		Rib_CliSuc,		Rib_EdoCiv,
			Rib_NumExt,		Rib_LugCon,		Rib_ZonUsu, 	FechaSis
		from SORIB noholdlock
		where Rib_Numero = @Rib_Numero
	end
	else if @Tip_ConCon = @Str_Dos begin
		select
			Rib_Numero,		Rib_NumPer,		Rib_NumInt,		Rib_NumSol,		Rib_TipSol,
			Rib_TipRib,		Rib_FecEla,		Rib_SucSol,		Rib_ConNom,		Rib_ConPue,
			Rib_PagWeb,		Rib_ActCat,		Rib_ActEsp,		Rib_MerObj,		Rib_LlViOc,
			Rib_UsuCap,		Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,
			Rib_FeInOp,		Rib_EmOtCr,		Rib_EmSuRe,		
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Cero ELSE Rib_DurSoc END) as Rib_DurSoc,
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Uno ELSE @Ent_Cero END) as Rib_DurInd,
			Rib_CotBol,		Rib_NumApo,		Rib_NumCon,		Rib_CliSuc,		Rib_EdoCiv,
			Rib_NumExt,		Rib_LugCon,		Rib_ZonUsu, 	FechaSis
		from SORIB noholdlock
		where Rib_NumPer = @Rib_NumPer
		  and Rib_NumSol = @Rib_NumSol
		order by Rib_Numero
	end
	else if @Tip_ConCon = @Str_Tres begin 
		select
			Rib_Numero,		Rib_NumPer,		Rib_NumInt,		Rib_NumSol,		Rib_TipSol,
			Rib_TipRib,		Rib_FecEla,		Rib_SucSol,		Rib_ConNom,		Rib_ConPue,
			Rib_PagWeb,		Rib_ActCat,		Rib_ActEsp,		Rib_MerObj,		Rib_LlViOc,
			Rib_UsuCap,		Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,
			Rib_FeInOp,		Rib_EmOtCr,		Rib_EmSuRe,		
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Cero ELSE Rib_DurSoc END) as Rib_DurSoc,
			(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Uno ELSE @Ent_Cero END) as Rib_DurInd,
			Rib_CotBol,		Rib_NumApo,		Rib_NumCon,		Rib_CliSuc,		Rib_EdoCiv,
			Rib_NumExt,		Rib_LugCon,		Rib_ZonUsu, 	FechaSis
		from SORIB noholdlock
		where Rib_NumSol = @Rib_NumSol
		  and Rib_NumInt = @Rib_NumInt
	end
	else if @Tip_ConCon = @Str_Cuatro begin

		SELECT 	Rib_Numero, 	Rrh_NumPer, 	
				Per_Comple = replicate(@Str_ComSim , 180), 
				Rrh_AniEmp, 	Ram_ParMer, 	Ram_TiCaDi, 	Ram_MerCon, 	Ram_MedUti, 
				Ram_LocVen, 	Ram_RegVen, 	Ram_NacVen, 	Ram_ExpVen, 	Rim_TipMaq, 
				Rim_ReMeMa, 	Rim_ArrMaq, 	Rim_AnCoMa, 	Rim_FVCoMa, 	Rim_AseMaq, 
				Rim_AraMaq, 	Rim_PlPoMa, 	Rim_VePoMa, 	Rim_MoCoMa, 	Rim_MCMaMo, 
				Rim_RMMaMo, 	Rii_TipIns, 	Rii_Por, 	 	Rii_ReMeIn, 	Rii_RMInMo, 
				Rii_ArrIns, 	Rii_AnCoIn, 	Rii_VeCoIn, 	Rii_AseIns, 	Rii_AraIns, 
				Rii_PlPoIn, 	Rii_VePoIn, 	Rii_MoCoIn, 	Rii_MCInMo, 	Rii_CubInc, 
				Rii_CubTer, 	Rii_CubHur, 	Rii_CubInu, 	Rii_CubOtr, 	Rii_CuOtEs, 
				Rii_PrePor, 	Rii_RMInVa, 	Rii_RMIVaM, 	Rii_RMInPa, 	Rii_RMIPaM, 
				(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Cero ELSE Rib_DurSoc END) as Rib_Duraci,
				Rib_NumPer, Rib_TipRib,
				Adi_FecCon = @Fec_Vacia,
				Rca_TipAdm = replicate(@Str_ComSim , 180), 
				Adi_FecNac = @Fec_Vacia, Adi_FeNaAp = @Fec_Vacia,
				Adm_Comple = replicate(@Str_ComSim , 180), 
				Per_Entida = replicate(@Str_ComSim , 180),
				(CASE WHEN Rib_DurSoc = @Ent_MenUno THEN @Ent_Uno ELSE @Ent_Cero END) as Rib_Indefi,
				sor.NumTransac, sor.Transaccio, sor.Usuario, 	sor.FechaSis, 	sor.SucOrigen,
				sor.SucDestino
			into #ReporteInfBas
			FROM SORIB sor noholdlock
			LEFT JOIN SORIREHU sorh noholdlock
				ON Rrh_NumRib = Rib_Numero
			LEFT JOIN SORIASME sora noholdlock
				ON Ram_NumRib = Rib_Numero
			LEFT JOIN SORIBMAQ sorm noholdlock
				ON Rim_NumRib = Rib_Numero
			LEFT JOIN SORIBINS sori noholdlock
				ON Rii_NumRib = Rib_Numero
			Where Rib_NumPer = @Rib_NumPer
			and Rib_NumSol = @Rib_NumSol

		UPDATE #ReporteInfBas SET
			Per_Comple =  SOPERSON.Per_Comple 
			from SOPERSON noholdlock
			Where Per_Numero = @Rib_NumPer

		UPDATE #ReporteInfBas SET
			Per_Entida = CLENTIDA.Ent_Nombre
			from SOPERSON noholdlock
			INNER JOIN CLENTIDA noholdlock
				ON Ent_Numero = SOPERSON.Per_Entida
			Where Per_Numero = @Rib_NumPer

		UPDATE #ReporteInfBas SET
			Rca_TipAdm = (CASE SORICOAC.Rca_TipAdm
					WHEN @Adm_Consej THEN @Str_Consej
					WHEN @Adm_Unico THEN @Str_Unico
				 END)
			from SORICOAC noholdlock
			where Rca_NumRib = Rib_Numero

		UPDATE #ReporteInfBas SET
			Adi_FecCon =  SOPERADI.Adi_FecCon,
			Adi_FecNac	= SOPERADI.Adi_FecNac
			from SOPERADI noholdlock
			where Adi_PerNum = Rib_NumPer

		UPDATE #ReporteInfBas SET
			Adm_Comple =  SOPERSON.Per_Comple 
			from SOPERSON noholdlock
			where Per_Numero = Rrh_NumPer

		UPDATE #ReporteInfBas SET
			Adi_FeNaAp =  SOPERADI.Adi_FecNac 
			from SOPERADI noholdlock
			where Adi_PerNum = Rrh_NumPer
	
		SELECT Rib_Numero, Rrh_NumPer, Per_Comple, Rrh_AniEmp, Ram_ParMer,
		   (CASE WHEN Ram_TiCaDi IS NULL THEN @Str_ComSim ELSE Ram_TiCaDi END) as Ram_TiCaDi,
		   (CASE WHEN Ram_MerCon IS NULL THEN @Str_ComSim ELSE Ram_MerCon END) as Ram_MerCon,
		   (CASE WHEN Ram_MedUti IS NULL THEN @Str_ComSim ELSE Ram_MedUti END) as Ram_MedUti,
		   Ram_LocVen, Ram_RegVen, 
		   Ram_NacVen, Ram_ExpVen, Rim_TipMaq, Rim_ReMeMa, Rim_ArrMaq, 
		   Rim_AnCoMa, Rim_FVCoMa, Rim_AseMaq, Rim_AraMaq, Rim_PlPoMa,
		   Rim_VePoMa, Rim_MoCoMa, Rim_MCMaMo, Rim_RMMaMo, Rii_TipIns, 
		   Rii_Por,	   Rii_ReMeIn, Rii_RMInMo, Rii_ArrIns, Rii_AnCoIn, 
		   Rii_VeCoIn, Rii_AseIns, Rii_AraIns, Rii_PlPoIn, Rii_VePoIn, 
		   Rii_MoCoIn, Rii_MCInMo, Rii_CubInc, Rii_CubTer, Rii_CubHur, 
		   Rii_CubInu, Rii_CubOtr, Rii_CuOtEs, Rii_PrePor, Rii_RMInVa, 
		   Rii_RMIVaM, Rii_RMInPa, Rii_RMIPaM, Rib_Duraci, Rib_NumPer, 
		   Adi_FecCon, Rca_TipAdm, Adi_FecNac, Rrh_NumPer, Adm_Comple,
		   Adi_FeNaAp, Rpf_Politi, Rpf_DCPoCo, Rpf_DiaInv, Rpf_DiaPro,
		   Rpf_PerPic, Rpf_PerRec, Rpf_ComCic, Rpf_PolInv, Per_Entida,
		   Rib_Indefi, Rib_TipRib, sor.NumTransac, sor.Transaccio, sor.Usuario, 
		   sor.FechaSis, sor.SucOrigen, sor.SucDestino
		FROM #ReporteInfBas sor
		LEFT JOIN SORIPOFI sopf noholdlock
			ON Rpf_NumRib = Rib_Numero

		drop table  #ReporteInfBas
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select
			Rib_Numero,		Rib_NumPer,		Rib_NumInt,		Rib_NumSol,		Rib_TipSol,
			Rib_TipRib,		Rib_FecEla,		Rib_SucSol,		Rib_ConNom,		Rib_ConPue,
			Rib_PagWeb,		Rib_ActCat,		Rib_ActEsp,		Rib_MerObj,		Rib_LlViOc,
			Rib_UsuCap,		Rib_NoAlGo,		Rib_PaEnPo,		Rib_CabCon,		Rib_FeCaPo,
			Rib_FeInOp,		Rib_EmOtCr,		Rib_EmSuRe,		Rib_DurSoc,		Rib_CotBol,
			Rib_NumApo,		Rib_NumCon,		Rib_CliSuc,		Rib_EdoCiv,		Rib_NumExt,
			Rib_LugCon,		Rib_ZonUsu, 	FechaSis
     from SORIB noholdlock
     where	Rib_NumSol = @Rib_NumSol
   end
end