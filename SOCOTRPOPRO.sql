-- drop procedure SOCOTRPOPRO
create procedure SOCOTRPOPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*******************************************************************************
** DESCRIPCION: Proceso para determinar las Configuraciones a Traspasarse a	****
**				Postgres. Niveles Cliente y Cuenta.							****
********************************************************************************
** REFERENCIAS:															    ****
********************************************************************************
** Modifico:	Joel Gonzalez											    ****
** Fecha:		15/10/2020											        ****
** Help:		1286068											    	    ****
** Descripcion:	Creacion del procedimiento							        ****
********************************************************************************/

-- Tablas temporales
-- Productos a procesar con Tipo de Cuenta, Personalidad Fiscal, Comision --
create table #ProductosPro(	Prp_Produc int not null,
							Prp_TiCuEn int not null,
							Prp_MonEnt smallint not null,
							Prp_TipCue char(2) not null,
							Prp_Moneda char(2) not null,
							Prp_PrPeFi int not null,
							Prp_PeFiEn smallint not null,
							Prp_PerFis char(1) not null,
							Prp_PrTiMo int not null,
							Prp_TiMoEn int not null,
							Prp_TipMov char(6) not null,
							Prp_TiCaMo smallint not null,
							Prp_CheGra int not null)

-- Nuevas Cuentas --
create table #CuentasNue(	Cun_Cuenta	char(12),
							Cun_TipCue	char(2),
							Cun_Moneda	char(2),
							Cun_Client	char(8))

-- Nuevos Clientes --
create table #ClientesNue(	Cln_Client	char(8),
							Cln_TipCue	char(2),
							Cln_Moneda	char(2))

-- Configuraciones a Nivel Cliente de Banca Electronica	
create table #ClientesBan
				(	
					Clb_Client	char(8) 		not null,
					Clb_TipCli	char(1) 		not null,
					Clb_TiAcEm	char(1) 		not null,
					Clb_TipCue	char(2)			not null,
					Clb_Moneda	char(2)			not null,
					Clb_Aplica	char(1)			not null,
					Clb_CoBaEl	money			not null,
				)	

-- Cuentas que cambian de Tipo de Cuenta
create table #CuentasCam		
				(	
					Cca_Cuenta	char(12) 		not null,
					Cca_Client	char(8) 		not null,
					Cca_TipCli	char(1) 		not null,
					Cca_TiAcEm	char(1) 		not null,
					Cca_PerFis	smallint		not null,
					Cca_TiCuAn	char(2)			not null,
					Cca_MonAnt	char(2)			not null,
					Cca_TiCuNu	char(2)			not null,
					Cca_MonNue	char(2)			not null
				)	

-- Clientes de Cuentas que cambian de Tipo de Cuenta
create table #ClientesCam		
				(	
					Clc_Client	char(8) 		not null,
					Clc_CliNum	int				not null,
					Clc_TipCli	char(1) 		not null,
					Clc_TiAcEm	char(1) 		not null,
					Clc_PerFis	smallint		not null,
					Clc_TiCuAn	char(2)			not null,
					Clc_MonAnt	char(2)			not null,
					Clc_TiCuNu	char(2)			not null,
					Clc_MonNue	char(2)			not null
				)	


-- Declaracion de variables
declare	@Status		int,			-- Status de ejecucion de subprocedimientos
		@Fec_Proces	smalldatetime,	-- Fecha de Proceso
		@Fec_CorAnt	smalldatetime,	-- Fecha de Corte del Mes anterior
		@Fec_IniMes	smalldatetime,	-- Fecha Inicio del Mes
		@Bcc_CanCue	int,			-- Cantidad de Cuentas
		@Bcc_CanCli	int,			-- Cantidad de Clientes
		@Bcc_CaReCu	int,			-- Cantidad de Registros de Configuraciones de Cuentas
		@Bcc_CaReCl	int,			-- Cantidad de Registros de Configuraciones de Clientes
		@Bcc_GenExi	bit,			-- Generacion exitosa de Configuraciones
		@Bcc_TraExi	bit,			-- Traspaso exitoso de Configuraciones
		@Bcc_MenGen	varchar(100),	-- Mensaje de Generacion de Configuraciones
		@Bcc_MenTra	varchar(100)	-- Mensaje de Traspaso de Configuraciones


-- Declaracion de Constantes
declare	@Str_Ceros	varchar(10),	-- String de Ceros para conversiones de numeros a valores string
		@Ent_Cero	int,			-- Cantidad: Cero
		@Ent_Uno	int,			-- Cantidad: Uno
		@Mon_Cero	money,			-- Monto: Cero
		@Bit_Si		bit,			-- Bit: Si
		@Bit_No		bit,			-- Bit: No
		@Str_Si		char(1),		-- String: Si
		@Str_No		char(1),		-- String: No
		@Mod_Cheque	char(2),		-- Modulo: Cheques
		@Per_PerMor	int,			-- Personalidad Fiscal: Persona Moral
		@Sta_CueAct	char(1),		-- Status Cuenta: Activa
		@Tip_CoCuNu	tinyint,		-- Tipo de Configuracion: Cuenta Nueva
		@Tip_CoCaTi	tinyint,		-- Tipo de Configuracion: Cuenta Cambia de Tipo de Cuenta
		@Tip_CaChEx	smallint,		-- Tipo Calculo: Cheques Expedidos
		@Tip_CaMaCu	smallint,		-- Tipo Calculo: Manejo de Cuenta
		@Tip_CaBaEl	smallint,		-- Tipo Calculo: Banca Electronica
		@Tip_CheExp	char(6),		-- Tipo de Movimiento: Cheques Expedidos
		@Tip_ManCue	char(6),		-- Tipo de Movimiento: Manejo de Cuenta
		@Tip_BanEle	char(6),		-- Tipo de Movimiento: Banca Electronica
		@Fec_Vacia	smalldatetime,	-- Fecha: Vacia
		@Etm_CoChEx	smallint,		-- Elemento de Tipo de Calculo: Comision de Cheques Expedidos
		@Etm_MesGra	smallint,		-- Elemento de Tipo de Calculo: Meses de Gracia
		@Mon_Peso	char(2),		-- Moneda: 01 Peso
		@Mon_Dolar	char(2),		-- Moneda: 02 Dolar
		@Tip_UsuAdm	char(1),		-- Tipo de Usuario Administrador
		@Sta_Cancel	char(1), 		-- Status Cancelado
		@Sta_Inacti	char(1),		-- Status Inactivo
		@Cli_Vacio	char(8),		-- Cliente Vacio
		@Men_Vacio	varchar(100),	-- Mensaje Vacio
		@Act_Genera	char(1)			-- Actualizacion: Generacion

-- Asignacion de valores de Constantes
select	@Str_Ceros	= '0000000000',	-- String de Ceros para conversiones de numeros a valores string
		@Ent_Cero	= 0,			-- Cantidad: Cero
		@Ent_Uno	= 1,			-- Cantidad: Uno
		@Mon_Cero	= 0.00,			-- Monto: Cero
		@Bit_Si		= 1,			-- Bit: Si
		@Bit_No		= 0,			-- Bit: No
		@Str_Si		= 'S',			-- String: Si
		@Str_No		= 'N',			-- String: No
		@Mod_Cheque	= 'CH',			-- Modulo: Cheques
		@Per_PerMor	= 1,			-- Personalidad Fiscal: Persona Moral
		@Sta_CueAct	= 'A',			-- Status Cuenta: Activa
		@Tip_CoCuNu	= 1,			-- Tipo de Configuracion: Cuenta Nueva
		@Tip_CoCaTi	= 2,			-- Tipo de Configuracion: Cuenta Cambia de Tipo de Cuenta
		@Tip_CaChEx	= 4,			-- Tipo Calculo: Cheques Expedidos
		@Tip_CaMaCu	= 2,			-- Tipo Calculo: Manejo de Cuenta
		@Tip_CaBaEl	= 8,			-- Tipo Calculo: Banca Electronica
		@Tip_CheExp	= '000005',		-- Tipo de Movimiento: Cheques Expedidos
		@Tip_ManCue	= '000003',		-- Tipo de Movimiento: Manejo de Cuenta
		@Tip_BanEle	= '000013',		-- Tipo de Movimiento: Banca Electronica
		@Fec_Vacia	= '19000101',	-- Fecha: Vacia
		@Etm_CoChEx	= 6,			-- Elemento de Tipo de Calculo: Comision de Cheques Expedidos
		@Etm_MesGra	= 15,			-- Elemento de Tipo de Calculo: Meses de Gracia
		@Mon_Peso	= '01',			-- Moneda: 01 Peso
		@Mon_Dolar	= '02',			-- Moneda: 02 Dolar
		@Tip_UsuAdm	= 'A',			-- Tipo de Usuario Administrador
		@Sta_Cancel	= 'C', 			-- Status Cancelado
		@Sta_Inacti	= 'I',			-- Status Inactivo
		@Cli_Vacio	= '00000000',	--	Cliente Vacio
		@Men_Vacio	= '',			-- Mensaje Vacio
		@Act_Genera	= 'G'			-- Actualizacion: Generacion

-- La Fecha de proceso es el dia actual del sistema
select	@Fec_Proces	= Par_FecAct
	from SOPARAMS noholdlock
	where Par_Sucurs	= @SucOrigen

-- Eliminar informacion de Bitacora de la Fecha de Proceso
delete SOBICOCU
	where Bcc_FecPro	= @Fec_Proces
	
-- Obtener la Fecha de Corte del mes anterior
select	@Fec_IniMes	= dateadd(dd, -@Ent_Uno * datepart(dd, @Fec_Proces) + @Ent_Uno, @Fec_Proces)

select	@Fec_CorAnt	= @Fec_IniMes

execute @Status	= SOANTFECHAB
						@Fecha		= @Fec_CorAnt output,
						@NumDia		= @Ent_Uno,
						@FinSem 	= @Str_No,
						@Salida_Fox	= @Str_No

if @Status <> @Ent_Cero begin
	select	@Bcc_MenGen = 'Error al obtener la Fecha de Corte del mes anterior'
	
	-- Insertar registro de Bitacora
	execute	@Status	= SOBICOCUALT
						@Bcc_FecPro	= @Fec_Proces,
						@Bcc_CanCue	= @Ent_Cero,
						@Bcc_CanCli	= @Ent_Cero,
						@Bcc_CaReCu	= @Ent_Cero,
						@Bcc_CaReCl	= @Ent_Cero,
						@Bcc_GenExi	= @Bit_No,
						@Bcc_TraExi	= @Bit_No,
						@Bcc_MenGen	= @Bcc_MenGen,
						@Bcc_MenTra	= @Men_Vacio,
						@NumTransac	= @NumTransac,	
						@Transaccio	= @Transaccio,
						@Usuario	= @Usuario,
						@FechaSis	= @FechaSis,
						@SucOrigen	= @SucOrigen,
						@SucDestino	= @SucDestino,
						@Modulo		= @Modulo
						
	return @Ent_Uno
end

-- Insertar registro de Bitacora
execute	@Status	= SOBICOCUALT
					@Bcc_FecPro	= @Fec_Proces,
					@Bcc_CanCue	= @Ent_Cero,
					@Bcc_CanCli	= @Ent_Cero,
					@Bcc_CaReCu	= @Ent_Cero,
					@Bcc_CaReCl	= @Ent_Cero,
					@Bcc_GenExi	= @Bit_No,
					@Bcc_TraExi	= @Bit_No,
					@Bcc_MenGen	= @Men_Vacio,
					@Bcc_MenTra	= @Men_Vacio,
					@NumTransac	= @NumTransac,	
					@Transaccio	= @Transaccio,
					@Usuario	= @Usuario,
					@FechaSis	= @FechaSis,
					@SucOrigen	= @SucOrigen,
					@SucDestino	= @SucDestino,
					@Modulo		= @Modulo

-- Si no se tienen datos en la tabla CHHISCUE en la fecha anterior, entonces no se puede hacer la comparacion para obtener Cuentas nuevas y que cambien de Tipo de Cuenta.
if not exists (select Cue_Numero
				from CHHISCUE noholdlock
				where Cue_FecCor	= @Fec_CorAnt) begin
				
	select	@Bcc_MenGen = 'No se tiene informacion de Cuentas del mes anterior'
	
	-- Insertar registro de Bitacora
	execute	@Status	= SOBICOCUACT
						@Bcc_FecPro	= @Fec_Proces,
						@Bcc_CanCue	= @Ent_Cero,
						@Bcc_CanCli	= @Ent_Cero,
						@Bcc_CaReCu	= @Ent_Cero,
						@Bcc_CaReCl	= @Ent_Cero,
						@Bcc_GenExi	= @Bit_No,
						@Bcc_TraExi	= @Bit_No,
						@Bcc_MenGen	= @Bcc_MenGen,
						@Bcc_MenTra	= @Men_Vacio,
						@Tip_Actual	= @Act_Genera,
						@NumTransac	= @NumTransac,	
						@Transaccio	= @Transaccio,
						@Usuario	= @Usuario,
						@FechaSis	= @FechaSis,
						@SucOrigen	= @SucOrigen,
						@SucDestino	= @SucDestino,
						@Modulo		= @Modulo	
	
	return @Ent_Uno			
end


-- Productos a procesar con Tipo de Cuenta, Personalidad Fiscal, Comision
insert into #ProductosPro(	Prp_Produc, Prp_TiCuEn, Prp_MonEnt, Prp_TipCue, Prp_Moneda,
							Prp_PrPeFi,	Prp_PeFiEn,	Prp_PerFis,	Prp_PrTiMo,	Prp_TiMoEn,
							Prp_TipMov,	Prp_TiCaMo,	Prp_CheGra)
select	Pro_Numero, Prp_TiCuEn	= Ptc_TipCue, Prp_MonEnt	= Ptc_Moneda, 
		Prp_TipCue	= substring(@Str_Ceros, 1, 2 - len(rtrim(convert(char(2), Ptc_TipCue)))) + rtrim(convert(char(2), Ptc_TipCue)),
		Prp_Moneda	= substring(@Str_Ceros, 1, 2 - len(rtrim(convert(char(2), Ptc_Moneda)))) + rtrim(convert(char(2), Ptc_Moneda)),
		Prp_PrPeFi	= Ppf_Numero,	Prp_PeFiEn	= Ppf_PerFis,
		Prp_PerFis	= rtrim(convert(char(1), Ppf_PerFis)),
		Prp_PrTiMo	= Ptm_Numero,	Prp_TiMoEn	= Ptm_TipMov,
		Prp_TipMov	= substring(@Str_Ceros, 1, 6 - len(rtrim(convert(char(6), Ptm_TipMov)))) + rtrim(convert(char(6), Ptm_TipMov)),
		Dat_TiCaMo,	Prp_CheGra	= @Ent_Cero 
from SOTIPPRO noholdlock
inner join SOSUBPRO noholdlock
		on Sup_TipPro	= Tip_Numero
		and Sup_Activo	= @Bit_Si
inner join SOPRODUC noholdlock
		on Pro_SubPro	= Sup_Numero
		and Pro_Activo	= @Bit_Si
inner join SOPRTICU noholdlock
		on Ptc_Produc	= Pro_Numero
inner join SOPRPEFI noholdlock
		on Ppf_Produc	= Pro_Numero
		and Ppf_Activo	= @Bit_Si
inner join SOPRTIMO noholdlock
		on Ptm_PrPeFi	= Ppf_Numero
		and Ptm_Activo	= @Bit_Si
inner join SODAADTI noholdlock
		on Dat_TipMov	= Ptm_TipMov
		and Dat_Activo	= @Bit_Si
where Tip_Modulo	= @Mod_Cheque
  and Tip_Activo	= @Bit_Si

-- Obtener los Cheques Gratis por Producto y Personalidad Fiscal
update #ProductosPro
	set Prp_CheGra	= case when Prp_PeFiEn = @Per_PerMor then Tip_NoChPM - @Ent_Uno else Tip_NoChPF - @Ent_Uno end
	from CHTIPOS noholdlock
	where Tip_Numero	= Prp_TipCue
	  and Tip_Moneda	= Prp_Moneda
		
-- Eliminar registros de la tabla de Configuraciones de Cuentas, de la Fecha de Proceso
delete SOCOCUNU
	where Ccn_FecPro	= @Fec_Proces
	
-- Eliminar registros de la tabla Configuraciones de Clientes, de la Fecha de Proceso.
delete SOCOCLCA
	where Ccc_FecPro	= @Fec_Proces

-- Nuevas Cuentas. Son las Cuentas que no tienen un Historial en CHHISCUE ---------------------
insert into #CuentasNue(Cun_Cuenta, Cun_TipCue, Cun_Moneda, Cun_Client)
select Cue.Cue_Numero, Cue.Cue_Tipo, Cue.Cue_Moneda, Cue.Cue_Client
	from CHCUENTA Cue noholdlock
	left join CHHISCUE HisCue noholdlock
			on HisCue.Cue_Numero	= Cue.Cue_Numero
			and HisCue.Cue_FecCor	= @Fec_CorAnt
	where Cue.Cue_Status	= @Sta_CueAct
	  and HisCue.Cue_Numero	is null

-- No procesar las Cuentas que ya hayan sido procesadas en un dia anterior durante este mismo mes.
delete #CuentasNue
	where Cun_Cuenta	in	(
								select distinct Ccn_Cuenta
								from SOCOCUNU noholdlock
								where Ccn_FecPro	>=	@Fec_IniMes
							)


-- Configuraciones a Nivel Cuenta de Cheques Expedidos
insert into SOCOCUNU(	Ccn_FecPro,	Ccn_TipCon,	Ccn_TipMov,	Ccn_Cuenta,	Ccn_Vigenc,	
						Ccn_FecIni,	Ccn_FecFin,	Ccn_Produc,	Ccn_PerFis,	Ccn_PrPeFi,	
						Ccn_PrTiMo,	Ccn_Aplica,	Ccn_Termin,	Ccn_ElTiMo,	Ccn_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_CheExp,	Cun_Cuenta,	@Bit_No,			
		@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
		Prp_PrTiMo,	
		Dat_Aplica = case when Coc_CobExp = @Str_Si then @Bit_Si else @Bit_No end, 
		Dat_Termin = @Bit_No,	Etm_Numero, 
		Etc_Valor = case when Coc_CobExp = @Str_Si then case when Etm_Numero = @Etm_CoChEx then Coc_CheExp else Prp_CheGra end else @Mon_Cero end,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,
		@SucDestino
	from #ProductosPro noholdlock
	inner join #CuentasNue noholdlock
			on Cun_TipCue	= Prp_TipCue
			and Cun_Moneda	= Prp_Moneda
	inner join CLCOMCUE noholdlock
			on Coc_Cuenta	= Cun_Cuenta
			and Coc_CobExp	= @Str_No
	left join CLLIMCHE noholdlock
			on LiC_Client	= Cun_Client
			and LiC_Moneda	= Cun_Moneda
			and LiC_CobExp	= @Str_No
	inner join SOELTIMO noholdlock
			on Etm_TiCaMo	= @Tip_CaChEx	
			and Etm_Activo	= @Bit_Si
	where Prp_TipMov	= @Tip_CheExp		
	  and LiC_Client	is null
	union all
	select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_CheExp,	Cun_Cuenta,	@Bit_No,			
			@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
			Prp_PrTiMo,	
			Dat_Aplica = case when Coc_CobExp = @Str_Si then @Bit_Si else @Bit_No end, 
			Dat_Termin = @Bit_No,	Etm_Numero, 
			Etc_Valor = case when Coc_CobExp = @Str_Si then case when Etm_Numero = @Etm_CoChEx then Coc_CheExp else Prp_CheGra end else @Mon_Cero end,
			@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,
			@SucDestino
		from #ProductosPro noholdlock
		inner join #CuentasNue noholdlock
				on Cun_TipCue	= Prp_TipCue
				and Cun_Moneda	= Prp_Moneda
		inner join CLCOMCUE noholdlock
				on Coc_Cuenta	= Cun_Cuenta
				and Coc_CobExp	= @Str_Si
				and Coc_CheExp	> @Mon_Cero
		left join CLLIMCHE noholdlock
				on LiC_Client	= Cun_Client
				and LiC_Moneda	= Cun_Moneda
				and LiC_CobExp	= @Str_No
		inner join SOELTIMO noholdlock
				on Etm_TiCaMo	= @Tip_CaChEx	
				and Etm_Activo	= @Bit_Si
		where Prp_TipMov	= @Tip_CheExp		
		  and LiC_Client	is null
	
	

-- Configuraciones a Nivel Cuenta de Manejo de Cuenta
insert into SOCOCUNU(	Ccn_FecPro,	Ccn_TipCon,	Ccn_TipMov,	Ccn_Cuenta,	Ccn_Vigenc,	
						Ccn_FecIni,	Ccn_FecFin,	Ccn_Produc,	Ccn_PerFis,	Ccn_PrPeFi,	
						Ccn_PrTiMo,	Ccn_Aplica,	Ccn_Termin,	Ccn_ElTiMo,	Ccn_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_ManCue,	Cun_Cuenta,	@Bit_No,			
		@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
		Prp_PrTiMo,		Ptm_Aplica =  @Bit_No, 
		Dat_Termin = @Bit_No,	Etm_Numero, Etc_Valor = @Mon_Cero,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,
		@SucDestino
	from #ProductosPro noholdlock
	inner join #CuentasNue noholdlock
			on Cun_TipCue	= Prp_TipCue
			and Cun_Moneda	= Prp_Moneda
	inner join CLCOMCUE noholdlock
			on Coc_Cuenta	= Cun_Cuenta
			and Coc_CobCue = @Str_No
	left join CLLIMCHE noholdlock
			on LiC_Client	= Cun_Client
			and LiC_Moneda	= Cun_Moneda
			and LiC_CobCue	= @Str_No
	inner join SOELTIMO noholdlock
			on Etm_TiCaMo	= @Tip_CaMaCu	
			and Etm_Activo	= @Bit_Si
	where Prp_TipMov	= @Tip_ManCue		
	  and LiC_Client	is null
	
----------------------------------------------------------------
-- Nuevos Clientes ---------------------------------------------
----------------------------------------------------------------

insert into #ClientesNue(	Cln_Client,	Cln_TipCue,	Cln_Moneda)
	select distinct Cun_Client,	Cun_TipCue,	Cun_Moneda
	from #CuentasNue noholdlock

-- No procesar los Clientes que ya hayan sido procesados en un dia anterior durante este mismo mes.
delete #ClientesNue
	where Cln_Client	in	(
								select distinct Ccc_Client
								from SOCOCLCA noholdlock
								where Ccc_FecPro	>=	@Fec_IniMes
							)

-- Configuraciones a Nivel Cliente de Cheques Expedidos
insert into SOCOCLCA(	Ccc_FecPro,	Ccc_TipCon,	Ccc_TipMov,	Ccc_Client,	Ccc_Vigenc,	
						Ccc_FecIni,	Ccc_FecFin,	Ccc_Produc,	Ccc_PerFis,	Ccc_PrPeFi,	
						Ccc_PrTiMo,	Ccc_Aplica,	Ccc_Termin,	Ccc_ElTiMo,	Ccc_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_CheExp,	Cln_Client,	@Bit_No,			
			@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
			Prp_PrTiMo,	
			Dat_Aplica = case when LiC_CobExp = @Str_Si then @Bit_Si else @Bit_No end, 
			Dat_Termin = case when LiC_CobExp = @Str_No then @Bit_Si else @Bit_No end,	Etm_Numero, 
			Etc_Valor = case when LiC_CobExp = @Str_Si then case when Etm_Numero = @Etm_CoChEx then LiC_CheExp else Prp_CheGra end else @Mon_Cero end,
			@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	@SucOrigen,
			@SucDestino	
	from #ProductosPro noholdlock
	inner join #ClientesNue noholdlock
			on Cln_TipCue	= Prp_TipCue
			and Cln_Moneda	= Prp_Moneda
	inner join CLLIMCHE noholdlock
			on LiC_Client	= Cln_Client
			and LiC_Moneda	= Cln_Moneda
			and LiC_CobExp	= @Str_No
	inner join SOELTIMO noholdlock
			on Etm_TiCaMo	= @Tip_CaChEx	
			and Etm_Activo	= @Bit_Si
	where Prp_TipMov	= @Tip_CheExp		
	union all
		select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_CheExp,	Cln_Client,	@Bit_No,			
				@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
				Prp_PrTiMo,	
				Dat_Aplica = case when LiC_CobExp = @Str_Si then @Bit_Si else @Bit_No end, 
				Dat_Termin = case when LiC_CobExp = @Str_No then @Bit_Si else @Bit_No end,	Etm_Numero, 
				Etc_Valor = case when LiC_CobExp = @Str_Si then case when Etm_Numero = @Etm_CoChEx then LiC_CheExp else Prp_CheGra end else @Mon_Cero end,
				@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	@SucOrigen,
				@SucDestino	
		from #ProductosPro noholdlock
		inner join #ClientesNue noholdlock
				on Cln_TipCue	= Prp_TipCue
				and Cln_Moneda	= Prp_Moneda
		inner join CLLIMCHE noholdlock
				on LiC_Client	= Cln_Client
				and LiC_Moneda	= Cln_Moneda
				and LiC_CobExp	= @Str_Si
				and LiC_CheExp	> @Mon_Cero
		inner join SOELTIMO noholdlock
				on Etm_TiCaMo	= @Tip_CaChEx	
				and Etm_Activo	= @Bit_Si
		where Prp_TipMov	= @Tip_CheExp		
	

-- Configuraciones a Nivel Cliente de Manejo de Cuenta
insert into SOCOCLCA(	Ccc_FecPro,	Ccc_TipCon,	Ccc_TipMov,	Ccc_Client,	Ccc_Vigenc,	
						Ccc_FecIni,	Ccc_FecFin,	Ccc_Produc,	Ccc_PerFis,	Ccc_PrPeFi,	
						Ccc_PrTiMo,	Ccc_Aplica,	Ccc_Termin,	Ccc_ElTiMo,	Ccc_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_ManCue,	Cln_Client,	@Bit_No,			
			@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
			Prp_PrTiMo,	
			Dat_Aplica =  @Bit_No, 
			Dat_Termin = @Bit_Si,	Etm_Numero, 
			Etc_Valor = @Mon_Cero,
			@NumTransac,	@Transaccio,@Usuario,			@FechaSis,	@SucOrigen,
			@SucDestino 	
	from #ProductosPro noholdlock
	inner join #ClientesNue noholdlock
			on Cln_TipCue	= Prp_TipCue
			and Cln_Moneda	= Prp_Moneda
	inner join CLLIMCHE noholdlock
			on LiC_Client	= Cln_Client
			and LiC_Moneda	= Cln_Moneda
			and LiC_CobCue	= @Str_No
	inner join SOELTIMO noholdlock
			on Etm_TiCaMo	= @Tip_CaMaCu	
			and Etm_Activo	= @Bit_Si
	where Prp_TipMov	= @Tip_ManCue		

	
				
-- Configuraciones a Nivel Cliente de Banca Electronica	
insert into #ClientesBan(	Clb_Client,	Clb_TipCli,	Clb_TiAcEm,	Clb_TipCue,	Clb_Moneda,	
							Clb_Aplica,	Clb_CoBaEl)
	select	Cli_Numero, Cli_Tipo, Cli_ActEmp, Cue_Tipo, Cue_Moneda, 
			Com_Aplica = min(Lim_CobBaE), Com_BanEle = min(case when Lim_CobBaE = @Str_Si then Lim_CoBaEl else @Mon_Cero end) 
	from #ClientesNue noholdlock
	inner join CLLIMITE noholdlock
			on Lim_Client	= Cln_Client
			and Lim_Moneda in (@Mon_Peso, @Mon_Dolar)
			and Lim_CobBaE = @Str_No
	inner join CLCLIENT noholdlock
			on Cli_Numero = Lim_Client
			and Cli_Status = @Str_Si
	inner join CHCUENTA noholdlock
			on Cue_Client = Lim_Client
			and Cue_Moneda = Lim_Moneda
			and Cue_Status = @Sta_CueAct
	inner join NBUSUARI noholdlock
			on Usu_CuCaCo = Cue_Numero
			and Usu_Tipo   = @Tip_UsuAdm
		  	and	Usu_Status not in (@Sta_Cancel, @Sta_Inacti)	
		  	and Usu_Client > @Cli_Vacio			
	group by Cli_Numero, Cli_Tipo, Cli_ActEmp, Cue_Tipo, Cue_Moneda
	union all
		select	Cli_Numero, Cli_Tipo, Cli_ActEmp, Cue_Tipo, Cue_Moneda, 
				Com_Aplica = min(Lim_CobBaE), Com_BanEle = min(case when Lim_CobBaE = @Str_Si then Lim_CoBaEl else @Mon_Cero end) 
		from #ClientesNue noholdlock
		inner join CLLIMITE noholdlock
				on Lim_Client	= Cln_Client
				and Lim_Moneda in (@Mon_Peso, @Mon_Dolar)
				and Lim_CobBaE = @Str_Si
				and Lim_CoBaEl > @Mon_Cero
		inner join CLCLIENT noholdlock
				on Cli_Numero = Lim_Client
				and Cli_Status = @Str_Si
		inner join CHCUENTA noholdlock
				on Cue_Client = Lim_Client
				and Cue_Moneda = Lim_Moneda
				and Cue_Status = @Sta_CueAct
		inner join NBUSUARI noholdlock
				on Usu_CuCaCo = Cue_Numero
				and Usu_Tipo   = @Tip_UsuAdm
				and	Usu_Status not in (@Sta_Cancel, @Sta_Inacti)	-- ('C', 'I')
				and Usu_Client > @Cli_Vacio			
		group by Cli_Numero, Cli_Tipo, Cli_ActEmp, Cue_Tipo, Cue_Moneda
	
	
insert into SOCOCLCA(	Ccc_FecPro,	Ccc_TipCon,	Ccc_TipMov,	Ccc_Client,	Ccc_Vigenc,	
						Ccc_FecIni,	Ccc_FecFin,	Ccc_Produc,	Ccc_PerFis,	Ccc_PrPeFi,	
						Ccc_PrTiMo,	Ccc_Aplica,	Ccc_Termin,	Ccc_ElTiMo,	Ccc_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,	@Tip_CoCuNu,	@Tip_BanEle,	Clb_Client,	@Bit_No,			
			@Fec_Vacia,		@Fec_Vacia,		Prp_Produc,		Prp_PeFiEn,	Prp_PrPeFi,	
			Prp_PrTiMo,	
			Dat_Aplica = case when Clb_Aplica = @Str_No then @Bit_No else @Bit_Si end, 
			Dat_Termin = case when Clb_Aplica = @Str_No then @Bit_Si else @Bit_No end,	Etm_Numero, 
			Etc_Valor =case when Etm_Numero = @Etm_MesGra then @Mon_Cero else Clb_CoBaEl end,
			@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,	@SucOrigen,
			@SucDestino
	from #ProductosPro noholdlock
	inner join #ClientesBan noholdlock
			on Clb_TipCue	= Prp_TipCue
			and Clb_Moneda	= Prp_Moneda
	inner join SOELTIMO noholdlock
			on Etm_TiCaMo	= @Tip_CaBaEl	
			and Etm_Activo	= @Bit_Si
	where Prp_TipMov	= @Tip_BanEle		


-----------------------------------------------------------------------
-- Cuentas que Cambian de Tipo de Cuenta -------------------------------
-----------------------------------------------------------------------

-- Cuentas que cambian de Tipo de Cuenta
insert into #CuentasCam(	Cca_Cuenta,	Cca_Client,	Cca_TipCli,	Cca_TiAcEm,	Cca_PerFis,
								Cca_TiCuAn,	Cca_MonAnt,	Cca_TiCuNu,	Cca_MonNue)
	select	Cue.Cue_Numero, Cue.Cue_Client, Cli_Tipo, Cli_ActEmp, Pfc_PerFis, 
		Cue.Cue_Tipo, Cue.Cue_Moneda, HisCue.Cue_Tipo, HisCue.Cue_Moneda
	from CHCUENTA Cue noholdlock
	inner join CHHISCUE HisCue noholdlock
			on HisCue.Cue_Numero	= Cue.Cue_Numero
			and HisCue.Cue_FecCor	= @Fec_CorAnt
			and HisCue.Cue_Tipo	<> Cue.Cue_Tipo
	inner join CLCLIENT (index 0) noholdlock
			on Cli_Numero	= Cue.Cue_Client
	inner join SOPEFICL noholdlock
			on Pfc_NuPeCl	= Cli_Tipo
			and Pfc_ActEmp	= Cli_ActEmp
	where Cue.Cue_Status	= @Sta_CueAct

-- No procesar las Cuentas que ya hayan sido procesadas en un dia anterior durante este mismo mes.
delete #CuentasCam
	where Cca_Cuenta	in	(
								select distinct Ccn_Cuenta
								from SOCOCUNU noholdlock
								where Ccn_FecPro	>=	@Fec_IniMes
							)

insert into SOCOCUNU(	Ccn_FecPro,	Ccn_TipCon,	Ccn_TipMov,	Ccn_Cuenta,	Ccn_Vigenc,	
						Ccn_FecIni,	Ccn_FecFin,	Ccn_Produc,	Ccn_PerFis,	Ccn_PrPeFi,	
						Ccn_PrTiMo,	Ccn_Aplica,	Ccn_Termin,	Ccn_ElTiMo,	Ccn_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,					@Tip_CoCaTi,					ProAnt.Prp_TipMov,	Cca_Cuenta, 		Ctm_Vigenc, 		
			isnull(Vct_FecIni, @Fec_Vacia), isnull(Vct_FecFin, @Fec_Vacia),	ProNue.Prp_Produc,	ProNue.Prp_PeFiEn,	ProNue.Prp_PrPeFi,	
			ProNue.Prp_PrTiMo,				Tma_Aplica, 					Tma_Termin,			Etc_ElTiMo,			Etc_Valor,
			@NumTransac,					@Transaccio,					@Usuario,			@FechaSis,			@SucOrigen,
			@SucDestino
	from #CuentasCam noholdlock
	inner join SOCOTICU noholdlock
			on Ctu_Cuenta = Cca_Cuenta
			and Ctu_Activo	= @Bit_Si
	inner join SOCOTIMO noholdlock
			on Ctm_Numero	= Ctu_CoTiMo
			and Ctm_Activo	= @Bit_Si
	left join SOVICOTI noholdlock
			on Vct_CoTiMo	= Ctm_Numero
			and Vct_Activo	= @Bit_Si
	inner join #ProductosPro ProAnt noholdlock
			on ProAnt.Prp_TipCue	= Cca_TiCuAn
			and ProAnt.Prp_Moneda	= Cca_MonAnt
			and ProAnt.Prp_PeFiEn	= Cca_PerFis
	inner join SOPRPECO noholdlock
			on Ppc_CoTiMo	= Ctm_Numero
			and Ppc_PrPeFi	= ProAnt.Prp_PrPeFi
			and Ppc_Activo	= @Bit_Si
	inner join SOTIMOAS noholdlock
			on Tma_PrPeCo	= Ppc_Numero
			and Tma_PrTiMo	= ProAnt.Prp_PrTiMo
			and Tma_Activo	= @Bit_Si
	inner join SOELTICA noholdlock
			on Etc_TiMoAs	= Tma_Numero
			and Etc_Activo	= @Bit_Si
	inner join #ProductosPro ProNue noholdlock
			on ProNue.Prp_TipCue	= Cca_TiCuNu
			and ProNue.Prp_Moneda	= Cca_MonNue
			and ProNue.Prp_PeFiEn	= Cca_PerFis
	where ProAnt.Prp_TipMov	= ProNue.Prp_TipMov
	order by Cca_Cuenta
	
				
-- Clientes de Cuentas que cambian de Tipo de Cuenta
insert into #ClientesCam(	Clc_Client,	Clc_CliNum,	Clc_TipCli,	Clc_TiAcEm,	Clc_PerFis,	
							Clc_TiCuAn,	Clc_MonAnt,	Clc_TiCuNu,	Clc_MonNue)			
	select distinct	Cca_Client,	convert(int, Cca_Client),	Cca_TipCli,	Cca_TiAcEm,	Cca_PerFis,	
					Cca_TiCuAn,	Cca_MonAnt,	Cca_TiCuNu,	Cca_MonNue
	from #CuentasCam noholdlock				
	
-- No procesar los Clientes que ya hayan sido procesados en un dia anterior durante este mismo mes.
delete #ClientesCam
	where Clc_Client	in	(
								select distinct Ccc_Client
								from SOCOCLCA noholdlock
								where Ccc_FecPro	>=	@Fec_IniMes
							)
	
insert into SOCOCLCA(	Ccc_FecPro,	Ccc_TipCon,	Ccc_TipMov,	Ccc_Client,	Ccc_Vigenc,	
						Ccc_FecIni,	Ccc_FecFin,	Ccc_Produc,	Ccc_PerFis,	Ccc_PrPeFi,	
						Ccc_PrTiMo,	Ccc_Aplica,	Ccc_Termin,	Ccc_ElTiMo,	Ccc_Valor,
						NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,
						SucDestino)
	select	@Fec_Proces,					@Tip_CoCaTi,					ProAnt.Prp_TipMov,	Clc_Client,			Ctm_Vigenc, 		
			isnull(Vct_FecIni, @Fec_Vacia),	isnull(Vct_FecFin, @Fec_Vacia),	ProNue.Prp_Produc,	ProNue.Prp_PeFiEn,	ProNue.Prp_PrPeFi,	
			ProNue.Prp_PrTiMo,				Tma_Aplica, 					Tma_Termin,			Etc_ElTiMo, 		Etc_Valor,
			@NumTransac,					@Transaccio,					@Usuario,			@FechaSis,			@SucOrigen,
			@SucDestino
	from #ClientesCam noholdlock
	inner join SOCOTICL noholdlock
			on Ctc_Client = Clc_CliNum
			and Ctc_Activo	= @Bit_Si
	inner join SOCOTIMO noholdlock
			on Ctm_Numero	= Ctc_CoTiMo
			and Ctm_Activo	= @Bit_Si
	left join SOVICOTI noholdlock
			on Vct_CoTiMo	= Ctm_Numero
			and Vct_Activo	= @Bit_Si
	inner join #ProductosPro ProAnt noholdlock
			on ProAnt.Prp_TipCue	= Clc_TiCuAn
			and ProAnt.Prp_Moneda	= Clc_MonAnt
			and ProAnt.Prp_PeFiEn	= Clc_PerFis
	inner join SOPRPECO noholdlock
			on Ppc_CoTiMo	= Ctm_Numero
			and Ppc_PrPeFi	= ProAnt.Prp_PrPeFi
			and Ppc_Activo	= @Bit_Si
	inner join SOTIMOAS noholdlock
			on Tma_PrPeCo	= Ppc_Numero
			and Tma_PrTiMo	= ProAnt.Prp_PrTiMo
			and Tma_Activo	= @Bit_Si
	inner join SOELTICA noholdlock
			on Etc_TiMoAs	= Tma_Numero
			and Etc_Activo	= @Bit_Si
	inner join #ProductosPro ProNue noholdlock
			on ProNue.Prp_TipCue	= Clc_TiCuNu
			and ProNue.Prp_Moneda	= Clc_MonNue
			and ProNue.Prp_PeFiEn	= Clc_PerFis
	where ProAnt.Prp_TipMov	= ProNue.Prp_TipMov
	order by Clc_Client


-- Registro de Bitacora de Generacion de Configuraciones --

-- Cantidad de Cuentas
-- Cantidad de Registros de Configuraciones de Cuentas
select	@Bcc_CanCue	= count(distinct Ccn_Cuenta), 
		@Bcc_CaReCu	= count(Ccn_Numero)
	from SOCOCUNU noholdlock
	where Ccn_FecPro = @Fec_Proces

-- Cantidad de Clientes
-- Cantidad de Registros de Configuraciones de Clientes
select	@Bcc_CanCli	= count(distinct Ccc_Client), 
		@Bcc_CaReCl	= count(Ccc_Numero)
	from SOCOCLCA noholdlock
	where Ccc_FecPro = @Fec_Proces
	
-- Generacion exitosa de Configuraciones
-- Mensaje de Generacion de Configuraciones
select	@Bcc_GenExi = @Bit_Si,
		@Bcc_MenGen	= @Men_Vacio
		

execute	@Status	= SOBICOCUACT
					@Bcc_FecPro	= @Fec_Proces,
					@Bcc_CanCue	= @Bcc_CanCue,
					@Bcc_CanCli	= @Bcc_CanCli,
					@Bcc_CaReCu	= @Bcc_CaReCu,
					@Bcc_CaReCl	= @Bcc_CaReCl,
					@Bcc_GenExi	= @Bcc_GenExi,
					@Bcc_TraExi	= @Bit_No,
					@Bcc_MenGen	= @Bcc_MenGen,
					@Bcc_MenTra	= @Men_Vacio,
					@Tip_Actual	= @Act_Genera,
					@NumTransac	= @NumTransac,	
					@Transaccio	= @Transaccio,
					@Usuario	= @Usuario,
					@FechaSis	= @FechaSis,
					@SucOrigen	= @SucOrigen,
					@SucDestino	= @SucDestino,
					@Modulo		= @Modulo		
		

-- Eliminar tablas temporales		
drop table #ProductosPro
drop table #CuentasNue
drop table #ClientesNue
drop table #ClientesBan
drop table #CuentasCam
drop table #ClientesCam

