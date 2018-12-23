create procedure SOHISTASCON (
	@Tipo		char(2),
	@Fecha		smalldatetime,
	@Tasa		double precision output,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6), 
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as
/***************************************************************************
 DESCRIPCION: ** Consulta al historico de tasas **
****************************************************************************
 REFERENCIAS: 
****************************************************************************
**					Store CONVERTIDO									**** 
****************************************************************************
** Modificó:	Tania De la Garza  										****
** Fecha:		11 Octubre 2012											****
** Descripción:	se quitó el group by para optimizar y estandarizó		****
** Help Desk:	00444014												****
**				FASE I de Rediseño										**** 
****************************************************************************
** Modificó:		FCHIA          										****
** Fecha:		28/Mar/01												****
** Descripción:	Se quito el Darediff de Hit_Fecha						****
****************************************************************************
** Modificó:		Ricardo Elizondo     								****
** Fecha:		21/Nov/00												****
** Descripción:															****
***************************************************************************/

/* Declaracion de constantes	*/
declare	@Mon_CorCer	smallmoney		

/* Asignacion de constantes	*/
select	@Mon_CorCer	= $0.00				/* Moneda Corta en Cero	*/

select	@Tasa	= @Mon_CorCer

select	@Tasa	= Hit_Valor
	from SOHISTAS noholdlock
	where	Hit_Tasa	= @Tipo
	  and	Hit_Fecha	= ( select max(Hit_Fecha)
								from SOHISTAS noholdlock
								where	Hit_Fecha	<= @Fecha
								  and	Hit_Tasa	 = @Tipo)

if isnull(@Tasa, @Mon_CorCer) = @Mon_CorCer
	select	@Tasa	= @Mon_CorCer

if @@nestlevel = 1
	select	Tasa	= @Tasa
