create procedure SOSPVATRPRO(
    @Cadena     VARCHAR(8000),
    @Cadena2	VARCHAR(8000),
    @Cadena3	VARCHAR(8000),
    @Separador  CHAR(1))
as
/***************************************************************************
** DESCRIPCION: Utileria para hacer SPLIT y guardarlo como VARCHAR 		****
** de cadenas truncas versión 3 del procedimiento UTSPLITV.				****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó:		Eloísa Hernández Fierro								****
** Fecha:			05/Octubre/2017										****
** Descripción: 	Se modificó porque se ciclaba al enviar el segundo 	****
**					parámetro consumiendo toda la memoria del tempdb.	****
**					Ver SP original UTSPLITV creado por Carlos Guzman.	****
**					No se puede utilizar la version 2 SOSPLVARPRO por	****
**					que en esta versión puede contener cadenas truncas	****
**					y en el otro escenario no se puede usar este sp por ****
**					que no tiene separador entre los parámetros para po-****
**					der unir las cadenas.								****
** Requisicion:		1031033												****
***************************************************************************/
declare @Posicion	int,				/* Declaración de Variables   */
		@Valor		varchar(8000),
		@LenCadena	int,
		@LenCadena2	int,
		@LenCadena3	int,
		@LenCadCom	int,				/* Longitud cadena complemento 					*/
										/* Se usa para determinar la porcioon de cadena */
										/* que se unira con el sobrante de la cadena que*/
										/* se esta procesando.							*/
		@LenSumCad	int
		
declare	@Str_Vacio	varchar(1),			/* Declaración de Constantes */
		@PosInicial	int,
		@LenCero	int,
		@PosCero	int,
		@LenMax		int		
		
select @Str_Vacio	= '', 				/*	String Vacío											*/
	@PosInicial		= 1,				/*	Posición inicial de la cadena							*/
	@LenCero		= 0,				/*	Longitud cero											*/
	@PosCero		= 0,				/*	Posición cero											*/
	@LenMax			= 8000				/*	Longitud maxima de la cadena							*/

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
		set @Valor = isnull(substring(@Cadena, @PosInicial, @Posicion-@PosInicial), @Str_Vacio)
		insert into #SplitTable values(@Valor)
		set @Cadena = right(@Cadena, len(@Cadena) - @Posicion)
	end else begin
		if @LenCadena2 > @LenCero begin
			set @LenSumCad = len(@Cadena)+@LenCadena2 
			if(@LenSumCad > @LenMax)begin
				/* Longitud de la cadena 2 menos la longitud del residuo de cadena */
				set @LenCadCom = @LenCadena2-len(@Cadena) 
				set @Cadena = @Cadena + substring(@Cadena2, @PosInicial, @LenCadCom)
				set @LenCadena2 = @LenCadena2 - @LenCadCom
				set @Cadena2 = substring(@Cadena2, @LenCadena2+@PosInicial, len(@Cadena2))
			end else begin
				set @Cadena = @Cadena + @Cadena2
				set @LenCadena2 = @LenCero
			end
			set @Posicion = @PosInicial
		end else begin
			set @LenSumCad = len(@Cadena)+@LenCadena3
			if @LenCadena3 > @LenCero begin
				if(@LenSumCad > @LenMax)begin
					set @LenCadCom = @LenCadena3-len(@Cadena) 
					set @Cadena = @Cadena + substring(@Cadena3, @PosInicial, @LenCadCom)
					set @LenCadena3 = @LenCadena2 - @LenCadCom
					set @Cadena3 = substring(@Cadena3, @LenCadena3+@PosInicial, len(@Cadena3))
				end else begin
					set @Cadena = @Cadena + @Cadena3
					set @LenCadena3 = @LenCero
				end
				set @Posicion = @PosInicial
			end
		end
	end
end
if(rtrim(@Cadena) != @Str_Vacio) begin
	insert into #SplitTable values(@Cadena)
end
