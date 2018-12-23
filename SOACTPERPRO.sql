create procedure SOACTPERPRO 
as


/**************************************************************************/
/* DESCRIPCION:		Proceso Actualización Personas						***/
/**************************************************************************/
/* REFERENCIAS:															***/
/***************************************************************************
** Modifico:		William Ramos Navarro  								****
** Fecha:			22/Enero/2016										****
** Help:		    00813627											****
** Descrip:			Ajustes en actualizaciones							****
***************************************************************************/
/***************************************************************************
** Creo:			Ma. Dolores Hdz.     								****
** Fecha:			24/Mar/15											****
** Help:		    00751891											****
** Descrip:			Proceso Actualizacion Personas						****
***************************************************************************/


/* Declaración de Variables	*/
declare	@NumTransac	varchar(10),
		@Status		int,
		@Fec_Busque	smalldatetime,	   
		@Map_FecIni	smalldatetime,
		@Map_FecFin	smalldatetime,
		@Map_TotAct int

/* Declaración de Constantes*/
declare	@Str_Vacio	char(1),
		@Transaccio	char(3),
		@Ent_Cero	int,	
		@Ent_Uno	int,	
		@Sucursal	char(3),
		@Usuario	char(6),
		@Str_No		char(1),	
		@Str_Si		char(1),
		@Sta_Activo	char(1)		
		
select	@Str_Vacio	= '',		
		@Ent_Cero 	= 0,
		@Ent_Uno	= 1,
		@Transaccio = 'CAL',
		@Sucursal	= '057',
		@Usuario	= '000000',
		@Str_No		= 'N',
		@Str_Si		= 'S',
		@Sta_Activo	= 'A'	


select	@NumTransac	= convert(varchar(8), getdate(), 112) + '00',
		@Map_FecIni = getdate()

select	@Fec_Busque	= max(Map_Fecha)
	from SOMOACPE noholdlock
			
select	@Fec_Busque	= DATEADD(day, -@Ent_Uno, @Fec_Busque)


--OBTENEMOS LA LISTA DE PERSONAS (SOLO LOS QUE SE ENCUENTREN EN BITACORA)
select 	distinct 
		Spe.PerPersoID,	Spe.Per_Numero,	Spe.Per_Fecha,	Spe.Per_NumTra,	Spe.Per_Tipo,
		Spe.Per_Benefi,	Spe.Per_NuSeFi,	Spe.Per_Titulo,	Spe.Per_Nombre,	Spe.Per_ApePat,
		Spe.Per_ApeMat,	Spe.Per_RazSoc,	Spe.Per_Comple,	Spe.Per_ComOrd,	Spe.Per_RFC,	
		Spe.Per_CURP,	Spe.Per_Calle,	Spe.Per_CalNum,	Spe.Per_Coloni,	Spe.Per_Entida,
		Spe.Per_Locali,	Spe.Per_CodPos,	Spe.Per_ApaPos,	Spe.Per_LadTel,	Spe.Per_Telefo,
		Spe.Per_Email,	Spe.Per_ComDom,	Spe.Per_EstCiv,	Spe.Per_Nacion,	Spe.Per_ActEmp,
		Spe.Per_Giro,	Spe.Per_Sector,	Spe.Per_Activi,	Spe.Per_ActINE,	Spe.NumTransac,
		Spe.Transaccio,	Spe.Usuario,	Spe.FechaSis,	Spe.SucOrigen,	Spe.SucDestino
	into #Personas
	from SOPERSON Spe noholdlock,
		 SOBITPER Sbp noholdlock 	
	where	Sbp.Bit_NumPer	= Spe.Per_Numero
	  and	Spe.FechaSis	>= @Fec_Busque

--INSERTAMOS SOLO LOS QUE SE REQUIERAN MODIFICAR	   
select	Per_Numero,	Per_Fecha,	Per_NumTra,	Per_Tipo,	Per_Titulo,   
		Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,   
		Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,	
		Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,  
		Per_LadTel,	Per_Telefo,	Per_Nacion,	Per_ActEmp,	Per_Sector,	
		Per_Activi,	Per_ActINE,	
		@Str_No	as	Per_Estatu,		
		@Str_No	as	Per_ModCal,			
		@Str_No	as	Per_ModCol,			
		@Str_No	as	Per_ModLoc,	
		@Str_No	as	Per_ModCod,	
		@Str_No	as	Per_ModLad,			
		@Str_No	as	Per_ModNac,	
		@Str_No	as	Per_MoAcEm,	
		@Str_No	as	Per_ModSec,	
		@Str_No	as	Per_ModAct,	
		@Str_No	as	Per_ModINE,	
		NumTransac,	Transaccio,	Usuario,	FechaSis,	SucOrigen,	
		SucDestino	
	into #DatosObl
	from #Personas
	where	isnull(Per_Calle,@Str_Vacio)	= @Str_Vacio 
	   or	( isnull(Per_CalNum,@Str_Vacio)	= @Str_Vacio )
	   or	( isnull(Per_Coloni,@Str_Vacio) = @Str_Vacio )
	   or	( isnull(Per_Entida,@Str_Vacio) = @Str_Vacio )
	   or	( isnull(Per_Locali,@Str_Vacio) = @Str_Vacio )
	   or	( isnull(Per_CodPos,@Str_Vacio) = @Str_Vacio )	   
	   or	( isnull(Per_LadTel,@Str_Vacio) = @Str_Vacio 
			  and isnull(Per_Telefo,@Str_Vacio)	<> @Str_Vacio)
	   or	( isnull(Per_Nacion,@Str_Vacio)	= @Str_Vacio)
	   or	( isnull(Per_ActEmp,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_Sector,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_Activi,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_ActINE,@Str_Vacio) = @Str_Vacio)
	   
	
--OBTENEMOS LA BITACORA (SOLO DE LAS PERSONAS QUE SE ENCUENTREN EN BITACORA)
select 	Sbp.Bit_NumPer,	Sbp.Bit_Fecha, 	Sbp.Bit_NumTra,	Sbp.Bit_Calle,	Sbp.Bit_CalNum,	
		Sbp.Bit_Coloni,	Sbp.Bit_Entida,	Sbp.Bit_Locali,	Sbp.Bit_CodPos,	Sbp.Bit_LadTel,	
		Sbp.Bit_Telefo,	Sbp.Bit_Nacion,	Sbp.Bit_ActEmp,	Sbp.Bit_Sector,	Sbp.Bit_Activi,	
		Sbp.Bit_ActINE,	Sbp.NumTransac,	Sbp.Transaccio,	Sbp.Usuario,	Sbp.FechaSis,	
		Sbp.SucOrigen,	Sbp.SucDestino
	into #Bitacora
	from #DatosObl Obl
	inner join SOBITPER Sbp noholdlock on Sbp.Bit_NumPer = Obl.Per_Numero	
	

--ACTUALIZACIONES
--Calle y Número
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasCalle
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Calle,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Calle,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer 
					
update #DatosObl set
	Per_Calle	= Bit_Calle,
	Per_CalNum	= Bit_CalNum,  
	Per_Estatu 	= @Str_Si,
	Per_ModCal	= @Str_Si 	
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasCalle 
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer and Fecha	= Bit_Fecha	
	  and 	isnull(Per_Calle,@Str_Vacio)	= @Str_Vacio 	
	  and 	rtrim(ltrim(isnull(Bit_Calle,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))

	  
--Colonia
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasColoni
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Coloni,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Coloni,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer
					
update #DatosObl set
	Per_Coloni	= Bit_Coloni,	 
	Per_Estatu	= @Str_Si,
	Per_ModCol	= @Str_Si	
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasColoni 
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and 	isnull(Per_Coloni,@Str_Vacio)	= @Str_Vacio 	
	  and 	rtrim(ltrim(isnull(Bit_Coloni,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))	


--Localidad, Entidad
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasLocali
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Locali,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Locali,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer
					
update #DatosObl set
	Per_Locali	= Est.Loc_Numero,	 
	Per_Entida	= Est.Loc_Entida,	 
	Per_Estatu	= @Str_Si, 
	Per_ModLoc	= @Str_Si	
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasLocali,
	     CLLOCALI Loc noholdlock,
		 CLLOCALI Est noholdlock
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and	Loc.Loc_Numero	= Bit_Locali
	  and	Est.Loc_Nombre	= Loc.Loc_Nombre 
	  and 	Est.Loc_Status	= @Sta_Activo 
	  and 	isnull(Per_Locali,@Str_Vacio)	= @Str_Vacio 	
	  and 	rtrim(ltrim(isnull(Bit_Locali,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))	  
	 

--Codigo Postal
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasCodigo
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_CodPos,@Str_Vacio) = @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_CodPos,@Str_Vacio))) <> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer

update #DatosObl set
	Per_CodPos	= Bit_CodPos,	 	
	Per_Estatu	= @Str_Si, 
	Per_ModCod	= @Str_Si
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasCodigo	    
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha		  
	  and 	isnull(Per_CodPos,@Str_Vacio)	= @Str_Vacio 	
	  and	rtrim(ltrim(isnull(Bit_CodPos,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))  
	  


--Lada de Telefono
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasLada
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	( isnull(Per_LadTel,@Str_Vacio) = @Str_Vacio and isnull(Per_Telefo,@Str_Vacio) <> @Str_Vacio)
	  and	rtrim(ltrim(isnull(Bit_LadTel,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer

update #DatosObl set
	Per_LadTel	= Bit_LadTel,	 	
	Per_Estatu	= @Str_Si, 
	Per_ModLad	= @Str_Si
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasCodigo	    
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha		  
	  and 	isnull(Per_LadTel,@Str_Vacio)	= @Str_Vacio 
	  and 	isnull(Per_Telefo,@Str_Vacio)	<> @Str_Vacio
	  and 	rtrim(ltrim(isnull(Bit_LadTel,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	  and 	rtrim(ltrim(isnull(Bit_Telefo,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	  and 	rtrim(ltrim(isnull(Bit_Telefo,@Str_Vacio)))	not like '%@%'
	  and 	patindex ('[0-9]%', Bit_Telefo)	> @Ent_Cero
	  

--Nacion
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasNacion
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Nacion,@Str_Vacio)	= @Str_Vacio
	  and	rtrim(ltrim(isnull(Bit_Nacion,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer

update #DatosObl set
	Per_Nacion	= Bit_Nacion,	 	
	Per_Estatu	= @Str_Si,
	Per_ModNac	= @Str_Si 	
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasNacion,
	     SOPAIS noholdlock   
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and	Pai_Numero = Bit_Nacion	  
	  and 	isnull(Per_Nacion,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Nacion,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))



--Sector
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasSector
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Sector,@Str_Vacio) = @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Sector,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer 
	  
update #DatosObl set
	Per_Sector	= Bit_Sector,	 	
	Per_Estatu	= @Str_Si,
	Per_ModSec	= @Str_Si 	
	from #DatosObl  noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasSector,
	     CLSECTOR 
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and 	Sec_Numero = Bit_Sector	   
	  and	isnull(Per_Sector,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Sector,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	 


--Actividad Empresarial
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasActividadEmpresarial
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_ActEmp,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_ActEmp,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer

update #DatosObl set
	Per_ActEmp	= Bit_ActEmp,	 	
	Per_Estatu	= @Str_Si,
	Per_MoAcEm	= @Str_Si	
	from #DatosObl noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasActividadEmpresarial	    
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and	isnull(Per_ActEmp,@Str_Vacio)	= @Str_Vacio 
	  and 	rtrim(ltrim(isnull(Bit_ActEmp,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))   


--Per_Activi
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasActividad
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_Activi,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Activi,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer 
	  
update #DatosObl set
	Per_Activi	= Bit_Activi,	 	
	Per_Estatu	= @Str_Si,
	Per_ModAct	= @Str_Si		
	from #DatosObl noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasActividad,
	     CLACTIVI 
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and	Act_Numero = Bit_Activi
	  and	isnull(Per_Activi,@Str_Vacio) = @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_Activi,@Str_Vacio))) <> rtrim(ltrim(@Str_Vacio))



--Per_ActINE
select	Bit_NumPer as Numero, 
		Max(Bit_Fecha) as Fecha
	into #FechasActividadINE
	from #DatosObl noholdlock
	inner join #Bitacora noholdlock on Bit_NumPer = Per_Numero
	where	isnull(Per_ActINE,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_ActINE,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))
	group by Bit_NumPer
	  
update #DatosObl set
	Per_ActINE	= Bit_ActINE,	 	
	Per_Estatu	= @Str_Si,
	Per_ModINE	= @Str_Si	
	from #DatosObl noholdlock, 
	     #Bitacora  noholdlock,
	     #FechasActividadINE,
	     CLACTINE noholdlock
	where	Bit_NumPer	= Per_Numero
	  and	Numero	= Bit_NumPer 
	  and	Fecha	= Bit_Fecha	
	  and	Act_Numero = Bit_ActINE
	  and	isnull(Per_ActINE,@Str_Vacio)	= @Str_Vacio 
	  and	rtrim(ltrim(isnull(Bit_ActINE,@Str_Vacio)))	<> rtrim(ltrim(@Str_Vacio))


select	@Map_TotAct	= count(Per_Numero)
	from #DatosObl
	where	Per_Estatu	= @Str_Si	
	
		  
--INSERTAR EN BITACORA LOS MODIFICADOS
insert into SOBITPER
select	Per.Per_Numero,	Per.Per_Fecha,	Per.Per_NumTra,	Per.Per_Tipo,	Per.Per_NuSeFi,	
		Per.Per_Titulo,	Per.Per_Nombre,	Per.Per_ApePat,	Per.Per_ApeMat, Per.Per_RazSoc,			
		Per.Per_Comple,	Per.Per_ComOrd,	Per.Per_RFC,	Per.Per_CURP,   Per.Per_Calle,	
		Per.Per_CalNum,	Per.Per_Coloni,	Per.Per_Entida,	Per.Per_Locali, Per.Per_CodPos,	
		Per.Per_ApaPos,	Per.Per_LadTel,	Per.Per_Telefo, Per.Per_Email,  Per.Per_ComDom, 
		Per.Per_EstCiv, Per.Per_Nacion, Per.Per_ActEmp, Per.Per_Giro,   Per.Per_Sector, 
		Per.Per_Activi,	Per.Per_ActINE, Per.NumTransac,	Per.Transaccio,	Per.Usuario,    
		Per.FechaSis,	Per.SucOrigen,  Per.SucDestino
   	from #DatosObl Obl noholdlock,
	     #Personas Per noholdlock
	where	Per.Per_Numero	= Obl.Per_Numero
	  and	Obl.Per_Estatu	= @Str_Si	


--ACTUALIZAMOS EN SOPERSON  
update SOPERSON set
	Per_Calle	= case when Per_ModCal = @Str_Si then Obl.Per_Calle else Per.Per_Calle end, 	
	Per_CalNum	= case when Per_ModCal = @Str_Si then Obl.Per_CalNum else Per.Per_CalNum end,
	Per_Coloni	= case when Per_ModCol = @Str_Si then Obl.Per_Coloni else Per.Per_Coloni end, 
	Per_Entida	= case when Per_ModLoc = @Str_Si then Obl.Per_Entida else Per.Per_Entida end,
	Per_Locali	= case when Per_ModLoc = @Str_Si then Obl.Per_Locali else Per.Per_Locali end,
	Per_CodPos	= case when Per_ModCod = @Str_Si then Obl.Per_CodPos else Per.Per_CodPos end,
	Per_LadTel	= case when Per_ModLad = @Str_Si then Obl.Per_LadTel else Per.Per_LadTel end,
	Per_Nacion	= case when Per_ModNac = @Str_Si then Obl.Per_Nacion else Per.Per_Nacion end,
	Per_ActEmp	= case when Per_MoAcEm = @Str_Si then Obl.Per_ActEmp else Per.Per_ActEmp end,
	Per_Sector	= case when Per_ModSec = @Str_Si then Obl.Per_Sector else Per.Per_Sector end,
	Per_Activi	= case when Per_ModAct = @Str_Si then Obl.Per_Activi else Per.Per_Activi end,
	Per_ActINE  = case when Per_ModINE = @Str_Si then Obl.Per_ActINE else Per.Per_ActINE end,	
	NumTransac	= @NumTransac, 		
	Transaccio	= @Transaccio,	
	Usuario		= Obl.Usuario,
	FechaSis	= Obl.FechaSis,	
	SucOrigen	= Obl.SucOrigen,	
	SucDestino	= Obl.SucDestino	
	from SOPERSON Per,
	     #DatosObl Obl	  
	where	Obl.Per_Numero	= Per.Per_Numero	  
	 
	  
select	@Map_FecFin = getdate(),
		@Map_TotAct = isnull(@Map_TotAct, @Ent_Cero)
		

exec @Status = SOMOACPEALT	
	@Map_FecIni,	@Map_FecIni,	@Map_FecFin,	@Map_TotAct,	@NumTransac,	
	@Transaccio,	@Usuario,		@Map_FecFin,	@Sucursal,		@Sucursal
if @Status <> @Ent_Cero begin		
	rollback
	return 1
end	
	
drop table #Personas
drop table #Bitacora
drop table #DatosObl
drop table #FechasCalle
drop table #FechasColoni
drop table #FechasLocali
drop table #FechasCodigo
drop table #FechasLada
drop table #FechasNacion
drop table #FechasSector
drop table #FechasActividadEmpresarial
drop table #FechasActividad
drop table #FechasActividadINE
