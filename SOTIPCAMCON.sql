create procedure SOTIPCAMCON (
	@Fecha		smalldatetime,
	@Con_TipCam	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*	Declaración de variables	*/
declare	@Mon_Numero	char(2),
		@Mon_TipCam	money,
		@Status		int

/*	Declaración de constantes	*/
declare	@Mon_Pesos	char(2)

/*	Asignación de constantes	*/
select	@Mon_Pesos	= '01'			/*	Moneda en Pesos	*/

select distinct 
		Moneda
	into #Monedas
	from #Tip_Cambio

declare MONEDAS cursor for
	select  Moneda
		from #Monedas
		
open MONEDAS
fetch MONEDAS into
	@Mon_Numero

while (@@sqlstatus = 0) begin	
	
	if @Mon_Numero = @Mon_Pesos
		select @Mon_TipCam = 1
	else begin
		exec @Status = SOHISMONCON
			@Mon_Numero,	@Fecha,			@Con_TipCam,	@Mon_TipCam output,	@NumTransac,
			@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,			@SucDestino,
			@Modulo
			
		if @Status <> 0 begin
			rollback
			return 1
		end
	end
	
	update #Tip_Cambio set
		Mon_TipCam		= @Mon_TipCam
		where	Moneda	= @Mon_Numero
	
	fetch MONEDAS into
		@Mon_Numero
end

close MONEDAS
deallocate cursor MONEDAS

drop table #Monedas
