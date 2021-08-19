
create procedure SOEJEPROPRO (
	@Num_EjeFlu int,					-- Numero de Ejecucion de Flujo
	@Num_ProFlu int,					-- Numero de Proceso de Flujo
	@Men_Error	varchar(200) output,	-- Mensaje de Error
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion: Ejecucion de Procesos definidos en Flujos								****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Frank Canul		                     									****
** Fecha:		13/08/2021									        					****
** Help:		1394242						        									****
** Descripcion:	Se agrega la ejecucion del proceso 	CTMAARAPPRO							****
********************************************************************************************
** Elaboro: 	Juan Jose Sandoval Marin               									****
** Fecha:		21/05/2021									        					****
** Help:		1507203						        									****
** Descripcion:	Se agrega la ejecucion del proceso 	CLMACLCAPRO y CLMAMOCAPRO			****
********************************************************************************************
** Elaboro: 	Juan Jose Sandoval Marin               									****
** Fecha:		06/05/2021									        					****
** Help:		1503952						        									****
** Descripcion:	Se agrega la ejecucion del proceso 	CLMAVECLPRO							****
********************************************************************************************
** Elaboro: 	Frank Canul		                     									****
** Fecha:		01/03/2021									        					****
** Help:		1394242						        									****
** Descripcion:	Se agrega los nuevos nombres de los store procedure que tenian la       ****
**                terminación MAE							                            ****
********************************************************************************************
** Elaboro: 	Frank Canul		                     									****
** Fecha:		10/02/2021									        					****
** Help:		1394242						        									****
** Descripcion:	Se agrega la ejecucion del proceso 	TAMAALHEPRO							****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		13/11/2020									        					****
** Help:		1394242						        									****
** Descripcion:	Ejecucion de procesos definidos en los Flujos							****
********************************************************************************************/

--Variables
declare	@Status		int,			-- Status de ejecucion de procedimientos
		@Res_EjeIns	int,			-- Resultado de ejecucion de Instruccion
		@Stp_Proced	varchar(50),	-- Store Procedure del Procedimiento
		@Pro_ExiEje	bit,			-- Procedimiento existente y ejecutado
		@Par_EntUno	int				-- Parametro de Tipo Entero Uno

--Constantes
declare	@Ent_Uno	tinyint,		-- Cantidad: Uno
		@Ent_Cero	tinyint,		-- Cantidad: Cero
		@Bit_Si		bit,			-- Bit: Si
		@Bit_No		bit,			-- Bit: No
		@Par_TipEje	varchar(20),	-- Parametro: Tip_Ejecuc
		@Pro_BlDeLi	varchar(11),	-- Procedimiento de Bloqueo y Desbloqueo de Lineas y Tarjetas. TAMABLDEPRO.
		@Pro_LiPeLi	varchar(11),	-- Procedimiento de Aplicacion de limites personal de lineas de crédito. TAMALIPEPRO.
		@Pro_InDeLi	varchar(11),	-- Procedimiento de incremento y decremento de lineas de credito. TAMAINDEPRO.
		@Pro_CanLin	varchar(11),	-- Procedimiento de Aplicacion de Cancelacion de lineas. TAMACALIPRO.
        @Pro_AltLin varchar(11),    -- Procedimiento de Alta de lineas hey. TAMAALHEPRO
        @Pro_VerCli varchar(11),     -- Procedimiento de Verificacion de Clientes. CLMAVECLPRO
		@Pro_CliCat varchar(11),    -- Procedimiento de Clientes Categorias. CLMACLCAPRO
        @Pro_MotCat varchar(11),     -- Procedimiento de Motivos Categorias. CLMAMOCAPRO
        @Pro_ActRap varchar(11)

select  @Ent_Uno	= 1,				-- Cantidad: Uno
		@Ent_Cero	= 0,				-- Cantidad: Cero
		@Bit_Si		= 1,				-- Bit: Si
		@Bit_No		= 0,				-- Bit: No
		@Par_TipEje	= 'Tip_Ejecuc',		-- Parametro: Tip_Ejecuc
		@Pro_BlDeLi	= 'TAMABLDEPRO',	-- Procedimiento de Bloqueo y Desbloqueo de Lineas y Tarjetas. TAMABLDEPRO.
		@Pro_LiPeLi	= 'TAMALIPEPRO',	-- Procedimiento de Aplicacion de limites personal de lineas de crédito. TAMALIPEPRO.
		@Pro_InDeLi	= 'TAMAINDEPRO',	-- Procedimiento de incremento y decremento de lineas de credito. TAMAINDEPRO.
		@Pro_CanLin	= 'TAMACALIPRO',	-- Procedimiento de Aplicacion de Cancelacion de lineas. TAMACALIPRO.
        @Pro_AltLin = 'TAMAALHEPRO',    -- Procedimiento de Alta de lineas Hey. TAMAALHEPRO
        @Pro_VerCli = 'CLMAVECLPRO',    -- Procedimiento de Verificacion de Clientes. CLMAVECLPRO
		@Pro_CliCat = 'CLMACLCAPRO',    -- Procedimiento de Clientes Categorias. CLMACLCAPRO
        @Pro_MotCat = 'CLMAMOCAPRO',    -- Procedimiento de Motivos Categorias. CLMAMOCAPRO
        @Pro_ActRap = 'CTMAARAPPRO'     -- Procedimiento de Actualizacion de registros Apple Pay 
--
select	@Pro_ExiEje	= @Bit_No

select	@Stp_Proced	= Prf_Proced
	from SOPROFLU noholdlock
	where Prf_Numero	= @Num_ProFlu

if @Stp_Proced	= @Pro_LiPeLi begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= TAMALIPEPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_InDeLi begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= TAMAINDEPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_CanLin begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
	
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= TAMACALIPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_BlDeLi begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
	
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= TAMABLDEPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end
	
	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_AltLin begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
	
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= TAMAALHEPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end
	
	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_VerCli begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= CLMAVECLPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_CliCat begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= CLMACLCAPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end  else if @Stp_Proced	= @Pro_MotCat begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= CLMAMOCAPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end else if @Stp_Proced	= @Pro_ActRap begin

	select @Par_EntUno	= convert(int, isnull(Ppe_Valor, Ppf_Valor))
	from SOPAPRFL noholdlock
	left join SOPAPREJ noholdlock
			on Ppe_EjeFlu	= @Num_EjeFlu
			and Ppe_PaPrFl	= Ppf_Numero
	where Ppf_ProFlu = @Num_ProFlu
	  and Ppf_NomPar = @Par_TipEje
	  and Ppf_Activo = @Bit_Si
		
	select	@Res_EjeIns	= @@error
	if @Res_EjeIns	<> @Ent_Cero begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return @Ent_Uno
	end
	
	if @Par_EntUno	is null begin
		select @Men_Error = 'Error al obtener valor del Parametro [' + @Par_TipEje + '] Valor: null'
		return @Ent_Uno
	end

	execute	@Status	= CTMAARAPPRO
		@Num_EjeFlu	= @Num_EjeFlu,
		@Num_ProFlu	= @Num_ProFlu,
		@Tip_Ejecuc	= @Par_EntUno,	-- Tipo de Ejecucion: 1.- Validacion 2.- Ejecucion
		@NumTransac	= @NumTransac, 
		@Transaccio	= @Transaccio,  
		@Usuario	= @Usuario, 
		@FechaSis	= @FechaSis, 
		@SucOrigen	= @SucOrigen,
		@SucDestino	= @SucDestino,
		@Modulo		= @Modulo

	--Si se detecta un error de ejecucion del procedimiento, reporta el Codigo de error.
	select @Res_EjeIns = @@error
	if @Res_EjeIns <> @Ent_Cero begin
		select	@Men_Error = 'ERROR de ejecucion (Sybase) Codigo: ' + convert(varchar(10), @Res_EjeIns)
		return	@Res_EjeIns
	end
	--Si el procedimiento respondio con error, registrar que el error fue dentro del proceso ejecutado
	if @Status <> @Ent_Cero begin
		select	@Men_Error = 'ERROR dentro del proceso de [' + @Stp_Proced + ']. Codigo: ' + convert(varchar(10), @Status)
		return	@Status
	end

	select	@Pro_ExiEje	= @Bit_Si
end
if 	@Pro_ExiEje	= @Bit_No begin
	select @Men_Error = 'El procedimiento [' + @Stp_Proced + '] no esta configuracion para ejecucion en SOEJEPROPRO'
	return @Ent_Uno
end