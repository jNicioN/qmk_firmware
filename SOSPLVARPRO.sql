create procedure SOSPLVARPRO(
    @Cadena     VARCHAR(8000),
    @Cadena2	VARCHAR(8000),
    @Cadena3	VARCHAR(8000),
    @Separador  CHAR(1))
as
/***************************************************************************
** DESCRIPCION: Utileria para hacer SPLIT y guardarlo como VARCHAR 		****
** versión 2 del procedimiento UTSPLITV.								****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó:		Eloísa Hernández Fierro								****
** Fecha:			03/Agosto/2017										****
** Descripción: 	Se modificó porque se ciclaba al enviar el segundo 	****
**					parámetro consumiendo toda la memoria del tempdb.	****
**					Ver SP original UTSPLITV creado por Carlos Guzman.	****
** Requisicion:		973043												****
***************************************************************************/
declare @Posicion	int,				/* Declaración de Variables   */
		@Valor		varchar(8000),
		@LenCadena	int,
		@LenCadena2	int,
		@LenCadena3	int
		
declare	@Str_Vacio	varchar(1),			/* Declaración de Constantes */
		@PosInicial	int,
		@LenCero	int,
		@PosCero	int
		
		
select @Str_Vacio	= '', 				/*	String Vacío											*/
	@PosInicial		= 1,				/*	Posición inicial de la cadena							*/
	@LenCero		= 0,				/*	Longitud cero											*/
	@PosCero		= 0					/*	Posición cero											*/

SET @Posicion = @PosInicial

set @LenCadena 	= @LenCero
if @Cadena is not null and isnull(rtrim(@Cadena), @Str_Vacio) <> @Str_Vacio begin
	set @LenCadena 	= len(@Cadena)
end
set @LenCadena2 = @LenCero
if @Cadena2 is not null and isnull(rtrim(@Cadena2), @Str_Vacio) <> @Str_Vacio begin
	set @LenCadena2 = len(@Cadena2)
end
set @LenCadena3 = @LenCero
if @Cadena3 is not null and isnull(rtrim(@Cadena3), @Str_Vacio) <> @Str_Vacio begin
	set @LenCadena3 = len(@Cadena3)
end

while (@Posicion > @PosCero) begin
	set @Posicion = charindex(@Separador, @Cadena)
	if @Posicion > @PosCero begin
		set @Valor = isnull(substring(@Cadena, 1, @Posicion-1), @Str_Vacio)
		insert into #SplitTable values(@Valor)
		set @Cadena = right(@Cadena, len(@Cadena) - @Posicion)
	end else begin
		insert into #SplitTable values(@Cadena)
		set @Cadena = @Str_Vacio
		if @LenCadena2 > @LenCero begin
			set @Cadena = @Cadena2
			set @LenCadena2 = @LenCero
			set @Posicion = @PosInicial
		end else begin
			if @LenCadena3 > @LenCero begin
				set @Cadena = @Cadena3
				set @LenCadena3 = @LenCero
				set @Posicion = @PosInicial
			end
		end
	end
end
