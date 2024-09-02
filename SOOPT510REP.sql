create procedure SOOPT510REP (
	@Rep_Fecha	smalldatetime,
	@Rep_FecIni	smalldatetime,
	@Rep_FecFin	smalldatetime,
	@Rep_TipRep	char(1),
	
	@NumTransac	char(10),  	
	@Transaccio	char(3), 	
	@Usuario	char(6), 	
	@FechaSis	smalldatetime, 	
	@SucOrigen	char(3), 	
	@SucDestino	char(3),	
	@Modulo		char(2))

as

/***************************************************************************/
 /* DESCRIPCION: Reporte de Operaciones con Tarjeta 510
				 Extracción de información para la generación de reporte 
				 de Operaciones con Tarjeta 510 */
/***************************************************************************
** Creó: Diego Calvillo ****
** Fecha: 20/Ago/24 ****
****************************************************************************/


-- declaración de variables
declare	@Des_Banco	char(8),
		@Fec_SemAnt smalldatetime,
		@Tot_NoApli int,
		@Mon_Anteri	double precision,
		@Mon_Actual	double precision,
		@Con_Contad int,	
		@Num_Regist int

-- declaración de constantes
declare	@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Str_Pesos	char(3),
		@Str_Dolar	char(3),
		@Tip_TarTDC	char(3),
		@Str_TarTDC	char(7),
		@Tip_TarTDD	char(3),
		@Str_TarTDD	char(7),
		@Str_Otras	char(7),
		@Fec_Vacia	smalldatetime,
        @Par_BanAct varchar(50),
		@Mon_Cero	money,
		@Des_Banreg char(8),
		@Des_Hey	char(3),
		@Mon_Pesos	char(2),
		@Mon_Dlls	char(2),
		@Sta_NoApli char(1), 
		@Sta_Apli char(1), 
		@Str_Tres	char(1),
		@Str_Cuatro char(1),
		@Str_Cinco char(1)

		
select	@Str_Uno	= '1',				-- Reporte: Totale de Transacciones por Dia y semana anterior
		@Str_Dos	= '2',
		@Str_Pesos	= 'MXN',
		@Str_Dolar	= 'USD',
		@Tip_TarTDC	= 'TDC',
		@Str_TarTDC	= 'Credito',
		@Tip_TarTDD	= 'TDD',
		@Str_TarTDD	= 'Debito',
		@Str_Otras	= 'OTRAS',
		@Fec_Vacia	= '1900-01-01',
		@Par_BanAct = 'BancoActual',               /*Banco Actual 1-HEY, 2-Banregio*/
		@Mon_Cero	= 0.00,
		@Des_Banreg = 'Banregio',
		@Des_Hey	= 'Hey',
		@Mon_Pesos	= '01',
		@Mon_Dlls	= '02',
		@Sta_NoApli	='N',
		@Sta_Apli	='A',
		@Str_Tres	= '3',
		@Str_Cuatro = '4',
		@Str_Cinco = '5'

		
select  @Des_Banco = case when cast(Par_Valor as int) =  1 then @Des_Hey else @Des_Banreg end
from    SOPARGEN noholdlock
where   Par_Nombre = @Par_BanAct
	
-- Total de Transacciones por Dia, TDD, TDC, Pesos, Dólares, Otras Moneda, 
-- del día que se solicite y semana anterior del mismo día

select @Fec_SemAnt = dateadd(wk, -1,@Rep_Fecha) 

if @Rep_TipRep	= @Str_Uno begin

	select	Con_FecApl, 
			Con_Tarjet,
			Con_Status,
			Con_Moneda = space(2),
			Con_Cantid
		into #Tnx
		from CTHISCON noholdlock 
			where	Con_FecApl	in(@Fec_SemAnt, @Rep_Fecha)
			
	create index #Tnx on #Tnx(Con_Tarjet)
	
	update #Tnx set 
	Con_Moneda = TaP_Moneda
	from CTTARPRO noholdlock,
		 #Tnx
	where TaP_Tarjet = Con_Tarjet
	  and TaP_Cuenta <> '' 
	
	select	Con_FecApl, 
			Con_Banco = @Des_Banco,
			Con_Tipo = @Str_TarTDD,
			Con_Moneda = case 	when Con_Moneda = @Mon_Pesos then @Str_Pesos	
								when Con_Moneda = @Mon_Dlls	then @Str_Dolar	
								else 'NA' end,  /* por mientras si hay alguna que no haga match de moneda */
			Con_Operac	= case when Con_FecApl = @Rep_Fecha then count(1) else 0 end,
			Con_Cantid	= case when Con_FecApl = @Rep_Fecha then sum(Con_Cantid) else 0 end,
			Con_OpSeAn	= case when Con_FecApl = @Fec_SemAnt then count(1) else 0 end,
			Con_CaSeAn	= case when Con_FecApl = @Fec_SemAnt then sum(Con_Cantid) else 0 end
			into #Totales
		from #Tnx noholdlock 
			group by Con_FecApl, Con_Moneda
	
	select	Act.Con_FecApl, 
			Act.Con_Banco,
			Act.Con_Tipo,
			Act.Con_Moneda,
			Act.Con_Operac,
			Act.Con_Cantid,
			Ant.Con_OpSeAn,
			Ant. Con_CaSeAn
		from #Totales Act noholdlock,
			#Totales Ant noholdlock 
		where Act.Con_Banco = Ant.Con_Banco
		  and Act.Con_Tipo = Ant.Con_Tipo
		  and Act.Con_Moneda = Ant.Con_Moneda
		  and Act.Con_FecApl = @Rep_Fecha
		  and Ant.Con_FecApl = @Fec_SemAnt
		  
	drop table #Tnx, #Totales
	
end

if @Rep_TipRep	in (@Str_Dos, @Str_Tres, @Str_Cuatro, @Str_Cinco)  begin
	
	if @Rep_FecIni = @Fec_Vacia or @Rep_FecFin = @Fec_Vacia begin 
		select	Err_Codigo = '000001',
				Err_Mensaj = 'las fechas no pueden ser vacias'
	end
	
		
	create table #MotivosDev (
		Mot_Identi char(2) not null,
		Mot_Descri varchar(250) not null
	)
	
	insert into #MotivosDev 
	select '01', 'No existe la autorizacion' union
	select '02', 'No se puede realizar la devolucion porque la venta no ha sido confirmada' union
 	select '12', 'No se puede realizar la devolucion porque la tarjeta no corresponde con la registrada en linea' union
	select '03', 'El monto de la devolucion es mayor a la venta' union
	select '04', 'No existe la autorizacion' union
	select '05', 'La operacion ya fue aplicada' union
	select '06', 'No se puede realizar la devolucion porque la venta no ha sido confirmada' union
	select '07', 'Transacción no valida para nuestro BIN' union
	select '08', 'La tarjeta no corresponde con la registrada en linea' union
	select '09', 'El monto de la devolucion es mayor a la venta' union
	select '13', 'No se puede realizar la venta, porque la transaccion fue Reversada' union
	select '11', 'Tipo de cambio FIX no encontrado' union
	select '10', 'Tipo de cambio no encontrado Moneda extranjera' 
	
	create table #TnxNoApl (
		Con_FecApl	smalldatetime, 
		Con_Tarjet	char(16),
		Con_Moneda 	char(2),
		Con_MonCon	char(3),
		Con_Cantid	money,
		Con_TipCam	money, 
		Con_Pesos 	money,
		Con_MotDev	char(2),
		Con_DesMot 	varchar(100)
	)
		insert into #TnxNoApl
		select	Con_FecApl, 
				Con_Tarjet,
				'',
				Con_MonCon,
				Con_Cantid,
				Con_TipCam, 
				Con_Cantid,
				Con_MotDev,
				''
			from CTHISCON noholdlock 
				where Con_FecApl between @Rep_FecIni and @Rep_FecFin
				  and Con_Status = case when @Rep_TipRep = @Str_Dos then @Sta_NoApli 
				  						when @Rep_TipRep = @Str_Cinco then @Sta_Apli 
				  						else @Sta_NoApli end
				  
		create index #TnxNoApl on #TnxNoApl (Con_Tarjet)
		
		update #TnxNoApl set 
		Con_Moneda = TaP_Moneda
		from CTTARPRO noholdlock,
			 #TnxNoApl
		where TaP_Tarjet = Con_Tarjet
		  and TaP_Cuenta <> '' 
		  
		  update #TnxNoApl set 
			Con_Pesos = Con_Cantid * Con_TipCam
			where Con_Moneda = 	@Mon_Dlls
		
		 update #TnxNoApl set 
			Con_DesMot = Mot_Descri
			from #MotivosDev 
			where Con_MotDev = 	Mot_Identi
		
	if @Rep_TipRep in(@Str_Dos, @Str_Cinco)  begin	
		
		select Con_FecApl, Con_Banco = @Des_Banco, Con_Total =  sum(Con_Pesos)
		from #TnxNoApl 
		group by Con_FecApl
		order by Con_FecApl
		
	end
	
	if @Rep_TipRep = @Str_Tres begin	
		
		select @Tot_NoApli = count(*)
			from #TnxNoApl 
			
		
		create table #totales (
			Con_DesMot 	varchar(100),
			Con_CanOpe	double precision,
			Con_Total	double precision			
		)

		insert into #totales
		select Con_DesMot, Con_CanOpe = count(*), Con_Total = @Tot_NoApli
		from #TnxNoApl 
		group by Con_DesMot
		order by Con_DesMot
		
		select Con_Banco = @Des_Banco, Con_DesMot, Con_Total = round(Con_Total,2) , Con_CanOpe, Con_Porcen = round((Con_CanOpe/Con_Total) * 100, 2)
		from #totales 

		
		
	end
	
	if @Rep_TipRep = @Str_Cuatro begin	
		
		create table #variacion (
			Con_Identi	int identity,
			Con_FecApl 	smalldatetime,
			Con_Banco	char(10),
			Con_Total	double precision,
			Con_Variac	double precision
		)

		insert into #variacion 
		select Con_FecApl, Con_Banco = @Des_Banco, Con_Total = sum(Con_Pesos), Con_Variac = 0.00
		from #TnxNoApl 
		group by Con_FecApl
		order by Con_FecApl
		
		select @Con_Contad = 1
		--Se contabilizan los registros restantes para while
		select @Num_Regist = max(Con_Identi)
			from #variacion noholdlock
			
		while @Con_Contad <= @Num_Regist begin
		
			if @Con_Contad = 1 begin
				select @Mon_Anteri = Con_Total
					from  #variacion
					where Con_Identi = 1
			end else begin
				select @Mon_Actual = Con_Total
					from  #variacion
					where Con_Identi = @Con_Contad
					
				update #variacion set
				Con_Variac =  ((@Mon_Actual-@Mon_Anteri)/@Mon_Anteri) * 100 
				where Con_Identi = @Con_Contad
				
				select @Mon_Anteri = @Mon_Actual
			end

			select @Con_Contad = @Con_Contad + 1

		end
	
		select  Con_FecApl, Con_Banco , Con_Total = round(Con_Total,2) , Con_Variac = round(Con_Variac,2)
			from #variacion
		order by Con_Identi
			
		drop table #MotivosDev, #TnxNoApl 
		
		
	
	end

end