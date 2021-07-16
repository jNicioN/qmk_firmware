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
		@Par_FecSuc smalldatetime

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Porcen	char(1),
		@Str_Coma	char(1),
		@Str_Prospe	varchar(25),
		@Sta_Si		char(1),
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Ent_Tres	int,
		@Ent_Cinco	int,
		@Ent_Ocho	int,
		@Tip_Moral	char(1),
		@Tip_Fisica	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Per_RFCSH	varchar(15),
		@Sin_Direcc varchar(50),
		@Sta_Termin char(1),
		@Str_Usuari varchar(10),
		@Str_L		char(1),
		@Str_CuaCer	char(4),
		@Cla_Banreg	int,
		@Cue_HeyBiz	char(2),
		@Cue_CashBa	char(2)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Str_Porcen	= '%',			-- String Porcentaje
		@Str_Coma	= ',',			-- String Coma
		@Str_Prospe	= 'PROSPECTO',	-- String Prospecto
		@Sta_Si		= 'S',			-- Status : Si
		@Ent_Uno	= 1,			-- Entero : 1
		@Ent_Dos	= 2,			-- Entero : 2
		@Ent_Tres	= 3,			-- Entero : 3
		@Ent_Cinco	= 5,			-- Entero : 5
		@Ent_Ocho	= 8,			-- Entero : 8
		@Tip_Moral	= '1',			-- Tipo de Persona Moral
		@Tip_Fisica	= '2',			-- Tipo de Persona Fisica
		@Str_Uno	= '1',
		@Str_Dos	= '2',
		@Str_Tres	= '3',
		@Sin_Direcc = 'Sin Direcci&oacuten',
		@Sta_Termin	= 'T',			-- Status de Terminado
		@Str_Usuari = 'USUARIO',		-- String Usuario
		@Str_L		= 'L',
		@Str_CuaCer	= '0000',		/* String: cuatro ceros */
		@Cla_Banreg = 2,			/* Clasificacion: Banregio */
		@Cue_HeyBiz = '47',			/* Tipo de Cuenta: Cashback */
		@Cue_CashBa = '31'			/* Tipo de Cuenta: Cashback */
		
select	@Busqueda	= @Per_Comple
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Str_L begin
	select	@Per_Comple	= ltrim(rtrim(@Per_Comple)) + @Str_Porcen
	
	if @Tip_ConCon = @Str_Uno begin /* LA - busqueda de personas-apertura nueva cuenta-sibamex3 solo Adi_ApeSuc='S' */
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin--Busqueda por numero de cliente/persona 
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end

			select	Cli_Numero as Per_Numero,
					Cli_Numero as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion,
					Cli_RFC as Per_RFC,
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre as Per_Calle,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(con.Con_FeEsCl, cla.Adi_FecNac)
					else
						cla.Adi_FecNac
					end as Adi_FecNac,
					con.Con_TipIde as Adi_TipIde,

					con.Con_NumIde as Adi_NumIde,
					cla.Adi_NumPer as Per_NumPer,
					Cli_CURP as Per_CURP,
					@Str_Vacio as Cli_TieCla
					into #ClientesPorNumeroCliente
			from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
					left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
			where	Cli_Numero = @Busqueda and Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti)
			
			update #ClientesPorNumeroCliente set 
				Cli_TieCla = @Sta_Si
			from #ClientesPorNumeroCliente
			inner join CHCUENTA noholdlock on Per_Numero = Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo   =  Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc  =  Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesPorNumeroCliente
			where	Cli_TieCla = @Str_Vacio
			
			--Obtener las personas por el numero
			select	Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasPorNumeroPersona
				from SOPERSON noholdlock
				where	Per_Numero	= @Busqueda
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC, 					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum 
					+ @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle,
					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		@Str_Vacio as Clp_TipSoc, @Str_Vacio as Clp_NomSoc,  per.Per_Nacion,
					Per_CURP
				into #PersonaPorNumeroPersona
				from #PersonasPorNumeroPersona per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum					
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
				select Per_Numero,	Per_ComOrd,	Per_RFC, Per_Calle ,					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc,  Clp_NomSoc,  Per_Nacion,
					'' as DaP_CoVeDi,		Per_CURP
				into #PersonaNumeroPersona
				from #PersonaPorNumeroPersona

			--Agrupar Clientes y Personas por numero 			
			select	Per_Numero, Per_NumTra, Per_Titulo, Per_ComOrd, Per_RFC, 
					Per_Calle, Per_Tipo, Per_Nombre, Per_ApePat, Per_ApeMat, 
					Per_RazSoc, Adi_FecNac, Adi_TipIde, Adi_NumIde, Per_Nacion,
					Per_NumPer, Per_CURP
			  from  #ClientesPorNumeroCliente
			union all
			select distinct Per_Numero, @Str_Prospe as Per_NumTra, 
					@Tip_Fisica as Per_Titulo, 
					Per_ComOrd, Per_RFC, Per_Calle, Per_Tipo, Per_Nombre, 
					Per_ApePat, Per_ApeMat, @Str_Vacio as Per_RazSoc, Adi_FecNac, 
					Adi_TipIde, Adi_NumIde, Per_Nacion, Per_Numero as Per_NumPer, Per_CURP
			  from  #PersonaNumeroPersona
				
					
			drop table #PersonasPorNumeroPersona
			drop table #PersonaPorNumeroPersona
			drop table #ClientesPorNumeroCliente
			drop table #PersonaNumeroPersona
			
		end else begin-- Busqueda por nombre cliente/persona
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Cinco begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 4 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return 1
			end
			
			--Se busca al cliente por el nombre
			select	Cli_Numero,	Cli_ComOrd,	Cli_RFC,	Cli_Calle,	Cli_CalNum,
					Cli_Coloni,	Cli_Locali,	Cli_Entida,	Cli_Tipo,	Cli_ActEmp,
					Cli_Nombre,	Cli_ApePat,	Cli_ApeMat,	Adi_FecNac,	Con_NomSoc,
					Con_TipSoc,	Con_FeEsCl,	Con_TipIde,	Con_NumIde, Adi_NumPer as Per_NumPer,
					Cli_CURP,	
					@Str_Vacio as Cli_TieCla
				into #ClientesAperturaSucursal
				from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
				where	Cli_SucAti = isnull(@Suc_Numero,Cli_SucAti) and Cli_Comple	like @Per_Comple
			--@Per_ClaCom
			update #ClientesAperturaSucursal set 
				Cli_TieCla = @Sta_Si
			from #ClientesAperturaSucursal
			inner join CHCUENTA noholdlock on Cli_Numero = Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo =   Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc  =  Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesAperturaSucursal
			where	Cli_TieCla = @Str_Vacio

			select	Cli_Numero as Per_Numero,
					Cli_Numero + space(@Ent_Uno) as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion, 
					Cli_RFC as Per_RFC,

					(CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle ,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_FeEsCl, Adi_FecNac)
					else
						Adi_FecNac
					end as Adi_FecNac,
					Con_TipIde as Adi_TipIde,
					Con_NumIde as Adi_NumIde,
					cli.Per_NumPer,
					cli.Cli_CURP as Per_CURP
				into #ClientesProspectosApertura
				from #ClientesAperturaSucursal cli
					inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--Se busca se a la persona por el nombre
			select	Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasRecientesApertura
				from SOPERSON noholdlock
				where	Per_Comple	like @Per_Comple
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC,	Per_Calle,	Per_CalNum,
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc, Clp_NomSoc,  per.Per_Nacion, Per_CURP 
				into #PersonaAperturaSucursal
				from #PersonasRecientesApertura per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum
					left join SOCLCAPE cla noholdlock on spe.Per_Numero =  Clp_NumPer
			
			--Se inserta al prospecto
			insert into #ClientesProspectosApertura
			select	Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					Per_RFC,
					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum + @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre  ELSE @Sin_Direcc END) as Per_Calle ,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
					end as Per_Tipo,
					case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
					end as Per_Nombre,
					Per_ApePat,
					Per_ApeMat,
					isnull(Clp_TipSoc, @Str_Vacio) as Per_RazSoc,
					Adi_FecNac,
					Adi_TipIde,
					Adi_NumIde,
					Per_Numero as Per_NumPer,
					Per_CURP
				from #PersonaAperturaSucursal
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
			
			select	distinct
					Per_Numero,	Per_NumTra,	Per_Titulo,	Per_ComOrd,	Per_RFC,
					Per_Calle,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_RazSoc,	Adi_FecNac,	Adi_TipIde,	Adi_NumIde, Per_Nacion, 
					Per_NumPer, Per_CURP
				from #ClientesProspectosApertura
				
			drop table #ClientesProspectosApertura
			drop table #ClientesAperturaSucursal
			drop table #PersonaAperturaSucursal
			drop table #PersonasRecientesApertura
		end
		
	end else if @Tip_ConCon = @Str_Dos begin -- Busqueda sin filtro de sucursal, con minimo 8 caracteres para busqueda por nombre y solo dia de hoy. ( BD PRODUCCION)
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		
		--Se obtiene la fecha actual de la sucursal
		select	@Par_FecSuc	= Par_FecAct
		from SOPARAMS noholdlock
		where	Par_Sucurs	= @Suc_Numero
		
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin--Busqueda por numero de cliente/persona 
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end

			select	top 50 
					Cli_Numero as Per_Numero,
					Cli_Numero as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion,
					Cli_RFC as Per_RFC,
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre as Per_Calle,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(con.Con_FeEsCl, cla.Adi_FecNac)
					else
						cla.Adi_FecNac
					end as Adi_FecNac,
					con.Con_TipIde as Adi_TipIde,

					con.Con_NumIde as Adi_NumIde,
					cla.Adi_NumPer as Per_NumPer,
					Cli_CURP as Per_CURP,
					@Str_Vacio as Cli_TieCla
					into #ClientesPorNumeroCliente2
			from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
					left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
			where	Cli_Numero = @Busqueda 
			and 	Cli_Fecha >= @Par_FecSuc
			
			update #ClientesPorNumeroCliente2 set 
				Cli_TieCla = @Sta_Si
			from #ClientesPorNumeroCliente2
			inner join CHCUENTA noholdlock on Per_Numero = Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo   =  Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc  =  Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesPorNumeroCliente2
			where	Cli_TieCla = @Str_Vacio
			
			--Obtener las personas por el numero
			select	top 50 
					Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasPorNumeroPersona2
				from SOPERSON noholdlock
				where	Per_Numero	= 	@Busqueda 
				and 	Per_Fecha 	>= 	@Par_FecSuc
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC, 					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum 
					+ @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle,
					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		@Str_Vacio as Clp_TipSoc, @Str_Vacio as Clp_NomSoc,  per.Per_Nacion,
					Per_CURP
				into #PersonaPorNumeroPersona2
				from #PersonasPorNumeroPersona2 per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum					
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
				select Per_Numero,	Per_ComOrd,	Per_RFC, Per_Calle ,					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc,  Clp_NomSoc,  Per_Nacion,
					'' as DaP_CoVeDi,		Per_CURP
				into #PersonaNumeroPersona2
				from #PersonaPorNumeroPersona2

			--Agrupar Clientes y Personas por numero 			
			select	Per_Numero, Per_NumTra, Per_Titulo, Per_ComOrd, Per_RFC, 
					Per_Calle, Per_Tipo, Per_Nombre, Per_ApePat, Per_ApeMat, 
					Per_RazSoc, Adi_FecNac, Adi_TipIde, Adi_NumIde, Per_Nacion,
					Per_NumPer, Per_CURP
			  from  #ClientesPorNumeroCliente2
			union all
			select distinct Per_Numero, @Str_Prospe as Per_NumTra, 
					@Tip_Fisica as Per_Titulo, 
					Per_ComOrd, Per_RFC, Per_Calle, Per_Tipo, Per_Nombre, 
					Per_ApePat, Per_ApeMat, @Str_Vacio as Per_RazSoc, Adi_FecNac, 
					Adi_TipIde, Adi_NumIde, Per_Nacion, Per_Numero as Per_NumPer, Per_CURP
			  from  #PersonaNumeroPersona2
				
			drop table #PersonasPorNumeroPersona2
			drop table #PersonaPorNumeroPersona2
			drop table #ClientesPorNumeroCliente2
			drop table #PersonaNumeroPersona2
			
		end else begin-- Busqueda por nombre cliente/persona
		
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			
			--Se busca al cliente por el nombre
			select	top 50 
					Cli_Numero,	Cli_ComOrd,	Cli_RFC,	Cli_Calle,	Cli_CalNum,
					Cli_Coloni,	Cli_Locali,	Cli_Entida,	Cli_Tipo,	Cli_ActEmp,
					Cli_Nombre,	Cli_ApePat,	Cli_ApeMat,	Adi_FecNac,	Con_NomSoc,
					Con_TipSoc,	Con_FeEsCl,	Con_TipIde,	Con_NumIde, Adi_NumPer as Per_NumPer,
					Cli_CURP,	
					@Str_Vacio as Cli_TieCla
				into #ClientesAperturaSucursal2
				from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
				where	Cli_Comple	like @Per_Comple
				and 	Cli_Fecha 	>= 	@Par_FecSuc 
			
			--se crea indice para ClientesAperturaSucursal2
			create unique nonclustered index CAS2client on #ClientesAperturaSucursal2(Cli_Numero)
				
			--@Per_ClaCom
			update #ClientesAperturaSucursal2 set 
				Cli_TieCla = @Sta_Si
			from #ClientesAperturaSucursal2
			inner join CHCUENTA noholdlock on Cli_Numero	= Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo		= Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc	= Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesAperturaSucursal2
			where	Cli_TieCla = @Str_Vacio

			select	Cli_Numero as Per_Numero,
					Cli_Numero + space(@Ent_Uno) as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion, 
					Cli_RFC as Per_RFC,

					(CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle ,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_FeEsCl, Adi_FecNac)
					else
						Adi_FecNac
					end as Adi_FecNac,
					Con_TipIde as Adi_TipIde,
					Con_NumIde as Adi_NumIde,
					cli.Per_NumPer,
					cli.Cli_CURP as Per_CURP
				into #ClientesProspectosApertura2
				from #ClientesAperturaSucursal2 cli
					inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--Se busca se a la persona por el nombre
			select	top 50 
					Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasRecientesApertura2
				from SOPERSON noholdlock
				where	Per_Comple	like @Per_Comple
				and 	Per_Fecha 	>= 	@Par_FecSuc
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC,	Per_Calle,	Per_CalNum,
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc, Clp_NomSoc,  per.Per_Nacion, Per_CURP 
				into #PersonaAperturaSucursal2
				from #PersonasRecientesApertura2 per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum
					left join SOCLCAPE cla noholdlock on spe.Per_Numero =  Clp_NumPer
			
			--Se inserta al prospecto
			insert into #ClientesProspectosApertura2
			select	Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					Per_RFC,
					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum + @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre  ELSE @Sin_Direcc END) as Per_Calle ,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
					end as Per_Tipo,
					case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
					end as Per_Nombre,
					Per_ApePat,
					Per_ApeMat,
					isnull(Clp_TipSoc, @Str_Vacio) as Per_RazSoc,
					Adi_FecNac,
					Adi_TipIde,
					Adi_NumIde,
					Per_Numero as Per_NumPer,
					Per_CURP
				from #PersonaAperturaSucursal2
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
			select	distinct top 50
					Per_Numero,	Per_NumTra,	Per_Titulo,	Per_ComOrd,	Per_RFC,
					Per_Calle,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_RazSoc,	Adi_FecNac,	Adi_TipIde,	Adi_NumIde, Per_Nacion, 
					Per_NumPer, Per_CURP
				from #ClientesProspectosApertura2
				
			drop table #ClientesProspectosApertura2
			drop table #ClientesAperturaSucursal2
			drop table #PersonaAperturaSucursal2
			drop table #PersonasRecientesApertura2
		end
		
	
	end else if @Tip_ConCon = @Str_Tres begin -- Busqueda sin filtro de sucursal, con minimo 8 caracteres para busqueda por nombre ( BD REPORTES )
		select	@Suc_Numero = ltrim(rtrim(@Per_Numero))
		
		if ISNUMERIC(@Busqueda) = @Ent_Uno begin--Busqueda por numero de cliente/persona 
			if char_length(ltrim(rtrim(@Busqueda))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'El número de cliente debe ser de 8 digitos',
						Err_Variab	= 'Per_Comple'
				return @Ent_Uno
			end
			if char_length(ltrim(rtrim(@Busqueda))) > @Ent_Ocho begin
				select	@Busqueda = substring(@Busqueda,@Ent_Uno,@Ent_Ocho)
			end

			select	top 50 
					Cli_Numero as Per_Numero,
					Cli_Numero as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion,
					Cli_RFC as Per_RFC,
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre as Per_Calle,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(con.Con_FeEsCl, cla.Adi_FecNac)
					else
						cla.Adi_FecNac
					end as Adi_FecNac,
					con.Con_TipIde as Adi_TipIde,

					con.Con_NumIde as Adi_NumIde,
					cla.Adi_NumPer as Per_NumPer,
					Cli_CURP as Per_CURP,
					@Str_Vacio as Cli_TieCla
					into #ClientesPorNumeroCliente3
			from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
					left join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
			where	Cli_Numero = @Busqueda
			
			update #ClientesPorNumeroCliente3 set 
				Cli_TieCla = @Sta_Si
			from #ClientesPorNumeroCliente3
			inner join CHCUENTA noholdlock on Per_Numero = Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo   =  Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc  =  Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesPorNumeroCliente3
			where	Cli_TieCla = @Str_Vacio
			
			--Obtener las personas por el numero
			select	top 50 
					Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasPorNumeroPersona3
				from SOPERSON noholdlock
				where	Per_Numero	= @Busqueda
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC, 					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum 
					+ @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle,
					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		@Str_Vacio as Clp_TipSoc, @Str_Vacio as Clp_NomSoc,  per.Per_Nacion,
					Per_CURP
				into #PersonaPorNumeroPersona3
				from #PersonasPorNumeroPersona3 per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum					
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
				select Per_Numero,	Per_ComOrd,	Per_RFC, Per_Calle ,					
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc,  Clp_NomSoc,  Per_Nacion,
					'' as DaP_CoVeDi,		Per_CURP
				into #PersonaNumeroPersona3
				from #PersonaPorNumeroPersona3

			--Agrupar Clientes y Personas por numero 			
			select	Per_Numero, Per_NumTra, Per_Titulo, Per_ComOrd, Per_RFC, 
					Per_Calle, Per_Tipo, Per_Nombre, Per_ApePat, Per_ApeMat, 
					Per_RazSoc, Adi_FecNac, Adi_TipIde, Adi_NumIde, Per_Nacion,
					Per_NumPer, Per_CURP
			  from  #ClientesPorNumeroCliente3
			union all
			select distinct Per_Numero, @Str_Prospe as Per_NumTra, 
					@Tip_Fisica as Per_Titulo, 
					Per_ComOrd, Per_RFC, Per_Calle, Per_Tipo, Per_Nombre, 
					Per_ApePat, Per_ApeMat, @Str_Vacio as Per_RazSoc, Adi_FecNac, 
					Adi_TipIde, Adi_NumIde, Per_Nacion, Per_Numero as Per_NumPer, Per_CURP
			  from  #PersonaNumeroPersona3
				
			drop table #PersonasPorNumeroPersona3
			drop table #PersonaPorNumeroPersona3
			drop table #ClientesPorNumeroCliente3
			drop table #PersonaNumeroPersona3
			
		end else begin-- Busqueda por nombre cliente/persona
			if char_length(ltrim(rtrim(@Per_Comple))) < @Ent_Ocho begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Se requieren mínimo 8 letras para obtener resultados',
						Err_Variab	= 'Per_Comple'
				return 1
			end
			
			--Se busca al cliente por el nombre
			select	top 50 
					Cli_Numero,	Cli_ComOrd,	Cli_RFC,	Cli_Calle,	Cli_CalNum,
					Cli_Coloni,	Cli_Locali,	Cli_Entida,	Cli_Tipo,	Cli_ActEmp,
					Cli_Nombre,	Cli_ApePat,	Cli_ApeMat,	Adi_FecNac,	Con_NomSoc,
					Con_TipSoc,	Con_FeEsCl,	Con_TipIde,	Con_NumIde, Adi_NumPer as Per_NumPer,
					Cli_CURP,	
					@Str_Vacio as Cli_TieCla
				into #ClientesAperturaSucursal3
				from CLCLIENT clc noholdlock
					left join CLADICIO cla noholdlock on Cli_Numero = Adi_Client
					left join CLCONTRA con noholdlock on Cli_Numero =  Con_Client
				where Cli_Comple like @Per_Comple
				
			--se crea indice para ClientesAperturaSucursal3
			create unique nonclustered index CAS3client on #ClientesAperturaSucursal3(Cli_Numero)
				
			--@Per_ClaCom
			update #ClientesAperturaSucursal3 set 
				Cli_TieCla = @Sta_Si
			from #ClientesAperturaSucursal3
			inner join CHCUENTA noholdlock on Cli_Numero = Cue_Client
			inner join SOPRTICU noholdlock on Cue_Tipo 	 = Ptc_TipCue
			inner join SOCLAPRO noholdlock on Ptc_Produc = Clp_Produc 
			where	Clp_Clasif  = @Per_ClaCom
			  and	Cue_Tipo not in  (@Cue_CashBa)
			
			delete from #ClientesAperturaSucursal3
			where	Cli_TieCla = @Str_Vacio

			select	Cli_Numero as Per_Numero,
					Cli_Numero + space(@Ent_Uno) as Per_NumTra,
					cast(@Ent_Uno as varchar) as Per_Titulo,
					Cli_ComOrd as Per_ComOrd,
					space(@Ent_Tres) as Per_Nacion, 
					Cli_RFC as Per_RFC,

					(CASE when (Cli_Calle <> @Str_Vacio and  Cli_CalNum <> @Str_Vacio and Cli_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Cli_Calle)) + @Str_Coma + space(@Ent_Uno) + Cli_CalNum + @Str_Coma + space(@Ent_Uno) + Cli_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre ELSE @Sin_Direcc END) as Per_Calle ,
					case when Cli_Tipo = @Tip_Fisica and Cli_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Cli_Tipo
					end as Per_Tipo,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_NomSoc, @Str_Vacio)
					else
						Cli_Nombre
					end as Per_Nombre,
					isnull(Cli_ApePat, @Str_Vacio) as Per_ApePat,
					isnull(Cli_ApeMat, @Str_Vacio) as Per_ApeMat,
					isnull(Con_TipSoc, @Str_Vacio) as Per_RazSoc,
					case when Cli_Tipo = @Tip_Moral then
						isnull(Con_FeEsCl, Adi_FecNac)
					else
						Adi_FecNac
					end as Adi_FecNac,
					Con_TipIde as Adi_TipIde,
					Con_NumIde as Adi_NumIde,
					cli.Per_NumPer,
					cli.Cli_CURP as Per_CURP
				into #ClientesProspectosApertura3
				from #ClientesAperturaSucursal3 cli
					inner join CLLOCALI noholdlock on Cli_Locali = Loc_Numero
					inner join CLENTIDA noholdlock on Cli_Entida = Ent_Numero
					
					--Se busca se a la persona por el nombre
			select	top 50 
					Per_Comple, Per_RFC,  Per_Nacion ,	max(FechaSis) FechaSis
				into #PersonasRecientesApertura3
				from SOPERSON noholdlock
				where	Per_Comple	like @Per_Comple
				group by Per_Comple,	Per_RFC

			select	spe.Per_Numero,	Per_ComOrd,	spe.Per_RFC,	Per_Calle,	Per_CalNum,
					Per_Coloni,		Per_Locali,	Per_Entida,	Per_Tipo,	Per_ActEmp,
					Per_Nombre,		Per_ApePat,	Per_ApeMat,	Adi_FecNac,	Adi_TipIde,
					Adi_NumIde,		Clp_TipSoc, Clp_NomSoc,  per.Per_Nacion, Per_CURP 
				into #PersonaAperturaSucursal3
				from #PersonasRecientesApertura3 per
					inner join SOPERSON spe noholdlock on per.Per_Comple = spe.Per_Comple and per.Per_RFC = spe.Per_RFC and per.FechaSis = spe.FechaSis
					inner join SOPERADI spa noholdlock on spe.Per_Numero = Adi_PerNum
					left join SOCLCAPE cla noholdlock on spe.Per_Numero =  Clp_NumPer
			
			--Se inserta al prospecto
			insert into #ClientesProspectosApertura3
			select	Per_Numero,
					@Str_Prospe as Per_NumTra,
					@Tip_Fisica as Per_Titulo,
					Per_ComOrd,					
					Per_Nacion,
					Per_RFC,
					
					(CASE when (Per_Calle <> @Str_Vacio and  Per_CalNum <> @Str_Vacio and Per_Coloni <> @Str_Vacio) THEN 
					rtrim(ltrim(Per_Calle)) + @Str_Coma + space(@Ent_Uno) + Per_CalNum + @Str_Coma + space(@Ent_Uno) + Per_Coloni + @Str_Coma + space(@Ent_Uno) +
					Loc_Nombre + @Str_Coma + space(@Ent_Uno) + Ent_Nombre  ELSE @Sin_Direcc END) as Per_Calle ,
					case when Per_Tipo = @Tip_Fisica and Per_ActEmp = @Sta_Si then
						@Str_Tres
					else
						Per_Tipo
					end as Per_Tipo,
					case when Per_Tipo = @Tip_Moral then
						isnull(Clp_NomSoc, @Str_Vacio)
					else
						Per_Nombre
					end as Per_Nombre,
					Per_ApePat,
					Per_ApeMat,
					isnull(Clp_TipSoc, @Str_Vacio) as Per_RazSoc,
					Adi_FecNac,
					Adi_TipIde,
					Adi_NumIde,
					Per_Numero as Per_NumPer,
					Per_CURP
				from #PersonaAperturaSucursal3
					left join CLLOCALI noholdlock on Per_Locali = Loc_Numero
					left join CLENTIDA noholdlock on Per_Entida = Ent_Numero
					
			select	distinct top 50
					Per_Numero,	Per_NumTra,	Per_Titulo,	Per_ComOrd,	Per_RFC,
					Per_Calle,	Per_Tipo,	Per_Nombre,	Per_ApePat,	Per_ApeMat,
					Per_RazSoc,	Adi_FecNac,	Adi_TipIde,	Adi_NumIde, Per_Nacion, 
					Per_NumPer, Per_CURP
				from #ClientesProspectosApertura3
				
			drop table #ClientesProspectosApertura3
			drop table #ClientesAperturaSucursal3
			drop table #PersonaAperturaSucursal3
			drop table #PersonasRecientesApertura3
		end
		
	end
end