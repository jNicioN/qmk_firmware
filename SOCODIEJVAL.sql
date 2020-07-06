create procedure SOCODIEJVAL
	@Fec_Hoy	smalldatetime,			-- Fecha a validar
	@Num_CoDiEj	int,					-- Flujo
	@Dia_Valido	bit output,				-- Resultado: Dia valido o no para ejecucion
	@Men_Error	varchar(200) output,	-- Mensaje de Error
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
as
/*******************************************************************************************
** Descripcion: Validacion de Configuracion de Dias de Ejecucion de Flujos y Procesos	****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		27/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Validacion de Configuracion de Dias de Ejecucion de Flujos y Procesos	****
********************************************************************************************/

--Variables
declare @Res_Ejecuc	int,			-- Resultado de Ejecucion
		@Fec_UltMes	smalldatetime,	-- Fecha Ultima del mes
		@Fec_UlMeHa	smalldatetime,	-- Fecha Ultima Habil del mes
		@Ult_DiMeHa	bit,			-- Ultimo Dia del Mes Habil Encontrado
		@Dia_SeUlMe	int,			-- Dia de la Semana del Ultimo Dia Habil
		@Hor_Actual	time,			-- Hora actual
		@Hor_ConIni	time,			-- Hora de Configuracion: Inicio
		@Hor_ConFin	time,			-- Hora de Configuracion: Fin
		@Dia_FecAct	int,			-- Dia del mes de la Fecha Hoy
		@Dia_SemAct	int,			-- Dia de la Semana Actual
		@Con_Ciclos	int,			-- Contador de Ciclos
		@Dia_ActVal	bit,			-- Dia Actual Valido, en validaciones de Dia de la Semana y Dia del Mes
		@Dia_HabReq	bit				-- Dia Habil Requerio

--Constantes
declare	@Can_Cero   tinyint,		-- Cantidad: Cero 
		@Can_Uno    tinyint,		-- Cantidad: Uno
		@Can_Diez   tinyint,		-- Cantidad: Diez
		@Bit_Si		bit,			-- Bit: Si
		@Bit_No		bit,			-- Bit: No
		@Hor_Vacia	time,			-- Hora Vacia
		@Hor_IniDia	time,			-- Hora Inicio del Dia: 00:00:00
		@Hor_FinDia	time,			-- Hora Fin del Dia: 23:59:59
		@Men_Vacio	varchar(10),	-- Mensaje Vacio
		@Dia_Doming	int,			-- Dia de la Semana: Domingo
		@Dia_Sabado	int				-- Dia de la Semana: Sabado
		

select  @Can_Cero   = 0,			-- Cantidad: Cero
		@Can_Uno    = 1,			-- Cantidad: Uno
		@Can_Diez   = 10,			-- Cantidad: Diez
		@Bit_Si		= 1,			-- Bit: Si
		@Bit_No		= 0,			-- Bit: No
		@Hor_Vacia	= '00:00:00',	-- Hora Vacia
		@Hor_IniDia	= '00:00:00',	-- Hora Inicio del Dia: 00:00:00
		@Hor_FinDia	= '23:59:59',	-- Hora Fin del Dia: 23:59:59
		@Men_Vacio	= '',			-- Mensaje Vacio
		@Dia_Doming	= 1,			-- Dia de la Semana: Domingo
		@Dia_Sabado	= 7				-- Dia de la Semana: Sabado

-- Asegurar que el primer dia de la semana sea domingo
set datefirst 7

-- Obtener Dia del Mes del Dia de Hoy
select	@Dia_FecAct = datepart(dd, @Fec_Hoy)

-- Obtener Dia de la Semana del Dia de Hoy
select @Dia_SemAct	= datepart(dw, @Fec_Hoy)

-- Al inicio no se sabe si el dia de hoy es un dia valido para ejecucion
select @Dia_Valido	= @Bit_No

-- Si se tiene configurado ejecucion de Todos los Dias, reportar que es correcto ejecutar
if @Dia_Valido	= @Bit_No begin
	if exists	(select Die_CoDiEj
					from SOCODIEJ noholdlock
					inner join SODIAEJE noholdlock
							on Die_CoDiEj	= Cde_Numero
							and Die_Activo	= @Bit_Si
					inner join SOTIDIEJ noholdlock
							on Tde_Numero	= Die_TiDiEj
							and Tde_TodDia	= @Bit_Si
							and Tde_DiaHab	= @Bit_No
							and Tde_Activo	= @Bit_Si
					where Cde_Numero	= @Num_CoDiEj
					  and Cde_Activo	= @Bit_Si) begin
		select @Dia_Valido	= @Bit_Si
	end
end

-- Si es Dia Habil y se tienen configurado ejecucion en Todos los Dias Habiles, reportar que es correcto ejecutar
if @Dia_Valido	= @Bit_No begin
	if exists	(select Die_CoDiEj
					from SOCODIEJ noholdlock
					inner join SODIAEJE noholdlock
							on Die_CoDiEj	= Cde_Numero
							and Die_Activo	= @Bit_Si
					inner join SOTIDIEJ noholdlock
							on Tde_Numero	= Die_TiDiEj
							and Tde_TodDia	= @Bit_Si
							and Tde_DiaHab	= @Bit_Si
							and Tde_Activo	= @Bit_Si
					where Cde_Numero	= @Num_CoDiEj
					  and Cde_Activo	= @Bit_Si) begin
		-- De inicio se indica que si es un dia valido
		select @Dia_Valido	= @Bit_Si
		
		-- Si es Sabado o Domingo, se indica que no es un dia valido
		if @Dia_SemAct in (@Dia_Sabado, @Dia_Doming) begin
			select @Dia_Valido	= @Bit_No
		end
		
		-- Si es un Dia Festivo, se indica que no es un dia valido
		if @Dia_Valido	= @Bit_Si begin
			select @Dia_Valido	= @Bit_No
				from SODIAFES noholdlock
				where Dfe_Fecha	= @Fec_Hoy
		end
	end
end

-- Validar si se trata de el Dia Ultimo del mes y se tiene configurado como valido.
if @Dia_Valido	= @Bit_No begin
	if exists	(select Die_CoDiEj
					from SOCODIEJ noholdlock
					inner join SODIAEJE noholdlock
							on Die_CoDiEj	= Cde_Numero
							and Die_Activo	= @Bit_Si
					inner join SOTIDIEJ noholdlock
							on Tde_Numero	= Die_TiDiEj
							and Tde_UlDiMe	= @Bit_Si
							and Tde_DiaHab	= @Bit_No
							and Tde_Activo	= @Bit_Si
					where Cde_Numero	= @Num_CoDiEj
					  and Cde_Activo	= @Bit_Si) begin
		-- Obtener Ultimo Dia el Mes
		select @Fec_UltMes	= dateadd(dd, -1, dateadd(mm, 1, convert(smalldatetime, convert(varchar(6), @Fec_Hoy, 112) + '01', 112)))
		
		-- ¿Si es el ultimo dia del mes?
		if @Fec_Hoy	= @Fec_UltMes
			select @Dia_Valido	= @Bit_Si	
	end
end

-- Validar si se trata de el Dia Ultimo Habil del mes y se tiene configurado como valido.
if @Dia_Valido	= @Bit_No begin
	if exists	(select Die_CoDiEj
					from SOCODIEJ noholdlock
					inner join SODIAEJE noholdlock
							on Die_CoDiEj	= Cde_Numero
							and Die_Activo	= @Bit_Si
					inner join SOTIDIEJ noholdlock
							on Tde_Numero	= Die_TiDiEj
							and Tde_UlDiMe	= @Bit_Si
							and Tde_DiaHab	= @Bit_Si
							and Tde_Activo	= @Bit_Si
					where Cde_Numero	= @Num_CoDiEj
					  and Cde_Activo	= @Bit_Si) begin
		-- Obtener Ultimo Dia el Mes
		select @Fec_UltMes	= dateadd(dd, -1, dateadd(mm, 1, convert(smalldatetime, convert(varchar(6), @Fec_Hoy, 112) + '01', 112)))
		
		-- Obtener el Ultimo Dia Habil del mes
		-- **Preguntar por el procedimiento que obtiene el Dia Habil Previo
		select	@Fec_UlMeHa	= @Fec_UltMes,	-- Se inicia en el dia ultimo del mes
				@Con_Ciclos	= @Can_Cero,	-- No debieran pasar mas de 4 dias para encontrar el ultimo dia del mes. Se deja margen de 10 dias.
				@Ult_DiMeHa	= @Bit_No		-- Ultimo Dia el Mes Habil Encontrado
				
		while @Ult_DiMeHa	= @Bit_No and @Con_Ciclos < @Can_Diez begin
			select @Dia_SeUlMe = datepart(dw, @Fec_UlMeHa)
						-- Si no es Fin de Semana
			if @Dia_SeUlMe	not in (@Dia_Sabado, @Dia_Doming) begin
				-- Y no es Dia Festivo, entonces se encontro el Ultimo Dia Inhabil del Mes
				if not exists (select Dfe_Fecha
								from SODIAFES noholdlock
								where Dfe_Fecha	= @Fec_UlMeHa) begin
					-- Si el dia no existe en los Dias Festivos, entonces se encontro el ultimo dia habil del mes
					select	@Ult_DiMeHa	= @Bit_Si
				end
			end
			
			--Si no se encontro el dia habil, ir al dia previo
			if @Ult_DiMeHa	= @Bit_No begin
				select	@Fec_UlMeHa	= dateadd(dd, -1, @Fec_UlMeHa),
						@Con_Ciclos	= @Con_Ciclos + @Can_Uno
			end
		end
		
		-- Si se paso la cantidad de ciclios de margen, reportar error.
		if @Con_Ciclos	>= @Can_Diez begin
			select	@Men_Error = 'No se pudo determinar el ultimo dia habil del mes. Ultimo dia revisado: ' + convert(varchar(8), @Fec_UlMeHa, 112)
			return	@Can_Uno
		end
		
		-- �Si es el ultimo dia habil del mes?
		if @Fec_Hoy	= @Fec_UlMeHa
			select @Dia_Valido	= @Bit_Si	
	end
end

-- Validar Dia de la Semana
if @Dia_Valido	= @Bit_No begin
	select @Dia_ActVal	=	@Bit_No
	-- Revisar si se tiene configurado el dia de la semana, y si se requiere que sea Dia habil
	select	@Dia_ActVal	= @Bit_Si,
			@Dia_HabReq	= Dse_SoDiHa
		from SOCODIEJ noholdlock
		inner join SODIAEJE noholdlock
				on Die_CoDiEj	= Cde_Numero
				and Die_Activo	= @Bit_Si
		inner join SOTIDIEJ noholdlock
				on Tde_Numero	= Die_TiDiEj
				and Tde_DiaSem	= @Bit_Si
				and Tde_Activo	= @Bit_Si
		inner join SODISEEJ noholdlock
				on Dse_CoDiEj	= Die_CoDiEj
				and Dse_DiaSem	= @Dia_SemAct
				and Dse_Activo	= @Bit_Si
		where Cde_Numero	= @Num_CoDiEj
		  and Cde_Activo	= @Bit_Si

	if @Dia_ActVal	= @Bit_Si begin
		-- Si se tiene configurado el dia de la semana del dia que se esta validando
		select @Dia_Valido	= @Bit_Si
		
		-- Si se pide que sea dia Habil, verificar que no sea Sabado o Domingo ni Dia Festivo
		if @Dia_HabReq	= @Bit_Si begin
			if @Dia_SemAct in (@Dia_Sabado, @Dia_Doming) begin
				select @Dia_Valido	= @Bit_No
			end
			else begin
				select @Dia_Valido	= @Bit_No
					from SODIAFES noholdlock
					where Dfe_Fecha	= @Fec_Hoy
			end
		end
	end
end

-- Validar Dia del mes
if @Dia_Valido	= @Bit_No begin
	select @Dia_ActVal	=	@Bit_No
	-- Revisar si se tiene configurado el dia del mes, y si se requiere que sea Dia habil
	select	@Dia_ActVal	= @Bit_Si,
			@Dia_HabReq	= Dme_SoDiHa
		from SOCODIEJ noholdlock
		inner join SODIAEJE noholdlock
				on Die_CoDiEj	= Cde_Numero
				and Die_Activo	= @Bit_Si
		inner join SOTIDIEJ noholdlock
				on Tde_Numero	= Die_TiDiEj
				and Tde_DiaMes	= @Bit_Si
				and Tde_Activo	= @Bit_Si
		inner join SODIMEEJ noholdlock
				on Dme_CoDiEj	= Die_CoDiEj
				and Dme_DiaMes	= @Dia_FecAct
				and Dme_Activo	= @Bit_Si
		where Cde_Numero	= @Num_CoDiEj
		  and Cde_Activo	= @Bit_Si

	if @Dia_ActVal	= @Bit_Si begin
		-- Si se tiene configurado el dia del mes del dia que se esta validando
		select @Dia_Valido	= @Bit_Si
		
		-- Si se pide que sea dia Habil, verificar que no sea Sabado o Domingo ni Dia Festivo
		if @Dia_HabReq	= @Bit_Si begin
			if @Dia_SemAct in (@Dia_Sabado, @Dia_Doming) begin
				select @Dia_Valido	= @Bit_No
			end
			else begin
				select @Dia_Valido	= @Bit_No
					from SODIAFES noholdlock
					where Dfe_Fecha	= @Fec_Hoy
			end
		end
	end
end


--**En todos los casos, si el Horario de Ejecucion inicia en un dia y termina en el siguiente dia, verificar si el dia y hora actual se encuentra dentro del intervalo correcto.

if @Dia_Valido	= @Bit_No begin
	select @Men_Error	=	'El dia actual no es un dia valido para ejecucion'
	return @Can_Cero
end

-- En este momento ya se determino que el dia es valido. Ahora se debe verificar el horario.

-- Verificar que se encuentre en un horario valido de ejecucion
select @Hor_Actual	= current_time()

select	@Hor_ConIni	= Cde_HorIni,
		@Hor_ConFin	= Cde_HorFin
	from SOCODIEJ noholdlock
	where Cde_Numero	= @Num_CoDiEj

-- Si en el Horario definido en la Configuracion la Hora Inicial y la Hora Final se encuentran en el mismo dia, se verifica que la Hora Actual se encuentre en ese Horario.
if @Hor_ConIni	< @Hor_ConFin begin
	if not @Hor_Actual	between @Hor_ConIni and @Hor_ConFin begin
		select @Men_Error	=	'La Hora actual no es valida para ejecucion'
		return @Can_Cero
	end
end
-- Si en el Horario definido en la Configuracion la Hora Inicial y la Hora Final NO se encuentran en el mismo dia, se verificar 
-- que la Hora Actual se encuentre entre la Hora Inicial y el Fin del Dia (23:59) o entre el Inicio de Dia (00:00) y la Hora Final.
else begin
	if not @Hor_Actual	between @Hor_ConIni and @Hor_FinDia
		and not @Hor_Actual	between @Hor_IniDia and @Hor_ConFin begin
		select @Men_Error	=	'La Hora actual no es valida para ejecucion'
		return @Can_Cero
	end
end

select @Men_Error	= @Men_Vacio
return @Can_Cero
