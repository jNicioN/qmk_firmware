create procedure SORIBPODPRO (
	@Rip_Numero int,
	@Rip_NumRib int,
	@Rip_MulPod varchar(20),
	@Tip_Proces	char(1),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as
/****************************************************************/
/* DESCRIPCION: Procesamiento de registros de Poderes RIB PM	*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		10/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

	/* declaracion de constantes */
	declare	@Str_A		char(1),
			@Str_Vacio	char(1),
			@Int_Cero	int

	select	@Str_A		= 'A',
			@Str_Vacio	= '',
			@Int_Cero	= 0

	/* declaracion de variables */
	declare	@Int_Index	int,
			@Status		int,
			@TipoPoder	int

	if @Tip_Proces = @Str_A begin
		/* eliminacion de registros por Rib */
		delete from SORIBPOD
			where Rip_NumRib = @Rip_NumRib

		/* Se separan los tipos de Poderes y se realiza la insercion */
		if @Rip_MulPod != @Str_Vacio begin
							select @Int_Index = charindex(',', @Rip_MulPod)
			while @Int_Index > @Int_Cero begin
				select @TipoPoder = CONVERT(INT,left(@Rip_MulPod, @Int_Index-1))
				exec SORIBPODALT
					@Int_Cero,	@Rip_NumRib,	@TipoPoder, 	@NumTransac,	@Transaccio,
					@Usuario,	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
				set @Rip_MulPod	= substring(@Rip_MulPod, @Int_Index+1, datalength(@Rip_MulPod) - @Int_Index)
				select @Int_Index = charindex(',', @Rip_MulPod)
			end
	
			if (datalength(@Rip_MulPod) > @Int_Cero) begin
				select @TipoPoder = CONVERT(INT,@Rip_MulPod)
				exec SORIBPODALT
					@Int_Cero,	@Rip_NumRib,	@TipoPoder,		@NumTransac,	@Transaccio,
					@Usuario,	@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
			end
		end
	end

	select		Err_Codigo	= '000000',
				Err_Mensaj	= 'Se ha procesado el alta de registros'
