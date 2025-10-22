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
		
select 	Per_ID =  Per_ID,
		Per_Numero = Per_Numero,
		Per_RFC = Per_RFC
		into #PersonasConMismoNombre
		from #Personas noholdlock 
		inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		where convert(date, Adi_FecNac) = convert(date, @Per_Fecha)

select  @Persona = count(*) from #PersonasConMismoNombre noholdlock

drop table 	#Personas	

/* Si existe un prospecto revisa si tiene un cliente con cuentas activas */
if @Persona > @Ent_Cero begin

		select	Adi_Client 
			into #Clientes
			from #PersonasConMismoNombre noholdlock
			inner join CLADICIO noholdlock on Per_Numero = Adi_NumPer 
			inner join CHCUENTA noholdlock on Adi_Client = Cue_Client
			where	Cue_Status in (@Sta_Bloque, @Sta_Activo) 
			  and	Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
				
		select	@Cliente	= count (*) 
			from #Clientes noholdlock
		
		if @Cliente = @Ent_Cero begin	
			select	Adi_Client 
				into #ClientesInactivos
				from #PersonasConMismoNombre noholdlock
				inner join CLADICIO noholdlock on Per_Numero = Adi_NumPer 
				inner join CHCUENTA noholdlock on Adi_Client = Cue_Client
				where	Cue_Status	= @Sta_Cancel
				  and	Cue_Tipo not in  (@Cue_CashBa , @Cue_Refere)
				
			select	@CliIna	= count (*) 
				from #ClientesInactivos noholdlock
				
			if @CliIna > @Ent_Cero begin	
				select	Clu_Grupo,
						Clu_Client
					into #GrupoClientes
					from CLCLIUNI noholdlock
					inner join #ClientesInactivos on Clu_Client = Adi_Client
				
				select	@Acumul	= count(*)
					from VEACUDLL noholdlock
					inner join #GrupoClientes noholdlock on Adl_Fecha >= @Fec_IniMes
					  and	Adl_Fecha	<= @Fec_FinMes and Clu_Client = Adl_NumCli
					  and	Adl_TipCli	in (@Tip_Client, @Tip_Nomina)
					  
				if @Acumul > @Ent_Cero begin	
					select	Err_Codigo	= '000000',
							Err_Mensaj = 'No se puede crear usuario hasta el próximo mes calendario'	
					rollback
					return @Ent_Uno
				end 				
		
			end
		
		end 
		
		drop table #Clientes

end

/* Crear tabla temporal para almacenar resultados de usuarios encontrados */
create table #ResultadosUsuarios (
	Une_IdeUsu char(8),
	Tab_Ori char(1),
	Une_Identi int,
	MismoMesCancelacion bit
)

/* si no es cliente se procede a buscar como usuario*/
if isnull(@Cliente, @Ent_Cero) = @Ent_Cero begin
	
	/* si es usuario nacional - solo toma el más reciente */
	if ( @Persona > @Ent_Cero ) begin
		insert into #ResultadosUsuarios (Une_IdeUsu, Tab_Ori, Une_Identi, MismoMesCancelacion)
		select convert(char(8), Une_IdeUsu),
				convert(char(1), Une_TabOri),
				Une_Identi,
				cast(0 as bit)  -- Valor por defecto false
		from #PersonasConMismoNombre noholdlock
		inner join SOUSNAEX noholdlock on convert(char(8), Une_IdeUsu) = convert(char(8), Per_ID) and convert(char(1), Une_TabOri) = convert(char(1), @Une_TaOrNa)
		order by Une_FecEst DESC
	end
	
	/* busca en extranjeros independientemente de si encontró nacionales - solo toma el más reciente */
	if( isnull(@Cliente, @Ent_Cero) = @Ent_Cero ) begin
		insert into #ResultadosUsuarios (Une_IdeUsu, Tab_Ori, Une_Identi, MismoMesCancelacion)
		select convert(char(8), Une_IdeUsu),
				convert(char(1), Une_TabOri),
				Une_Identi,
				cast(0 as bit)  -- Valor por defecto false
		from SOUSUEXT noholdlock
		inner join SOUSNAEX noholdlock on convert(char(8), Une_IdeUsu) = convert(char(8), Use_IdUsEx) and convert(char(1), Une_TabOri) = convert(char(1), @Une_TaOrEx)
		where Use_NoCoUs = @Str_Comple
		and convert(date,Use_FecNac)= convert(date, @Per_Fecha)
		order by Une_FecEst DESC
	end 
	
	/* Verificar si se encontraron usuarios */
	if exists(select 1 from #ResultadosUsuarios)
		select @UsuarioCV = @Ent_Uno
	
end

drop table #PersonasConMismoNombre

if @UsuarioCV = @Ent_Uno begin
	
	-- Inicializar el campo boolean por defecto como false (diferente mes)
	select @MismoMesCancelacion = 0
	
	-- VALIDACIÓN DIRECTA: Verificar si existe cualquier usuario con mismo nombre y fecha de nacimiento en el mes actual
	if exists (
		-- Buscar en usuarios nacionales
		select 1 
		from SOPERSON p
		inner join SOPERADI a on a.Adi_PerNum = p.Per_Numero
		inner join SOUSNAEX s on convert(char(8), s.Une_IdeUsu) = convert(char(8), p.PerPersoID) 
			and convert(char(1), s.Une_TabOri) = convert(char(1), @Une_TaOrNa)
		inner join SOBITUSU b on convert(int, b.Biu_FolUsu) = convert(int, s.Une_Identi)
		where p.Per_Comple = @Str_Comple
		and convert(date, a.Adi_FecNac) = convert(date, @Per_Fecha)
		and year(b.Biu_FecEst) = year(@Fec_Actual)
		and month(b.Biu_FecEst) = month(@Fec_Actual)
	) OR exists (
		-- Buscar en usuarios extranjeros
		select 1
		from SOUSUEXT e
		inner join SOUSNAEX s on convert(char(8), s.Une_IdeUsu) = convert(char(8), e.Use_IdUsEx) 
			and convert(char(1), s.Une_TabOri) = convert(char(1), @Une_TaOrEx)
		inner join SOBITUSU b on convert(int, b.Biu_FolUsu) = convert(int, s.Une_Identi)
		where e.Use_NoCoUs = @Str_Comple
		and convert(date, e.Use_FecNac) = convert(date, @Per_Fecha)
		and year(b.Biu_FecEst) = year(@Fec_Actual)
		and month(b.Biu_FecEst) = month(@Fec_Actual)
	) begin
		-- Si existe registro en el mismo mes, actualizar todos los registros encontrados
		update #ResultadosUsuarios
		set MismoMesCancelacion = cast(1 as bit)  -- NO se puede dar de alta (mismo mes) = 1
	end
	
end

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