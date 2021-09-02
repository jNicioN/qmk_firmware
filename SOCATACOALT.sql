create procedure SOCATACOALT (
	@Ctc_TasNum	char(2),

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
** DESCRIPCION:	Alta catálogo para tasas que requieren confirmación		****
****************************************************************************
****************************************************************************
** REFERENCIAS:		
****************************************************************************
** Creó:		Gregorio Martínez										****
** Fecha:		04/Agosto/2021											****
** Descripción: Se agrega validación para las tasas que ya fueron		****
				confirmadas 											****
** Help:		1556250 												****													****
****************************************************************************
** Creó:		Manuel Adrián Flores Félix								****
** Fecha:		08/Noviembre/2019										****
** Help:		1149607													****
****************************************************************************
*/

-- Declaracion de Variables
declare @Ctc_Numero	int,
		@Exi_NumPro	int,
		@Exi_NumTas	int

-- Declaración de constantes
declare	@Chr_Vacio	char(1),
		@Chr_StaAct	char(1),
		@Int_Cero	int,
		@Int_Uno	int
		
-- Asignación de constantes
select	@Chr_Vacio	= '',	-- Caracter vacío
		@Chr_StaAct	= 'A',	-- Caracter de status "Activo"
		@Int_Cero	= 0,	-- Número entero cero
		@Int_Uno	= 1		-- Número entero uno

if isnull(@Ctc_TasNum, @Chr_Vacio)	= @Chr_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Número incorrecto de la tasa',
			Err_Variab	= 'Ctc_TasNum'
	rollback
	return 1
end

select	@Exi_NumPro	= count(1)
	from	SOCATACO noholdlock
	where	Ctc_TasNum	= @Ctc_TasNum

if @Exi_NumPro	> @Int_Cero begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Confirmacion de la Tasa '+ @Ctc_TasNum+' ya se encuentra registrada',
			Err_Variab	= 'Ctc_TasNum'
	rollback

	return 1
end

select	@Exi_NumTas	= count(0)
	from	SOTASAS noholdlock
	where	Tas_Numero	= @Ctc_TasNum

if @Exi_NumTas	= @Int_Cero begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Tasa '+ @Ctc_TasNum +' no existe',
			Err_Variab	= 'Ctc_TasNum'
	rollback
	return 1
end

insert into SOCATACO (	Ctc_TasNum,		Ctc_Status,		NumTransac,		Transaccio,		Usuario,
						FechaSis,		SucOrigen,		SucDestino
					) values (
						@Ctc_TasNum,	@Chr_StaAct,	@NumTransac,	@Transaccio,	@Usuario,
						@FechaSis,		@SucOrigen,		@SucDestino
					)
					
select	@Ctc_Numero	= @@identity

if @@nestlevel = @Int_Uno begin
	select	Err_Codigo	= '000000',
	Ctc_Numero	= @Ctc_Numero,
			Err_Mensaj	= 'Registro insertado'
end