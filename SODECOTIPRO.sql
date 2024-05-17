--drop procedure SODECOTIPRO
create procedure SODECOTIPRO (
	@Pro_Numero	smallint,		/* Proceso para el cual se ejecutaran sus Tipos de Movimientos */
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: Determinacion de Configuraciones de Tipos de Movimientos****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó: 	Jayro Flores					    					****
** Fecha: 		15/Mayo/2024											****
** Help: 		TCELCV-24065											****
** Descripcion: Se elimina table scan hacia la tabla CHCUENTA 		    ****
****************************************************************************
**	Modificó:	Fatima Sanchez											****
**  Fecha:		30/04/2021												****
**  Help:		1286068													****
**	Descripción: se elimina el convert y tipo de dato de los campos		****
**  Cop_PerFis y Ppf_PerFis que pasaron de smallint a char				****
****************************************************************************
**	Modificó:	Frank canul												****
**  Fecha:		23/12/2020												****
**  Help:		1286068													****
**	Descripción: se elimina el convert para las columnas				****
**  Ptc_TipCue y Ptc_Moneda ya que ahora son char y no se				****
**  necesita las conversiones  											****
****************************************************************************
** Modifico:	José Rivera												****
** Fecha:		07/12/2020											    ****
** Help:		1453282											    	****
** Descripcion:	Se modifica procedimiento para conversión de enteros a  ****
				alganúmericos en tabla CHGRUCLI							****
****************************************************************************
** Modifico:	Joel Gonzalez											****
** Fecha:		07/09/2020											    ****
** Help:		1286068											    	****
** Descripcion:	Optimizacion de obtencion de Configuraciones asignadas  ****
**              a Producto - Personalidad Fiscal - Tipo de Movimiento	****
**              (SOTIMOAS)												****
****************************************************************************
** Modifico:	Code4u Joel Gonzalez									****
** Fecha:		31/01/2020											    ****
** Help:			1286068										    	****
** Descripcion:	Creacion del procedimiento							    ****
****************************************************************************/

-- Declaracion de Variables
declare	@Status		int,			-- Resultado de la ejecucion de subprocedimientos
		@Fec_Actual	smalldatetime,	-- Fecha 
		@Fec_FecIni	smalldatetime,	-- Fecha Inicio 
		@Fec_FecFin	smalldatetime,	-- Fecha Fin 	
		@Reg_CoTiMo	int,			-- Contador de Registros de Tipos de Movimientos 
		@Reg_TipMov	int,			-- Total de Registros de Tipos de Movimientos 
		@Pro_TipMov	char(6),		-- Tipo de Movimiento a Procesar
		@Var_Contin bit,			-- Continuar con proceso que esta por ejecutarse 
		@Str_Descri char(50),		-- Descripcion del proceso ejecutado 
		@Fec_IniPro datetime,		-- Fecha de inicio de proceso ejecutado 
		@Fec_FinPro datetime,		-- Fecha de finalizacion de proceso ejecutado 
		@Can_TieEje int				-- Tiempo de ejecucion del proceso ejecutado 

-- Declaracion de Constantes
declare	@Bit_Si		bit,			-- Activo Registro
		@Bit_No		bit,			-- No 
		@Ent_Uno	int,			-- Entero: Uno
		@Ent_Cero	int,			-- Entero: Cero
		@Car_Cero	varchar(1),		-- Caracter: Cero
		@Ent_NivPro smallint,		-- Nivel Producto 
		@Ent_VigMod tinyint,		-- Vigencia de Configuraciones Especiales de Modalidades. 
									-- Esta Vigencia NO podria utilizarse dentro del proceso  
									-- determinacion del Nivel. En este caso el Nivel es      
									-- asignado directamente                                  
		@Sto_CieCom	varchar(11),	-- Proceso de Cierre de Comisiones 
		@Sta_Activo char(1),		-- Status Activo 
		@Ent_ProMod int				-- Numero de Producto Modalidad --

-- Asignacion de Constantes
select	@Bit_Si		= 1,				-- Si (bit)
		@Bit_No		= 0,				-- No (bit) 
		@Ent_Uno	= 1,				-- Entero Uno 
		@Ent_Cero	= 0,				-- Entero: Cero
		@Car_Cero	= '0',				-- Caracter: Cero
		@Ent_NivPro = 1,				-- Nivel Producto 
		@Ent_VigMod = 2,				-- Vigencia de Configuraciones Especiales de Modalidades. 
										-- Esta Vigencia NO podria utilizarse dentro del proceso  
										-- determinacion del Nivel. En este caso el Nivel es      
										-- asignado directamente                                  
		@Sto_CieCom	= 'SODECOTIPRO',	-- Proceso de Cierre de Comisiones 
		@Sta_Activo = 'A',				-- Status Activo 
		@Ent_ProMod = 29				-- Numero de Producto Modalidad 

create table #TiposMovPro 
		(Tmp_TipMov char(6),			/* Tabla para guardar los Tipos de Movimientos a Procesar */
		Tmp_Numero int identity)
create index TiposMovPro on #TiposMovPro (Tmp_Numero)
		
create table #ConfiguracionProd			-- Configuraciones por Productos - Personalidad Fiscal
		(	Cop_Cuenta	char(12) not null,
			Cop_TipMov	char(6) not null,
			Cop_NivEnt	smallint not null,
			Cop_Vigenc	tinyint not null,
			Cop_Produc	int not null,
			Cop_PerFis	char(1) not null,
			Cop_Elemen	int not null,
			Cop_Priori	smallint not null,
			Cop_PrPeCo	int not null,
			Cop_PrTiMo	int not null)

-- Tabla temporal para Obtener las Cuentas Activas junto con su Cliente, Tipo de Cuenta, Sucursal, Clasificacion de Cliente.
create table #CuentasAct
		(	Cua_Cuenta	char(12)	not null,
			Cua_CliEnt	int			not null,	-- Cliente en formato Entero
			Cua_TipCue	char(2)		not null,	-- Tipo de Cuenta en formato Char -- FACM 23/12/2020
			Cua_Moneda	char(2)		not null,	-- Moneda en formato char -- FACM 23/12/2020
			Cua_ClClEn	int			not null,	-- Clasificacion de Cliente en formato Entero
			Cua_SucEnt	int			not null	-- Sucursal en formato Entero
		)

-- Tabla Temporal para obtener los Grupos de Clientes.
create table #GruposCli
		(	Grc_CliEnt	int			not null,	-- Cliente en formato Entero
			Grc_Grupo	char(4)		not null)	-- Grupo de Cliente
create index GruposCli on #GruposCli (Grc_CliEnt)

-- Proceso principal

select	@Fec_Actual		= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen
--En caso de error hacer rollback
if @@error <> 0
begin
	return 1
end

select	@Fec_FecIni		= dateadd(dd, 1, dateadd(dd, - datepart(dd, @Fec_Actual), @Fec_Actual))
select	@Fec_FecFin		= dateadd(dd, -1, dateadd(mm, 1, @Fec_FecIni))

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select
	@Pro_TipMov = 'P00001'	--Producto, Personalidad Fiscal y Tipo de Movimiento

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output, @NumTransac,
	@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Preparacion de Productos-TipoCuenta_Personalidad ',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--Eliminar registros de tablas temporales
	delete SOTMPPRP
		where Prp_NumTra = @NumTransac
	truncate table SOTMPCUC
	truncate table SOTMPCCN
	truncate table SOTMPCUL
	
	--Eliminar registros de tablas de Tipos De Movimientos.
	truncate table SOTIMOCU
	truncate table SOTIMOIM
	truncate table SOEXAPCA
	
	--Eliminar registros de tablas de Historia. Para casos de reproceso.
	delete SOHISTMC
		where Tmc_Fecha = @Fec_Actual
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	delete SOHISTMI
		where Tmi_Fecha = @Fec_Actual
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	delete SOHISEAC
		where Eac_Fecha = @Fec_Actual
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end

	-- Obtener informacion de Producto, Personalidad Fiscal y Tipo de Movimiento
	-- Y en los casos en que se necesite hacer conversion de tipo de dato aplicar la conversion
	insert into SOTMPPRP(	Prp_NumTra,	Prp_Produc,	Prp_TipCue,	Prp_Moneda,	Prp_PerFis,	
							Prp_TipMov,	Prp_PeFiCa,	Prp_TiMoCa, Prp_NuPeCl, Prp_ActEmp) 
		select	distinct	@NumTransac,Ppf_Produc,	Ptc_TipCue,	Ptc_Moneda,	Ppf_PerFis,	
							Dat_TipMov,	Ppf_PerFis,
							substring('000000', 1, 6 - len(rtrim(convert(char(6), Dat_TipMov)))) + rtrim(convert(char(6), Dat_TipMov)),
							convert(char(1), Pfc_NuPeCl), 
							Pfc_ActEmp
		from SODAADTI noholdlock	--Comisiones con Configuraciones en el Módulo de Cheques
		inner join SOPRTIMO noholdlock	--Productos - Personalidades Fiscales con Configuraciones
				on Ptm_TipMov	=	Dat_TipMov
				and Ptm_Activo	=	@Bit_Si
		inner join SOPRPEFI noholdlock	--Personalidades Fiscales en Productos con Configuraciones de las Comisiones
				on Ppf_Numero	=	Ptm_PrPeFi
				and Ppf_Activo	=	@Bit_Si
		inner join SOPEFICL noholdlock
				on Pfc_PerFis	=	Ppf_PerFis
		inner join SOPRODUC noholdlock
				on Pro_Numero	=	Ppf_Produc
		inner join SOPRTICU noholdlock
				on Ptc_Produc	=	Pro_Numero
		where Dat_Modulo = @Modulo
		  and Dat_Proces = @Pro_Numero
		  and Dat_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	--Registrar ejecucion de Preparacion
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

-- Codigo para ejecucion de Proceso de Preparacion de Cuentas
select
	@Pro_TipMov = 'P00002'	-- Cuentas

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output, @NumTransac,
	@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Preparacion de Cuentas ',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	-- Obtener las Cuentas Activas junto con su Cliente, Tipo de Cuenta, Sucursal, Clasificacion de Cliente.
	insert into #CuentasAct	(	Cua_Cuenta,	Cua_CliEnt,					Cua_TipCue,				Cua_Moneda,					Cua_ClClEn,
								Cua_SucEnt)
		select					Cue_Numero,	convert(int, Cue_Client),	Cue_Tipo,	            Cue_Moneda,	        convert(int, Cli_Clasif),
								convert(int, Cue_Sucurs)
		from CHCUENTA noholdlock
		inner join CLCLIENT noholdlock
				on Cli_Numero	= Cue_Client
		where Cue_Status = @Sta_Activo
	if @Status <> @Ent_Cero begin
		return @Status
	end

	--Registrar ejecucion de Preparacion
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end


-- Codigo para ejecucion de Proceso de Preparacion de Grupos de Clientes
select
	@Pro_TipMov = 'P00003'	-- Grupos de Clientes

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output, @NumTransac,
	@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Preparacion de Grupos de Clientes ',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	-- Obtener las Cuentas Activas junto con su Cliente, Tipo de Cuenta, Sucursal, Clasificacion de Cliente.
	insert into #GruposCli	(	Grc_CliEnt,					Grc_Grupo)
		select					convert(int, GCh_Client),	GCh_Grupo
		from CHGRUCLI noholdlock
	if @Status <> @Ent_Cero begin
		return @Status
	end

	--Registrar ejecucion de Preparacion
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end


--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select
	@Pro_TipMov = 'A00001'	--Configuraciones a Nivel Producto

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual, @Sto_CieCom, @Pro_TipMov, @Var_Contin	output, @NumTransac,
	@Transaccio, @Usuario,	@FechaSis, @SucOrigen,	@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Producto',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--Obtener las Configuraciones (SOCOTIMO) en las que aplica cada Cuenta en cada Nivel
	--1. Producto
	insert into SOTMPCUC (Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Ctp_CoTiMo
		from #CuentasAct noholdlock
		inner join SOPRTICU noholdlock
				on Ptc_TipCue = Cua_TipCue
				and Ptc_Moneda = Cua_Moneda
		inner join SOCOTIPR noholdlock
				on Ctp_Produc = Ptc_Produc
				and Ctp_Activo = @Bit_Si
		inner join SOCOTIMO noholdlock
				on Ctm_Numero = Ctp_CoTiMo
				and Ctm_Activo = @Bit_Si
				and Ctm_Vigenc = @Bit_No		-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ctp_CoTiMo
			from #CuentasAct noholdlock
			inner join SOPRTICU noholdlock
					on Ptc_TipCue = Cua_TipCue
					and Ptc_Moneda = Cua_Moneda
			inner join SOCOTIPR noholdlock
					on Ctp_Produc = Ptc_Produc
					and Ctp_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctp_CoTiMo
					and Ctm_Activo = @Bit_Si
					and Ctm_Vigenc = @Bit_Si
			inner join SOVICOTI noholdlock				-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
				on Vct_CoTiMo = Ctm_Numero
				and @Fec_Actual	between Vct_FecIni and Vct_FecFin 
				and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Producto
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00002'	--Configuraciones a Nivel Clasificacion Cliente

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Clasificacion Cliente',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--2. Clasificacion de Cliente
	
	insert into SOTMPCUC 
		(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Ccc_CoTiMo
			from #CuentasAct noholdlock
			inner join SOCOCLCL noholdlock
				on Ccc_Clasif = Cua_ClClEn
				and Ccc_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ccc_CoTiMo
					and Ctm_Activo = @Bit_Si
					and Ctm_Vigenc = @Bit_No		-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ccc_CoTiMo
				from #CuentasAct noholdlock
				inner join SOCOCLCL noholdlock
					on Ccc_Clasif = Cua_ClClEn
					and Ccc_Activo = @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero = Ccc_CoTiMo
						and Ctm_Activo = @Bit_Si
						and Ctm_Vigenc = @Bit_Si
				inner join SOVICOTI noholdlock		-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso 
						on Vct_CoTiMo = Ctm_Numero
						and @Fec_Actual between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si		  
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Clasificacion Cliente
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00003'	--Configuraciones a Nivel Grupo Cliente

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Grupo Cliente',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--3. Grupo
	insert into SOTMPCUC(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Ctg_CoTiMo
			from #CuentasAct noholdlock
			inner join #GruposCli noholdlock
					on Grc_CliEnt	= Cua_CliEnt
			inner join SOCOTIGR noholdlock
					on Ctg_Grupos	= Grc_Grupo
					and Ctg_Activo	= @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero	= Ctg_CoTiMo
					and Ctm_Activo	= @Bit_Si
					and	Ctm_Vigenc	= @Bit_No	-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ctg_CoTiMo
				from #CuentasAct noholdlock
				inner join #GruposCli noholdlock
						on Grc_CliEnt	= Cua_CliEnt
				inner join SOCOTIGR noholdlock
						on Ctg_Grupos	= Grc_Grupo
						and Ctg_Activo	= @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero	= Ctg_CoTiMo
						and Ctm_Activo	= @Bit_Si
						and	Ctm_Vigenc	= @Bit_Si
				inner join SOVICOTI noholdlock	-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
						on Vct_CoTiMo = Ctg_CoTiMo
						and @Fec_Actual	between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Grupo Cliente
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00005'	--Configuraciones a Nivel Zona

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Zona',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--5. Zona
	insert into SOTMPCUC(Cuc_Cuenta,	Cuc_CoTiMo)
	select Cua_Cuenta, Ctz_CoTiMo
		from #CuentasAct noholdlock
		inner join SOSUCURS noholdlock
				on SoSucursID = Cua_SucEnt
		inner join SOZONAS noholdlock
				on Zon_Numero = Suc_Zona
		inner join SOCOTIZO noholdlock
				on Ctz_Zonas = convert(smallint, Zon_Numero)
				and Ctz_Activo = @Bit_Si
		inner join SOCOTIMO noholdlock
				on Ctm_Numero = Ctz_CoTiMo
				and Ctm_Activo = @Bit_Si
				and Ctm_Vigenc = @Bit_No	-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ctz_CoTiMo
				from #CuentasAct noholdlock
				inner join SOSUCURS noholdlock
						on SoSucursID = Cua_SucEnt
				inner join SOZONAS noholdlock
						on Zon_Numero = Suc_Zona
				inner join SOCOTIZO noholdlock
						on Ctz_Zonas = convert(smallint, Zon_Numero)
						and Ctz_Activo = @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero = Ctz_CoTiMo
						and Ctm_Activo = @Bit_Si
						and Ctm_Vigenc = @Bit_Si
				inner join SOVICOTI noholdlock		-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
						on Vct_CoTiMo = Ctm_Numero
						and @Fec_Actual	between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Zona
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00006'	--Configuraciones a Nivel Plaza

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Plaza',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--6. Plaza
	insert into SOTMPCUC(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Ctp_CoTiMo
			from #CuentasAct noholdlock
			inner join SOSUCURS noholdlock
					on SoSucursID = Cua_SucEnt
			inner join SOCOTIPL noholdlock
					on Ctp_Plazas = SoPlazaID
					and Ctp_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctp_CoTiMo
					and Ctm_Activo = @Bit_Si
					and Ctm_Vigenc = @Bit_No	-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ctp_CoTiMo
				from #CuentasAct noholdlock
				inner join SOSUCURS noholdlock
						on SoSucursID = Cua_SucEnt
				inner join SOCOTIPL noholdlock
						on Ctp_Plazas = SoPlazaID
						and Ctp_Activo = @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero = Ctp_CoTiMo
						and Ctm_Activo = @Bit_Si
						and Ctm_Vigenc = @Bit_Si
				inner join SOVICOTI noholdlock		-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
						on Vct_CoTiMo = Ctm_Numero
						and @Fec_Actual	between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Plaza
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00007'	--Configuraciones a Nivel Sucursal

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Sucursal',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--7. Sucursal
	insert into SOTMPCUC 
		(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Cts_CoTiMo
			from #CuentasAct noholdlock
			inner join SOCOTISU noholdlock
					on Cts_Sucurs = Cua_SucEnt
					and Cts_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Cts_CoTiMo
					and Ctm_Activo = @Bit_Si
					and Ctm_Vigenc = @Bit_No	-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Cts_CoTiMo
				from #CuentasAct noholdlock
				inner join SOCOTISU noholdlock
						on Cts_Sucurs = Cua_SucEnt
						and Cts_Activo = @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero = Cts_CoTiMo
						and Ctm_Activo = @Bit_Si
						and Ctm_Vigenc = @Bit_Si	
				inner join SOVICOTI noholdlock		-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
						on Vct_CoTiMo = Ctm_Numero
						and @Fec_Actual	between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Sucursal
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro, 	@Fec_FinPro,	@NumTransac, 	@Transaccio, 	@Usuario, 
		@FechaSis, 		@SucOrigen, 	@SucDestino, 	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00008'	--Configuraciones a Nivel Ciente

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio,	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Cliente',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--8. Cliente
	insert into SOTMPCUC 
		(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cua_Cuenta, Ctc_CoTiMo
			from #CuentasAct noholdlock
			inner join SOCOTICL noholdlock	
					on Ctc_Client	= Cua_CliEnt
					and Ctc_Activo	= @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctc_CoTiMo
					and Ctm_Activo = @Bit_Si
					and Ctm_Vigenc = @Bit_No		-- Obtener todas las Configuraciones Base (sin vigencia)
		union all
			select Cua_Cuenta, Ctc_CoTiMo
				from #CuentasAct noholdlock
				inner join SOCOTICL noholdlock	
						on Ctc_Client	= Cua_CliEnt
						and Ctc_Activo	= @Bit_Si
				inner join SOCOTIMO noholdlock
						on Ctm_Numero = Ctc_CoTiMo
						and Ctm_Activo = @Bit_Si
						and Ctm_Vigenc = @Bit_Si
				inner join SOVICOTI noholdlock		-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
						on Vct_CoTiMo = Ctm_Numero
						and @Fec_Actual between Vct_FecIni and Vct_FecFin
						and Vct_Activo = @Bit_Si
	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end
	
	--Registrar ejecucion de Configuraciones a Nivel Cliente
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro,	@NumTransac,	@Transaccio,	@Usuario, 
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--Codigo para ejecucion de Proceso de Preparacion de Productos y Cuentas
select	@Pro_TipMov = 'A00009'	--Configuraciones a Nivel Cuenta

--Determinar si el proceso de Preparacion ya fue ejecutado
execute	@Status = SOTMPBCCCON 
	@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
	@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
	@Modulo
if @Status <> @Ent_Cero begin
	return @Status
end

if @Var_Contin = @Bit_Si
begin
	select @Str_Descri = 'Configuraciones a Nivel Cuenta',	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */

	--9. Cuenta
	insert into SOTMPCUC 
		(Cuc_Cuenta,	Cuc_CoTiMo)
		select Cue_Numero,	Ctu_CoTiMo
			from CHCUENTA noholdlock
			inner join SOCOTICU noholdlock
					on Ctu_Cuenta = Cue_Numero
					and Ctu_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctu_CoTiMo
					and Ctm_Activo = @Bit_Si
					and	Ctm_Vigenc = @Bit_No	-- Obtener todas las Configuraciones Base (sin vigencia)
			where	Cue_Status = @Sta_Activo
		union all
		select Cue_Numero,	Ctu_CoTiMo
			from CHCUENTA noholdlock
			inner join SOCOTICU noholdlock
					on Ctu_Cuenta = Cue_Numero
					and Ctu_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctu_CoTiMo
					and Ctm_Activo = @Bit_Si
					and	Ctm_Vigenc = @Bit_Si	-- Obtener las Configuraciones con Vigencia que correspondan a la fecha de Proceso
			inner join SOVICOTI noholdlock
					on Vct_CoTiMo = Ctm_Numero
					and @Fec_Actual	between Vct_FecIni and Vct_FecFin
					and Vct_Activo = @Bit_Si
			where	Cue_Status = @Sta_Activo
		  

	--En caso de error hacer rollback
	if @@error <> 0
	begin
		return 1
	end	
	
	--Registrar ejecucion de Configuraciones a Nivel Cuenta
	select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
	select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
	
	execute	@Status = SOTMPBCCALT 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
		@Fec_IniPro,	@Fec_FinPro, 	@NumTransac, 	@Transaccio, 	@Usuario, 
		@FechaSis, 		@SucOrigen, 	@SucDestino, 	@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end
end

--FIN Obtener las Configuraciones (SOCOTIMO) en las que aplica cada Cuenta en cada Nivel


--Ejecutar proceso de Determinacion de Configuracion de Cuentas, para cada Comision.
insert into #TiposMovPro
	(Tmp_TipMov)
	select substring('000000', 1, 6 - len(rtrim(convert(char(6), Dat_TipMov)))) + rtrim(convert(char(6), Dat_TipMov))
	from	SODAADTI noholdlock
	where 	Dat_Modulo = @Modulo
	  and 	Dat_Proces = @Pro_Numero
	  and 	Dat_Activo = @Bit_Si
	order by Dat_TipMov
--En caso de error hacer rollback
if @@error <> 0
begin
	return 1
end

-- Primer Tipo de Movimiento
select	@Reg_CoTiMo	=	min(Tmp_Numero)
	from #TiposMovPro
-- Ultimo Tipo de Movimiento
select	@Reg_TipMov	=	max(Tmp_Numero)
	from #TiposMovPro
	
while (@Reg_CoTiMo <= @Reg_TipMov) --Ejecutar cada Comision
begin
	--Obtener siguiente Comision
	select	@Pro_TipMov = Tmp_TipMov
		from	#TiposMovPro
		where 	Tmp_Numero = @Reg_CoTiMo

	--Determinar si la Comision ya fue ejecutada
	execute	@Status = SOTMPBCCCON 
		@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Var_Contin	output,	@NumTransac,
		@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen,			@SucDestino,
		@Modulo
	if @Status <> @Ent_Cero begin
		return @Status
	end

	if @Var_Contin = @Bit_Si
	begin
		truncate table SOTMPCTA
		truncate table SOTMPCUL
		truncate table #ConfiguracionProd
		
		-----Inicio Proceso de Comision----
		begin transaction
		
		select @Str_Descri = 'Comision ' + @Pro_TipMov,	/* Descripcion del proceso ejecutado */
				@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */
		
		--Obtener los elementos de cada Nivel para cada Cuenta
		--Obtener las Configuraciones Base y con Vigencia en cada Nivel
		--Configuraciones del Tipo de Movimiento de todas las Cuentas en todos los Niveles

		create table #chciecue(
			Cue_Numero 	char(12),
			Cue_Tipo 	char(2),
			Cue_Moneda	char(2),
			Prp_Produc	int,
			Prp_PerFis	char(1),
			Prp_TipMov	int,
			Prp_TiMoCa	char(6)
		)
		create index #chciecue on #chciecue (Cue_Numero)
 		insert into #chciecue (Cue_Numero, Cue_Tipo,	Cue_Moneda, Prp_Produc, Prp_PerFis,
							Prp_TipMov, Prp_TiMoCa)
		select	Cue_Numero, Cue_Tipo,	Cue_Moneda, Prp_Produc, Prp_PerFis,
				Prp_TipMov, Prp_TiMoCa
		from CHCIECUE noholdlock
		inner join SOTMPPRP noholdlock
				on	Prp_NumTra	=	@NumTransac
				and Prp_TipCue	=	Cue_Tipo
				and Prp_Moneda	=	Cue_Moneda
				and Prp_NuPeCl	=	Cue_CliTip		--- Condición por Personalidad Fiscal del Cliente
				and Prp_ActEmp	=	Cue_ActEmp		--- Condición por Personalidad Fiscal del Cliente
				and Prp_TiMoCa	=	@Pro_TipMov		--- Filtrado por Tipo de Movimiento
		where	Cue_Status = @Sta_Activo

		insert into SOTMPCUL(
			Cul_Cuenta, Cul_TipCue, Cul_Moneda, Cul_Produc, Cul_PerFis,
			Cul_TipMov, Cul_CoTiMo, Cul_TiMoCa,	Cul_NivEnt,	Cul_Vigenc, 
			Cul_Priori)			
		select Cue_Numero, Cue_Tipo,	Cue_Moneda, Prp_Produc, Prp_PerFis,
				Prp_TipMov, Cuc_CoTiMo, Prp_TiMoCa, Ctm_NivEnt,	Ctm_Vigenc,	
				Ppt_Priori
		from #chciecue noholdlock
		inner join SOTMPCUC noholdlock				-- Configuraciones de todas las Cuentas en todos los Niveles.
				on Cuc_Cuenta	=	Cue_Numero
		inner join SOCOTIMO noholdlock
				on Ctm_Numero 	=	Cuc_CoTiMo
		inner join SOPRPETI	noholdlock			--Obtener Prioridad de Nivel del Tipo de Movimiento en el Producto/PersonalidadFiscal
				on Ppt_PrTiMo	=	Prp_TipMov
				and Ppt_NivEnt	=	Ctm_NivEnt
				and Ppt_Activo	=	@Bit_Si

		drop table  #chciecue

		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback transaction
			return 1
		end
		
		insert into #ConfiguracionProd(	Cop_Cuenta,	Cop_TipMov,	Cop_NivEnt,	Cop_Vigenc,	Cop_Produc,
										Cop_PerFis,	Cop_Elemen,	Cop_Priori,	Cop_PrPeCo,	Cop_PrTiMo)
			select	Cul_Cuenta,	Cul_TiMoCa,	Cul_NivEnt,	convert(tinyint, Cul_Vigenc),	Cul_Produc, 
					Cul_PerFis, Cul_Produc,	Cul_Priori,	Ppc_Numero,	Ptm_Numero
			from SOTMPCUL noholdlock
			inner join SOPRPEFI noholdlock			--Personalidades Fiscales de cada Producto
					on Ppf_Produc	=	Cul_Produc
					and Ppf_PerFis	=	Cul_PerFis
					and Ppf_Activo	=	@Bit_Si
			inner join SOPRTIMO noholdlock			--Obtener el Tipo de Movimiento de la Configuración
					on Ptm_PrPeFi	=	Ppf_Numero
					and Ptm_TipMov	=	Cul_TipMov	--Tipo o Tipos de Movimientos seleccionados en SOTMPPRP
					and Ptm_Activo	=	@Bit_Si
			inner join SOPRPECO noholdlock			--Productos/Personalidades Fiscales asignadas a Configuraciones
					on Ppc_CoTiMo	=	Cul_CoTiMo
					and Ppc_PrPeFi	=	Ppf_Numero
					and Ppc_Activo	=	@Bit_Si
			where Cul_TipMov = convert(int, @Pro_TipMov)
		-- En caso de error terminar con error
		if @@error <> 0
		begin
			rollback transaction
			return 1
		end

		insert into SOTMPCCN 
			(Ccn_Cuenta,	Ccn_TipMov,	Ccn_NivEnt,	Ccn_Vigenc,	Ccn_Produc,
			Ccn_PerFis, 	Ccn_Elemen, Ccn_TiMoAs,	Ccn_Aplica, Ccn_Termin, 
			Ccn_Priori, 	Ccn_AplCal, Ccn_Activo)	
			select	Cop_Cuenta,	Cop_TipMov,	Cop_NivEnt,	Cop_Vigenc,	Cop_Produc,
					Cop_PerFis,	Cop_Elemen,	Tma_Numero,	Tma_Aplica, Tma_Termin, 
					Cop_Priori, @Bit_Si,	@Bit_Si
			from #ConfiguracionProd
			inner join SOTIMOAS noholdlock			--Tipos de Movimientos en cada Prod/PerFis dentro de cada Configuración
					on Tma_PrPeCo	=	Cop_PrPeCo
					and Tma_PrTiMo	=	Cop_PrTiMo
					and Tma_Activo	=	@Bit_Si
		-- En caso de error terminar con error
		if @@error <> 0
		begin
			rollback transaction
			return 1
		end
		
		
		--MODALIDADES----------------------------------------------------------------------------
		--Eliminar las Configuraciones de Cuentas que hayan obtenido el Tipo de Movimiento como Beneficio en Modalidades.
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN CCN
			inner join CHTMPCMO noholdlock
					on Cmo_Cuenta = CCN.Ccn_Cuenta
					and Cmo_TipMov = convert(int, CCN.Ccn_TipMov)
			where	CCN.Ccn_TipMov = @Pro_TipMov
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		--FIN MODALIDADES------------------------------------------------------------------------
	
		--Obtener la Configuracion que se utilizara en cada Cuenta, considerando Nivel y Terminal.--
		--En este momento, para cada Cuenta, en todos los niveles, se tienen las Configuraciones sin vigencia,
		--y Configuraciones con Vigencia y que la vigencia se encuentre la Fecha Actual de proceso.
		--Por lo tanto se tiene hasta dos Configuraciones por Nivel en cada Cuenta:
		--A: Solo la Configuracion sin Vigencia.
		--B: O Solo la Configuracion con Vigencia.
		--C: O Configuracion sin Vigencia y Configuracion con Vigencia.
		
		--Eliminar las Configuraciones con Vigencia cuando se tenga una Configuracion sin Vigencia en el mismo Nivel
		--Y que la Configuración Sin Vigencia sea Terminal.
		--Cuando se tienen Configuraciones Terminales, las Configuraciones de "menor" prioridad no son tomadas en cuenta.
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN CcnE
			inner join SOTMPCCN CcnA
					on CcnA.Ccn_TipMov = CcnE.Ccn_TipMov
					and CcnA.Ccn_Cuenta = CcnE.Ccn_Cuenta
					and CcnA.Ccn_NivEnt = CcnE.Ccn_NivEnt
					and CcnA.Ccn_Vigenc = @Bit_No
					and CcnA.Ccn_Termin = @Bit_Si
			where	CcnE.Ccn_TipMov = @Pro_TipMov
			  and	CcnE.Ccn_Vigenc = @Bit_Si
			  and 	CcnE.Ccn_Activo = @Bit_Si
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
			
		--En este momento, las Configuraciones Terminales ya quedaron sin otra Configuracion en el mismo Nivel
		--Eliminar las Configuraciones Sin Vigencia cuando se tenga una Configuracion Con Vigencia en el mismo Nivel
		--Las Configuraciones con Vigencia tienen mayor prioridad que las Configuraciones sin Vigencia.
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN CcnE
			inner join SOTMPCCN CcnA
					on CcnA.Ccn_TipMov = CcnE.Ccn_TipMov
					and CcnA.Ccn_Cuenta = CcnE.Ccn_Cuenta
					and CcnA.Ccn_NivEnt = CcnE.Ccn_NivEnt
					and CcnA.Ccn_Vigenc = @Bit_Si
			where	CcnE.Ccn_TipMov = @Pro_TipMov
			  and 	CcnE.Ccn_Vigenc = @Bit_No
			  and 	CcnE.Ccn_Activo = @Bit_Si
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		
		--En este momento, se tiene una sola Configuracion en cada Nivel para los cuales la Cuenta haya tenido Configuracion.
		--Eliminar Configuraciones de Mayor Nivel que un Menor Nivel con Configuracion Terminal
			--Obtener Cuentas con Configuracion Terminal, y se registra el Nivel con Menor prioridad en cada Cuenta
		--Cuando se tienen Configuraciones Terminales, las Configuraciones de "mayor" prioridad no son tomadas en cuenta.
		
		insert into SOTMPCTA 
			(Cta_Cuenta,	Cta_Priori)
			select Ccn_Cuenta,	min(Ccn_Priori)
				from	SOTMPCCN noholdlock
				where 	Ccn_TipMov = @Pro_TipMov
				and 	Ccn_Termin = @Bit_Si
				and 	Ccn_Activo = @Bit_Si
				group by	Ccn_Cuenta
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN
			inner join SOTMPCTA
					on Cta_Cuenta = Ccn_Cuenta
					and Cta_Priori < Ccn_Priori
			where	Ccn_TipMov = @Pro_TipMov
			  and 	Ccn_Activo = @Bit_Si
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		
		--En este momento ya se Eliminaron Configuraciones de Mayor Prioridad que las Terminales.
		--Eliminar todas las Configuraciones con Menor Prioridad que la Configuracion con Mayor Prioridad.
		--Por lo que para cada Cuenta quedará activa una sola Configuracion
		
		delete SOTMPCTA
			where Cta_Cuenta <> ''
		
		insert into SOTMPCTA 
			(Cta_Cuenta,	Cta_Priori)
			select Ccn_Cuenta, max(Ccn_Priori)
			from 	SOTMPCCN noholdlock
			where 	Ccn_TipMov = @Pro_TipMov
			  and	Ccn_Activo = @Bit_Si
			group by	Ccn_Cuenta
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
				
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN
			inner join SOTMPCTA
					on Cta_Cuenta = Ccn_Cuenta
					and Cta_Priori > Ccn_Priori
			where	Ccn_TipMov = @Pro_TipMov
			  and	Ccn_Activo = @Bit_Si
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		
		--Es posible que en un Nivel, una Cuenta pueda pertenecer a mas de un Elemento.
		--Por ejemplo en Nivel de Grupo de Cuenta, una Cuenta puede pertenecer a mas de un Grupo.
		--Si ese Nivel es el seleccionado para aplicar a la Cuenta, se debe utilizar solo una 
		--  de las Configuraciones.
		--Podria ser que se asignen prioridades entre Elementos del Mismo Nivel, para que
		--  aquí se pueda determinar la Configuracion seleccionada utilizando esas Prioridades.
		--** Inicialmente se utilizara la ultima Configuracion asignada a la Cuenta.
		
		delete SOTMPCTA
			where Cta_Cuenta <> ''
		
		insert into SOTMPCTA 
			(Cta_Cuenta,	Cta_Priori)
			select Ccn_Cuenta, max(Ccn_TiMoAs)
			from 	SOTMPCCN noholdlock
			where 	Ccn_TipMov = @Pro_TipMov
			  and	Ccn_Activo = @Bit_Si
			group by	Ccn_Cuenta
			having count(*) > 1		--Solo para los casos en que se tenga mas de una Configuracion aun Activas
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
				
		update SOTMPCCN
			set Ccn_Activo = @Bit_No
			from SOTMPCCN
			inner join SOTMPCTA
					on Cta_Cuenta = Ccn_Cuenta
					and Cta_Priori <> Ccn_TiMoAs
			where	Ccn_TipMov = @Pro_TipMov
			  and	Ccn_Activo = @Bit_Si
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		-----Fin Proceso de Comision----

		--MODALIDADES----------------------------------------------------------------------------
		--Insertar Configuraciones de Cuentas que hayan obtenido el Tipo de Movimiento como Beneficio en Modalidades.
		--Las Configuraciones son la Configuracion Base del Producto Modalidades.
		insert into SOTMPCCN 
			(Ccn_Cuenta,	Ccn_TipMov,	Ccn_NivEnt,	Ccn_Vigenc,	Ccn_Produc,
			Ccn_PerFis,		Ccn_Elemen, Ccn_TiMoAs,	Ccn_Aplica, Ccn_Termin, 
			Ccn_Priori, 	Ccn_AplCal, Ccn_Activo)
			select	Cmo_Cuenta, 
					substring('000000', 1, 6 - len(rtrim(convert(CHAR(6), Cmo_TipMov)))) + rtrim(convert(CHAR(6), Cmo_TipMov)), 
					@Ent_NivPro,	@Ent_VigMod,	Ctm_Numero,
					Pfc_PerFis, 	Ctm_Numero, 	Tma_Numero,	Tma_Aplica,	Tma_Termin,
					Ppt_Priori, 	@Bit_No, 		@Bit_Si 
			from	CHTMPCMO noholdlock
			inner join CHCUENTA noholdlock
					on Cue_Numero = Cmo_Cuenta
			inner join CLCLIENT noholdlock
					on Cli_Numero = Cue_Client
			inner join SOPEFICL noholdlock
					on Pfc_NuPeCl = Cli_Tipo
					and Pfc_ActEmp = Cli_ActEmp
			inner join SOPRPEFI noholdlock
					on Ppf_Produc = @Ent_ProMod
					and Ppf_PerFis = Pfc_PerFis
					and Ppf_Activo = @Bit_Si
			inner join SOPRTIMO noholdlock
					on Ptm_PrPeFi = Ppf_Numero
					and Ptm_TipMov = Cmo_TipMov
					and Ptm_Activo = @Bit_Si
			inner join SOPRPETI noholdlock
					on Ppt_PrTiMo = Ptm_Numero
					and Ppt_NivEnt = @Ent_NivPro
					and Ppt_Activo = @Bit_Si
			inner join SOCOTIPR noholdlock
					on Ctp_Produc = @Ent_ProMod
					and Ctp_Activo = @Bit_Si
			inner join SOCOTIMO noholdlock
					on Ctm_Numero = Ctp_CoTiMo
					and Ctm_Vigenc = @Bit_No
					and Ctm_Activo = @Bit_Si
			inner join SOPRPECO noholdlock
					on Ppc_CoTiMo = Ctm_Numero
					and Ppc_PrPeFi = Ppf_Numero
					and Ppc_Activo = @Bit_Si
			inner join SOTIMOAS noholdlock
					on Tma_PrPeCo = Ppc_Numero
					and Tma_PrTiMo = Ptm_Numero
					and Tma_Activo = @Bit_Si
			where	Cmo_TipMov = convert(int, @Pro_TipMov)
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		--FIN MODALIDADES------------------------------------------------------------------------		

		--Registrar ejecucion de Comision
		select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
		select @Can_TieEje = datediff(second, @Fec_IniPro, @Fec_FinPro)
		
		execute	@Status = SOTMPBCCALT 
			@Fec_Actual,	@Sto_CieCom,	@Pro_TipMov,	@Str_Descri,	@Can_TieEje,
			@Fec_IniPro, 	@Fec_FinPro, 	@NumTransac, 	@Transaccio, 	@Usuario, 
			@FechaSis, 		@SucOrigen, 	@SucDestino, 	@Modulo
		if @Status <> @Ent_Cero begin
			return @Status
		end
		
		--Fin de ejecución de Comisión
		commit transaction
	end 
		
	--Incrementar contador de Tipos de Movimientos
	select	@Reg_CoTiMo	=	@Reg_CoTiMo	+	@Ent_Uno
end 

delete SOTMPPRP
	where Prp_NumTra = @NumTransac
drop table #ConfiguracionProd
drop table #TiposMovPro
drop table #CuentasAct
drop table #GruposCli