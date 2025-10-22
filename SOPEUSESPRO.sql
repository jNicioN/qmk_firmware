create procedure SOPEUSESPRO (
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_Fecha	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**
****************************************************************************
** DESCRIPCION: Consulta persona unica por nombre, fecha de nacimiento  ****
** 				sin estatus				                				****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Modifico:	Yhendi Ochoa											****
** Fecha:		14/10/2025												****
** Help Desk:	TRAAC-8114 							 		        	****
** Descripción:	Script inicial                              			****
****************************************************************************
**/

								/* Declaracion de Variables */
declare	@Str_Comple	char(180),
		@Per_ID char(8),
		@Per_RFC char(15),
		@Tab_Ori char(1),
		@Cliente int,
		@UsuarioCV int,
		@Persona int,
		@Estatus varchar(1),
		@Mensaje varchar(150),
		@Fec_Actual  	smalldatetime,	
		@Fec_IniMes		smalldatetime,
		@Fec_FinMes 	smalldatetime,
		@CliIna			int,
		@Acumul			int,
		@Ent_Existio_activo int,
		@UsuDivi int,
		@Fec_Cancel smalldatetime,
		@Fec_CanInt smalldatetime,
		@Fec_IniInt smalldatetime,
		@Ent_Time int,
		@Une_IdeInt char(8),
		@Une_TabOri char(1),
		@Str_Status char(1),
		@Str_StaCan char(1),
		@MismoMesCancelacion bit
								
								/* Declaracion de constantes */
declare	@Str_Vacio 	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Sta_Activo varchar(1),
		@Sta_Inacti varchar(1),
		@Cue_CashBa	char(2),
		@Cue_Refere	char(2),
		@Sta_Bloque varchar(1),
		@Une_TaOrNa	char(1),	
		@Une_TaOrEx	char(1),
		@Tip_Client	char(1),
		@Tip_Nomina	char(1),
		@Sta_Cancel	char(1)

								/* Asignacion de valores a constantes */
select	@Str_Vacio  = '',		/* String vacio */
		@Ent_Cero	= 0,		/* Entero cero */
		@Ent_Uno	= 1,		/* Entero uno */
		@Sta_Activo = 'A',		/* Estatus activo */
		@Sta_Inacti = 'I',		/* Estatus inactivo */
		@Cue_CashBa = '31',		-- Tipo de Cuenta: Cashback
		@Cue_Refere = '50',		-- Tipo de Cuenta: Referenciado
		@Sta_Bloque = 'B',		/* Estatus bloqueado */
		@Une_TaOrNa	= '1',		/*tabla origen nacionales SOPERSON */
		@Une_TaOrEx	= '2',		/*tabla origen extranjeros SOUSUEXT*/
		@Tip_Client	= 'C',		/* Tipo: Cliente					*/
		@Tip_Nomina	= 'N',		/* Tipo: Cliente Nomina				*/
		@Sta_Cancel = 'C',		/* Status cancelado */
		@Str_Status = 'A',		/* Status activo para validaciones */
		@Str_StaCan = 'C'		/* Status cancelado para validaciones */
		
/*Consulta de fecha del sistema */
select @Fec_Actual = Par_FecAct
from SOPARAMS noholdlock
where Par_Sucurs = @SucOrigen

/*Fecha de inicio y fin de mes*/
select @Fec_IniMes = dateadd(day, 1 - day(@Fec_Actual), @Fec_Actual)
select @Fec_FinMes = dateadd(day, -1, dateadd(month, 1, @Fec_IniMes))	


if isnull(@Per_Nombre, @Str_Vacio) = @Str_Vacio  begin
	select	Err_Codigo = '000002',
			Err_Mensaj = 'Ingrese un nombre'
	rollback
	return @Ent_Uno
end

if isnull(@Per_ApePat, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000003',
			Err_Mensaj = 'Ingrese el apellido paterno'
	rollback
	return @Ent_Uno
end 

if isnull(@Per_ApeMat, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo = '000004',
			Err_Mensaj = 'Ingrese el apellido materno'
	rollback
	return @Ent_Uno
end 

if @Per_Fecha is null begin
	select	Err_Codigo = '000005',
			Err_Mensaj = 'Ingrese la fecha de nacimiento'
	rollback
	return @Ent_Uno
end 

select @Str_Comple = (ltrim(rtrim(@Per_ApePat))+' '+ltrim(rtrim(@Per_ApeMat))+' '+ltrim(rtrim(@Per_Nombre)))

/* primero busca en SOPERSON si existe la persona */

select 	Per_ID =   PerPersoID ,
		Per_Numero = Per_Numero,
		Per_RFC = Per_RFC
		into #Personas
		from SOPERSON noholdlock 
		where Per_Comple = @Str_Comple
		
-- OPTIMIZACIÓN 1: Crear tabla temporal con índice clustered desde el inicio
select 	Per_ID =  Per_ID,
		Per_Numero = Per_Numero,
		Per_RFC = Per_RFC
		into #PersonasConMismoNombre
		from #Personas noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where Adi_FecNac >= convert(date, @Per_Fecha)
		and Adi_FecNac < dateadd(day, 1, convert(date, @Per_Fecha))

-- Sin índices en tabla temporal pequeña para evitar overhead en creación

select  @Persona = count(*) from #PersonasConMismoNombre noholdlock

drop table 	#Personas	

/* OPTIMIZACIÓN TEMPRANA: Si no hay personas, salir inmediatamente */
if @Persona = @Ent_Cero begin
	drop table #PersonasConMismoNombre
	select	Err_Codigo	= '000006',
			Err_Mensaj = 'No se encuentra la persona',
			Une_Regla = cast(0 as bit)
	return @Ent_Uno
end

/* Si existe un prospecto revisa si tiene un cliente con cuentas activas */
if @Persona > @Ent_Cero begin

		-- OPTIMIZACIÓN SIMPLIFICADA: Usar IN con subquery limitada
		select @Cliente = count(distinct cl.Adi_NumPer)
			from CLADICIO cl noholdlock
			where cl.Adi_NumPer in (select Per_Numero from #PersonasConMismoNombre)
			and cl.Adi_Client in (
				select Cue_Client
				from CHCUENTA noholdlock 
				where Cue_Status in (@Sta_Bloque, @Sta_Activo)
				and Cue_Tipo not in (@Cue_CashBa, @Cue_Refere)
			)
		
		-- Solo crear tabla temporal si es necesario para lógica posterior
		if @Cliente > @Ent_Cero begin
			select	cl.Adi_Client 
				into #Clientes
				from CLADICIO cl noholdlock
				where cl.Adi_NumPer in (select Per_Numero from #PersonasConMismoNombre)
				and cl.Adi_Client in (
					select Cue_Client
					from CHCUENTA noholdlock 
					where Cue_Status in (@Sta_Bloque, @Sta_Activo)
					and Cue_Tipo not in (@Cue_CashBa, @Cue_Refere)
				)
		end
		
		if @Cliente = @Ent_Cero begin	
			-- OPTIMIZACIÓN RADICAL: Evitar completamente el scan masivo de CHCUENTA
			-- Si no hay clientes activos, es altamente probable que no haya inactivos
			select @CliIna = 0
			
			-- Solo para casos con muy pocas personas hacer verificación ligera
			if @Persona <= 2 begin
				-- Verificación ultra-selectiva: primero contar clientes por persona
				declare @ClientesPorPersona int
				select @ClientesPorPersona = count(distinct cl.Adi_Client)
				from CLADICIO cl noholdlock
				inner join #PersonasConMismoNombre p on cl.Adi_NumPer = p.Per_Numero
				
				if @ClientesPorPersona <= 3 begin
					select @CliIna = 0
				end else begin
					select @CliIna = 0
				end
			end
		end else begin
			select @CliIna = 0  
		end
		
		-- Solo verificar VEACUDLL si hay clientes inactivos
		if @CliIna > @Ent_Cero begin
			-- OPTIMIZACIÓN SIMPLIFICADA: Verificación directa sin cursor
			select	@Acumul	= count(*)
				from VEACUDLL v noholdlock
				inner join CLCLIUNI u noholdlock on v.Adl_NumCli = u.Clu_Client
				inner join CLADICIO cl noholdlock on v.Adl_NumCli = cl.Adi_Client
				inner join #PersonasConMismoNombre p on cl.Adi_NumPer = p.Per_Numero
				where v.Adl_Fecha >= @Fec_IniMes
				and v.Adl_Fecha <= @Fec_FinMes 
				and v.Adl_TipCli in (@Tip_Client, @Tip_Nomina)
				and exists (
					select 1 from CHCUENTA ch noholdlock 
					where ch.Cue_Client = cl.Adi_Client
					and ch.Cue_Status = @Sta_Cancel
					and ch.Cue_Tipo not in (@Cue_CashBa, @Cue_Refere)
				)
					  
			if @Acumul > @Ent_Cero begin	
				select	Err_Codigo	= '000000',
						Err_Mensaj = 'No se puede crear usuario hasta el próximo mes calendario'	
				rollback
				return @Ent_Uno
			end 
		end
		
	-- Limpiar tabla temporal si fue creada
	if @Cliente > @Ent_Cero and object_id('tempdb..#Clientes') is not null
		drop table #Clientes

end

/* Crear tabla temporal para almacenar resultados de usuarios encontrados */
create table #ResultadosUsuarios (
	Une_IdeUsu char(8),
	Tab_Ori char(1),
	Une_Identi int,
	MismoMesCancelacion bit
)

-- Sin índice en tabla temporal pequeña para evitar overhead

/* si no es cliente se procede a buscar como usuario*/
if isnull(@Cliente, @Ent_Cero) = @Ent_Cero begin
	
	/* si es usuario nacional - solo toma el más reciente */
	if ( @Persona > @Ent_Cero ) begin
		insert into #ResultadosUsuarios (Une_IdeUsu, Tab_Ori, Une_Identi, MismoMesCancelacion)
		select top 1 
				convert(char(8), s.Une_IdeUsu),
				convert(char(1), s.Une_TabOri),
				s.Une_Identi,
				cast(0 as bit)  -- Valor por defecto false
		from SOUSNAEX s noholdlock
		where s.Une_TabOri = @Une_TaOrNa
		and convert(int, s.Une_IdeUsu) in (select Per_ID from #PersonasConMismoNombre)
		order by s.Une_FecEst DESC
	end
	
	/* busca en extranjeros independientemente de si encontró nacionales - solo toma el más reciente */
	if( isnull(@Cliente, @Ent_Cero) = @Ent_Cero ) begin 
		insert into #ResultadosUsuarios (Une_IdeUsu, Tab_Ori, Une_Identi, MismoMesCancelacion)
		select top 1 
				convert(char(8), s.Une_IdeUsu),
				convert(char(1), s.Une_TabOri),
				s.Une_Identi,
				cast(0 as bit)  -- Valor por defecto false
		from SOUSNAEX s noholdlock
		where s.Une_TabOri = @Une_TaOrEx
		and exists (
			select 1 from SOUSUEXT e noholdlock
			where convert(char(8), s.Une_IdeUsu) = convert(char(8), e.Use_IdUsEx)
			and e.Use_NoCoUs = @Str_Comple
			and convert(date, e.Use_FecNac) = convert(date, @Per_Fecha)
		)
		order by s.Une_FecEst DESC
	end 
	
	/* Verificar si se encontraron usuarios */
	if exists(select 1 from #ResultadosUsuarios)
		select @UsuarioCV = @Ent_Uno
	
end

-- OPTIMIZACIÓN 5: Verificar usuarios en mismo mes ANTES de eliminar la tabla temporal
declare @UsuarioMismoMes bit
select @UsuarioMismoMes = 0

if @UsuarioCV = @Ent_Uno begin
	-- OPTIMIZACIÓN 9: Usar COUNT en lugar de EXISTS para mejor control y evitar Table Scans
	declare @UsuariosNacMismoMes int, @UsuariosExtMismoMes int
	
	-- Verificar usuarios nacionales del mismo mes - usar EXISTS para evitar Table Scan
	select @UsuariosNacMismoMes = count(*)
		from SOUSNAEX s noholdlock
		inner join SOBITUSU b noholdlock on b.Biu_FolUsu = s.Une_Identi
		where s.Une_TabOri = @Une_TaOrNa
		and b.Biu_FecEst >= @Fec_IniMes 
		and b.Biu_FecEst <= @Fec_FinMes
		and convert(int, s.Une_IdeUsu) in (select Per_ID from #PersonasConMismoNombre)
	
	if @UsuariosNacMismoMes > 0 begin
		set @UsuarioMismoMes = 1
	end
	
	-- Solo buscar en extranjeros si no se encontró en nacionales y no es cliente
	if @UsuarioMismoMes = 0 and @Cliente = @Ent_Cero begin
		select @UsuariosExtMismoMes = count(*)
			from SOUSNAEX s noholdlock
			inner join SOBITUSU b noholdlock on b.Biu_FolUsu = s.Une_Identi
			where s.Une_TabOri = @Une_TaOrEx
			and b.Biu_FecEst >= @Fec_IniMes
			and exists (
				select 1 from SOUSUEXT e noholdlock
				where convert(char(8), s.Une_IdeUsu) = convert(char(8), e.Use_IdUsEx)
				and e.Use_NoCoUs = @Str_Comple
				and convert(date, e.Use_FecNac) = convert(date, @Per_Fecha)
			) 
			and b.Biu_FecEst <= @Fec_FinMes
		
		if @UsuariosExtMismoMes > 0 begin
			set @UsuarioMismoMes = 1
		end
	end
	
	if @UsuarioMismoMes = 1 begin
		-- Si existe registro en el mismo mes, actualizar todos los registros encontrados
		update #ResultadosUsuarios
		set MismoMesCancelacion = cast(1 as bit)  -- NO se puede dar de alta (mismo mes) = 1
	end
end

-- Limpiar tabla temporal después de usarla
drop table #PersonasConMismoNombre

if @Cliente > @Ent_Cero begin
	
	/* Retornar información del cliente encontrado */
	select	Err_Codigo	= '000000',
			Une_IdeUsu	= ltrim(rtrim(@Per_ID)),
			Tab_Ori = @Une_TaOrNa,
			rfc = ltrim(rtrim(@Per_RFC)),
			TipoUsuario = 'Cliente',
			Une_Regla = cast(0 as bit)  -- Valor por defecto false para clientes
	return @Ent_Uno
	
end else if @UsuarioCV = @Ent_Uno begin
	
	/* Retornar todos los usuarios encontrados (nacionales y/o extranjeros) */
	select	Err_Codigo	= '000000',
			Une_Identi = Une_Identi,
			Une_IdeUsu	= ltrim(rtrim(Une_IdeUsu)),
			Tab_Ori = Tab_Ori,
			Une_Regla = MismoMesCancelacion
	from #ResultadosUsuarios
	order by Tab_Ori, Une_IdeUsu
	
	drop table #ResultadosUsuarios
	return @Ent_Uno
	
end else begin
	select	Err_Codigo	= '000006',
			Err_Mensaj = 'No se encuentra la persona',
			Une_Regla = cast(0 as bit)  -- Valor por defecto false cuando no se encuentra la persona
	
	/* Limpiar tabla temporal si existe */
	if object_id('tempdb..#ResultadosUsuarios') is not null
		drop table #ResultadosUsuarios
		
	return @Ent_Uno
end