create procedure SORENTASPRO (
	@Amo_MonFin	double precision,	-- Monto a Financiar
	@Amo_IVAFac	smallmoney,			-- Porcentaje de I.V.A. de Factura
	@Amo_OpcCom	double precision,	-- opción de Compra
	@Amo_RenExt	double precision,	-- Renta Extraordinaria
	@Amo_Plazo	smallint,			-- Numero de Frecuencia
	@Amo_PerGra	smallint,			-- Periodo de Gracia
	@Amo_TasBas	double precision,	-- Tasa Base
	@Amo_TipArr	char(1),			-- 1(Financiero) - 2(Puro) - 3(Credito Simple)
	@Amo_TipAmo	char(1),			-- 1.Niveladas - 2. Iguales
	@Amo_Frecue	smallint,			-- 1.Mensualidades - 2. Bimestralidades - 3. Trimestralidades - 4. Cuatrimestrualidades - 5. Semestralidades - 6. Anualidades
	@Amo_CobIVA	char(1),			-- S. Cobra I.V.A. - N. No Cobra I.V.A.
	@Amo_IVA	smallmoney,			-- Porcentaje de I.V.A. a Cobrar
	@Amo_ToPaIn	double precision,	-- Monto total del pago inicial
	@Amo_TipCal	char(1),			-- Tipo de Calculo, se utiliza para cuando el calculo es desde pantalla o desde reporte
	@Num_Cotiza	char(7),			-- Numero de cotizacion o seran 7 ceros en caso de que la cotizacion no ha sido guardada aun
	@Amo_TipCon	char(1),			-- Tipo de Contrato (0(Financiero),1(Comercial Puro),2(B2B Puro),3(Credito Simple))
	@Amo_RenMen	money,				-- Monto Renta mensual (pago final)  se utiliza solo para B2B Puro ya que en este caso las rentas deben ser todas  con el mismo monto
	@Amo_TipTas	char(1),			-- Tipo de tasa: 0 - Automatica/360 	1 - Automatica
	@Amo_TipRen	char(1),			-- Tipo de Renta: 0 - Manual			1 - Sin Renta Interina
	@Amo_MonCer	char(1),			-- Si se dejan o no los montos en cero		S - Si		N - No
	@Amo_UniNeg	smallint,			-- Tipo de Unidad de Negocio: 1-Especializado  2-B2B  3-Arrendamiento Mexico

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*
**************************************************************************
DESCRIPCION:	**Procedimiento que genera las Rentas en la cotización
				de ArrendaRegio**
**************************************************************************
REFERENCIAS:
****************************************************************************
** Modifico:		Zaida C. Lucas G.									****
** Fecha:			14/Marzo/2016		  								****
** Help:			830922												****
** Descripcion:		Se agregan validaciones para Auto Leasing Plus		****
****************************************************************************
** Modifico:		David Amaya								****
** Fecha:		30/Junio/2015								****
** Help:	   		00782754									****
** Descripción:	Se ajusto para que se considere el IVA de	****
**				la sucursal para las rentas de B2B Puro			****
**				y no el IVA de Factura							****
****************************************************************************
** Modifico:		David Amaya								****
** Fecha:		10/Marzo/2015								****
** Help:	   		00692112									****
** Descripción:	Se agrego la funcionalidad par manejar los	****
**				pagos extraordinarios con monto cero			****
****************************************************************************
** Modifico:		David Amaya								****
** Fecha:		13/Octubre/2014							****
** Help:	   		00692112									****
** Descripción:	Se agregaron los parametros @Amo_TipTas y	****
**				@Amo_TipRen,@Amo_MonCer,@Ren_UniNeg	****
**				Se agrego funcionalidad para que se realicen	****
**				los calculos sobre 360 dias o 365 dias		****
**				Se adecuo store para considerar la nueva		****
**				clasificacion de contrato 3(Credito Simple)	****
****************************************************************************
** 				STORE CONVERTIDO						****
** Creó:			Luis Saldivar								****
** Fecha:		09/Agosto/2012								****
** Help:	   		00444009									****
** Descripción:	Procedimiento que genera las Rentas en la	****
**				cotización de ArrendaRegio					****
****************************************************************************
*/

declare	@Ren_ResCap	double precision,		/*	Declaración de Variables	*/
		@Res_IvaFac	double precision,
		@Ren_Capita	double precision,
		@Ren_Intere	double precision,
		@Ren_TtCaIn	double precision,
		@Ren_IvaInt	double precision,
		@Ren_IvaFac	double precision,
		@Ren_Total	double precision,
		@Mon_Intere	double precision,
		@Mon_InAPag	double precision,
		@Frecuencia	smallint,
		@Mon_CapREx	double precision,
		@Mon_IvaREx	double precision,
		@Par_DiaMes	smallint,
		@Par_DiBaCr	smallint,
		@Par_IVA	smallmoney,
		@Ren_Consec	smallint,
		@Ren_Numero	char(3),
		@PerGra		smallint,
		@Tot_Capita	double precision,
		@Tot_IvaFac	double precision,
		@Mon_IvaFac	double precision,
		@Ren_IvaRen	money,
		@Num_Meses	smallint,
		@SumCaPaEx	money,
		@NumPagExt	smallint,
		@Pae_Cantid	money,
		@Amo_Mensua	money,
		@Status		int,
		@Par_PorIVA	smallmoney,
		@Amo_FecIni	smalldatetime,
		@Amo_FecVen	smalldatetime,
		@Ban_PaExCe	char(1)

declare	@Mon_Cero	smallint,				/*	Declaración de Constantes	*/
		@Mon_Uno	smallint,
		@Mon_Cien	smallint,
		@Ent_Cero	smallint,
		@Ent_Uno	smallint,
		@Str_RenExt	char(3),
		@Str_ValFut	char(3),
		@Str_Si		char(1),
		@Tip_FreMen	smallint,
		@Tip_FreBim	smallint,
		@Tip_FreTri	smallint,
		@Tip_FreCua	smallint,
		@Tip_FreSem	smallint,
		@Tip_FreAnu	smallint,
		@Fre_Mensua	double precision,
		@Fre_Bimens	double precision,
		@Fre_Trimen	double precision,
		@Fre_Cuatri	double precision,
		@Fre_Semest	double precision,
		@Fre_Anual	double precision,
		@Arr_Financ	char(1),
		@Arr_Puro	char(1),
		@Arr_CreSim	char(1),
		@Amo_Nivela	char(1),
		@Amo_Iguale	char(1),
		@Cal_Report	char(1),
		@Cal_Pantal	char(1),
		@Str_Vacio	char(1),
		@Str_3Ceros	char(3),
		@Amo_PagIni	char(3),
		@CadTotales	char(7),
		@Cal_ConEsp	char(1),
		@Fec_Vacia	smalldatetime,
		@Con_B2BPur	char(1),
		@Tip_Tas360	char(1),
		@Tip_Tas365	char(1),
		@Con_ComPur	char(1),
		@Cad_Si		char(1),
		@Cad_No		char(1),
		@Uni_ArrMex	int,
		@Uni_Especi	int,
		@Con_LeaVIP char(1)		

/*	Asignación de Constantes	*/
select	@Mon_Cero	= 0.00,			/*	Moneda Cero																	*/
		@Mon_Uno	= 1.00,			/*	Moneda Uno																	*/
		@Mon_Cien	= 100,			/*	Moneda Cien																	*/
		@Ent_Cero	= 0,			/*	Entero Cero																	*/
		@Ent_Uno	= 1,			/*	Entero Uno																	*/
		@Str_RenExt	= 'Ext',		/*	Identificador de renta extraordinaria										*/
		@Str_ValFut	= 'V.F',		/*	Valor futuro = Opción de compra del cliente									*/
		@Str_Si		= 'S',			/*	Cadena Si																	*/
		@Tip_FreMen	= 1,			/*	Tipo de Frecuencia Mensual													*/
		@Tip_FreBim	= 2,			/*	Tipo de Frecuencia Bimestral												*/
		@Tip_FreTri	= 3,			/*	Tipo de Frecuencia Trimestral												*/
		@Tip_FreCua	= 4,			/*	Tipo de Frecuencia Cuatrimestral											*/
		@Tip_FreSem	= 5,			/*	Tipo de Frecuencia Semestral												*/
		@Tip_FreAnu	= 6,			/*	Tipo de Frecuencia Anual													*/
		@Fre_Mensua	= 1,			/*	Frecuencia Mensual															*/
		@Fre_Bimens	= 2,			/*	Frecuencia Bimestral														*/
		@Fre_Trimen	= 3,			/*	Frecuencia Trimestral														*/
		@Fre_Cuatri	= 4,			/*	Frecuencia Cuatrimestral													*/
		@Fre_Semest	= 6,			/*	Frecuencia Semestral														*/
		@Fre_Anual	= 12,			/*	Frecuencia Anual															*/
		@Arr_Financ	= '1',			/*	Arrendamiento Financiero													*/
		@Arr_Puro	= '2',			/*	Arrendamiento Puro															*/
		@Arr_CreSim	= '3',			/*	Credito Simple																*/
		@Amo_Nivela	= '1',			/*	Amortizaciones niveladas													*/
		@Amo_Iguale	= '2',			/*	Amortizaciones iguales														*/
		@Cal_Report	= '1',			/*	el resultado final ira al reporte											*/
		@Cal_Pantal	= '2',			/*	el resultado final ira a la pantalla										*/
		@Str_Vacio	= '',			/*	Cadena Vacia																*/
		@Str_3Ceros	= '000',		/*	Cadena 3 ceros																*/
		@Amo_PagIni	= '000',		/*	Amorizacion 000 donde se muestra lo que el cliente dará de pago inicial		*/
		@CadTotales	= 'TOTALES',	/*	Cadena Totales																*/
		@Cal_ConEsp	= '3',			/*	El resultado ira a la pantalla de contrato especifico						*/
		@Fec_Vacia	= '1900-01-01',	/*	Fecha Vacia																	*/
		@Con_B2BPur	= '2',			/*	Tipo de Contrato B2B Puro													*/
		@Tip_Tas360	= '0',			/*	Tipo de Tasa Automatica/360													*/
		@Tip_Tas365	= '1',			/*	Tipo de Tasa Automatica (trabaja sobre 365 dias)							*/
		@Con_ComPur	= '1',			/*	Tipo de Contrato Comercial Puro												*/
		@Cad_Si		= 'S',			/*	Cadena Si																	*/
		@Cad_No		= 'N', 			/*	Cadena No																	*/
		@Uni_ArrMex	= 3,			/*	Unidad de Negocio Arrendamiento Mexico										*/
		@Uni_Especi	= 1,				/*	Unidad de Negocio Especializado												*/
		@Con_LeaVIP	= '5'			/* Tipo de contrato Auto Leasing Plus*/
		
create table #Rentas (
	Ren_Consec	smallint not null,
	Ren_Numero	char(3),
	Ren_Capita	money,
	Ren_Intere	money,
	Ren_TtCaIn	money,
	Ren_IvaInt	money,
	Ren_IvaFac	money,
	Ren_IvaRen	money, 
	Ren_Total	money
)


select	@Par_DiaMes	= Par_DiaMes,
		@Par_PorIVA	= Par_PorIVA
	from ABPARAMS noholdlock

select	@Par_DiBaCr	= Par_DiBaCr,
		@Par_IVA	= Par_IVA
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

if @Amo_RenExt > @Mon_Cero begin
	select	@Mon_CapREx	= round(@Amo_RenExt / (@Mon_Uno + (@Amo_IVAFac/@Mon_Cien) ), 2),
			@Mon_IvaREx	= @Amo_RenExt - round(@Amo_RenExt / (@Mon_Uno + (@Amo_IVAFac/@Mon_Cien) ), 2)

	insert into #Rentas values(	@Mon_Cero,	@Str_RenExt,	@Mon_CapREx,	@Mon_Cero,	@Mon_CapREx,
								@Mon_Cero,	@Mon_IvaREx,	@Mon_Cero,		@Amo_RenExt)
end else
	insert into #Rentas values(	@Mon_Cero,	@Str_RenExt,	@Mon_Cero,	@Mon_Cero,	@Mon_Cero,
								@Mon_Cero,	@Mon_Cero,		@Mon_Cero,	@Mon_Cero)


-- Inserción de amortización cero "000" correspondiente al pago inicial
select	@Ren_Consec = @Ent_Cero

select	@Ren_Numero	= convert(char, @Ren_Consec)
exec UTCERIZQ
		@Valor		= @Ren_Numero output,
		@Longitud	= 3

select	@Ren_Capita	= @Amo_ToPaIn

select	@Ren_Capita	= @Ren_Capita

insert into #Rentas values(	@Mon_Cero,	@Ren_Numero,	@Ren_Capita,	@Mon_Cero,	@Ren_Capita,
							@Mon_Cero,	@Mon_Cero,		@Mon_Cero,		@Ren_Capita)

select	@Frecuencia	= case @Amo_Frecue  when @Tip_FreSem then @Fre_Semest
										when @Tip_FreAnu then @Fre_Anual
										else @Amo_Frecue end

select	@Ren_Consec = @Ent_Uno

while @Ren_Consec <= @Amo_Plazo begin
	select	@Ren_Numero	= convert(char, @Ren_Consec)
	exec UTCERIZQ
		@Valor		= @Ren_Numero output,
		@Longitud	= 3

	insert into #Rentas values(	@Ren_Consec,	@Ren_Numero,	@Mon_Cero,	@Mon_Cero,	@Mon_Cero,
								@Mon_Cero,		@Mon_Cero,		@Mon_Cero,	@Mon_Cero)

	select	@Ren_Consec	= @Ren_Consec + @Ent_Uno
end

if @Amo_TipCon = @Con_ComPur/*Comercial Puro*/ begin
	select	@Ren_Numero	= @Str_ValFut
	insert into #Rentas values(	@Mon_Cero,	@Ren_Numero,	@Amo_OpcCom,	@Mon_Cero,	@Amo_OpcCom,
								@Mon_Cero,	@Mon_Cero,		@Mon_Cero,		@Amo_OpcCom)
end

if @Amo_MonCer = @Cad_No begin
	select	@Ren_ResCap	= @Amo_MonFin,
			@Res_IvaFac	= round((@Amo_MonFin * @Amo_IVAFac) / @Mon_Cien, 2)
	
	/*	Para calcular la Tasa Nominal - El monto no se debe de redondear	*/
	select	@Mon_Intere	= case @Amo_Frecue 	when @Tip_FreMen then @Amo_TasBas / @Mon_Cien / @Fre_Anual
											when @Tip_FreBim then @Amo_TasBas / @Mon_Cien / @Fre_Semest
											when @Tip_FreTri then @Amo_TasBas / @Mon_Cien / @Fre_Cuatri
											when @Tip_FreCua then @Amo_TasBas / @Mon_Cien / @Fre_Trimen
											when @Tip_FreSem then @Amo_TasBas / @Mon_Cien / @Fre_Bimens
											when @Tip_FreAnu then @Amo_TasBas / @Mon_Cien / @Fre_Mensua end
	
	select	@Num_Meses	= case @Amo_Frecue 	when @Tip_FreMen then @Fre_Anual
											when @Tip_FreBim then @Fre_Semest
											when @Tip_FreTri then @Fre_Cuatri
											when @Tip_FreCua then @Fre_Trimen
											when @Tip_FreSem then @Fre_Bimens
											when @Tip_FreAnu then @Fre_Mensua end
	
	select	@SumCaPaEx	= sum(Pae_Cantid),
			@NumPagExt	= count(Pae_Amorti)
		from ABTMPPEC noholdlock
		where	Pae_NumCot	= @Num_Cotiza
	
	/*CALCULO DE LA RENTA*/
	if @Mon_Intere = @Mon_Cero begin --Tasa Cero
	
		if (select	count(Pae_Amorti)
				from ABTMPPEC noholdlock
				where	Pae_NumCot	= @Num_Cotiza) > @Ent_Cero begin 
	
			select	@Mon_InAPag	= round((@Amo_MonFin - (@SumCaPaEx/ (@Ent_Uno + (@Amo_IVAFac/@Mon_Cien))))/(@Amo_Plazo - @Amo_PerGra - @NumPagExt), 2)
	
		end else begin
			select	@Mon_InAPag	= round(@Amo_MonFin / (@Amo_Plazo - @Amo_PerGra) ,2)
		end
	
	end else begin
		if (select	count(Pae_Amorti)
				from ABTMPPEC noholdlock
				where	Pae_NumCot	= @Num_Cotiza) > @Ent_Cero begin
	
			exec @Status	= ABTMPPECPRO
				@Amo_Plazo,		@Amo_MonFin,	@Amo_TasBas,	@Num_Meses,			@Amo_PerGra,
				@Amo_OpcCom,	@Amo_TipArr,	@Amo_IVA,		@Amo_Mensua output,	@Num_Cotiza,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,			@SucOrigen,
				@SucDestino,	@Modulo
	
			if @Status <> 0 begin
				rollback
				return 1
			end
	
			select	@Mon_InAPag	= @Amo_Mensua
			
		end else begin
			if @Amo_TipArr in (@Arr_Financ, @Arr_CreSim) begin
				select	@Mon_InAPag	= round(@Amo_MonFin * @Mon_Intere * power((@Mon_Uno + @Mon_Intere), (@Amo_Plazo - @Amo_PerGra)) / (power((@Mon_Uno + @Mon_Intere), (@Amo_Plazo - @Amo_PerGra)) - @Mon_Uno) ,2)
	
				end
			else
				select	@Mon_InAPag	= round((@Amo_MonFin - (@Amo_OpcCom * power((@Mon_Uno + @Mon_Intere), (- @Amo_Plazo + @Amo_PerGra)))) * @Mon_Intere * power((@Mon_Uno + @Mon_Intere), (@Amo_Plazo - @Amo_PerGra)) / (power((@Mon_Uno + @Mon_Intere), (@Amo_Plazo - @Amo_PerGra)) - @Mon_Uno) ,2)
	
		end
	end
	
	select	@PerGra	= @Ent_Uno
	
	select TOP 1 @Ren_Consec = Ren_Consec
		from #Rentas
		where	Ren_Consec > @Ent_Cero
		order by Ren_Consec
	
	while @Ren_Consec <= @Amo_Plazo begin
		select	@Ren_Capita	= @Mon_Cero,
				@Ren_Intere	= @Mon_Cero,
				@Ren_TtCaIn	= @Mon_Cero,
				@Ren_IvaInt	= @Mon_Cero,
				@Ren_IvaFac	= @Mon_Cero,
				@Ren_IvaRen	= @Mon_Cero, 
				@Ren_Total	= @Mon_Cero

		if @Amo_TipTas = @Tip_Tas365 begin

			select	@Ren_Numero	= convert(char, @Ren_Consec)
			exec UTCERIZQ
				@Valor		= @Ren_Numero output,
				@Longitud	= 3
			
			select	@Amo_FecIni	= Ren_FecIni, 
					@Amo_FecVen	= Ren_FecVen
				from #RenMen noholdlock
				where	Ren_Numero	= @Ren_Numero
			
			select	@Par_DiaMes	= datediff(dd, @Amo_FecIni, @Amo_FecVen)
		end

		if @PerGra <= @Amo_PerGra
			select	@Ren_Capita	= @Mon_Cero,
					@Ban_PaExCe	= @Cad_No
		else begin
			if @NumPagExt > @Ent_Cero and 
			   exists (select	Pae_Amorti
						from ABTMPPEC noholdlock
						where	Pae_NumCot	= @Num_Cotiza
						  and	Pae_Amorti	= right(@Str_3Ceros + ltrim(rtrim(convert(char(3), @Ren_Consec))), 3)) begin
	
				select	@Pae_Cantid	= Pae_Cantid
					from ABTMPPEC noholdlock
					where Pae_NumCot	= @Num_Cotiza
					  and	Pae_Amorti	= right(@Str_3Ceros + ltrim(rtrim(convert(char(3), @Ren_Consec))), 3)

				if @Pae_Cantid = @Mon_Cero begin
					select	@Ren_Capita	= @Mon_Cero,
							@Ban_PaExCe	= @Cad_Si	
				end else begin
					if @Amo_UniNeg = @Uni_ArrMex begin
						if @Amo_TipAmo = @Amo_Nivela
							select	@Ren_Capita	= round((@Pae_Cantid / (@Ent_Uno + @Amo_IVA)) - (@Ren_ResCap * (@Amo_TasBas / @Mon_Cien) * (@Par_DiaMes * @Frecuencia) / @Par_DiBaCr), 4)
						else
							select	@Ren_Capita	= round((@Pae_Cantid / (@Ent_Uno + @Amo_IVA)) - (@Amo_MonFin * (@Amo_TasBas / @Mon_Cien) * (@Par_DiaMes * @Frecuencia) / @Par_DiBaCr), 4)
					end else begin
						select	@Ren_Capita	= round((@Pae_Cantid / (@Ent_Uno + @Amo_IVA)) - (@Ren_ResCap * (@Amo_TasBas / @Mon_Cien) * (@Par_DiaMes * @Frecuencia) / @Par_DiBaCr), 4)				
					end
					
					select	@Ban_PaExCe	= @Cad_No
				end

			end else begin
				if @Amo_TipAmo = @Amo_Nivela begin
					select	@Ren_Capita	= round(@Mon_InAPag - @Ren_ResCap * @Mon_Intere, 4)
				end else begin
					select	@Ren_Capita	= round(@Amo_MonFin / (@Amo_Plazo - @Amo_PerGra), 4)
				end

				select	@Ban_PaExCe	= @Cad_No
			end	
		end

		select	@Ren_Intere	= round(@Ren_ResCap * (@Amo_TasBas / @Mon_Cien) * (@Par_DiaMes * @Frecuencia) / @Par_DiBaCr, 4)

		if @Ban_PaExCe	= @Cad_No begin
			select	@Ren_TtCaIn	= @Ren_Capita + @Ren_Intere
		end else begin
			select	@Ren_TtCaIn	= @Mon_Cero
		end

		select	@Ren_IvaInt	= case @Amo_CobIVA when @Str_Si then round(@Ren_Intere * @Amo_IVA, 4) else @Mon_Cero end
		select	@Ren_IvaInt	= round(@Ren_IvaInt * (@Par_PorIVA/@Mon_Cien),4)
		select	@Ren_IvaFac	= round((@Ren_Capita * @Amo_IVAFac) / @Mon_Cien, 4)
		select	@Ren_IvaRen	= @Ren_IvaInt + @Ren_IvaFac

		if @Ban_PaExCe	= @Cad_No begin
			select	@Ren_Total	= round((@Ren_Capita + @Ren_Intere + @Ren_IvaInt + @Ren_IvaFac),2)
		end else begin
			select	@Ren_Total	= @Mon_Cero
		end

		if @Amo_TipCon = @Con_B2BPur or @Amo_TipCon = @Con_LeaVIP begin /*B2B Puro*/
	
			update #Rentas set
				Ren_Capita	= @Amo_RenMen,
				Ren_Intere	= @Mon_Cero,
				Ren_TtCaIn	= @Mon_Cero,
				Ren_IvaInt	= (@Amo_RenMen * @Par_IVA),
				Ren_IvaFac	= @Mon_Cero,
				Ren_IvaRen	= (@Amo_RenMen * @Par_IVA) + @Mon_Cero,
				Ren_Total	= @Amo_RenMen + (@Amo_RenMen * @Par_IVA)
			where	Ren_Consec	= @Ren_Consec
	
		end else begin /*Arrendamiento-comercial puro-credito*/
	
			update #Rentas set
				Ren_Capita	= @Ren_Capita,
				Ren_Intere	= @Ren_Intere,
				Ren_TtCaIn	= @Ren_TtCaIn,
				Ren_IvaInt	= @Ren_IvaInt,
				Ren_IvaFac	= @Ren_IvaFac,
				Ren_IvaRen	= @Ren_IvaRen, 
				Ren_Total	= @Ren_Total
			where	Ren_Consec	= @Ren_Consec
		end
	
		select	@Ren_ResCap	= @Ren_ResCap - @Ren_Capita
		select	@PerGra		= @PerGra + @Ent_Uno
		select	@Ren_Consec	= @Ren_Consec + @Ent_Uno
	end

	select	@Tot_Capita	= sum(Ren_Capita),
			@Tot_IvaFac	= sum(Ren_IvaFac)
		from #Rentas
		where	Ren_Consec > @Ent_Cero
	
	select	@Mon_IvaFac	= sum(Ren_IvaFac)
		from #Rentas
	
	/*Cuando la suma de capitales de las amortizaciones no es igual al monto a financiar por cuestion de redondeo*/
	if round(@Tot_Capita,2) > round(@Amo_MonFin  ,2)begin
		if @Amo_TipArr in (@Arr_Financ, @Arr_CreSim) begin
			select	@Ren_Capita	= @Ren_Capita - (round(@Tot_Capita,2) - round(@Amo_MonFin,2))
		end else begin
			select	@Ren_Capita	= @Ren_Capita - (round(@Tot_Capita,2) - (round(@Amo_MonFin,2) - round(@Amo_OpcCom,2)))
		end
	end else begin
		if round(@Tot_Capita,2) < round(@Amo_MonFin,2) begin
			if @Amo_TipArr in (@Arr_Financ, @Arr_CreSim) begin
				select	@Ren_Capita	= @Ren_Capita + (round(@Amo_MonFin,2) - round(@Tot_Capita,2))
			end else begin
				select	@Ren_TtCaIn	= @Ren_TtCaIn-@Ren_Capita
				select	@Ren_Capita	= @Ren_Capita + ((round(@Amo_MonFin,2) - round(@Amo_OpcCom,2)) - round(@Tot_Capita,2))
				select	@Ren_TtCaIn	= @Ren_TtCaIn+@Ren_Capita
			end
		end
	end

	/*Cuando la suma de los IVA's de la factura no es igual al IVA de la factura por cuestion de redondeo*/
	if @Tot_IvaFac > @Res_IvaFac  begin
		select	@Ren_IvaFac	= @Ren_IvaFac - (@Tot_IvaFac - @Res_IvaFac)
	end else begin 
		if @Tot_IvaFac < @Mon_IvaFac  begin
			select	@Ren_IvaFac	= @Ren_IvaFac + (@Res_IvaFac -@Tot_IvaFac)
		end
	end

	if @Mon_Intere > @Mon_Cero begin
		if @Amo_TipAmo = @Amo_Nivela begin
			select	@Ren_Intere	= @Ren_TtCaIn - @Ren_Capita
		end else begin
			/*En esta seccion se saca el interes de la ultima renta, no se condiciona el @Par_DiaMes ya que independientemente de si
			el tipo de tasa es a 360 dias (utiliza como valor de @Par_DiaMes un 30) o si es 365 (en el while donde se realizan los calculos 
			se llena esta variable con la diferencia entre FecIni y FecVen de cada una de las rentas pero al final la diferencia que queda guardada
			en la variable es la de la ultima renta) el @Par_DiaMes trae un valor correcto dependiendo de la tasa elegida */
			select	@Ren_Intere	= round(@Ren_Capita * (@Amo_TasBas / @Mon_Cien) * (@Par_DiaMes * @Frecuencia) / @Par_DiBaCr, 2)
		end
	end

	select	@Ren_TtCaIn	= @Ren_Capita + @Ren_Intere
	select	@Ren_IvaInt	= case @Amo_CobIVA when @Str_Si then round(@Ren_Intere * @Amo_IVA, 2) else @Mon_Cero end
	select	@Ren_IvaInt	= round(@Ren_IvaInt * (@Par_PorIVA/@Mon_Cien),2)
	select	@Ren_IvaRen	= @Ren_IvaInt + @Ren_IvaFac 
	select	@Ren_Total	= @Ren_Capita + @Ren_Intere + @Ren_IvaInt + @Ren_IvaFac
	
	if @Amo_TipCon = @Con_B2BPur/*B2B Puro*/ or @Amo_TipCon = @Con_LeaVIP begin
	
		update #Rentas set
				Ren_Capita	= @Amo_RenMen,
				Ren_Intere	= @Mon_Cero,
				Ren_TtCaIn	= @Mon_Cero,
				Ren_IvaInt	= (@Amo_RenMen * @Par_IVA),
				Ren_IvaFac	= @Mon_Cero,
				Ren_IvaRen	= (@Amo_RenMen * @Par_IVA) + @Mon_Cero,
				Ren_Total	= @Amo_RenMen + (@Amo_RenMen * @Par_IVA)
			where	Ren_Consec	= @Amo_Plazo

	end else begin /*Arrendamientos-comerciales puro-credito*/
	
		if @Amo_TipArr = @Arr_Puro begin /*Si el tipo de arrendamiento es comercial puro */

			update #Rentas set
					Ren_Capita	= @Ren_Capita,
					Ren_Intere	= @Ren_Intere,
					Ren_TtCaIn	= @Ren_TtCaIn
				where	Ren_Consec	= @Amo_Plazo
		
			update #Rentas set
				Ren_IvaInt	= round(Ren_TtCaIn * (@Amo_IVAFac/@Mon_Cien) * (@Mon_Cien/@Mon_Cien) ,2),
				Ren_IvaRen	= round(Ren_TtCaIn * (@Amo_IVAFac/@Mon_Cien) * (@Mon_Cien/@Mon_Cien) ,2),
				Ren_IvaFac	= @Mon_Cero
				where	Ren_Consec > @Ent_Cero

			update #Rentas set
				Ren_Total	= Ren_Capita + Ren_Intere + Ren_IvaInt + Ren_IvaFac

			update #Rentas set
				Ren_IvaRen	= Ren_IvaFac
				where Ren_Numero = @Str_RenExt

		end else begin /*Si el tipo de arrendamiento es comercial financiero o credito */
			update #Rentas set
					Ren_Capita	= @Ren_Capita,
					Ren_Intere	= @Ren_Intere,
					Ren_TtCaIn	= @Ren_TtCaIn,
					Ren_IvaInt	= @Ren_IvaInt,
					Ren_IvaFac	= @Ren_IvaFac,
					Ren_IvaRen	= @Ren_IvaRen,
					Ren_Total	= @Ren_Total
				where	Ren_Consec	= @Amo_Plazo
		end
	end

	if @Amo_TipCal = @Cal_ConEsp begin
		-- Salida para la pantalla de contrato especifico
		update #RenMen
			set Ren_Cotiza	= @Num_Cotiza,
				Ren_Numero	= #Rentas.Ren_Numero,
				Ren_Capita	= #Rentas.Ren_Capita,
				Ren_Intere	= #Rentas.Ren_Intere,
				Ren_TtCaIn	= #Rentas.Ren_TtCaIn,
				Ren_IvaInt	= #Rentas.Ren_IvaInt,
				Ren_IvaFac	= #Rentas.Ren_IvaFac,
				Ren_IvaRen	= #Rentas.Ren_IvaRen,
				Ren_Total	= #Rentas.Ren_Total
		from #Rentas
			 inner join #RenMen on #Rentas.Ren_Numero = #RenMen.Ren_Numero
		where	#Rentas.Ren_Numero	not in (@Str_RenExt, @Str_ValFut, @Amo_PagIni)

	end else if @Amo_TipCal = @Cal_Report begin

		if @Amo_TipCon = @Con_B2BPur  or @Amo_TipCon = @Con_LeaVIP begin /*B2B Puro o Auto Leasing Plus*/

			update #RenMen
				set Ren_Cotiza	= @Num_Cotiza,
					Ren_Numero	= #Rentas.Ren_Numero,
					Ren_Capita	= #Rentas.Ren_Capita,
					Ren_Intere	= #Rentas.Ren_Intere,
					Ren_TtCaIn	= #Rentas.Ren_TtCaIn,
					Ren_IvaInt	= #Rentas.Ren_IvaInt,
					Ren_IvaFac	= #Rentas.Ren_IvaFac,
					Ren_IvaRen	= #Rentas.Ren_IvaRen,
					Ren_Total	= #Rentas.Ren_Total
			from #Rentas
				 inner join #RenMen on #Rentas.Ren_Numero = #RenMen.Ren_Numero
	
		end else begin /*Arrendamiento-Comercial puro-credito*/

			update #RenMen
				set Ren_Cotiza	= @Num_Cotiza,
					Ren_Numero	= #Rentas.Ren_Numero,
					Ren_Capita	= #Rentas.Ren_Capita,
					Ren_Intere	= #Rentas.Ren_Intere,
					Ren_TtCaIn	= #Rentas.Ren_TtCaIn,
					Ren_IvaInt	= #Rentas.Ren_IvaInt,
					Ren_IvaFac	= #Rentas.Ren_IvaFac,
					Ren_IvaRen	= #Rentas.Ren_IvaRen,
					Ren_Total	= #Rentas.Ren_Total
			from #Rentas
				 inner join #RenMen on #Rentas.Ren_Numero = #RenMen.Ren_Numero
			where	#Rentas.Ren_Numero <> @Amo_PagIni

		end
	
	end else begin
	
		if @Amo_TipCon = @Con_B2BPur or @Amo_TipCon = @Con_LeaVIP begin /*B2B Puro o Auto Leasing Plus*/

			update #RenMen
				set Ren_Cotiza	= @Num_Cotiza,
					Ren_Numero	= #Rentas.Ren_Numero,
					Ren_Capita	= #Rentas.Ren_Capita,
					Ren_Intere	= #Rentas.Ren_Intere,
					Ren_TtCaIn	= #Rentas.Ren_TtCaIn,
					Ren_IvaInt	= #Rentas.Ren_IvaInt,
					Ren_IvaFac	= #Rentas.Ren_IvaFac,
					Ren_IvaRen	= #Rentas.Ren_IvaRen,
					Ren_Total	= #Rentas.Ren_Total
			from #Rentas
				 inner join #RenMen on #Rentas.Ren_Numero = #RenMen.Ren_Numero

			insert into #RenMen
			select	Ren_Cotiza	= @Str_Vacio,
					Ren_Numero	= @CadTotales,
					Ren_FecIni	= null,
					Ren_FecVen	= null,
					Ren_FecTer	= null,
					Ren_Capita	= sum(Ren_Capita),
					Ren_Intere	= sum(Ren_Intere),
					Ren_TtCaIn	= sum(Ren_TtCaIn),
					Ren_IvaInt	= sum(Ren_IvaInt),
					Ren_IvaFac	= sum(Ren_IvaFac),
					Ren_IvaRen	= sum(Ren_IvaRen),
					Ren_Total	= sum(Ren_Total)
			from #Rentas
			where	Ren_Numero <> @Amo_PagIni

		end else begin /*Arrendamiento-comercial puro-credito*/
			update #RenMen
				set Ren_Cotiza	= @Num_Cotiza,
					Ren_Numero	= #Rentas.Ren_Numero,
					Ren_Capita	= #Rentas.Ren_Capita,
					Ren_Intere	= #Rentas.Ren_Intere,
					Ren_TtCaIn	= #Rentas.Ren_TtCaIn,
					Ren_IvaInt	= #Rentas.Ren_IvaInt,
					Ren_IvaFac	= #Rentas.Ren_IvaFac,
					Ren_IvaRen	= #Rentas.Ren_IvaRen,
					Ren_Total	= #Rentas.Ren_Total
			from #Rentas
				 inner join #RenMen on #Rentas.Ren_Numero = #RenMen.Ren_Numero
			where	#Rentas.Ren_Numero <> @Amo_PagIni
	
			insert into #RenMen
			select	Ren_Cotiza	= @Str_Vacio,
					Ren_Numero	= @CadTotales,
					Ren_FecIni	= null,
					Ren_FecVen	= null,
					Ren_FecTer	= null,
					Ren_Capita	= sum(Ren_Capita),
					Ren_Intere	= sum(Ren_Intere),
					Ren_TtCaIn	= sum(Ren_TtCaIn),
					Ren_IvaInt	= sum(Ren_IvaInt),
					Ren_IvaFac	= sum(Ren_IvaFac),
					Ren_IvaRen	= sum(Ren_IvaRen),
					Ren_Total	= sum(Ren_Total)
			from #Rentas
			where	Ren_Numero <> @Amo_PagIni

		end
	
	end

end else begin
	if @Amo_TipCal = @Cal_ConEsp begin
		delete from #RenMen
		insert into #RenMen
		select	@Num_Cotiza,	Ren_Numero,	@Fec_Vacia,	@Fec_Vacia,	@Fec_Vacia,
				Ren_Capita,		Ren_Intere,	Ren_TtCaIn,	Ren_IvaInt,	Ren_IvaFac,
				Ren_IvaRen,		Ren_Total
		from #Rentas
		where	Ren_Numero	not in (@Str_RenExt, @Str_ValFut, @Amo_PagIni)
	
	end else begin
		if @Amo_TipCon = @Con_B2BPur or @Amo_TipCon = @Con_LeaVIP begin /*B2B Puro o Auto Leasing Plus*/

			delete from #RenMen
			insert into #RenMen
			select	@Num_Cotiza,	Ren_Numero,	@Fec_Vacia,	@Fec_Vacia,	@Fec_Vacia,
					Ren_Capita,		Ren_Intere,	Ren_TtCaIn,	Ren_IvaInt,	Ren_IvaFac,
					Ren_IvaRen,		Ren_Total
			from #Rentas
	
		end else begin /*Arrendamiento-comercial puro-credito*/

			delete from #RenMen
			insert into #RenMen
			select	@Num_Cotiza,	Ren_Numero,	@Fec_Vacia,	@Fec_Vacia,	@Fec_Vacia,
					Ren_Capita,		Ren_Intere,	Ren_TtCaIn,	Ren_IvaInt,	Ren_IvaFac,
					Ren_IvaRen,		Ren_Total
			from #Rentas
			where	Ren_Numero <> @Amo_PagIni
	
		end
	end
end

drop table #Rentas
