
create procedure SODENMORCON (
    @moneda        varchar(10),
    @denominacion  varchar(20),
    @tipoConsulta  varchar(3),

    @NumTransac    char(10),
    @Transaccio    char(3),
    @Usuario       char(6),
    @FechaSis      smalldatetime,
    @SucOrigen     char(3),
    @SucDestino    char(3),
    @Modulo        char(2)
)
as

/*************************************************************************
*   DESCRIPCION: Consulta registros de la tabla SODENMOR según filtros   *
**************************************************************************
* REFERENCIAS:
**************************************************************************
** Creó:       Diego Valdés                                            ***
** Fecha:      25/06/2025                                              ***
** Descripción: Procedimiento para consulta de monedas y denominaciones**
************************************************************************/


declare @TIPO_L1              varchar(3),
        @TIPO_C1              varchar(3),
        @TIPO_C2              varchar(3),
        @STATUS_OK            int,
        @STATUS_BAD_REQUEST   int,
        @STATUS_NOT_FOUND     int,
        @STATUS_ERROR         int,
        @MSG_NOT_FOUND        varchar(50),
        @MSG_BAD_REQUEST      varchar(100),
        @MSG_BAD_REQUEST_C1   varchar(100),
        @MSG_BAD_REQUEST_C2   varchar(100),
        @MSG_INVALID_CHARS    varchar(100),
        @MSG_INTERNAL_ERROR   varchar(50)

select
    @TIPO_L1            = 'L1',
    @TIPO_C1            = 'C1',
    @TIPO_C2            = 'C2',
    @STATUS_OK          = 200,
    @STATUS_BAD_REQUEST = 400,
    @STATUS_NOT_FOUND   = 404,
    @STATUS_ERROR       = 500,
    @MSG_NOT_FOUND      = 'CODE_NOT_FOUND',
    @MSG_BAD_REQUEST    = 'CODE_BAD_REQUEST',
    @MSG_BAD_REQUEST_C1 = 'CODE_BAD_REQUEST - moneda requerida para tipo C1',
    @MSG_BAD_REQUEST_C2 = 'CODE_BAD_REQUEST - moneda y denominacion requeridas para tipo C2',
    @MSG_INVALID_CHARS  = 'CODE_BAD_REQUEST - parámetros contienen caracteres inválidos',
    @MSG_INTERNAL_ERROR = 'CODE_INTERNAL_ERROR'

/* Validación de tipoConsulta: solo se permiten L1, C1 y C2 */
if @tipoConsulta not in (@TIPO_L1, @TIPO_C1, @TIPO_C2)
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST as mensaje
    return
end

/* Validación de parámetros obligatorios según tipoConsulta */
if @tipoConsulta = @TIPO_C1 and isnull(@moneda, '') = ''
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST_C1 as mensaje
    return
end

if @tipoConsulta = @TIPO_C2 and (isnull(@moneda, '') = '' or isnull(@denominacion, '') = '')
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST_C2 as mensaje
    return
end

/* Validación de caracteres no permitidos en los parámetros */
if (@moneda <> '' and @moneda like '%[^a-zA-Z0-9]%')
   or (@denominacion <> '' and @denominacion like '%[^a-zA-Z0-9]%')
   or (@tipoConsulta like '%[^a-zA-Z0-9]%')
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_INVALID_CHARS as mensaje
    return
end

/* Validación adicional: denominación debe ser numérica si es tipo C2 */
if @tipoConsulta = @TIPO_C2 and isnumeric(@denominacion) = 0
begin
    select @STATUS_BAD_REQUEST as status_code,
           'CODE_BAD_REQUEST - denominacion debe ser numérica' as mensaje
    return
end

/* Ejecución según el tipo de consulta */
if @tipoConsulta = @TIPO_L1
begin
    if exists (select 1 from SODENMOR)
    begin
        select
            Dem_Moneda,
            Dem_Denomi,
            Dem_Descri,
            NumTransac,
            Transaccio,
            Usuario,
            FechaSis,
            SucOrigen,
            SucDestino
        from SODENMOR
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end
else if @tipoConsulta = @TIPO_C1
begin
    if exists (select 1 from SODENMOR where Dem_Moneda = @moneda)
    begin
        select
            Dem_Moneda,
            Dem_Denomi,
            Dem_Descri,
            NumTransac,
            Transaccio,
            Usuario,
            FechaSis,
            SucOrigen,
            SucDestino
        from SODENMOR
        where Dem_Moneda = @moneda
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end
else if @tipoConsulta = @TIPO_C2
begin
    if exists (select 1 from SODENMOR where Dem_Moneda = @moneda and Dem_Denomi = convert(money, @denominacion))
    begin
        select
            Dem_Moneda,
            Dem_Denomi,
            Dem_Descri,
            NumTransac,
            Transaccio,
            Usuario,
            FechaSis,
            SucOrigen,
            SucDestino
        from SODENMOR
        where Dem_Moneda = @moneda and Dem_Denomi = convert(money, @denominacion)
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end

/* Confirmación de ejecución exitosa si no hubo errores y nivel base */
if @@nestlevel = 1
begin
    select
        Err_Numero = '00000',
        Err_Mensaj = '',
        Consulta_Ejecutada = @tipoConsulta
end
