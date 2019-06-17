create procedure SOTASASMOD (
	@Tas_Numero	char(2),
	@Tas_Descri	varchar(80),
	@Tas_Abrevi	varchar(10),
	@Tas_Valor 	double precision,
	@Tas_Valor2	double precision,
	@Tas_Fecha 	smalldatetime,
	@Tas_Moneda char(2),
	@Tas_SelPar	char(1),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2) )

as
/* NOTA: Las TABLAS AFECTADAS deben ejecutarse antes compilar el stored procedure*/
/* TABLAS AFECTADAS: */
/*Modifica una tasa en SOTASAS donde TAS_NUMERO = @TAS_NUMERO
Si TAS_VALOR o TAS_FECHA fueron modificados
	Agrega un registro en SOHISTAS con @TAS_NUMERO, @TAS_VALOR y @TAS_FECHA*/
/* NOTA: Las SALIDAS deben ejecutarse despues de compilar el stored procedure*/

/* SALIDAS: */
/*Ninguna*/ 
/*****************************************************************************/
/* DESCRIPCION: ** Modificacion de una tasa de interes ** */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modificó:	Jonathan Balderas Gauna									****
** Fecha:		23/Marzo/2016											****
** Help:		849927													****
** Descripción:	Se agrega parámetro @Tas_Valor2							****
****************************************************************************
**				STORE CONVERTIDO										****
**	Fecha:		30/Ago/2006												****
**	Convirtió:	Perla J. Abundis Orozco									****
****************************************************************************
** Modificó:	Ignacio Ordaz Valtierra    								****
** Fecha:		03/Julio/2014											****
** Help:		614254													****
** Descripción:	Se agrega act de tasas de pagare						****
****************************************************************************
** Modificó:	Juan Muñoz												****
** Fecha:		23/Septiembre/2013										****
** Help:		00593235												****
** Descripción:	Actualización de Tasas de CETES (CETASAS)				****
****************************************************************************
** Modificó:	Jorge Ortega Rodríguez									****
** Fecha:		02/Agosto/2006											****
** Help:		00124820.002											****
** Descripción:	Se agrego @Tas_NoSePa y @Tas_SiSePa, la					****
**				validación de @Tas_SelPar y al update					****
****************************************************************************
** 				STORE CONVERTIDO										****
** Convirtió:   Perla Judith Abundis Orozco								****
** Fecha:       08/Febrero/2005 12:16 pm								****		
****************************************************************************
** Modificó:	FCHIA          											****
** Fecha:		23/Abr/01												****
** Descripción:	Se agrego la Moneda (Tas_Moneda)						****		
****************************************************************************/

declare	@Status		int,					/* Declaración de Variables */
		@Fot_Produc	char(02)
		
declare	@Mon_Cero	money,					/* Declaración de Constantes */
		@Ent_Cero	int,
		@Str_Vacio	char(1),
		@Tas_NoSePa	char(1),
		@Tas_SiSePa	char(1),
		@Fec_Vacia	smalldatetime,
		@Tip_Produc	char(1),
		@Tas_CETE	char(2),
		@Act_Pagare	char(1)

/* Asignacion de Constantes */
select	@Mon_Cero	= $0.00,			/* Moneda en Ceros */
		@Ent_Cero	= 0,				/* Entero en Cero */
		@Str_Vacio	= '',				/* String Vacio */
		@Tas_NoSePa	= 'N',				/* Tasa No De Seleccion Parcial */
		@Tas_SiSePa	= 'S',				/* Tasa Sí De Seleccion Parcial */
		@Fec_Vacia	= '1900-01-01',		/* Fecha Vacia */
		@Tip_Produc	= 'P',				
		@Tas_CETE	= '02',				/* Tasa CETE 28 */	
		@Act_Pagare	= 'A'				/* Tipo de act para pagare */			

select	@FechaSis	= getdate()

if not exists ( select	Tas_Numero
					from SOTASAS noholdlock
					where	Tas_Numero	= @Tas_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La Tasa No Existe',
			Err_Variab	= 'Tas_Numero'
	rollback
	return 1
end 

if @Tas_Descri = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripcion Incorrecta',
			Err_Variab	= 'Tas_Descri'
	rollback
	return 1
end 

if @Tas_Abrevi = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Abreviacion Incorrecta',
			Err_Variab 	= 'Tas_Abrevi'
	rollback
	return 1
end 

if @Tas_Valor = @Mon_Cero begin
	select	Err_Codigo	= '000004',
			Err_Mensaj 	= 'Valor de la Tasa Incorrecto',
			Err_Variab 	= 'Tas_Valor'
	rollback
	return 1
end 

if @Tas_Fecha <= @Fec_Vacia begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Fecha incorrecta',
			Err_Variab	= 'Tas_Fecha'
	rollback
	return 1
end 

if @Tas_SelPar not in(@Tas_NoSePa, @Tas_SiSePa) begin
	select	Err_Codigo	= '000006',
			Err_Mensaj 	= 'Tipo De Seleccion Incorrecta',
			Err_Variab 	= 'Tas_SelPar'
	rollback
	return 1
end 

update SOTASAS set
	Tas_Numero 	= @Tas_Numero,
	Tas_Descri	= @Tas_Descri,
	Tas_Abrevi	= @Tas_Abrevi,
	Tas_Valor  	= @Tas_Valor,
	Tas_Fecha  	= @Tas_Fecha,
	Tas_Moneda	= @Tas_Moneda,
	Tas_SelPar	= @Tas_SelPar,
	
	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Tas_Numero	= @Tas_Numero

exec @Status = SOHISTASALT
	@Tas_Numero,	@Tas_Fecha,	@Tas_Valor,	@Tas_Valor2, 	@NumTransac,	
	@Transaccio, 	@Usuario,	@FechaSis,	@SucOrigen,		@SucDestino,	
	@Modulo
if @Status <> 0 begin
	rollback
	return 1
end

/* Calculo de las tasas en cedes */
select @Fot_Produc = Fot_Tasa
	from CEFORTAS noholdlock
	where   Fot_Tasa = @Tas_Numero
	
if isnull(@Fot_Produc, @Str_Vacio) <> @Str_Vacio begin
	exec @Status = CETASASACT
		@Tas_Valor,		@Fot_Produc,	@Tip_Produc,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end
end

/* Calculo de las tasas en pagare y actulizar en intasas */
if @Tas_Numero = @Tas_CETE begin
	exec @Status = INTASASACT
		@Tas_Valor,		@Act_Pagare,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end
	
end	 

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj 	= 'Registro Modificado'
