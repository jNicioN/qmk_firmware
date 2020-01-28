create procedure SOCATACOMOD (
	@Ctc_TasNum	char(2),
	@Ctc_Status	char(1),

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
** DESCRIPCION:	Actualización de catálogo para tasas					****
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

-- Declaración de constantes
declare	@Chr_Vacio	char(1),
		@Chr_StaAct	char(1),
		@Chr_StaIna	char(1),
		@Int_Cero	int,
		@Int_Uno	int

-- Asignación de constantes
select	@Chr_Vacio	= '',	-- Caracter vacío
		@Chr_StaAct	= 'A',	-- Caracter de status "Activo"
		@Chr_StaIna	= 'I',	-- Caracter de status "Inactivo"
		@Int_Cero	= 0,	-- Número entero cero
		@Int_Uno	= 1		-- Número entero uno

if isnull(@Ctc_TasNum, @Chr_Vacio)	= @Chr_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Número incorrecto de la tasa',
			Err_Variab	= 'Ctc_TasNum'
	rollback

	return 1
end

if (select	count(0)
	from	SOTASAS noholdlock
	where	Tas_Numero	= @Ctc_TasNum)	= @Int_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Tasa '+@Ctc_TasNum+' no existe',
			Err_Variab	= 'Ctc_TasNum'
	rollback

	return 1
end

if	@Ctc_Status not in (@Chr_StaAct, @Chr_StaIna) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Status '+@Ctc_Status+' inválido',
			Err_Variab	= 'Ctc_Status'
	rollback

	return 1
end

update SOCATACO set
	Ctc_Status	= @Ctc_Status,
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
where Ctc_TasNum	= @Ctc_TasNum

if @@nestlevel = @Int_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro actualizado'
end