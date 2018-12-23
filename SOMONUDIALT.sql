create procedure SOMONUDIALT(
	@Mon_Numero char(2),
	@Mon_Fecha  smalldatetime,
	@Mon_Descri varchar(30),
	@Mon_EfeCom	double precision,	

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

declare @Par_FecAct smalldatetime,		/* Declaración de Variables */
		@Status		int

declare	@Dob_Cero	double precision,	/* Declaración de Constantes */
		@Ent_Cero	int,
		@Fec_Vacia	smalldatetime

/* Asignación de Constantes */
select	@Dob_Cero	= 0.00,				/* Double Precision en cero */
		@Ent_Cero	= 0,				/* Entero en Cero */
		@Fec_Vacia	= '1900-01-01'		/* Fecha Vacía */

select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

if convert(int, @Mon_Numero) = @Ent_Cero begin
	select	Err_Codigo = '000001',
			Err_Mensaj = 'Numero incorrecto', 
			Err_Variab = 'Mon_Numero'
	rollback
	return 1
end 

if not exists (select	Mon_Numero
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Numero) begin
	select 	Err_Codigo = '000002', 
			Err_Mensaj = 'La moneda no existe', 
			Err_Variab = 'Mon_Numero'
	rollback
	return 1
end 

if @Mon_EfeCom <= @Dob_Cero begin
	select	Err_Codigo = '000003', 
			Err_Mensaj = 'Tipo de Cambio incorrecto', 
			Err_Variab = 'Mon_EfeCom'
	rollback
	return 1
end 

if isnull(@Mon_Fecha, @Fec_Vacia) = @Fec_Vacia begin
	select	Err_Codigo = '000004', 
			Err_Mensaj = 'Fecha incorrecta', 
			Err_Variab = 'Mon_Fecha'
	rollback
	return 1
end 

if @Mon_Fecha < @Par_FecAct begin
	select	Err_Codigo = '000005', 
			Err_Mensaj = 'No se puede actualizar el valor a una fecha anterior a la actual', 
			Err_Variab = 'Mon_Fecha'
	rollback
	return 1
end 

if @Mon_Fecha  = @Par_FecAct 
	update SOMONEDA set
		Mon_Fecha 	= @Mon_Fecha,
		Mon_EfeCom	= @Mon_EfeCom,
		Mon_EfeVen	= @Mon_EfeCom,
		Mon_DocCom	= @Mon_EfeCom,
		Mon_DocVen	= @Mon_EfeCom,
		Mon_FixCom	= @Mon_EfeCom,
		Mon_FixVen	= @Mon_EfeCom,
		Mon_CieCom	= @Mon_EfeCom,
		Mon_CieVen	= @Mon_EfeCom,
		Mon_FixVal	= @Mon_EfeCom,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino															
	where	Mon_Numero	= @Mon_Numero		

exec @Status = SOHISMONALT
	@Mon_Numero,	@Mon_Fecha,		@Mon_EfeCom,	@Mon_EfeCom, 	@Mon_EfeCom,
	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,
	@Dob_Cero,		@Dob_Cero,		@Dob_Cero,		@Mon_EfeCom,	@NumTransac,	
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	
	@Modulo		
if @Status <> 0 begin
	rollback
	return 1
end		

/* Alta en la Bitacora */
exec @Status = SOBITMONALT
	@Mon_Numero,	@Mon_Fecha,		@Mon_EfeCom,	@Mon_EfeCom, 	@Mon_EfeCom,
	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,	@Mon_EfeCom,
	@Dob_Cero,		@Dob_Cero,		@Dob_Cero,		@Mon_EfeCom,	@NumTransac,	
	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	
	@Modulo		
if @Status <> 0 begin
	rollback
	return 1
end				

select 	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
