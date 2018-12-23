create procedure SORIBJUIPRO (
	@Rij_Numero	int,
	@Rij_NumRib	int,
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
/** Descripcion: Procesamiento de registros de Juicios			*/
/**					Asociados a RIB								*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		02/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/
	/* declaracion de constantes */
	declare	@Str_A		char(1),
			@Int_Cero	int,
			@Int_Uno	int

	select	@Str_A		= 'A',
			@Int_Cero	= 0,
			@Int_Uno	= 1

	/* declaracion de variables */
	declare	@Int_RibBas	int,
			@Str_NumPer	char(8),
			@Int_NumSol int
	
	if @Tip_Proces = @Str_A begin
		
		select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Rij_NumRib)
		select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Rij_NumRib)

		if @Int_NumSol > @Int_Cero begin
			/* Si existe Rib Persona Base, se crean las copias de registros */
			if exists (select Rib_Numero from SORIB noholdlock where Rib_NumPer = @Str_NumPer and Rib_NumSol = @Int_Cero) begin
			
				select @Int_RibBas = (select Rib_Numero 
										from SORIB noholdlock 
										where Rib_NumPer = @Str_NumPer 
										and Rib_NumSol = @Int_Cero)

				delete from SORIBJUI 
				   where Rij_NumRib = @Int_RibBas

				insert into SORIBJUI (
						Rij_NumRib,		Rij_TipJui,		Rij_FecAct,		Rij_Descri,
						Rij_Activo,		NumTransac,		Transaccio,		Usuario,
						FechaSis,		SucOrigen,		SucDestino)
					select	@Int_RibBas,	Rij_TipJui,		Rij_FecAct,		Rij_Descri,
							Rij_Activo,		@NumTransac,	@Transaccio,	@Usuario,
							@FechaSis,		@SucOrigen,		@SucDestino
					from SORIBJUI noholdlock
					where Rij_NumRib = @Rij_NumRib
					  and Rij_Activo = @Int_Uno
			end
		end
	end

	select	Err_Codigo = '000000',
			Err_Mensaj = 'Registro Borrado Correctamente'
