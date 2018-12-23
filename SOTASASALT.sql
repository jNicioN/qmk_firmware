create procedure SOTASASALT (
	@Tas_Numero	char(2),
	@Tas_Descri	varchar(80), 
	@Tas_Abrevi varchar(10),
	@Tas_Valor 	double precision, 
	@Tas_Fecha  smalldatetime,
	@Tas_Moneda	char(2),
	@Tas_SelPar	char(1),
	
	@NumTransac char(10), 
	@Transaccio	char(3),
	@Usuario 	char(6),        
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),    
	@SucDestino char(3),
	@Modulo 	char(2))

as
/***************************************************************************
** DESCRIPCION: ** Alta de una Tasa de interes **						****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Modificó:	Jonathan Balderas Gauna									****
** Fecha:		23/Marzo/2016											****
** Help:		849927													****
** Descripción:	Se agrega parámetro @Mon_Cero al exec de SOHISTASALT	****
****************************************************************************
** Modificó:	Sergio Trevi±o Jasso									****
** Fecha:		23/Febrero/2011											****
** Help:		444178													****
** Descripción:	Se agrego campo Tas_StaAct al insert					****
****************************************************************************
**				STORE CONVERTIDO										****
**	Fecha:		30/Ago/2006												****
**	Convirtió:	Perla J. Abundis Orozco									****
****************************************************************************
** Modificó:	Jorge Ortega Rodríguez									****
** Fecha:		02/Agosto/2006											****
** Help:		00124820.002											****
** Descripción:	Se agrego @Tas_NoSePa y @Tas_SiSePa, la					****	
**				validación de @Tas_SelPar y al insert					****
****************************************************************************
** 			  STORE CONVERTIDO											****
** Convirtió: Perla Judith Abundis Orozco								****
** Fecha:     08/Febrero/2005 12:14 pm									****	
****************************************************************************
** Modificó:	Raúl González											****	
** Fecha:		26/Septiembre/2003										****
** Descripción:	Se agreg¾ la constante 'N' a la Tasa Extempo.			****
****************************************************************************
** Modificó:	FCHIA          											****
** Fecha:		23/Abr/01												****
** Descripción:	Se agrego la Moneda (Tas_Moneda)						****
****************************************************************************
@TAS_NUMERO.- No debe de existir en SOTASAS
@TAS_DESCRI.- No vacio
@TAS_ABREVI.- No Vacio
@TAS_VALOR.- Mayor a Cero
@TAS_FECHA.- Fecha menor o igual a fecha actual
*/
declare	@Status		int					/* Declaración de Variables */				

declare	@Mon_Cero	money,				/* Declaración de Constantes */
		@Ent_Cero	int,
		@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Tas_NoExt	char(1),
		@Tas_NoSePa	char(1),
		@Tas_SiSePa	char(1),
		@Sta_Activa	char(1)

/* Asignacion de Constantes */
select	@Mon_Cero	= $0.00,			/* Moneda en Ceros */
		@Ent_Cero	= 0,				/* Entero en Cero */
		@Str_Vacio	= '',				/* String Vacio */
		@Fec_Vacia	= '1900-01-01',		/* Fecha Vacia */
		@Tas_NoExt	= 'N',				/* Tasa No Extemporanea */
		@Tas_NoSePa	= 'N',				/* Tasa No De Seleccion Parcial */
		@Tas_SiSePa	= 'S',				/* Tasa Sí De Seleccion Parcial */
		@Sta_Activa	= 'S'				/* Status Activa */


select	@FechaSis	= getdate()

if convert(int, @Tas_Numero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Numero Incorrecto',
			Err_Variab	= 'Tas_Numero'
	rollback
	return 1
end	
	
if exists ( select	Tas_Numero
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero ) begin				
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Numero ya Existe',
			Err_Variab 	= 'Tas_Numero'
	rollback
	return 1
end 

if @Tas_Descri = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Descripcion Incorrecta',
			Err_Variab 	= 'Tas_Descri'
	rollback
	return 1
end

if @Tas_Abrevi	= @Str_Vacio begin
	select 	Err_Codigo 	= '000004',
			Err_Mensaj	= 'Abreviacion Incorrecta',
			Err_Variab 	= 'Tas_Abrevi'
	rollback
	return 1
end 

if @Tas_Valor <= @Mon_Cero begin
	select	Err_Codigo	= '000005',
			Err_Mensaj 	= 'Valor de la Tasa Incorrecto',
			Err_Variab	= 'Tas_Valor'
	rollback
	return 1
end 

if @Tas_Fecha <= @Fec_Vacia begin
	select	Err_Codigo	= '000006',
			Err_Mensaj 	= 'Fecha Incorrecta',
			Err_Variab 	= 'Tas_Fecha'
	rollback
	return 1
end 
	
if @Tas_SelPar not in(@Tas_NoSePa, @Tas_SiSePa) begin
	select	Err_Codigo	= '000007',
			Err_Mensaj 	= 'Tipo De Seleccion Incorrecta',
			Err_Variab 	= 'Tas_SelPar'
	rollback
	return 1
end 

if exists ( select	Tas_Numero
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero ) 
				
	update SOTASAS set
		Tas_Descri	= @Tas_Descri,
		Tas_Abrevi	= @Tas_Abrevi,
		Tas_Valor	= @Tas_Valor,
		Tas_Fecha	= @Tas_Fecha,
		NumTransac  = @NumTransac,
		Transaccio  = @Transaccio,
		Usuario     = @Usuario,
		FechaSis 	= @FechaSis,
		SucOrigen 	= @SucOrigen,
		SucDestino  = @SucDestino
		where	Tas_Numero	= @Tas_Numero	
else
	insert into SOTASAS values (
		@Tas_Numero,	@Tas_Descri,	@Tas_Abrevi,	@Tas_Valor,		@Tas_Fecha,
		@Tas_Moneda,	@Tas_NoExt,		@Tas_SelPar,	@Sta_Activa,	@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis, 		@SucOrigen,		@SucDestino )

exec @Status = SOHISTASALT
	@Tas_Numero, 	@Tas_Fecha, @Tas_Valor, @Mon_Cero,	 	@NumTransac,
	@Transaccio, 	@Usuario, 	@FechaSis, 	@SucOrigen, 	@SucDestino,
	@Modulo					
	
if @Status <> 0 begin
	rollback
	return 1
end		

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado'
