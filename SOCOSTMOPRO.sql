create procedure SOCOSTMOPRO (
	@Val_String	varchar(20),
	@Val_Money	money output)
	
as

declare	@Lon_String	int,			/* Declaracion de Variables */
		@Contador	int,
		@Asc_Numero	int,
		@Str_Paso	varchar(20)

declare	@Ent_Cero	int,			/* Declaracion de Constantes */
		@Str_Vacio	char(1)

/* Asignacion de Constantes */
select	@Ent_Cero	= 0,			/* Entero en Cero */
		@Str_Vacio	= ''			/* String Vacio */

select	@Val_String	= isnull(@Val_String, @Str_Vacio),
		@Str_Paso	= @Str_Vacio

select	@Val_String	= ltrim(rtrim(@Val_String))

if @Val_String <> @Str_Vacio begin
	select	@Lon_String	= char_length(@Val_String)	
end else begin
	select	@Lon_String	= @Ent_Cero	
end

select	@Contador	= 1

while (@Contador <= @Lon_String) begin

	select	@Asc_Numero	= @Ent_Cero
	
	select	@Asc_Numero	= ascii(substring(@Val_String, @Contador, 1))
	
	if(@Asc_Numero >= 48 and @Asc_Numero <=57) or @Asc_Numero = 44 or @Asc_Numero = 46 begin
		select	@Str_Paso	= @Str_Paso + char(@Asc_Numero)
	end	
		
	select	@Contador	= @Contador + 1
end

select	@Val_Money	= convert(money, @Str_Paso)
