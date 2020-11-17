create procedure SOFLUJOSPRO (
	@Num_EjeFlu int output, 			-- Numero de Ejecucion de Flujo	-- Puede ser recibido como parametro de entrada o como salida.
	@Num_Flujo	int,					-- Numero de Flujo
	@Nue_Ejecuc	bit,					-- Iniciar una Nueva Ejecucion del Flujo
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Ejecucion de Procesos de un Flujo									****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		24/08/2020									        					****
** Help:		1394242									        						****
** Descripcion:	Ajustes por agregado de tabla SOEJEFLU.									****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		27/05/2020									        					****
** Help:		2020061642000031						        						****
** Descripcion:	Ejecucion de Procesos de un Flujo										****
********************************************************************************************/

create table #ProcesosEje	(
							Pre_Numero	int identity,	-- Identificador
							Pre_ProFlu	int,			-- Proceso
							Pre_CoDiEj	int,			-- Configuracion de Dias de Ejecucion
							Pre_Hito	bit,			-- Hito
							Pre_AbPrFl	varchar(15),	-- Abreviatura de Proceso
							Pre_ReqCon	bit,			-- Proceso requerido para continuar
							Pre_Proced	varchar(50)		-- Procedimiento
						)

--Variables
declare @Num_ProFlu	int,			-- Proceso de Flujo
		@Num_CoDiEj	int,			-- Numero de Configuracion de Dias de Ejecucion del Flujo
		@Dia_ValEje	bit,			-- Dia valido para ejecucion
		@Dep_ProFal	bit,			-- Dependencias de Procesos Fallidas
		@Pre_Hito	bit,			-- Hito
		@Abr_ProFlu	varchar(15),	-- Abreviatura de Proceso
		@Pro_ReqCon	bit,			-- Proceso requerido para continuar
		@Pro_Ejecut	varchar(50),	-- Proceso a ejecutar
		@Par_ProEje	varchar(200),	-- Parametros de Proceso de Flujo
		@Men_Error 	varchar(200),	-- Mensaje de Error
		@Status		int,			-- Resultado de Ejecucion de Procedimientos
		@Res_Ejecuc	int,			-- Resultado de Ejecucion
		@Res_EjePro int,			-- Resultado de Ejecucion (Sybase)
		@Men_Bitaco	varchar(200),	-- Mensaje de Bitacora
		@Abr_Flujo	varchar(15),	-- Abreviatura de Flujo
		@Fec_ActSis	smalldatetime,	-- Fecha Actual del Sistema
		@Fec_Hoy	smalldatetime,	-- Fecha: Hoy
		@Fec_HorEje	smalldatetime,	-- Fecha y Hora de Ejecucion
		@Reg_Actual	int,			-- Registro Actual
		@Reg_Inicia	int,			-- Registro Inicial
		@Reg_Final	int				-- Registro Final

--Constantes
declare	@Can_Cero   tinyint,		-- Cantidad: Cero 
		@Can_Uno    tinyint,		-- Cantidad: Uno
		@Bit_Si		bit,			-- Bit: Si
		@Bit_No		bit,			-- Bit: No
		@Hor_Vacia	time,			-- Hora Vacia
		@Men_Vacio	varchar(200)	-- Mensaje vacio

select  @Can_Cero   = 0,		-- Cantidad: Cero
		@Can_Uno    = 1,		-- Cantidad: Uno
		@Bit_Si		= 1,		-- Bit: Si
		@Bit_No		= 0,		-- Bit: No
		@Hor_Vacia	= '00:00',	-- Hora Vacia
		@Men_Vacio	= ''		-- Mensaje vacio

-- Obtener Fechas de Sistema y hoy
select	@Fec_ActSis = Par_FecAct
	from SOPARAMS noholdlock
	where Par_Sucurs = @SucOrigen

select @Fec_Hoy = convert(smalldatetime, convert(varchar(10),getdate(),112))

-- Obtener informacion del Flujo
select	@Abr_Flujo	= Flu_Abrevi
	from SOFLUJOS noholdlock
	where Flu_Numero	= @Num_Flujo

-- El Numero de Ejecucion de Flujo se obtendra de la Ejecucion actual o se generara una Nueva
-- De inicio se asigna el valor del parametro
select @Num_EjeFlu	= isnull(@Num_EjeFlu, @Can_Cero)

-- Si No se solicita una nueva Ejecucion, obtener la Ultima Ejecucion del Dia
-- Se obtiene la Ultima Ejecucion del Dia cuando NO se recibe el Numero de Ejecucion como parametro.
if @Nue_Ejecuc	= @Bit_No and @Num_EjeFlu	= @Can_Cero begin
	select	@Num_EjeFlu	= max(Ejf_Numero)
		from SOEJEFLU noholdlock
		where Ejf_Flujo	= @Num_Flujo
		  and Ejf_Fecha	= @Fec_Hoy
end

------------------------------------------------------------------------------------
-- Iniciar nueva Ejecucion del Flujo
------------------------------------------------------------------------------------
-- Si se solicita una nueva Ejecucion, generarla sin afectar a la Ejecucion anterior.
-- Si no se solicito Nueva Ejecucion, pero no se tiene una Ejecucion Actual, generar una Nueva.
if @Nue_Ejecuc	= @Bit_Si or @Num_EjeFlu	= @Can_Cero begin
	select	@Status	= @Can_Uno	-- Se inicializa con "error" para detectar alguna ejecucion indeterminada
	
	execute @Status	= SOEJEFLUALT
		@Ejf_Numero	= @Num_EjeFlu output, 
		@Ejf_Flujo 	= @Num_Flujo,
		@Ejf_Fecha	= @Fec_Hoy,
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
				@Men_Bitaco = 'ERROR de ejecucion (Sybase) del proceso de Generacion de Nueva Ejecucion para [' + @Abr_Flujo  + '] Codigo: ' + convert(varchar(10), @Res_EjePro),
				@Fec_HorEje	= getdate()
	end
	else begin
		select	@Res_Ejecuc	= @Status
		select	@Men_Bitaco	= 'Error Codigo: ' + convert(varchar(10), @Res_Ejecuc)
		if @Res_Ejecuc	<> @Can_Cero begin
			select	@Men_Bitaco = 'ERROR en proceso de Generacion de Nueva Ejecucion. Flujo [' + @Abr_Flujo + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate()
		end
	end
	
	if	@Res_Ejecuc	<> @Can_Cero begin
		-- Como no se pudo generar una Ejecucion de Flujo, no se puede escribir en la Bitacora.
		-- Entonces se regresa el codigo de error.
		return	@Res_Ejecuc
	end
end


-- Registrar que el Flujo se esta ejecutando
--update SOFLUJOS
--	set Flu_EjeAct	= @Bit_Si
--	where Flu_Numero	= @Num_Flujo

-- Al inicio aun no se tiene un proceso a ejecutar
select @Num_ProFlu	= @Can_Cero

-- Insertar los Proceso del Flujo en tabla de Control de Flujo
-- Se ejecuta un Flujo una vez por dia
if not exists	(select Cof_EjeFlu
					from SOCONFLU noholdlock
					where Cof_EjeFlu	= @Num_EjeFlu
				) begin
	insert into SOCONFLU	(	Cof_EjeFlu,	Cof_ProFlu, Cof_Orden,	Cof_Ejecut, Cof_FecHor, 
								NumTransac, Transaccio, Usuario,	FechaSis, 	SucOrigen,	
								SucDestino)
		select 					@Num_EjeFlu,Prf_Numero,	Prf_Orden,	@Bit_No,	@Hor_Vacia,	
								@NumTransac,@Transaccio,@Usuario,	@FechaSis,	@SucOrigen,	
								@SucDestino
		from SOPROFLU noholdlock
		where Prf_Flujo		= @Num_Flujo
		  and Prf_Activo	= @Bit_Si
end

-- Obtener los Procesos que no se han ejecutado
insert into #ProcesosEje (	Pre_ProFlu, Pre_CoDiEj, Pre_Hito, Pre_AbPrFl, Pre_ReqCon, 
							Pre_Proced)
	select 					Cof_ProFlu, Prf_CoDiEj, Prf_Hito, Prf_Abrevi, Prf_ReqCon, 
							Prf_Proced
	from SOCONFLU noholdlock
	inner join SOPROFLU noholdlock
			on Prf_Numero	= Cof_ProFlu
			and Prf_Activo	= @Bit_Si
	where Cof_EjeFlu	= @Num_EjeFlu
	  and Cof_Ejecut	= @Bit_No
	order by Cof_Orden

select	@Reg_Inicia	= min(Pre_Numero)
	from #ProcesosEje
	
select	@Reg_Final	= max(Pre_Numero)
	from #ProcesosEje

select	@Reg_Actual	= @Reg_Inicia

-- Recorrer cada Proceso (Desde Control de Flujo)
while @Reg_Actual	<= @Reg_Final begin
	-- Obtere Numero de Proceso a Ejecutar
	select	@Num_ProFlu	= Pre_ProFlu,
			@Num_CoDiEj	= Pre_CoDiEj,
			@Pre_Hito	= Pre_Hito,
			@Abr_ProFlu	= Pre_AbPrFl,
			@Pro_ReqCon	= Pre_ReqCon,
			@Pro_Ejecut	= Pre_Proced
		from #ProcesosEje
		where Pre_Numero	= @Reg_Actual
		
	-- Si el Proceso es un Hito, colocar en @Pro_Ejecut el valor de @Abr_ProFlu, para que se muestre ese dato en los mensajes de error.
	if @Pre_Hito = @Bit_Si begin
		select	@Pro_Ejecut	= @Abr_ProFlu
	end
	
	-- Se inicia con un Resultado de Ejecucion No correcto, esperando por el resultado del proceso
	select	@Status	= @Can_Uno
		
	-- Revisar si el Dia y Horario son correctos para ejecucion del Proceso
	execute @Status	= SOCODIEJVAL
							@Fec_Hoy	= @Fec_Hoy,				-- Fecha a validar
							@Num_CoDiEj	= @Num_CoDiEj,			-- Configuracion de Dias de Ejecucion
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
				@Men_Bitaco = 'ERROR de ejecucion (Sybase) del proceso de Validacion de Dias de Ejecucion para [' + @Abr_Flujo + ' - ' + @Pro_Ejecut + '] Codigo: ' + convert(varchar(10), @Res_EjePro),
				@Fec_HorEje	= getdate(),
				@Dia_ValEje	= @Bit_No
	end
	else begin
		select 	@Res_Ejecuc	= @Status
		if @Res_Ejecuc	<> @Can_Cero begin
			select	@Men_Bitaco = 'ERROR al validar Dia y Horario de Ejecucion. Flujo [' + + @Abr_Flujo + ' - ' + @Pro_Ejecut + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate(),
					@Dia_ValEje	= @Bit_No
		end
	end
	
	if @Res_Ejecuc	= @Can_Cero	begin
		if @Dia_ValEje	= @Bit_No begin
			-- Si es Dia u Hora no valido para ejecucion, indicarlo en la Bitacora
			select	@Res_Ejecuc	= @Can_Uno,	-- El Resultado general de ejecucion se coloca diferente de cero (No Existoso)
					@Men_Bitaco = 'Flujo [' + @Abr_Flujo + ' - ' + @Pro_Ejecut + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate()
		end
	end
	
	-- Revision de Dependencias de Procesos
	select @Dep_ProFal	= @Bit_No
	if @Res_Ejecuc = @Can_Cero begin
		--Si el proceso tiene Dependencias, verificar si se ejecutaron correctamente.
		if exists (select Dpf_ProFlu
					from SODEPRFL noholdlock
					inner join SOCONFLU noholdlock
							on Cof_EjeFlu		= @Num_EjeFlu
							  and Cof_ProFlu	= Dpf_PrFlDe
							  and Cof_Ejecut	= @Bit_No
					where Dpf_ProFlu	= @Num_ProFlu
					  and Dpf_Activo	= @Bit_Si) begin
			-- El proceso tiene Dependencias no ejecutadas
			select	@Dep_ProFal	= @Bit_Si,
					@Res_Ejecuc	= @Can_Uno,	-- El Resultado general de ejecucion se coloca diferente de cero (No Exitoso)
					@Men_Bitaco = 'ERROR por Dependencias no ejecutadas. Flujo [' + @Abr_Flujo + ' - ' + @Pro_Ejecut + '] - ' + @Men_Bitaco,
					@Fec_HorEje	= getdate()
		end
	end
	
	-- Si se detecto alguna situacion por la que no se va a ejecutar el Flujo, registrarlo en la Bitacora
	if  @Res_Ejecuc = @Can_Uno begin
		-- Registrar mensaje de error
		execute	@Status	= SOBITFLUALT
					@Bif_EjeFlu	= @Num_EjeFlu,	-- Ejecucion de Flujo
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
		select @Dia_ValEje	= @Bit_No
	end
	
	-- Si las validaciones no han reportado algun error, ejecutar el Proceso
	if  @Res_Ejecuc = @Can_Cero begin
		-- Si el Proceso es un Hito, solo registar el Hito en la Bitacora
		if @Pre_Hito = @Bit_Si begin
			select	@Men_Bitaco	= 'Flujo [' + @Abr_Flujo + '] - Hito: [' + @Abr_ProFlu + ']',
					@Fec_HorEje	= getdate()
			-- Registrar Proceso como ejecutado
			update SOCONFLU
				set	Cof_Ejecut	= @Bit_Si,
					Cof_FecHor	= @Fec_HorEje,
					NumTransac	= @NumTransac,	
					Transaccio	= @Transaccio,
					Usuario		= @Usuario,
					FechaSis	= @FechaSis,
					SucOrigen	= @SucOrigen,
					SucDestino	= @SucDestino
				where Cof_EjeFlu	= @Num_EjeFlu
				  and Cof_ProFlu	= @Num_ProFlu
			-- Registrar Bitacora
			execute	@Status	= SOBITFLUALT
						@Bif_EjeFlu	= @Num_EjeFlu,	-- Ejecucion de Flujo
						@Bif_ProFlu	= @Num_ProFlu,	-- Proceso
						@Bif_EjeExi	= @Bit_Si,		-- Ejecucion Exitosa
						@Bif_FecHor	= @Fec_HorEje,	-- Fecha y hora de ejecucion
						@Bif_Mensaj = @Men_Bitaco,	-- Mensaje
						@NumTransac	= @NumTransac,	
						@Transaccio	= @Transaccio,
						@Usuario	= @Usuario,
						@FechaSis	= @FechaSis,
						@SucOrigen	= @SucOrigen,
						@SucDestino	= @SucDestino,
						@Modulo		= @Modulo
		end
		
		-- Si el Proceso no es un Hito, Ejecutar el Procedimiento
		if @Pre_Hito = @Bit_No begin
		
			-- Obtener los parametros del Proceso de Flujo
			execute	@Status	= SOPAPREJPRO
						@Num_EjeFlu = @Num_EjeFlu,			-- Numero de Ejecucion de Flujo
						@Num_ProFlu = @Num_ProFlu,			-- Numero de Proceso de Flujo
						@Lis_Parame	= @Par_ProEje output,	-- Lista de Parametros
						@NumTransac	= @NumTransac,	
						@Transaccio	= @Transaccio,
						@Usuario	= @Usuario,
						@FechaSis	= @FechaSis,
						@SucOrigen	= @SucOrigen,
						@SucDestino	= @SucDestino,
						@Modulo		= @Modulo
			
			select	@Status		= @Can_Uno,	--De inicio no se puede saber si hay ejecucion exitosa
					@Men_Error	= @Men_Vacio
			 
			execute	@Status = SOEJEPROPRO
				@Num_EjeFlu = @Num_EjeFlu,			-- Numero de Ejecucion de Flujo
				@Num_ProFlu = @Num_ProFlu,			-- Numero de Proceso de Flujo
				@Men_Error	= @Men_Error output,	-- Mensaje de Error
				@NumTransac	= @NumTransac,	
				@Transaccio	= @Transaccio,
				@Usuario	= @Usuario,
				@FechaSis	= @FechaSis,
				@SucOrigen	= @SucOrigen,
				@SucDestino	= @SucDestino,
				@Modulo		= @Modulo
			
			--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
			select @Res_EjePro = @@error
			if @Res_EjePro <> @Can_Cero begin
			  select	@Res_Ejecuc = @Can_Uno,
						@Men_Bitaco = 'ERROR de ejecucion (Sybase) del proceso de [' + @Abr_Flujo + ' - ' + @Pro_Ejecut + '] Codigo: ' + convert(varchar(10), @Res_EjePro),
						@Fec_HorEje	= getdate()
			end
			else begin	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
				select	@Res_Ejecuc	= @Status
				if @Res_Ejecuc <> @Can_Cero begin
					select	@Men_Bitaco = 'ERROR dentro del proceso de [' + @Abr_Flujo + ' - ' + @Pro_Ejecut + ']: ' + @Men_Error,
							@Fec_HorEje	= getdate()
				end
			end
			
			-- Si el proceso ejecutado dejo una transaccion pendiente, hacer rollback
			if @@trancount > @Can_Cero
				rollback
			
			-- Si hubo error de ejecucion, registrar en la Bitacora
			if @Res_Ejecuc <> @Can_Cero begin
				-- Registrar Bitacora
				execute	@Status	= SOBITFLUALT
							@Bif_EjeFlu	= @Num_EjeFlu,	-- Ejecucion de Flujo
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
			end
			
			-- Si la ejecucion fue exitosa, marcar en Control de Flujo y registrar en la Bitacora
			if @Res_Ejecuc = @Can_Cero begin
				select	@Men_Bitaco	= 'Flujo [' + @Abr_Flujo + '] - Ejecucion EXITOSA procedimiento: [' + @Pro_Ejecut + ']',
						@Fec_HorEje	= getdate()
				
				-- Registrar Proceso como ejecutado
				update SOCONFLU
					set Cof_Ejecut	= @Bit_Si,
						Cof_FecHor	= @Fec_HorEje,
						NumTransac	= @NumTransac,	
						Transaccio	= @Transaccio,
						Usuario		= @Usuario,
						FechaSis	= @FechaSis,
						SucOrigen	= @SucOrigen,
						SucDestino	= @SucDestino
					where Cof_EjeFlu	= @Num_EjeFlu
					  and Cof_ProFlu	= @Num_ProFlu
		
				-- Registrar Bitacora
				execute	@Status	= SOBITFLUALT
							@Bif_EjeFlu	= @Num_EjeFlu,	-- Ejecucion de Flujo
							@Bif_ProFlu	= @Num_ProFlu,	-- Proceso
							@Bif_EjeExi	= @Bit_Si,		-- Ejecucion Exitosa
							@Bif_FecHor	= @Fec_HorEje,	-- Fecha y hora de ejecucion
							@Bif_Mensaj = @Men_Bitaco,	-- Mensaje
							@NumTransac	= @NumTransac,	
							@Transaccio	= @Transaccio,
							@Usuario	= @Usuario,
							@FechaSis	= @FechaSis,
							@SucOrigen	= @SucOrigen,
							@SucDestino	= @SucDestino,
							@Modulo		= @Modulo
			end
		end -- No es un Hito
	end	-- No se encontro ningun problema en las Validaciones: Dia Valido de Ejecucion y No se tienen Dependencias pendientes
	
	--En caso de error, si el proceso es requerido para continuar, entonces terminar con error el flujo
	if @Res_Ejecuc	<> @Can_Cero begin
		if @Pro_ReqCon	= @Bit_Si begin
			select	@Men_Bitaco	= 'Se DETIENE el procesamiento del Flujo [' + @Abr_Flujo + '] debido al ERROR en la ejecucion del procedimiento: [' + @Pro_Ejecut + '] el cual requerido para continuar.',
					@Fec_HorEje	= getdate()
					
			-- Registrar Bitacora
			execute	@Status	= SOBITFLUALT
						@Bif_EjeFlu	= @Num_EjeFlu,	-- Ejecucion de Flujo
						@Bif_ProFlu	= @Can_Cero,	-- Proceso
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
						
			-- Finalizar procesamiento del Flujo
			select	@Reg_Actual	= @Reg_Final + @Can_Uno
		end
	end
	
	-- Pasar al siguiente Proceso
	select	@Reg_Actual	= @Reg_Actual + @Can_Uno
	
end-- Ciclo de Proceso a Ejecutar

--Terminar el Flujo con exito

-- Registrar que el Flujo ya no se esta ejecutando
--update SOFLUJOS
--	set Flu_EjeAct	= @Bit_No
--	where Flu_Numero	= @Num_Flujo

drop table #ProcesosEje

                                                                                                                       