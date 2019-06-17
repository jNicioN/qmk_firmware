create procedure SORIDILFPRO (
	@Rdf_Numero int,
    @Rdf_NumRib int,
    @Rdf_Tipo varchar(50),
    @Tip_Proces	char(1),
    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario char(6),
    @FechaSis smalldatetime,
    @SucOrigen char(3),
    @SucDestino char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Procesamiento Diversificacion Lineas			*/
/*				Financiamiento de RIB							*/
/****************************************************************/
/* Modifico:	Victor Osorio									*/
/* Fecha:		23/01/2018										*/
/* Descripcion:	Se corrige alta de registros			*/
/* Help:		929417											*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
	/* declaracion de constantes */
	declare	@Str_A		char(1),	/* String A */
			@Ent_Cero	int,			/* Entero cero */
			@Status	int,		/* Campo de retorno */
			@Ent_Uno	int		/* Entero Uno */

	select	@Str_A		= 'A',
			@Ent_Cero	= 0,
			@Ent_Uno	= 1

	/* declaracion de variables */
	declare	@Int_Index	int,	/* Variable entero para indice */
			@Tipo   	int		/* Variable entero para tipo de proceso */
	
	if @Tip_Proces = @Str_A begin				
		Delete from SORIDILF
		where Rdf_NumRib = @Rdf_NumRib
		
		/* Se separan los tipos de Poderes y se realiza la insercion */
		select @Int_Index = charindex(',', @Rdf_Tipo)
		while @Int_Index > @Ent_Cero begin
			select @Tipo = CONVERT(INT,left(@Rdf_Tipo, @Int_Index-1))
			exec @Status = SORIDILFALT
			   @Ent_Cero,	@Rdf_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
			   @Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
			
			if @Status <> @Ent_Cero begin
				select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Error en alta de registros de Diversificacion Lineas'

				rollback
				return @Ent_Uno
			end

			set @Rdf_Tipo	= substring(@Rdf_Tipo, @Int_Index+1, datalength(@Rdf_Tipo) - @Int_Index)
			select @Int_Index = charindex(',', @Rdf_Tipo)
		end

		if (datalength(@Rdf_Tipo) > @Ent_Cero) begin
			select @Tipo = CONVERT(INT,@Rdf_Tipo)
			exec @Status = SORIDILFALT
				@Ent_Cero,	@Rdf_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
				@Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
				
			if @Status <> @Ent_Cero begin
				select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Error en alta de registro de Diversificacion Lineas'

				rollback
				return @Ent_Uno
			end
		end
	end
	
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado Correctamente'
