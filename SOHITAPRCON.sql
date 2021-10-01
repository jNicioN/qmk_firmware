create procedure SOHITAPRCON (
	@Par_FecIni		smalldatetime,
	@Par_FecFin		smalldatetime,
	@Par_Tasa		char(2),
	@Tip_Consul		char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION: Promedio Tasas por fecha								  */	
/***************************************************************************
/** REFERENCIAS: 														  */
****************************************************************************
** Creý:		Luis Eduardo Gonzalez Martinez							****
** Fecha:		13/Septiembre/2021										****
** Help:		1547998													****
***************************************************************************/
	
/* Declaracion de Variables */


	declare	@Fec_Ciclo smalldatetime,
			@Fec_FinSem smalldatetime,
			@Tas_Valor float,
			@Tas_Nombre varchar(50),
			@Sum_Tasas	float,
			@Val_Promed	float,
			@Val_Dias	int,
			@Sum_Dias	int,
			@Val_UltTas	float,
			@Ent_Cero int,
			@Val_Tasa char(2),
			@Str_NE	char(2),
			@Int_Cero int,
			@Int_MenUno int,
			@Ent_Uno	int,
			@Tip_ConTip char(1),
			@Tip_ConCon char(1),
			@Bus_Consul	char(1)
			
		
		
	select	@Fec_Ciclo = @Par_FecIni,
			@Bus_Consul = 'C',
			@Tas_Valor = 0,
			@Sum_Tasas = 0,
			@Val_Promed = 0,
			@Val_Dias = 0,
			@Sum_Dias = 0,
			@Val_UltTas = 0,
			@Str_NE		= 'NE',
			@Int_MenUno = -1,
			@Ent_Uno	= 1,
			@Int_Cero   = 0
			
		
		
		select 	@Tip_ConTip = substring(@Tip_Consul, 1, 1),
				@Tip_ConCon = substring(@Tip_Consul, 2, 1)
		
		if @Par_FecFin < @Par_FecIni begin
		select 	Err_Codigo 	= '000001',
				Err_Mensaj 	= 'La Fecha Final debe de ser mayor a la inicial',
				Err_Foco 	= 'cmdDevolver'
		rollback
		return 1
		end
		
		select top 1 @Val_Tasa =  Hit_Tasa 
			from SOHISTAS 
		where  Hit_Tasa = @Par_Tasa
		
		select @Val_Tasa = isnull(@Val_Tasa,@Str_NE)
			
		if @Val_Tasa = @Str_NE begin
			select 	Err_Codigo 	= '000002',
					Err_Mensaj 	= 'La tasa esta incorrecta'
				rollback
				return 1
			end
		
		create table #TasasFecha (
			Tmp_NomTas	varchar(50),
			Tmp_Fecha	smalldatetime,
			Tmp_ValTas	float,
			Tmp_Suma	float
		)
		
		
		select @Tas_Nombre = Tas_Descri
		from SOTASAS noholdlock
		where  Tas_Numero = @Par_Tasa
		
		while @Fec_Ciclo <= @Par_FecFin begin
			
			select	@Fec_FinSem = @Fec_Ciclo
											
					select @Tas_Valor = isnull(Hit_Valor, @Int_Cero)
					 FROM SOHISTAS noholdlock 
					 where  Hit_Fecha = @Fec_FinSem 
					 and Hit_Tasa = @Par_Tasa
									
					select @Tas_Valor = isnull(@Tas_Valor, @Int_Cero)
							
							if @Tas_Valor = @Int_Cero begin
									
								select top 1 @Tas_Valor = (Hit_Valor) 
									from SOHISTAS 
									where Hit_Tasa = @Par_Tasa 
									and Hit_Fecha <= @Fec_FinSem
									order by Hit_Fecha desc
						
									select @Tas_Valor = isnull(@Tas_Valor, @Int_Cero)
								
							end
									


							if @Tas_Valor <> @Int_Cero begin 
								
								select @Val_UltTas = round(@Tas_Valor,4)
								select @Sum_Tasas = @Sum_Tasas + @Tas_Valor
							
							end
							
							if @Tas_Valor = @Int_Cero begin
								
								select @Tas_Valor = @Val_UltTas 
								select @Sum_Tasas = @Sum_Tasas + @Tas_Valor
								
							end

												
								select @Fec_FinSem = DATEADD(dd,@Int_MenUno,@Fec_FinSem)

			
					insert into #TasasFecha values (@Tas_Nombre, @Fec_Ciclo, @Tas_Valor, @Sum_Tasas)
			
				
					select @Fec_Ciclo = DATEADD(dd,+1,@Fec_Ciclo), @Tas_Valor = @Int_Cero		
		end
		
				
		select @Val_Dias = datediff(day, @Par_FecIni,@Par_FecFin) + @Ent_Uno
		
		select @Val_Promed = @Sum_Tasas / @Val_Dias
				
	if @Tip_ConTip = @Bus_Consul begin  	/* 'C' = Consulta */
		if @Tip_ConCon = '1' begin	/* Consulta General */
			
			select Tmp_NomTas, Tmp_Fecha, Tmp_ValTas, Tmp_Suma from #TasasFecha 
		
			select  @Val_Promed Promedio
		
		end else begin 
		
			select Tmp_NomTas, Tmp_Fecha, Tmp_ValTas, Tmp_Suma from #TasasFecha
			 
		end
	end else begin	 /* 'L' = Lista */
		
			select Tmp_NomTas, Tmp_Fecha, Tmp_ValTas, Tmp_Suma from #TasasFecha
	end
	
		
		
