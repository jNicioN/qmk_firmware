create procedure SOTMPPTCPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Migracion de la Información de Comisiones            ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		CODE4U Jonathan Perez Tiburcio                      ****
** Fecha:		    11/01/2020									        ****
** Help:			1286068  									        ****
** Descripción:	    Procedimiento de Sincronizacion.                    ****
****************************************************************************/

										/* Declaración de variables */
declare	@Par_FecAct	smalldatetime,
		@IniMes		smalldatetime,
		@FinMes		smalldatetime

declare	@Str_Vacio	char(1),			/* Declaración de constantes */
		@Suc_Princi char(3)

										/* Asignación de constantes */
select  @Str_Vacio  = '',       		/* String vacio */
        @Suc_Princi = '001'     		/* Sucursal para consultar la fecha del sistema */


/*Consulta de fecha del sistema */
select	@Par_FecAct	= Par_FecAct
	from SOPARAMS noholdlock
	where	Par_Sucurs	= @SucOrigen

/*Fecha de inicio y fin de mes*/
select @IniMes	= dateadd(dd, 1 - datepart(dd, @Par_FecAct), @Par_FecAct)
select @FinMes	= dateadd(dd, -1, dateadd(mm,  1, @IniMes))

begin transaction
	update SOPRTICU set
		Ptc_TipCue  =  tmp.Ptc_TipCue,
		Ptc_Moneda  =  tmp.Ptc_Moneda,
		Ptc_Produc  =  tmp.Ptc_Produc,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPPTC tmp
		inner join SOPRTICU des on tmp.Ptc_TipCue = des.Ptc_TipCue
        and tmp.Ptc_Moneda = des.Ptc_Moneda
		where convert(date, tmp.Ptc_FecCon) between @IniMes and @FinMes


	insert into SOPRTICU(
		Ptc_TipCue,   Ptc_Moneda, Ptc_Produc, NumTransac,   Transaccio, 
        Usuario,      FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Ptc_TipCue,   tmp.Ptc_Moneda, tmp.Ptc_Produc, @NumTransac,    @Transaccio,
        @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPPTC tmp noholdlock 
		left join SOPRTICU des on tmp.Ptc_TipCue = des.Ptc_TipCue
        and tmp.Ptc_Moneda = des.Ptc_Moneda
		where des.Ptc_TipCue is null 
          and des.Ptc_Moneda is null
		  and convert(date, tmp.Ptc_FecCon) between @IniMes and @FinMes
commit