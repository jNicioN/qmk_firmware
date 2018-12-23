create procedure SORIDILIPRO (
	@Rdl_Numero int,
    @Rdl_NumRib int,
    @Rdl_Tipo varchar(50),
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
/* DESCRIPCION: Procesamiento de Diversificacion Lineas de RIB	*/
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
		Delete from SORIDILI
		where Rdl_NumRib = @Rdl_NumRib
		
		/* Se separan los tipos de Poderes y se realiza la insercion */
		select @Int_Index = charindex(',', @Rdl_Tipo)
		while @Int_Index > @Int_Cero begin
			select @Tipo = CONVERT(INT,left(@Rdl_Tipo, @Int_Index-1))
			exec SORIDILIALT
			   @Int_Cero,	@Rdl_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
			   @Usuario,	@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo 

			set @Rdl_Tipo	= substring(@Rdl_Tipo, @Int_Index+1, datalength(@Rdl_Tipo) - @Int_Index)
			select @Int_Index = charindex(',', @Rdl_Tipo)
		end

		if (datalength(@Rdl_Tipo) > @Int_Cero) begin
			select @Tipo = CONVERT(INT,@Rdl_Tipo)
			exec SORIDILIALT
				@Int_Cero,		@Rdl_NumRib,	@Tipo,		@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,	@SucDestino,	@Modulo
		end
	end
	
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado Correctamente'
