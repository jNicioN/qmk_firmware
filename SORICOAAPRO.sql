create procedure SORICOAAPRO (
	@Rca_Numero	int,
	@Rca_NumRib	int,
	@Rca_Tipo varchar(10),
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
/* DESCRIPCION: Procesamiento de registros de Composicion		*/
/*				Accionaria de RIB								*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
	/* declaracion de constantes */
	declare	@Str_A		char(1),
			@Int_Cero	int

	select	@Str_A		= 'A',
			@Int_Cero	= 0

	/* declaracion de variables */
	declare	@Int_Index	int,
			@Status		int,
			@Tipo   	int
	
	if @Tip_Proces = @Str_A begin				
		Delete from SORICOAA
			where Rca_NumRib = @Rca_NumRib
		
		/* Se separan los tipos de agencias */
		select @Int_Index = charindex(',', @Rca_Tipo)
		while @Int_Index > @Int_Cero begin
			select @Tipo = CONVERT(INT,left(@Rca_Tipo, @Int_Index-1))
			exec SORICOAAALT
			   @Int_Cero,	@Rca_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
			   @Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo 

			set @Rca_Tipo	= substring(@Rca_Tipo, @Int_Index+1, datalength(@Rca_Tipo) - @Int_Index)
			select @Int_Index = charindex(',', @Rca_Tipo)
		end

		if (datalength(@Rca_Tipo) > @Int_Cero) begin
			select @Tipo = CONVERT(INT,@Rca_Tipo)
			exec SORICOAAALT
				@Int_Cero,	@Rca_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
				@Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
		end
	end
	
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado Correctamente'
