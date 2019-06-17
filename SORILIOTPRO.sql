create procedure SORILIOTPRO (
	@Rlo_Numero int,
	@Rlo_NumRib int,
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
/* DESCRIPCION: Procesamiento de registros Lineas				*/
/*				Autorizadas con Otras Instituciones Financieras	*/
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
	
	select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Rlo_NumRib)
	select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Rlo_NumRib)

	if @Int_NumSol > @Int_Cero begin	
		/* Si existe Rib Persona Base, se crean las copias de registros */
		if exists (select Rib_Numero from SORIB noholdlock where Rib_NumPer = @Str_NumPer and Rib_NumSol = @Int_Cero) begin
			
			select @Int_RibBas = (select Rib_Numero 
									from SORIB noholdlock
									where Rib_NumPer = @Str_NumPer 
									and Rib_NumSol = @Int_Cero)

			delete from SORILIOT where Rlo_NumRib = @Int_RibBas

			insert into SORILIOT (
					Rlo_NumRib,		Rlo_Instit,		Rlo_TipCre,		Rlo_MonAut,		Rlo_Respon,
					Rlo_Moneda,		Rlo_Plazo,		Rlo_Tasa,		Rlo_Avales,		Rlo_Garant,
					Rlo_Total,		Rlo_PagMen,		Rlo_Destin,		Rlo_Activo,		NumTransac,
					Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
			select	@Int_RibBas,	Rlo_Instit,		Rlo_TipCre,		Rlo_MonAut,		Rlo_Respon,
					Rlo_Moneda,		Rlo_Plazo,		Rlo_Tasa,		Rlo_Avales,		Rlo_Garant,
					Rlo_Total,		Rlo_PagMen,		Rlo_Destin,		Rlo_Activo,		@NumTransac,
					@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
			from SORILIOT noholdlock
			where Rlo_NumRib = @Rlo_NumRib
			  and Rlo_Activo = @Int_Uno
		end
	end
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Se ha procesado la copia de registros de forma correcta'
