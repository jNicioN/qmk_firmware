create procedure SOANTFECHAB (
	@Fecha		smalldatetime output, 
	@NumDia		int output, 
	@FinSem 	char(1),
	@Salida_Fox char(1))

as

declare @Dias		int, 			/* Declaración de Variables */
		@FechaFin	smalldatetime, 
		@Dia_Contad	int

declare	@Si			char(1),		/* Declaración de Constantes */
		@No			char(1)

/* Asignación de Constantes */
select	@Si			= 'S',			/* string de Si */
		@No			= 'N'			/* string de No */

select	@Dias		= @NumDia,
		@FechaFin	= @Fecha,
		@Dia_Contad = 0

/* Quitarle la Hora a la fecha */
select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @Fecha), @Fecha)), dateadd(mi, -datepart(mi, @Fecha), @Fecha))

if @Dias = 0 begin
	
	if @FinSem = @No and (datepart(dw, @FechaFin) = 1 or datepart(dw, @FechaFin) = 7)
		select	@Dias	= 1

	else if (select	count(*)
			 	from SODIAFES noholdlock
		 		where	Dfe_Fecha	= @FechaFin) > 0
		select	@Dias	= 1
	else
		select	@Dias	= @Dia_Contad
end

while @Dias > @Dia_Contad begin
	
	select	@FechaFin	= dateadd(dd, -1, @FechaFin)
	
	if @FinSem = @Si begin	/* Si toma en cuenta fines de semana */		
		/* Checar que no sea día festivo */
		if (select	count(*)
			 from SODIAFES noholdlock
			 where	Dfe_Fecha	= @FechaFin) = 0 begin
			select	@Dia_Contad	= @Dia_Contad + 1
		end

	end else begin
		/* Checar que no sea día festivo */
		if (select	count(*)
			 from SODIAFES noholdlock
			 where	Dfe_Fecha	= @FechaFin) = 0 and 
	 		datepart(dw, @FechaFin) <> 1 and 
	 		datepart(dw, @FechaFin) <> 7 begin
			select	@Dia_Contad	= @Dia_Contad + 1
		end
	end

end

if @Salida_Fox = @Si
	select	Fecha	= @FechaFin, 
			Dias 	= datediff(dd, @Fecha, @FechaFin)
	
select	@Fecha	= @FechaFin, 
		@NumDia	= datediff(dd, @Fecha, @FechaFin)
