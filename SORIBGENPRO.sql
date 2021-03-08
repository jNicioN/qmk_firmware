create procedure SORIBGENPRO (
	@Rig_Numero	int,
	@Rig_NumRib	int,
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
/** Descripcion :	Procesamiento de registros de Generalidades	*/
/**					asociados a RIB								*/
/****************************************************************/
/** Creo:		Raul Muniz										*/
/** Fecha:		23/12/2020                               		*/
/** Help:		1433413					 						*/
/****************************************************************/
/* declaracion de constantes */
declare	@Str_A		char(1),
		@Str_B		char(1),
		@Int_Cero	int,
		@Int_Uno	int

select	@Str_A		= 'A',
		@Str_B		= 'B',
		@Int_Cero	= 0,
		@Int_Uno	= 1

/* declaracion de variables */
declare	@Int_RibBas	int,
		@Str_NumPer	char(8),
		@Int_NumSol int,
		@Rig_TiDeGo	int,
		@Rig_DepGob	int,
		@Rig_TieExp	int,
		@Rig_Export	int,
		@Rig_PorExp	numeric(10,2),
		@Rig_TiGeDi	int,
		@Rig_GeCoMa	int

if @Tip_Proces = @Str_A begin
	
	select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Rig_NumRib)
	select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Rig_NumRib)

	if @Int_NumSol > @Int_Cero begin
		/* Si existe Rib Persona Base, se crean las copias de registros */
		if exists (select Rib_Numero from SORIB noholdlock where Rib_NumPer = @Str_NumPer and Rib_NumSol = @Int_Cero) begin

			select @Int_RibBas = (select Rib_Numero 
									from SORIB noholdlock
									where Rib_NumPer = @Str_NumPer 
									and Rib_NumSol = @Int_Cero)

			delete from SORIBGEN where Rig_NumRib = @Int_RibBas

			insert into SORIBGEN 
				(Rig_NumRib,	Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,		Rig_Export,
				Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,		NumTransac,
				Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino)
				select	@Int_RibBas,	Rig_TiDeGo,		Rig_DepGob,		Rig_TieExp,		Rig_Export,
						Rig_PorExp,		Rig_TiGeDi,		Rig_GeCoMa,		Rig_Activo,		@NumTransac,
						@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino
					from SORIBGEN noholdlock
					where Rig_NumRib = @Rig_NumRib
		end
	end
end
else if @Tip_Proces = @Str_B begin
	
	select @Str_NumPer = (select DISTINCT(Rib_NumPer) from SORIB noholdlock where Rib_Numero = @Rig_NumRib)
	select @Int_NumSol = (select DISTINCT(Rib_NumSol) from SORIB noholdlock where Rib_Numero = @Rig_NumRib)
	
	if @Int_NumSol = @Int_Cero begin
		select	@Rig_TiDeGo	= Rig_TiDeGo,	@Rig_DepGob = Rig_DepGob,	@Rig_TieExp = Rig_TieExp,	@Rig_Export = Rig_Export,	@Rig_PorExp = Rig_PorExp,
				@Rig_TiGeDi = Rig_TiGeDi,	@Rig_GeCoMa = Rig_GeCoMa
			from	SORIBGEN noholdlock
			where	Rig_NumRib = @Rig_NumRib
			
		update SORIBGEN set
			Rig_TiDeGo	= @Rig_TiDeGo,
			Rig_DepGob	= @Rig_DepGob,
			Rig_TieExp	= @Rig_TieExp,
			Rig_Export	= @Rig_Export,
			Rig_PorExp	= @Rig_PorExp,
			Rig_TiGeDi	= @Rig_TiGeDi,
			Rig_GeCoMa	= @Rig_GeCoMa,
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		from 	SORIB noholdlock
		where	Rib_Numero = Rig_NumRib
		  and	Rib_NumPer = @Str_NumPer
	end
end

select	Err_Codigo = '000000',
		Err_Mensaj = 'Registro Borrado Correctamente'