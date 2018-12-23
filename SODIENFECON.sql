create procedure SODIENFECON (
	@Vac_FecIni	smalldatetime,
	@Vac_FecFin	smalldatetime,
	
	@Vac_DiaTot int output,
	@Vac_DiaHab int output,
	@Vac_ConSab int output,
	@Vac_ConDom int output,
	@Dif_NumDia int output,
	@Dif_ConSab int output,
	@Dif_ConDom	int output,
	
    @NumTransac char(10),
    @Transaccio char(3),
    @Usuario    char(6),
    @FechaSis   smalldatetime,
    @SucOrigen  char(3),
    @SucDestino char(3),
	@Modulo char(2)
)

as

/**
********************************************************************
** Descripcion : Alta de Solicitud de Clientes por Promotor		****
********************************************************************
** Referencias:	                                                ****
********************************************************************
** creó:     Víctor Manuel vázquez García						****
** Fecha:    01/07/2015											****
** Help:	 00754177											****
*******************************************************************/


declare	@Dfe_CntSab	int,	/* Total de Dias Festivos/Asueto que son Sabado */
	@Dfe_CntDom	int,		/* Total de Dias Festivos/Asueto que son Domingo */
	@Vac_CntSab	int,		/* Total de Sabados entre las fechas 		*/
	@Vac_CntDom	int,		/* Total de Domingos entre las fechas 		*/
	@Dfe_Fecha	datetime,	/* Para recorrer fechas del rango		*/
	@Dfe_NumDia	int,		/* Total de Dias Festivos/Asueto 		*/
	@Vac_NumDia	int			/* Para Calcular Dias Habiles			*/


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

select  @Vac_DiaTot = datediff(dd, @Vac_FecIni, @Vac_FecFin) +1,
	@Vac_DiaHab = @Vac_NumDia, @Vac_ConSab = @Vac_CntSab, @Vac_ConDom = @Vac_CntDom,
	@Dif_NumDia = @Dfe_NumDia, @Dif_ConSab = @Dfe_CntSab, @Dif_ConDom = @Dfe_CntDom

/*  Regreso:
	@Vac_DiaTot - Total de Numero de Dias Calendario,
	@Vac_DiaHab - Total de Dias Habiles 
	@Vac_ConSab - Total de Sabados
	@Vac_ConDom - Total de Domingos
	@Dif_NumDia - Total de Dias Festivos/Asueto
	@Dif_CntSab - Total de Dias Festivos/Asueto que son Sabado
	@Dif_CntDom - Total de Dias Festivos/Asueto que son Domingo	
*/

drop table #RHDiaFes
