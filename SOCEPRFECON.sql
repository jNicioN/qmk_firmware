create procedure SOCEPRFECON (

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Cen_FecAct	smalldatetime,	/* Declaracion de Variables */
		@Cen_FecSis	smalldatetime,
		@Cen_FecSig	smalldatetime,
		@Sis_FecAct	smalldatetime,
		@Hoy		smalldatetime

										/* Declaracion de Constantes */
declare	@Fec_Vacia	smalldatetime,
		@Ent_Cero	int

/* Asignación de Constantes */
select	@Fec_Vacia	= '1900-01-01',		/* Fecha Vacia */
		@Ent_Cero	= 0

select	@Sis_FecAct	= getdate()

select	@Cen_FecAct = Cen_FecAct,
		@Cen_FecSis	= Cen.FechaSis
	from	SOSUCURS noholdlock,
			SOPLAZAS noholdlock,
			SOCENPRO Cen noholdlock
	where	Suc_Numero = @SucOrigen
		and	Suc_Plaza  = Pla_Numero
		and	Pla_CenPro = Cen_Numero

select	@Cen_FecAct	= isnull(@Cen_FecAct, @Fec_Vacia)

if @Cen_FecAct = @Fec_Vacia begin
	select 	Err_Codigo = '000001',
			Err_Mensaj = 'El centro de procesamiento no tiene una fecha valida'
	rollback
	return 1
end

/* Checa si la Fecha del Cen.Resp. se movio hoy (Getdate()) */
if datediff(dd, @Sis_FecAct, @Cen_FecSis) = @Ent_Cero
	exec SOANTFECHAB 
		@Fecha		= @Cen_FecAct output,
		@NumDia		= 1,
		@FinSem		= 'N',
		@Salida_Fox	= 'N'
				
select @Cen_FecSig = dateadd(dd, 1, @Cen_FecAct)
	
exec SOSIGFECHAB 
	@Fecha		= @Cen_FecSig output,
	@NumDia		= 0,
	@FinSem		= 'N',
	@Salida_Fox	= 'N'
	
select @Hoy = @Cen_FecSig

select 	Cen_FecAct 	= @Cen_FecAct,
		Hoy 		= @Hoy
