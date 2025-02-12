create procedure SONORPALPRO (
	@Nor_Texto varchar(100), 
	@Nor_Result varchar(100) output,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************
** DESCRIPCION: Elimina los acentos, eñes y diéresis que pudiera 			****
**				tener el nombre.											****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

	/* Declaración de variables */
	declare @Val_Itera int,				-- Índice para iterar sobre los caracteres
			@Val_SubIte int,			-- Índice para recorrer la cadena resultante
			@Val_Caract char(1),		-- Carácter actual
			@Val_CarRee char(1)			-- Carácter de reemplazo	

	/* Declaración de constantes */
	declare	@Val_CarOri varchar(255),	
			@Val_CarDes varchar(255),	
			@Val_AlfMx varchar(100),
			@Ent_Cero int,
			@Ent_Uno int

	/* Asignación de valores a constantes */	
	-- Definir los caracteres con acentos y sus respectivos reemplazos
	
	select	@Val_AlfMx 	= 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz ',-- Caracteres del alfabero
			@Val_CarOri	= 'ÃÀÁÄÂÈÉËÊÌÍÏÎÒÓÖÔÙÚÜÛãàáäâèéëêìíïîòóöôùúüûÇç',			-- Carácter de origen con acentos y diéresis
			@Val_CarDes	= 'AAAAAEEEEIIIIOOOOUUUaaaaaeeeeiiiioooouuucc',				-- Carácter destino sin acentos ni diéresis
			@Nor_Result	= '',  														-- inicializar la cadena resultante
			@Val_Itera	= 1,        												-- inicializar el índice para recorrer los caracteres de origen							
			@Ent_Cero	= 0,														-- Valor Entero Cero
			@Ent_Uno	= 1															-- Valor Entero Uno

	set	@Nor_Texto	= ltrim(@Nor_Texto)
	-- Iterar sobre cada carácter en la cadena de entrada
	while @Val_Itera <= len(@Nor_Texto) begin
		set @Val_Caract = substring(ltrim(@Nor_Texto), @Val_Itera, @Ent_Uno)  -- Obtener el carácter actual de la cadena

		-- Buscar el carácter en la lista de caracteres con acentos
		set @Val_SubIte = charindex(@Val_Caract, @Val_CarOri)

		-- Si el carácter existe en la lista de caracteres con acentos, reemplazarlo
		if @Val_SubIte > @Ent_Cero begin
			set @Val_CarRee = substring(@Val_CarDes, @Val_SubIte, @Ent_Uno)  -- Obtener el reemplazo
			set @Nor_Result = @Nor_Result + @Val_CarRee        -- Agregar el reemplazo a la cadena resultante
		end 
		else begin
			-- Buscamos si el caracter es parte del alfabeto o es un espacio
			set @Val_SubIte = charindex(@Val_Caract,@Val_AlfMx)
			-- Si lo encontramos se agrega al texto nuevo, en caso contrario se omite
			if @Val_SubIte > @Ent_Cero begin
				set @Nor_Result = ltrim(@Nor_Result) + @Val_Caract  -- Si no es necesario reemplazar, agregar el carácter original
			end
		end

		set @Val_Itera = @Val_Itera + @Ent_Uno  -- Avanzar al siguiente carácter
	end
	set @Nor_Result = ltrim(@Nor_Result)

end