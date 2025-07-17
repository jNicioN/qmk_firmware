create procedure SODENMORCON (
    @Dem_Moneda	char(2), 
    @Dem_Denomi money, 
    @Tip_Consul	char(2),

    @NumTransac	char(10),
    @Transaccio	char(3),
    @Usuario	char(6),
    @FechaSis	smalldatetime,
    @SucOrigen	char(3),
    @SucDestino	char(3),
    @Modulo		char(2)
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

-- Declaración de constantes
declare @Str_Lista   char(1),
        @Str_Consul  char(1),
        @Str_Uno     char(1),
        @Str_Dos     char(1),
        @Str_Vacio   char(1),
        @Tip_ConTip  char(1),
        @Tip_ConCon  char(1),
        @Str_Permit  char(12),
        @Str_Porcen  char(1)

select  @Str_Lista   = 'L',
        @Str_Consul  = 'C',
        @Str_Uno     = '1',
        @Str_Dos     = '2',
        @Str_Vacio   = '',
        @Tip_ConTip  = substring(@Tip_Consul, 1, 1),
        @Tip_ConCon  = substring(@Tip_Consul, 2, 1),
        @Str_Permit  = '[^a-zA-Z0-9]', 
        @Str_Porcen  = '%'

select  @Dem_Moneda = isnull(@Dem_Moneda, @Str_Vacio),
        @Dem_Denomi = isnull(@Dem_Denomi, 0)

if @Tip_ConTip = @Str_Consul begin  -- CONSULTAS

    if @Dem_Moneda = @Str_Vacio begin 
        select	Err_Codigo = '00001',
                Err_Mensaj = 'La moneda no puede ser vacía',
                Err_Variab = 'Dem_Moneda'
        return 1
    end 

    -- Validación de caracteres no permitidos (solo en campos tipo char)
    if (@Dem_Moneda like @Str_Porcen + @Str_Permit + @Str_Porcen)
        or (@Tip_Consul like @Str_Porcen + @Str_Permit + @Str_Porcen)
    begin
        select	Err_Codigo = '00002',
                Err_Mensaj = 'No se permiten caracteres especiales',
                Err_Variab = 'Dem_Moneda, Tip_Consul'
        return 1
    end

    if @Tip_ConCon = @Str_Dos begin  -- Consulta por Llave Principal

        if @Dem_Denomi = 0 begin 
            select	Err_Codigo = '00003',
                    Err_Mensaj = 'La denominación no puede ser cero',
                    Err_Variab = 'Dem_Denomi'
            return 1
        end 

        if @Dem_Denomi < 0 begin 
            select	Err_Codigo = '00004',
                    Err_Mensaj = 'La denominación no puede ser negativa',
                    Err_Variab = 'Dem_Denomi'
            return 1
        end

        select	Dem_Moneda, Dem_Denomi, Dem_Descri
        from SODENMOR noholdlock
        where Dem_Moneda = @Dem_Moneda
          and Dem_Denomi = @Dem_Denomi

    end 
    else if @Tip_ConCon = @Str_Uno begin  -- Consulta por Moneda
        select	Dem_Moneda, Dem_Denomi, Dem_Descri
        from SODENMOR noholdlock
        where Dem_Moneda = @Dem_Moneda
    end 

end  -- cierre de if @Tip_ConTip = @Str_Consul

-- Listado completo (tipo L1)
if @Tip_ConTip = @Str_Lista and @Tip_ConCon = @Str_Uno begin
    select	Dem_Moneda, Dem_Denomi, Dem_Descri
    from SODENMOR noholdlock
end 
