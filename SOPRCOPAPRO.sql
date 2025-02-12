create procedure SOPRCOPAPRO (
    @PCo_Texto varchar(100),
    @PCo_Result char(1) output,

   	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************
** DESCRIPCION: Saca la primer consonante interna del texto, y la devuelve. ****
** 				Si no hay una consonante interna, devuelve X.				****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

/* Declaración de variables */
    declare @Val_Subcad varchar(100),        -- Subcadena sin nombres comunes ni prefijos
            @Val_Palabr varchar(50)

/* Declaración de constantes */
    declare @Val_Conson varchar(50),        -- Conjunto de consonantes
            @Val_Iterad int,                -- Contador para recorrer los caracteres
    		@Val_Caract char(1),            -- Carácter actual
    		@Ent_Cero int,
    		@Ent_Uno int,
    		@Ent_Dos int,
    		@Str_Espaci varchar(2),
    		@Str_LetraX varchar(1)
    
    create table #Tab_PalCom (Cam_NomCom varchar(50))       -- Tabla de nombres comunes y prefijos

/* Asignación de valores a constantes */
    select	@Ent_Cero       = 0,
    		@Ent_Uno 	    = 1,
    		@Ent_Dos 	    = 2,
    		@Str_Espaci     = ' ',
    		@Str_LetraX     ='X',
            @Val_Conson     = 'BCDFGHJKLMNÑPQRSTVWXYZ'      -- Conjunto de consonantes

    -- inicializamos la lista de nombres comunes y prefijos con inserciones individuales  
    insert into #Tab_PalCom(Cam_NomCom) values ('MARIA')
    insert into #Tab_PalCom(Cam_NomCom) values ('MA')
    insert into #Tab_PalCom(Cam_NomCom) values ('MA.')
    insert into #Tab_PalCom(Cam_NomCom) values ('JOSE')
    insert into #Tab_PalCom(Cam_NomCom) values ('J')
    insert into #Tab_PalCom(Cam_NomCom) values ('J.')

    -- Eliminar espacios iniciales y finales
    set @PCo_Texto = ltrim(rtrim(@PCo_Texto))

    -- Filtrar nombres comunes y prefijos
    while charindex(' ', @PCo_Texto) > @Ent_Cero begin
        -- Extraer la primera palabra
        set @Val_Palabr = left(@PCo_Texto, charindex(@Str_Espaci, @PCo_Texto) - @Ent_Uno) 

        -- Si la palabra está en la lista de nombres comunes, eliminarla
        if exists (select 1 from #Tab_PalCom where Cam_NomCom = @Val_Palabr)
            set @PCo_Texto = ltrim(substring(@PCo_Texto, charindex(@Str_Espaci, @PCo_Texto) + @Ent_Uno, len(@PCo_Texto)))
        else
            break
    end

    -- La cadena restante después de eliminar nombres comunes
    select	@Val_Subcad = substring(@PCo_Texto, @Ent_Dos, len(@PCo_Texto) - @Ent_Uno),  -- Extraemos la cadena desde el segundo carácter
    		@Val_Iterad = @Ent_Uno,
    		@PCo_Result = @Str_LetraX       -- Valor predeterminado si no hay consonantes

    -- Iteramos sobre la subcadena
    while @Val_Iterad <= len(@Val_Subcad) begin
        set @Val_Caract = substring(@Val_Subcad, @Val_Iterad, @Ent_Uno)        -- Extraemos el carácter actual

        -- Si el carácter es consonante, lo asignamos y salimos del bucle
        if charindex(@Val_Caract, @Val_Conson) > @Ent_Cero begin
            set @PCo_Result = @Val_Caract
            break
        end

        set @Val_Iterad = @Val_Iterad + @Ent_Uno
    end
end