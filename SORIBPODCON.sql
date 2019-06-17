create procedure SORIBPODCON (
	@Rip_Numero int,
	@Rip_NumRib int,
	@Tip_Consul char(2),
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
as

/****************************************************************/
/* DESCRIPCION: Consulta de registros de Poderes RIB PM			*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		07/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de Variables */
declare @Tip_ConTip char(1),
        @Tip_ConCon char(1), 
        @Str_C char(1),
		@Act_Uno	int	

declare @Str_Uno char(1),
		@Str_Dos char(1)

select @Str_C = 'C',
       @Str_Uno = '1',
	   @Str_Dos = '2',
	   @Act_Uno = 1

select @Tip_ConTip = substring(@Tip_Consul, 1, 1),
       @Tip_ConCon = substring(@Tip_Consul, 2, 1) 


if @Tip_ConTip	= @Str_C begin /* 'C': Consulta */
	if @Tip_ConCon = @Str_Uno begin		/* C1 */
		select
			Rip_Numero,		Rip_NumRib,		Rip_TipPod,		NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SORIBPOD noholdlock
		where Rip_Numero = @Rip_Numero
		and Rip_Activo = @Act_Uno
	end
end else begin
	if @Tip_ConCon = @Str_Uno begin		/* L1 */
		select
			Rip_Numero,		Rip_NumRib,		Rip_TipPod,		NumTransac,		Transaccio,		Usuario,		FechaSis,		SucOrigen,		SucDestino
		from SORIBPOD noholdlock
		where Rip_NumRib = @Rip_NumRib
		and Rip_Activo = @Act_Uno
	end
end
