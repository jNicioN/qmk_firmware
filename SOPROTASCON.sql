create procedure SOPROTASCON (
	@FechaIni	smalldatetime,
	@FechaFin	smalldatetime,
	@Hit_Tasa	char(2),
	@Promedio	smallmoney output,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/***************************************************************************
 DESCRIPCION: 	** Promedio de Tasas, para 2 fechas **
****************************************************************************
 REFERENCIAS: 
****************************************************************************
**						STORE CONVERTIDO								****
** Modificó:	Tania De la Garza										****
** Fecha:		28/Junio/2014											****
** Help:		668612													****
** Descripción:	se agregan noholdlocks									****
****************************************************************************
** 				No se encontraron referencias anteriores				****
***************************************************************************/

declare @Dias		int,
		@Total		money,
		@FecIniRea	smalldatetime,
		@Hit_Fecha	smalldatetime,
		@Hit_Valor	smallmoney,
		@Hit_FecAnt	smalldatetime,
		@Hit_ValAnt	smallmoney

select	@Dias		= datediff(day, @FechaIni, @FechaFin) + 1,
		@Total		= 0

if @Dias <= 0
	select	@Dias		= 1,
			@FechaFin	= @FechaIni

select	@FecIniRea	= Hit_Fecha
	from SOHISTAS noholdlock
	where	Hit_Tasa	=  @Hit_Tasa and
			Hit_Fecha	= (select max(Hit_Fecha)
							from SOHISTAS noholdlock
							where	Hit_Tasa	= @Hit_Tasa
							  and	Hit_Fecha	<= @FechaIni)

declare TASAS cursor for
	select	Hit_Fecha
	from SOHISTAS noholdlock
	where	Hit_Tasa	=  @Hit_Tasa	and
			Hit_Fecha	>  @FechaIni	and
			Hit_Fecha	<= @FechaFin
	order by Hit_Fecha

select	@Hit_FecAnt	= @FechaIni

select	@Hit_ValAnt	= Hit_Valor
	from SOHISTAS noholdlock
	where	Hit_Tasa	= @Hit_Tasa		and
			Hit_Fecha	= @FecIniRea

select	@Hit_ValAnt	= isnull(@Hit_ValAnt, 0)

open TASAS

fetch TASAS into
	@Hit_Fecha

while @@sqlstatus = 0 begin
	
	select	@Total	= @Total + (datediff(dd, @Hit_FecAnt, @Hit_Fecha) * @Hit_ValAnt)
	
	select	@Hit_FecAnt	= @Hit_Fecha
	
	select	@Hit_ValAnt	= Hit_Valor
		from SOHISTAS noholdlock
		where	Hit_Tasa	= @Hit_Tasa		and
				Hit_Fecha	= @Hit_FecAnt
	
	select	@Hit_ValAnt	= isnull(@Hit_ValAnt, 0)
	
	fetch TASAS into
		@Hit_Fecha
end

select	@Hit_Fecha	= dateadd(dd, 1, @FechaFin)
select	@Total		= @Total + (datediff(dd, @Hit_FecAnt, @Hit_Fecha) * @Hit_ValAnt)

close TASAS
deallocate cursor TASAS

select	@Promedio	= round(@Total / @Dias, 2)
