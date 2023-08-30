create procedure SOPERCLACON (
	@Per_Numero	char(8),
	@Per_Comple	varchar(181),
	@Per_Tipo	char(1),
	@Per_RFC	varchar(15),
	@Per_ClaCom	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Consulta de Personas y Clasificacion **		****
********************************************************************
** REFERENCIAS:													****
********************************************************************
**	Modificó:	Rafael Moreno									****
**  Fecha:		24/08/2023										****
**  Help:		-----											****
**	Descripción: Agregar L4, similar a L1, pero debe regresar	****
**	Cli_Status y numero de cliente unico y nivel de cliente. 	****
**	buscar por RFC en CLCLIENT y SOPERSON						****
********************************************************************
**	Modificó:	Carlos Copto									****
**  Fecha:		02/09/2021										****
**  Help:		1478014											****
**	Descripción: Se optimizan todas las consultas, se cambia	****
**	la forma de obtener la clasificacion del cliente			****
**	desde la tabla CLCLACLI										****
********************************************************************
**	Modificó:	Carlos Copto									****
**  Fecha:		14/04/2021										****
**  Help:		1478014											****
**	Descripción: Se crean consultas L2 (para bd produccion, sin ****
**	filtro de sucursal, aumenta a 8 letras para busqueda de 	****
**	nombre y limitado a fecha de hoy) y L3 (para bd de reportes,****
**	lo mismo que la L2 pero sin limitarlo al dia de hoy)		****
********************************************************************
**	Modificó:	Frank canul										****
**  Fecha:		23/12/2020										****
**  Help:		1286068											****
**	Descripción: se elimina el convert para la columna			****
**  Ptc_TipCue  ya que ahora es char y no se					****
**  necesita las conversiones  									****
********************************************************************
** Creo:			Adriana Gomez								****
** Fecha:			28/nov/2020									****
** Help:			1376175 									****
** Descripcion:		se quita busqueda viejita de usuarios de CV	****
********************************************************************
** Creo:			Juan Sandoval								****
** Fecha:			09/oct/2020									****
** Help:			1431786 									****
** Descripcion:		Creacion SP atomico base: SOPERSONCON		****
********************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Busqueda	varchar(100),
		@Suc_Numero	varchar(3),
		@Par_FecSuc smalldatetime,
		@Conteo		int

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Porcen	char(1),
		@Str_Coma	char(1),
		@Str_Prospe	varchar(25),
		@Sta_Si		char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Ent_Tres	int,
		@Ent_Cuatro int,
		@Ent_Cinco	int,
		@Ent_Ocho	int,
		@Tip_Moral	char(1),
		@Tip_Fisica	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Cuatro char(1),
		@Per_RFCSH	varchar(15),
		@Sin_Direcc varchar(50),
		@Sta_Termin char(1),
		@Str_Usuari varchar(10),
		@Str_L		char(1),
		@Str_CuaCer	char(4),
		@Cla_Banreg	int,
		@Cue_HeyBiz	char(2),
		@Cue_CashBa	char(2),
		@Fec_Vacia	smalldatetime,
		@Cli_StaS	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Str_Porcen	= '%',			-- String Porcentaje
		@Str_Coma	= ',',			-- String Coma
		@Str_Prospe	= 'PROSPECTO',	-- String Prospecto
		@Sta_Si		= 'S',			-- Status : Si
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1,			-- Entero : 1
		@Ent_Dos	= 2,			-- Entero : 2
		@Ent_Tres	= 3,			-- Entero : 3
		@Ent_Cuatro	= 4,			-- Entero : 4
		@Ent_Cinco	= 5,			-- Entero : 5
		@Ent_Ocho	= 8,			-- Entero : 8
		@Tip_Moral	= '1',			-- Tipo de Persona Moral
		@Tip_Fisica	= '2',			-- Tipo de Persona Fisica
		@Str_Uno	= '1',
		@Str_Dos	= '2',
		@Str_Tres	= '3',
		@Str_Cuatro	= '4',
		@Sin_Direcc = 'Sin Direcci&oacuten',
		@Sta_Termin	= 'T',			-- Status de Terminado
		@Str_Usuari = 'USUARIO',		-- String Usuario
		@Str_L		= 'L',
		@Str_CuaCer	= '0000',		-- String: cuatro ceros 
		@Cla_Banreg = 2,			-- Clasificacion: Banregio 
		@Cue_HeyBiz = '47',			-- Tipo de Cuenta: Cashback 
		@Cue_CashBa = '31',			-- Tipo de Cuenta: Cashback 
		@Fec_Vacia	= '1900-01-01',	-- Feha Vacia
		@Cli_StaS 	= 'S'			-- Cliente estatus S
		
select	@Busqueda	= @Per_Comple
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

--se crean las tablas temporales a usar 
create table #CientesPersonas (
	Per_Numero	char(8), 	
	Per_NumTra	char(10), 	
	Per_Titulo	varchar(10), 
	Per_ComOrd	varchar(181),
	Per_Nacion	char(3), 	
	Per_RFC		varchar(15), 
	Per_Calle	varchar(200), 		
	Per_Tipo	char(1), 		
	Per_Nombre	varchar(40), 	
	Per_ApePat	varchar(40),	
	Per_ApeMat 	varchar(40), 
	Per_RazSoc	varchar(180), 	
	Adi_FecNac	smalldatetime, 	
	Adi_TipIde	char(1), 	
	Adi_NumIde	varchar(30), 	
	Per_NumPer	char(8), 
	Per_CURP	char(18),
	
	Cli_TieCla	char(1),
	Cli_Locali	char(8),
	Cli_Entida	char(3),
	
	Cli_Calle	char(40),
	Cli_CalNum	varchar(10),
	Cli_Coloni	varchar(150),
	Cli_ID		int,
	Cli_Status	char(1),
	Cli_Unico	char(8),
	Nac_NivAut	int
)

create table #AuxCientesPersonas (
	ClientePersonaID	int, 	
	ClientePersonaNum	char(8),
	FechaSis			smalldatetime
)

---------------------------------------------

if @Tip_ConTip = @Str_L begin
	
	select	@Per_Comple	= ltrim(rtrim(@Per_Comple)) + @Str_Porcen
	
	if @Tip_ConCon = @Str_Uno begin --CONSULTA L1 : BUSQUEDA DE CLIENTES Y PERSONAS CON RESTRICCION DE SUCURSAL
		
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin	--Busqueda por numero de cliente 
		
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where 	Cli_Numero = @Busqueda 
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti)
						
			--solo si encontro reultado continua con las consultas
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin
				
				--se crean indices de la tabla temporal
				create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
				create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select distinct
							Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID,
							clc.Cli_Status,
							uni.Clu_Grupo,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
							left join CLCLIUNI uni noholdlock on ClientePersonaNum = Clu_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle de los registros con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
			
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas 
					where	Cli_TieCla = @Str_Vacio
					
			end 

		end else if (@Per_RFC != @Str_Vacio) begin	------------- Busqueda por RFC

			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_RFC like @Per_RFC
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) 
			
			--se crean indices de la tabla temporal
			create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
			create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
	
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select distinct
							Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID,
							clc.Cli_Status,
							uni.Clu_Grupo,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
							left join CLCLIUNI uni noholdlock on ClientePersonaNum = Clu_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas
					where	Cli_TieCla = @Str_Vacio

			end

		end else begin			------------- Busqueda por nombre cliente/persona
		
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_Comple like @Per_Comple
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) 
			
			--se crean indices de la tabla temporal
			create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
			create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
	
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select distinct
							Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID,
							clc.Cli_Status,
							uni.Clu_Grupo,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
							left join CLCLIUNI uni noholdlock on ClientePersonaNum = Clu_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas
					where	Cli_TieCla = @Str_Vacio
			end
			
			-- se limpian las tablas auxiliares para buscar a las personas
			truncate table #AuxCientesPersonas
					
			-----Se obtienen solo los id de las personas
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)		
			select	top 50		
					PerPersoID, Per_Numero, max(FechaSis) FechaSis
				from 	SOPERSON noholdlock
				where	Per_Comple like @Per_Comple
				group by Per_Comple, Per_RFC
	
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
		
				--Se inserta al prospecto
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select	
					Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					isnull(Per_RFC, @Str_Vacio),
					@Str_Vacio,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
							@Str_Tres
						else
							Per_Tipo
					end,
					case when Per_Tipo = @Tip_Moral then
							isnull(Clp_NomSoc, @Str_Vacio)
						else
							Per_Nombre
					end,
					isnull(Per_ApePat, @Str_Vacio),
					isnull(Per_ApeMat, @Str_Vacio),
					isnull(Clp_TipSoc, @Str_Vacio),
					isnull(Adi_FecNac, @Fec_Vacia),
					isnull(Adi_TipIde, @Str_Vacio),
					isnull(Adi_NumIde, @Str_Vacio),
					Per_Numero,
					isnull(Per_CURP, @Str_Vacio),
					@Str_Vacio,
					isnull(Per_Locali, @Str_Vacio),
					isnull(Per_Entida, @Str_Vacio),
					isnull(Per_Calle, @Str_Vacio),
					isnull(Per_CalNum, @Str_Vacio),
					isnull(Per_Coloni, @Str_Vacio),
					PerPersoID,
					@Str_Vacio,
					@Str_Vacio,
					@Ent_Cero
				from #AuxCientesPersonas noholdlock
					inner join SOPERSON noholdlock on PerPersoID  = ClientePersonaID
					inner join SOPERADI noholdlock on ClientePersonaNum = Adi_PerNum
					left join SOCLCAPE noholdlock on ClientePersonaNum  = Clp_NumPer
				
				--se actualiza el campo Per_Calle con la info faltante de entidad y localidad
				update #CientesPersonas set  
					Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
								rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
								Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
				from #CientesPersonas noholdlock
						inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
						inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
			end
		end				
	end else if @Tip_ConCon = @Str_Dos begin --CONSULTA L2 : BUSQUEDA DE CLIENTES Y PERSONAS SIN RESTRICCION DE SUCURSAL Y SOLO CREADOS EL DIA DE HOY (BD PRODUCCION)
		
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		--Se obtiene la fecha actual de la sucursal
		select	@Par_FecSuc	= Par_FecAct
		from SOPARAMS noholdlock
		where	Par_Sucurs	= @Suc_Numero
			
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin	--Busqueda por numero de cliente 
		
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where 	Cli_Numero = @Busqueda 
				and 	Cli_Fecha >= @Par_FecSuc
						
			--solo si encontro reultado continua con las consultas
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin
				
				--se crean indices de la tabla temporal
				create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
				create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select		Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID ,
							@Str_Vacio,
							@Str_Vacio,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle de los registros con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas 
					where	Cli_TieCla = @Str_Vacio
					
			end 
					
		end else begin			------------- Busqueda por nombre cliente/persona
		
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_Comple like @Per_Comple
				and 	Cli_Fecha >= @Par_FecSuc
			
			--se crean indices de la tabla temporal
			create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
			create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
	
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select		Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID, 
							@Str_Vacio,
							@Str_Vacio,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas
					where	Cli_TieCla = @Str_Vacio
			end
			
			-- se limpian las tablas auxiliares para buscar a las personas
			truncate table #AuxCientesPersonas
					
			-----Se obtienen solo los id de las personas
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select	top 50		
					PerPersoID, Per_Numero, max(FechaSis) FechaSis
				from 	SOPERSON noholdlock
				where	Per_Comple like @Per_Comple
				and 	Per_Fecha 	>= 	@Par_FecSuc
				group by Per_Comple, Per_RFC
			
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
		
				--Se inserta al prospecto
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select	
					Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					isnull(Per_RFC, @Str_Vacio),
					@Str_Vacio,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
							@Str_Tres
						else
							Per_Tipo
					end,
					case when Per_Tipo = @Tip_Moral then
							isnull(Clp_NomSoc, @Str_Vacio)
						else
							Per_Nombre
					end,
					isnull(Per_ApePat, @Str_Vacio),
					isnull(Per_ApeMat, @Str_Vacio),
					isnull(Clp_TipSoc, @Str_Vacio),
					isnull(Adi_FecNac, @Fec_Vacia),
					isnull(Adi_TipIde, @Str_Vacio),
					isnull(Adi_NumIde, @Str_Vacio),
					Per_Numero,
					isnull(Per_CURP, @Str_Vacio),
					@Str_Vacio,
					isnull(Per_Locali, @Str_Vacio),
					isnull(Per_Entida, @Str_Vacio),
					isnull(Per_Calle, @Str_Vacio),
					isnull(Per_CalNum, @Str_Vacio),
					isnull(Per_Coloni, @Str_Vacio),
					PerPersoID,
					@Str_Vacio,
					@Str_Vacio,
					@Ent_Cero
				from #AuxCientesPersonas noholdlock
					inner join SOPERSON noholdlock on PerPersoID  = ClientePersonaID
					inner join SOPERADI noholdlock on ClientePersonaNum = Adi_PerNum
					left join SOCLCAPE noholdlock on ClientePersonaNum  = Clp_NumPer
				
				--se actualiza el campo Per_Calle con la info faltante de entidad y localidad
				update #CientesPersonas set  
					Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
								rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
								Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
				from #CientesPersonas noholdlock
						inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
						inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
			end
		end				
	end else if @Tip_ConCon = @Str_Tres begin --CONSULTA L3 : BUSQUEDA DE CLIENTES Y PERSONAS SIN RESTRICCION DE SUCURSAL (BD REPORTES)
		
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin	--Busqueda por numero de cliente 
		
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where 	Cli_Numero = @Busqueda
						
			--solo si encontro reultado continua con las consultas
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin
				
				--se crean indices de la tabla temporal
				create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
				create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select		Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID, 
							@Str_Vacio,
							@Str_Vacio,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle de los registros con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas 
					where	Cli_TieCla = @Str_Vacio
					
			end 
					
		end else begin			------------- Busqueda por nombre cliente/persona
		
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			--se consulta solo el numero del cliente
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_Comple like @Per_Comple
			
			--se crean indices de la tabla temporal
			create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
			create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
			
			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
	
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select		Cli_Numero,
							Cli_Numero,
							cast(@Ent_Uno as varchar),
							isnull(Cli_ComOrd, @Str_Vacio),
							space(@Ent_Tres),
							isnull(Cli_RFC, @Str_Vacio),
							@Str_Vacio,
							case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
									@Str_Tres
								else
									isnull(Cli_Tipo, @Str_Vacio)
							end,
							case when Cli_Tipo = @Tip_Moral then
									isnull(Con_NomSoc, @Str_Vacio)
								else
									isnull(Cli_Nombre, @Str_Vacio)
							end,
							isnull(Cli_ApePat, @Str_Vacio),
							isnull(Cli_ApeMat, @Str_Vacio),
							isnull(Con_TipSoc, @Str_Vacio),
							case when Cli_Tipo = @Tip_Moral then
									isnull(con.Con_FeEsCl, cla.Adi_FecNac)
								else
									isnull(cla.Adi_FecNac,@Fec_Vacia)
							end,
							isnull(con.Con_TipIde, @Str_Vacio),
							isnull(con.Con_NumIde, @Str_Vacio),
							isnull(cla.Adi_NumPer, @Str_Vacio),
							isnull(Cli_CURP, @Str_Vacio),
							@Str_Vacio,
							isnull(Cli_Locali, @Str_Vacio),
							isnull(Cli_Entida, @Str_Vacio),
							isnull(Cli_Calle, @Str_Vacio),
							isnull(Cli_CalNum, @Str_Vacio),
							isnull(Cli_Coloni, @Str_Vacio),
							clc.ClClientID, 
							@Str_Vacio,
							@Str_Vacio,
							@Ent_Cero
					from 	#AuxCientesPersonas noholdlock
							inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
							left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
							left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
					
					--se crea indice para la tabla
					create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
					
					--se actualiza el campo Per_Calle con la direccion completa
					update #CientesPersonas set  
						Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
									rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
									Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
					from #CientesPersonas noholdlock
							inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
							inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
				
					--se actualiza el campo de clasificacion
					update #CientesPersonas set 
							Cli_TieCla = @Sta_Si
					from 	#CientesPersonas noholdlock
							inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
					where	Clc_Clasif = @Per_ClaCom
					
					--se borran los que no tengan clasificacion
					delete from #CientesPersonas
					where	Cli_TieCla = @Str_Vacio
			end
			
			-- se limpian las tablas auxiliares para buscar a las personas
			truncate table #AuxCientesPersonas
					
			-----Se obtienen solo los id de las personas
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select	top 50		
					PerPersoID, Per_Numero, max(FechaSis) FechaSis
				from 	SOPERSON noholdlock
				where	Per_Comple like @Per_Comple
				group by Per_Comple, Per_RFC

			--solo si regreso resultados continua con las consultas de cliente
			select @Conteo = count(*) from #AuxCientesPersonas noholdlock
			if @Conteo > @Ent_Cero begin  
		
				--Se inserta al prospecto
				insert into #CientesPersonas(
					Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
					Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
					Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
					Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
					Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
					Cli_Unico,		Nac_NivAut
				)
				select	
					Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					isnull(Per_RFC, @Str_Vacio),
					@Str_Vacio,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
							@Str_Tres
						else
							Per_Tipo
					end,
					case when Per_Tipo = @Tip_Moral then
							isnull(Clp_NomSoc, @Str_Vacio)
						else
							Per_Nombre
					end,
					isnull(Per_ApePat, @Str_Vacio),
					isnull(Per_ApeMat, @Str_Vacio),
					isnull(Clp_TipSoc, @Str_Vacio),
					isnull(Adi_FecNac, @Fec_Vacia),
					isnull(Adi_TipIde, @Str_Vacio),
					isnull(Adi_NumIde, @Str_Vacio),
					Per_Numero,
					isnull(Per_CURP, @Str_Vacio),
					@Str_Vacio,
					isnull(Per_Locali, @Str_Vacio),
					isnull(Per_Entida, @Str_Vacio),
					isnull(Per_Calle, @Str_Vacio),
					isnull(Per_CalNum, @Str_Vacio),
					isnull(Per_Coloni, @Str_Vacio),
					PerPersoID,
					@Str_Vacio,
					@Str_Vacio,
					@Ent_Cero
				from #AuxCientesPersonas noholdlock
					inner join SOPERSON noholdlock on PerPersoID  = ClientePersonaID
					inner join SOPERADI noholdlock on ClientePersonaNum = Adi_PerNum
					left join SOCLCAPE noholdlock on ClientePersonaNum  = Clp_NumPer
				
				--se actualiza el campo Per_Calle con la info faltante de entidad y localidad
				update #CientesPersonas set  
					Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
								rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
								Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
				from #CientesPersonas noholdlock
						inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
						inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
	
			end
		end
	end	
	else if @Tip_ConCon = @Str_Cuatro begin --CONSULTA L4 : BUSQUEDA DE CLIENTES Y PERSONAS CON RESTRICCION DE SUCURSAL Y NIVEL DE CLIENTE
		
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin	-- Busqueda por numero de cliente 
		
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end
			
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where 	Cli_Numero = @Busqueda 
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti)

		end else if (@Per_RFC != @Str_Vacio) begin	-- Busqueda por RFC

			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_RFC like @Per_RFC
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) 

		end else begin	-- Busqueda por nombre cliente/persona
		
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)
			select top 50	
				ClClientID, Cli_Numero, FechaSis
				from  CLCLIENT noholdlock
				where	Cli_Comple like @Per_Comple
				and 	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) 

		end

		--solo si encontro reultado continua con las consultas
		select @Conteo = count(*) from #AuxCientesPersonas noholdlock
		if @Conteo > @Ent_Cero begin
			
			--se crean indices de la tabla temporal
			create nonclustered index ACPID on #AuxCientesPersonas ( ClientePersonaID )
			create nonclustered index ACPNum on #AuxCientesPersonas ( ClientePersonaNum )
		
			insert into #CientesPersonas(
				Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
				Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
				Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
				Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
				Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
				Cli_Unico,		Nac_NivAut
			)
			select distinct
						clc.Cli_Numero,
						clc.Cli_Numero,
						cast(@Ent_Uno as varchar),
						isnull(clc.Cli_ComOrd, @Str_Vacio),
						space(@Ent_Tres),
						isnull(clc.Cli_RFC, @Str_Vacio),
						@Str_Vacio,
						case when clc.Cli_Tipo = @Tip_Fisica and clc.Cli_ActEmp = @Sta_Si then
								@Str_Tres
							else
								isnull(clc.Cli_Tipo, @Str_Vacio)
						end,
						case when clc.Cli_Tipo = @Tip_Moral then
								isnull(Con_NomSoc, @Str_Vacio)
							else
								isnull(clc.Cli_Nombre, @Str_Vacio)
						end,
						isnull(clc.Cli_ApePat, @Str_Vacio),
						isnull(clc.Cli_ApeMat, @Str_Vacio),
						isnull(Con_TipSoc, @Str_Vacio),
						case when clc.Cli_Tipo = @Tip_Moral then
								isnull(con.Con_FeEsCl, cla.Adi_FecNac)
							else
								isnull(cla.Adi_FecNac,@Fec_Vacia)
						end,
						isnull(con.Con_TipIde, @Str_Vacio),
						isnull(con.Con_NumIde, @Str_Vacio),
						isnull(cla.Adi_NumPer, @Str_Vacio),
						isnull(clc.Cli_CURP, @Str_Vacio),
						@Str_Vacio,
						isnull(clc.Cli_Locali, @Str_Vacio),
						isnull(clc.Cli_Entida, @Str_Vacio),
						isnull(clc.Cli_Calle, @Str_Vacio),
						isnull(clc.Cli_CalNum, @Str_Vacio),
						isnull(clc.Cli_Coloni, @Str_Vacio),
						clc.ClClientID,
						clc.Cli_Status,
						uni.Clu_Grupo,
						Nac_NivAut
				from 	#AuxCientesPersonas noholdlock
						inner join CLCLIENT clc noholdlock on clc.ClClientID = ClientePersonaID
						left join CLADICIO cla noholdlock on ClientePersonaID = cla.ClClientID 
						left join CLCONTRA con noholdlock on ClientePersonaNum =  Con_Client
						left join CLCLIUNI uni noholdlock on ClientePersonaNum = uni.Clu_Client
						left join CLCLIENT clu noholdlock on clu.Cli_Numero = uni.Clu_Grupo
						left join CLNIAUCL niv noholdlock on Nac_CliUni = clu.ClClientID and Nac_TipPer = (case 
								when clc.Cli_Tipo = @Str_Uno then 1
								when clc.Cli_Tipo in (@Str_Dos, @Str_Tres) and clc.Cli_ActEmp = @Sta_Si then 3
								else 2
								end)
				where 	clc.Cli_Status = @Cli_StaS
				and 	Nac_NivAut <> @Ent_Ocho
				
			--se crea indice para la tabla
			create nonclustered index CPNumero on #CientesPersonas ( Per_Numero )
			
			--se actualiza el campo Per_Calle de los registros con la direccion completa
			update #CientesPersonas set  
				Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
							rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
							Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
			from #CientesPersonas noholdlock
					left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
	
			--se actualiza el campo de clasificacion
			update #CientesPersonas set 
					Cli_TieCla = @Sta_Si
			from 	#CientesPersonas noholdlock
					inner join CLCLACLI noholdlock on  Cli_ID = Clc_Client
			where	Clc_Clasif = @Per_ClaCom
			
			--se borran los que no tengan clasificacion
			delete from #CientesPersonas 
			where	Cli_TieCla = @Str_Vacio

		end 
			
		-- se limpian las tablas auxiliares para buscar a las personas
		truncate table #AuxCientesPersonas

		if (@Per_RFC != @Str_Vacio) begin	------------- Busqueda por RFC

			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)		
			select	top 50		
					PerPersoID, Per_Numero, max(FechaSis) FechaSis
				from 	SOPERSON noholdlock
				where	Per_RFC = @Per_RFC
				group by Per_Comple, Per_RFC 

		end else begin			------------- Busqueda por nombre cliente/persona
		
			insert into #AuxCientesPersonas(ClientePersonaID,ClientePersonaNum,FechaSis)		
			select	top 50		
					PerPersoID, Per_Numero, max(FechaSis) FechaSis
				from 	SOPERSON noholdlock
				where	Per_Comple like @Per_Comple
				group by Per_Comple, Per_RFC

		end

		--solo si regreso resultados continua con las consultas de cliente
		select @Conteo = count(*) from #AuxCientesPersonas noholdlock
		if @Conteo > @Ent_Cero begin  
	
			--Se inserta al prospecto
			insert into #CientesPersonas(
				Per_Numero,		Per_NumTra,		Per_Titulo,		Per_ComOrd,		Per_Nacion,	
				Per_RFC,		Per_Calle,		Per_Tipo, 		Per_Nombre, 	Per_ApePat,	
				Per_ApeMat,		Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde,		Adi_NumIde,	
				Per_NumPer,		Per_CURP,		Cli_TieCla,		Cli_Locali,		Cli_Entida,
				Cli_Calle,		Cli_CalNum,		Cli_Coloni,		Cli_ID,			Cli_Status,
				Cli_Unico,		Nac_NivAut
			)
			select	
				Per_Numero,
				@Str_Prospe as Per_NumTra,
				@Tip_Fisica as Per_Titulo,
				Per_ComOrd,					
				Per_Nacion,
				isnull(Per_RFC, @Str_Vacio),
				@Str_Vacio,
				case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
				end,
				case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
				end,
				isnull(Per_ApePat, @Str_Vacio),
				isnull(Per_ApeMat, @Str_Vacio),
				isnull(Clp_TipSoc, @Str_Vacio),
				isnull(Adi_FecNac, @Fec_Vacia),
				isnull(Adi_TipIde, @Str_Vacio),
				isnull(Adi_NumIde, @Str_Vacio),
				Per_Numero,
				isnull(Per_CURP, @Str_Vacio),
				@Str_Vacio,
				isnull(Per_Locali, @Str_Vacio),
				isnull(Per_Entida, @Str_Vacio),
				isnull(Per_Calle, @Str_Vacio),
				isnull(Per_CalNum, @Str_Vacio),
				isnull(Per_Coloni, @Str_Vacio),
				PerPersoID,
				@Str_Vacio,
				@Str_Vacio,
				@Ent_Cero
			from #AuxCientesPersonas noholdlock
				inner join SOPERSON noholdlock on PerPersoID  = ClientePersonaID
				inner join SOPERADI noholdlock on ClientePersonaNum = Adi_PerNum
				left join SOCLCAPE noholdlock on ClientePersonaNum  = Clp_NumPer
			
			--se actualiza el campo Per_Calle con la info faltante de entidad y localidad
			update #CientesPersonas set  
				Per_Calle = (CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
							rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
							Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END)
			from #CientesPersonas noholdlock
					inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero

		end
	end
	
	--Si llega a dejar vacio el Per_Calle donde va la direccion se vuelve a actualizar
	update #CientesPersonas set  
		Per_Calle = @Sin_Direcc
	where Per_Calle = @Str_Vacio
	
	select	distinct
			Per_Numero, 	Per_NumTra, 	Per_Titulo, 	Per_ComOrd, 	Per_RFC, 
			Per_Calle, 		Per_Tipo, 		Per_Nombre, 	Per_ApePat, 	Per_ApeMat, 
			Per_RazSoc, 	Adi_FecNac, 	Adi_TipIde, 	Adi_NumIde, 	Per_Nacion,
			Per_NumPer, 	Per_CURP,		Cli_Status,		Cli_Unico,		Nac_NivAut
	from  #CientesPersonas noholdlock
			
	drop table #CientesPersonas
	drop table #AuxCientesPersonas
			
end 
	