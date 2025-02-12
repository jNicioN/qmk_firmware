create or replace procedure SOGECURPPRO (
	@Gen_Nombre	varchar(100),
	@Gen_ApePat varchar(100),
	@Gen_ApeMat varchar(100),
	@Gen_Sexo 	varchar(1),
	@Gen_EntNac varchar(2),
	@Gen_FecNac date,
	@Gen_Homoni varchar(1),
	@Gen_CURP 	varchar(18) output,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as
/*******************************************************************************
** DESCRIPCION: Función principal que genera la CURP.						****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

/* Declaración de variables */
	declare	@Val_IniNom	varchar(1), 	-- Inicial Nombre
			@Val_VocApe varchar(1), 	-- Vocal Apellido
			@Val_PrLePa varchar(1), 	-- Primera Letra Paterno
			@Val_PrLeMa varchar(1), 	-- Primera Letra Materno
			@Val_1_4 	varchar(4),		-- Posicion 1 - 4
			@Val_14_16 	varchar(3), 	-- Posicion 14 - 16
			@Val_FecNac	varchar(6), 	-- Fecha de nacimiento
			@Val_CURPBa varchar(17),	-- CURP Base
			@Val_DigVer	int, 			-- Digito Verificador
			@Val_NomNor	varchar(255),	-- Nombre Normalizado
			@Val_ApPaNo	varchar(255),	-- Apellido Paterno Normalizado
			@Val_ApMaNo varchar(255),	-- Apellido Materno Normalizado
			@Val_EsVali bit,			-- Es valido
			@Val_Estatu int,			-- Estatus
			@Val_Caract char(1),		-- Caracter
			@Val_Result varchar(40),	-- Resultado
			@Val_NomSig varchar(50),	-- Nombre Significativo
			@Val_Iterad int,			-- Iterador
			@Val_ConPat char(1),		-- Consonante Apellido Paterno
			@Val_ConMat char(1),		-- Consonante Apellido Materno
			@Val_ConNom char(1)			-- Consonante Nombres

	create table #Tab_Nombre (Cam_Nombre varchar(50))

/* Declaración de constantes */
	declare	@Val_Hombre varchar(1),
			@Val_Mujer varchar(1),
			@Fec_Vacia date,
			@Str_Vacio char(1),
			@Str_Cero varchar(1),
			@Str_LetraX varchar(1),
			@Str_LetraA varchar(1),
			@Str_LetraE varchar(1),
			@Str_LetraI varchar(1),
			@Str_LetraO varchar(1),
			@Str_LetraU varchar(1),
			@Str_RegLet varchar(10),
			@Str_Espaci varchar(2),
			@Ent_Cero int,
			@Ent_Uno int,
			@Ent_Dos int,
			@Ent_DosMil int

	create table #Tab_Comune (Cam_NomCom varchar(50))
	create table #Tab_PalInc (Cam_Palabr varchar(4))
			
/* Asignación de valores a constantes */			
	select	@Val_Hombre		= 'H',			-- Valor de Hombre
			@Val_Mujer 		= 'M',			-- Valor de Mujer
			@Fec_Vacia 		= '1900-01-01',	-- Valor de Fecha Vacia
			@Str_Vacio		= '',			-- Texto Vacio
			@Str_Cero 		= '0',			-- Valor Cero en texto
			@Str_LetraX 	= 'X',			-- Valor Letra X
			@Str_LetraA 	= 'A',			-- Valor Letra A
			@Str_LetraE 	= 'E',			-- Valor Letra E
			@Str_LetraI 	= 'I',			-- Valor Letra I
			@Str_LetraO 	= 'O',			-- Valor Letra O
			@Str_LetraU 	= 'U',			-- Valor Letra U
			@Str_RegLet 	= '[A-Za-z]',	-- Regex de letras
			@Str_Espaci		= ' ',			-- Espacio
			@Ent_Cero 		= 0,			-- Valor Entero Cero
			@Ent_Uno 		= 1,			-- Valor Entero Uno
			@Ent_Dos 		= 2,			-- Valor Entero Dos
			@Ent_DosMil 	= 2000			-- Valor Entero Dosmil

	-- insertar nombres comunes y prefijos que deben ignorarse
    insert into #Tab_Comune(Cam_NomCom) values ('MARIA')
    insert into #Tab_Comune(Cam_NomCom) values ('MA')
    insert into #Tab_Comune(Cam_NomCom) values ('MA.')
    insert into #Tab_Comune(Cam_NomCom) values ('JOSE')
    insert into #Tab_Comune(Cam_NomCom) values ('J')
    insert into #Tab_Comune(Cam_NomCom) values ('J.')

	-- insertar las palabras inconvenientes
	insert into #Tab_PalInc (Cam_Palabr) values ('BACA')
	insert into #Tab_PalInc (Cam_Palabr) values ('LOCO')
	insert into #Tab_PalInc (Cam_Palabr) values ('BUEI')
	insert into #Tab_PalInc (Cam_Palabr) values ('BUEY')
	insert into #Tab_PalInc (Cam_Palabr) values ('MAME')
	insert into #Tab_PalInc (Cam_Palabr) values ('CACA')
	insert into #Tab_PalInc (Cam_Palabr) values ('MAMO')
	insert into #Tab_PalInc (Cam_Palabr) values ('CACO')
	insert into #Tab_PalInc (Cam_Palabr) values ('MEAR')
	insert into #Tab_PalInc (Cam_Palabr) values ('CAGA')
	insert into #Tab_PalInc (Cam_Palabr) values ('MEAS')
	insert into #Tab_PalInc (Cam_Palabr) values ('CAGO')
	insert into #Tab_PalInc (Cam_Palabr) values ('MEON')
	insert into #Tab_PalInc (Cam_Palabr) values ('CAKA')
	insert into #Tab_PalInc (Cam_Palabr) values ('MIAR')
	insert into #Tab_PalInc (Cam_Palabr) values ('CAKO')
	insert into #Tab_PalInc (Cam_Palabr) values ('MION')
	insert into #Tab_PalInc (Cam_Palabr) values ('COGE')
	insert into #Tab_PalInc (Cam_Palabr) values ('MOCO')
	insert into #Tab_PalInc (Cam_Palabr) values ('COGI')
	insert into #Tab_PalInc (Cam_Palabr) values ('MOKO')
	insert into #Tab_PalInc (Cam_Palabr) values ('COJA')
	insert into #Tab_PalInc (Cam_Palabr) values ('MULA')
	insert into #Tab_PalInc (Cam_Palabr) values ('COJE')
	insert into #Tab_PalInc (Cam_Palabr) values ('MULO')
	insert into #Tab_PalInc (Cam_Palabr) values ('COJI')
	insert into #Tab_PalInc (Cam_Palabr) values ('NACA')
	insert into #Tab_PalInc (Cam_Palabr) values ('COJO')
	insert into #Tab_PalInc (Cam_Palabr) values ('NACO')
	insert into #Tab_PalInc (Cam_Palabr) values ('COLA')
	insert into #Tab_PalInc (Cam_Palabr) values ('PEDA')
	insert into #Tab_PalInc (Cam_Palabr) values ('CULO')
	insert into #Tab_PalInc (Cam_Palabr) values ('PEDO')
	insert into #Tab_PalInc (Cam_Palabr) values ('FALO')
	insert into #Tab_PalInc (Cam_Palabr) values ('PENE')
	insert into #Tab_PalInc (Cam_Palabr) values ('FETO')
	insert into #Tab_PalInc (Cam_Palabr) values ('PIPI')
	insert into #Tab_PalInc (Cam_Palabr) values ('GETA')
	insert into #Tab_PalInc (Cam_Palabr) values ('PITO')
	insert into #Tab_PalInc (Cam_Palabr) values ('GUEI')
	insert into #Tab_PalInc (Cam_Palabr) values ('POPO')
	insert into #Tab_PalInc (Cam_Palabr) values ('GUEY')
	insert into #Tab_PalInc (Cam_Palabr) values ('PUTA')
	insert into #Tab_PalInc (Cam_Palabr) values ('JETA')
	insert into #Tab_PalInc (Cam_Palabr) values ('PUTO')
	insert into #Tab_PalInc (Cam_Palabr) values ('JOTO')
	insert into #Tab_PalInc (Cam_Palabr) values ('QULO')
	insert into #Tab_PalInc (Cam_Palabr) values ('KACA')
	insert into #Tab_PalInc (Cam_Palabr) values ('RATA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KACO')
	insert into #Tab_PalInc (Cam_Palabr) values ('ROBA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KAGA')
	insert into #Tab_PalInc (Cam_Palabr) values ('ROBE')
	insert into #Tab_PalInc (Cam_Palabr) values ('KAGO')
	insert into #Tab_PalInc (Cam_Palabr) values ('ROBO')
	insert into #Tab_PalInc (Cam_Palabr) values ('KAKA')
	insert into #Tab_PalInc (Cam_Palabr) values ('RUIN')
	insert into #Tab_PalInc (Cam_Palabr) values ('KAKO')
	insert into #Tab_PalInc (Cam_Palabr) values ('SENO')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOGE')
	insert into #Tab_PalInc (Cam_Palabr) values ('TETA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOGI')
	insert into #Tab_PalInc (Cam_Palabr) values ('VACA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOJA')
	insert into #Tab_PalInc (Cam_Palabr) values ('VAGA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOJE')
	insert into #Tab_PalInc (Cam_Palabr) values ('VAGO')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOJI')
	insert into #Tab_PalInc (Cam_Palabr) values ('VAKA')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOJO')
	insert into #Tab_PalInc (Cam_Palabr) values ('VUEI')
	insert into #Tab_PalInc (Cam_Palabr) values ('KOLA')
	insert into #Tab_PalInc (Cam_Palabr) values ('VUEY')
	insert into #Tab_PalInc (Cam_Palabr) values ('KULO')
	insert into #Tab_PalInc (Cam_Palabr) values ('WUEI')
	insert into #Tab_PalInc (Cam_Palabr) values ('LILO')
	insert into #Tab_PalInc (Cam_Palabr) values ('WUEY')
	insert into #Tab_PalInc (Cam_Palabr) values ('LOCA')
	insert into #Tab_PalInc (Cam_Palabr) values ('BAKA')
	insert into #Tab_PalInc (Cam_Palabr) values ('LOKA')
	insert into #Tab_PalInc (Cam_Palabr) values ('LOKO')

	-- Validamos campo de sexo
	if @Gen_Sexo not in(@Val_Hombre,@Val_Mujer) begin
		set @Gen_CURP = null
		return @Ent_Uno
	end
	
	if @Gen_FecNac <= @Fec_Vacia begin
		set @Gen_CURP = null
		return @Ent_Uno
	end
			
	-- Validar estado
	exec SOESTVALPRO 	@Gen_EntNac,	@Val_EsVali output,	@NumTransac,	@Transaccio,	@Usuario, 
						@FechaSis,	 	@SucOrigen, 		@SucDestino, 	@Modulo
						
	if @Val_EsVali = @Ent_Cero begin
		set @Gen_CURP = null
		return @Ent_Uno
	end

	-- Normalizar y ajustar nombres
	exec SONORPALPRO 	
		@Gen_Nombre,	@Val_NomNor output, @NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
						
	exec SONORPALPRO	
		@Gen_ApePat,	@Val_ApPaNo output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
						
	exec SONORPALPRO	
		@Gen_ApeMat,	@Val_ApMaNo output, @NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo

	-- Eliminar palabras compuestas
	exec SOAJPACOPRO
		@Val_NomNor,	@Val_NomNor output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
		
	exec SOAJPACOPRO
		@Val_ApPaNo,	@Val_ApPaNo output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
		
	exec SOAJPACOPRO	
		@Val_ApMaNo,	@Val_ApMaNo output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo

-- Obtener la inicial del primer nombre
	set @Val_Result = @Val_NomNor

    -- Dividir el nombre en palabras y almacenarlas en la tabla @nombres
    while charindex(@Str_Espaci, @Val_Result) > @Ent_Cero
    begin
        insert into #Tab_Nombre(Cam_Nombre)
        values (left(@Val_Result, charindex(@Str_Espaci, @Val_Result) - @Ent_Uno))
        set @Val_Result = ltrim(substring(@Val_Result, charindex(@Str_Espaci, @Val_Result) + @Ent_Uno, len(@Val_Result)))
    end
    -- insertar la última palabra
    insert into #Tab_Nombre (Cam_Nombre)
    values (@Val_Result)
    
    -- Seleccionar el primer nombre y compararlo con el listado de nombres comunes, si es comun seleccionar el segundo nombre
    select top 1 @Val_NomSig = Cam_Nombre from #Tab_Nombre
    if @Val_NomSig in(select Cam_NomCom from #Tab_Comune) begin
    	select top 2 @Val_NomSig = Cam_Nombre from #Tab_Nombre
    end

	drop table #Tab_Nombre
	drop table #Tab_Comune

    -- Tomar la inicial del nombre significativo
    if @Val_NomSig is not null and len(@Val_NomSig) > @Ent_Cero
        set @Val_IniNom = left(@Val_NomSig, @Ent_Uno)
    else
        set @Val_IniNom = @Str_LetraX

	-- Obtener la primera vocal del apellido paterno
	set @Val_VocApe = null

	set @Val_Iterad = @Ent_Dos -- Empezamos desde la segunda posición (después de la primera letra)

	while @Val_Iterad <= len(@Val_ApPaNo) and @Val_VocApe is null begin
		if substring(@Val_ApPaNo, @Val_Iterad, @Ent_Uno) in (@Str_LetraA, @Str_LetraE, @Str_LetraI, @Str_LetraO, @Str_LetraU) begin
			select @Val_VocApe = substring(@Val_ApPaNo, @Val_Iterad, @Ent_Uno)
		end
		set @Val_Iterad = @Val_Iterad + @Ent_Uno
	end
	-- Si no se encuentra una vocal, asignar 'X'
	if @Val_VocApe is null begin
		set @Val_VocApe = @Str_LetraX
	end
	-- Obtener la primera letra del apellido paterno
	select @Val_PrLePa = substring(ltrim(@Val_ApPaNo), @Ent_Uno, @Ent_Uno)

	-- Obtener la primera letra del apellido materno, o 'X' si no existe
	if len(@Val_ApMaNo) > @Ent_Cero begin
		select @Val_PrLeMa = substring(ltrim(@Val_ApMaNo), @Ent_Uno, @Ent_Uno)
	end else begin
		set @Val_PrLeMa = @Str_LetraX
	end

	-- Concatenar los primeros 4 caracteres: Paterno + Vocal + Materno + inicial Nombre
	set @Val_1_4 = @Val_PrLePa + @Val_VocApe + @Val_PrLeMa + @Val_IniNom

	-- Filtrar caracteres no válidos
	select	@Val_1_4= ltrim(@Val_1_4),
			@Val_Iterad = @Ent_Uno,
			@Val_Result = @Str_Vacio

	while @Val_Iterad <= len(@Val_1_4) begin
		set @Val_Caract = substring(@Val_1_4, @Val_Iterad, @Ent_Uno)
		
		-- Verificar si es alfabético, de lo contrario reemplazar por 'X'
		if @Val_Caract like @Str_RegLet
			set @Val_Result = ltrim(@Val_Result) + @Val_Caract
        else
			set @Val_Result = ltrim(@Val_Result) + @Str_LetraX
		set @Val_Iterad = @Val_Iterad + @Ent_Uno

	end
	set @Val_1_4 = @Val_Result

	-- Filtra palabras inconvenientes
	-- Lista de palabras inconvenientes
    if @Val_1_4 in (select Cam_Palabr from #Tab_PalInc) begin
		-- Reemplazar la segunda letra con 'X'
		set @Val_1_4 = stuff(@Val_1_4, @Ent_Dos, @Ent_Uno, @Str_LetraX)
	end

	drop table #Tab_PalInc

	-- Extraer la primera consonante de los apellidos y el nombre
	-- Extrae la primer consonante en palabras
	exec SOPRCOPAPRO 
		@Val_ApPaNo,	@Val_ConPat output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
		
	exec SOPRCOPAPRO 
		@Val_ApMaNo, 	@Val_ConMat output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo
		
	exec SOPRCOPAPRO 
		@Val_NomNor,	@Val_ConNom output,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo

	-- Concatenar las primeras consonantes de cada apellido y del nombre
	set @Val_14_16 = @Val_ConPat + @Val_ConMat + @Val_ConNom

	-- Generar el código de la fecha de nacimiento (año + mes + día)
	select @Val_FecNac = convert(varchar(4),year(@Gen_FecNac))
	select @Val_FecNac = convert(varchar(2),  right(convert(varchar(4),year(@Gen_FecNac)), @Ent_Dos))
	+ right(@Str_Cero + convert(varchar(2), MONTH(@Gen_FecNac)), @Ent_Dos)
	+ right(@Str_Cero + convert(varchar(2), DAY(@Gen_FecNac)), @Ent_Dos)

	-- Generar la parte básica del CURP
	set @Val_CURPBa = convert(varchar(4),@Val_1_4) + convert(varchar(6),@Val_FecNac)  + upper(convert(varchar(1),@Gen_Sexo))
	+ upper(convert(varchar(2),@Gen_EntNac)) + @Val_14_16

	-- Determinar homonimia (si no se especifica, se asigna A o 0)
	if @Gen_Homoni is null begin
		if year(@Gen_FecNac) >= @Ent_DosMil
			set @Gen_Homoni = @Str_LetraA
		else
			set @Gen_Homoni = @Str_Cero
	end

	-- Concatenar el CURP base con el homonimia
	set @Val_CURPBa = @Val_CURPBa + @Gen_Homoni
		
	-- Generar el dígito verificador
	set @Val_Estatu = @Ent_Cero
	exec @Val_Estatu = SODVCURPPRO 
		@Val_CURPBa,	@Val_DigVer output,	@NumTransac,	@Transaccio,	@Usuario,	
		@FechaSis,		@SucOrigen,			@SucDestino,	@Modulo

   	if @Val_Estatu <> @Ent_Cero begin
		select @Gen_CURP = @Val_CURPBa
		return @Ent_Uno -- Devolvemos el código de error
    end else begin
		-- Concatenar el CURP completo (base + dígito verificador)
		select @Gen_CURP = @Val_CURPBa + convert(varchar(1), @Val_DigVer)
		return @Ent_Cero
	end

end