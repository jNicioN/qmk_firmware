create procedure SOPARAMSCON (
	@Par_Sucurs	char(3),
	@Tip_Consul	char(2),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

declare @Fecha_Val 	smalldatetime,		/* Declaración de variables */
		@Dia_Actual smalldatetime, 
		@Tip_Fecha	char(1),
		@Fecha_Char char(10),
		@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Par_TiCaDi	char(3)
										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_LetH	char(1),
		@Fec_LetI	char(1),
		@Str_No		char(1),
		@Str_Consul	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Tres	char(1),
		@Str_Cuatro	char(1)
										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String: Vacío */
		@Fec_LetH	= 'H',
		@Fec_LetI	= 'I',
		@Str_No		= 'N',				/* String: No */
		@Str_Consul	= 'C',				/* String: Consulta */
		@Str_Uno	= '1',				/* String: Uno */
		@Str_Dos	= '2',				/* String: Dos */
		@Str_Tres	= '3',				/* String: Tres */
		@Str_Cuatro	= '4'				/* String: Cuatro */

select	@Par_TiCaDi	= @Par_Sucurs
select	@Dia_Actual = getdate()
select	@Fecha_Char	= convert(char, @Dia_Actual, 101)
select	@Dia_Actual = @Fecha_Char
select	@Fecha_Val	= @Dia_Actual
		
exec SOSIGFECHAB
	@Fecha		= @Fecha_Val output,
	@NumDia		= 0,
	@FinSem		= @Str_No,
	@Salida_Fox	= @Str_No

if datediff(dd, @Dia_Actual, @Fecha_Val) = 0
	select	@Tip_Fecha	= @Fec_LetH
else 	
	select	@Tip_Fecha	= @Fec_LetI

if isnull(@Tip_Consul, @Str_Vacio) = @Str_Vacio begin		/* Cliente:  FoxPro */
	select	Par_Sucurs,	Par_CheCaj,	Par_IVA,	Par_ISR,	Par_DiBaIn,
			Par_DiBaCr,	Par_DiBaCh,	Par_ChLey1,	Par_ChLey2,	Par_ChLey3,
			Par_CheCer,	Par_DiaRem,	Par_LimAut,	Par_TranBR,	Par_CliInd,
			Par_BanFol,	Par_FecAct,	Par_CoCoIn,	Par_CoReme,	Par_OpeBan,
			Par_ConPap,	Par_MonCom,	Par_LinSob,	Par_EnvSPE,	Par_Banco,
			Par_ComRem,	Par_IvaRem,	Par_RemExt,	Par_IVAREX,	Par_GiBaEx,
			Par_GiBaNa,	Par_IVAGBN,	Par_IVAGBE,	Par_ComSPE,	Par_IVASPE,
			Par_NumTes,	Par_IncISR,	Par_InsISR,	Par_SPEUA,	Par_SIAC,
			Par_CobInm,	Par_FecRem,	Par_IntBan,	Par_Compan,
			Tip_Fecha	= @Tip_Fecha,
			Suc_UltDia	= Suc_UltDia
		from SOPARAMS noholdlock,
			SOSUCURS noholdlock
	 	where	Par_Sucurs	= Suc_Numero
 		  and	Par_Sucurs	= @SucOrigen
end else begin
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

	if @Tip_ConTip = @Str_Consul begin		/* Consulta */
		if @Tip_ConCon = @Str_Uno begin
			select	Par_Sucurs, Par_IVA, Par_DiBaCr, Par_FecAct,
					Par_FecSis	= getdate()
				from SOPARAMS noholdlock
				where	Par_Sucurs	= @Par_Sucurs
		end
		if @Tip_ConCon = @Str_Dos begin
			select	Par_Sucurs, Par_HoEnSp
				from SOPARAMS noholdlock
				where	Par_Sucurs	= @Par_Sucurs
		end
		if @Tip_ConCon = @Str_Tres begin
			select	Par_Sucurs,	Suc_Nombre,	Tcd_Numero,	Tcd_Descri
				from SOPARAMS noholdlock,
					 ITTICADI noholdlock,
					 SOSUCURS noholdlock
				where	Par_TiCaDi	= Tcd_Numero
				  and	Par_Sucurs	= Suc_Numero
				  and	Par_TiCaDi	= @Par_TiCaDi
		end
		if @Tip_ConCon = @Str_Cuatro begin
			select	Par_Sucurs,	Par_CheCaj,	Par_IVA,	Par_ISR,	Par_DiBaIn,
				Par_DiBaCr,	Par_DiBaCh,	Par_ChLey1,	Par_ChLey2,	Par_ChLey3,
				Par_CheCer,	Par_DiaRem,	Par_LimAut,	Par_TranBR,	Par_CliInd,
				Par_BanFol,	Par_FecAct,	Par_CoCoIn,	Par_CoReme,	Par_OpeBan,
				Par_ConPap,	Par_MonCom,	Par_LinSob,	Par_EnvSPE,	Par_Banco,
				Par_ComRem,	Par_IvaRem,	Par_RemExt,	Par_IVAREX,	Par_GiBaEx,
				Par_GiBaNa,	Par_IVAGBN,	Par_IVAGBE,	Par_ComSPE,	Par_IVASPE,
				Par_NumTes,	Par_IncISR,	Par_InsISR,	Par_SPEUA,	Par_SIAC,
				Par_CobInm,	Par_FecRem,	Par_IntBan,	Par_Compan,
				Tip_Fecha	= @Tip_Fecha,
				Suc_UltDia	= Suc_UltDia
			from SOPARAMS noholdlock,
				SOSUCURS noholdlock
			where	Par_Sucurs	= Suc_Numero
			  and	Par_Sucurs	= @Par_Sucurs
		end
	end
end
