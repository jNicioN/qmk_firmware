create procedure SOCATACOCON (
	@Ctc_Numero	int,
	@Ctc_TasNum	char(2),
	@Ctc_Status	char(1),

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
** DESCRIPCION:	Consulta de catálogo para tasas							****
**				que requieren confirmación								****
****************************************************************************
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Manuel Adrián Flores Félix								****
** Fecha:		08/Noviembre/2019										****
** Help:		1149607													****
****************************************************************************
*/

-- Declaración de variables
declare	@TipConTip	char(1),
		@TipConCon	char(1)

-- Declaración de constantes
declare	@Chr_Consul	char(1),
		@Chr_Lista	char(1),
		@Chr_Uno	char(1),
		@Chr_Dos	char(1),
		@Chr_Vacio	char(1),
		@Chr_StaAct	char(1),
		@Chr_StaIna	char(1),
		@Int_Cero	int

-- Asignación de constantes
select	@Chr_Consul	= 'C',			-- Caracter tipo consulta "Consulta"
		@Chr_Lista	= 'L',			-- Caracter tipo consulta "Lista"
		@Chr_Uno	= '1',			-- Caracter de número 1
		@Chr_Dos	= '2',			-- Caracter de número 2
		@Chr_Vacio	= '',			-- Caracter vacío
		@Chr_StaAct	= 'A',			-- Caracter de status "Activo"
		@Chr_StaIna	= 'I',			-- Caracter de status "Inactivo"
		@Int_Cero	= 0				-- Número entero cero

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
		select	Ctc_Numero,	Ctc_TasNum,	Ctc_Status
		from	SOCATACO noholdlock
	end

	if @TipConCon = @Chr_Dos begin						/* Consulta lista por status */
		if @Ctc_Status not in (@Chr_StaAct, @Chr_StaIna) begin
			select	Err_Codigo	= '000002',
					Err_Mensaj	= 'Status '+@Ctc_Status+' inválido',
					Err_Variab	= 'Ctc_Status'
			rollback
			return 1
		end

		select	Ctc_Numero,	Ctc_TasNum,	Ctc_Status
		from	SOCATACO noholdlock
		where	Ctc_Status	= @Ctc_Status
	end
end

if @TipConTip = @Chr_Consul begin						/* Consulta específica */
	if @TipConCon = @Chr_Uno begin						/* Consulta de registro específico */
		if isnull(@Ctc_Numero, @Int_Cero) = @Int_Cero begin
			select	Err_Codigo	= '000003',
					Err_Mensaj	= 'Número inválido de registro',
					Err_Variab	= 'Ctc_Numero'
			rollback

			return 1
		end

		select	Ctc_Numero,	Ctc_TasNum,	Ctc_Status
		from	SOCATACO noholdlock
		where	Ctc_Numero	= @Ctc_Numero
	end
	
	if @TipConCon = @Chr_Dos begin						/* Consulta específica de tasa */
		if (select	count(0)
			from	SOCATACO noholdlock
			where	Ctc_TasNum	= @Ctc_TasNum) = @Int_Cero begin

			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'Tasa '+@Ctc_TasNum+' no está registrada',
					Err_Variab	= 'Ctc_TasNum'
			rollback
			return 1
		end

		select	Ctc_Numero,	Ctc_TasNum,	Ctc_Status
		from	SOCATACO noholdlock
		where	Ctc_TasNum	= @Ctc_TasNum
	end
end