create procedure SOTMPCCLPRO (
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
	update SOCOTICL set
		Ctc_CoTiMo  =  tmp.Ccl_CoTiMo,
		Ctc_Client  =  tmp.Ccl_Client,
		Ctc_Activo  =  tmp.Ccl_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPCCL tmp
		inner join SOCOTICL des on tmp.Ccl_CoTiMo = des.Ctc_CoTiMo
		where convert(date, tmp.Ccl_FecCon) between @IniMes and @FinMes


	insert into SOCOTICL(
		Ctc_CoTiMo,   Ctc_Client,  Ctc_Activo, NumTransac, Transaccio,   
        Usuario,      FechaSis,    SucOrigen,  SucDestino)
		select  
		tmp.Ccl_CoTiMo,   tmp.Ccl_Client, tmp.Ccl_Activo, @NumTransac,    @Transaccio,
        @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPCCL tmp noholdlock 
		left join SOCOTICL des on tmp.Ccl_CoTiMo = des.Ctc_CoTiMo
        where des.Ctc_CoTiMo is null 
          and convert(date, tmp.Ccl_FecCon) between @IniMes and @FinMes
commit