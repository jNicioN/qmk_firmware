create procedure SOCADIHACON (
	@Fec_Inicio	smalldatetime,
	@Fec_Final	smalldatetime,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Dia_InhSab	int,		/* Total de Dias Festivos/Asueto que son Sabado */
		@Dia_InhDom	int,		/* Total de Dias Festivos/Asueto que son Domingo */
		@Dia_Sabado	int,		/* Total de Sabados entre las fechas 		*/
		@Dia_Doming	int,		/* Total de Domingos entre las fechas 		*/
		@Dia_Inhabi	int,		/* Total de Dias Festivos/Asueto 		*/
		@Dia_Habile	int,		/* Para Calcular Dias Habiles			*/
		@Dia_Totale	int,		/* Para Calcular Dias Habiles			*/
		@Dat_Fecha	datetime,	/* Para recorrer fechas del rango		*/
		@Ent_Uno	int,
		@Ent_Cero	int,
		@Dia_Uno	int,
		@Dia_Siete	int

select	@Dia_InhSab =	0,
		@Dia_InhDom =	0,	
		@Dia_Sabado =	0,
		@Dia_Doming =	0,
		@Dat_Fecha = 	'1990-01-01',
		@Dia_Inhabi =	0,
		@Dia_Habile =	0,
		@Dia_Totale	= 	0,
		@Ent_Uno	=	1,
		@Ent_Cero	=   0,
		@Dia_Uno	=	1,
		@Dia_Siete	=	7

select Dfe_Fecha, Dfe_Coment
	into #RHDiaFes 
from SODIAFES noholdlock
where 	Dfe_Fecha >= @Fec_Inicio 
  and 	Dfe_Fecha <= @Fec_Final
order by Dfe_Fecha

select @Dia_Inhabi = (select count(Dfe_Fecha) from #RHDiaFes)

if @Dia_Inhabi > @Ent_Cero begin	/* Consultamos la lista para ver cuantos días caen dentro de esa fecha
								y si son Sabado o Domingo */

	select @Dia_InhSab = (select count(Dfe_Fecha) from #RHDiaFes 
			where datepart(dw, Dfe_Fecha) = @Dia_Siete )
	select @Dia_InhDom = (select count(Dfe_Fecha) from #RHDiaFes 
			where datepart(dw, Dfe_Fecha) = @Dia_Uno )
			
end else begin 	/* No hay dias festivos en ese rango */
  	select	@Dia_InhSab =	@Ent_Cero,
			@Dia_InhDom =	@Ent_Cero
  end

select @Dat_Fecha = @Fec_Inicio

select @Dia_Habile = datediff(dd, @Fec_Inicio, @Fec_Final) + @Ent_Uno

while @Dat_Fecha <= @Fec_Final
  begin
	if datepart(dw, @Dat_Fecha) = @Dia_Siete
		select @Dia_Sabado = @Dia_Sabado + @Ent_Uno
	else
		if datepart(dw, @Dat_Fecha) = @Dia_Uno
			select @Dia_Doming = @Dia_Doming + @Ent_Uno
		
		select @Dat_Fecha = dateadd(day, @Ent_Uno, @Dat_Fecha)
  end

/* Dias Totales de Vacaciones MENOS (Sabados y Domingos) MENOS Dias_Festivos que NO sean Sabado o Domingo */
select @Dia_Habile = @Dia_Habile - (@Dia_Sabado + @Dia_Doming) - (@Dia_Inhabi - ( @Dia_InhSab + @Dia_InhDom))

select @Dia_Totale	= datediff(dd, @Fec_Inicio, @Fec_Final) + @Ent_Uno

insert into #Dias
select  @Dia_Totale,	@Dia_Habile,	@Dia_Sabado,	@Dia_Doming,
		@Dia_Inhabi,	@Dia_InhSab,	@Dia_InhDom

drop table #RHDiaFes 

