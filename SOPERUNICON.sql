create procedure SOPERUNICON (
	@Per_Numero	char(8),
	@Per_Fecha	smalldatetime,
	@Per_NumTra	char(10),
	@Per_RFC	char(15),
	@Per_Comple	varchar(180),
	
	@Per_Client	char(8),
	@Per_TipPar	int,
	@Per_Modulo	char(1),
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
** DESCRIPCION: Consulta de Persona Unica						  **
********************************************************************
** ModificÓ:	Francisco Javier Carrillo Rojas					****
** Fecha:		24/Nov/2018										****
** Help:		01171269										****
** Descripcion:	Agregar salida de a Per_Email, Per_Tipo,		****
**				Per_Nombre,	Per_ApePat y Per_ApeMat a C5		****
********************************************************************
** Modifico:	Francisco Javier Carrillo Rojas					****
** Fecha:		29/10/2018										****
** Help:		1147468											****
** Descripcion:	Se agrega salida de campos Adi_FeExId, Adi_Sexo	****
**				y Adi_FecNac a C5 y L5, agregar L7				****
********************************************************************
** Modifico:	Erick Gloria							        ****
** Fecha:		28/05/2018										****
** Help:		1114960 										****
** Descripcion:	Consulta L6 documentos por Persona (Modulo ADN) ****
********************************************************************
** Modifico:	Omar Zamora										****
** Fecha:		18/05/2018										****
** Help:		1105919											****
** Descripcion:	Se agrega el tipo de consulta C6				****
********************************************************************
** Modifico:	Francisco Javier Carrillo Rojas					****
** Fecha:		12/03/2018										****
** Help:		1020500											****
** Descripcion:	Se agrega el tipo de consulta C5 y L5			****
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		13/09/2017										****
** Help:		929417 											****
** Descripcion:	Optimizacion por consulta de documentos	L3 		****
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		13/02/2017										****
** Help:		897438 											****
** Descripcion:	Agrega L4 para obtener cliente y persona unificada**
********************************************************************
** Modifico:	Claudia V Sandoval P							****
** Fecha:		03/10/2016										****
** Help:		903360 											****
** Descripcion:	Agrega C2, C3 y L2								****
********************************************************************
** Modifico:	Marcelo Bautista   								****
** Fecha:		19/Oct/2016										****
** Help:		895469											****
** Descripcion:	Se agrega consulta C4							****
********************************************************************
** Modifico:	Vanesa Herrera									****
** Fecha:		21/Jun/11										****
** Help:		388789											****
** Descripcion:	Consulta de Persona Unica						****
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1), /* Consulta Tipo C/L*/
		@Tip_ConCon	char(1), /* Tipo Consecutivo */
		@Cli_Numero	char(8), /* Cliente Numero */
		@Adi_NumPer	char(8), /* Adicional Numero Persona */
		@Per_Grupo	char(8), /* Persona Grupo */
		@Cli_Unific	char(8), /* Cliente Unificado */
		@Int_Existe	int,     /* Existe */
		@Str_PeuNom	varchar(150) /* Persona unica Nombre */

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1), /* Vacio */
		@Str_C		char(1), /* Tipo C */
		@Str_I		char(1), /* Tipo I */
		@Str_B		char(1), /* Tipo B */
		@Str_Uno	char(1), /* Tipo 1 */
		@Str_Dos	char(1), /* Tipo 2 */
		@Str_Tres	char(1), /* Tipo 3 */
		@Str_Cuatro	char(1), /* Tipo 4 */
		@Sta_Activo	char(1), /* Activo */
		@Ent_Si		int,     /* Si - 1 */
		@Ent_No		int,     /* No - 0 */
		@Str_Porcen	char(1), /* String porcentaje % */
		@Str_Cinco	char(1), /* Tipo 5 */
		@Str_Seis	char(1), /* Tipo 6 */
		@Str_Siete	char(1)	 /* Tipo 7 */

/* Asignacion de Constantes */
select	@Str_Vacio	= '',
		@Str_C		= 'C',
		@Str_I		= 'I',
		@Str_B		= 'B',
		@Str_Uno	= '1',
		@Str_Dos	= '2',
		@Str_Tres	= '3',
		@Str_Cuatro	= '4',
		@Sta_Activo	= 'A',
		@Ent_Si		= 1,
		@Ent_No		= 0,
		@Str_Porcen	= '%',
		@Str_Cinco	= '5',
		@Str_Seis	= '6',
		@Str_Siete	= '7'

select	@Str_PeuNom	= ltrim(rtrim(@Per_Comple)) + @Str_Porcen

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin

	if @Tip_ConCon	= @Str_Uno begin
		select	Per_Numero,		Per_Fecha,		Per_NumTra,		Per_Tipo,		Per_Benefi,
				Per_NuSeFi,		Per_Titulo,		Per_Nombre,		Per_ApePat,		Per_ApeMat,
				Per_RazSoc,		Per_Comple,		Per_ComOrd,		Per_RFC,		Per_CURP,
				Per_Calle,		Per_CalNum,		Per_Coloni,		Per_Entida,		Per_Locali,
				Per_CodPos,		Per_ApaPos,		Per_LadTel,		Per_Telefo,		Per_Email,
				Per_ComDom,		Per_EstCiv,		Per_Nacion,		Per_ActEmp,		Per_Giro,
				Per_Sector,		Per_Activi,		Per_ActINE,		Adi_PerNum,		Adi_Fecha,
				Adi_NumTra,		Adi.Adi_LugNac,	Adi.Adi_Sexo,	Adi.Adi_FecNac,	Adi_RegMat,
				Adi_VivCas,		Adi_TieRes,		Adi_Fax,		Adi_NumDep,		Adi.Adi_Puesto,
				Adi_Ocupac,		Adi_AntLab,		Adi.Adi_LugTra,	Adi.Adi_TelTra,	Adi_CalTra
				Adi_NuCaTr,		Adi_ColTra,		Adi_Locali,		Adi_CPTra,		Adi_FecCon,
				Adi_CaNuIn,		Adi_NacExt,		Adi.Adi_Reside,	Adi.Adi_DocEst,	Adi_OtDoEs,
				Adi.Adi_FeExDo,	Adi.Adi_CalInm,	Adi.Adi_CalExt,	Adi.Adi_CaNuEx,	Adi.Adi_ColExt,
				Adi.Adi_LocExt,	Adi.Adi_EntExt,	Adi.Adi_PaiExt,	Adi.Adi_CoPoEx,	Adi_TelExt,
				Adi_TipIde,		Adi_OtrIde,		Adi_NumIde,		Adi_FeExId,		Adi_FeVeId,
				Adi_NuIdFi,		Adi.Adi_EntPri,	Adi.Adi_EntSeg,	Per_Client = Adi_Client
			from SOPERSON noholdlock
			join SOPERADI Adi noholdlock  on Adi_PerNum = Per_Numero
			left join CLADICIO noholdlock on Adi_NumPer = Per_Numero
			where	Per_Numero	= @Per_Numero
	end

	if @Tip_ConCon	= @Str_Dos begin /* C2 - Consulta de Persona Base de una persona a consultar*/
		select	@Per_Grupo = @Per_Numero
		
		select	@Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = @Per_Numero

		select	Per_Numero,	Per_Comple,	Per_RFC,	P.Adi_FecNac,	Adi_FecCon,
				Per_Client = Adi_Client
			from SOPERSON noholdlock
			inner join SOPERADI P noholdlock on Adi_PerNum = Per_Numero
			inner join CLADICIO C noholdlock on Adi_NumPer = Per_Numero
			where	Per_Numero = @Per_Grupo
	end

	if @Tip_ConCon	= @Str_Tres begin /* C3 - Consulta de Persona Base por Cliente */
		select Per_Person = Adi_NumPer, Per_Grupo = Adi_NumPer
			into #tmpPerso03
			from CLADICIO noholdlock
			where  Adi_Client = @Per_Client

		update #tmpPerso03 set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		select	distinct
				Per_Numero,	Per_Comple,	Per_RFC,	Adi_FecNac,	Adi_FecCon,
				Per_Client = @Per_Client
			from #tmpPerso03
			inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
			inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero

		drop table #tmpPerso03
	end

	if @Tip_ConCon	= @Str_Cuatro begin
		select	@Cli_Numero	= Cli_Numero
			from CLCLIENT noholdlock
			where	Cli_RFC	= @Per_RFC

		select	@Cli_Numero	= isnull(@Cli_Numero, @Str_Vacio)

		select	@Adi_NumPer	= Adi_NumPer
			from CLADICIO noholdlock
			where	Adi_Client	= @Cli_Numero

		select	@Adi_NumPer	= isnull(@Adi_NumPer, @Str_Vacio)

		select	isnull(Peu_Grupo, @Str_Vacio) as Per_Numero
			from SOUNIPER noholdlock
			where	Peu_Person	= @Adi_NumPer

	end

	if @Tip_ConCon	= @Str_Cinco begin /* C5 - Consulta de Persona con base al registro en persona unica*/
		select	@Per_Grupo = @Per_Numero
		
		select	@Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = @Per_Numero

		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC, Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Adi_FeExId,	Adi_Sexo,
				Adi_FecNac,	Per_Email,	Per_Tipo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat
			from SOPERSON noholdlock
			inner join SOPERADI P noholdlock on Adi_PerNum = Per_Numero
			where	Per_Numero = @Per_Grupo
	end
	if @Tip_ConCon	= @Str_Seis begin /* C6 - Consulta de Personas pertenecientes a un grupo*/
		select	@Per_Grupo = @Per_Numero
		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC, Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt				
			from SOPERSON noholdlock
			inner join SOPERADI P noholdlock on (Adi_PerNum = Per_Numero)
			inner join SOUNIPER noholdlock on (Peu_Person = Per_Numero)			
			where	Peu_Grupo = @Per_Grupo
	end
end else begin

	if @Tip_ConCon	= @Str_Uno begin
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_Client = Adi_Client
			from SOPERSON noholdlock
			left join CLADICIO noholdlock on Adi_NumPer = Per_Numero
			where	Per_RFC	= @Per_RFC
		
	end

	if @Tip_ConCon	= @Str_Dos begin /* L2 - Consulta de Personas Bases por nombre */
		select Per_Person = Per_Numero, Per_Grupo = Per_Numero
			into #tmpPerso02
			from SOPERSON noholdlock
			where	Per_Comple like @Str_PeuNom

		update #tmpPerso02 set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		select	distinct
				Per_Numero,	Per_Comple,	Per_RFC,	Adi.Adi_FecNac,	Adi_FecCon,
				Per_Client = Adi_Client
			from #tmpPerso02
			inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
			inner join SOPERADI Adi noholdlock on Adi_PerNum = Per_Numero
			 left join CLADICIO noholdlock on Adi_NumPer = Per_Numero

		drop table #tmpPerso02
	end

	if @Tip_ConCon	= @Str_Tres begin /* L3 - Consulta de todos los documentos por Persona */
		if @Per_Numero = @Str_Vacio begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= 'El Numero de persona esta vacio',
					Err_Variab	= 'Per_Numero'
			return 1
		end
		create table #tmpPersoL3 (
			Per_Person char(8)
		)
		create index #tmpPersoL3 on #tmpPersoL3 (Per_Person)

		create table #tmpClienL3 (
			Cli_Client char(8),
			Cli_Unific char(8)
		)
		create index #tmpClienL3 on #tmpClienL3 (Cli_Client)

		create table #documentosBit (
			Bad_Numero int,
			Bad_Bandej int,
			Bad_Docume int,
			Bad_Status char(1),
			Bad_Archiv varchar(50),
			Bad_PidCM  varchar(200),
			Ban_Person char(8)
		)
		create index #documentosBit on #documentosBit (Bad_Docume)

		create table #ultimosDoctos (
			Tip_Docume int,
			Max_Docume int
		)
		create index #ultimosDoctos on #ultimosDoctos (Tip_Docume)

		select	@Per_Grupo = @Per_Numero

		select	@Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = @Per_Numero

		insert into #tmpPersoL3
			select	Peu_Person
				from SOUNIPER noholdlock
				where	Peu_Grupo = @Per_Grupo

		select	@Int_Existe = @Ent_No
		select	@Int_Existe = count(1)
			from #tmpPersoL3

		if @Int_Existe = @Ent_No
			insert into #tmpPersoL3
				values (@Per_Grupo)

		insert into #tmpClienL3
			select	Adi_Client,	@Str_Vacio
				from CLADICIO noholdlock
				inner join #tmpPersoL3 on Adi_NumPer = Per_Person

		update #tmpClienL3 set
			Cli_Unific = Clu_Grupo 
			from CLCLIUNI noholdlock
			where Clu_Client = Cli_Client

		select @Cli_Unific = Cli_Unific
			from #tmpClienL3

		select	Ban_Numero,	Ban_Person
			into #documentosBitPer 
			from #tmpPersoL3 
			inner join DXBANDEJ noholdlock on Ban_Person = Per_Person
		
		create index #documentosBitPer on #documentosBitPer (Ban_Numero)
		
		select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
				Bad_PidCM,	Ban_Person
			into #documentosBitPerDoc
			from #documentosBitPer 
			inner join DXBANDOC noholdlock on Bad_Bandej = Ban_Numero 
			
		create index #documentosBitPerDoc on #documentosBitPerDoc (Bad_Status, Bad_Docume)
		
		insert into #documentosBit
			select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
					Bad_PidCM,	Ban_Person
				from #documentosBitPerDoc
				inner join DXDOCPAR noholdlock on Dop_TipDoc = Bad_Docume 
											  and Dop_TipPar = @Per_TipPar 
											  and Dop_Modulo = @Per_Modulo
				where Bad_Status not in (@Str_I, @Str_B)
		
		drop table #documentosBitPer, #documentosBitPerDoc
		
		select	Ban_Numero,	Ban_Person, Ban_Client
			into #documentosBitCli
			from #tmpClienL3 
			inner join DXBANDEJ noholdlock on Ban_Client = Cli_Client

		create index #documentosBitCli on #documentosBitCli (Ban_Numero)
		
		select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
				Bad_PidCM,	Ban_Person
			into #documentosBitCliDoc
			from #documentosBitCli 
			inner join DXBANDOC noholdlock on Bad_Bandej = Ban_Numero 
		
		create index #documentosBitCliDoc on #documentosBitCliDoc (Bad_Status, Bad_Docume)
		
		insert into #documentosBit
			select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
					Bad_PidCM,	Ban_Person
				from #documentosBitCliDoc 
				inner join DXDOCPAR noholdlock on Dop_TipDoc = Bad_Docume 
											  and Dop_TipPar = @Per_TipPar 
											  and Dop_Modulo = @Per_Modulo
				where Bad_Status not in (@Str_I, @Str_B)
		
		drop table #documentosBitCli, #documentosBitCliDoc
		
		insert into #ultimosDoctos
			select	Tip_Docume = Bad_Docume,
					Max_Docume = max(Bad_Numero)
				from #documentosBit
				group by Bad_Docume

		select	distinct
				Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Archiv, Bad_PidCM,
				Tid_Nombre, Ban_Person = @Per_Grupo, Per_Client = @Cli_Unific
			from #documentosBit 
			inner join #ultimosDoctos on Tip_Docume = Bad_Docume
									 and Max_Docume = Bad_Numero
			inner join DXTIPDOC noholdlock on Tid_Numero = Bad_Docume

		drop table #tmpPersoL3, #tmpClienL3, #documentosBit, #ultimosDoctos
	end

	if @Tip_ConCon	= @Str_Cuatro begin /* L4 - Obtenie el cliente o persona unificada*/
		if @Per_Numero = @Str_Vacio and @Per_Client = @Str_Vacio begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= 'El Numero de Persona o Cliente esta vacio',
					Err_Variab	= 'Per_Numero'
			return 1
		end
		
		select @Per_Grupo = @Per_Numero
		select @Cli_Unific = @Per_Client
		
		if @Cli_Unific <> @Str_Vacio and @Per_Grupo = @Str_Vacio begin
			select	@Per_Grupo = Adi_NumPer,
					@Per_Numero = Adi_NumPer
				from CLADICIO noholdlock
				where Adi_Client = @Cli_Unific
		end
		if @Cli_Unific = @Str_Vacio and @Per_Grupo <> @Str_Vacio begin
			select	@Per_Client = Adi_Client,
					@Cli_Unific = Adi_Client
				from CLADICIO noholdlock
				where Adi_NumPer = @Per_Grupo
		end
		if @Per_Numero <> @Str_Vacio begin
			select @Per_Grupo = Peu_Grupo
				from SOUNIPER noholdlock
				where Peu_Person = @Per_Numero
		end
		if @Cli_Unific <> @Str_Vacio begin
			select @Cli_Unific = Clu_Grupo
				from CLCLIUNI noholdlock
				where Clu_Client = @Per_Client
		end
		if @Cli_Unific <> @Str_Vacio and @Per_Grupo = @Str_Vacio begin
			select	@Per_Grupo = Adi_NumPer,
					@Per_Numero = Adi_NumPer
				from CLADICIO noholdlock
				where Adi_Client = @Cli_Unific
		end
		if @Cli_Unific = @Str_Vacio and @Per_Grupo <> @Str_Vacio begin
			select	@Per_Client = Adi_Client,
					@Cli_Unific = Adi_Client
				from CLADICIO noholdlock
				where Adi_NumPer = @Per_Grupo
		end
		
		select	Per_Client = @Cli_Unific,
				Per_Numero = @Per_Grupo
	end
	if @Tip_ConCon	= @Str_Cinco begin /* L5 - Busqueda de Grupo de Persona por nombre*/
		select Per_Person = Per_Numero, Per_Grupo = Per_Numero
			into #tmpPerso04
			from SOPERSON noholdlock
			where	Per_Comple like @Str_PeuNom

		update #tmpPerso04 set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC, Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Adi_FeExId,	Adi_Sexo,
				Adi_FecNac
			from #tmpPerso04
			inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
			left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero 

		drop table #tmpPerso04
	end
	
	if @Tip_ConCon	= @Str_Seis begin /* L6 - Consultar TODOS los documentos por Numero de Persona */
		if @Per_Numero = @Str_Vacio begin
			select	Err_Codigo	= '000001',
					Err_Mensaj	= 'El Numero de persona esta vacio',
					Err_Variab	= 'Per_Numero'
			return 1
		end
		create table #tmpPersoL5 (
			Per_Person char(8)
		)
		create index #tmpPersoL5 on #tmpPersoL5 (Per_Person)

		create table #tmpClienL5 (
			Cli_Client char(8),
			Cli_Unific char(8)
		)
		create index #tmpClienL5 on #tmpClienL5 (Cli_Client)

		create table #documentosPersona (
			Bad_Numero int,
			Bad_Bandej int,
			Bad_Docume int,
			Bad_Status char(1),
			Bad_Archiv varchar(50),
			Bad_PidCM  varchar(200),
			Ban_Person char(8)
		)
		create index #documentosPersona on #documentosPersona (Bad_Docume)

		select	@Per_Grupo = @Per_Numero

		select	@Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = @Per_Numero

		insert into #tmpPersoL5
			select	Peu_Person
				from SOUNIPER noholdlock
				where	Peu_Grupo = @Per_Grupo

		select	@Int_Existe = @Ent_No
		select	@Int_Existe = count(1)
			from #tmpPersoL5

		if @Int_Existe = @Ent_No
			insert into #tmpPersoL5
				values (@Per_Grupo)

		insert into #tmpClienL5
			select	Adi_Client,	@Str_Vacio
				from CLADICIO noholdlock
				inner join #tmpPersoL5 on Adi_NumPer = Per_Person

		update #tmpClienL5 set
			Cli_Unific = Clu_Grupo 
			from CLCLIUNI noholdlock
			where Clu_Client = Cli_Client

		select @Cli_Unific = Cli_Unific
			from #tmpClienL5

		select	Ban_Numero,	Ban_Person
			into #documentosBandejaPersona
			from #tmpPersoL5 
			inner join DXBANDEJ noholdlock on Ban_Person = Per_Person
		
		create index #documentosBandejaPersona on #documentosBandejaPersona (Ban_Numero)
		
		select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
				Bad_PidCM,	Ban_Person
			into #documentosBandejaPersonaDoc
			from #documentosBandejaPersona 
			inner join DXBANDOC noholdlock on Bad_Bandej = Ban_Numero 
			
		create index #documentosBandejaPersonaDoc on #documentosBandejaPersonaDoc (Bad_Status, Bad_Docume)
		
		drop table #documentosBandejaPersona
		
		select	Ban_Numero,	Ban_Person, Ban_Client
			into #documentosBandejaCliente
			from #tmpClienL5
			inner join DXBANDEJ noholdlock on Ban_Client = Cli_Client

		create index #documentosBandejaCliente on #documentosBandejaCliente (Ban_Numero)
		
		select	Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Status,	Bad_Archiv,
				Bad_PidCM,	Ban_Person
			into #documentosBandejaClienteDoc
			from #documentosBandejaCliente 
			inner join DXBANDOC noholdlock on Bad_Bandej = Ban_Numero 
		
		create index #documentosBandejaClienteDoc on #documentosBandejaClienteDoc (Bad_Status, Bad_Docume)
		
		drop table #documentosBandejaCliente
		
		select	distinct
				Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Archiv, Bad_PidCM,
				Tid_Nombre, Ban_Person = @Per_Grupo, Per_Client = @Cli_Unific
			from #documentosBandejaPersonaDoc 
			inner join DXTIPDOC noholdlock on Tid_Numero = Bad_Docume
		union
		select	distinct
				Bad_Numero,	Bad_Bandej,	Bad_Docume,	Bad_Archiv, Bad_PidCM,
				Tid_Nombre, Ban_Person = @Per_Grupo, Per_Client = @Cli_Unific
			from #documentosBandejaClienteDoc 
			inner join DXTIPDOC noholdlock on Tid_Numero = Bad_Docume
		order by Tid_Nombre, Bad_Numero

		drop table #tmpPersoL5, #tmpClienL5, #documentosBandejaPersonaDoc, #documentosBandejaClienteDoc
	end
	
	if @Tip_ConCon	= @Str_Siete begin /* L7 - Busqueda por nombre de personas que representan la persona única*/
		select Per_Person = Per_Numero, Per_Grupo = Per_Numero
			into #personasUnicas
			from SOPERSON noholdlock
			where	Per_Comple like @Str_PeuNom

		update #personasUnicas set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person

		select	Per_Numero, Per_ComOrd, Per_Comple,	Per_RFC, Per_CURP,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Adi_TipIde,	Adi_NumIde,
				Adi_FeVeId,	Per_Nacion,	Adi_NacExt,	Adi_FeExId,	Adi_Sexo,
				Adi_FecNac
			from #personasUnicas
			inner join SOPERSON noholdlock on Per_Numero = Per_Grupo
			left outer join SOPERADI noholdlock on Adi_PerNum	= Per_Numero 
			where Per_Person	= Per_Grupo

		drop table #personasUnicas
	end	
end