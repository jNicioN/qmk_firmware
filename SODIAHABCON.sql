create procedure SODIAHABCON (
	@Fecha		smalldatetime output,
	@NumDia		int output,
	@FinSem		char(1),
	@Pais		char(3),
	@Salida_Fox	char(1),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Dias		int, 					/* Declaración de Variables */
		@FechaFin	smalldatetime,
		@DiaBase	int,
		@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Fon_Numero	char(3),
		@Dia_Contad	int,
		@EsDiaHabil	char(1),
		@FechaAux	smalldatetime,
		@salto int

declare	@Si			char(1),				/* Declaración de Constantes */
		@No			char(1),
		@Mexico		char(3),
		@EstUni		char(3),
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Dia_Sabado	int,
		@Dia_Doming	int,
		@Tip_CoSiFo	char(1)

/* Asignación de Constantes */
select	@Si			= 'S',					/* String de Si */
		@No			= 'N',					/* String de No */
		@Mexico		= '001',				/* String para el País México*/
		@EstUni		= '036',				/* String para el País Estados Unidos*/
		@Str_Vacio	= '',					/* String vacío */
		@Ent_Cero	= 0,					/* Entero en cero */
		@Ent_Uno	= 1,					/* Entero en uno */
		@Dia_Sabado	= 7,					/* Número correspondiente al Dia sábado */
		@Dia_Doming	= 1,					/* Número correspondiente al Dia Domingo */
		@Tip_CoSiFo	= '3'					/* Consulta siguiente día hábile ligadas a fondos de inversión  */

select	@Dias		= @NumDia,
		@FechaFin	= @Fecha,
		@Dia_Contad = @Ent_Cero

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/* 'C':  Consulta */
	/*Para dar soporte a las consultas que no sean de fondos de inversión, dejamos el proceso tal cual estaba */
	if @Tip_ConCon = '1' begin				/* Consulta para el Día Siguiente Hábil */
		if not exists (select	Pai_Numero
							from SOPAIS noholdlock
							where	Pai_Numero = @Pais) begin
			select	Err_Codigo = '000001',
					Err_Mensaj = 'El Pais <NO> existe',
					Err_Variab = ''
			rollback
			return 1

	end else begin
		
		/* Checa si el Pais es México */
		if @Pais = @Mexico begin
				/* Quitarle la Hora a la fecha */
			select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @Fecha), @Fecha)), dateadd(mi, -datepart(mi, @Fecha), @Fecha))
			if @Dias = @Ent_Cero begin
				if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
					select	@Dias	= @Ent_Uno
				end else
					if (select	count(*)
						 	from SODIAFES noholdlock
					 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
						select	@Dias	= @Ent_Uno
					end	else begin
						select	@Dias	= @Dia_Contad
					end
			end

			while @Dias > @Dia_Contad begin
				select	@FechaFin	= dateadd(dd, 1, @FechaFin)

				/* Sí toma en cuenta fines de semana */
				if @FinSem = @Si begin
					/* Checar que no sea día festivo */
					if (select	count(*)
							from SODIAFES noholdlock
							where	Dfe_Fecha	= @FechaFin) = @Ent_Cero begin
						select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
					end
				end else begin
						/* Checar que no sea día festivo */
						if (select	count(*)
								from SODIAFES noholdlock
								where Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end
				end
			end
		end	/*END DEL PAIS = MÉXICO*/


		/* Checa si el Pais es Estados Unidos */
		if @Pais = @EstUni begin

			/* Quitarle la Hora a la fecha */
			select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @FechaFin), @FechaFin)), dateadd(mi, -datepart(mi, @FechaFin), @FechaFin))

			if @Dias = @Ent_Cero begin
				if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
					select	@Dias	= @Ent_Uno
				end else
					if (select	count(*)
						 	from SODIAFES noholdlock
					 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
							select	@Dias	= @Ent_Uno
					end	else begin
						if (select count(*)
								from ITDIAFES noholdlock
								where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
								select	@Dias	= @Ent_Uno
						end	else begin
							select	@Dias	= @Dia_Contad
						end
					end
			end

			while @Dias > @Dia_Contad begin
				select	@FechaFin	= dateadd(dd, 1, @FechaFin)
				
				/* Sí toma en cuenta fines de semana */
				if @FinSem = @Si begin
					/* Checar que no sea día inhábil */
					if (select	count(*)
							from SODIAFES noholdlock
							where Dfe_Fecha	= @FechaFin) = @Ent_Cero
							  and datepart(dw, @FechaFin) <> @Dia_Doming
							  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
						select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
					end
				end else begin
					/* Checar que no sea día festivo */
					if (select count(*)
							from SODIAFES noholdlock
							where Dfe_Fecha	= @FechaFin) = @Ent_Cero
							  and datepart(dw, @FechaFin) <> @Dia_Doming
							  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
						if (select count(*)
								from ITDIAFES noholdlock
								where	Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end	
					end
				end
			end
		end /*FIN DEL IF PAIS = EUA*/


		/* Como el Pais no es México ni Estados Unidos, va y checa el Pais que se especificó */
		if @Pais not in (@Mexico, @EstUni) begin

			/* Quitarle la Hora a la fecha */
			select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @FechaFin), @FechaFin)), dateadd(mi, -datepart(mi, @FechaFin), @FechaFin))

			if @Dias = @Ent_Cero begin
				if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
					select	@Dias	= @Ent_Uno
				end else
					if (select	count(*)
						 	from SODIAFES noholdlock
					 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
							select	@Dias	= @Ent_Uno
					end	else begin
						if (select count(*)
								from SODIAINH noholdlock
								where	Din_Fecha	= @FechaFin
							   	  and	Din_Pais	= @Pais) > @Ent_Cero begin
								select	@Dias	= @Ent_Uno
						end	else begin
							select	@Dias	= @Dia_Contad
						end
					end
			end

			while @Dias > @Dia_Contad begin
				select	@FechaFin	= dateadd(dd, 1, @FechaFin)
				
				/* Sí toma en cuenta fines de semana */
				if @FinSem = @Si begin
					/* Checar que no sea día inhábil */
					if (select	count(*)
							from SODIAFES noholdlock
							where Dfe_Fecha	= @FechaFin) = @Ent_Cero 
							  and datepart(dw, @FechaFin) <> @Dia_Doming
							  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
						select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
					end
				end else begin
					/* Checar que no sea día festivo */
					if (select count(*)
							from SODIAFES noholdlock
							where Dfe_Fecha	= @FechaFin) = @Ent_Cero
							  and datepart(dw, @FechaFin) <> @Dia_Doming
							  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
						if (select count(*)
								from SODIAINH noholdlock
								where	Din_Fecha	= @FechaFin
							   	  and	Din_Pais	= @Pais) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end	
					end
				end
			end
		end /*END DEL IF PAIS <> MEXICO NI EUA*/

		if @Salida_Fox = @Si
			select	Fecha	= @FechaFin,
					Dias 	= datediff(dd, @Fecha, @FechaFin)

		select	@Fecha	= @FechaFin,
				@NumDia	= datediff(dd, @Fecha, @FechaFin)

		end

	/* Consulta para el Día Anterior Hábil */
	end else if @Tip_ConCon = '2' begin	
		if not exists (select	Pai_Numero
							from SOPAIS noholdlock
							where	Pai_Numero = @Pais) begin
			select	Err_Codigo = '000002',
					Err_Mensaj = 'El Pais <NO> existe',
					Err_Variab = ''
			rollback
			return 1

		end else begin
		
			/* Checa si el Pais es México */
			if @Pais = @Mexico begin

				/* Quitarle la Hora a la fecha */
				select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @Fecha), @Fecha)), dateadd(mi, -datepart(mi, @Fecha), @Fecha))
				if @Dias = @Ent_Cero begin
					if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
						select	@Dias	= @Ent_Uno
					end else
						if (select	count(*)
							 	from SODIAFES noholdlock
						 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
							select	@Dias	= @Ent_Uno
						end	else begin
							select	@Dias	= @Dia_Contad
						end
				end

				while @Dias > @Dia_Contad begin
					select	@FechaFin	= dateadd(dd, -1, @FechaFin)

					/* Sí toma en cuenta fines de semana */
					if @FinSem = @Si begin
						/* Checar que no sea día festivo */
						if (select	count(*)
								from SODIAFES noholdlock
								where	Dfe_Fecha	= @FechaFin) = @Ent_Cero begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end
					end else begin
							/* Checar que no sea día festivo */
							if (select	count(*)
									from SODIAFES noholdlock
									where Dfe_Fecha	= @FechaFin) = @Ent_Cero
									  and datepart(dw, @FechaFin) <> @Dia_Doming
									  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
								select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
							end
					end
				end
			end	/*END DEL PAIS = MÉXICO*/

			/* Checa si el Pais es Estados Unidos */
			if @Pais = @EstUni begin

				/* Quitarle la Hora a la fecha */
				select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @FechaFin), @FechaFin)), dateadd(mi, -datepart(mi, @FechaFin), @FechaFin))
				if @Dias = @Ent_Cero begin
					if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
						select	@Dias	= @Ent_Uno
					end else
						if (select	count(*)
							 	from SODIAFES noholdlock
						 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
								select	@Dias	= @Ent_Uno
						end	else begin
							if (select	count(*)
								 	from ITDIAFES noholdlock
							 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
									select	@Dias	= @Ent_Uno
							end	else begin
								select	@Dias	= @Dia_Contad
							end
						end
				end

				while @Dias > @Dia_Contad begin
					select	@FechaFin	= dateadd(dd, -1, @FechaFin)

					/* Sí toma en cuenta fines de semana */
					if @FinSem = @Si begin
						/* Checar que no sea día inhábil */
						if (select	count(*)
								from SODIAFES noholdlock
								where Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end
					end else begin
						/* Checar que no sea día festivo */
						if (select count(*)
								from SODIAFES noholdlock
								where Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							if (select count(*)
									from ITDIAFES noholdlock
									where	Dfe_Fecha	= @FechaFin) = @Ent_Cero
									  and datepart(dw, @FechaFin) <> @Dia_Doming
									  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
								select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
							end	
						end
					end
				end
			end /*FIN DEL IF PAIS = EUA*/

			/* Como el Pais no es México ni Estados Unidos, va y checa el Pais que se especificó */
			if @Pais not in (@Mexico, @EstUni) begin

				/* Quitarle la Hora a la fecha */
				select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @FechaFin), @FechaFin)), dateadd(mi, -datepart(mi, @FechaFin), @FechaFin))
				if @Dias = @Ent_Cero begin
					if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
						select	@Dias	= @Ent_Uno
					end else
						if (select	count(*)
							 	from SODIAFES noholdlock
						 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
								select	@Dias	= @Ent_Uno
						end	else begin
							if (select	count(*)
								 	from SODIAINH noholdlock
							 		where	Din_Fecha	= @FechaFin
							 		  and	Din_Pais	= @Pais) > @Ent_Cero begin
									select	@Dias	= @Ent_Uno
							end	else begin
								select	@Dias	= @Dia_Contad
							end
						end
				end

				while @Dias > @Dia_Contad begin
					select	@FechaFin	= dateadd(dd, -1, @FechaFin)
				
					/* Sí toma en cuenta fines de semana */
					if @FinSem = @Si begin
						/* Checar que no sea día inhábil */
						if (select	count(*)
								from SODIAFES noholdlock
								where Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
						end
					end else begin
						/* Checar que no sea día festivo */
						if (select count(*)
								from SODIAFES noholdlock
								where Dfe_Fecha	= @FechaFin) = @Ent_Cero
								  and datepart(dw, @FechaFin) <> @Dia_Doming
								  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
							if (select count(*)
									from SODIAINH noholdlock
									where	Din_Fecha	= @FechaFin
								   	  and	Din_Pais	= @Pais) = @Ent_Cero
									  and datepart(dw, @FechaFin) <> @Dia_Doming
									  and datepart(dw, @FechaFin) <> @Dia_Sabado begin
								select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
							end	
						end
					end
				end
			end /*END DEL IF PAIS <> MEXICO NI EUA*/

			if @Salida_Fox = @Si
				select	Fecha	= @FechaFin,
						Dias 	= datediff(dd, @Fecha, @FechaFin)

			select	@Fecha	= @FechaFin,
					@NumDia	= datediff(dd, @Fecha, @FechaFin)

			end
	/*Consultas multipaises ligadas a Fondos de Inversión*/
	end else if @Tip_ConCon in('3', '4') begin
		select	@Fon_Numero	= @Pais
		select	@Pais	= @Str_Vacio
		
		declare PAISES cursor for
				select Fop_Pais
					from FIFONPAI noholdlock
					where	Fop_Fondo	= @Fon_Numero
			for read only
			
		/*------Validar existencia de todos y cada uno de los países---------------*/
		open PAISES
		fetch PAISES into
			@Pais
		while @@sqlStatus = @Ent_Cero begin
			if not exists (select	Pai_Numero
								from SOPAIS noholdlock
								where	Pai_Numero = @Pais) begin
				select	Err_Codigo = '000001',
					Err_Mensaj = 'El Pais ' + @Pais + ' <NO> existe',
					Err_Variab = ''
				rollback
				return 1
			end
			
			fetch PAISES into
				@Pais
		end
		close PAISES
		
		/*Para definir si consulta dias anteriores o dias siguientes */
		if @Tip_ConCon	= @Tip_CoSiFo		/*Consulta  de días siguientes*/
			select	@DiaBase	= @Ent_Uno
		else 		/*Consulta de días anteriores*/
			select	@DiaBase	= - @Ent_Uno

		/* Quitarle la Hora a la fecha */
		select	@FechaFin	= dateadd(hh, -datepart(hh, dateadd(mi, -datepart(mi, @FechaFin), @FechaFin)), dateadd(mi, -datepart(mi, @FechaFin), @FechaFin))

		/*-------Comenzamos a saltar los días requeridos*------------------*/
		select	@EsDiaHabil	= @Si,
				@salto		= @Ent_Cero
		
		while @Dias >= @Dia_Contad begin

			/*no sumar los días para la primera vuelta, porque se está evaluando la fecha actual*/
			if @salto > @Ent_Cero begin
				select	@FechaFin	= dateadd(dd, @DiaBase, @FechaFin) 
			end

			open PAISES
			fetch PAISES into
				@Pais
			
			while @@sqlstatus = @Ent_Cero begin
				/* Sí no toma en cuenta fines de semana en el cálculo  y la fecha cae en fin de semana,  no contamos el salto*/
				if @FinSem = @No and (datepart(dw, @FechaFin) = @Dia_Doming or datepart(dw, @FechaFin) = @Dia_Sabado) begin
					select	@EsDiaHabil	= @No
					break
				end else begin
					if @Pais = @Mexico begin	/*Checar días inhábiles de méxico*/
						if (select	count(*)
							 	from SODIAFES noholdlock
						 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
							select	@EsDiaHabil	= @No
							break
						end
					end else if @Pais = @EstUni begin	/*Checar días inhábiles de EUA*/
						if (select	count(*)
							 	from ITDIAFES noholdlock
						 		where	Dfe_Fecha	= @FechaFin) > @Ent_Cero begin
							select	@EsDiaHabil	= @No
							break
						end
					end else begin
						if (select count(*) /*Checar días inhábiles de otros paises*/
							from SODIAINH noholdlock
							where	Din_Fecha	= @FechaFin
								  and	Din_Pais	= @Pais) > @Ent_Cero begin
							select	@EsDiaHabil	= @No
							break
						end
					end
				end
				fetch PAISES into
					@Pais
			end/*Fin de while de paises */
			close PAISES
			if @EsDiaHabil	= @Si begin
				select	@Dia_Contad	= @Dia_Contad + @Ent_Uno
			end
			
			select	@EsDiaHabil	= @Si,
					@salto		= @salto + @Ent_Uno
		end/*Fin de while  de dias contados  */

		if @Salida_Fox = @Si
			select	Fecha	= @FechaFin,
					Dias 	= datediff(dd, @Fecha, @FechaFin)
		
		select	@Fecha	= @FechaFin,
			@NumDia	= datediff(dd, @Fecha, @FechaFin)
	
		deallocate cursor PAISES

	end
end

