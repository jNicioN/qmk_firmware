CREATE PROCEDURE SOFECVACCON(
	@Vac_FecIni	smalldatetime,
	@Vac_FecFin	smalldatetime
)	

AS

declare	@Dfe_CntSab	int,		/* Total de Dias Festivos/Asueto que son Sabado */
	@Dfe_CntDom	int,		/* Total de Dias Festivos/Asueto que son Domingo */
	@Vac_CntSab	int,		/* Total de Sabados entre las fechas 		*/
	@Vac_CntDom	int,		/* Total de Domingos entre las fechas 		*/
	@Dfe_Fecha	datetime,	/* Para recorrer fechas del rango		*/
	@Dfe_NumDia	int,		/* Total de Dias Festivos/Asueto 		*/
	@Vac_NumDia	int		/* Para Calcular Dias Habiles			*/


select	@Dfe_CntSab =	0,
	@Dfe_CntDom =	0,	
	@Vac_CntSab =	0,
	@Vac_CntDom =	0,
	@Dfe_Fecha = 	'1990-01-01',
	@Dfe_NumDia =	0,
	@Vac_NumDia =	0


select Dfe_Fecha, Dfe_Coment
	into #RHDiaFes 
from SODIAFES noholdlock
where 	Dfe_Fecha >= @Vac_FecIni and 
	Dfe_Fecha <= @Vac_FecFin
order by Dfe_Fecha

select @Dfe_NumDia = (select count(Dfe_Fecha) from #RHDiaFes)


if @Dfe_NumDia > 0 
  begin	
	/* Consultamos la lista para ver cuantos días caen dentro de esa fecha
	y si son Sabado o Domingo */

	select @Dfe_CntSab = (select count(Dfe_Fecha) from #RHDiaFes 
			where datepart(dw, Dfe_Fecha) = 7 )
	select @Dfe_CntDom = (select count(Dfe_Fecha) from #RHDiaFes 
			where datepart(dw, Dfe_Fecha) = 1 )
  end
else 	/* No hay dias festivos en ese rango */
  begin
	select	@Dfe_CntSab =	0,
		@Dfe_CntDom =	0
  end

select @Dfe_Fecha = @Vac_FecIni

select @Vac_NumDia = datediff(dd, @Vac_FecIni, @Vac_FecFin) +1

while @Dfe_Fecha <= @Vac_FecFin
  begin
	if datepart(dw, @Dfe_Fecha) = 7
		select @Vac_CntSab = @Vac_CntSab + 1
	else
	  if datepart(dw, @Dfe_Fecha) = 1
		select @Vac_CntDom = @Vac_CntDom + 1	
		

	select @Dfe_Fecha = dateadd(day, 1, @Dfe_Fecha)
  end

/* Dias Totales de Vacaciones MENOS (Sabados y Domingos) MENOS Dias_Festivos que NO sean Sabado o Domingo */
select @Vac_NumDia = @Vac_NumDia - (@Vac_CntSab + @Vac_CntDom) - (@Dfe_NumDia - ( @Dfe_CntSab + @Dfe_CntDom))

select  datediff(dd, @Vac_FecIni, @Vac_FecFin) +1 as Vac_DiaTot,
	@Vac_NumDia as Vac_DiaHab, @Vac_CntSab as Vac_CntSab, @Vac_CntDom as Vac_CntDom,
	@Dfe_NumDia as Dfe_NumDia, @Dfe_CntSab as Dfe_CntSab, @Dfe_CntDom as Dfe_CntDom

/*  Regreso:
	@Vac_DiaTot - Total de Numero de Dias Calendario,
	@Vac_DiaHab - Total de Dias Habiles 
	@Vac_CntSab - Total de Sabados
	@Vac_CntDom - Total de Domingos
	@Dfe_NumDia - Total de Dias Festivos/Asueto
	@Dfe_CntSab - Total de Dias Festivos/Asueto que son Sabado
	@Dfe_CntDom - Total de Dias Festivos/Asueto que son Domingo	
*/

drop table #RHDiaFes 


