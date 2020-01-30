create procedure SOCONTASCON (
	@Cot_Numero	int,
	@Cot_TasNum	char(2),
	@Cot_Status	char(1),

	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)

as

/*
****************************************************************************
** DESCRIPCION:	Consulta de de tasas pendientes y confirmadas			****
****************************************************************************
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó:	Manuel Adrián Flores Félix								****
** Fecha:		28/ENero/2020											****
** Help:		1149607													****
** Descripción:	Se agrega ValDos a resultset.							****
****************************************************************************
** Creó:		Manuel Adrián Flores Félix								****
** Fecha:		06/Noviembre/2019										****
** Help:		1149607													****
****************************************************************************
*/

-- Declaración de variables
declare	@TipConTip	char(1),
		@TipConCon	char(1),
		@FechaHoy	smalldatetime

-- Declaración de constantes
declare	@Chr_Vacio	char(1),
		@Chr_Consul	char(1),
		@Chr_Lista	char(1),
		@Chr_Uno	char(1),
		@Chr_Dos	char(1),
		@Chr_Tres	char(1),
		@Int_Cero	int,
		@Sta_ConAlt	char(1),
		@Sta_ConCon	char(1),
		@Sta_ConRec	char(1)

-- Asignación de constantes
select	@Chr_Vacio	= '',			-- Caracter de texto vacío
		@Chr_Consul	= 'C',			-- Caracter tipo consulta "Consulta"
		@Chr_Lista	= 'L',			-- Caracter tipo consulta "Lista"
		@Chr_Uno	= '1',			-- Caracter de número 1
		@Chr_Dos	= '2',			-- Caracter de número 2
		@Chr_Tres	= '3',			-- Caracter de número 2
		@Int_Cero	= 0,			-- Número entero 0
		@Sta_ConAlt	= 'A',			-- Status "Alta" para confirmación
		@Sta_ConCon	= 'C',			-- Status "Confirmado" para confirmación
		@Sta_ConRec	= 'R'			-- Status "Rechazado" para confirmación

if isnull(@Tip_Consul, @Chr_Vacio) = @Chr_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Tipo de consulta '+@Tip_Consul+' inválido',
			Err_Variab	= 'Tip_Consul'
	rollback
	return 1
end

select	@TipConTip	= substring(@Tip_Consul, 1, 1),
		@TipConCon	= substring(@Tip_Consul, 2, 1)

if @TipConTip = @Chr_Lista begin						/* Consultar lista */
	if @TipConCon = @Chr_Uno begin						/* Consulta lista general */
		select	Cot_Numero,	Cot_TasNum,	Cot_Descri,	Cot_Abrevi,	Cot_Valor,
				Cot_ValDos,	Cot_Fecha,	Cot_Moneda,	Cot_Extemp,	Cot_SelPar,
				Cot_StaAct,
				Cot_UsuMov	= Usu_Numero,
				Cot_FecMov,	Cot_Status,	Cot_Coment
		from	SOCONTAS noholdlock
		inner join SOUSUARI noholdlock
			on	SoUsuariID	= Cot_UsuMov
	end

	if @TipConCon = @Chr_Dos begin						/* Consulta lista por estatus */
		if isnull(@Cot_Status, @Chr_Vacio) = @Chr_Vacio begin
			select	Err_Codigo	= '000002',
					Err_Mensaj	= 'Estatus inválido',
					Err_Variab	= 'Cot_Status'
			rollback

			return 1
		end

		if @Cot_Status not in (@Sta_ConAlt, @Sta_ConCon, @Sta_ConRec) begin
			select	Err_Codigo	= '000003',
					Err_Mensaj	= 'Estatus incorrecto',
					Err_Variab	= 'Cot_Status'
			rollback

			return 1
		end

		select	Cot_Numero,	Cot_TasNum,	Cot_Descri,	Cot_Abrevi,	Cot_Valor,
				Cot_ValDos,	Cot_Fecha,	Cot_Moneda,	Cot_Extemp,	Cot_SelPar,
				Cot_StaAct,
				Cot_UsuMov	= Usu_Numero,
				Cot_FecMov,	Cot_Status,	Cot_Coment
		from	SOCONTAS noholdlock
		inner join SOUSUARI noholdlock
			on	SoUsuariID	= Cot_UsuMov
		where	Cot_Status	= @Cot_Status
	end

	if @TipConCon = @Chr_Tres begin						/* Consulta lista registros por confirmar */
		select	@FechaHoy	= Par_Fecha
		from DEPARAMS noholdlock

		select	Cot_Numero,	Cot_TasNum,	Cot_Descri,	Cot_Abrevi,	Cot_Valor,
				Cot_ValDos,	Cot_Fecha,	Cot_Moneda,	Cot_Extemp,	Cot_SelPar,
				Cot_StaAct,
				Cot_UsuMov	= Usu_Numero,
				Cot_FecMov,	Cot_Status,	Cot_Coment
		from	SOCONTAS noholdlock
		inner join SOUSUARI noholdlock
			on	SoUsuariID	= Cot_UsuMov
		where	Cot_Status	!=	@Sta_ConCon
			and	Cot_FecMov	=	@FechaHoy
	end
end

if @TipConTip = @Chr_Consul begin						/* Consulta específica */
	if @TipConCon = @Chr_Uno begin						/* Consulta de registro específico */
		if isnull(@Cot_Numero, @Int_Cero) = @Int_Cero begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'Número inválido de registro',
					Err_Variab	= 'Cot_Numero'
			rollback

			return 1
		end

		select	Cot_Numero,	Cot_TasNum,	Cot_Descri,	Cot_Abrevi,	Cot_Valor,
				Cot_ValDos,	Cot_Fecha,	Cot_Moneda,	Cot_Extemp,	Cot_SelPar,
				Cot_StaAct,
				Cot_UsuMov	= Usu_Numero,
				Cot_FecMov,	Cot_Status,	Cot_Coment
		from	SOCONTAS noholdlock
		inner join SOUSUARI noholdlock
			on	SoUsuariID	= Cot_UsuMov
		where	Cot_Numero	= @Cot_Numero
	end

	if @TipConCon = @Chr_Dos begin						/* Consulta de registro por tasa */
		if isnull(@Cot_TasNum, @Chr_Vacio) = @Chr_Vacio begin
			select	Err_Codigo	= '000005',
					Err_Mensaj	= 'Número inválido de tasa',
					Err_Variab	= 'Cot_TasNum'
			rollback

			return 1
		end

		select	Cot_Numero,	Cot_TasNum,	Cot_Descri,	Cot_Abrevi,	Cot_Valor,
				Cot_ValDos,	Cot_Fecha,	Cot_Moneda,	Cot_Extemp,	Cot_SelPar,
				Cot_StaAct,
				Cot_UsuMov	= Usu_Numero,
				Cot_FecMov,	Cot_Status,	Cot_Coment
		from	SOCONTAS noholdlock
		inner join SOUSUARI noholdlock
			on	SoUsuariID	= Cot_UsuMov
		where	Cot_TasNum	= @Cot_TasNum
	end
end