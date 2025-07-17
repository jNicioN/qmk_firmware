create procedure SODENMORCON (
    @Dem_Moneda     varchar(3),
    @Dem_Denomi     money,
    @Tip_Consul     varchar(2),

    @NumTransac     char(10),
    @Transaccio     char(3),
    @Usuario        char(6),
    @FechaSis       smalldatetime,
    @SucOrigen      char(3),
    @SucDestino     char(3),
    @Modulo         char(2)
)
as

/*************************************************************************
*   DESCRIPCION: Consulta registros de la tabla SODENMOR según filtros   *
*************************************************************************/

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

/* Validación de tipoConsulta */
if @Tip_Consul not in (@TIPO_L1, @TIPO_C1, @TIPO_C2)
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST as mensaje
    return
end

/* Validación de parámetros requeridos */
if @Tip_Consul = @TIPO_C1 and isnull(@Dem_Moneda, '') = ''
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST_C1 as mensaje
    return
end

if @Tip_Consul = @TIPO_C2 and (isnull(@Dem_Moneda, '') = '' or @Dem_Denomi is null)
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_BAD_REQUEST_C2 as mensaje
    return
end

/* Validación de caracteres inválidos solo para cadenas */
if (@Dem_Moneda <> '' and @Dem_Moneda like '%[^a-zA-Z0-9]%')
   or (@Tip_Consul like '%[^a-zA-Z0-9]%')
begin
    select @STATUS_BAD_REQUEST as status_code, @MSG_INVALID_CHARS as mensaje
    return
end

/* Ejecuciones */
if @Tip_Consul = @TIPO_L1
begin
    if exists (select 1 from SODENMOR)
    begin
        select * from SODENMOR
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end
else if @Tip_Consul = @TIPO_C1
begin
    if exists (select 1 from SODENMOR where Dem_Moneda = @Dem_Moneda)
    begin
        select * from SODENMOR where Dem_Moneda = @Dem_Moneda
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end
else if @Tip_Consul = @TIPO_C2
begin
    if exists (select 1 from SODENMOR where Dem_Moneda = @Dem_Moneda and Dem_Denomi = @Dem_Denomi)
    begin
        select * from SODENMOR where Dem_Moneda = @Dem_Moneda and Dem_Denomi = @Dem_Denomi
    end
    else
    begin
        select @STATUS_NOT_FOUND as status_code, @MSG_NOT_FOUND as mensaje
    end
end

