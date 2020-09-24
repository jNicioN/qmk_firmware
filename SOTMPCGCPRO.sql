create procedure SOTMPCGCPRO (
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
	update SOCOTIGR set
		Ctg_CoTiMo  =  tmp.Cgc_CoTiMo,
		Ctg_Grupos  =  tmp.Cgc_Grupos,
		Ctg_Activo  =  tmp.Cgc_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPCGC tmp
		inner join SOCOTIGR des on tmp.Cgc_CoTiMo = des.Ctg_CoTiMo
		where convert(date, tmp.Cgc_FecCon) between @IniMes and @FinMes


	insert into SOCOTIGR(
		Ctg_CoTiMo,   Ctg_Grupos,  Ctg_Activo, NumTransac, Transaccio,   
        Usuario,      FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Cgc_CoTiMo,   tmp.Cgc_Grupos, tmp.Cgc_Activo, @NumTransac,    @Transaccio,
        @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPCGC tmp noholdlock 
		left join SOCOTIGR des on tmp.Cgc_CoTiMo = des.Ctg_CoTiMo
        where des.Ctg_CoTiMo is null 
          and convert(date, tmp.Cgc_FecCon) between @IniMes and @FinMes
commit