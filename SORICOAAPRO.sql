create procedure SORICOAAPRO (
	@Rca_Numero	int,
	@Rca_NumRib	int,
	@Rca_Tipo varchar(10),
	@Rca_PoPaMu numeric,
	@Rca_ConMuj int,
	@Rca_PeAlDi int,
	@Rca_MuAlDi int,
	@Rca_DiPrMi int,
	@Rca_GeDiGe int,
	@Rca_GePrCo int,
   
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
/* Modifico:	Raul Muniz										*/
/* Fecha:		28/03/2025										*/
/* Descripcion:	Se modifica tipo de parametro @Rca_DiPrMi a int	*/
/* ID Jira:		TCELEM-11573									*/
/****************************************************************/
/* Modifico:	Raul Muniz										*/
/* Fecha:		21/06/2023										*/
/* C.Cambios:	29013											*/
/* Descripcion: Se agregan campos de inclusion de la mujer		*/
/****************************************************************/
/* Creo:		Jorge Armando Garcia							*/
/* Fecha:		24/02/2017										*/
/* Help:		929417											*/
/****************************************************************/
	/* declaracion de constantes */
	declare	@Str_A		char(1),
			@Int_Cero	int

	select	@Str_A		= 'A',	/* String A */
			@Int_Cero	= 0		/* Entero Cero */

	/* declaracion de variables */
	declare	@Int_Index	int,	/* Indice */
			@Status		int,	/* Campo de retorno */
			@Tipo   	int		/* Tipo */
	
	if @Tip_Proces = @Str_A begin				
		Delete from SORICOAA
			where Rca_NumRib = @Rca_NumRib
		
		/* Se separan los tipos de agencias */
		select @Int_Index = charindex(',', @Rca_Tipo)
		while @Int_Index > @Int_Cero begin
			select @Tipo = CONVERT(INT,left(@Rca_Tipo, @Int_Index-1))
			exec @Status = SORICOAAALT
			   @Int_Cero,	@Rca_NumRib,	@Tipo,			@Rca_PoPaMu,	@Rca_ConMuj,
			   @Rca_PeAlDi,	@Rca_MuAlDi,	@Rca_DiPrMi,	@Rca_GeDiGe,	@Rca_GePrCo,
			   @NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
			   @SucDestino,	@Modulo 

			set @Rca_Tipo	= substring(@Rca_Tipo, @Int_Index+1, datalength(@Rca_Tipo) - @Int_Index)
			select @Int_Index = charindex(',', @Rca_Tipo)
		end

		if (datalength(@Rca_Tipo) > @Int_Cero) begin
			select @Tipo = CONVERT(INT,@Rca_Tipo)
			exec @Status = SORICOAAALT
				@Int_Cero,		@Rca_NumRib,	@Tipo,			@Rca_PoPaMu,	@Rca_ConMuj,
				@Rca_PeAlDi,	@Rca_MuAlDi,	@Rca_DiPrMi,	@Rca_GeDiGe,	@Rca_GePrCo,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino,	@Modulo
		end
	end
	
	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado Correctamente'