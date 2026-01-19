CREATE PROCEDURE SOUSNAEXREP(
	@Une_Identi	int,
	@Sucursal	char(3),
	@FechaIni	smalldatetime,
	@FechaFin	smalldatetime,
	@Une_Estatu	char(1),
	
	@numtransac	char(10),
	@transaccio	char(3),
	@usuario	char(6),
	@fechasis	smalldatetime,
	@sucorigen	char(3),
	@sucdestino	char(3),
	@modulo		char(2)
)
as

	/***********************************************************************************
	** Descripcion:		Reporte de Usuarios de Divisas por Sucursal.				****
	************************************************************************************
	** Referencias:
	************************************************************************************
	** Modifico:			Francisco Javier Minajas Carbajal						****
	** Fecha:			19/Enero/2026												****
	** Jira:			TRAAC-9198													****
	** Descripción:		La realiza la consulta a SOBITPER y SOBIUSEX, para obtener  ****
	*					la fecha de modificacion									**** 
	************************************************************************************
	** Modifico:			Ezequiel Gonzalez Cobix									****
	** Fecha:			03/Noviembre/2022											****
	** Help:			TRAAC-933													****
	** Descripción:		La consulta regresa la nacionalidad							**** 
	************************************************************************************
	** Creo:			Ezequiel Gonzalez Cobix										****
	** Fecha:			06/Octubre/2022												****
	** Req.	:			TRAAC-851													****
	** Descripción:		Creación de SP												**** 
	************************************************************************************/
	
	/* Declaracion de constantes  */
	declare	@Str_Vacio	char(1),
			@Ent_Cero	int,
			@Str_Inacti	char(1),
			@Str_Activo	char(1),
			@Str_Cancel	char(1),
			@Fec_Vacia	smalldatetime,
			@Des_Inacti	char(8),
			@Des_Activo	char(6),
			@Des_Cancel	char(9),
			@Tab_OriUno	char(1),
			@Tab_OriDos	char(2),
			@Ent_Tres	int,
			@Ent_VeiTre	int,
			@Ent_CinNue	int,
			@Str_Nacion char(8),
			@Str_Extran	char(10)

	/* Declaracion de variables */
	declare	@Conteo		int,
			@Val_Fecha  smalldatetime,
			@IdeUsuario	int,
			@Estatus	char(1),
			@Fec_Fin	smalldatetime
	
	/* Asignacion de constantes*/	
	select	@Str_Vacio	=	'',				/*Cadena vacia*/
			@Ent_Cero	=	0,				/*Entero cero*/
			@Str_Inacti	=	'I',			/*Estatus de inactivo*/
			@Str_Activo	=	'A',			/*Estatus de activo*/
			@Str_Cancel	=	'C',			/*Estatus de cancelado*/
			@Fec_Vacia	=	'1900-01-01',	/*Fecha Vacia*/
			@Des_Inacti	=	'Inactivo',		/*Descripción de estatus inactivo*/
			@Des_Activo	=	'Activo',		/*Descripción de estatus activo*/
			@Des_Cancel	=	'Cancelado',	/*Descripción de estatus Cancelado*/
			@Tab_OriUno	=	'1',			/*Tabla origen 1 SOPERSON*/
			@Tab_OriDos	=	'2',			/*Tabla origen 1 SOUSREXT*/
			@Ent_Tres   =	3, 				/* Entero tres */
			@Ent_VeiTre	=	23,				/* Entero Veintitres*/
			@Ent_CinNue	=	59,				/* Entero Cincuenta y nueve*/
			@Str_Nacion	=	'NACIONAL',		/* descripción nacional */
			@Str_Extran	=	'EXTRANJERO'	/* descripción extranjero*/			
			
	/* Asignacion de variables */

	
	--Se obtiene el rango limite para fecha
	select @Val_Fecha	=	dateadd(month, @Ent_Tres, @FechaIni)
	select @IdeUsuario	=	@Une_Identi
	select @Estatus		=	@Une_Estatu
	select @Fec_Fin		=   dateadd(second,@Ent_CinNue,dateadd(minute,@Ent_CinNue,dateadd(hour, @Ent_VeiTre, @FechaFin)))
	
	--Se evalua rango de fechas
	if @FechaFin > @Val_Fecha
	begin
	select	Err_Codigo	= '000001', 
			Err_Mensaj	= 'Ha sobrepasado el rango de fechas',
			Err_Variab	= 'FechaIni, FechaFin' 
			rollback
			return 1
	end	
	

	Create Table #UltimoEstatus(
	Numero						int identity not 	null,
	Folio						int					null,
	FechaEstatus				smalldatetime		null,
	Consecutivo					int					null
	)
	
	create nonclustered index TmpUltFolio on #UltimoEstatus (Folio)
	
	Create Table #UltimoEstatuResp(
	Numero						int identity not 	null,
	Folio						int					null,
	FechaEstatus				smalldatetime		null,
	Consecutivo					int					null,
	)
	
	create nonclustered index TmpUlEsReFolio on #UltimoEstatuResp (Folio)
	
	create Table #RegUltEstatus(
	Numero						int identity not 	null,
	Folio						int					null,
	Estatus						char(1)				null,
	FechaEstatus				smalldatetime		null,
	Consecutivo					int					null,
	FechaMenor					smalldatetime		null
	)
	create nonclustered index TmpRegUltEstEst on #RegUltEstatus (Estatus, Folio)	
	
	Create Table #RegistroDeEstatus(
	Numero						int identity not 	null,
	Folio						int					null,
	Estatus						char(1)				null,
	FechaEstatus				smalldatetime		null,
	Usuario						char(6)				null,
	Sucursal					char(3)				null,
	DescripcionEstatus			char(180)			null,
	NombreUsuario				char(50)			null,
	Consecutivo					int					null,
	FechaMenor					smalldatetime		null	
	)
	
	create nonclustered index TmpRegFolio on #RegistroDeEstatus (Folio)	
	create nonclustered index TmpRegEstatus on #RegistroDeEstatus (Estatus,Folio)
	
	
	Create Table #UsuariosDivisa(
	Numero						int identity not 	null,
	Folio						int					null
	)
	create nonclustered index TmpUsuFolio on #UsuariosDivisa (Folio)
	
	Create Table #ReporteUsuarioDivisa(
	Numero						int identity not 	null,
	Sucursal					char(3)				null,
	IdeUsuario					int					null,
	Nombre						varchar(180)		null,	
	Estatus						char(9)				null,
	NombreRegistro				varchar(180)		null,
	NombreActivo				varchar(180)		null,
	NombreCancelo				varchar(180)		null,
	MotivoCancelacion			varchar(180) 		null,		
	FechaRegistro				smalldatetime		null,
	FechaActivo					smalldatetime		null,
	FechaCancela				smalldatetime		null,
	TablaOrigen					char(1)				null,
	IdUsuTabla					int					null,
	SucursalInactivo			char(3)				null,
	SucursalActivo				char(3)				null,
	SucursalCancelado			char(3)				null,
	IdentificadorPersona		int					null,
	FechaModificacion			smalldatetime		null
	)
	
	--Se valida trae id de usuario de divisa
	if isnull(@IdeUsuario,@Ent_Cero) <> @Ent_Cero begin
		--Se obtiene información del usuario de divisa, validando información en la bitacora de usuario de divisa
		Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
		Select distinct Biu_FolUsu, Biu_FecEst, Biu_Consec
		from SOUSNAEX noholdlock
		inner join SOBITUSU noholdlock on ( Biu_Estatu =  Une_Estatu  and Une_Identi = SOBITUSU.Biu_FolUsu)
		where   Une_Identi 	=	@IdeUsuario
		order by Biu_FecEst
		
		select @Conteo = count(*) from #UltimoEstatus noholdlock
		
		if isnull(@Conteo,@Ent_Cero)=@Ent_Cero begin
			--Si no hay información de bitacora se obtiene la información de SOUSNAEX
			Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			Select  Une_Identi,  Une_FecEst , Une_Consec 
			from SOUSNAEX  noholdlock
			where   Une_Identi  =	@IdeUsuario

			insert into #UsuariosDivisa(Folio)
			Select distinct Folio
			from #UltimoEstatus noholdlock 			
			
			Insert into #RegistroDeEstatus(Folio, Estatus, FechaEstatus, Usuario, Sucursal, DescripcionEstatus, NombreUsuario, Consecutivo, FechaMenor)
			Select  Une_Identi,  Une_Estatu ,   Une_FecEst , @Str_Vacio,	@Str_Vacio,	@Str_Vacio, @Str_Vacio, Une_Consec, Une_FecEst  
			from SOUSNAEX  noholdlock
			where  Une_Identi	=	@IdeUsuario
			
		end else begin
			Insert into #RegUltEstatus (Folio,	Estatus,	FechaEstatus,	Consecutivo, FechaMenor)
			Select  Biu_FolUsu,  Biu_Estatu, Max(Biu_FecEst), Max(Biu_Consec), min(Biu_FecEst)  
			from SOBITUSU noholdlock
			Inner join #UltimoEstatus noholdlock on (Folio= Biu_FolUsu)
			group by Biu_FolUsu,  Biu_Estatu			
			
			insert into #UsuariosDivisa(Folio)
			Select distinct Folio
			from #RegUltEstatus noholdlock 		
			
			--se obtiene los otros cambios de estatus para saber quien realizó el cambio y cuando.
			Insert into #RegistroDeEstatus(Folio, Estatus, FechaEstatus, Usuario, Sucursal, DescripcionEstatus, NombreUsuario, Consecutivo, FechaMenor)
			Select Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, Biu_DesEst,  Usu_Nombre,	 Biu_Consec,	FechaMenor 
			from SOBITUSU noholdlock
			inner join #RegUltEstatus noholdlock on (Consecutivo	=	Biu_Consec)
			left outer join SOUSUARI noholdlock on ( Usu_Numero =  Biu_Usuari )				
		end
	
	end else begin
		Insert into #UltimoEstatuResp(Folio, FechaEstatus, Consecutivo)
		Select Biu_FolUsu, max(Biu_FecEst), max(Biu_Consec) from (
			Select   Biu_FolUsu,  Biu_FecEst, Biu_Consec
			from SOBITUSU noholdlock 
			where SOBITUSU.Biu_FecEst  between @FechaIni and  @Fec_Fin 
		) as tabla
		group by Biu_FolUsu
		order by max(Biu_FecEst)		
	
	
		--Se valida si no trae sucursal ni estatus
		if ((isnull(@Sucursal,@Str_Vacio)=@Str_Vacio) and (isnull(@Estatus,@Str_Vacio)=@Str_Vacio) ) begin
			/*Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			select Folio, FechaEstatus, Consecutivo 
			from #UltimoEstatuResp*/
			Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			Select Biu_FolUsu,  Biu_FecEst, Biu_Consec
			from SOBITUSU noholdlock 
			inner join #UltimoEstatuResp UlEsRe noholdlock on (UlEsRe.Consecutivo	=	SOBITUSU. Biu_Consec )
			Inner join SOUSNAEX noholdlock on ( Une_Estatu = SOBITUSU.Biu_Estatu and   Biu_FolUsu =  Une_Identi )

		end else if ((isnull(@Sucursal,@Str_Vacio)<>@Str_Vacio) and (isnull(@Estatus,@Str_Vacio)=@Str_Vacio)) begin
			--Se valida si no trae estatus y si trae sucursal
			Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			Select Biu_FolUsu,  Biu_FecEst, Biu_Consec
			from SOBITUSU noholdlock 
			inner join #UltimoEstatuResp UlEsRe noholdlock on (UlEsRe.Consecutivo	=	SOBITUSU. Biu_Consec )
			Inner join SOUSNAEX noholdlock on ( Une_Estatu = SOBITUSU.Biu_Estatu and   Biu_FolUsu =  Une_Identi )
			where SOBITUSU.Biu_Sucurs	=	@Sucursal
		end else if ((isnull(@Sucursal,@Str_Vacio)=@Str_Vacio) and (isnull(@Estatus,@Str_Vacio)<>@Str_Vacio)) begin
			--Se valida si no trae sucursal y si trae estatus
			Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			Select Biu_FolUsu,  Biu_FecEst, Biu_Consec
			from SOBITUSU noholdlock 
			inner join #UltimoEstatuResp UlEsRe noholdlock on (UlEsRe.Consecutivo	=	SOBITUSU. Biu_Consec )
			Inner join SOUSNAEX noholdlock on ( Une_Estatu = SOBITUSU.Biu_Estatu and   Biu_FolUsu =  Une_Identi )
			where SOBITUSU.Biu_Estatu 	=	@Estatus
		end else if ((isnull(@Sucursal,@Str_Vacio)<>@Str_Vacio) and (isnull(@Estatus,@Str_Vacio)<>@Str_Vacio)) begin
			---Se valida si trae estatus y sucursal.	
			Insert into #UltimoEstatus(Folio, FechaEstatus, Consecutivo)
			Select Biu_FolUsu,  Biu_FecEst, Biu_Consec
			from SOBITUSU noholdlock 
			inner join #UltimoEstatuResp UlEsRe noholdlock on (UlEsRe.Consecutivo	=	SOBITUSU. Biu_Consec )
			Inner join SOUSNAEX noholdlock on ( Une_Estatu = SOBITUSU.Biu_Estatu and   Biu_FolUsu =  Une_Identi )
			where SOBITUSU.Biu_Sucurs	=	@Sucursal
				and SOBITUSU.Biu_Estatu =	@Estatus
		end
		
		Insert into #RegUltEstatus (Folio,	Estatus,	FechaEstatus,	Consecutivo, FechaMenor)
		Select  Biu_FolUsu,  Biu_Estatu, Max(Biu_FecEst), Max(Biu_Consec), Min(Biu_FecEst)  
		from SOBITUSU noholdlock
		Inner join #UltimoEstatus noholdlock on (Folio= Biu_FolUsu)
		group by Biu_FolUsu,  Biu_Estatu
		
		insert into #UsuariosDivisa(Folio)
		Select distinct Folio
		from #RegUltEstatus noholdlock 		
		
		--se obtiene los otros cambios de estatus para saber quien realizó el cambio y cuando.
		Insert into #RegistroDeEstatus(Folio, Estatus, FechaEstatus, Usuario, Sucursal, DescripcionEstatus, NombreUsuario, Consecutivo, FechaMenor)
		Select Biu_FolUsu, Biu_Estatu, Biu_FecEst, Biu_Usuari, Biu_Sucurs, Biu_DesEst,  Usu_Nombre,  Biu_Consec,	FechaMenor   
		from SOBITUSU noholdlock
		inner join #RegUltEstatus noholdlock on (Consecutivo	=	Biu_Consec /*Folio	=	Biu_FolUsu and Biu_Estatu=Estatus and FechaEstatus= Biu_FecEst and*/ )
		left outer join SOUSUARI noholdlock on ( Usu_Numero =  Biu_Usuari )		
		
	end
	
	--Se termina de obtener la información solicitada para el reporte de usuario de divisa
	insert into #ReporteUsuarioDivisa(Sucursal, IdeUsuario, Nombre, Estatus, NombreRegistro, NombreActivo, NombreCancelo, MotivoCancelacion, FechaRegistro,	
										FechaCancela, TablaOrigen, IdUsuTabla, SucursalInactivo, SucursalActivo, SucursalCancelado, FechaActivo)
	Select @Str_Vacio,
		 SOUSNAEX.Une_Identi  , 
		 @Str_Vacio , 
		 case SOUSNAEX.Une_Estatu when @Str_Inacti then @Des_Inacti when @Str_Activo then @Des_Activo when @Str_Cancel then @Des_Cancel end , 
		 @Str_Vacio , 
		 @Str_Vacio , 
		 @Str_Vacio ,
		 @Str_Vacio , 
		 @Fec_Vacia ,   
		 @Fec_Vacia ,
		 Une_TabOri, Une_IdeUsu, @Str_Vacio, @Str_Vacio, @Str_Vacio, @Fec_Vacia 
	from #UsuariosDivisa UsuDivisa  noholdlock  
	inner join SOUSNAEX  noholdlock on (UsuDivisa.Folio	=	SOUSNAEX.Une_Identi)

	
	
	Update #ReporteUsuarioDivisa
		set #ReporteUsuarioDivisa.Nombre	=	SOPERSON.Per_Comple, 	#ReporteUsuarioDivisa.IdentificadorPersona = SOPERSON.PerPersoID
		from #ReporteUsuarioDivisa
		inner join SOPERSON noholdlock on (PerPersoID = #ReporteUsuarioDivisa.IdUsuTabla)
		where #ReporteUsuarioDivisa.TablaOrigen	=	@Tab_OriUno
	
	Update #ReporteUsuarioDivisa
		set #ReporteUsuarioDivisa.Nombre	=	SOUSUEXT.Use_NoCoUs,	#ReporteUsuarioDivisa.IdentificadorPersona = SOUSUEXT.Use_IdUsEx	
		from #ReporteUsuarioDivisa
		inner join SOUSUEXT noholdlock on (Use_IdUsEx = IdUsuTabla)
		where TablaOrigen	=	@Tab_OriDos
	
	Update #ReporteUsuarioDivisa
		set #ReporteUsuarioDivisa.NombreRegistro		=	RegIna.NombreUsuario,
				#ReporteUsuarioDivisa.SucursalInactivo	= 	RegIna.Sucursal,
				#ReporteUsuarioDivisa.FechaRegistro		=	RegIna.FechaEstatus  
		from #ReporteUsuarioDivisa
		left outer join #RegistroDeEstatus  RegIna noholdlock on (#ReporteUsuarioDivisa.IdeUsuario 	=	RegIna.Folio and RegIna.Estatus	=	@Str_Inacti )
		where RegIna.Folio is not null
		
	Update #ReporteUsuarioDivisa
		set #ReporteUsuarioDivisa.NombreActivo			=	RegAct.NombreUsuario,
				#ReporteUsuarioDivisa.SucursalActivo	=	RegAct.Sucursal,
				#ReporteUsuarioDivisa.FechaActivo		=	RegAct.FechaEstatus 
		from #ReporteUsuarioDivisa
		left outer join #RegistroDeEstatus  RegAct noholdlock on (#ReporteUsuarioDivisa.IdeUsuario 	=	RegAct.Folio and RegAct.Estatus	=	@Str_Activo	)
		where RegAct.Folio is not null		
		
	Update #ReporteUsuarioDivisa
		set #ReporteUsuarioDivisa.NombreCancelo			=	RegCan.NombreUsuario,
				#ReporteUsuarioDivisa.SucursalCancelado	=	RegCan.Sucursal,
				#ReporteUsuarioDivisa.FechaCancela		=	RegCan.FechaEstatus,
				#ReporteUsuarioDivisa.MotivoCancelacion	=	RegCan.DescripcionEstatus
		from #ReporteUsuarioDivisa
		left outer join #RegistroDeEstatus  RegCan noholdlock on (#ReporteUsuarioDivisa.IdeUsuario 	=	RegCan.Folio and RegCan.Estatus	=	@Str_Cancel	)
		where RegCan.Folio is not null		
		
	Update #ReporteUsuarioDivisa
		set Sucursal = case Estatus when @Des_Inacti then SucursalInactivo when @Des_Activo then SucursalActivo when @Des_Cancel then SucursalCancelado end
	
	/* --- OPTIMIZACIÓN PARA NACIONALES --- */
	
	-- Paso 1: Obtener solo los Per_Numero que están en mi reporte actual
	SELECT DISTINCT P.Per_Numero
	INTO #IDsNacReporte
	FROM #ReporteUsuarioDivisa R
	INNER JOIN SOPERSON P noholdlock ON R.IdentificadorPersona = P.PerPersoID
	WHERE R.TablaOrigen = @Tab_OriUno
	
	-- Paso 2: Buscar en bitácora SOLO para esos IDs (Esto reducirá el tiempo drásticamente)
	SELECT B.Bit_NumPer, MAX(B.Bit_Fecha) AS UltimaFecha
	INTO #MaxFechasNac
	FROM SOBITPER B noholdlock
	INNER JOIN #IDsNacReporte I ON B.Bit_NumPer = I.Per_Numero
	GROUP BY B.Bit_NumPer
	
	-- Paso 3: Actualizar directamente la tabla de reporte
	UPDATE #ReporteUsuarioDivisa
	SET #ReporteUsuarioDivisa.FechaModificacion = M.UltimaFecha
	FROM #ReporteUsuarioDivisa
	INNER JOIN SOPERSON P noholdlock ON #ReporteUsuarioDivisa.IdentificadorPersona = P.PerPersoID
	INNER JOIN #MaxFechasNac M ON P.Per_Numero = M.Bit_NumPer
	WHERE #ReporteUsuarioDivisa.TablaOrigen = @Tab_OriUno
	
	-- Limpieza inmediata de temporales de apoyo
	DROP TABLE #IDsNacReporte
	DROP TABLE #MaxFechasNac
	
	
	/* --- OPTIMIZACIÓN PARA EXTRANJEROS --- */
	
	-- Paso 1: Buscar fechas máximas filtrando directamente por los IDs del reporte
	SELECT B.Bue_IdUsEx, MAX(B.Bue_FecCre) AS UltimaFecha
	INTO #MaxFechasExt
	FROM SOBIUSEX B noholdlock
	INNER JOIN #ReporteUsuarioDivisa R ON B.Bue_IdUsEx = R.IdentificadorPersona
	WHERE R.TablaOrigen = @Tab_OriDos
	GROUP BY B.Bue_IdUsEx
	
	-- Paso 2: Actualizar directamente la tabla de reporte
	UPDATE #ReporteUsuarioDivisa
	SET #ReporteUsuarioDivisa.FechaModificacion = M.UltimaFecha
	FROM #ReporteUsuarioDivisa
	INNER JOIN #MaxFechasExt M ON #ReporteUsuarioDivisa.IdentificadorPersona = M.Bue_IdUsEx
	WHERE #ReporteUsuarioDivisa.TablaOrigen = @Tab_OriDos
	
	-- Limpieza inmediata
	DROP TABLE #MaxFechasExt
	
	
	select	Sucursal,								IdeUsuario as Une_Identi,			upper(Nombre) Nombre,						Upper(Estatus) Estatus,		
			Upper(NombreRegistro) NombreRegistro, 	Upper(NombreActivo) NombreActivo,	Upper(NombreCancelo) NombreCancelo,			Upper(MotivoCancelacion) MotivoCancelacion,	
			FechaRegistro,							FechaCancela, 						FechaActivo, 
			case when TablaOrigen = @Tab_OriUno then @Str_Nacion  else @Str_Extran end as Biu_Pais, FechaModificacion 
	from #ReporteUsuarioDivisa
	Order by Sucursal, IdeUsuario
	
	--Se borrar tabla
	drop table #UltimoEstatus, #RegistroDeEstatus, #ReporteUsuarioDivisa, #UltimoEstatuResp, #RegUltEstatus, #UsuariosDivisa
	