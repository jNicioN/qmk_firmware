create procedure SOEJEFLUPRO (
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Ejecucion de Flujos													****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		27/05/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Proceso para ejecucion de Flujos										****
********************************************************************************************/

create table #FLUEJE	(
							Fle_Numero	int identity,	-- Identificador
							Fle_Flujo	int,			-- Flujo
							Fle_CoDiEj	int,			-- Configuracion de Dias de Ejecucion
						)

--Variables
declare @Num_ProFlu	int,			-- Proceso de Flujo
		@Num_Flujo	int,			-- Flujo
		@Abr_ProFlu	varchar(15),	-- Abreviatura de Proceso
		@Num_CoDiEj	int,			-- Numero de Configuracion de Dias de Ejecucion del Flujo
		@Res_Ejecuc	int,			-- Resultado de Ejecucion
		@Abr_Flujo	varchar(15),	-- Abreviatura de Flujo
		@Res_EjePro int,			-- Resultado de Ejecucion (Sybase)
		@Men_Bitaco	varchar(200),	-- Mensaje de Bitacora
		@Flu_Activo	bit,			-- Flujo Activo
		@Eje_ActFlu	bit,			-- Ejecucion Actual del Flujo
		@Fec_ActSis	smalldatetime,	-- Fecha Actual del Sistema
		@Fec_HoyRea	smalldatetime,	-- Fecha: Hoy real.
		@Fec_Hoy	smalldatetime,	-- Fecha: Hoy para ejecucion de procesos.
		@Fec_HorEje	smalldatetime,	-- Fecha y Hora de Ejecucion
		@Hor_ConIni	time,			-- Hora de Configuracion: Inicio
		@Hor_ConFin	time,			-- Hora de Configuracion: Fin
		@Dia_ValEje	bit,			-- Dia valido para ejecucion
		@Reg_Actual	int,			-- Registro Actual
		@Reg_Inicia	int,			-- Registro Inicial
		@Reg_Final	int				-- Registro Final

--Constantes
declare	@Can_Cero   tinyint,	-- Cantidad: Cero 
		@Can_Uno    tinyint,	-- Cantidad: Uno
		@Bit_Si		bit,		-- Bit: Si
		@Bit_No		bit,		-- Bit: No
		@Hor_Vacia	time,		-- Hora Vacia
		@Hor_IniDia	time,		-- Hora Inicio del Dia: 00:00:00
		@Men_Vacio	varchar(10)	-- Mensaje vacio

-- Asignacion de Constantes
select  @Can_Cero   = 0,		-- Cantidad: Cero
		@Can_Uno    = 1,		-- Cantidad: Uno
		@Bit_Si		= 1,		-- Bit: Si
		@Bit_No		= 0,		-- Bit: No
		@Hor_Vacia	= '00:00',	-- Hora Vacia
		@Hor_IniDia	= '00:00:00',	-- Hora Inicio del Dia: 00:00:00
		@Men_Vacio	= ''		-- Mensaje vacio

-- Obtener Fechas de Sistema y hoy
select	@Fec_ActSis = Par_FecAct
	from SOPARAMS noholdlock
	where Par_Sucurs = @SucOrigen

-- Fecha Hoy Real
select @Fec_HoyRea = convert(smalldatetime, convert(varchar(10),getdate(),112))

-- Los registros en Bitacora se generan sin Numero de Proceso
select @Num_ProFlu	= @Can_Cero

-- Obtener los Flujos a ejecutar
insert into #FLUEJE (Fle_Flujo, Fle_CoDiEj)
	select Flu_Numero, Flu_CoDiEj
	from SOFLUJOS noholdlock
	where Flu_Activo	= @Bit_Si

select	@Reg_Inicia	= min(Fle_Numero),
		@Reg_Final	= max(Fle_Numero)
	from #FLUEJE

select	@Reg_Actual	= @Reg_Inicia

-- Recorrer cada Proceso (Desde Control de Flujo)
while @Reg_Actual	<= @Reg_Final begin
	-- Obtere Numero de Proceso a Ejecutar
	select	@Num_Flujo	= Fle_Flujo,
			@Num_CoDiEj	= Fle_CoDiEj
		from #FLUEJE
		where Fle_Numero	= @Reg_Actual
		
	-- Obtener informacion del Flujo
	select	@Abr_Flujo	= Flu_Abrevi,
			@Flu_Activo	= Flu_Activo,
			@Eje_ActFlu	= Flu_EjeAct
		from SOFLUJOS noholdlock
		where Flu_Numero	= @Num_Flujo
	
	-- Si el Horario de Ejecucion de la Configuracion inicia en un Dia y termina el dia siguiente,
	-- y la hora actual se encuentra dentro el horaro del dia siguiente,
	-- entonces hacer las validaciones con el dia anterior.
	
	-- En caso predeterminado la Fecha de Hoy es la misma que la Fecha Real
	select @Fec_Hoy	= @Fec_HoyRea
	
	select	@Hor_ConIni	= Cde_HorIni,
			@Hor_ConFin	= Cde_HorFin
		from SOCODIEJ noholdlock
		where Cde_Numero	= @Num_CoDiEj
		
	if @Hor_ConIni	> @Hor_ConFin begin
		if current_time()	between @Hor_IniDia	and @Hor_ConFin begin
			select	@Fec_Hoy	= dateadd(dd, -@Can_Uno, @Fec_HoyRea)
		end
	end
	
	
	-- Mensaje de Bitacora sin valor, de inicio
	select	@Men_Bitaco	= @Men_Vacio

	-- Revisar si el Dia y Horario son correctos para ejecucion del Flujo
	execute @Res_Ejecuc	= SOCODIEJVAL
							@Fec_Hoy	= @Fec_Hoy,				-- Fecha a validar
							@Num_CoDiEj	= @Num_CoDiEj,			-- Flujo
							@Dia_Valido	= @Dia_ValEje output,	-- Resultado: Dia valido o no para ejecucion
							@Men_Error	= @Men_Bitaco output,	-- Mensaje de Error
							@NumTransac	= @NumTransac,	
							@Transaccio	= @Transaccio,
							@Usuario	= @Usuario,
							@FechaSis	= @FechaSis,
							@SucOrigen	= @SucOrigen,
							@SucDestino	= @SucDestino,
							@Modulo		= @Modulo
	select @Res_EjePro = @@error
	if @Res_EjePro <> @Can_Cero begin
	  select	@Res_Ejecuc = @Can_Uno,
				@Men_Bitaco = 'ERROR de ejecucion (Sybase) del proceso de Validacion de Dias de Ejecucion para [' + @Abr_Flujo + '] Codigo: ' + convert(varchar(10), @Res_EjePro),
				@Fec_HorEje	= getdate(),
				@Dia_ValEje	= @Bit_No
	end
	else begin
		if @Res_Ejecuc	<> @Can_Cero begin
			select	@Men_Bitaco = 'ERROR al validar Dia y Horario de Ejecucion. Flujo [' + @Abr_Flujo + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate(),
					@Dia_ValEje	= @Bit_No
		end
	end
							

	if @Res_Ejecuc	= @Can_Cero	begin
		if @Dia_ValEje	= @Bit_No begin
			-- Si es Dia u Hora no valido para ejecucion, indicarlo en la Bitacora
			select	@Res_Ejecuc	= @Can_Uno,	-- Se indica error general para el Flujo. Ya no se debe procesar.
					@Men_Bitaco = 'Flujo [' + @Abr_Flujo + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate()
		end
	end
	
	-- Verificar que no se este ejecutando actualmente el flujo.
	if @Res_Ejecuc	= @Can_Cero begin
		if @Eje_ActFlu	= @Bit_Si begin
			--Si se esta ejecutando en otra sesion. Reportar error. (Solicitar envio de mensaje a Operador de Flujos).
			select	@Res_Ejecuc	= @Can_Uno,	-- Se indica error general para el Flujo. Ya no se debe procesar.
					@Men_Bitaco	= 'El Flujo [' + @Abr_Flujo + '] se esta ejecutando actualmente en otra sesion',
					@Fec_HorEje	= getdate()
		end
	end
	
	-- Ejecutar Flujo
	if @Res_Ejecuc	= @Can_Cero begin
		select	@Res_Ejecuc = @Can_Uno	--De inicio no se puede saber si hay ejecucion exitosa
		execute @Res_Ejecuc = SOFLUJOSPRO
								@Num_Flujo	= @Num_Flujo,		-- Numero de Flujo
								@NumTransac	= @NumTransac,	
								@Transaccio	= @Transaccio,
								@Usuario	= @Usuario,
								@FechaSis	= @FechaSis,
								@SucOrigen	= @SucOrigen,
								@SucDestino	= @SucDestino,
								@Modulo		= @Modulo
		select @Res_EjePro = @@error
		if @Res_EjePro <> @Can_Cero begin
		  select	@Res_Ejecuc = @Can_Uno,
					@Men_Bitaco = 'ERROR de ejecucion (Sybase) del proceso del Flujo [' + @Abr_Flujo + '] Codigo: ' + convert(varchar(10), @Res_EjePro),
					@Fec_HorEje	= getdate()
		end
		else begin
			if @Res_Ejecuc	<> @Can_Cero begin
				select	@Men_Bitaco = 'ERROR de Ejecucion. Flujo [' + @Abr_Flujo + ']', -- ' + @Men_Bitaco,
						@Fec_HorEje	= getdate()
			end
		end
	end
	
	-- Si se detecto alguna situacion por la que no se va a ejecutar el Flujo, registrarlo en la Bitacora
	if @Res_Ejecuc	<> @Can_Cero begin
		-- Registrar mensaje de error
		execute SOBITFLUALT
					@Bif_Flujo	= @Num_Flujo,	-- Flujo
					@Bif_Fecha	= @Fec_Hoy,		-- Fecha
					@Bif_ProFlu	= @Num_ProFlu,	-- Proceso
					@Bif_EjeExi	= @Bit_No,		-- Ejecucion Exitosa
					@Bif_FecHor	= @Fec_HorEje,	-- Fecha y hora de ejecucion
					@Bif_Mensaj = @Men_Bitaco,	-- Mensaje
					@NumTransac	= @NumTransac,	
					@Transaccio	= @Transaccio,
					@Usuario	= @Usuario,
					@FechaSis	= @FechaSis,
					@SucOrigen	= @SucOrigen,
					@SucDestino	= @SucDestino,
					@Modulo		= @Modulo
		--select @Dia_ValEje	= @Bit_No
	end
	
	-- Pasar al siguiente Proceso
	select	@Reg_Actual	= @Reg_Actual + @Can_Uno
end
--Terminar el Flujo con exito

drop table #FLUEJE

return @Can_Cero
