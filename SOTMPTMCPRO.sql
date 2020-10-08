create procedure SOTMPTMCPRO (
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
    
    
	update SOTIMOAS set
		Tma_Numero  =  tmp.Tmc_Numero,
		Tma_PrPeCo  =  tmp.Tmc_PrPeCo,
		Tma_PrTiMo  =  tmp.Tmc_PrTiMo,
        Tma_Aplica  =  tmp.Tmc_Aplica,
        Tma_Termin  =  tmp.Tmc_Termin,
        Tma_Activo  =  tmp.Tmc_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPTMC tmp
		inner join SOTIMOAS des on tmp.Tmc_Numero = des.Tma_Numero
		where convert(date, tmp.Tmc_FecCon) between @IniMes and @FinMes


	insert into SOTIMOAS(
		Tma_Numero,   Tma_PrPeCo, Tma_PrTiMo, Tma_Aplica, Tma_Termin,
        Tma_Activo,   NumTransac, Transaccio, Usuario,    FechaSis,
        SucOrigen,    SucDestino)
		select  
		tmp.Tmc_Numero,   tmp.Tmc_PrPeCo, tmp.Tmc_PrTiMo, tmp.Tmc_Aplica, tmp.Tmc_Termin,
        tmp.Tmc_Activo,   @NumTransac,    @Transaccio,    @Usuario,       @FechaSis,
        @SucOrigen,       @SucDestino
		from SOTMPTMC tmp noholdlock 
		left join SOTIMOAS des on tmp.Tmc_Numero = des.Tma_Numero
        where des.Tma_Numero is null 
          and convert(date, tmp.Tmc_FecCon) between @IniMes and @FinMes
    
   
commit