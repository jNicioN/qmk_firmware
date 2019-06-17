create procedure SOCENPROFEC (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Cen_FecAct	smalldatetime,
		@Fecha_Val	smalldatetime,
		@Hoy		smalldatetime

select	@Cen_FecAct = Cen_FecAct
	from	SOSUCURS noholdlock,	SOPLAZAS noholdlock,
			SOCENPRO noholdlock
	where	Suc_Numero = @SucOrigen
		and	Suc_Plaza  = Pla_Numero
		and	Pla_CenPro = Cen_Numero

if @Cen_FecAct = null begin
	select 	Err_Codigo = '000001',
			Err_Mensaj = 'El centro de procesamiento no tiene una fecha valida'
	rollback
	return 1		
end
		
select @Fecha_Val = dateadd(dd, 1, @Cen_FecAct)

exec SOSIGFECHAB @Fecha_Val output, 0, 'N', 'N'

select @Hoy = @Fecha_Val

select 	Cen_FecAct 	= @Cen_FecAct, 
		Hoy 		= @Hoy
