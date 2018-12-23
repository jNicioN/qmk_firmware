create procedure SOESFITIPRO (
	@Eft_TipFor	int,
	@Eft_ClEsFi	int,
	@Eft_EsFin1	int,
	@Eft_EsFin2	int,
	@Eft_EsFin3	int,
	@Eft_EsFin4	int,
	@Tip_Proces char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as
/****************************************************************/
/* DESCRIPCION: Proceso de Estados Financieros Tipo Cuenta		*/
/****************************************************************/
/** Modifico:		Victor Osorio								*/
/** Fecha:			20/09/2017                               	*/
/** Descripcion:	Se agrega proceso G para reporte caratula	*/
/** Help:			929417 					 					*/
/****************************************************************/
/** Creo:		Claudia Sandoval								*/
/** Fecha:		08/03/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Variables */
declare	@Ent_Cuenta	int,		/* Entero numero partida */
		@Ent_Column	int,		/* Entero numero de columna */
		@Ent_i		int,		/* Entero indice i */
		@Max_Report	int,		/* Entero variable contador reporte */
		@Ent_Existe	int,		/* Entero contador existe */
		@Esf_EfiNu1 int,		/* Entero numero estado financiero 1 */
		@Esf_EfiNu2 int,		/* Entero numero estado financiero 2 */
		@Esf_EfiNu3 int,		/* Entero numero estado financiero 3 */
		@Esf_EfiNu4 int,		/* Entero numero estado financiero 4 */
		@Esf_PerNum int,		/* Entero numero de persona */
		@Esf_SolNum int,		/* Entero numero de solicitud */
		@Niv_Padre int,			/* Entero contador de nivel padre */
		@Esf_MesIni1 int,		/* Entero mes inicial 1 */
		@Esf_MesFin1 int,		/* Entero mes final 1 */
		@Esf_MesIni2 int,		/* Entero mes inicial 2 */
		@Esf_MesFin2 int,		/* Entero mes final 2 */
		@Esf_MesIni3 int,		/* Entero mes inicial 3 */
		@Esf_MesFin3 int,		/* Entero mes final 3 */
		@Status		 int		/* Entero estatus */

/* Declaracion de Constantes */
declare	@Tip_ProA char(1),		/* Caracter A */
		@Tip_ProB char(1),		/* Caracter B */
		@Tip_ProC char(1),		/* Caracter C */
		@Tip_ProD char(1),		/* Caracter D */
		@Tip_ProE char(1),		/* Caracter E */
		@Tip_ProF char(1),		/* Caracter F */
		@Tip_ProG char(1),		/* Caracter G */
		@Tip_A char(1),			/* Caracter tipo A */
		@Tip_E char(1),			/* Caracter tipo E */
		@Ent_Cero	int,		/* Entero Cero */
		@Ent_Uno	int,		/* Entero Uno */
		@Bit_Si		bit,		/* Bit valor 1 */
		@Bit_No		bit,		/* Bit valor 0 */
		@Ent_Max	int,		/* Entero contador maximo a 200*/
		@Mon_Cero	money,		/* Moneda $0.00 */
		@Cha_Vacio	char(1),	/* Char vacio */
		@Tip_C2		char(2),	/* Char C2 */
		@Tip_C4 	char(2),	/* Char C4 */
		@Tip_C6		char(2)		/* Char C6 */

select	@Ent_Cero	= 0,
		@Ent_Uno	= 1,
		@Bit_Si		= 1,
		@Bit_No		= 0,
		@Ent_Max	= 200,
		@Mon_Cero	= $0.00,
		@Tip_ProA 	= 'A',
		@Tip_ProB 	= 'B',
		@Tip_ProC 	= 'C',
		@Tip_ProD 	= 'D',
		@Tip_ProE	= 'E',
		@Tip_ProF	= 'F',
		@Tip_ProG	= 'G',
		@Cha_Vacio	= '',
		@Esf_EfiNu1 = 0,
		@Esf_EfiNu2 = 0,
		@Esf_EfiNu3 = 0,
		@Esf_EfiNu4 = 0,
		@Tip_A 		= 'A',
		@Tip_E 		= 'E',
		@Niv_Padre	= 0,
		@Esf_MesIni1 = 0,
		@Esf_MesFin1 = 0,
		@Esf_MesIni2 = 0,
		@Esf_MesFin2 = 0,
		@Esf_MesIni3 = 0,
		@Esf_MesFin3 = 0,
		@Tip_C2 = 'C2',
		@Tip_C4 = 'C4',
		@Tip_C6 = 'C6'
			
		
select	@Ent_Cuenta = @Ent_Uno,
		@Ent_i		= @Ent_Uno

if @Tip_Proces = @Tip_ProA begin
	create table #Cuentas (
		Cue_Report	int,
		Cue_PaTiCu	int null,
		Cue_Nivel	varchar(50),
		Cue_TipCue	int not null,
		Cue_Descri	varchar(150) null,
		Cue_Visibl	bit not null,
		Cue_Captur	bit not null,
		Cue_Indice	int,
		Cue_TipAna	int null,
		Cue_ParSug	bit not null,
		Cue_NivPad	int not null,
		Cue_Visual	bit not null,
		Cue_Identa	int null
	)

	create table #CueEEFF (
		Eft_Report	int,
		Eft_PaTiCu	int null,
		Eft_Nivel	varchar(50),
		Eft_TipCue	int not null,
		Eft_Descri	varchar(150) null,
		Eft_Visibl	bit not null,
		Eft_Captur	bit not null,
		Eft_Visual	bit not null,
		Eft_Identa	int null,
		Eft_Numero	int,
		Eft_EsFin1	int,
		Eft_Valor1	money,
		Eft_Porce1	money,
		Eft_EsFin2	int,
		Eft_Valor2	money,
		Eft_Porce2	money,
		Eft_EsFin3	int,
		Eft_Valor3	money,
		Eft_Porce3	money,
		Eft_Indice	int,
		Eft_TipAna	int null,
		Eft_TieAn1  bit not null,
		Eft_TieAn2  bit not null,
		Eft_TieAn3  bit not null,
		Eft_ParAc1  bit not null,
		Eft_ParAc2  bit not null,
		Eft_ParAc3  bit not null,
		Eft_NivPad	int not null
	)
	create table #CueTot (
		Tot_PaTiCu	int null,
		Tot_NumCue	int not null,
		Tot_Descri	varchar(150) null,
		Tot_Visibl	bit not null,
		Tot_Captur	bit not null,
		Tot_Indice	int null,
		Tot_TipAna	int null,
		Tot_ParSug	bit not null,
		Tot_Visual	bit not null,
		Tot_Identa	int null
	)

	insert into #CueTot
		select	Tic_PaTiCu, Tic_Numero, rtrim(isnull(Tic_Descri, Tic_DesTot)), Tfc_Visibl, Tcc_Captur, 
				Tfc_Indice,	Tic_TipAna, Tcc_ParSug,	tf.Tfc_Visual, cl.Tcc_Identa
		from SOTICUEF tc noholdlock
			inner join SOTFOTCU tf noholdlock 
				 on Tfc_Cuenta = Tic_Numero
				and Tfc_Format = @Eft_TipFor 
				and Tfc_Stock <> @Bit_Si
			inner join SOTICUCL cl noholdlock 
				 on Tcc_TipCue = Tic_Numero
				and Tcc_ClEsFi = @Eft_ClEsFi
			where Tfc_Stock		<> @Bit_Si

	update #CueTot set
		Tot_Descri = Tic_DesTot
		from SOTICUEF noholdlock
		where	Tot_Descri is null
		  and	Tot_NumCue = Tic_Numero

	update #CueTot set
		Tot_Descri = Tic_DesTot
		from SOTICUEF noholdlock
		where	char_length(ltrim(rtrim(Tic_DesTot)))>@Ent_Cero
		  and	Tot_NumCue = Tic_Numero

	create index #CueTotPa on #CueTot (Tot_PaTiCu)

	insert into #Cuentas
		select	@Ent_Uno,	Tot_PaTiCu, convert(char, Tot_NumCue), Tot_NumCue, Tot_Descri,
				Tot_Visibl, Tot_Captur,	Tot_Indice,	Tot_TipAna, Tot_ParSug,	@Niv_Padre,	Tot_Visual,
				Tot_Identa
		from #CueTot
			where Tot_PaTiCu is null

	select	@Niv_Padre = @Niv_Padre + @Ent_Uno
	
	select	@Max_Report = Max(Cue_Report)
		from #Cuentas

	select Pad_TipCue = Cue_TipCue
		into #Padres
		from #Cuentas
		where Cue_Report = @Max_Report

	select	@Ent_Existe = @Ent_Cero
	select	@Ent_Existe = @Ent_Uno
		from #CueTot
		inner join #Padres on Pad_TipCue = Tot_PaTiCu

	while @Ent_Existe = @Ent_Uno and @Ent_i <= @Ent_Max begin 
		insert into #Cuentas
			select 	@Max_Report + @Ent_Uno, Tot_PaTiCu,
					ltrim(rtrim(Cue_Nivel))  + '/' + convert( char(10), Tot_NumCue),
					Tot_NumCue, Tot_Descri, Tot_Visibl, Tot_Captur,	Tot_Indice,	
					Tot_TipAna,	Tot_ParSug,	@Niv_Padre,	Tot_Visual, Tot_Identa
				from #CueTot 
				inner join #Cuentas on Cue_TipCue = Tot_PaTiCu
				inner join #Padres  on Pad_TipCue = Tot_PaTiCu

		select	@Niv_Padre = @Niv_Padre + @Ent_Uno

		select @Ent_Column = max(Cue_Report)
			from #Cuentas

		select	@Max_Report = Max(Cue_Report)
			from #Cuentas 

		delete #Padres

		insert into #Padres
			select Cue_TipCue 
				from #Cuentas
				where Cue_Report = @Max_Report

		select	@Ent_Existe = @Ent_Cero
		select	@Ent_Existe = @Ent_Uno
			from #CueTot
			inner join #Padres on Pad_TipCue = Tot_PaTiCu

		select @Ent_i = @Ent_i + @Ent_Uno
	end
	drop table #Padres

	insert into #CueEEFF
		select	Cue_Report, Cue_PaTiCu, Cue_Nivel,	Cue_TipCue,	Cue_Descri,
				Cue_Visibl, Cue_Captur,	Cue_Visual, Cue_Identa, isnull(Eft_Numero, @Ent_Cero), @Eft_EsFin1,
				isnull(Eft_Valor, @Mon_Cero),	isnull(Eft_Porcen, @Mon_Cero),
				@Eft_EsFin2,	@Mon_Cero,	@Mon_Cero,	@Eft_EsFin3,	@Mon_Cero,
				@Mon_Cero,		Cue_Indice,	Cue_TipAna, @Bit_No, @Bit_No, @Bit_No,
				@Bit_No,		@Bit_No,	@Bit_No,	Cue_NivPad
			from #Cuentas
			left join SOESFITI noholdlock 
				 on Eft_TipCue = Cue_TipCue
				and Eft_EstFin = @Eft_EsFin1

	if @Eft_EsFin1 > 0 begin
		update #CueEEFF set
			Eft_TieAn1	= Eft_TieAna,
			Eft_ParAc1	= Eft_ParAct
			from SOESFITI noholdlock 
			where Eft_EstFin = @Eft_EsFin1
			  and SOESFITI.Eft_TipCue = #CueEEFF.Eft_TipCue
	end

	if @Eft_EsFin2 > 0 begin
		update #CueEEFF set
			Eft_Valor2	= Eft_Valor,
			Eft_Porce2	= Eft_Porcen,
			Eft_TieAn2	= Eft_TieAna,
			Eft_ParAc2	= Eft_ParAct
			from SOESFITI noholdlock
			where Eft_EstFin = @Eft_EsFin2
			  and SOESFITI.Eft_TipCue = #CueEEFF.Eft_TipCue
	end

	if @Eft_EsFin3 > 0 begin
		update #CueEEFF set
			Eft_Valor3	= Eft_Valor,
			Eft_Porce3	= Eft_Porcen,
			Eft_TieAn3	= Eft_TieAna,
			Eft_ParAc3	= Eft_ParAct
			from SOESFITI noholdlock 
			where Eft_EstFin = @Eft_EsFin3
			  and SOESFITI.Eft_TipCue = #CueEEFF.Eft_TipCue
	end
	
	select	distinct 
				Eft_Nivel,		Eft_PaTiCu,		Eft_Report,		Eft_TipCue,		Eft_Descri,
				Eft_Visibl, 	Eft_Captur,		Eft_Visual,		Eft_Numero,		Eft_EsFin1,		
				Eft_Valor1,		Eft_Porce1,		Eft_EsFin2,		Eft_Valor2,		Eft_Porce2,		
				Eft_EsFin3,		Eft_Valor3,		Eft_Porce3,		Eft_Indice,		Eft_TipAna,		
				tic.Tic_Codigo,	tcu.Tcc_Formul,	tcu.Tcc_ForPor,	Eft_TieAn1,		Eft_TieAn2,		
				Eft_TieAn3,		tic.Tic_TipVal,	Eft_ParAc1,		Eft_ParAc2,		Eft_ParAc3,		
				tcu.Tcc_ParSug,	Eft_NivPad,		tcu.Tcc_Identa
		from #CueEEFF
		left join SOTICUCL tcu noholdlock
		on tcu.Tcc_TipCue = Eft_TipCue
		and Tcc_ClEsFi = @Eft_ClEsFi
		inner join SOTICUEF tic noholdlock
		on tic.Tic_Numero	= tcu.Tcc_TipCue
		where Eft_Visibl	= @Bit_Si
	order by Eft_Indice
	
	drop table #CueEEFF, #Cuentas, #CueTot
	
end	else if @Tip_Proces = @Tip_ProB begin
	
	select @Esf_PerNum = Esf_PerNum
			from SOESTFIN efn noholdlock
				where Esf_Numero = @Eft_EsFin1

	select @Esf_SolNum = Esf_Solici
			from SOESTFIN efn noholdlock
				where Esf_Numero = @Eft_EsFin1
	
	if @Eft_EsFin1 > @Ent_Cero begin
		exec SOESTFINCON @Eft_EsFin1, @Esf_PerNum, @Esf_SolNum, @Ent_Cero, 
			@Cha_Vacio, @Ent_Cero, @Ent_Cero, @Esf_EfiNu1 output, @Tip_C2, @NumTransac, @Transaccio, @Usuario,
			@FechaSis, @SucOrigen, @SucDestino, @Modulo
	end
	if @Eft_EsFin2 > @Ent_Cero begin
		exec SOESTFINCON @Eft_EsFin2, @Esf_PerNum, @Esf_SolNum, @Ent_Cero,
			@Cha_Vacio, @Ent_Cero, @Ent_Cero, @Esf_EfiNu2 output, @Tip_C2, @NumTransac, @Transaccio, @Usuario,
			@FechaSis, @SucOrigen, @SucDestino, @Modulo
	end
	if @Eft_EsFin3 > @Ent_Cero begin
		exec SOESTFINCON @Eft_EsFin3, @Esf_PerNum, @Esf_SolNum, @Ent_Cero,
			@Cha_Vacio, @Ent_Cero, @Ent_Cero, @Esf_EfiNu3 output, @Tip_C2, @NumTransac, @Transaccio, @Usuario, 
			@FechaSis, @SucOrigen, @SucDestino, @Modulo
	end
	if @Eft_EsFin4 > @Ent_Cero begin
		exec SOESTFINCON @Eft_EsFin4, @Esf_PerNum, @Esf_SolNum, @Ent_Cero, 
			@Cha_Vacio, @Ent_Cero, @Ent_Cero, @Esf_EfiNu4 output, @Tip_C2, @NumTransac, @Transaccio, @Usuario, 
			@FechaSis, @SucOrigen, @SucDestino, @Modulo
	end

	exec @Status = SOESFITIPRO @Eft_TipFor, @Eft_ClEsFi, @Esf_EfiNu1, @Esf_EfiNu2, @Esf_EfiNu3, @Esf_EfiNu4, @Tip_A,
		@NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo

	if @Status <> @Ent_Cero begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de Estados Financieros'

		rollback
		return @Ent_Uno
	end
	
end	else if @Tip_Proces = @Tip_ProC begin

	select	@Esf_PerNum = Esf_PerNum,
			@Esf_MesIni1 = Esf_MesIni,
			@Esf_MesFin1 = Esf_MesFin
		from SOESTFIN efn noholdlock
		where Esf_Numero = @Eft_EsFin1

	select 	@Esf_MesIni2 = Esf_MesIni,
			@Esf_MesFin2 = Esf_MesFin
		from SOESTFIN efn noholdlock
		where Esf_Numero = @Eft_EsFin2

	select 	@Esf_MesIni3 = Esf_MesIni,
			@Esf_MesFin3 = Esf_MesFin
		from SOESTFIN efn noholdlock
		where Esf_Numero = @Eft_EsFin3

	if @Eft_EsFin1 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin1, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero, 	@Cha_Vacio, 
			@Esf_MesIni1, 	@Esf_MesFin1, 	@Esf_EfiNu1 output, @Tip_C4, 	@NumTransac, 
			@Transaccio, 	@Usuario, 		@FechaSis, 			@SucOrigen, @SucDestino, 
			@Modulo
	end
	if @Eft_EsFin2 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin2, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero, 		@Cha_Vacio, 
			@Esf_MesIni2, 	@Esf_MesFin2, 	@Esf_EfiNu2 output, @Tip_C4, 		@NumTransac, 
			@Transaccio, 	@Usuario, 		@FechaSis, 			@SucOrigen, 	@SucDestino, 
			@Modulo
	end
	if @Eft_EsFin3 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin3, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero, 		@Cha_Vacio,
			@Esf_MesIni3, 	@Esf_MesFin3, 	@Esf_EfiNu3 output, @Tip_C4, 		@NumTransac,
			@Transaccio, 	@Usuario, 		@FechaSis, 			@SucOrigen, 	@SucDestino,
			@Modulo
	end

	exec @Status = SOESFITIPRO
		@Eft_TipFor, 		@Eft_ClEsFi, 	@Esf_EfiNu1, 		@Esf_EfiNu2, 	@Esf_EfiNu3,
		@Esf_EfiNu4, 		@Tip_A,			@NumTransac, 		@Transaccio, 	@Usuario,
		@FechaSis, 			@SucOrigen, 	@SucDestino, 		@Modulo
	
	if @Status <> @Ent_Cero begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de Estados Financieros'

		rollback
		return @Ent_Uno
	end
end else if @Tip_Proces = @Tip_ProD begin
	create table #CuentasAdi (
		Cue_Report	int,
		Cue_PaTiCu	int null,
		Cue_TipCue	int not null,
		Cue_Descri	varchar(150) null,
		Cue_Visibl	bit not null,
		Cue_Indice	int
	)

	create table #EeffAdi (
		Eft_Report	int,
		Eft_PaTiCu	int null,
		Eft_TipCue	int not null,
		Eft_Descri	varchar(150) null,
		Eft_Visibl	bit not null,
		Eft_Indice	int,
		Eft_Numero	int,
		Eft_EsFin1	int,
		Eft_AplIc1	bit not null,
		Eff_Icap1	numeric(10,2) null,
		EFf_CapNe1	numeric(10,2) null,
		Esf_AcSuR1	numeric(10,2) null,
		Esf_TipSo1	int  null,
		Esf_TipLi1	int  null,
		Esf_TipEf1	int  null,
		Eft_EsFin2	int,
		Eft_AplIc2	bit not null,
		Eff_Icap2	numeric(10,2) null,
		EFf_CapNe2	numeric(10,2) null,
		Esf_AcSuR2	numeric(10,2) null,
		Esf_TipSo2	int  null,
		Esf_TipLi2	int  null,
		Esf_TipEf2	int  null,
		Eft_EsFin3	int,
		Eft_AplIc3	bit not null,
		Eff_Icap3	numeric(10,2) null,
		EFf_CapNe3	numeric(10,2) null,
		Esf_AcSuR3	numeric(10,2) null,
		Esf_TipSo3	int  null,
		Esf_TipLi3	int  null,
		Esf_TipEf3	int  null
	)
	create table #TotalesAdi (
		Tot_PaTiCu	int null,
		Tot_NumCue	int not null,
		Tot_Descri	varchar(150) null,
		Tot_Visibl	bit not null,
		Tot_Indice	int null
	)

	insert into #TotalesAdi
		select	Tic_PaTiCu, Tic_Numero, rtrim(isnull(Tic_Descri, Tic_DesTot)), Tfc_Visibl, Tfc_Indice
		from SOTICUEF tc noholdlock
			inner join SOTFOTCU tf noholdlock 
				 on Tfc_Cuenta = Tic_Numero
				and Tfc_Format = @Eft_TipFor 
				and Tfc_Stock <> @Bit_Si
			inner join SOTICUCL cl noholdlock 
				 on Tcc_TipCue = Tic_Numero
				and Tcc_ClEsFi = @Eft_ClEsFi
			where Tfc_Stock		<> @Bit_Si

	create index #TotalesAdiPa on #TotalesAdi (Tot_PaTiCu)

	insert into #CuentasAdi
		select	@Ent_Uno,	Tot_PaTiCu, Tot_NumCue, Tot_Descri,
				Tot_Visibl, Tot_Indice
		from #TotalesAdi
			where Tot_PaTiCu is null

	insert into #EeffAdi
		select	Cue_Report, Cue_PaTiCu, Cue_TipCue,	Cue_Descri,
				Cue_Visibl, Cue_Indice, isnull(Eft_Numero, @Ent_Cero),
				@Eft_EsFin1, @Bit_No, @Mon_Cero, @Mon_Cero, @Mon_Cero, @Ent_Cero, @Ent_Cero, @Ent_Cero,
				@Eft_EsFin2, @Bit_No, @Mon_Cero, @Mon_Cero, @Mon_Cero, @Ent_Cero, @Ent_Cero, @Ent_Cero,
				@Eft_EsFin3, @Bit_No, @Mon_Cero, @Mon_Cero, @Mon_Cero, @Ent_Cero, @Ent_Cero, @Ent_Cero
			from #CuentasAdi
			left join SOESFITI noholdlock 
				 on Eft_TipCue = Cue_TipCue
				and Eft_EstFin = @Eft_EsFin1

	if @Eft_EsFin1 > 0 begin
		update #EeffAdi set
			Eft_AplIc1	= Esf_AplIca,
			Eff_Icap1	= Esf_Icap,
			EFf_CapNe1	= Esf_CapNet,
			Esf_AcSuR1	= Esf_AcSuRi,
			Esf_TipSo1	= Esf_TipSol,
			Esf_TipLi1	= Esf_TipLiq,
			Esf_TipEf1	= Esf_TipEfi
			from SOESTFIN noholdlock 
			where Esf_Numero = @Eft_EsFin1
	end

	if @Eft_EsFin2 > 0 begin
		update #EeffAdi set
			Eft_AplIc2	= Esf_AplIca,
			Eff_Icap2	= Esf_Icap,
			EFf_CapNe2	= Esf_CapNet,
			Esf_AcSuR2	= Esf_AcSuRi,
			Esf_TipSo2	= Esf_TipSol,
			Esf_TipLi2	= Esf_TipLiq,
			Esf_TipEf2	= Esf_TipEfi
			from SOESTFIN noholdlock 
			where Esf_Numero = @Eft_EsFin2
	end

	if @Eft_EsFin3 > 0 begin
		update #EeffAdi set
			Eft_AplIc3	= Esf_AplIca,
			Eff_Icap3	= Esf_Icap,
			EFf_CapNe3	= Esf_CapNet,
			Esf_AcSuR3	= Esf_AcSuRi,
			Esf_TipSo3	= Esf_TipSol,
			Esf_TipLi3	= Esf_TipLiq,
			Esf_TipEf3	= Esf_TipEfi
			from SOESTFIN noholdlock 
			where  Esf_Numero = @Eft_EsFin3
	end

	select	Eft_TipCue,	Eft_Descri,	Eft_Visibl,	Eft_Indice,
			Eft_Numero,	Eft_EsFin1,	Eft_AplIc1,	Eff_Icap1,
			EFf_CapNe1,	Esf_AcSuR1,	Esf_TipSo1,	Esf_TipLi1,
			Esf_TipEf1,	Eft_EsFin2,	Eft_AplIc2,	Eff_Icap2,
			EFf_CapNe2,	Esf_AcSuR2,	Esf_TipSo2,	Esf_TipLi2,
			Esf_TipEf2,	Eft_EsFin3,	Eft_AplIc3,	Eff_Icap3,
			EFf_CapNe3,	Esf_AcSuR3,	Esf_TipSo3,	Esf_TipLi3,
			Esf_TipEf3
		from #EeffAdi
		where Eft_Visibl	= @Bit_Si
	order by Eft_Indice
	
	drop table #EeffAdi, #CuentasAdi, #TotalesAdi
end else if @Tip_Proces = @Tip_ProE begin		/* EEFF Gobierno */
	create table #CuentasGobierno (
		Cgo_Report	int,
		Cgo_PaTiCu	int null,
		Cgo_Nivel	varchar(50),
		Cgo_TipCue	int not null,
		Cgo_Descri	varchar(150) null,
		Cgo_Visibl	bit not null,
		Cgo_Captur	bit not null,
		Cgo_Indice	int,
		Cgo_NivPad	int not null,
		Cgo_Visual	bit not null,
		Cgo_Identa	int null
	)
	
	create table #CuentasEstadosGobierno (
		Cef_Report	int,
		Cef_PaTiCu	int null,
		Cef_Nivel	varchar(50),
		Cef_TipCue	int not null,
		Cef_Descri	varchar(150) null,
		Cef_Visibl	bit not null,
		Cef_Captur	bit not null,
		Cef_Visual	bit not null,
		Cef_Identa	int null,
		Cef_Numero	int,
		Cef_EsFin1	int,
		Cef_Valor1	money,
		Cef_Porce1	money,
		Cef_EsFin2	int,
		Cef_Valor2	money,
		Cef_Porce2	money,
		Cef_EsFin3	int,
		Cef_Valor3	money,
		Cef_Porce3	money,
		Cef_EsFin4	int,
		Cef_Valor4	money,
		Cef_Porce4	money,
		Cef_Indice	int,
		Cef_NivPad	int not null
	)
	create table #CuentasEstadosTotal (
		Cet_PaTiCu	int null,
		Cet_NumCue	int not null,
		Cet_Descri	varchar(150) null,
		Cet_Visibl	bit not null,
		Cet_Captur	bit not null,
		Cet_Indice	int null,
		Cet_Visual	bit not null,
		Cet_Identa	int null
	)

	insert into #CuentasEstadosTotal
		select	Tic_PaTiCu, Tic_Numero, rtrim(isnull(Tic_Descri, Tic_DesTot)), Tfc_Visibl, Tcc_Captur,
				Tfc_Indice,	tf.Tfc_Visual, cl.Tcc_Identa
		from SOTICUEF tc noholdlock
			inner join SOTFOTCU tf noholdlock 
				 on Tfc_Cuenta = Tic_Numero
				and Tfc_Format = @Eft_TipFor 
				and Tfc_Stock <> @Bit_Si
			inner join SOTICUCL cl noholdlock 
				 on Tcc_TipCue = Tic_Numero
				and Tcc_ClEsFi = @Eft_ClEsFi
			where Tfc_Stock		<> @Bit_Si

	update #CuentasEstadosTotal set
		Cet_Descri = Tic_DesTot
		from SOTICUEF noholdlock
		where	Cet_Descri is null
		  and	Cet_NumCue = Tic_Numero

	update #CuentasEstadosTotal set
		Cet_Descri = Tic_DesTot
		from SOTICUEF noholdlock
		where	char_length(ltrim(rtrim(Tic_DesTot)))>@Ent_Cero
		  and	Cet_NumCue = Tic_Numero

	create index #CuentasEstadosTotalPA on #CuentasEstadosTotal (Cet_PaTiCu)

	insert into #CuentasGobierno
		select	@Ent_Uno,	Cet_PaTiCu, convert(char, Cet_NumCue),	Cet_NumCue, Cet_Descri,
				Cet_Visibl, Cet_Captur,	Cet_Indice,	@Niv_Padre,	Cet_Visual,		Cet_Identa
		from #CuentasEstadosTotal
			where Cet_PaTiCu is null

	select	@Niv_Padre = @Niv_Padre + @Ent_Uno
	
	select	@Max_Report = Max(Cgo_Report)
		from #CuentasGobierno

	select Pad_TipCue = Cgo_TipCue
		into #PadreGobierno
		from #CuentasGobierno
		where Cgo_Report = @Max_Report

	select	@Ent_Existe = @Ent_Cero
	select	@Ent_Existe = @Ent_Uno
		from #CuentasEstadosTotal
		inner join #PadreGobierno on Pad_TipCue = Cet_PaTiCu

	while @Ent_Existe = @Ent_Uno and @Ent_i <= @Ent_Max begin 
		insert into #CuentasGobierno
			select @Max_Report + @Ent_Uno, Cet_PaTiCu,
				ltrim(rtrim(Cgo_Nivel))  + '/' + convert( char(10), Cet_NumCue),
				Cet_NumCue, Cet_Descri, Cet_Visibl,	Cet_Captur, Cet_Indice,	
				@Niv_Padre,	Cet_Visual, Cet_Identa
				from #CuentasEstadosTotal 
				inner join #CuentasGobierno on Cgo_TipCue = Cet_PaTiCu
				inner join #PadreGobierno  on Pad_TipCue = Cet_PaTiCu

		select	@Niv_Padre = @Niv_Padre + @Ent_Uno

		select @Ent_Column = max(Cgo_Report) 
			from #CuentasGobierno

		select	@Max_Report = Max(Cgo_Report)
			from #CuentasGobierno 

		delete #PadreGobierno
		
		insert into #PadreGobierno
			select Cgo_TipCue 
				from #CuentasGobierno
				where Cgo_Report = @Max_Report

		select	@Ent_Existe = @Ent_Cero
		select	@Ent_Existe = @Ent_Uno
			from #CuentasEstadosTotal
			inner join #PadreGobierno on Pad_TipCue = Cet_PaTiCu

		select @Ent_i = @Ent_i + @Ent_Uno
	end
	drop table #PadreGobierno

	insert into #CuentasEstadosGobierno
		select	Cgo_Report, 	Cgo_PaTiCu, 	Cgo_Nivel,		Cgo_TipCue,		Cgo_Descri,
				Cgo_Visibl,		Cgo_Captur, 	Cgo_Visual, 	Cgo_Identa, 	
				isnull(Eft_Numero, @Ent_Cero), 	@Eft_EsFin1,	isnull(Eft_Valor, @Mon_Cero),	
				isnull(Eft_Porcen, @Mon_Cero),	@Eft_EsFin2,	@Mon_Cero,		@Mon_Cero,
				@Eft_EsFin3,	@Mon_Cero,		@Mon_Cero,		@Eft_EsFin4,	@Mon_Cero,		
				@Mon_Cero,		Cgo_Indice,		Cgo_NivPad
			from #CuentasGobierno
			left join SOESFITI noholdlock 
				 on Eft_TipCue = Cgo_TipCue
				and Eft_EstFin = @Eft_EsFin1

	if @Eft_EsFin2 > 0 begin
		update #CuentasEstadosGobierno set
			Cef_Valor2	= Eft_Valor,
			Cef_Porce2	= Eft_Porcen
			from SOESFITI noholdlock
			where Eft_EstFin = @Eft_EsFin2
			  and SOESFITI.Eft_TipCue = #CuentasEstadosGobierno.Cef_TipCue
	end

	if @Eft_EsFin3 > 0 begin
		update #CuentasEstadosGobierno set
			Cef_Valor3	= Eft_Valor,
			Cef_Porce3	= Eft_Porcen
			from SOESFITI noholdlock 
			where Eft_EstFin = @Eft_EsFin3
			  and SOESFITI.Eft_TipCue = #CuentasEstadosGobierno.Cef_TipCue
	end

	if @Eft_EsFin4 > 0 begin
		update #CuentasEstadosGobierno set
			Cef_Valor4	= Eft_Valor,
			Cef_Porce4	= Eft_Porcen
			from SOESFITI noholdlock 
			where Eft_EstFin = @Eft_EsFin4
			  and SOESFITI.Eft_TipCue = #CuentasEstadosGobierno.Cef_TipCue
	end

	select	distinct 
			Cef_Nivel  AS Eft_Nivel,	Cef_PaTiCu AS Eft_PaTiCu,		Cef_Report AS Eft_Report,		Cef_TipCue AS Eft_TipCue,
			Cef_Descri AS Eft_Descri,	Cef_Visibl AS Eft_Visibl,		Cef_Captur AS Eft_Captur,		Cef_Visual AS Eft_Visual,
			Cef_Numero AS Eft_Numero,	Cef_EsFin1 AS Eft_EsFin1,		Cef_Valor1 AS Eft_Valor1,		Cef_Porce1 AS Eft_Porce1,
			Cef_EsFin2 AS Eft_EsFin2,	Cef_Valor2 AS Eft_Valor2,		Cef_Porce2 AS Eft_Porce2,		Cef_EsFin3 AS Eft_EsFin3,
			Cef_Valor3 AS Eft_Valor3,	Cef_Porce3 AS Eft_Porce3,		Cef_EsFin4 AS Eft_EsFin4,		Cef_Valor4 AS Eft_Valor4,
			Cef_Porce4 AS Eft_Porce4,	Cef_Indice AS Eft_Indice,		tic.Tic_Codigo,					tcu.Tcc_Formul,		
			tcu.Tcc_ForPor,				tic.Tic_TipVal,					Cef_NivPad AS Eft_NivPad,		tcu.Tcc_Identa
		from #CuentasEstadosGobierno
		left join SOTICUCL tcu noholdlock
		on tcu.Tcc_TipCue = Cef_TipCue
		and Tcc_ClEsFi = @Eft_ClEsFi
		inner join SOTICUEF tic noholdlock
		on tic.Tic_Numero	= tcu.Tcc_TipCue
		where Cef_Visibl	= @Bit_Si
	order by Cef_Indice

	drop table #CuentasEstadosGobierno, #CuentasGobierno, #CuentasEstadosTotal

end	else if @Tip_Proces = @Tip_ProF begin
	
	select @Esf_PerNum = Esf_PerNum
			from SOESTFIN efn noholdlock
				where Esf_Numero = @Eft_EsFin1
	
	if @Eft_EsFin1 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin1, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero,		@Cha_Vacio, 
			@Ent_Cero, 		@Ent_Cero, 		@Esf_EfiNu1 output, @Tip_C6, 		@NumTransac, 
			@Transaccio, 	@Usuario,		@FechaSis, 			@SucOrigen, 	@SucDestino, 
			@Modulo
	end
	if @Eft_EsFin2 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin2, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero,		@Cha_Vacio, 
			@Ent_Cero, 		@Ent_Cero, 		@Esf_EfiNu2 output, @Tip_C6, 		@NumTransac, 
			@Transaccio, 	@Usuario,		@FechaSis, 			@SucOrigen, 	@SucDestino, 
			@Modulo
	end
	if @Eft_EsFin3 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin3, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero,		@Cha_Vacio, 
			@Ent_Cero, 		@Ent_Cero, 		@Esf_EfiNu3 output, @Tip_C6, 		@NumTransac, 
			@Transaccio, 	@Usuario, 		@FechaSis, 			@SucOrigen, 	@SucDestino, 
			@Modulo
	end
	if @Eft_EsFin4 > @Ent_Cero begin
		exec SOESTFINCON 
			@Eft_EsFin4, 	@Esf_PerNum, 	@Ent_Cero, 			@Ent_Cero, 		@Cha_Vacio, 
			@Ent_Cero, 		@Ent_Cero, 		@Esf_EfiNu4 output, @Tip_C6, 		@NumTransac, 
			@Transaccio, 	@Usuario, 		@FechaSis, 			@SucOrigen, 	@SucDestino, 
			@Modulo
	end

	exec @Status = SOESFITIPRO 
		@Eft_TipFor, 	@Eft_ClEsFi, 	@Esf_EfiNu1, 	@Esf_EfiNu2, 	@Esf_EfiNu3, 
		@Esf_EfiNu4, 	@Tip_E,			@NumTransac, 	@Transaccio, 	@Usuario, 
		@FechaSis, 		@SucOrigen, 	@SucDestino, 	@Modulo

	if @Status <> @Ent_Cero begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en proceso de Estados Financieros'

		rollback
		return @Ent_Uno
	end
end	else if @Tip_Proces = @Tip_ProG begin
	create table #CuentaValorEeff (
		Eft_TipCue	int not null,
		Eft_DesRep	varchar(150) null,
		Eft_Numero	int,
		Eft_EsFin1	int,
		Eft_Valor1	money,
		Eft_Porce1	money,
		Eft_EsFin2	int,
		Eft_Valor2	money,
		Eft_Porce2	money,
		Eft_Indice	int null
	)
	create table #CuentaReporte (
		Tot_NumCue	int not null,
		Tot_DesRep	varchar(150) null,
		Tot_Indice	int null
	)

	insert into #CuentaReporte
		select	Tic_Numero, Tic_DesRep, Tfc_IndRep
		from SOTICUEF tc noholdlock
			inner join SOTFOTCU tf noholdlock
				 on Tfc_Cuenta = Tic_Numero
				and Tfc_Format = @Eft_TipFor
				and Tfc_Stock <> @Bit_Si
			inner join SOTICUCL cl noholdlock 
				 on Tcc_TipCue = Tic_Numero
				and Tcc_ClEsFi = @Eft_ClEsFi
			where Tfc_Stock		<> @Bit_Si
			  and Tfc_Report	= @Ent_Uno

	insert into #CuentaValorEeff
		select	Tot_NumCue,		Tot_DesRep,		isnull(Eft_Numero, @Ent_Cero),
				@Eft_EsFin1,	isnull(Eft_Valor, @Mon_Cero),	isnull(Eft_Porcen, @Mon_Cero),
				@Eft_EsFin2,	@Mon_Cero,		@Mon_Cero,
				Tot_Indice
		from #CuentaReporte
		left join SOESFITI noholdlock
		on	Eft_TipCue = Tot_NumCue
		and Eft_EstFin = @Eft_EsFin1

	update #CuentaValorEeff set
		Eft_Valor2	= Eft_Valor,
		Eft_Porce2	= Eft_Porcen
		from SOESFITI noholdlock
		where Eft_EstFin = @Eft_EsFin2
		  and SOESFITI.Eft_TipCue = #CuentaValorEeff.Eft_TipCue

	select	Eft_TipCue,
			Eft_DesRep AS Eft_Descri,
			Eft_Numero,
			Eft_EsFin1,
			Eft_Valor1,
			Eft_Porce1,
			Eft_EsFin2,
			Eft_Valor2,
			Eft_Porce2,
			Eft_Indice
		from #CuentaValorEeff
		order by Eft_Indice

	drop table #CuentaValorEeff, #CuentaReporte
end
