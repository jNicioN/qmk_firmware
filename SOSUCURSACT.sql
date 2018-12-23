create procedure SOSUCURSACT (
	@Suc_Numero	char(3),
	@Suc_IVA	smallmoney,
	@Tip_Actual	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* Declaración de Variables*/

/* Declaración de Constantes*/
declare	@Act_IVA	char(1),
		@Act_CieArr	char(1),
		@Act_CieRea	char(1),
		@Sta_Proces	char(1),
		@Sta_Termin	char(1)

/* Asignación  de Valores*/
select 	@Act_IVA	= 'A',				/* Actualizar campo de IVA en SOSUCURS*/
		@Act_CieArr	= 'B',				/*	Actualizacion: Sucursales En Proceso	*/
		@Act_CieRea	= 'C',				/*	Actualizacion: Cierre Realizado			*/
		@Sta_Proces	= 'N',				/*	Status: En Proceso	*/
		@Sta_Termin	= 'T'				/*	Status: Terminado	*/

if @Tip_Actual = @Act_IVA begin
	update SOSUCURS set
		Suc_IVA		= @Suc_IVA,		

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Suc_Numero	= @Suc_Numero
end

if @Tip_Actual = @Act_CieArr begin
	update SOSUCURS set
		Suc_StCiAr	= @Sta_Proces,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
end

if @Tip_Actual = @Act_CieRea begin
	update SOSUCURS set
		Suc_StCiAr	= @Sta_Termin,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Suc_Numero	= @Suc_Numero
end
