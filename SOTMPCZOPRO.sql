create procedure SOTMPCZOPRO (
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
	update SOCOTIZO set
		Ctz_CoTiMo  =  tmp.Czo_CoTiMo,
		Ctz_Zonas   =  tmp.Czo_Zonas,
		Ctz_Activo  =  tmp.Czo_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPCZO tmp
		inner join SOCOTIZO des on tmp.Czo_CoTiMo = des.Ctz_CoTiMo
		where convert(date, tmp.Czo_FecCon) between @IniMes and @FinMes


	insert into SOCOTIZO(
		Ctz_CoTiMo,   Ctz_Zonas,  Ctz_Activo, NumTransac, Transaccio,   
        Usuario,      FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Czo_CoTiMo,   tmp.Czo_Zonas,  tmp.Czo_Activo, @NumTransac,    @Transaccio,
        @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPCZO tmp noholdlock 
		left join SOCOTIZO des on tmp.Czo_CoTiMo = des.Ctz_CoTiMo
        where des.Ctz_CoTiMo is null 
          and convert(date, tmp.Czo_FecCon) between @IniMes and @FinMes
commit