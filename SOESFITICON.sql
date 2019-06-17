create procedure SOESFITICON (
   @Eft_Numero int,
   @Eft_EstFin int,
   @Eft_TipCue int,
   @Eft_FilCue varchar(50),
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
/** DESCRIPCION: Consulta de registros de estado financiero		*/
/**				tipo cuenta en SOESFITI							*/
/****************************************************************/
/****************************************************************/
/** Modifico:		José Eduardo Sánchez Méndez					*/
/** Fecha:			19/09/2018                               	*/
/** Help:			1113298 					 				*/
/** Descripcion:	Consulta por tipo cta y estado financiero	*/
/****************************************************************/
/** Modifico:		Victor Osorio								*/
/** Fecha:			17/10/2017                               	*/
/** Help:			929417 					 					*/
/** Descripcion:	Se agrega consulta L6 Partidas y Sumatorias	*/
/****************************************************************/
/** Creo:			Felipe Castillo								*/
/** Fecha:			19/05/2017                               	*/
/** Help:			929417 					 					*/
/****************************************************************/

/* Declaracion de variables */
declare @Tip_ConTip char(1),			/* Tipo de Consulta C/L */
        @Tip_ConCon char(1),			/* Numero de Consulta */
        @Int_Index int					/* Entero indice para substring */

/* Declaracion de constantes */
declare @Str_C char(1),					/* Caracter C */
        @Str_Uno char(1),				/* Caracter 1 */
        @Str_Dos char(1),				/* Caracter 2 */
        @Str_Tres char(1),				/* Caracter 3 */
		@Str_Cuatro char (1),			/* Caracter 4 */
		@Str_Cinco char(1),				/* Caracter 5 */
		@Str_Seis char(1),				/* Caracter 6 */
        @Str_CuToAc char(5),			/* Codigo Activo */
        @Str_CuInVe char(5),			/* Codigo Total de Ingresos */
        @Str_CuUNet char(5),			/* Codigo Utilidad Neta */
        @Str_CuUAfi char(5),			/* Codigo Utilidad de la operacion */
        @Str_CuPasi char(5),			/* Codigo Total Pasivo */
        @Str_CuCaCo char(5),			/* Codigo Total Capital Contable */
        @Str_CuQuTe char(5),			/* Codigo Quiebra Tecnica */
        @Str_TerEdi char(5),			/* Codigo Terrenos y Edificios */
        @Int_Cero	int,				/* Entero Cero */
        @Int_Uno	int,					/* Entero Uno */
        @Tipo_Cta int ,                  /*tipo cuenta*/   
        @Str_coma char(1)				/*coma*/                 

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2',
       @Str_Tres = '3',
	   @Str_Cuatro = '4',
	   @Str_Cinco = '5',
	   @Str_Seis = '6',
	   @Int_Cero = 0,
       @Str_CuToAc = 'C0036',
       @Str_CuInVe = 'C0075',
       @Str_CuUNet = 'C0094',
       @Str_CuUAfi = 'C0081',
       @Str_CuPasi = 'C0060',
       @Str_CuCaCo = 'C0072',
       @Str_CuQuTe = 'C0503',
       @Str_TerEdi = 'C0015',
       @Int_Uno = 1,
       @Tipo_Cta=192,
       @Str_coma=','
       

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select Eft_Numero,    Eft_EstFin,    Eft_TipCue,	Eft_Valor,	Eft_Porcen, 
			NumTransac,    Transaccio,    Usuario,    	FechaSis,	SucOrigen, 
			SucDestino 
		 from SOESFITI noholdlock 
		 where Eft_Numero = @Eft_Numero
   end
   if @Tip_ConCon = @Str_Dos begin		/* C2 */
     select Eft_Numero,    Eft_EstFin,    Eft_TipCue,	Eft_Valor,	Eft_Porcen, 
			NumTransac,    Transaccio,    Usuario,		FechaSis,	SucOrigen, 
			SucDestino 
		 from SOESFITI noholdlock 
		 where Eft_EstFin = @Eft_EstFin and Eft_TipCue = @Eft_TipCue
   end
   if @Tip_ConCon = @Str_Tres begin /* C3 */
        select ( ef.Esf_MesFin - ef.Esf_MesIni )+ @Int_Uno as Esf_MesTot,Eft_Valor 
            from SOESFITI eftc noholdlock 
            inner join SOESTFIN ef noholdlock
                on ef. Esf_Numero =eftc. Eft_EstFin 
            WHERE  eftc.Eft_EstFin =@Eft_EstFin AND  eftc.Eft_TipCue = @Tipo_Cta
    end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select Eft_Numero,    Eft_EstFin,    Eft_TipCue,	Eft_Valor,	Eft_Porcen, 
			NumTransac,    Transaccio,    Usuario,    	FechaSis,	SucOrigen, 
			SucDestino 
		from SOESFITI noholdlock   
   end
    if @Tip_ConCon = @Str_Dos begin /* L2 */
    	select Tic_Codigo,		Eft_Valor,		Esf_ExpCif,	 		tif.NumTransac,		tif.Transaccio,    
			   tif.Usuario,     tif.FechaSis,   tif.SucOrigen,   	tif.SucDestino 
			from SOTICUEF tc noholdlock
			inner join SOESFITI tif noholdlock 
				on Eft_TipCue = Tic_Numero
			inner join SOESTFIN ef noholdlock 
				on  Esf_Numero =  Eft_EstFin
			where Esf_Numero = @Eft_EstFin
			and Tic_Codigo IN (@Str_CuToAc, @Str_CuInVe, @Str_CuUNet, @Str_CuUAfi, @Str_CuPasi, @Str_CuCaCo)
   end
    if @Tip_ConCon = @Str_Tres begin /* L3 QUIEBRA TECNICA */
    	select Tic_Codigo,		Eft_Valor,		Esf_ExpCif,	 		tif.NumTransac,		tif.Transaccio,    
			   tif.Usuario,     tif.FechaSis,   tif.SucOrigen,   	tif.SucDestino 
			from SOTICUEF tc noholdlock
			inner join SOESFITI tif noholdlock 
				on Eft_TipCue = Tic_Numero
			inner join SOESTFIN ef noholdlock 
				on  Esf_Numero =  Eft_EstFin
			where Esf_Numero = @Eft_EstFin
			and Tic_Codigo = @Str_CuQuTe
   end
   if @Tip_ConCon = @Str_Cuatro begin /* L4 Carga datos Analitica por Tipo Cuenta*/
		/* tabla temporal para Tipo Cuentas*/
		create table #Tmp_TipCue(id int)
		
		/* Se separan los IDs de Tipo Cuentas*/
		select @Int_Index = charindex(@Str_coma, @Eft_FilCue)
		
		while @Int_Index > @Int_Cero begin
			insert into #Tmp_TipCue
				values (CONVERT(INT,left(@Eft_FilCue, @Int_Index-1)))
			set @Eft_FilCue	= substring(@Eft_FilCue, @Int_Index+1, datalength(@Eft_FilCue) - @Int_Index)
			select @Int_Index = charindex(@Str_coma, @Eft_FilCue)
		end
		
		insert into #Tmp_TipCue
				values (CONVERT(INT,@Eft_FilCue))
		
    	select 	Eft_Numero, 	Eft_EstFin, 	Eft_TipCue, 	Aec_Concep, 	Aec_Monto, 
				Aec_Porcen, 	Ane_VarMon, 	eft.NumTransac,	eft.Transaccio, eft.Usuario,     
				eft.FechaSis,   eft.SucOrigen,  eft.SucDestino 
			from SOESFITI eft noholdlock
			inner join SOANAEST ae noholdlock
				on Ane_EsFiCu = Eft_Numero
			inner join SOANESCO aec noholdlock
				on Aec_AnaEst = Ane_Numero
			where Eft_EstFin = @Eft_EstFin
			and Eft_TipCue IN (Select id from #Tmp_TipCue)
		
		drop table #Tmp_TipCue
   end
   if @Tip_ConCon = @Str_Cinco begin /* L5 Carga Estado Financiero X Tipo Cuenta Para Garantias Reales.*/
    	select Eft_Numero,		Tic_Codigo,		Eft_Valor,		 Esf_ExpCif,	 tif.NumTransac,	
			   tif.Transaccio,  tif.Usuario,     tif.FechaSis,   tif.SucOrigen,  tif.SucDestino 
			from SOTICUEF tc noholdlock
			inner join SOESFITI tif noholdlock 
				on Eft_TipCue = Tic_Numero
			inner join SOESTFIN ef noholdlock 
				on  Esf_Numero =  Eft_EstFin
			where Esf_Numero = @Eft_EstFin
			and Tic_Codigo IN (@Str_CuToAc, @Str_CuPasi, @Str_TerEdi)
   end
	if @Tip_ConCon = @Str_Seis begin /* L6 Carga las sumatorias totales de todos los parciales de ciertas cuentas */
		/* tabla temporal para Tipo Cuentas*/
		create table #TmpCuentas(Tmp_NumCue int)
		
		/* Se separan los IDs de Tipo Cuentas*/
		select @Int_Index = charindex(@Str_coma, @Eft_FilCue)
		
		while @Int_Index > @Int_Cero begin
			insert into #TmpCuentas
				values (CONVERT(INT,left(@Eft_FilCue, @Int_Index-1)))
			set @Eft_FilCue	= substring(@Eft_FilCue, @Int_Index+1, datalength(@Eft_FilCue) - @Int_Index)
			select @Int_Index = charindex(@Str_coma, @Eft_FilCue)
		end

		/* Se inserta ultimo tipo cuenta */
		insert into #TmpCuentas
			values (CONVERT(INT,@Eft_FilCue))

		select Esf_PerNum, Esf_Solici, Esf_Anio
			into #EstadoFinanciero
			from SOESTFIN noholdlock
			where Esf_Numero = @Eft_EstFin

		select	soft.Eft_TipCue,	SUM(soft.Eft_Valor) as Eft_Valor
			from #EstadoFinanciero ef noholdlock
			inner join SOESTFIN soef noholdlock
				on	soef.Esf_PerNum	= ef.Esf_PerNum
				and	soef.Esf_Solici	= ef.Esf_Solici
				and	soef.Esf_Anio	= ef.Esf_Anio
			inner join SOESFITI soft noholdlock
				on	Esf_Numero = Eft_EstFin
			inner join #TmpCuentas tmpc
				on	tmpc.Tmp_NumCue = soft.Eft_TipCue
			where Esf_Status	= @Int_Uno
			group by soft.Eft_TipCue

		drop table #EstadoFinanciero, #TmpCuentas
	end
end
