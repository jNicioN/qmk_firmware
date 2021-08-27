create procedure SOCATACOBAJ (
	@Ctc_Numero	int,
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
** DESCRIPCION:	Baja de catálogo para tasas					****
**				que requieren confirmación								****
****************************************************************************
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Creó:		Fernanda Murillo										****
** Fecha:		24/Agosto/2021											****
** Help:		1556250 												****
****************************************************************************
*/

-- Declaración de constantes
declare	@Chr_Vacio	char(1),
		@Chr_StaAct	char(1),
		@Chr_StaIna	char(1),
		@Int_Cero	int,
		@Int_Uno	int,
		@Existe		int

-- Asignación de constantes
select	@Chr_Vacio	= '',	-- Caracter vacío
		@Chr_StaAct	= 'A',	-- Caracter de status "Activo"
		@Chr_StaIna	= 'I',	-- Caracter de status "Inactivo"
		@Int_Cero	= 0,	-- Número entero cero
		@Int_Uno	= 1		-- Número entero uno


	if isnull(@Ctc_Numero, @Int_Cero)	= @Int_Cero begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Número incorrecto de la tasa',
				Err_Variab	= 'Ctc_TasNum'
		rollback
	
		return 1
	end
	
	select	@Existe	= count(0)
		from	SOCATACO noholdlock
		where	Ctc_Numero	= @Ctc_Numero
		
	if @Existe	= @Int_Cero begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'La confirmación ' + convert(varchar,@Ctc_Numero) + ' no existe',
				Err_Variab	= 'Ctc_Numero'
		rollback
	
		return 1
	end
	
	update SOCATACO set
		Ctc_Status	= @Chr_StaIna,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Ctc_Numero	= @Ctc_Numero
	
	if @@nestlevel = @Int_Uno begin
		select	Err_Codigo	= '000000',
				Ctc_Numero	= @Ctc_Numero,
				Err_Mensaj	= 'Registro actualizado'
	end