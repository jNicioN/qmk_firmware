create procedure SOPRACPEPRO 
as
	
/**************************************************************************/
/* DESCRIPCION:		Proceso Primera Actualización Personas				***/
/**************************************************************************/
/* REFERENCIAS:															***/
/***************************************************************************
** Creó:			Ma. Dolores Hdz.     								****
** Fecha:			24/Mar/15											****
** Help:		    00751891											****
** Descrip:			Proceso Primera Actualización Personas				****
****************************************************************************/


/* Declaración de Variables	*/
declare	@NumTransac	varchar(10),
	    @Status		int,		
	    @Map_FecAct	smalldatetime,
		@Map_FecIni	smalldatetime,
		@Map_FecFin	smalldatetime,
		@Map_TotAct int

/* Declaración de Constantes*/
declare	@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Transaccio	char(3),
		@Sucursal	char(3),
		@Usuario	char(6),
		@Str_Si		char(1)		

/*Asignación de Constantes*/			
select	@Str_Vacio	= '',
		@Ent_Cero 	= 0,
		@Ent_Uno	= 1,
		@Transaccio = 'CAL',
		@Sucursal	= '057',
		@Usuario	= '000000',
		@Str_Si		= 'S'				


select	@NumTransac = convert(varchar(8), getdate(), 112) + '00',
		@Map_FecIni = getdate()


--1.OBTENEMOS LA LISTA DE PERSONAS QUE SE ENCUENTREN EN TEMPORAL SOTMPPER
select	Per.Per_Numero,	Per.Per_Fecha,	Per.Per_NumTra,	Per.Per_Calle, 	Per.Per_CalNum,
		Per.Per_Coloni, Per.Per_Entida,	Per.Per_Locali, Per.Per_CodPos, Per.Per_LadTel, 
		Per.Per_Telefo,	Per.Per_Nacion, Per.Per_ActEmp,	Per.Per_Sector, Per.Per_Activi, 
		Per.Per_ActINE, Per.FechaSis
	into #Lista
	from SOTMPPER Tmp noholdlock,
	     SOPERSON Per noholdlock
	WHERE	Per.Per_Numero	= Tmp.Per_Numero	
	  and	Per.Per_Fecha	= Tmp.Per_Fecha
	  and	Per.Per_NumTra	= Tmp.Per_NumTra
	  and 	Per.FechaSis	= Tmp.FechaSis
	  
--2. CONFIRMAMOS QUE LOS CAMPOS OBLIGATORIOS SE ENCUENTRES VACIOS Y SELECCIONAMOS LAS PERSONAS A MODIFICAR  
select	Per_Numero,	Per_Fecha,	Per_NumTra,	FechaSis
	into #Modificados
	from #Lista 
	where	isnull(Per_Calle,@Str_Vacio)	= @Str_Vacio
	   or	( isnull(Per_CalNum,@Str_Vacio)	= @Str_Vacio )
	   or	( isnull(Per_Coloni,@Str_Vacio)	= @Str_Vacio )
	   or	( isnull(Per_Entida,@Str_Vacio) = @Str_Vacio )
	   or	( isnull(Per_Locali,@Str_Vacio) = @Str_Vacio )
	   or	( isnull(Per_CodPos,@Str_Vacio) = @Str_Vacio )	   
	   or	( isnull(Per_LadTel,@Str_Vacio) = @Str_Vacio 
			   and	isnull(Per_Telefo,@Str_Vacio)	<> @Str_Vacio )
	   or	( isnull(Per_Nacion,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_ActEmp,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_Sector,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_Activi,@Str_Vacio) = @Str_Vacio)
	   or	( isnull(Per_ActINE,@Str_Vacio) = @Str_Vacio)	  

select	@Map_TotAct	= count(Per_Numero)
	from #Modificados

	
--3. INSERTAMOS EN BITACORA LOS QUE SERAN MODIFICADOS
insert into SOBITPER
select	Mod.Per_Numero,	Mod.Per_Fecha,	Mod.Per_NumTra,	Per_Tipo,		Per_NuSeFi,
		Per_Titulo,		Per_Nombre,		Per_ApePat,		Per_ApeMat,		Per_RazSoc,
		Per_Comple,		Per_ComOrd,		Per_RFC,		Per_CURP,		Per_Calle,	
		Per_CalNum,		Per_Coloni,		Per_Entida,		Per_Locali,		Per_CodPos,
		Per_ApaPos,		Per_LadTel,		Per_Telefo,		Per_Email,		Per_ComDom,
		Per_EstCiv,		Per_Nacion,		Per_ActEmp,		Per_Giro,		Per_Sector,
		Per_Activi,		Per_ActINE,		NumTransac,		Transaccio,		Usuario,
		Mod.FechaSis,	SucOrigen,	SucDestino
	from #Modificados Mod,		 
	     SOPERSON Per noholdlock
	where	Per.Per_Numero	= Mod.Per_Numero	  
	  and	Per.Per_Fecha	= Mod.Per_Fecha
	  and	Per.Per_NumTra	= Mod.Per_NumTra
	  and	Per.FechaSis	= Mod.FechaSis

--4. ACTUALIZAMOS EN SOPERSON  
update SOPERSON set
	Per_Calle	= case when Per_ModCal = @Str_Si then Tmp.Per_Calle else Per.Per_Calle end, 	
	Per_CalNum	= case when Per_ModCal = @Str_Si then Tmp.Per_CalNum else Per.Per_CalNum end,
	Per_Coloni	= case when Per_ModCol = @Str_Si then Tmp.Per_Coloni else Per.Per_Coloni end, 
	Per_Entida	= case when Per_ModLoc = @Str_Si then Tmp.Per_Entida else Per.Per_Entida end,
	Per_Locali	= case when Per_ModLoc = @Str_Si then Tmp.Per_Locali else Per.Per_Locali end,
	Per_CodPos	= case when Per_ModCod = @Str_Si then Tmp.Per_CodPos else Per.Per_CodPos end,
	Per_LadTel	= case when Per_ModLad = @Str_Si then Tmp.Per_LadTel else Per.Per_LadTel end,
	Per_Nacion	= case when Per_ModNac = @Str_Si then Tmp.Per_Nacion else Per.Per_Nacion end,
	Per_ActEmp	= case when Per_MoAcEm = @Str_Si then Tmp.Per_ActEmp else Per.Per_ActEmp end,
	Per_Sector	= case when Per_ModSec = @Str_Si then Tmp.Per_Sector else Per.Per_Sector end,
	Per_Activi	= case when Per_ModAct = @Str_Si then Tmp.Per_Activi else Per.Per_Activi end,
	Per_ActINE  = case when Per_ModINE = @Str_Si then Tmp.Per_ActINE else Per.Per_ActINE end,
	NumTransac	= @NumTransac, 		
	Transaccio	= @Transaccio,	
	Usuario		= Tmp.Usuario,
	FechaSis	= Tmp.FechaSis,	
	SucOrigen	= Tmp.SucOrigen,	
	SucDestino	= Tmp.SucDestino	
	from SOPERSON Per,
	     #Modificados Mod,
	     SOTMPPER Tmp	     		
	where	Mod.Per_Numero	= Per.Per_Numero	  
	  and	Mod.Per_Fecha	= Per.Per_Fecha
	  and	Mod.Per_NumTra	= Per.Per_NumTra
	  and	Mod.FechaSis	= Per.FechaSis	  	
	  and  	Tmp.Per_Numero	= Mod.Per_Numero	  
	  and	Tmp.Per_Fecha	= Mod.Per_Fecha
	  and	Tmp.Per_NumTra	= Mod.Per_NumTra
	  and	Tmp.FechaSis	= Mod.FechaSis


select	@Map_FecAct	= max(Tmp.FechaSis)
	from SOPERSON Per noholdlock,
	     #Modificados Mod,
	     SOTMPPER Tmp noholdlock	     		
	where	Mod.Per_Numero	= Per.Per_Numero	  
	  and	Mod.Per_Fecha	= Per.Per_Fecha
	  and	Mod.Per_NumTra	= Per.Per_NumTra
	  and	Mod.FechaSis	= Per.FechaSis	  	
	  and  	Tmp.Per_Numero	= Mod.Per_Numero	  
	  and	Tmp.Per_Fecha	= Mod.Per_Fecha
	  and	Tmp.Per_NumTra	= Mod.Per_NumTra
	  and	Tmp.FechaSis	= Mod.FechaSis
	  
	  
select	@Map_FecFin	= getdate(),
		@Map_TotAct = isnull(@Map_TotAct, @Ent_Cero),
		@Map_FecAct	= isnull(@Map_FecAct, @Map_FecIni) 
		
select	@Map_FecAct	= DATEADD(day, -@Ent_Uno, @Map_FecAct)
			  
exec @Status = SOMOACPEALT	
	@Map_FecAct,	@Map_FecIni,	@Map_FecFin,	@Map_TotAct,	@NumTransac,	
	@Transaccio,	@Usuario,		@Map_FecFin,	@Sucursal,		@Sucursal
if @Status <> @Ent_Cero begin		
	rollback
	return 1
end	
	
	 
drop table #Lista
drop table #Modificados
