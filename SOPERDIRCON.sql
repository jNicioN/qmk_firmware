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
** Modifico: 	Kevin Becerra											  **
** Fecha:		03/03/2026						                    	  **
** HelpDesk:	TCELEM-15447						                      **
** Descripcion:	Se regresa el campo de sexo en las consultas		   	  **
****************************************************************************
** Modifico: 	Edwin Santiago											  **
** Fecha:		03/08/2021						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se valida consulta de personas por RFC y Nombre		   	  **
****************************************************************************
** Modifico: 	Edwin Santiago											  **
** Fecha:		06/04/2021						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se agrega fecha de nacimiento para la consulta de   	  **
**              personas					                              **
****************************************************************************
** Modifico: 	Edwin Santiago											  **
** Fecha:		24/01/2021						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se modifican consultas para contemplar unicamente tipos   **
**              de cliente Banregio			                              **
****************************************************************************
** Modifico: 	Edwin Santiago											  **
** Fecha:		25/06/2020						                    	  **
** HelpDesk:	1299445						                    	      **
** Descripcion:	Se modifican consultas para contemplar la actividad       **
**              economica y tipos de sociedad                             **
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
	
	declare	@RowCount	int		/* Declaración de Variables */
	
			
	/* Declaracion de Constantes*/
	declare	@Str_Porcen	char(1),  /* Caracter porcentaje*/
			@Int_Cero	int,	  /* Constante con valor cero */
			@Int_Dos	int,	  /* Constante con valor dos */
			@Str_Uno	char(1),  /* Caracter Uno*/
			@Str_Dos    char(1),  /* Caracter Dos*/ 
			@Str_Tres   char(1), /* Caracter Tres*/ 
			@Str_Cuatro char(1), /* Caracter Cuatro*/ 
			@Str_LetraC char(1),  /* Caracter C*/
            @Tip_ConTip	char(1),  /* Tipo Consulta*/
			@Tip_ConCon	char(1)   /* Numero de consulta*/
						
	/* Asignación de valores a Constantes */
	select	@Str_Porcen	= '%',
			@Int_Cero   =  0,  /* Entero igual a cero */
			@Int_Dos    =  2,  /* Entero igual a dos */
			@Str_Uno	= '1',			
			@Str_Dos    = '2', 			
			@Str_Tres   = '3',
			@Str_Cuatro = '4',
			@Str_LetraC = 'C'
			

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
			
			
 CREATE TABLE #SOPERINF (
            Per_Numero char(8) not  null,
            Per_Nombre varchar(40)  null,
            Per_ApePat varchar(40)  null,
            Per_ApeMat varchar(40)  null,
            Per_Comple varchar(180) null,
			Per_RFC    varchar(15)  null,
			Per_RazSoc varchar(180) null,
			Per_Calle  char(40)     null,
			Per_CalNum varchar(10)  null,
			Per_Coloni varchar(150) null,
			Col_Nombre char(60)     null,
			Per_Entida char(3)      null,
			Ent_Nombre char(30)     null,
			Per_Locali char(8)      null,
			Loc_Nombre char(40)     null,
			Per_CodPos char(6)      null,
			Per_Tipo   char(1)      null,
			Adi_Client char(8)      null,
			Per_Email  varchar(50)  null,
			Per_LadTel varchar(5)   null,
			Per_Telefo char(15)     null,
			Adi_FecCon smalldatetime null,
			Adi_FecNac smalldatetime null,
			Per_Activi char(10)     null,
			Peu_Grupo  char(8)      null,
			Adi_Sexo   char(1)      null
)
CREATE INDEX #SOPERINF ON #SOPERINF (Per_Numero)

CREATE TABLE #SOGRUPOS (
            Peu_Person  char(8) null,
            Peu_Grupo   char(8) null
)
CREATE INDEX #SOGRUPOS ON #SOGRUPOS (Peu_Grupo)



CREATE TABLE #CLPERSON (
			Cli_ClieId  int 	null,
            Adi_NumPer  char(8) null,
            Adi_Client  char(8) null
)
CREATE INDEX #CLPERSON ON #CLPERSON (Cli_ClieId)

CREATE TABLE #CLCLIUNI (
			Cli_ClieId int     null,
			Adi_NumPer char(8) null,
            Adi_Client char(8) null,
            Cla_Numero int     null,
            Clu_Grupo  char(8) null
    )
CREATE INDEX #CLCLIUNI ON #CLCLIUNI (Adi_Client)

CREATE TABLE #CLCOLONI (
            Cpc_Numero  char(6)     not null,
            Cpc_Nombre  varchar(60) not null
    )
CREATE INDEX #CLCOLONI ON #CLCOLONI (Cpc_Nombre)


	if @Tip_ConTip = @Str_LetraC begin					/* 'C':  Consulta */
		if @Tip_ConCon = @Str_Uno     begin				/* Consulta por numero de persona */
					
			-- Buscamos el grupo de la persona base		
			INSERT INTO #SOGRUPOS(Peu_Grupo, Peu_Person )
			select  so.Peu_Grupo, so.Peu_Person
			from SOUNIPER so noholdlock
			where Peu_Person = @Per_Numero
			
			--Buscamos la persona base
			select @Per_Numero = so.Peu_Person from #SOGRUPOS p
			inner join  SOUNIPER so noholdlock
			on p.Peu_Grupo = so.Peu_Grupo and p.Peu_Grupo = so.Peu_Person
			
			-- Busqueda de Persona
			INSERT INTO #SOPERINF (Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
								  Per_Comple,	Per_RFC,	Per_RazSoc,	Per_Calle,
								  Per_CalNum,	Per_Coloni,	Per_Entida,	Per_Locali,
								  Per_CodPos,	Per_Tipo,	Per_Email,	Per_LadTel,
								  Per_Telefo,	Per_Activi)
			select 	 Per_Numero,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					 Per_Comple,	Per_RFC,	Per_RazSoc,	Per_Calle,
					 Per_CalNum,	Per_Coloni,	Per_Entida,	Per_Locali,
					 Per_CodPos,	Per_Tipo,	Per_Email,	Per_LadTel,
					 Per_Telefo,	Per_Activi
					from SOPERSON noholdlock
					where  Per_Numero  = @Per_Numero

			-- Buscando los numeros de clientes por persona 
			INSERT INTO #CLPERSON (Cli_ClieId,Adi_NumPer,Adi_Client)
			select cl.ClClientID,cl.Adi_NumPer,cl.Adi_Client
			from CLADICIO cl noholdlock 
			inner join #SOPERINF
			on Adi_NumPer = Per_Numero
			
			-- Buscando el grupo del cliente
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo)
			select Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo
			from #CLPERSON cl
			inner join CLCLIUNI noholdlock
			on Clu_Client = Adi_Client
			
			-- Seteamos el cliente unico
			select @Per_Client = clc.Clu_Client from #CLCLIUNI clu
			inner join  CLCLIUNI clc noholdlock
			on clu.Clu_Grupo = clc.Clu_Grupo  and clu.Clu_Grupo = clc.Clu_Client 
			
			delete from #CLCLIUNI where Cli_ClieId is not null
			
			-- Buscamos su ID CLIENTE
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client, Adi_NumPer)
			select ClClientID,Adi_Client,@Per_Numero
			from CLADICIO noholdlock
			where Adi_Client = @Per_Client
									
			-- Se setea la clasificacion de cada cliente
			update #CLCLIUNI set
			Cla_Numero = CLCLACLI.Clc_Clasif
			from CLCLACLI noholdlock
			where CLCLACLI.Clc_Client = #CLCLIUNI.Cli_ClieId
					
			-- Se eliminan clientes no Banregio		
			delete from #CLCLIUNI where Cla_Numero <> @Int_Dos
			
			--Obteniendo informacion adicional de la persona
			update #SOPERINF set Adi_FecCon = so.Adi_FecCon ,Adi_FecNac = so.Adi_FecNac, Adi_Sexo = so.Adi_Sexo
			from SOPERADI so noholdlock
			where  Adi_PerNum = Per_Numero
			
			-- Seteando numero de cliente Unico
			update #SOPERINF set Adi_Client = cu.Adi_Client 
			from #CLCLIUNI cu
			where Per_Numero = cu.Adi_NumPer 
			
			-- Seteando numero de cliente Unico
			update #SOPERINF set Adi_Client = cu.Adi_Client 
			from #CLCLIUNI cu
			where Per_Numero = cu.Adi_NumPer 
			
			
			-- Se obtiene el nombre de la entidad
			update #SOPERINF  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA cl noholdlock
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOPERINF  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c noholdlock
			where Per_Locali = Loc_Numero 
			
			-- Se obtiene colonias de acuerdo al codigo postal
			INSERT INTO #CLCOLONI (Cpc_Numero,Cpc_Nombre)	 
			select Cpc_Numero,Cpc_Nombre 
			from CLCODPOS noholdlock
			inner join #SOPERINF 
			on Cpc_CodPos = Per_CodPos
			
			-- Se setea el nombre de la colonia
			update #SOPERINF set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from #CLCOLONI where Cpc_Nombre = Per_Coloni
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Upper(Per_RFC) as Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac, Act_Numero, Act_Descri, Adi_Sexo,
					Tis_Numero, Tis_Descri
			from #SOPERINF
			left join CLACTIVI noholdlock
			on Act_Numero = Per_Activi
			left join SOCLCAPE noholdlock
			on Clp_NumPer = Per_Numero
			left join CLTIPSOC noholdlock
			on Clp_TipSoc = Tis_Numero

			drop table #SOPERINF,#CLPERSON,#CLCLIUNI,#CLCOLONI,#SOGRUPOS

		end
		
	end else begin								/* 'L':  Lista */
		
		 if @Tip_ConCon = @Str_Uno begin				/* Consulta por RFC */
		 
		 -- Buscamos el numero de persona
		 INSERT INTO #SOPERINF (Per_Numero)
		 select Per_Numero from SOPERSON noholdlock
		 where Per_RFC = @Per_RFC
		 
		 select @RowCount =  count(1) from #SOPERINF
		 
		 if @RowCount = @Int_Cero begin
		 	select	Err_Codigo	= '000004',
					Err_Mensaj	= 'El RFC no existe',
					Err_Variab	= '@Per_RFC'
			rollback
			return 1
		 end else begin
		 
		 -- Buscamos el grupo al que pertenece
		 INSERT INTO #SOGRUPOS(Peu_Grupo, Peu_Person )
		 select  so.Peu_Grupo, so.Peu_Person
		 from SOUNIPER so noholdlock
		 inner join #SOPERINF
		 on Peu_Person = Per_Numero
			
		-- Seteamos la persona base
		select @Per_Numero = so.Peu_Person from #SOGRUPOS p
		inner join  SOUNIPER so noholdlock
		on p.Peu_Grupo = so.Peu_Grupo and p.Peu_Grupo = so.Peu_Person
		
		delete from #SOPERINF where Per_Numero is not null
		 
		-- Busqueda de Persona por RFC
		INSERT INTO #SOPERINF (Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
							 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
							 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
							 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
							 Per_Telefo,Per_Activi)
		select 	 Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
				 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
				 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
				 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
				 Per_Telefo,Per_Activi
				from SOPERSON noholdlock
				where Per_Numero = @Per_Numero
								            
				-- Buscando los numeros de clientes por persona 
			INSERT INTO #CLPERSON (Cli_ClieId,Adi_NumPer,Adi_Client)
			select cl.ClClientID,cl.Adi_NumPer,cl.Adi_Client
			from CLADICIO cl noholdlock 
			inner join #SOPERINF
			on Adi_NumPer = Per_Numero
			
			-- Buscando el grupo del cliente
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo)
			select Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo
			from #CLPERSON cl
			inner join CLCLIUNI noholdlock
			on Clu_Client = Adi_Client
			
			-- Seteamos el cliente unico
			select @Per_Client = clc.Clu_Client from #CLCLIUNI clu
			inner join  CLCLIUNI clc noholdlock
			on clu.Clu_Grupo = clc.Clu_Grupo  and clu.Clu_Grupo = clc.Clu_Client 
			
			delete from #CLCLIUNI where Cli_ClieId is not null
			
			-- Buscamos su ID CLIENTE
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client, Adi_NumPer)
			select ClClientID,Adi_Client,@Per_Numero
			from CLADICIO noholdlock
			where Adi_Client = @Per_Client
									
			-- Se setea la clasificacion de cada cliente
			update #CLCLIUNI set
			Cla_Numero = CLCLACLI.Clc_Clasif
			from CLCLACLI noholdlock
			where CLCLACLI.Clc_Client = #CLCLIUNI.Cli_ClieId
					
			-- Se eliminan clientes no Banregio		
			delete from #CLCLIUNI where Cla_Numero <> @Int_Dos
			
			--Obteniendo informacion adicional de la persona
			update #SOPERINF set Adi_FecCon = so.Adi_FecCon ,Adi_FecNac = so.Adi_FecNac, Adi_Sexo = so.Adi_Sexo
			from SOPERADI so noholdlock
			where  Adi_PerNum = Per_Numero
			
			-- Seteando numero de cliente Unico
			update #SOPERINF set Adi_Client = cu.Adi_Client 
			from #CLCLIUNI cu noholdlock
			where Per_Numero = cu.Adi_NumPer 
			
			
			-- Se obtiene el nombre de la entidad
			update #SOPERINF  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA cl noholdlock
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOPERINF  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c noholdlock
			where Per_Locali = Loc_Numero 
			
			-- Se obtiene colonias de acuerdo al codigo postal
			INSERT INTO #CLCOLONI (Cpc_Numero,Cpc_Nombre)	 
			select Cpc_Numero,Cpc_Nombre 
			from CLCODPOS noholdlock
			inner join #SOPERINF 
			on Cpc_CodPos = Per_CodPos
			
			-- Se setea el nombre de la colonia
			update #SOPERINF set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from #CLCOLONI where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Upper(Per_RFC) as Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac, Act_Numero, Act_Descri, Adi_Sexo,
					Tis_Numero, Tis_Descri
			from #SOPERINF
			left join CLACTIVI noholdlock
			on Act_Numero = Per_Activi
			left join SOCLCAPE noholdlock
			on Clp_NumPer = Per_Numero
			left join CLTIPSOC noholdlock
			on Clp_TipSoc = Tis_Numero

			drop table #SOPERINF,#CLPERSON,#CLCLIUNI,#CLCOLONI,#SOGRUPOS
			end
		end 
		else if @Tip_ConCon = @Str_Dos begin				/* Consulta de RFC con HomoClave */
		
		
		     INSERT INTO #SOPERINF (Per_Numero)
			 select Per_Numero from SOPERSON noholdlock
			 where Per_RFC like  @Per_RFC + @Str_Porcen
			 
		select @RowCount =  count(1) from #SOPERINF
		 
		 if @RowCount = @Int_Cero begin
		 	select	Err_Codigo	= '000004',
					Err_Mensaj	= 'El RFC no existe',
					Err_Variab	= '@Per_RFC'
			rollback
			return 1
		 end else begin
			 
			 INSERT INTO #SOGRUPOS(Peu_Grupo, Peu_Person )
			 select  so.Peu_Grupo, so.Peu_Person
			 from SOUNIPER so noholdlock
			 inner join #SOPERINF
			 on Peu_Person = Per_Numero
				
				
			select @Per_Numero = so.Peu_Person from #SOGRUPOS p
			inner join  SOUNIPER so noholdlock
			on p.Peu_Grupo = so.Peu_Grupo and p.Peu_Grupo = so.Peu_Person
			
			delete from #SOPERINF where Per_Numero is not null
				
		 -- Busqueda de Persona por RFC
			INSERT INTO #SOPERINF (Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
								 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
								 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
								 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
								 Per_Telefo,Per_Activi)
			select 	 Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
					 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
					 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
					 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
					 Per_Telefo,Per_Activi
			from SOPERSON noholdlock
			where Per_Numero = @Per_Numero
					    
			-- Buscando los numeros de clientes por persona 
			INSERT INTO #CLPERSON (Cli_ClieId,Adi_NumPer,Adi_Client)
			select cl.ClClientID,cl.Adi_NumPer,cl.Adi_Client
			from CLADICIO cl noholdlock 
			inner join #SOPERINF
			on Adi_NumPer = Per_Numero
			
			-- Buscando el grupo del cliente
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo)
			select Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo
			from #CLPERSON cl
			inner join CLCLIUNI noholdlock
			on Clu_Client = Adi_Client
			
			-- Seteamos el cliente unico
			select @Per_Client = clc.Clu_Client from #CLCLIUNI clu
			inner join  CLCLIUNI clc noholdlock
			on clu.Clu_Grupo = clc.Clu_Grupo  and clu.Clu_Grupo = clc.Clu_Client 
			
			delete from #CLCLIUNI where Cli_ClieId is not null
			
			-- Buscamos su ID CLIENTE
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client, Adi_NumPer)
			select ClClientID,Adi_Client,@Per_Numero
			from CLADICIO noholdlock
			where Adi_Client = @Per_Client
									
			-- Se setea la clasificacion de cada cliente
			update #CLCLIUNI set
			Cla_Numero = CLCLACLI.Clc_Clasif
			from CLCLACLI noholdlock
			where CLCLACLI.Clc_Client = #CLCLIUNI.Cli_ClieId
					
			-- Se eliminan clientes no Banregio		
			delete from #CLCLIUNI where Cla_Numero <> @Int_Dos
			
			--Obteniendo informacion adicional de la persona
			update #SOPERINF set Adi_FecCon = so.Adi_FecCon ,Adi_FecNac = so.Adi_FecNac, Adi_Sexo = so.Adi_Sexo
			from SOPERADI so noholdlock
			where  Adi_PerNum = Per_Numero
			
			-- Seteando numero de cliente Unico
			update #SOPERINF set Adi_Client = cu.Adi_Client 
			from #CLCLIUNI cu
			where Per_Numero = cu.Adi_NumPer 
			
			
			-- Se obtiene el nombre de la entidad
			update #SOPERINF  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA cl noholdlock
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOPERINF  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c noholdlock
			where Per_Locali = Loc_Numero 
			
			-- Se obtiene colonias de acuerdo al codigo postal
			INSERT INTO #CLCOLONI (Cpc_Numero,Cpc_Nombre)	 
			select Cpc_Numero,Cpc_Nombre 
			from CLCODPOS noholdlock
			inner join #SOPERINF 
			on Cpc_CodPos = Per_CodPos
			
			-- Se setea el nombre de la colonia
			update #SOPERINF set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from #CLCOLONI where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Upper(Per_RFC) as Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac, Act_Numero, Act_Descri, Adi_Sexo,
					Tis_Numero, Tis_Descri
			from #SOPERINF
			left join CLACTIVI noholdlock
			on Act_Numero = Per_Activi
			left join SOCLCAPE noholdlock
			on Clp_NumPer = Per_Numero
			left join CLTIPSOC noholdlock
			on Clp_TipSoc = Tis_Numero

			drop table #SOPERINF,#CLPERSON,#CLCLIUNI,#CLCOLONI,#SOGRUPOS
			
			end
			
		end else if @Tip_ConCon = @Str_Tres begin /* Busqueda por Nombre Completo*/
		
		
			 INSERT INTO #SOPERINF (Per_Numero)
			 select Per_Numero from SOPERSON noholdlock
			 where Per_Comple like @Per_Nombre
			 
			if @RowCount = @Int_Cero begin
				select	Err_Codigo	= '000004',
						Err_Mensaj	= 'No se encontraron coincidencias de nombre',
						Err_Variab	= '@Per_Nombre'
				rollback
				return 1
			 end else begin
			 
			 INSERT INTO #SOGRUPOS(Peu_Grupo, Peu_Person )
			 select  so.Peu_Grupo, so.Peu_Person
			 from SOUNIPER so noholdlock
			 inner join #SOPERINF
			 on Peu_Person = Per_Numero
				
				
			select @Per_Numero = so.Peu_Person from #SOGRUPOS p
			inner join  SOUNIPER so noholdlock
			on p.Peu_Grupo = so.Peu_Grupo and p.Peu_Grupo = so.Peu_Person
			
			delete from #SOPERINF where Per_Numero is not null
			
			 -- Busqueda de Persona por Nombre
			INSERT INTO #SOPERINF (Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
								 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
								 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
								 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
								 Per_Telefo,Per_Activi)
			select 	 Per_Numero,Per_Nombre,Per_ApePat,Per_ApeMat,
					 Per_Comple,Per_RFC,Per_RazSoc,Per_Calle,
					 Per_CalNum,Per_Coloni,Per_Entida,Per_Locali,
					 Per_CodPos,Per_Tipo,Per_Email,Per_LadTel,
					 Per_Telefo,Per_Activi
					from SOPERSON noholdlock
					where Per_Numero = @Per_Numero
					 
				 
			-- Busqueda de Grupo por numero de persona
			update #SOPERINF set Peu_Grupo = su.Peu_Grupo
			from 	SOUNIPER su noholdlock
			where	Per_Numero = Peu_Person 
			
			-- Borrando los numeros de persona que no son base
			delete from #SOPERINF where Per_Numero <> Peu_Grupo
			            
			-- Buscando los numeros de clientes por persona 
			INSERT INTO #CLPERSON (Cli_ClieId,Adi_NumPer,Adi_Client)
			select cl.ClClientID,cl.Adi_NumPer,cl.Adi_Client
			from CLADICIO cl noholdlock 
			inner join #SOPERINF
			on Adi_NumPer = Per_Numero
			
			-- Buscando los clientes unicos
			INSERT INTO #CLCLIUNI (Cli_ClieId,Adi_Client,Adi_NumPer,Clu_Grupo)
			select cl.Cli_ClieId,cl.Adi_Client,cl.Adi_NumPer,Clu_Grupo
			from #CLPERSON cl
			inner join CLCLIUNI noholdlock
			on Clu_Client = Adi_Client
			
			--Se borran los numeros de cliente que no son unicos
			delete from #CLCLIUNI where Adi_Client <> Clu_Grupo
			
			-- Se setea la clasificacion de cada cliente
			update #CLCLIUNI set
			Cla_Numero = CLCLACLI.Clc_Clasif
			from CLCLACLI noholdlock
			where CLCLACLI.Clc_Client = #CLCLIUNI.Cli_ClieId
					
			-- Se eliminan clientes no Banregio		
			delete from #CLCLIUNI where Cla_Numero <> @Int_Dos
			
			--Obteniendo informacion adicional de la persona
			update #SOPERINF set Adi_FecCon = so.Adi_FecCon ,Adi_FecNac = so.Adi_FecNac, Adi_Sexo = so.Adi_Sexo
			from SOPERADI so noholdlock
			where  Adi_PerNum = Per_Numero
			
			-- Seteando numero de cliente Unico
			update #SOPERINF set Adi_Client = cu.Adi_Client 
			from #CLCLIUNI cu
			where Per_Numero = cu.Adi_NumPer 
			
			
			-- Se obtiene el nombre de la entidad
			update #SOPERINF  set Ent_Nombre = cl.Ent_Nombre
			from CLENTIDA cl noholdlock
			where Per_Entida = Ent_Numero 
		
			-- Se obtiene el nombre del municipio
			update #SOPERINF  set Loc_Nombre = c.Loc_Nombre
			from CLLOCALI c noholdlock
			where Per_Locali = Loc_Numero 
			
			-- Se obtiene colonias de acuerdo al codigo postal
			INSERT INTO #CLCOLONI (Cpc_Numero,Cpc_Nombre)	 
			select Cpc_Numero,Cpc_Nombre 
			from CLCODPOS noholdlock
			inner join #SOPERINF 
			on Cpc_CodPos = Per_CodPos
			
			-- Se setea el nombre de la colonia
			update #SOPERINF set Per_Coloni = Cpc_Numero, Col_Nombre = Cpc_Nombre
			from #CLCOLONI where Cpc_Nombre = Per_Coloni
		 
		 
			select 	Per_Numero,	rtrim(Per_Nombre) as Per_Nombre,	rtrim(Per_ApePat) as Per_ApePat,
					rtrim(Per_ApeMat) as Per_ApeMat, Per_Comple,	Upper(Per_RFC) as Per_RFC,	rtrim(Per_Calle) as Per_Calle,
					Per_CalNum,	Per_RazSoc,			 Per_Coloni,	rtrim(Col_Nombre) as Col_Nombre,Per_Entida,
					rtrim(Ent_Nombre) as Ent_Nombre, Per_Locali,	rtrim(Loc_Nombre) as Loc_Nombre,
					Per_CodPos,			 Adi_Client, Per_Tipo,		Per_Email,
					Per_LadTel , 		 Per_Telefo, Adi_FecCon, 	Adi_FecNac, Act_Numero, Act_Descri, Adi_Sexo,
					Tis_Numero, Tis_Descri
			from #SOPERINF
			left join CLACTIVI noholdlock
			on Act_Numero = Per_Activi
			left join SOCLCAPE noholdlock
			on Clp_NumPer = Per_Numero
			left join CLTIPSOC noholdlock
			on Clp_TipSoc = Tis_Numero

			drop table #SOPERINF,#CLPERSON,#CLCLIUNI,#CLCOLONI,#SOGRUPOS
			
			end


		end else if @Tip_ConCon = @Str_Cuatro begin /*Busqueda de colonias por parametros de entidad,estado y codigo postal*/
			
			select Cpc_Numero as Per_Coloni, Cpc_Nombre as Col_Nombre
			from CLENTIDA noholdlock
			inner join CLLOCALI noholdlock
			on Ent_Numero = Loc_Entida
			inner join CLCODPOS noholdlock
			on Loc_Numero = Cpc_Locali
			where  Ent_Numero  = @Per_Entida
			and  Loc_Numero = @Per_Locali
			and  Cpc_CodPos  = @Per_CodPos
			
		end
	end
end