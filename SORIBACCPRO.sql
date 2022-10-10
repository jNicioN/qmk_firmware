create procedure SORIBACCPRO (
	@Ria_Numero int,
	@Ria_NumRib int,
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
/* DESCRIPCION: Procesamiento de registros de Accionistas		*/
/*				asociados a Rib									*/
/****************************************************************/
/** Modifico:		Jose R. Rodriguez Zenteno					*/
/** Fecha:			21/09/2022                               	*/
/** Descripcion:	Se agrego Ria_NomAcc en insert				*/
/** Help:			1643668					 					*/
/****************************************************************/
/** Creo:			Victor Osorio								*/
/** Fecha:			02/05/2017                             		*/
/** Help:			929417 				 						*/
/****************************************************************/

/* Declaracion de Constantes */
declare @Str_A		char(1),
		@Int_Cero	int,
		@Int_Uno	int,
		@Exi_Reg	int

select	@Str_A		= 'A',
		@Int_Cero	= 0,
		@Int_Uno	= 1,
		@Exi_Reg    = 0

/* Declaracion de Variables */
declare @Int_RibBas	int,
		@Str_NumPer	char(8),
		@Int_NumSol int


if @Tip_Proces	= @Str_A begin /* 'A': Proceso para realizar la copia de registros al Rib Base. */
	
	select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Ria_NumRib)
	select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Ria_NumRib)
	
	if @Int_NumSol > @Int_Cero begin
		/* Si existe Rib Persona Base, se crean las copias de registros */
		select @Exi_Reg = @Int_Uno from SORIB noholdlock where Rib_NumPer = @Str_NumPer and Rib_NumSol = @Int_Cero
		
		if (@Exi_Reg = @Int_Uno) begin
			
			select @Int_RibBas = (select Rib_Numero 
									from SORIB noholdlock
									where Rib_NumPer = @Str_NumPer 
									and Rib_NumSol = @Int_Cero)

			delete from SORIBACC where Ria_NumRib = @Int_RibBas

			insert into SORIBACC (
					Ria_NumRib,		Ria_NumPer,		Ria_PorPar,		Ria_Activo,		Ria_NomAcc,
					NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,
					SucDestino)
			select	@Int_RibBas,   	Ria_NumPer,    	Ria_PorPar,		Ria_Activo,		Ria_NomAcc,
					@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
					@SucDestino
			from SORIBACC noholdlock
			where Ria_NumRib = @Ria_NumRib
			  and Ria_Activo = @Int_Uno

		end
	end
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Se ha procesado la copia de registros de forma correcta'