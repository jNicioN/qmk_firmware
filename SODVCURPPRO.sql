create procedure SODVCURPPRO (
	@DVe_CURP varchar(17),
	@DVe_Digito int output,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************
** DESCRIPCION: Genera el dígito que se usa para validar el CURP.			****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

	/* Declaración de variables */
	declare @Val_Caract varchar(1),
			@Val_Posici int,
			@Val_Suma int,
			@Val_Iterad int,
			@Val_DigCal int,
			@Val_CodErr int

	/* Declaración de constantes */
	declare	@Val_CarPer varchar(37),
			@Str_Vacio char(1),
			@Ent_Cero int,
			@Ent_Uno int,
			@Ent_Diez int,
			@Ent_DieSie int,
			@Ent_DieOch int

	/* Asignación de valores a constantes */
	select	@Val_CarPer 	= '0123456789ABCDEFGHIJKLMNÑOPQRSTUVWXYZ',
			@Str_Vacio		= '',
			@Ent_Cero 		= 0,
			@Ent_Uno 		= 1,
			@Ent_Diez 		= 10,
			@Ent_DieSie 	= 17,
			@Ent_DieOch 	= 18
			
	select	@DVe_CURP 		= upper(ltrim(@DVe_CURP)),  -- Convertimos CURP a mayúsculas
			@Val_Suma 		= @Ent_Cero,
			@Val_Iterad 	= @Ent_Uno -- Empezamos desde el primer carácter

	-- Recorrer los primeros 17 caracteres del CURP
	while @Val_Iterad <= @Ent_DieSie begin
		-- Obtener el carácter en la posición @Val_Iterad
		set @Val_Caract = @Str_Vacio
		set @Val_Caract = substring(@DVe_CURP, @Val_Iterad, @Ent_Uno)
	
		-- Buscar el índice del carácter en el conjunto 'caracteres'
		select @Val_Posici = charindex(@Val_Caract, @Val_CarPer) - @Ent_Uno  -- charindex devuelve la posición, ajustamos a 0-based
	
		-- Si el carácter no se encuentra, asignamos -1 y terminamos
		if @Val_Posici = -1 begin
			set @DVe_Digito = - @Ent_Uno
			return @Ent_Uno
		end
	
		-- Acumular el valor ponderado (multiplicación por la ponderación: 18, 17, ..., 1)
		set @Val_Suma = @Val_Suma + (@Val_Posici * (@Ent_DieOch - (@Val_Iterad - @Ent_Uno)))
	
		-- incrementar el índice @Val_Iterad
		set @Val_Iterad = @Val_Iterad + @Ent_Uno
	end
	
	-- Calcular el dígito verificador
	set @Val_DigCal = @Ent_Diez - (@Val_Suma % @Ent_Diez)
	
	-- Si el dígito verificador es 10, lo ajustamos a 0
	if @Val_DigCal = @Ent_Diez begin
		set @Val_DigCal = @Ent_Cero
	end
	
	-- Asignar el valor del dígito verificador al parámetro de salida
	set @DVe_Digito = @Val_DigCal
	
	set @Val_CodErr = @@error
	if @DVe_Digito = -1 or @Val_CodErr <> @Ent_Cero 
	begin
        return @Ent_Uno
    end else begin
	    return @Ent_Cero
	end
end