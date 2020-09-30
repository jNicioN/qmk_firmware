create procedure SOTMPELCPRO (
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
	
    
    update SOELTICA set
		Etc_Numero  =  tmp.Elc_Numero,
		Etc_TiMoAs  =  tmp.Elc_TiMoAs,
		Etc_ElTiMo  =  tmp.Elc_ElTiMo,
        Etc_Valor   =  tmp.Elc_Valor,
        Etc_Activo  =  tmp.Elc_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPELC tmp
		inner join SOELTICA des on tmp.Elc_Numero = des.Etc_Numero
		where convert(date, tmp.Elc_FecCon) between @IniMes and @FinMes


	insert into SOELTICA(
		Etc_Numero,   Etc_TiMoAs, Etc_ElTiMo, Etc_Valor,  Etc_Activo,
        NumTransac,   Transaccio, Usuario,    FechaSis,   SucOrigen,
        SucDestino)
		select  
		tmp.Elc_Numero,   tmp.Elc_TiMoAs, tmp.Elc_ElTiMo, tmp.Elc_Valor,  tmp.Elc_Activo,
        @NumTransac,      @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,
        @SucDestino
		from SOTMPELC tmp noholdlock 
		left join SOELTICA des on tmp.Elc_Numero = des.Etc_Numero
        where des.Etc_Numero is null 
          and convert(date, tmp.Elc_FecCon) between @IniMes and @FinMes
          

commit

