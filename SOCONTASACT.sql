create procedure SOCONTASACT (
	@Cot_TasNum	char(2),
	@Cot_Descri	varchar(80),
	@Cot_Abrevi	varchar(10),
	@Cot_Valor	double precision,
	@Cot_ValDos	double precision,
	@Cot_Fecha	smalldatetime,
	@Cot_Moneda	char(2),
	@Cot_Extemp	char(1),
	@Cot_SelPar	char(1),
	@Cot_StaAct	char(1),
	@Cot_UsuMov	int,
	@Cot_FecMov	smalldatetime,
	@Cot_Status	char(1),
	@Cot_Coment	varchar(200),

	@Tip_Actual	char(1),

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
** DESCRIPCION:	Actualización de tasas para posterior confirmación		****
****************************************************************************
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó:	Manuel Adrián Flores Félix								****
** Fecha:		28/ENero/2020											****
** Help:		1149607													****
** Descripción:	Se guarda ValDos desde pantalla.						****
****************************************************************************
** Creó:		Manuel Adrián Flores Félix								****
** Fecha:		11/Noviembre/2019										****
** Help:		1149607													****
****************************************************************************
*/

-- Declaración de constantes
declare	@Mon_Cero	money,
		@Chr_Vacio	char(1),
		@Int_Cero	int,
		@Int_Uno	int,
		@Fec_Vacia	smalldatetime,
		@Tas_NoSePa	char(1),
		@Tas_SiSePa	char(1),
		@Tas_SiExte	char(1),
		@Tas_NoExte	char(1),
		@Sta_TasAct	char(1),
		@Sta_TasIna	char(1),
		@Sta_ConAlt	char(1),
		@Sta_ConCon	char(1),
		@Sta_ConRec	char(1),
		@Act_Genera	char(1),
		@Act_StaCon	char(1)

-- Definición de constantes
select	@Mon_Cero	= $0.00,			-- Cantidad monetaria cero
		@Chr_Vacio	= '',				-- Caracter vacío
		@Int_Cero	= 0,				-- Número entero cero
		@Int_Uno	= 1,				-- Número entero uno
		@Fec_Vacia	= '1900-01-01',		-- Fecha por default nula
		@Tas_NoSePa	= 'N',				-- Tasa no de seleccion parcial
		@Tas_SiSePa	= 'S',				-- Tasa sí de seleccion parcial
		@Tas_SiExte	= 'S',				-- Tasa extemporanea
		@Tas_NoExte	= 'N',				-- Tasa no extemporanea
		@Sta_TasAct	= 'S',				-- Tasa activada
		@Sta_TasIna	= 'N',				-- Tasa inactiva
		@Sta_ConAlt	= 'A',				-- Status "Alta" para confirmación
		@Sta_ConCon	= 'C',				-- Status "Confirmado" para confirmación
		@Sta_ConRec	= 'R',				-- Status "Rechazado" para confirmación
		@Act_Genera	= '1',				-- Tipo de actualización general de registro completo
		@Act_StaCon	= '2'				-- Tipo de actualización para el status de una confirmación

if isnull(@Cot_TasNum, @Chr_Vacio) = @Chr_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Número incorrecto de la tasa',
			Err_Variab	= 'Cot_TasNum'
	rollback

	return 1
end

if (select count(0)
	from SOCONTAS noholdlock
	where Cot_TasNum	= @Cot_TasNum)	= @Int_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Número de tasa no registrado',
			Err_Variab	= 'Cot_TasNum'
	rollback

	return 1
end

if @Tip_Actual = @Act_Genera begin
	if isnull(@Cot_Descri, @Chr_Vacio) = @Chr_Vacio begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Descripción incorrecta de la tasa',
				Err_Variab	= 'Cot_Descri'
		rollback

		return 1
	end

	if isnull(@Cot_Abrevi, @Chr_Vacio) = @Chr_Vacio begin
		select 	Err_Codigo	= '000004',
				Err_Mensaj	= 'Abreviación incorrecta de la tasa',
				Err_Variab	= 'Cot_Abrevi'
		rollback

		return 1
	end

	if @Cot_Valor <= @Mon_Cero begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'Valor incorrecto de la tasa',
				Err_Variab	= 'Cot_Valor'
		rollback

		return 1
	end

	if @Cot_ValDos < @Mon_Cero begin
		select	Err_Codigo	= '000006',
				Err_Mensaj	= 'Valor 2 incorrecto de la tasa',
				Err_Variab	= 'Cot_ValDos'
		rollback

		return 1
	end

	if @Cot_Fecha <= @Fec_Vacia begin
		select	Err_Codigo	= '000007',
				Err_Mensaj	= 'Fecha incorrecta de la tasa',
				Err_Variab	= 'Cot_Fecha'
		rollback

		return 1
	end

	if (select	count(0)
		from	SOMONEDA noholdlock
		where	Mon_Numero	= @Cot_Moneda) = @Int_Cero begin

		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'Moneda '+@Cot_Moneda+' no existe',
				Err_Variab	= 'Cot_Moneda'
		rollback

		return 1
	end

	if @Cot_Extemp not in(@Tas_SiExte, @Tas_NoExte) begin
		select	Err_Codigo	= '000009',
				Err_Mensaj	= 'Valor extemporaneo de tasa incorrecto',
				Err_Variab	= 'Cot_SelPar'
		rollback

		return 1
	end

	if @Cot_SelPar not in(@Tas_NoSePa, @Tas_SiSePa) begin
		select	Err_Codigo	= '000010',
				Err_Mensaj	= 'Tipo de selección incorrecta',
				Err_Variab	= 'Cot_SelPar'
		rollback

		return 1
	end

	if @Cot_StaAct not in(@Sta_TasAct, @Sta_TasIna) begin
		select	Err_Codigo	= '000011',
				Err_Mensaj	= 'Status de tasa incorrecto',
				Err_Variab	= 'Cot_StaAct'
		rollback

		return 1
	end

	if (select	count(0)
		from	SOUSUARI noholdlock
		where	SoUsuariID	= @Cot_UsuMov) = @Int_Cero begin

		select	Err_Codigo	= '000012',
				Err_Mensaj	= 'Usuario '+convert(varchar, @Cot_UsuMov)+' no existe',
				Err_Variab	= 'Cot_UsuMov'
		rollback

		return 1
	end

	if @Cot_FecMov <= @Fec_Vacia begin
		select	Err_Codigo	= '000013',
				Err_Mensaj	= 'Fecha incorrecta de de movimiento',
				Err_Variab	= 'Cot_FecMov'
		rollback

		return 1
	end

	if @Cot_Status not in(@Sta_ConAlt, @Sta_ConCon, @Sta_ConRec) begin
		select	Err_Codigo	= '000014',
				Err_Mensaj	= 'Status deconfirmación incorrecto',
				Err_Variab	= 'Cot_Status'
		rollback

		return 1
	end

	update SOCONTAS set
		Cot_Descri	= @Cot_Descri,
		Cot_Abrevi	= @Cot_Abrevi,
		Cot_Valor	= @Cot_Valor,
		Cot_ValDos	= @Cot_ValDos,
		Cot_Fecha	= @Cot_Fecha,
		Cot_Moneda	= @Cot_Moneda,
		Cot_Extemp	= @Cot_Extemp,
		Cot_SelPar	= @Cot_SelPar,
		Cot_StaAct	= @Sta_TasAct,
		Cot_UsuMov	= @Cot_UsuMov,
		Cot_FecMov	= @Cot_FecMov,
		Cot_Status	= @Sta_ConAlt,
		Cot_Coment	= @Chr_Vacio,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Cot_TasNum	= @Cot_TasNum
end

if @Tip_Actual = @Act_StaCon begin
	if (select	count(0)
		from	SOUSUARI noholdlock
		where	SoUsuariID	= @Cot_UsuMov) = @Int_Cero begin

		select	Err_Codigo	= '000015',
				Err_Mensaj	= 'Usuario '+convert(varchar, @Cot_UsuMov)+' no existe',
				Err_Variab	= 'Cot_UsuMov'
		rollback

		return 1
	end

	if @Cot_FecMov <= @Fec_Vacia begin
		select	Err_Codigo	= '000016',
				Err_Mensaj	= 'Fecha incorrecta de de movimiento',
				Err_Variab	= 'Cot_FecMov'
		rollback

		return 1
	end

	if @Cot_Status not in(@Sta_ConAlt, @Sta_ConCon, @Sta_ConRec) begin
		select	Err_Codigo	= '000017',
				Err_Mensaj	= 'Status deconfirmación incorrecto',
				Err_Variab	= 'Cot_Status'
		rollback

		return 1
	end

	update SOCONTAS set
		Cot_UsuMov	= @Cot_UsuMov,
		Cot_FecMov	= @Cot_FecMov,
		Cot_Status	= @Cot_Status,
		Cot_Coment	= @Cot_Coment,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where	Cot_TasNum	= @Cot_TasNum
end

if @@nestlevel = @Int_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro actualizado'
end