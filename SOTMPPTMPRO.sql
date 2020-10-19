create procedure SOTMPPTMPRO (
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
	update SOPRPETI set
		Ppt_PrTiMo  =  tmp.Ptm_PrTiMo,
		Ppt_NivEnt  =  tmp.Ptm_NivEnt,
		Ppt_Priori  =  tmp.Ptm_Priori,
        Ppt_Activo  =  tmp.Ptm_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPPTM tmp
		inner join SOPRPETI des on tmp.Ptm_PrTiMo = des.Ppt_PrTiMo
        and tmp.Ptm_NivEnt = des.Ppt_NivEnt
		where convert(date, tmp.Ptm_FecCon) between @IniMes and @FinMes


	insert into SOPRPETI(
		Ppt_PrTiMo,   Ppt_NivEnt, Ppt_Priori,  Ppt_Activo, NumTransac, 
        Transaccio,   Usuario,    FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Ptm_PrTiMo,   tmp.Ptm_NivEnt, tmp.Ptm_Priori,  tmp.Ptm_Activo, @NumTransac,
        @Transaccio,      @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPPTM tmp noholdlock 
		left join SOPRPETI des on tmp.Ptm_PrTiMo = des.Ppt_PrTiMo
        where des.Ppt_PrTiMo is null 
          and convert(date, tmp.Ptm_FecCon) between @IniMes and @FinMes
commit