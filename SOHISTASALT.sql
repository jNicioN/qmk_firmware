create procedure SOHISTASALT (
	@Tas_Numero	char(2),
	@Tas_Fecha	smalldatetime,
	@Tas_Valor	double precision,
	@Tas_Valor2	double precision,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as	
/***************************************************************************
** DESCRIPCION: Alta de Tasas en el Historico							****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Modificó:	Norman Valenzuela										****
** Fecha:		26/Abril/2016											****
** Help:		000000													****
** Descripción:	Se agrega validacion de anio							****
****************************************************************************
** Modificó:	Jonathan Balderas Gauna									****
** Fecha:		23/Marzo/2016											****
** Help:		849927													****
** Descripción:	Se agrega parámetro @Tas_Valor2							****
****************************************************************************
** Creó:		FCHIA          											****
** Fecha:		23/Abr/01												****
****************************************************************************/

/* Declaración de Variables */
declare @Fec_Tasa   smalldatetime

/* Declaración de Constantes */
declare @Tas_INPC 	char(2),
		@Mon_Cero 	money,
		@Str_No		char(1),
		@Ent_Uno 	int,
		@anio       int

/* Asignacion de Constantes */
select 	@Tas_INPC   = '98', 		/* Tasa: INDICE NACIONAL DE PRECIOS AL CONSUMIDOR */
		@Mon_Cero	= 0.00,			/* Moneda en Ceros */
		@Str_No		= 'N',			/* Cadena No */
		@Ent_Uno 	= 1,				/* Entero Uno */
		@anio       = 2016

if @Tas_Numero = @Tas_INPC begin 
	if isnull(@Tas_Valor2, @Mon_Cero) = @Mon_Cero begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Valor de la Tasa Incorrecto',
				Err_Variab	= '@Tas_Valor2'
		rollback
		return 1
	end
	select @Fec_Tasa = convert (date , getdate())
	exec SOSIGFECHAB @Fec_Tasa output, @Ent_Uno, @Str_No, @Str_No
    IF (datepart(month, @Fec_Tasa) >= @anio)
	begin
		if (datepart(month, @Fec_Tasa) = datepart(month, convert (date , getdate()))) begin
			select	Err_Codigo	= '000002',
					Err_Mensaj	= 'Solo se puede modificar la Tasa INPC el último día hábil del mes',
					Err_Variab	= '@Tas_Fecha'
			rollback
			return 1
		end
	end
end

if exists ( select	Tas_Valor
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero)
	if exists ( select	Hit_Valor
					from SOHISTAS noholdlock
					where	Hit_Tasa	= @Tas_Numero
					  and	Hit_Fecha	= @Tas_Fecha )
					  
		update SOHISTAS set	
			Hit_Valor	= @Tas_Valor,
			Hit_Valor2  = @Tas_Valor2,
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
			where	Hit_Tasa	= @Tas_Numero
			  and	Hit_Fecha	= @Tas_Fecha
	else
		insert into SOHISTAS values (
			@Tas_Numero,	@Tas_Fecha, 	@Tas_Valor, 	@Tas_Valor2, 	@NumTransac,	
			@Transaccio, 	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino )
