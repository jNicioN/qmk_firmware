--drop procedure CHCATIMOPRO
create procedure CHCATIMOPRO (
	@Pro_Numero	smallint,		/* Proceso para el cual se ejecutarán sus Tipos de Movimientos */
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** DESCRIPCION: Calculo de Tipos de Movimientos por Configuraciones		****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modifico:	Code4u Joel Gonzalez									****
** Fecha:		31/01/2020											    ****
** Help:		1286068											    	****
** Descripcion:	Creacion del procedimiento							    ****
****************************************************************************/

-- Declaración de Variables
declare	@Fec_FecAct	smalldatetime,						/* Fecha */
		@Fec_FecIni	smalldatetime,						/* Fecha Inicio */
		@Fec_FecFin	smalldatetime,						/* Fecha Fin */
		@Fec_FecQui	smalldatetime,						/* Fecha dia quince del mes */
		@Reg_ContTM	int,								/* Contador de Registros de Tipos de Movimientos */ 
		@Reg_TotTM	int,								/* Total de Registros de Tipos de Movimientos */
		@Pro_TipMov	char(6),							/* Tipo de Movimiento a Procesar */
		@Pro_TiCaMo	int,								/* Tipo de Calculo de Movimiento a Procesar */
		@Var_Contin bit,								/* Continuar con proceso que esta por ejecutarse */
		@Str_Descri char(50),							/* Descripcion del proceso ejecutado */
		@Fec_IniPro datetime,							/* Fecha de inicio de proceso ejecutado */
		@Fec_FinPro datetime,							/* Fecha de finalizacion de proceso ejecutado */
		@Cie_Tiempo int,								/* Tiempo de ejecucion del proceso ejecutado */
		@Imp_IVA 	int								/* Numero de Impuesto de IVA */
		

-- Declaración de Constantes
declare	@Bit_Si	bit,				/* Si */
		@Bit_No	bit,				/* No */
		@Str_Cero char(6),			/* String de 6 Ceros */
		@Mon_Cero money,			/* Monto cero */
		@Mon_Uno money,				/* Monto Uno */
		@Can_Cero int,				/* Cantidad cero */
		@Ent_Dos int,				/* Entero dos */
		@Sto_CalCom	varchar(11),	/* Proceso de Cierre de Comisiones */
		@Str_TiMoMa char(6),		/* 000003 Comision por Manejo de cuenta */
		@Str_TiMoCh char(6), 		/* 000005 Comision por Cheques expedidos */
		@Str_TiMoAn char(6), 		/* 000007 Comision por Aniversario */
		@Str_TiMoAp char(6), 		/* 000009 Comision por Apertura */
		@Str_TiMoBa char(6), 		/* 000013 Comision por Banca Electronica */
		@Str_TiMoCu char(6), 		/* 000099 CUOTA MENSUAL */
		@Str_TiMoIn char(6), 		/* 000122 Comision por Inactividad de Cuenta */
		@Str_Activo	char(1),		/* String Activo */
		@Ele_Comisi	int,			/* Elemento Comision */
		@Etm_Comisi	int,			/* Elemento Comision en ETM */
		@Ele_ComBas	int,			/* Elemento Comision Basica en BE */
		@Etm_ComBas	int,			/* Elemento Comision Basica en BE en ETM*/
		@Ele_MesGra	int,			/* Elemento Meses Gratis en BE */
		@Etm_MesGra	int,			/* Elemento Meses Gratis en BE en ETM */
		@Ele_CheGra	int,			/* Elemento Cheques Gratis */
		@Etm_CheGra	int,			/* Elemento Cheques Gratis en ETM */
		@Ele_SaPrMi	int,			/* Elemento Saldo Promedio Minimo */
		@Etm_SaPrMi	int,			/* Elemento Saldo Promedio Minimo en ETM */
		@Ele_ExeCuo int,			/* Elemento Exenta Cuota (La Cuenta podria Exenta la Cuota si cumple con el SPM) */
		@Etm_ExeCuo int,			/* Elemento Exenta Cuota (La Cuenta podria Exenta la Cuota si cumple con el SPM) en ETM */
		@Ele_MesIna	int,			/* Elemento Meses de Inactividad */
		@Etm_MesIna	int,			/* Elemento Meses de Inactividad en ETM */
		@Tip_Admini char(1),		/* Usuario de BE princial del Cliente */
		@Sta_Cancel char(1),		/* Status Usuario BE Cancelado */
		@Sta_Inacti char(1),		/* Status Usuario BE Inactivo */
		@Cli_Vacio char(8),			/* Cliente vacio -> '00000000' */
		@Sta_Activo char(1),		/* Status Activo */
		@Tip_AccCom char(1),		/* Tipo de Acceso: Completo */
		@Tip_AccNom char(1),		/* Tipo de Acceso: Nomina */
		@Mot_ApeQui smallint,		/* Motivo Excencion Calculo: 1.- Apertura posterior al dia 15 */
		@Mot_PagNom smallint,		/* Motivo Excencion Calculo: 2.- Cliente Paga Nomina de Empleados en Banregio */
		@Mot_PaCoIn smallint,		/* Motivo Excencion Calculo: 3.- Paga Comision de Inactivad */
		@Mot_ApeMes smallint,		/* Motivo Excencion Calculo: 4.- Apertura dentro del mes de proceso */
		@Mot_Modali smallint,		/* Motivo Excencion Calculo: 5.- Cuentas con Exencion por Modalidad */
		@Mot_NoSaDi smallint,		/* Motivo Excencion Calculo: 6.- Cuentas sin Saldo Disponible */
		@Mot_FecVac smallint,		/* Motivo Excencion Calculo: 7.- Cuenta sin Fecha de Apertura: NULL o 01/01/1900 */
		@Sta_Pagado char(1),		/* Status Nomina Pagada */
		@Mon_Minimo money,			/* Monto minimo de Pago de Nomina */
		@Fec_Vacia	smalldatetime	/* Fecha Vacia */
		
-- Asignación de Constantes
select	@Bit_Si	=	1,					/* Si (bit)*/
		@Bit_No	=	0,					/* No (bit) */
		@Str_Cero = '000000',			/* String de 6 Ceros */
		@Mon_Cero = 0.00,				/* Monto cero */
		@Mon_Uno = 1.00,				/* Monto Uno */
		@Can_Cero = 0,					/* Cantidad cero */
		@Ent_Dos = 2,					/* Entero dos */
		@Sto_CalCom	= 'CHCATIMOPRO',	/* Proceso de Cierre de Comisiones */
		@Str_TiMoMa = '000003',			/* 000003 Comision por Manejo de cuenta */
		@Str_TiMoCh = '000005', 		/* 000005 Comision por Cheques expedidos */
		@Str_TiMoAn = '000007', 		/* 000007 Comision por Aniversario */
		@Str_TiMoAp = '000009', 		/* 000009 Comision por Apertura */
		@Str_TiMoBa = '000013', 		/* 000013 Comision por Banca Electronica */
		@Str_TiMoCu = '000099', 		/* 000099 CUOTA MENSUAL */
		@Str_TiMoIn = '000122',			/* 000122 Comision por Inactividad de Cuenta */
		@Str_Activo	= 'A',				/* Sta: Activa */
		@Ele_Comisi = 1,				/* Elemento Comision */
		@Ele_ComBas = 2,				/* Elemento Comision Basica BE */
		@Ele_MesGra	= 3,				/* Elemento Meses Gratis en BE */
		@Ele_CheGra	= 2,				/* Elemento Cheques Gratis */
		@Ele_SaPrMi	= 2,				/* Elemento Saldo Promedio Minimo */
		@Ele_ExeCuo	= 3,				/* Elemento Exenta Cuota (La Cuenta podria Exenta la Cuota si cumple con el SPM) */
		@Ele_MesIna	= 2,				/* Elemento Meses de Inactividad */
		@Tip_Admini	= 'A',				/* Tipo de Usuario: Administrador */
		@Sta_Cancel = 'C',				/* Status de Administrador: Cancelado*/
		@Sta_Inacti	= 'I',				/* Status de Administrador: Inactivo*/		
		@Cli_Vacio = '00000000',		/* Cliente vacio -> '00000000' */
		@Sta_Activo = 'A',				/* Status Activo */
		@Tip_AccCom = 'C',				/* Tipo de Acceso: Completo */
		@Tip_AccNom = 'N',				/* Tipo de Acceso: Nomina */	
		@Mot_ApeQui = 1,				/* Motivo Excencion Calculo: 1.- Apertura posterior al dia 15 */
		@Mot_PagNom = 2,				/* Motivo Excencion Calculo: 2.- Cliente Paga Nomina de Empleados en Banregio */
		@Mot_PaCoIn = 3,				/* Motivo Excencion Calculo: 3.- Paga Comision de Inactivad */
		@Mot_ApeMes = 4,				/* Motivo Excencion Calculo: 4.- Apertura dentro del mes de proceso */
		@Mot_Modali = 5,				/* Motivo Excencion Calculo: 5.- Cuentas con Exencion por Modalidad */
		@Mot_NoSaDi = 6,				/* Motivo Excencion Calculo: 6.- Cuentas sin Saldo Disponible */
		@Mot_FecVac = 7,				/* Motivo Excencion Calculo: 7.- Cuenta sin Fecha de Apertura: NULL o 01/01/1900 */
		@Sta_Pagado = 'P',				/* Status Nomina Pagada */
		@Mon_Minimo = 100.00,			/* Monto minimo de Pago de Nomina */
		@Fec_Vacia	= '19000101'		/* Fecha Vacia */

create table #Tab_TiMoPr 
		(Tmp_TipMov char(6),			/* Tabla para guardar las Comisiones a Procesar */
		 Tmp_TiCaMo int,					
		Tmp_Numero int identity)	

-- Proceso principal

select @Fec_FecAct = Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen
--En caso de error hacer rollback
if @@error <> 0
begin
	--rollback
	return 1
end

select	@Fec_FecIni		= dateadd(dd, 1, dateadd(dd, - datepart(dd, @Fec_FecAct), @Fec_FecAct))
select	@Fec_FecFin		= dateadd(dd, -1, dateadd(mm, 1, @Fec_FecIni))
select	@Fec_FecQui		= dateadd(dd, 14, @Fec_FecIni)

--Impuesto IVA
select @Imp_IVA = Imp_Numero
	from SOIMPUES
	where Imp_EsIVA = @Bit_Si
--En caso de error hacer rollback
if @@error <> 0
begin
	--rollback
	return 1
end

--Obtener los elementos de cada Nivel para cada Cuenta
--Obtener las Configuraciones Base y con Vigencia en cada Nivel

insert into #Tab_TiMoPr
	(Tmp_TipMov, Tmp_TiCaMo)
	select 	substring(@Str_Cero, 1, 6 - len(rtrim(convert(CHAR(6), Dat_TipMov)))) + rtrim(convert(CHAR(6), Dat_TipMov)),
			Dat_TiCaMo
		from SODAADTI noholdlock
		where Dat_Modulo = @Modulo
		  and Dat_Proces = @Pro_Numero
		  and Dat_Activo = @Bit_Si
		order by Dat_TipMov
--En caso de error hacer rollback
if @@error <> 0
begin
	--rollback
	return 1
end

select @Reg_ContTM	=	min(Tmp_Numero),
		@Reg_TotTM	=	max(Tmp_Numero)
	from #Tab_TiMoPr
	
while (@Reg_ContTM <= @Reg_TotTM) --Ejecutar cada Comision
begin
	--Obtener siguiente Comision
	select @Pro_TipMov = Tmp_TipMov,
			@Pro_TiCaMo = Tmp_TiCaMo
		from #Tab_TiMoPr
		where Tmp_Numero = @Reg_ContTM
	
	-----Inicio Proceso de Comision----
	select @Str_Descri = 'Comision ' + @Pro_TipMov,	/* Descripcion del proceso ejecutado */
			@Fec_IniPro = getdate()					/* Fecha de inicio de proceso ejecutado */
	
	select @FechaSis = getdate()
	exec SOTMPBCCCON 
		@Fec_FecAct, @Sto_CalCom, @Pro_TipMov, @Var_Contin	output, @NumTransac,
		@Transaccio, @Usuario,	@FechaSis, @SucOrigen,	@SucDestino,
		@Modulo
				
	--Iniciar transaccion para cada Comision
	if @Var_Contin = @Bit_Si
	begin
		/* Truncado. 000013 Comision por Banca Electronica @Str_TiMoBa */
		if @Pro_TipMov = @Str_TiMoBa	-- 000013 Comision por Banca Electronica
		begin
			--Vaciar tabla temporal de Cuentas de Usuarios de Banca Electronica
			truncate table SOTMPCBE
		end
	
		begin transaction

		--MODALIDADES----------------------------------------------------------------------------
		--Agregar Exenciones por Modalidades. Para aquellas Comisiones que tenga Exencion por Modalidad.
		insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_Modali,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
			from CHTMPCMO noholdlock
			inner join SOTMPCCN noholdlock
					on Ccn_Cuenta = Cmo_Cuenta
					and Ccn_TipMov = substring('000000', 1, 6 - len(rtrim(convert(CHAR(6), Cmo_TipMov)))) + rtrim(convert(CHAR(6), Cmo_TipMov))
					and Ccn_Activo = @Bit_Si
			left join SOEXAPCA noholdlock
					on Eac_TipMov = Ccn_TipMov
					and Eac_Cuenta = Ccn_Cuenta
			where Cmo_TipMov = convert(int, @Pro_TipMov)
			and Ccn_Activo = @Bit_Si
			and Eac_TipMov is null
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		
		---Inicio de ejecucion de Comision---
		-- 000003 Manejo de Cuenta --@Str_TiMoMa
		if @Pro_TipMov = @Str_TiMoMa	-- 000003 Manejo de Cuenta
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
			
			--Elemento de Saldo Promedio Minimo
			select
				@Etm_SaPrMi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_SaPrMi
				and Etm_Activo = @Bit_Si
			
			--Exencion por Cuentas aperturadas durante el mes de proceso.
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_ApeMes,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero	= Ccn_Cuenta
						and Cue_FecApe	>= @Fec_FecIni
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Exencion por Cuentas Sin Saldo Disponible.
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_NoSaDi,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero	= Ccn_Cuenta
						and Cue_Dispon	< @Mon_Cero
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
			
			--Exencion por Cuentas Sin Fecha de Apertura: NULL o 01/01/1900.
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_FecVac,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero	= Ccn_Cuenta
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and (Cue_FecApe	is null
					or Cue_FecApe = @Fec_Vacia)
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Colocar No Aplica a Cuentas con Excepciones	
			update SOTMPCCN
				set Ccn_Aplica = @Bit_No
				from SOEXAPCA noholdlock
				inner join SOTMPCCN CCN
						on CCN.Ccn_TipMov = Eac_TipMov
						and CCN.Ccn_Cuenta = Eac_Cuenta
						and CCN.Ccn_Activo = @Bit_Si
				where Eac_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_Activo = @Bit_Si
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
			
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,	
						case when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si then
							case when Cue_SalPro >= ETCSAPRMI.Etc_Valor then 
								@Mon_Cero
							else 
								case when ETCSAPRMI.Etc_Valor - Cue_SalPro < ETCELECOM.Etc_Valor then ETCSAPRMI.Etc_Valor - Cue_SalPro else ETCELECOM.Etc_Valor end
							end
						else
							@Mon_Cero
						end,	@Bit_Si,
						Ccn_Aplica,	Tma_Termin,	@Bit_No,	@NumTransac,	@Transaccio,
						@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCSAPRMI noholdlock
						on ETCSAPRMI.Etc_TiMoAs = Tma_Numero
						and ETCSAPRMI.Etc_ElTiMo = @Etm_SaPrMi
						and ETCSAPRMI.Etc_Activo = @Bit_Si		
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end-- 000003 Manejo de Cuenta
				
 		/* 000005 Comision por Cheques expedidos @Str_TiMoCh */
		if @Pro_TipMov = @Str_TiMoCh	-- 000005 Comision por Cheques expedidos
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
			
			--Elemento de Cheques Gratis
			select
				@Etm_CheGra = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_CheGra
				and Etm_Activo = @Bit_Si
		
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,
					case 
						when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si and Cue_NuChEx > @Can_Cero then
							case 
								when Cue_NuChEx >= ETCCHEGRA.Etc_Valor then (Cue_NuChEx - ETCCHEGRA.Etc_Valor) * ETCELECOM.Etc_Valor 
								else @Mon_Cero 
							end
						else
							@Mon_Cero
					end,		@Bit_Si,
					Ccn_Aplica,	Tma_Termin,	@Bit_No,	@NumTransac,	@Transaccio,
					@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCCHEGRA noholdlock
						on ETCCHEGRA.Etc_TiMoAs = Tma_Numero
						and ETCCHEGRA.Etc_ElTiMo = @Etm_CheGra
						and ETCCHEGRA.Etc_Activo = @Bit_Si		
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000005 Comision por Cheques expedidos
				
 		/* 000007 Comision por Aniversario @Str_TiMoAn */
		if @Pro_TipMov = @Str_TiMoAn	-- 000007 Comision por Aniversario
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
		
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,
					case when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si then
						case 
							when datepart(month, Cue_FecApe) = datepart(month, @Fec_FecAct) 
								and datepart(year, Cue_FecApe) < datepart(year, @Fec_FecAct) then 
									ETCELECOM.Etc_Valor 
							else @Mon_Cero end
						else @Mon_Cero
					end,	@Bit_Si,
						Ccn_Aplica,	Tma_Termin,	@Bit_No,	@NumTransac,	@Transaccio,
						@Usuario,	getdate(),	@SucOrigen, @SucDestino
				from SOTMPCCN noholdlock
				inner join CHCUENTA noholdlock
						on Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000007 Comision por Aniversario
				
 		/* 000009 Comision por Apertura @Str_TiMoAp */
		if @Pro_TipMov = @Str_TiMoAp	-- 000009 Comision por Apertura
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
		
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select
					Ccn_Cuenta,@Pro_TipMov,Ccn_TiMoAs,
					case when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si then
						case when DATEPART(year, Cue_FecApe) = DATEPART(year, @Fec_FecAct) 
							and DATEPART(month, Cue_FecApe) = DATEPART(month, @Fec_FecAct) then 
								ETCELECOM.Etc_Valor 
						else @Mon_Cero end
					else
						@Mon_Cero end,
					@Bit_Si,
					Ccn_Aplica,Tma_Termin,@Bit_No,
					@NumTransac,@Transaccio,@Usuario,getdate(),@SucOrigen,	
					@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCUENTA noholdlock
						on Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000009 Comision por Apertura
		 		
 		/* 000013 Comision por Banca Electronica @Str_TiMoBa */
		if @Pro_TipMov = @Str_TiMoBa	-- 000013 Comision por Banca Electronica
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
			--Elemento de Comision Basica
			select
				@Etm_ComBas = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_ComBas
				and Etm_Activo = @Bit_Si
			--Elemento de Meses Gratis
			select
				@Etm_MesGra = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_MesGra
				and Etm_Activo = @Bit_Si
		
		
			insert into SOTMPCBE
					(Cbe_Cuenta, Cbe_Sucurs, Cbe_Moneda, Cbe_TipCue, Cbe_Usuari,
					Cbe_FecAlt,	Cbe_TipAcc)
				select	Usu_CuCaCo, Cli_Sucurs, Cue_Moneda, Cue_Tipo, 	Usu_Numero, 
						Usu_FecAlt, Pau_TipAcc
				from (
							select Usu_CuCaCo, Cli_Sucurs, Cue_Moneda, Cue_Tipo, Usu_Numero = Min(Usu_Numero), 
									Usu_FecAlt = Min(Usu_FecAlt)
								from NBUSUARI noholdlock
								inner join CHCUENTA noholdlock
										on Cue_Numero = Usu_CuCaCo
										and Cue_Status = @Sta_Activo
								inner join CLCLIENT noholdlock
										on Cli_Numero = Cue_Client
							where Usu_Tipo   = @Tip_Admini
							  and Usu_Status not in (@Sta_Cancel, @Sta_Inacti)
							  and Usu_Client > @Cli_Vacio
							group by Usu_CuCaCo, Cli_Sucurs, Cue_Moneda, Cue_Tipo
					) Usu
					inner join NBPARUSU noholdlock
								on Pau_Usuari = Usu_Numero
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Exencion por Cuentas aperturadas durante el mes de proceso para Personas Morales.
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_ApeMes,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero	= Ccn_Cuenta
						and Cue_CliTip	= '1'
				inner join SOTMPCBE nohodlock
						on Cbe_Cuenta = Ccn_Cuenta
						and Cbe_FecAlt >= @Fec_FecIni
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Colocar No Aplica a Cuentas con Excepciones	
			update SOTMPCCN
				set Ccn_Aplica = @Bit_No
				from SOEXAPCA noholdlock
				inner join SOTMPCCN CCN
						on CCN.Ccn_TipMov = Eac_TipMov
						and CCN.Ccn_Cuenta = Eac_Cuenta
						and CCN.Ccn_Activo = @Bit_Si
				where Eac_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_Activo = @Bit_Si
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,
						case 
							when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si 
								and (Ccn_PerFis <> 2 or Cbe_FecAlt < dateadd(mm, (-1 * ETCELMEGR.Etc_Valor), @Fec_FecIni))
							then
								case
									when Cbe_TipAcc in (@Tip_AccCom,@Tip_AccNom) 
									then ETCELECOM.Etc_Valor
									else ETCELCOBA.Etc_Valor
								end 
							else @Mon_Cero 
						end,	@Bit_Si,
						Ccn_Aplica,	Tma_Termin,	@Bit_No,	@NumTransac,	@Transaccio,
						@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCBE
				inner join SOTMPCCN noholdlock
						on Ccn_TipMov = @Pro_TipMov
						and Ccn_Cuenta = Cbe_Cuenta
				  		and Ccn_AplCal = @Bit_Si
				  		and Ccn_Activo = @Bit_Si
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCELCOBA noholdlock
						on ETCELCOBA.Etc_TiMoAs = Tma_Numero
						and ETCELCOBA.Etc_ElTiMo = @Etm_ComBas
						and ETCELCOBA.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCELMEGR noholdlock
						on ETCELMEGR.Etc_TiMoAs = Tma_Numero
						and ETCELMEGR.Etc_ElTiMo = @Etm_MesGra
						and ETCELMEGR.Etc_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000013 Comision por Banca Electronica
		 		
 		/* 000099 CUOTA MENSUAL @Str_TiMoCu */
		if @Pro_TipMov = @Str_TiMoCu	-- 000099 CUOTA MENSUAL
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
			--Elemento de Saldo Promedio Minimo
			select
				@Etm_SaPrMi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_SaPrMi
				and Etm_Activo = @Bit_Si
			--Elemento de Saldo Promedio Minimo
			select
				@Etm_ExeCuo = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_ExeCuo
				and Etm_Activo = @Bit_Si

			--Exencion por Cuentas aperturadas posterior al dia 15 del mes de proceso no pagan Cuota Mensual.
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_ApeQui,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero	= Ccn_Cuenta
						and Cue_FecApe	> @Fec_FecQui
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
			
			--Exencion por Clientes que pagan Nomina de Empleados en Banregio
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_TipMov,	Ccn_Cuenta,	@Mot_PagNom,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join SOELTICA noholdlock		--Generar Exencion cuando la Configuracion indique que si se puede Excentar
						on Etc_TiMoAs = Ccn_TiMoAs
						and Etc_ElTiMo = @Etm_ExeCuo
						and Etc_Valor = @Mon_Uno
				inner join (
					select	Pag_CueCar
					from CHPAGNOM noholdlock
					where Pag_Fecha		>= @Fec_FecIni
					  and Pag_Fecha 	<= @Fec_FecFin
					  and Pag_Status	= @Sta_Pagado
					  and Pag_Cantid 	>= @Mon_Minimo
					group by Pag_CueCar ) PAGNOM
						on PAGNOM.Pag_CueCar = Ccn_Cuenta
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Ccn_Cuenta
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Exencion por Cuentas que pagan Comision por Inactividad
			insert into SOEXAPCA
					(	Eac_TipMov,	Eac_Cuenta,	Eac_MoExCa, Eac_Activo,	NumTransac,	
						Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
				select	distinct 
						Ccn_TipMov,	Ccn_Cuenta,	@Mot_PaCoIn,@Bit_Si,	@NumTransac,	
						@Transaccio,@Usuario,	getdate(),	@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCOINCU Chc noholdlock
						on Chc.Cue_Numero = Ccn_Cuenta
				left join CHMOVRES noholdlock
						on Mov_Cuenta = Chc.Cue_Numero
				left join SOEXAPCA noholdlock
						on Eac_TipMov = Ccn_TipMov
						and Eac_Cuenta = Chc.Cue_Numero
				where Ccn_TipMov = @Pro_TipMov
				and Ccn_Activo = @Bit_Si
				and Eac_TipMov is null						
				and Mov_Cuenta is null
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end

			--Colocar No Aplica a Cuentas con Excepciones	
			update SOTMPCCN
				set Ccn_Aplica = @Bit_No
				from SOEXAPCA noholdlock
				inner join SOTMPCCN CCN
						on CCN.Ccn_TipMov = Eac_TipMov
						and CCN.Ccn_Cuenta = Eac_Cuenta
						and CCN.Ccn_Activo = @Bit_Si
				where Eac_TipMov = @Pro_TipMov
				and Eac_Activo = @Bit_Si
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
			
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,
						case 
							when Ccn_AplCal = @Bit_Si and Ccn_Aplica = @Bit_Si then
								case 
									when ETCEXECUO.Etc_Valor = @Mon_Cero then ETCELECOM.Etc_Valor
								else
									case 
										when Cue_SalPro >= ETCSAPRMI.Etc_Valor then @Mon_Cero 
										else ETCELECOM.Etc_Valor
									end
								end
							else @Mon_Cero
						end,	@Bit_Si,
						Ccn_Aplica,	Tma_Termin,		@Bit_No,	@NumTransac,	@Transaccio,
						@Usuario,	getdate(),		@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCIECUE noholdlock
						on Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCSAPRMI noholdlock
						on ETCSAPRMI.Etc_TiMoAs = Tma_Numero
						and ETCSAPRMI.Etc_ElTiMo = @Etm_SaPrMi
						and ETCSAPRMI.Etc_Activo = @Bit_Si		
				inner join SOELTICA ETCEXECUO noholdlock
						on ETCEXECUO.Etc_TiMoAs = Tma_Numero
						and ETCEXECUO.Etc_ElTiMo = @Etm_ExeCuo
						and ETCEXECUO.Etc_Activo = @Bit_Si		
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000099 CUOTA MENSUAL
		 		
 		/* 000122 Comision por Inactividad de Cuenta @Str_TiMoIn */
		if @Pro_TipMov = @Str_TiMoIn	-- 000122 Comision por Inactividad de Cuenta
		begin
			--Elemento de Comision
			select
				@Etm_Comisi = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_Comisi
				and Etm_Activo = @Bit_Si
			--Elemento de Comision
			select
				@Etm_MesIna = Etm_Numero
			from
				SOELTIMO noholdlock
			where
				Etm_TiCaMo = @Pro_TiCaMo
				and Etm_NumEle = @Ele_MesIna
				and Etm_Activo = @Bit_Si
		
			insert into SOTIMOCU
				(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
				Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
				Usuario,		FechaSis,	SucOrigen,	SucDestino)
				select	Ccn_Cuenta,	@Pro_TipMov,	Ccn_TiMoAs,	ETCELECOM.Etc_Valor,	@Bit_Si,
						Ccn_Aplica,	Tma_Termin,		@Bit_No,	@NumTransac,			@Transaccio,
						@Usuario,	getdate(),		@SucOrigen,	@SucDestino
				from SOTMPCCN noholdlock
				inner join CHCOINCU Chc noholdlock			--Tabla que contiene las Cuentas Inctivas
						on Chc.Cue_Numero = Ccn_Cuenta
				inner join SOTIMOAS noholdlock
						on Tma_Numero = Ccn_TiMoAs
						and Tma_Activo = @Bit_Si
				inner join SOELTICA ETCELECOM noholdlock
						on ETCELECOM.Etc_TiMoAs = Tma_Numero
						and ETCELECOM.Etc_ElTiMo = @Etm_Comisi
						and ETCELECOM.Etc_Activo = @Bit_Si
				inner join SOELTICA ETCMESINA noholdlock
						on ETCMESINA.Etc_TiMoAs = Tma_Numero
						and ETCMESINA.Etc_ElTiMo = @Etm_MesIna
						and ETCMESINA.Etc_Activo = @Bit_Si		
				where Ccn_TipMov = @Pro_TipMov
				  and Ccn_AplCal = @Bit_Si
				  and Ccn_Activo = @Bit_Si
			
			--En caso de error hacer rollback
			if @@error <> 0
			begin
				rollback
				return 1
			end
		end -- 000122 Comision por Inactividad de Cuenta
		
		----Fin de ejecucion de Comision---
		
		--MODALIDADES----------------------------------------------------------------------------
		--Agregar Montos de Comisiones de Cuentas que hayan obtenido el Tipo de Movimiento como Beneficio en Modalidades.
		insert into SOTIMOCU
			(Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,	Tmc_Activo,
			Tmc_Aplica,		Tmc_Termin,	Tmc_CarPen,	NumTransac,	Transaccio,
			Usuario,		FechaSis,	SucOrigen,	SucDestino)
			select	Cmo_Cuenta,	Ccn_TipMov,	Ccn_TiMoAs,	Cmo_Monto,		@Bit_Si,
					Ccn_Aplica,	Ccn_Termin,	@Bit_No,	@NumTransac,	@Transaccio,
					@Usuario,	getdate(),	@SucOrigen,	@SucDestino
			from CHTMPCMO noholdlock
			inner join SOTMPCCN noholdlock
					on Ccn_Cuenta = Cmo_Cuenta
					and Ccn_TipMov = substring('000000', 1, 6 - len(rtrim(convert(CHAR(6), Cmo_TipMov)))) + rtrim(convert(CHAR(6), Cmo_TipMov))
					and Ccn_Activo = @Bit_Si
			where Cmo_TipMov = convert(int, @Pro_TipMov)
			
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		--FIN MODALIDADES------------------------------------------------------------------------
	
		--Generar IVA de las Comisiones
		insert into SOTIMOIM 
			(Tmi_Cuenta,	Tmi_TipMov,	Tmi_Impues,	Tmi_Monto,	Tmi_Activo,
			NumTransac,		Transaccio,	Usuario,	FechaSis,	SucOrigen,
			SucDestino)
			select	Tmc_Cuenta,		Tmc_TipMov,		@Imp_IVA,	round(Tmc_Monto * Par_IVA, @Ent_Dos),	@Bit_Si,
					@NumTransac,	@Transaccio,	@Usuario,	getdate(),								@SucOrigen,	
					@SucDestino
			from SOTIMOCU noholdlock
			inner join CHCUENTA noholdlock
					on Cue_Numero = Tmc_Cuenta
			inner join CLCLIENT noholdlock
					on Cli_Numero = Cue_Client
			inner join SOPARAMS noholdlock
					on Par_Sucurs = Cli_SucAti
			where Tmc_TipMov = @Pro_TipMov
			  and Tmc_Monto > @Mon_Cero
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
		--FIN Generar IVA de las Comisiones
		
		--Insertar en tablas de Historia
		insert into SOHISTMC
			(Tmc_Fecha,	Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,
			Tmc_Aplica,	Tmc_Termin,	Tmc_CarPen,	Tmc_Activo,	NumTransac,
			Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
			select @Fec_FecAct,	Tmc_Cuenta,	Tmc_TipMov,	Tmc_TiMoAs,	Tmc_Monto,
				Tmc_Aplica,	Tmc_Termin,	Tmc_CarPen,	Tmc_Activo,	NumTransac,
				Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino
				from SOTIMOCU noholdlock
				where Tmc_TipMov = @Pro_TipMov
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
			
		insert into SOHISTMI
			(Tmi_Fecha,	Tmi_Cuenta,	Tmi_TipMov,	Tmi_Impues,	Tmi_Monto,
			Tmi_Activo,	NumTransac,	Transaccio,	Usuario,	FechaSis,
			SucOrigen,	SucDestino)
			select @Fec_FecAct,	Tmi_Cuenta,	Tmi_TipMov,	Tmi_Impues,	Tmi_Monto,
			Tmi_Activo,	NumTransac,	Transaccio,	Usuario,	FechaSis,
			SucOrigen,	SucDestino
				from SOTIMOIM noholdlock
				where Tmi_TipMov = @Pro_TipMov
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end
					    	
		insert into SOHISEAC
				(	Eac_Numero,	Eac_Fecha, Eac_TipMov,	Eac_Cuenta, Eac_MoExCa, 
					Eac_Activo,	NumTransac,Transaccio,Usuario,		FechaSis,	
					SucOrigen,	SucDestino)
			select	Eac_Numero,	@Fec_FecAct,Eac_TipMov,	Eac_Cuenta, Eac_MoExCa,	Eac_Activo,	
					NumTransac,	Transaccio,Usuario,		FechaSis,	SucOrigen,	
					SucDestino
			from SOEXAPCA noholdlock
			where Eac_TipMov = @Pro_TipMov
		--En caso de error hacer rollback
		if @@error <> 0
		begin
			rollback
			return 1
		end	
					    		
		--Registrar ejecucion de Comision
		select @Fec_FinPro = getdate()	/* Fecha de finalizacion de proceso ejecutado */
		select @Cie_Tiempo = datediff(second, @Fec_IniPro, @Fec_FinPro)	
		
		--Registro de tiempo de ejecucion en Bitacora de Comisiones
		select @FechaSis = getdate()
		exec SOTMPBCCALT 
			@Fec_FecAct, @Sto_CalCom, @Pro_TipMov, @Str_Descri, @Cie_Tiempo,
			@Fec_IniPro, @Fec_FinPro, @NumTransac, @Transaccio, @Usuario, 
			@FechaSis, @SucOrigen, @SucDestino, @Modulo
		
		--Terminar transaccion
		commit
	end 
	---Fin de ejecucion de Comision---		
	
	--Incrementar contador de Tipos de Movimientos
	select
		@Reg_ContTM	=	@Reg_ContTM	+	1
end --Ejecutar cada Comision

return 0