create procedure SOESTFINCON (
   @Esf_Numero int,
   @Esf_PerNum int, 
   @Esf_Solici int,
   @Tic_ClEsFi int,
   @Esf_Filtro varchar(100),
   @Esf_MesIni int,
   @Esf_MesFin int,
   @Esf_EfiNum int output,
   @Tip_Consul char(2),
   
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as

/*******************************************************************
** DESCRIPCION: Consulta de registros de estados financieros      **
********************************************************************
** Modifica:		Edwin Santiago 				                  **
** Fecha:			27/11/2018                               	  **
** Descripcion:		Se puede filtrar por numero de persona        **
** 					validando si es de tipo estado financiero 	  **
**					y regulada L6,Se agrega consulta C7 Y C8	  **
** Help: 			1074432		 					 			   **
********************************************************************
** Modifica:		Edwin Santiago                     	          **
** Fecha:			21/09/2018                               	  **
** Descripcion:		Modificacion a L2 para traer solo 3 estados   **
**					Financieros									  **
** Help:			1156952 					 				  **
********************************************************************
** Modifica:		Edwin Santiago                     	          **
** Fecha:			09/05/2018                               	  **
** Descripcion:		Modificacion a L2 para traer el 4 estado	  **
**					Financiero									  **
** Help:			1113042 					 				  **
********************************************************************
** Modifica:		Victor Manuel Osorio                     	  **
** Fecha:			07/03/2018                               	  **
** Descripcion:		Modificacion a L2 para respetar el filtro de  **
**					Estados Financieros dados @Esf_Filtro		  **
** Help:			929417 					 					  **
********************************************************************
** Modifica:		Felipe Castillo Rendon                     	  **
** Fecha:			29/12/2017                               	  **
** Descripcion:		Se puede filtrar sin numero de solicitud en L2**
** Help:		929417 					 						  **
********************************************************************
** Modifica:		José Eduardo Sánchez Méndez                   **
** Fecha:			25/07/2018                               	  **
** Descripcion:		Se puede filtrar por numero de persona        **
** validando si es de tipo estado financiero y regulada L6        **
** Help: 1074432		 					 			     	  **
********************************************************************
** Creo:		Felipe Castillo Rendon                     		  **
** Fecha:		19/05/2017                               		  **
** Help:		929417 					 						  **
*******************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1), 
        @Str_B char(1), 
        @Str_C char(1), 
        @Str_Uno char(1), 
        @Str_Dos char(1),
        @Str_Tres char(1),
		@Str_Cuatro char(1),
		@Str_Cinco char(1),
		@Str_Seis char(1),
        @Str_Siete char(1),
        @Str_Ocho char(1),
        @Ent_Uno int,
        @Ent_Dos int,
        @Ent_Tres int,
        @Ent_Cuatro int,
        @Ent_Solici int,
        @Ent_Ocho   int,
        @Ent_TipF int,
		@EsfNum int,
		@Ent_MesFin int,
		@Ent_InsReg char(1),
		@Ent_InsEntFin char(1),
        @Ent_PerTipo char(1),
        @Str_S char(1),
        @Str_N char(1)	,
        @Str_C2 char(2),	
        @Str_C7 char(2),	
        @Ef_Anterior  int,
        @Ef_AnParcial  int,
        @Ef_RangoAC    int,
        @Ef_RangoAN    int,     
        @Str_Filtro varchar(100),	
		@Ent_Posici numeric(20),
		@Str_EstFin varchar(50),
		@Ent_Cero int,
		@Str_Vacio varchar(2),
		@Str_Coma varchar(2),
		@Ent_Anio int,
		@Ent_Mes int,
		@Ent_TipEFF int,
		@Ent_ValInp float,
		@Str_PerNum varchar(8),
		@Status	int           /*Estatus*/
        

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),	/* Tipo de consulta */
       @Tip_ConCon = substring(@Tip_Consul, 2, 1),  /* Numero de consulta */
       @Str_B = 'B',								/* String B */
       @Str_C = 'C',								/* String C */
       @Str_Uno = '1',								/* String 1 */
       @Str_Dos = '2',								/* String 2 */
       @Str_Tres = '3',								/* String 3 */
	   @Str_Cuatro = '4',							/* String 4 */
	   @Str_Cinco = '5',							/* String 5 */
	   @Str_Seis = '6',								/* String 6 */
       @Str_Siete = '7',							/* String 7 */
       @Str_Ocho  = '8',							/* String 8 */
       @Ent_Uno = 1,								/* Entero 1 */
       @Ent_Dos = 2,								/* Entero 2 */
       @Ent_Tres = 3,								/* Entero 3 */
       @Ent_Cuatro = 4,								/* Entero 4 */
       @Ent_Ocho = 8,								/* Entero 8 */
       @Ent_Solici = 0,								/* Entero 0	*/
	   @Ent_TipF=518,                               /* Tipo Entidad Financiera*/
	   @Ent_MesFin=12,								/* Mes Doce*/
	   @Str_S='S',									/* String S*/
	   @Str_N='N',									/* String N*/
	   @Str_C2='C2',                                 /* Tipo Consulta C2*/
	   @Str_C7='C7',                                 /* Tipo Consulta C7*/
	   @Ef_Anterior=0,	                             /* Estado Financiero Anterior*/
	   @Ef_AnParcial=0,								/* Estado Financiero Anterior Parcial*/
	   @Ef_RangoAN=0,    							/* Perido de tiempo del estado financiero anterior*/
	   @Ef_RangoAC=0								/* Perido de tiempo del estado financiero Actual*/
	   

SET @Str_Filtro = @Esf_Filtro,	/* String filtro */
		@Ent_Cero = 0,			/* Entero 0	*/
		@Str_Vacio = '',		/* String vacio */
		@Str_Coma = ','			/* String coma	*/
		
if @Esf_Solici > @Ent_Cero begin 
	select @Ent_Solici = @Esf_Solici
end

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 */
     select 
          soef.Esf_Numero,	soef.Esf_TipFor,		soef.Esf_Anio,		soef.Esf_MesIni,		soef.Esf_MesFin,
          soef.Esf_TiEsFi,	soef.Esf_ExpCif,		soef.Esf_Moneda,	soef.Esf_PerNum,		soef.Esf_Solici,
		  soef.Esf_EsEsFi,	soef.Esf_ValInp,		soef.Esf_AplIca,	soef.Esf_Icap,			soef.Esf_CapNet,
		  soef.Esf_AcSuRi,	soef.Esf_TipSol,		soef.Esf_TipLiq,	soef.Esf_TipEfi,		soef.Esf_UsuCre,
		  soef.Esf_FecCre,	soef.Esf_UsuMod,		soef.Esf_FecMod,	soef.NumTransac,		soef.Transaccio,
		  soef.Usuario,		soef.FechaSis,			soef.SucOrigen,		soef.SucDestino,		souc.Usu_Nombre as Esf_UsCrNo,
		  soum.Usu_Nombre as Esf_UsCrMo
     from SOESTFIN soef noholdlock
     left join SOUSUARI souc noholdlock on souc.Usu_Numero = Esf_UsuCre
     left join SOUSUARI soum noholdlock on soum.Usu_Numero = Esf_UsuMod
     where Esf_Numero = @Esf_Numero
     and Esf_Status = @Ent_Uno

     end else if @Tip_ConCon = @Str_Dos begin		/* C2*/
	 
	 select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin
		into #TemporalFrecuencia
		from SOESTFIN efi noholdlock
		where Esf_Numero = @Esf_Numero
	
	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,    
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno, 
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,    	
		  efn.SucOrigen,     efn.SucDestino 
	 into #TemporalRango
		 from SOESTFIN efn noholdlock
		 where efn.Esf_PerNum = @Esf_PerNum
			and efn.Esf_Solici = @Esf_Solici
			and Esf_Status = @Ent_Uno
			and efn.Esf_Anio = (select (#TemporalFrecuencia.Esf_Anio)-@Ent_Uno from #TemporalFrecuencia where Esf_Numero = @Esf_Numero)
		 order by efn.Esf_Anio desc
	 
	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
		into #TemporalMaximo
		from #TemporalRango
		group by Esf_PerNum, Esf_Solici, Esf_Anio
	
	update #TemporalRango set
	Esf_Mayor	= @Ent_Uno
	from #TemporalMaximo efm
	where	efm.Esf_PerNum	= #TemporalRango.Esf_PerNum
	  and	efm.Esf_Solici	= #TemporalRango.Esf_Solici
	  and	efm.Esf_Anio	= #TemporalRango.Esf_Anio
	  and	Esf_RaMax		= #TemporalRango.Esf_Rango
	  
	delete #TemporalRango
	where Esf_Mayor	= @Ent_Cero
	
	select @Esf_EfiNum = efn.Esf_Numero
     from #TemporalRango efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
	 order by efn.Esf_Anio desc
	 
	 drop table #TemporalRango, #TemporalMaximo, #TemporalFrecuencia
	 
	 end else if @Tip_ConCon = @Str_Tres begin		/* C3*/
	 
	 select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin
				into #FormatoPeriodo
				from SOESTFIN efi noholdlock
				where Esf_Numero = @Esf_Numero

	select @Ent_Anio = (select (#FormatoPeriodo.Esf_Anio)-@Ent_Uno from #FormatoPeriodo where Esf_Numero = @Esf_Numero)

	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,    
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno, 
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,    	
		  efn.SucOrigen,     efn.SucDestino 
	 into #EstadoSolicitud
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and Esf_Status = @Ent_Uno
		and efn.Esf_Anio = @Ent_Anio
	 order by efn.Esf_Anio desc
	 
	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
	into #MaximoRango
	from #EstadoSolicitud
	group by Esf_PerNum, Esf_Solici, Esf_Anio
	
	update #EstadoSolicitud set
	Esf_Mayor	= @Ent_Uno
	from #MaximoRango efm
	where	efm.Esf_PerNum	= #EstadoSolicitud.Esf_PerNum
	  and	efm.Esf_Solici	= #EstadoSolicitud.Esf_Solici
	  and	efm.Esf_Anio	= #EstadoSolicitud.Esf_Anio
	  and	Esf_RaMax		= #EstadoSolicitud.Esf_Rango
	  
	delete #EstadoSolicitud
	where Esf_Mayor	= @Ent_Cero
	
	select @Esf_EfiNum = efn.Esf_Numero
     from #EstadoSolicitud efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
	 order by efn.Esf_Anio desc

	select @Ent_Mes = (select Esf_MesFin from SOESTFIN noholdlock where Esf_Numero = @Esf_EfiNum and Esf_Status = @Ent_Uno)
	select @Ent_ValInp = (select Ipc_Cantid from ACINPRCO noholdlock where Ipc_Anio = CONVERT(CHAR(4),@Ent_Anio) and Ipc_Mes = CONVERT(CHAR(2),@Ent_Mes))

	 select 
          Esf_Numero,    Esf_TipFor,    Esf_Anio, 	   Esf_MesIni,    Esf_MesFin, 
          Esf_TiEsFi,    Esf_ExpCif,    Esf_Moneda,    Esf_PerNum,    Esf_Solici, 
		  Esf_EsEsFi,    @Ent_ValInp AS Esf_ValInp,    Esf_AplIca,    Esf_Icap,      Esf_CapNet,    
		  Esf_AcSuRi,    Esf_TipSol,    Esf_TipLiq,    Esf_TipEfi,    NumTransac,   
		  Transaccio,    Usuario,    FechaSis,    SucOrigen,    SucDestino 
     from SOESTFIN noholdlock 
     where Esf_Numero = @Esf_EfiNum
     and Esf_Status = @Ent_Uno
	 
	 drop table #EstadoSolicitud, #MaximoRango, #FormatoPeriodo
	 
	 end else if @Tip_ConCon = @Str_Cuatro begin		/* C4*/
	 
		 select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin
				into #PeriodoFormato
				from SOESTFIN efi noholdlock
				where Esf_Numero = @Esf_Numero
	
	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,    
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno, 
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,    	
		  efn.SucOrigen,     efn.SucDestino 
	 into #PeriodoMayor
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and Esf_Status = @Ent_Uno
		and efn.Esf_Anio = (select (#PeriodoFormato.Esf_Anio)-@Ent_Uno from #PeriodoFormato where Esf_Numero = @Esf_Numero)
		and efn.Esf_MesIni = @Esf_MesIni
		and efn.Esf_MesFin = @Esf_MesFin 
	 order by efn.Esf_Anio desc
	 
	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
	into #RangoMaximo
	from #PeriodoMayor
	group by Esf_PerNum, Esf_Solici, Esf_Anio
	
	update #PeriodoMayor set
	Esf_Mayor	= @Ent_Uno
	from #RangoMaximo efm
	where	efm.Esf_PerNum	= #PeriodoMayor.Esf_PerNum
	  and	efm.Esf_Solici	= #PeriodoMayor.Esf_Solici
	  and	efm.Esf_Anio	= #PeriodoMayor.Esf_Anio
	  and	Esf_RaMax		= #PeriodoMayor.Esf_Rango
	  
	delete #PeriodoMayor
	where Esf_Mayor	= @Ent_Cero
	
	select @Esf_EfiNum = efn.Esf_Numero
     from #PeriodoMayor efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
	 order by efn.Esf_Anio desc

	 drop table #PeriodoMayor, #RangoMaximo, #PeriodoFormato

end else if @Tip_ConCon = @Str_Cinco begin		/* C5  Obtiene EEFF de anio anterior con mismo tipo de EEFF (dictaminado, interno, presupuestado) */
	select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin, Esf_TiEsFi
				into #EstadoFinanciero
				from SOESTFIN efi noholdlock
				where Esf_Numero = @Esf_Numero

	select @Ent_Anio = (select (#EstadoFinanciero.Esf_Anio)-@Ent_Uno from #EstadoFinanciero where Esf_Numero = @Esf_Numero)
	select @Ent_TipEFF = (select #EstadoFinanciero.Esf_TiEsFi from #EstadoFinanciero where Esf_Numero = @Esf_Numero)

	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin,
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno,
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,
		  efn.SucOrigen,     efn.SucDestino
	 into #EstadoAnterior
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and Esf_Status = @Ent_Uno
		and efn.Esf_Anio = @Ent_Anio
		and efn.Esf_TiEsFi = @Ent_TipEFF
	 order by efn.Esf_Anio desc
	 
	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
	into #EstadoAnteriorMaximo
	from #EstadoAnterior
	group by Esf_PerNum, Esf_Solici, Esf_Anio

	update #EstadoAnterior set
	Esf_Mayor	= @Ent_Uno
	from #EstadoAnteriorMaximo efm
	where	efm.Esf_PerNum	= #EstadoAnterior.Esf_PerNum
	  and	efm.Esf_Solici	= #EstadoAnterior.Esf_Solici
	  and	efm.Esf_Anio	= #EstadoAnterior.Esf_Anio
	  and	Esf_RaMax		= #EstadoAnterior.Esf_Rango

	delete #EstadoAnterior
	where Esf_Mayor	= @Ent_Cero

	select @Esf_EfiNum = efn.Esf_Numero
     from #EstadoAnterior efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
	 order by efn.Esf_Anio desc

	select @Ent_Mes = (select Esf_MesFin from SOESTFIN noholdlock where Esf_Numero = @Esf_EfiNum and Esf_Status = @Ent_Uno)
	select @Ent_ValInp = (select Ipc_Cantid from ACINPRCO noholdlock where Ipc_Anio = CONVERT(CHAR(4),@Ent_Anio) and Ipc_Mes = CONVERT(CHAR(2),@Ent_Mes))

	 select 
          Esf_Numero,    Esf_TipFor,    Esf_Anio, 	   Esf_MesIni,    Esf_MesFin, 
          Esf_TiEsFi,    Esf_ExpCif,    Esf_Moneda,    Esf_PerNum,    Esf_Solici, 
		  Esf_EsEsFi,    @Ent_ValInp AS Esf_ValInp,    Esf_AplIca,    Esf_Icap,      Esf_CapNet,    
		  Esf_AcSuRi,    Esf_TipSol,    Esf_TipLiq,    Esf_TipEfi,    NumTransac,   
		  Transaccio,    Usuario,    FechaSis,    SucOrigen,    SucDestino 
     from SOESTFIN noholdlock 
     where Esf_Numero = @Esf_EfiNum
     and Esf_Status = @Ent_Uno

	 drop table #EstadoAnterior, #EstadoAnteriorMaximo, #EstadoFinanciero

end else if @Tip_ConCon = @Str_Seis begin		/* C6 */
	select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin, Esf_TiEsFi
				into #EstadoGobierno
				from SOESTFIN efi noholdlock
				where Esf_Numero = @Esf_Numero

	select @Ent_Anio = (select (#EstadoGobierno.Esf_Anio)-@Ent_Uno from #EstadoGobierno where Esf_Numero = @Esf_Numero)
	select @Ent_TipEFF = (select #EstadoGobierno.Esf_TiEsFi from #EstadoGobierno where Esf_Numero = @Esf_Numero)

	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin,
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno,
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,
		  efn.SucOrigen,     efn.SucDestino
	 into #EstadoGobiernoAnterior
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and Esf_Status = @Ent_Uno
		and efn.Esf_Anio = @Ent_Anio
		and efn.Esf_TiEsFi = @Ent_TipEFF
	 order by efn.Esf_Anio desc
	 
	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
	into #GobiernoMaximo
	from #EstadoGobiernoAnterior
	group by Esf_PerNum, Esf_Solici, Esf_Anio

	update #EstadoGobiernoAnterior set
	Esf_Mayor	= @Ent_Uno
	from #GobiernoMaximo efm
	where	efm.Esf_PerNum	= #EstadoGobiernoAnterior.Esf_PerNum
	  and	efm.Esf_Solici	= #EstadoGobiernoAnterior.Esf_Solici
	  and	efm.Esf_Anio	= #EstadoGobiernoAnterior.Esf_Anio
	  and	Esf_RaMax		= #EstadoGobiernoAnterior.Esf_Rango

	delete #EstadoGobiernoAnterior
	where Esf_Mayor	= @Ent_Cero

	select @Esf_EfiNum = efn.Esf_Numero
     from #EstadoGobiernoAnterior efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
	 order by efn.Esf_Anio desc

	 drop table #EstadoGobiernoAnterior, #GobiernoMaximo, #EstadoGobierno
end else if @Tip_ConCon = @Str_Siete begin		/* C7*/  /*obtiene el estado financiero anterior con el mismo periodo de tiempo que el actual*/
	 
	 select Esf_Numero, Esf_TipFor, Esf_Anio, Esf_MesIni, Esf_MesFin,Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno
		into #AnioAnterior
		from SOESTFIN efi noholdlock
		where Esf_Numero = @Esf_Numero
		
	select
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,    
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno, 
		  Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,    	
		  efn.SucOrigen,     efn.SucDestino 
	 into #EfRangos
		 from SOESTFIN efn noholdlock
		 where efn.Esf_PerNum = @Esf_PerNum
			and efn.Esf_Solici = @Esf_Solici
			and Esf_Status = @Ent_Uno
			and efn.Esf_Anio = (select (#AnioAnterior.Esf_Anio)-@Ent_Uno from #AnioAnterior where Esf_Numero = @Esf_Numero)
		 order by efn.Esf_Anio desc
	 
	 
	select Esf_Numero,Esf_PerNum,  Esf_Solici, Esf_Anio,Esf_Rango
		into #EfSeleccionado
		from #EfRangos
		group by Esf_PerNum, Esf_Solici, Esf_Anio
	
	update #EfRangos set
	Esf_Mayor	= @Ent_Uno
	from #EfSeleccionado efm
	where	efm.Esf_PerNum	= #EfRangos.Esf_PerNum
	  and	efm.Esf_Solici	= #EfRangos.Esf_Solici
	  and	efm.Esf_Anio	= #EfRangos.Esf_Anio

	  
	delete #EfRangos
	where Esf_Mayor	= @Ent_Cero
	
	select @Esf_EfiNum = efn.Esf_Numero
     from #EfRangos efn
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and Esf_Rango= (select #AnioAnterior.Esf_Rango from #AnioAnterior where Esf_Numero = @Esf_Numero)
	 order by efn.Esf_Anio desc
	 
	 drop table #EfRangos, #EfSeleccionado, #AnioAnterior
	 
end else if @Tip_ConCon = @Str_Ocho begin	 /* C8*/  /*se obtiene el caso a evaluar para ROE*/
	 	 
	-- se evalua si existe un estado financiero anterior
	exec SOESTFINCON @Esf_Numero, @Esf_PerNum, @Ent_Cero, @Ent_Cero,@Str_Vacio, 
					 @Ent_Cero, @Ent_Cero, @Ef_Anterior output, @Str_C2, @NumTransac, 
					 @Transaccio, @Usuario,@FechaSis, @SucOrigen, @SucDestino, @Modulo
	
	select @Ef_RangoAC = (convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno) FROM SOESTFIN where  Esf_Numero =@Esf_Numero  -- margen de tiempo del EF Actual
	select @Ef_RangoAN = (convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno) FROM SOESTFIN where  Esf_Numero =@Ef_Anterior -- margen de tiempo del EF Anterior
	
	if (@Ef_Anterior <> @Ent_Cero) begin
		if(@Ef_RangoAC<>@Ent_MesFin) begin /*es parcial*/
			
			--se busca su estado financiero anterior parcial con el mismo margen de tiempo en balance general
			exec SOESTFINCON @Esf_Numero, @Esf_PerNum, @Ent_Cero, @Ent_Cero,@Str_Vacio, 
			                 @Ent_Cero, @Ent_Cero, @Ef_AnParcial output,@Str_C7, @NumTransac, 
			                 @Transaccio, @Usuario,@FechaSis, @SucOrigen, @SucDestino, @Modulo
			
			if(@Ef_AnParcial > @Ent_Cero and @Ef_RangoAN=@Ent_MesFin) begin /* 1 CIERRE  Y 2 PARCIALES CON MISMO PERIODO DE TIEMPO*/
				select @Ent_Cuatro as Esf_Caso
			end
			else begin
				select @Ent_Uno as Esf_Caso
			end
			
		end
		else begin
            if(@Ef_RangoAC=@Ent_MesFin and @Ef_RangoAN=@Ent_MesFin) begin  /*ES CIERRE Y EXISTE UN ESTADO FINANCIERO ANTERIOR QUE TAMBIEN ES CIERRE*/
				select @Ent_Dos as Esf_Caso
			end
			else begin /*NO EXISTE UN ESTADO FINANCIERO ANTERIOR Y ES CIERRE*/
				select @Ent_Tres as Esf_Caso
			end 
        end
	end
	else begin
		if(@Ef_RangoAC=@Ent_MesFin) begin /*NO EXISTE UN ESTADO FINANCIERO ANTERIOR Y ES CIERRE*/
			select @Ent_Tres as Esf_Caso
		end 
		else begin
			select @Ent_Uno as Esf_Caso
		end 
	end
	
end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 */
     select 
          Esf_Numero,    Esf_TipFor,    Esf_Anio,      Esf_MesIni,    Esf_MesFin, 
          Esf_TiEsFi,    Esf_ExpCif,    Esf_Moneda,    Esf_PerNum,    Esf_Solici,
		  Esf_EsEsFi,    Esf_ValInp,    Esf_AplIca,    Esf_Icap,      Esf_CapNet,    
		  Esf_AcSuRi,    Esf_TipSol,    Esf_TipLiq,    Esf_TipEfi,    NumTransac,    
		  Transaccio,    Usuario,    	FechaSis,      SucOrigen,     SucDestino 
     from SOESTFIN noholdlock   
     where Esf_Status = @Ent_Uno
   end else if @Tip_ConCon = @Str_Dos begin		/* L2 este debe traer los estados de los ultimos 3 anios, 1 estado financiero por anio*/
    
    create table #ListaEstados (Efi_Numero int)
	
	SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
	if (@Ent_Posici = @Ent_Cero and @Esf_Filtro <> @Str_Vacio) begin
			insert into #ListaEstados(Efi_Numero)
			values(convert(int, @Esf_Filtro))
	end
	while @Ent_Posici <> @Ent_Cero begin
		SET @Str_EstFin = LEFT(@Str_Filtro, @Ent_Posici-@Ent_Uno)
		SET @Str_Filtro = stuff(@Str_Filtro, @Ent_Uno, @Ent_Posici, NULL)
		SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
		
		if (@Ent_Posici = @Ent_Cero) begin
			insert into #ListaEstados(Efi_Numero)
			values(convert(int, @Str_Filtro))
		end
		
		insert into #ListaEstados(Efi_Numero)
		values(convert(int, @Str_EstFin))
	end

	select
		efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin,
		efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno,
		Esf_Mayor = @Ent_Cero,	Esf_Filtro = @Esf_Filtro, 				efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,
		efn.SucOrigen,     efn.SucDestino
	 into #ListadoRangos
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Ent_Solici
		and (efn.Esf_Numero IN (select efi.Efi_Numero from #ListaEstados efi) or @Esf_Filtro = @Str_Vacio)
		and Esf_Status = @Ent_Uno
	 order by efn.Esf_Anio desc

	select Esf_PerNum,  Esf_Solici, Esf_Anio,
			(CASE WHEN Esf_Filtro = @Str_Vacio THEN (max(Esf_Rango))
			ELSE Esf_Rango END) as Esf_RaMax
		into #ListadoMaximos
		from #ListadoRangos
		group by Esf_PerNum, Esf_Solici, Esf_Anio

	update #ListadoRangos set
		Esf_Mayor	= @Ent_Uno
		from #ListadoMaximos efm
		where	efm.Esf_PerNum	= #ListadoRangos.Esf_PerNum
		  and	efm.Esf_Solici	= #ListadoRangos.Esf_Solici
		  and	efm.Esf_Anio	= #ListadoRangos.Esf_Anio
		  and	Esf_RaMax		= #ListadoRangos.Esf_Rango

	delete #ListadoRangos
	where Esf_Mayor	= @Ent_Cero

	select TOP 3
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	efn.NumTransac,
		  efn.Transaccio,      		efn.Usuario,       efn.FechaSis,    	efn.SucOrigen,      efn.SucDestino
	 into #UltimosTres
     from #ListadoRangos efn 
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Ent_Solici
		and (efn.Esf_Numero IN (select efi.Efi_Numero from #ListaEstados efi) or @Esf_Filtro = @Str_Vacio)
	 order by efn.Esf_Anio desc

	 select Esf_Numero,    		Esf_TipFor,    Esf_Anio,    	Esf_MesIni,    	Esf_MesFin,
          Esf_TiEsFi,    		Esf_ExpCif,    Esf_Moneda,    	Esf_PerNum,    	Esf_Solici,
		  Esf_EsEsFi,    		Esf_ValInp,    Esf_AplIca,    	Esf_Icap,    	Esf_CapNet,
		  Esf_AcSuRi,    		Esf_TipSol,    Esf_TipLiq,    	Esf_TipEfi,    	NumTransac,
		  Transaccio,      		Usuario,       FechaSis,    	SucOrigen,      SucDestino
	from #UltimosTres efi
	order by Esf_Anio asc

	 drop table #ListaEstados, #ListadoRangos, #ListadoMaximos, #UltimosTres

   end else if @Tip_ConCon = @Str_Tres begin		/* L3 obtiene los estados financieros activos de la persona*/
		select
			Esf_Numero,    Esf_TipFor,    Esf_Anio,    Esf_MesIni,    Esf_MesFin,
			Esf_TiEsFi,    Esf_ExpCif,    Esf_Moneda,    Esf_PerNum,    Esf_Solici,
			Esf_EsEsFi,    Esf_ValInp,    Esf_AplIca,    Esf_Icap,    Esf_CapNet,
			Esf_AcSuRi,    Esf_TipSol,    Esf_TipLiq,    Esf_TipEfi,    NumTransac,
			Transaccio,    Usuario,    	FechaSis,    SucOrigen,    SucDestino
		from SOESTFIN noholdlock
		where Esf_PerNum = @Esf_PerNum
		  and Esf_Solici = @Esf_Solici
		  and Esf_Status = @Ent_Uno
		order by Esf_Anio desc
	end else if @Tip_ConCon = @Str_Cuatro begin		/* L4 obtiene todos los estados financieros de la persona*/
		select
			Esf_Numero,		Esf_TipFor,		Esf_Anio,		Esf_MesIni,		Esf_MesFin,
			Esf_TiEsFi,		Esf_ExpCif,		Esf_Moneda,		Esf_PerNum,		Esf_Solici,
			Esf_EsEsFi,		Esf_ValInp,		Esf_AplIca,		Esf_Icap,		Esf_CapNet,
			Esf_AcSuRi,		Esf_TipSol,		Esf_TipLiq,		Esf_TipEfi,		Esf_Status,
			NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
			SucDestino 
		from SOESTFIN noholdlock   
		where Esf_PerNum = @Esf_PerNum
		  and (Esf_Solici = @Esf_Solici or @Esf_Solici = @Ent_Cero)
		order by Esf_Anio desc
	end else if @Tip_ConCon = @Str_Cinco begin		/* L5 obtiene los Estados Financieros de Razones F. para formato Gobierno (2 Internos, 2 Presupuestados) */
		create table #ListadoRazones (Efi_Numero int)
	
	SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
	if (@Ent_Posici = @Ent_Cero and @Esf_Filtro <> @Str_Vacio) begin
			insert into #ListadoRazones(Efi_Numero)
			values(convert(int, @Esf_Filtro))
	end
	while @Ent_Posici <> @Ent_Cero begin
		SET @Str_EstFin = LEFT(@Str_Filtro, @Ent_Posici-@Ent_Uno)
		SET @Str_Filtro = stuff(@Str_Filtro, @Ent_Uno, @Ent_Posici, NULL)
		SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
		
		if (@Ent_Posici = @Ent_Cero) begin
			insert into #ListadoRazones(Efi_Numero)
			values(convert(int, @Str_Filtro))
		end
		
		insert into #ListadoRazones(Efi_Numero)
		values(convert(int, @Str_EstFin))
	end

	select
		efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin,
		efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno,
		Esf_Mayor = @Ent_Cero,	efn.NumTransac,	   efn.Transaccio,      efn.Usuario,    	efn.FechaSis,
		efn.SucOrigen,     efn.SucDestino
	 into #RazonesRangos
     from SOESTFIN efn noholdlock
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and (efn.Esf_Numero IN (select efi.Efi_Numero from #ListadoRazones efi) or @Esf_Filtro = @Str_Vacio)
		and Esf_Status = @Ent_Uno
	 order by efn.Esf_Anio desc

	select Esf_PerNum,  Esf_Solici, Esf_Anio, Esf_RaMax = max(Esf_Rango)
		into #RazonesMaximos
		from #RazonesRangos
		group by Esf_PerNum, Esf_Solici, Esf_Anio

	update #RazonesRangos set
		Esf_Mayor	= @Ent_Uno
		from #RazonesMaximos efm
		where	efm.Esf_PerNum	= #RazonesRangos.Esf_PerNum
		  and	efm.Esf_Solici	= #RazonesRangos.Esf_Solici
		  and	efm.Esf_Anio	= #RazonesRangos.Esf_Anio
		  and	Esf_RaMax		= #RazonesRangos.Esf_Rango

	delete #RazonesRangos
	where Esf_Mayor	= @Ent_Cero

	select TOP 4
          efn.Esf_Numero,    		efn.Esf_TipFor,    efn.Esf_Anio,    	efn.Esf_MesIni,    	efn.Esf_MesFin, 
          efn.Esf_TiEsFi,    		efn.Esf_ExpCif,    efn.Esf_Moneda,    	efn.Esf_PerNum,    	efn.Esf_Solici,
		  efn.Esf_EsEsFi,    		efn.Esf_ValInp,    efn.Esf_AplIca,    	efn.Esf_Icap,    	efn.Esf_CapNet,
		  efn.Esf_AcSuRi,    		efn.Esf_TipSol,    efn.Esf_TipLiq,    	efn.Esf_TipEfi,    	efn.NumTransac,
		  efn.Transaccio,      		efn.Usuario,       efn.FechaSis,    	efn.SucOrigen,      efn.SucDestino
	 into #RazonesUltimos
     from #RazonesRangos efn 
	 where efn.Esf_PerNum = @Esf_PerNum
		and efn.Esf_Solici = @Esf_Solici
		and (efn.Esf_Numero IN (select efi.Efi_Numero from #ListadoRazones efi) or @Esf_Filtro = @Str_Vacio)
	 order by efn.Esf_Anio desc

	 select Esf_Numero,    		Esf_TipFor,    Esf_Anio,    	Esf_MesIni,    	Esf_MesFin,
          Esf_TiEsFi,    		Esf_ExpCif,    Esf_Moneda,    	Esf_PerNum,    	Esf_Solici,
		  Esf_EsEsFi,    		Esf_ValInp,    Esf_AplIca,    	Esf_Icap,    	Esf_CapNet,
		  Esf_AcSuRi,    		Esf_TipSol,    Esf_TipLiq,    	Esf_TipEfi,    	NumTransac,
		  Transaccio,      		Usuario,       FechaSis,    	SucOrigen,      SucDestino
	from #RazonesUltimos efi
	order by Esf_Anio asc

	 drop table #ListadoRazones, #RazonesRangos, #RazonesMaximos, #RazonesUltimos
	end else if @Tip_ConCon = @Str_Seis begin /* L6 obtiene los Estados Financieros de tipo Entidad Financiera y que sean reguladas*/
		
		select	@Status		= @Ent_Cero
		select @Str_PerNum = convert(varchar(8), @Esf_PerNum)
		
		exec @Status = UTCERIZQ @Str_PerNum output, @Longitud	= @Ent_Ocho
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end

		select @Ent_PerTipo = Per_Tipo
		from SOPERSON noholdlock 
		where Per_Numero = @Str_PerNum
		
		if @Ent_PerTipo = @Str_Uno begin
            select
                @Ent_InsEntFin=Clp_EntFin, @Ent_InsReg=Clp_InsReg 
            from SOCLCAPE noholdlock   
            where Clp_NumPer = @Str_PerNum
        end 
        else begin
            set @Ent_InsEntFin=@Str_N,@Ent_InsReg=@Str_N
        end
	
		if @Ent_InsEntFin =@Str_S AND @Ent_InsReg=@Str_S	begin
	
			select
				top 1 Esf_Numero,    		Esf_TipFor,    Esf_Anio,    	Esf_MesIni,    	Esf_MesFin,
				Esf_TiEsFi,    		Esf_ExpCif,    Esf_Moneda,    	Esf_PerNum,    	Esf_Solici,
				Esf_EsEsFi,    		Esf_ValInp,    Esf_AplIca,    	Esf_Icap,    	Esf_CapNet,
				Esf_AcSuRi,    		Esf_TipSol,    Esf_TipLiq,    	Esf_TipEfi,    	NumTransac,
				Transaccio,      		Usuario,       FechaSis,    	SucOrigen,      SucDestino
			from SOESTFIN noholdlock   
			where Esf_PerNum = @Esf_PerNum
			and Esf_TipFor=@Ent_TipF
			order by Esf_Anio desc,Esf_MesFin desc
		end 
		else begin
			select
				top 1 Esf_Numero,    		Esf_TipFor,    Esf_Anio,    	Esf_MesIni,    	Esf_MesFin,
				Esf_TiEsFi,    		Esf_ExpCif,    Esf_Moneda,    	Esf_PerNum,    	Esf_Solici,
				Esf_EsEsFi,    		Esf_ValInp,    Esf_AplIca,    	Esf_Icap,    	Esf_CapNet,
				Esf_AcSuRi,    		Esf_TipSol,    Esf_TipLiq,    	Esf_TipEfi,    	NumTransac,
				Transaccio,      		Usuario,       FechaSis,    	SucOrigen,      SucDestino
			from SOESTFIN noholdlock   
			where Esf_PerNum = @Esf_PerNum
			and Esf_MesIni = @Ent_Uno
			and Esf_MesFin = @Ent_MesFin
			order by Esf_Anio desc,Esf_MesFin desc
        end
	end
end