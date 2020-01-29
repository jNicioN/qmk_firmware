create procedure SOCONTASPRO (
	@Cot_TasNum	char(2),
	@Cot_Descri	varchar(80),
	@Cot_Abrevi	varchar(10),
	@Cot_Valor	double precision,
	@Cot_Fecha	smalldatetime,
	@Cot_Moneda	char(2),
	@Cot_SelPar	char(1),
	@Cot_UsuMov	char(6),
	@Cot_Status	char(1),
	@Cot_Coment	varchar(200),

	@Tip_Proces	char(2),
	
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
** DESCRIPCION:	Registro y actualización de tasas						****
**				y bitácora de confirmaciones y rechazos					****
****************************************************************************
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Manuel Adrián Flores Félix								****
** Fecha:		05/Noviembre/2019										****
** Help:		1149607													****
****************************************************************************
*/

-- Declaración de variables
declare	@Status				int,
		@UsuarioMov			int,
		@FechaMov			smalldatetime,
		@TasValHis			double precision,
		@BitTasNum			char(2),
		@BitDescri			varchar(80),
		@BitAbrevi			varchar(10),
		@BitValor			double precision,
		@BitFecha			smalldatetime,
		@BitMoneda			char(2),
		@BitNoExt			char(1),
		@BitSelPar			char(1),
		@BitStaAct			char(1),
		@BitUsuMov			int,
		@BitFecMov			smalldatetime,
		@BitStatus			char(1),
		@BitComent			varchar(200)

-- Declaración de constantes
declare	@Mon_Cero	money,
		@Int_Cero	int,
		@Int_Uno	int,
		@Chr_Vacio	char(1),
		@Chr_Uno	char(1),
		@Chr_Dos	char(1),
		@Fec_Vacia	smalldatetime,
		@Cot_NoExt	char(1),
		@Cot_NoSePa	char(1),
		@Cot_SiSePa	char(1),
		@Sta_TasAct	char(1),
		@Sta_ConAlt	char(1),
		@Sta_ConCon	char(1),
		@Sta_ConRec	char(1),
		@Tip_Regist	char(2)

-- Asignacion de constantes
select	@Mon_Cero	= $0.00,			-- Cantidad monetaria cero
		@Int_Cero	= 0,				-- Número entero cero
		@Int_Uno	= 1,				-- Número entero uno
		@Chr_Vacio	= '',				-- Caracter de texto vacío
		@Chr_Uno	= '1',				-- Caracter de número uno
		@Chr_Dos	= '2',				-- Caracter de número 2
		@Fec_Vacia	= '1900-01-01',		-- Fecha por default nula
		@Cot_NoExt	= 'N',				-- Tasa no extemporanea
		@Cot_NoSePa	= 'N',				-- Tasa no de seleccion parcial
		@Cot_SiSePa	= 'S',				-- Tasa sí de seleccion parcial
		@Sta_TasAct	= 'S',				-- Status de tasa activa
		@Sta_ConAlt	= 'A',				-- Status "Alta" para confirmación
		@Sta_ConCon	= 'C',				-- Status "Confirmado" para confirmación
		@Sta_ConRec	= 'R',				-- Status "Rechazado" para confirmación
		@Tip_Regist	= '01'				-- Tipo de proceso "Registro"

if isnull(@Cot_TasNum, @Chr_Vacio) = @Chr_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Número incorrecto de la tasa',
			Err_Variab	= 'Cot_Numero'
	rollback

	return 1
end

if isnull(@Cot_Descri, @Chr_Vacio) = @Chr_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripción incorrecta de la tasa',
			Err_Variab	= 'Cot_Descri'
	rollback

	return 1
end

if isnull(@Cot_Abrevi, @Chr_Vacio) = @Chr_Vacio begin
	select 	Err_Codigo	= '000003',
			Err_Mensaj	= 'Abreviación incorrecta de la tasa',
			Err_Variab	= 'Cot_Abrevi'
	rollback

	return 1
end

if @Cot_Valor <= @Mon_Cero begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Valor incorrecto de la tasa',
			Err_Variab	= 'Cot_Valor'
	rollback

	return 1
end

if @Cot_Fecha <= @Fec_Vacia begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Fecha incorrecta de la tasa',
			Err_Variab	= 'Cot_Fecha'
	rollback

	return 1
end

if (select	count(0)
	from	SOMONEDA noholdlock
	where	Mon_Numero	= @Cot_Moneda) = @Int_Cero begin

	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Moneda '+@Cot_Moneda+' no existe',
			Err_Variab	= 'Cot_Moneda'
	rollback

	return 1
end

if @Cot_SelPar not in(@Cot_NoSePa, @Cot_SiSePa) begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Tipo de selección incorrecta',
			Err_Variab	= 'Cot_SelPar'
	rollback

	return 1
end

if (select	count(0)
	from	SOUSUARI noholdlock
	where	Usu_Numero	= @Cot_UsuMov) = @Int_Cero begin

	select	Err_Codigo	= '000008',
			Err_Mensaj	= 'Usuario '+@Cot_UsuMov+' no existe',
			Err_Variab	= 'Cot_UsuMov'
	rollback

	return 1
end

if @Cot_Status not in(@Sta_ConAlt, @Sta_ConCon, @Sta_ConRec) begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'Status de confirmación incorrecto',
			Err_Variab	= 'Cot_Status'
	rollback

	return 1
end

select	@FechaMov	= Par_FecAct
from	SOPARAMS noholdlock
where	Par_Sucurs = @SucOrigen

select	@UsuarioMov	= SoUsuariID
from	SOUSUARI noholdlock
where	Usu_Numero	= @Cot_UsuMov

if @Tip_Proces = @Tip_Regist begin
	if (select	count(0)
		from	SOCONTAS noholdlock
		where	Cot_TasNum	=	@Cot_TasNum) = @Int_Cero begin

		if @Cot_Status	!=	@Sta_ConAlt begin
			select	Err_Codigo	= '000010',
					Err_Mensaj	= 'Estatus '+@Cot_Status+' incorrecto, tasa '+@Cot_TasNum+' no existe',
					Err_Variab	= 'Cot_Status'
			rollback

			return 1
		end

		select	@BitDescri	= @Cot_Descri,
				@BitAbrevi	= @Cot_Abrevi,
				@BitValor	= @Cot_Valor,
				@BitFecha	= @Cot_Fecha,
				@BitMoneda	= @Cot_Moneda,
				@BitNoExt	= @Cot_NoExt,
				@BitSelPar	= @Cot_SelPar,
				@BitStaAct	= @Sta_TasAct,
				@BitUsuMov	= @UsuarioMov,
				@BitFecMov	= @FechaMov,
				@BitStatus	= @Sta_ConAlt,
				@BitComent	= @Chr_Vacio

		exec @Status = SOCONTASALT	@Cot_TasNum,	@Cot_Descri,	@Cot_Abrevi,	@Cot_Valor,		@Cot_Fecha,
									@Cot_Moneda,	@Cot_NoExt,		@Cot_SelPar,	@Sta_TasAct,	@UsuarioMov,
									@FechaMov,		@Sta_ConAlt,	@Chr_Vacio,		@NumTransac,	@Transaccio,
									@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

		if @Status	!= @Int_Cero begin
			select	Err_Codigo	= '000011',
					Err_Mensaj	= 'No fué posible realizar el alta de confirmación de tasa'
			rollback

			return 1
		end
	end else begin
		if (select	Cot_FecMov
			from	SOCONTAS noholdlock
			where	Cot_TasNum	=	@Cot_TasNum) > @FechaMov
			and	@Cot_Status	!=	@Sta_ConAlt begin

			select	Err_Codigo	= '000012',
					Err_Mensaj	= 'Fecha de movimiento anterior a la registrada',
					Err_Variab	= 'Cot_FecMov'
			rollback

			return 1
		end

		if @Cot_Status	= @Sta_ConAlt begin
			if (select	count(0)
				from	SOCONTAS noholdlock
				where	Cot_TasNum	=	@Cot_TasNum
					and	Cot_Status	=	@Sta_ConAlt
					and	Cot_FecMov	=	@FechaMov) > @Int_Cero begin

				select	Err_Codigo	= '000013',
						Err_Mensaj	= 'Tasa '+@Cot_TasNum+' existe y pendiente de confirmación'
				rollback

				return 1
			end

			select	@BitDescri	= @Cot_Descri,
					@BitAbrevi	= @Cot_Abrevi,
					@BitValor	= @Cot_Valor,
					@BitFecha	= @Cot_Fecha,
					@BitMoneda	= @Cot_Moneda,
					@BitNoExt	= @Cot_NoExt,
					@BitSelPar	= @Cot_SelPar,
					@BitStaAct	= @Sta_TasAct,
					@BitUsuMov	= @UsuarioMov,
					@BitFecMov	= @FechaMov,
					@BitStatus	= @Cot_Status,
					@BitComent	= @Chr_Vacio

			exec @Status = SOCONTASACT	@Cot_TasNum,	@Cot_Descri,	@Cot_Abrevi,	@Cot_Valor,		@Cot_Fecha,
										@Cot_Moneda,	@Cot_NoExt,		@Cot_SelPar,	@Sta_TasAct,	@UsuarioMov,
										@FechaMov,		@Cot_Status,	@Chr_Vacio,		@Chr_Uno,		@NumTransac,
										@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
										@Modulo

			if @Status	!= @Int_Cero begin
				select	Err_Codigo	= '000014',
						Err_Mensaj	= 'No fué posible realizar el registro de la confirmación'
				rollback

				return 1
			end
		end
		
		if @Cot_Status	= @Sta_ConCon begin
			if (select	count(0)
				from	SOCONTAS noholdlock
				where	Cot_TasNum	=	@Cot_TasNum
					and	Cot_Status	=	@Sta_ConCon
					and	Cot_FecMov	=	@FechaMov) > @Int_Cero begin

				select	Err_Codigo	= '000015',
						Err_Mensaj	= 'Tasa '+@Cot_TasNum+' ya ha sido confirmada'
				rollback

				return 1
			end

			if (select	count(0)
				from	SOCONTAS noholdlock
				where	Cot_TasNum	=	@Cot_TasNum
					and	Cot_Status	=	@Sta_ConRec
					and	Cot_FecMov	=	@FechaMov) > @Int_Cero begin

				select	Err_Codigo	= '000016',
						Err_Mensaj	= 'Tasa '+@Cot_TasNum+' ya ha sido rechazada'
				rollback

				return 1
			end

			select	@BitDescri	= Cot_Descri,
					@BitAbrevi	= Cot_Abrevi,
					@BitValor	= Cot_Valor,
					@BitFecha	= Cot_Fecha,
					@BitMoneda	= Cot_Moneda,
					@BitNoExt	= Cot_Extemp,
					@BitSelPar	= Cot_SelPar,
					@BitStaAct	= Cot_StaAct,
					@BitUsuMov	= @UsuarioMov,
					@BitFecMov	= @FechaMov,
					@BitStatus	= @Cot_Status,
					@BitComent	= Cot_Coment
			from	SOCONTAS noholdlock
			where	Cot_TasNum	= @Cot_TasNum

			exec @Status = SOCONTASACT	@Cot_TasNum,	@Chr_Vacio,		@Chr_Vacio,		@Int_Cero,		@Fec_Vacia,	
										@Chr_Vacio,		@Chr_Vacio,		@Chr_Vacio,		@Chr_Vacio,		@UsuarioMov,
										@FechaMov,		@Cot_Status,	@Chr_Vacio,		@Chr_Dos,		@NumTransac,
										@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
										@Modulo

			if @Status	!= @Int_Cero begin
				select	Err_Codigo	= '000017',
						Err_Mensaj	= 'No fué posible realizar la confirmación de la tasa'
				rollback

				return 1
			end

			if (select	count(0)
				from	SOTASAS noholdlock
				where	Tas_Numero	= @Cot_TasNum) = @Int_Cero begin

				exec @Status = SOTASASALT	@Cot_TasNum,	@BitDescri,		@BitAbrevi,		@BitValor,		@BitFecha,
											@BitMoneda,		@BitSelPar,		@NumTransac,	@Transaccio,	@Usuario,
											@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

				if @Status	!= @Int_Cero begin
					select	Err_Codigo	= '000018',
							Err_Mensaj	= 'No fué posible realizar el alta de tasa'
					rollback

					return 1
				end
			end else begin
				select	@TasValHis	=	Tas_Valor
				from	SOTASAS noholdlock
				where	Tas_Numero	=	@Cot_TasNum

				exec @Status = SOTASASMOD	@Cot_TasNum,	@BitDescri,		@BitAbrevi,		@BitValor,		@TasValHis,
											@BitFecha,		@BitMoneda,		@BitSelPar,		@NumTransac,	@Transaccio,
											@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

				if @Status	!= @Int_Cero begin
					select	Err_Codigo	= '000019',
							Err_Mensaj	= 'No fué posible realizar la actualización de tasa'
					rollback

					return 1
				end
			end
		end

		if @Cot_Status	= @Sta_ConRec begin
			if (select	count(0)
				from	SOCONTAS noholdlock
				where	Cot_TasNum	=	@Cot_TasNum
					and	Cot_Status	=	@Sta_ConCon
					and	Cot_FecMov	=	@FechaMov) > @Int_Cero begin

				select	Err_Codigo	= '000020',
						Err_Mensaj	= 'Tasa '+@Cot_TasNum+' ya ha sido confirmada'
				rollback

				return 1
			end

			if (select	count(0)
				from	SOCONTAS noholdlock
				where	Cot_TasNum	=	@Cot_TasNum
					and	Cot_Status	=	@Sta_ConRec
					and	Cot_FecMov	=	@FechaMov) > @Int_Cero begin

				select	Err_Codigo	= '000021',
						Err_Mensaj	= 'Tasa '+@Cot_TasNum+' ya ha sido rechazada'
				rollback

				return 1
			end

			if isnull(@Cot_Coment, @Chr_Vacio)	= @Chr_Vacio begin
				select	Err_Codigo	= '000022',
						Err_Mensaj	= 'Comentario obligatorio al rechazar tasa',
						Err_Variab	= 'Cot_Coment'
				rollback

				return 1
			end

			select	@BitDescri	= Cot_Descri,
					@BitAbrevi	= Cot_Abrevi,
					@BitValor	= Cot_Valor,
					@BitFecha	= Cot_Fecha,
					@BitMoneda	= Cot_Moneda,
					@BitNoExt	= Cot_Extemp,
					@BitSelPar	= Cot_SelPar,
					@BitStaAct	= Cot_StaAct,
					@BitUsuMov	= @UsuarioMov,
					@BitFecMov	= @FechaMov,
					@BitStatus	= @Cot_Status,
					@BitComent	= @Cot_Coment
			from	SOCONTAS noholdlock
			where	Cot_TasNum	= @Cot_TasNum

			exec @Status = SOCONTASACT	@Cot_TasNum,	@Chr_Vacio,		@Chr_Vacio,		@Int_Cero,		@Fec_Vacia,	
										@Chr_Vacio,		@Chr_Vacio,		@Chr_Vacio,		@Chr_Vacio,		@UsuarioMov,
										@FechaMov,		@Cot_Status,	@Cot_Coment,	@Chr_Dos,		@NumTransac,
										@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
										@Modulo

			if @Status	!= @Int_Cero begin
				select	Err_Codigo	= '000023',
						Err_Mensaj	= 'No fué posible realizar la confirmación de la tasa'
				rollback

				return 1
			end
		end
	end

	exec @Status = SOBICOTAALT	@Cot_TasNum,	@BitDescri,		@BitAbrevi,		@BitValor,		@BitFecha,
								@BitMoneda,		@BitNoExt,		@BitSelPar,		@BitStaAct,		@BitUsuMov,
								@BitFecMov,		@BitStatus,		@BitComent,		@NumTransac,	@Transaccio,
								@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

	if @Status	!= @Int_Cero begin
		select	Err_Codigo	= '000024',
				Err_Mensaj	= 'No fué posible realizar el alta de bitácora'
		rollback

		return 1
	end
end

if @@nestlevel	= @Int_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Proceso realizado con éxito'