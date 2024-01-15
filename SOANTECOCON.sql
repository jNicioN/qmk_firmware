create procedure SOANTECOCON (
   @Atc_Numero int,
   @Atc_AnaTer int,
   @Atc_BieInm int,
   @Tip_Consul char(2),
   
   @NumTransac	char(10),
   @Transaccio	char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino	char(3),
   @Modulo char(2)) 
 as

/*********************************************************************
** DESCRIPCION: Consulta de registros de analitica terreno concepto	**
**********************************************************************
** Modifico:		Raul Muniz										**
** Fecha:			09/01/2024                               		**
** C.Cambios:		36743											**
** Descripcion:		Ajuste en consulta L3 para regresar tipo de		**
**					cuenta del estado financiero					**
**********************************************************************
** Modifico:		Raul Muniz										**
** Fecha:			21/04/2023                               		**
** C.Cambios:		26559											**
** Descripcion:		Ajuste en consulta L3 para validar si bien está	**
**					relacionado a estado financiero dentro de los	**
**					ultimos 3 activos								**
**********************************************************************
** Modifico:		Raul Muniz										**
** Fecha:			10/11/2022                               		**
** Help:			1643668		 					 				**
** C.Cambios:		20119											**
** Descripcion:		Se agrega parametro @Atc_BieInm y consulta L3	**
**********************************************************************
** Creo:			Felipe Castillo Rendon                    	  	**
** Fecha:			22/08/2017                               	  	**
** Help:			929417 					 					  	**
*********************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),		/* Variable de tipo de consulta o lista */
        @Tip_ConCon char(1), 		/* Variable numero de la consulta o lista */
        @Str_C char(1), 			/* Variable de tipo cadena con valor C */
        @Str_Uno char(1), 			/* Variable entera con valor 1 */
        @Str_Dos char(1),			/* Variable entera con valor 2 */
        @Str_Tres char(1),			/* Variable entera con valor 3 */
        @Ent_Activo smallint,		/* Variable entera activa */
        @Ent_Cero	smallint,		/* Entero Cero */
        @Ent_Uno	smallint		/* Entero Uno */

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1), 
       @Str_C = 'C',
       @Str_Uno = '1',
       @Str_Dos = '2',
       @Str_Tres = '3',
       @Ent_Activo = 1,
       @Ent_Cero = 0,
       @Ent_Uno	= 1

if @Tip_ConTip	= @Str_C begin /* Consulta */
   if @Tip_ConCon = @Str_Uno begin		/* C1 Consulta por numero y analitica activa */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
			from SOANTECO noholdlock 
			where Atc_Numero = @Atc_Numero
			and Atc_EstAna = @Ent_Activo
   end
end else begin
   if @Tip_ConCon = @Str_Uno begin		/* L1 Lista de todos los conceptos activos */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
			from SOANTECO noholdlock
			where Atc_EstAna = @Ent_Activo
   end
   if @Tip_ConCon = @Str_Dos begin		/* L2 Lista de todos los conceptos activos por analitica */
		select 	Atc_Numero,		Atc_AnaTer,		Atc_BieInm,		Atc_EstAna, 
				NumTransac,		Transaccio,		Usuario,		FechaSis, 
				SucOrigen,		SucDestino 
			from SOANTECO noholdlock
			where Atc_AnaTer = @Atc_AnaTer
				and Atc_EstAna = @Ent_Activo
   end
   if @Tip_ConCon = @Str_Tres begin		/* L3 Lista de todos los conceptos activos por bien inmueble */
		select 	Esf_PerNum
			into #BienPersonas
			from SOANTECO noholdlock
			inner join SOANATER noholdlock
				on Atc_AnaTer = Ant_Numero
			inner join SOESFITI noholdlock
				on Ant_EFTiCu = Eft_Numero
			inner join SOESTFIN noholdlock
				on Eft_EstFin = Esf_Numero
			where Atc_BieInm = @Atc_BieInm
				and Atc_EstAna = @Ent_Activo
			
		select	efn.Esf_Numero,	efn.Esf_Anio,	efn.Esf_PerNum,	efn.Esf_Solici,
				Esf_Rango = convert(int, Esf_MesFin) - convert(int, Esf_MesIni) + @Ent_Uno,
				Esf_Mayor = @Ent_Cero
			into #ListadoRangos
			from SOESTFIN efn noholdlock
			inner join #BienPersonas per
				on per.Esf_PerNum = efn.Esf_PerNum
			where efn.Esf_Status = @Ent_Activo
		
		select Esf_PerNum,  Esf_Solici, Esf_Anio,	max(Esf_Rango) as Esf_RaMax
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
			
		select	TOP 3
				efn.Esf_Numero,	efn.Esf_Anio,	efn.Esf_PerNum,	efn.Esf_Solici
			into #UltimosTres
			from #ListadoRangos efn
			order by efn.Esf_Anio desc
   
		select 	atc.Atc_Numero,	atc.Atc_AnaTer,	atc.Atc_BieInm,	atc.Atc_EstAna,
				Eft_EstFin,		Eft_TipCue,		atc.NumTransac,	atc.Transaccio,
				atc.Usuario,	atc.FechaSis,	atc.SucOrigen,	atc.SucDestino 
			from SOANTECO atc noholdlock
			inner join SOANATER noholdlock
				on Atc_AnaTer = Ant_Numero
			inner join SOESFITI noholdlock
				on Ant_EFTiCu = Eft_Numero
			inner join #UltimosTres
				on Eft_EstFin = Esf_Numero
			where Atc_BieInm = @Atc_BieInm
				and Atc_EstAna = @Ent_Activo
			
		drop table #BienPersonas, #ListadoRangos, #ListadoMaximos, #UltimosTres
   end
end