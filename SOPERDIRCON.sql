create procedure SOPERDIRCON (
	@Per_Numero	 char(8),
	@Per_Nombre  char(180),
	@Per_RFC	 char(15),
	@Per_Client	 char(8),
	@Per_CURP    char(18),
	@Per_Entida  char(3),
	@Per_Locali  char(8),
	@Per_CodPos  char(6),
	@Tip_Consul  char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)as

/* *************************************************************************
** DESCRIPCION: ** Consultas de Personas con Direccion					****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modifico: 	Edwin Santiago											  **
** Fecha:		27/04/2020						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se modifican consultas para contemplar mas inforamcion de **
**              colonias, tambien se agrega consulta L4 para consultar    **
**              relacion entre parametros de datos geograficos			  **
****************************************************************************
** Creó: 		Edwin Santiago											  **
** Fecha:		02/04/2020						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se realiza consulta de persona por nombre y rfc,          **
**              trayendo solo la persona unificada con su direccion		  **
****************************************************************************
**/

begin
	
	/* Declaracion de Variables */
	declare @Ent_Nombre char(30), /* Nombre de la Entidad*/
			@Loc_Nombre char(40), /* Nombre de la Localidad*/
			@Col_Nombre char(60), /* Nombre de la Colonia*/
			@Adi_Client char(8),  /* Numero de cliente */
			@Peu_Grupo  char(8)  /* Grupo al que pertenece la persona*/
			
	/* Declaracion de Constantes*/
	declare	@Str_Porcen	char(1),  /* Caracter porcentaje*/
			@Str_Uno	char(1),  /* Caracter Uno*/
			@Str_Dos    char(1),  /* Caracter Dos*/ 
			@Str_Tres   char(1), /* Caracter Tres*/ 
			@Str_Cuatro char(1), /* Caracter Cuatro*/ 
			@Str_LetraC char(1),  /* Caracter C*/
            @Tip_ConTip	char(1),  /* Tipo Consulta*/
			@Tip_ConCon	char(1)   /* Numero de consulta*/
						
	/* Asignación de valores a Constantes */
	select	@Str_Porcen	= '%',
			@Str_Uno	= '1',			
			@Str_Dos    = '2', 			
			@Str_Tres   = '3',
			@Str_Cuatro = '4',
			@Str_LetraC = 'C'
	
	/* Asignación de valores a Variables */	
	select  @Ent_Nombre = '',
			@Loc_Nombre = '',
			@Col_Nombre = '',
			@Adi_Client = ''
			

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

	if @Tip_ConTip = @Str_LetraC begin					/* 'C':  Consulta */
		if @Tip_ConCon = @Str_Uno     begin				/* Consulta por numero de persona */
			
			 -- Busqueda de Persona
			select 	Per_Numero, @Peu_Grupo as Peu_Grupo
					into #SOTMPNUM
					from SOPERSON noholdlock
					where  Per_Numero  = @Per_Numero
			 
			-- Busqueda de Grupo por numero de persona
			update #SOTMPNUM set Peu_Grupo = su.Peu_Grupo
			from 	SOUNIPER su noholdlock
			where	Per_Numero = Peu_Person 
			
			-- Borrando los numeros de persona que no son base
			delete from #SOTMPNUM where Per_Numero <> Peu_Grupo
			            
			-- Buscando los numeros de clientes por persona
			select Adi_Client 
			into #SOTMPCPS
			from CLADICIO noholdlock 
			where Adi_NumPer in (select Peu_Grupo from #SOTMPNUM)
			
			-- Buscando los numeros de clientes unicos
			select Clu_Grupo 
			into #SOTMPCPU
			from CLCLIUNI 
			where Clu_Client in ( select Adi_Client from #SOTMPCPS )
			
			
			-- Se obtiene la persona Base de acuerdo al grupo
			select	
				s.Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_Comple,
				Per_RFC,		Per_RazSoc,	Per_Calle,	Per_CalNum,	Per_Coloni, @Col_Nombre as Col_Nombre,
				Per_Entida,		@Ent_Nombre as Ent_Nombre,			Per_Locali,
				@Loc_Nombre as Loc_Nombre,	Per_CodPos, Per_Tipo, 	Adi_Client,
				Per_Email , 	Per_LadTel, Per_Telefo, Adi_FecCon, Adi.Adi_FecNac
			into #SOTMPDPE
			from #SOTMPNUM tmp
			inner join SOPERSON s noholdlock on s.Per_Numero = tmp.Peu_Grupo
			inner join SOPERADI Adi noholdlock on Adi_PerNum = tmp.Peu_Grupo
			left join  CLADICIO noholdlock on Adi_NumPer = tmp.Peu_Grupo
			
			delete from #SOTMPDPE where Adi_Client is not null 
	                      and Adi_Client not in (select Clu_Grupo from #SOTMPCPU )


			
			-- Se obtiene el nombre de la entidad
			
			update #SOTMPDPE  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA  cl
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOTMPDPE  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c  
			where Per_Locali = Loc_Numero 
			
			update #SOTMPDPE set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from CLCODPOS where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac
			from #SOTMPDPE
				
			drop table #SOTMPNUM,#SOTMPDPE,#SOTMPCPU,#SOTMPCPS

		end
		
	end else begin								/* 'L':  Lista */
		
		 if @Tip_ConCon = @Str_Uno begin				/* Consulta por RFC */
		 
			 -- Busqueda de Persona
			select 	Per_Numero, @Peu_Grupo as Peu_Grupo
					into #SOTMPPER
					from SOPERSON noholdlock
					where Per_RFC = @Per_RFC
			 
			-- Busqueda de Grupo por numero de persona
			update #SOTMPPER set Peu_Grupo = su.Peu_Grupo
			from 	SOUNIPER su noholdlock
			where	Per_Numero = Peu_Person 
			
			-- Borrando los numeros de persona que no son base
			delete from #SOTMPPER where Per_Numero <> Peu_Grupo
			            
			-- Buscando los numeros de clientes por persona
			select Adi_Client 
			into #SOTMPCLP
			from CLADICIO noholdlock 
			where Adi_NumPer in (select Peu_Grupo from #SOTMPPER)
			
			-- Buscando los numeros de clientes unicos
			select Clu_Grupo 
			into #SOTMPCLI
			from CLCLIUNI 
			where Clu_Client in ( select Adi_Client from #SOTMPCLP )
			
			
			-- Se obtiene la persona Base de acuerdo al grupo
			select	
				s.Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_Comple,
				Per_RFC,		Per_RazSoc,	Per_Calle,	Per_CalNum,	Per_Coloni, @Col_Nombre as Col_Nombre,
				Per_Entida,		@Ent_Nombre as Ent_Nombre,			Per_Locali,
				@Loc_Nombre as Loc_Nombre,	Per_CodPos, Per_Tipo, 	Adi_Client,
				Per_Email , 	Per_LadTel, Per_Telefo, Adi_FecCon, Adi.Adi_FecNac
			into #SOTMPPRR
			from #SOTMPPER tmp
			inner join SOPERSON s noholdlock on s.Per_Numero = tmp.Peu_Grupo
			inner join SOPERADI Adi noholdlock on Adi_PerNum = tmp.Peu_Grupo
			left join  CLADICIO noholdlock on Adi_NumPer = tmp.Peu_Grupo
			
			delete from #SOTMPPRR where Adi_Client is not null 
	                      and Adi_Client not in (select Clu_Grupo from #SOTMPCLI )


			
			-- Se obtiene el nombre de la entidad
			
			update #SOTMPPRR  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA  cl
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOTMPPRR  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c  
			where Per_Locali = Loc_Numero 
			
			update #SOTMPPRR set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from CLCODPOS where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac
			from #SOTMPPRR
				
			drop table #SOTMPPER,#SOTMPPRR,#SOTMPCLI,#SOTMPCLP

		end 
		else if @Tip_ConCon = @Str_Dos begin				/* Consulta de RFC con HomoClave */
			
		
			 -- Busqueda de Persona
			select 	Per_Numero, @Peu_Grupo as Peu_Grupo
					into #SOTMPRFC
					from SOPERSON noholdlock
					where Per_RFC like  @Per_RFC + @Str_Porcen
			 
			-- Busqueda de Grupo por numero de persona
			update #SOTMPRFC set Peu_Grupo = su.Peu_Grupo
			from 	SOUNIPER su noholdlock
			where	Per_Numero = Peu_Person 
			
			-- Borrando los numeros de persona que no son base
			delete from #SOTMPRFC where Per_Numero <> Peu_Grupo
			            
			-- Buscando los numeros de clientes por persona
			select Adi_Client 
			into #SOTMPCLF
			from CLADICIO noholdlock 
			where Adi_NumPer in (select Peu_Grupo from #SOTMPRFC)
			
			-- Buscando los numeros de clientes unicos
			select Clu_Grupo 
			into #SOTMPCLR
			from CLCLIUNI 
			where Clu_Client in ( select Adi_Client from #SOTMPCLF )
			
			
			-- Se obtiene la persona Base de acuerdo al grupo
			select	
				s.Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_Comple,
				Per_RFC,		Per_RazSoc,	Per_Calle,	Per_CalNum,	Per_Coloni, @Col_Nombre as Col_Nombre,
				Per_Entida,		@Ent_Nombre as Ent_Nombre,			Per_Locali,
				@Loc_Nombre as Loc_Nombre,	Per_CodPos, Per_Tipo, 	Adi_Client,
				Per_Email , 	Per_LadTel, Per_Telefo, Adi_FecCon, Adi.Adi_FecNac
			into #SOTMPDAT
			from #SOTMPRFC tmp
			inner join SOPERSON s noholdlock on s.Per_Numero = tmp.Peu_Grupo
			inner join SOPERADI Adi noholdlock on Adi_PerNum = tmp.Peu_Grupo
			left join  CLADICIO noholdlock on Adi_NumPer = tmp.Peu_Grupo
			

			delete from #SOTMPDAT where Adi_Client is not null 
								  and Adi_Client not in (select Clu_Grupo from #SOTMPCLR )
			
			-- Se obtiene el nombre de la entidad
			
			update #SOTMPDAT  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA  cl
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOTMPDAT  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c  
			where Per_Locali = Loc_Numero 
			
			update #SOTMPDAT set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from CLCODPOS where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac
			from #SOTMPDAT
				
			drop table #SOTMPRFC,#SOTMPCLF,#SOTMPCLR,#SOTMPDAT
			
		end else if @Tip_ConCon = @Str_Tres begin /* Busqueda por Nombre Completo*/
			
			 -- Busqueda de Persona
			select 	Per_Numero, @Peu_Grupo as Peu_Grupo
					into #SOTMPNOM
					from SOPERSON noholdlock
					where Per_Comple like @Per_Nombre
			 
			-- Busqueda de Grupo por numero de persona
			update #SOTMPNOM set Peu_Grupo = su.Peu_Grupo
			from 	SOUNIPER su noholdlock
			where	Per_Numero = Peu_Person 
			
			-- Borrando los numeros de persona que no son base
			delete from #SOTMPNOM where Per_Numero <> Peu_Grupo
			            
			-- Buscando los numeros de clientes por persona
			select Adi_Client 
			into #SOTMPCPE
			from CLADICIO noholdlock 
			where Adi_NumPer in (select Peu_Grupo from #SOTMPNOM)
			
			-- Buscando los numeros de clientes unicos
			select Clu_Grupo 
			into #SOTMPCUN
			from CLCLIUNI 
			where Clu_Client in ( select Adi_Client from #SOTMPCPE )
			
			
			-- Se obtiene la persona Base de acuerdo al grupo
			select	
				s.Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_Comple,
				Per_RFC,		Per_RazSoc,	Per_Calle,	Per_CalNum,	Per_Coloni, @Col_Nombre as Col_Nombre,
				Per_Entida,		@Ent_Nombre as Ent_Nombre,			Per_Locali,
				@Loc_Nombre as Loc_Nombre,	Per_CodPos, Per_Tipo, 	Adi_Client,
				Per_Email , 	Per_LadTel, Per_Telefo, Adi_FecCon, Adi.Adi_FecNac
			into #SOTMPPCO
			from #SOTMPNOM tmp
			inner join SOPERSON s noholdlock on s.Per_Numero = tmp.Peu_Grupo
			inner join SOPERADI Adi noholdlock on Adi_PerNum = tmp.Peu_Grupo
			left join  CLADICIO noholdlock on Adi_NumPer = tmp.Peu_Grupo
			

			delete from #SOTMPPCO where Adi_Client is not null 
								  and Adi_Client not in (select Clu_Grupo from #SOTMPCUN )
			
			-- Se obtiene el nombre de la entidad
			
			update #SOTMPPCO  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA  cl
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOTMPPCO  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c  
			where Per_Locali = Loc_Numero 
			
			update #SOTMPPCO set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from CLCODPOS where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac
			from #SOTMPPCO
				
			drop table #SOTMPNOM,#SOTMPCPE,#SOTMPCUN,#SOTMPPCO

		end else if @Tip_ConCon = @Str_Cuatro begin /*Busqueda de colonias por parametros de entidad,estado y codigo postal*/
			
			select Cpc_Numero as Per_Coloni, Cpc_Nombre as Col_Nombre
			from CLENTIDA  
			inner join CLLOCALI 
			on Ent_Numero = Loc_Entida
			inner join CLCODPOS
			on Loc_Numero = Cpc_Locali
			where  Ent_Numero  = @Per_Entida
			and  Loc_Numero = @Per_Locali
			and  Cpc_CodPos  = @Per_CodPos
			
		end
	end
end