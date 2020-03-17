create procedure SOTMPCTMPRO (
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
	update SOCOTIMO set
		Ctm_Numero  =  tmp.Ctm_Numero,
		Ctm_NivEnt  =  tmp.Ctm_NivEnt,
		Ctm_Descri  =  tmp.Ctm_Descri,
        Ctm_Vigenc  =  tmp.Ctm_Vigenc,
        Ctm_Activo  =  tmp.Ctm_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPCTM tmp
		inner join SOCOTIMO des on tmp.Ctm_Numero = des.Ctm_Numero
		where convert(date, tmp.Ctm_FecCon) between @IniMes and @FinMes


	insert into SOCOTIMO(
		Ctm_Numero,   Ctm_NivEnt, Ctm_Descri, Ctm_Vigenc, Ctm_Activo,
        NumTransac,   Transaccio, Usuario,    FechaSis,   SucOrigen,
        SucDestino)
		select  
		tmp.Ctm_Numero,   tmp.Ctm_NivEnt, tmp.Ctm_Descri, tmp.Ctm_Vigenc, tmp.Ctm_Activo,
        @NumTransac,      @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,
        @SucDestino
		from SOTMPCTM tmp noholdlock 
		left join SOCOTIMO des on tmp.Ctm_Numero = des.Ctm_Numero
        where des.Ctm_Numero is null 
          and convert(date, tmp.Ctm_FecCon) between @IniMes and @FinMes
commit