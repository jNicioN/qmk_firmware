create procedure SORIREINPRO (
	@Rri_Numero int,
	@Rri_NumRib int,
	@Tip_Proces char(1),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Procesamiento de registros Relaciones			*/
/*				de Instituciones Financieras asociadas a Rib	*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		02/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Constantes */
declare @Str_A		char(1),
		@Int_Cero	int,
		@Int_Uno	int

select	@Str_A		= 'A',
		@Int_Cero	= 0,
		@Int_Uno	= 1

/* Declaracion de Variables */
declare @Int_RibBas	int,
		@Str_NumPer	char(8),
		@Int_NumSol int


if @Tip_Proces	= @Str_A begin /* 'A': Proceso para realizar la copia de registros al Rib Base. */
	
	select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Rri_NumRib)
	select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Rri_NumRib)

	if @Int_NumSol > @Int_Cero begin
		/* Si existe Rib Persona Base, se crean las copias de registros */
		if exists (select Rib_Numero from SORIB noholdlock where Rib_NumPer = @Str_NumPer and Rib_NumSol = @Int_Cero) begin
		
			select @Int_RibBas = (select Rib_Numero 
									from SORIB noholdlock
									where Rib_NumPer = @Str_NumPer 
									and Rib_NumSol = @Int_Cero)

			delete from SORIREIN where Rri_NumRib = @Int_RibBas

			insert into SORIREIN (
					Rri_NumRib,		Rri_Instit,		Rri_Produc,		Rri_PorPar,		Rri_FePrC1, 
					Rri_MoPrC1,		Rri_FePrC2,		Rri_MoPrC2,		Rri_FePrC3,		Rri_MoPrC3,
					Rri_Activo,		NumTransac,		Transaccio,		Usuario,		FechaSis,
					SucOrigen,		SucDestino)
			select	@Int_RibBas,	Rri_Instit,		Rri_Produc,		Rri_PorPar,		Rri_FePrC1, 
					Rri_MoPrC1,		Rri_FePrC2,		Rri_MoPrC2,		Rri_FePrC3,		Rri_MoPrC3,
					Rri_Activo,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
					@SucOrigen,		@SucDestino
			from SORIREIN noholdlock
			where Rri_NumRib = @Rri_NumRib
			  and Rri_Activo = @Int_Uno
		end
	end
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Se ha procesado la copia de registros de forma correcta'
