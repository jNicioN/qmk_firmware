create procedure SOPAISMOD(
	@Pai_Numero	char(3),
	@Pai_Nombre	varchar(30),
	@Pai_Abrevi	varchar(10),
	@Pai_ISR	smallmoney,
	@Pai_Gentil	varchar(30),	
	@Pai_IdeBMX	char(3),
	@Pai_IdCNBV	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Modificación de Paises */
/*****************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Modificando:	Gerardo Valladares Muñiz	   				            ****
** Fecha:		10/Jul/2013												****
** Help:		571100		   					                  		****
** Descripción:	Agregar parametros a exec CLCLIENTACT					****
****************************************************************************
** Modifico:	Ignacio Ordaz Valtierra									****
** Fecha:		05/Sep/2011												****
** Req:			386334													****
** Modificar:	Se modifica exec de clclientact							****
****************************************************************************
** Modifico:	Tania De la Garza										****
** Fecha:		28/Junio/2011											****
** Req:			00389100												****
** Modificar:	Se agrega @Pai_IdCNBV									****
****************************************************************************
** Modificó:	Andrés Grande Díaz										****
** Fecha:		15/Diciembre/2009										****
** HelpDesk:	234126													****
** Descripción:	Parámetros a CLCLIENTACT: Calle, Num, 					****
**				Colonia, Entidad, Localidad, C.P. y Telefono			****
****************************************************************************
** Creó:		Diego Olvera Garza  									****
** Fecha:		11/Ene/07												****
** Help:		00007741												****
******************************************************************************/

declare @Valor_ISR	int,				/* Declaración de Variables */
		@Status		int


declare	@Str_Vacio	char(1),			/* Declaración de Constantes */
		@Tip_ActAct	char(1),
		@Mon_CorCer	smallmoney

/* Asignación de Constantes */
select	@Str_Vacio	= '',				/* String Vacío */
		@Tip_ActAct	= 'M',				/* Tipo de Actualizacion: Modificación del Cliente	*/
		@Mon_CorCer	= 0.00				-- Moneda corta cero

select	@FechaSis = getdate()


/* Asignación del Valor del ISR que se tenia */
select	@Valor_ISR	= @Pai_ISR


/* Validación de la Existencia del País */
if not exists (select	Pai_Numero
				from SOPAIS noholdlock
				where	Pai_Numero	=	@Pai_Numero)		begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Error.- Este País <NO> existe en el Catálogo de Países',
			Err_Variab	= ''
	rollback
	return 1
end

/* Validación del Nombre */
if isnull(@Pai_Nombre, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Error.- Descripcion del Nombre incorrecta',
			Err_Variab	= 'Pai_Nombre'
	rollback
	return 1
end

/* Validación de la Abreviación */
if isnull(@Pai_Abrevi, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Error.- Abreviación incorrecta',
			Err_Variab	= 'Pai_Abrevi'
	rollback
	return 1
end


/* Validación  del ISR */
if @Pai_ISR < 0 or @Pai_ISR > 100 begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Error.- ISR incorrecto', 
			Err_Variab	= 'Pai_ISR'
	rollback
	return 1
end 


/* Validación del Gentilicio */
if isnull(@Pai_Gentil, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'Error.- Gentilicio incorrecto',
			Err_Variab	= 'Pai_Gentil'
	rollback
	return 1
end


/* Validación del País Identificador de BMX */
if isnull(@Pai_IdeBMX, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Error.- Pais Identificador de BMX incorrecto',
			Err_Variab	= 'Pai_IdeBMX'
	rollback
	return 1
end

/* Validación del País Identificador de CNBV */
if not exists (select Pac_Clave from SOPAICNB
						where Pac_Clave = @Pai_IdCNBV) or 
			isnull(@Pai_IdCNBV, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000007',
			Err_Mensaj	= 'Error.- Pais Identificador de CNBV incorrecto',
			Err_Variab	= 'Pai_IdCNBV'
	rollback
	return 1
end


/* Validación  para el cambio del ISR */
if @Pai_ISR <> @Valor_ISR
	if exists (select Cli_Pais
				from CLCLIENT noholdlock
				where Cli_Pais	= @Pai_Numero) begin

		exec @Status = CLCLIENTACT
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Pai_Numero,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Mon_CorCer,
			@Str_Vacio,		@Tip_ActAct,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
		
		if @Status <> 0 begin
			select	Err_Codigo	= '000007',
					Err_Mensaj	= 'Actualización de información del Cliente no se completó.'
			rollback
			return 1
		end
end

/* Actualiza los Datos en la Tabla*/
update SOPAIS set 
	Pai_Nombre	= @Pai_Nombre,
	Pai_Abrevi	= @Pai_Abrevi,
	Pai_ISR		= @Pai_ISR,
	Pai_Gentil	= @Pai_Gentil,	
	Pai_IdeBMX	= @Pai_IdeBMX,
	Pai_IdCNBV	= @Pai_IdCNBV
where	Pai_Numero	= @Pai_Numero

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Modificado'
