create procedure SOAJPACOPRO(
    @APa_PalCom varchar(100),
    @APa_PalRes varchar(100) output,
    
    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************
** DESCRIPCION: Cuando el nombre o los apellidos son compuestos y tienen	****
** 				proposiciones, contracciones o conjunciones, se deben 		****
**				eliminar esas palabras a la hora de calcular la CURP.		****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

/* Declaración de variables */
    declare @Val_PalCom varchar(10),
            @Val_Iterad int

/* Declaración de constantes */
	declare @Str_Espaci varchar(2),
			@Str_EspDou varchar(3),
			@Ent_Cero int,
            @Ent_Uno int,
            @Ent_DieNue int
    
    create table #Tab_PalCom (
        Cam_Identi int, 
        Cam_Palabr varchar(10)
    )

/* Asignación de valores a constantes */				
	select	@Str_Espaci 	= ' ',          -- Espacio Sencillo
			@Str_EspDou 	= '  ',         -- Espacio Doble
    		@Ent_Cero 		= 0,            -- Entero Cero
            @Ent_Uno        = 1,            -- Entero Uno
            @Ent_DieNue     = 19            -- Entero Diecinueve
    
	select @APa_PalRes 	= @APa_PalCom

    -- insertar las palabras compuestas en la tabla temporal
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (1, 'DA')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (2, 'DAS')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (3, 'DE')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (4, 'DEL')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (5, 'DER')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (6, 'DI')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (7, 'DIE')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (8, 'DD')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (9, 'EL')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (10, 'LA')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (11, 'LOS')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (12, 'LAS')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (13, 'LE')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (14, 'LES')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (15, 'MAC')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (16, 'MC')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (17, 'VAN')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (18, 'VON')
    insert into #Tab_PalCom(Cam_Identi, Cam_Palabr) values (19, 'Y')

    set  @Val_Iterad = @Ent_Uno

    -- cursor para iterar sobre las palabras compuestas
    while @Val_Iterad <=  @Ent_DieNue begin
        select @Val_PalCom = Cam_Palabr 
        from  #Tab_PalCom
        where Cam_Identi = @Val_Iterad

        -- Reemplaza la palabra compuesta en el texto y elimina espacios adicionales
        set @APa_PalRes = ltrim(rtrim(str_replace(@Str_Espaci + @APa_PalRes + @Str_Espaci, @Str_Espaci +@Val_PalCom + @Str_Espaci, @Str_Espaci)))
        set @Val_Iterad = @Val_Iterad + @Ent_Uno
    end
    
    drop table #Tab_PalCom

    -- Eliminar espacios dobles resultantes
    while charindex(@Str_EspDou, @APa_PalRes) > @Ent_Cero begin
        set @APa_PalRes = str_replace(@APa_PalRes, @Str_EspDou, @Str_Espaci)
    end

    -- Eliminar espacios iniciales y finales
    set @APa_PalRes = ltrim(rtrim(@APa_PalRes))

end