create procedure SOTMPATCPRO (
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
	update SODAADTI set
		Dat_TipMov  =  tmp.Atc_TipMov,
		Dat_Modulo  =  tmp.Atc_Modulo,
		Dat_ApCoPe  =  tmp.Atc_ApCoPe,
        Dat_TiCaMo  =  tmp.Atc_TiCaMo,
        Dat_PeApTi  =  tmp.Atc_PeApTi,
        Dat_Proces  =  tmp.Atc_Proces,
        Dat_StoPro  =  tmp.Atc_StoPro,
        Dat_Activo  =  tmp.Atc_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPATC tmp
		inner join SODAADTI des on tmp.Atc_TipMov = des.Dat_TipMov
		where convert(date, tmp.Atc_FecCon) between @IniMes and @FinMes


	insert into SODAADTI(
		Dat_TipMov,   Dat_Modulo, Dat_ApCoPe, Dat_TiCaMo, Dat_PeApTi, 
        Dat_Proces,   Dat_StoPro, Dat_Activo, NumTransac, Transaccio,
        Usuario,      FechaSis,     SucOrigen,  SucDestino)
		select  
		tmp.Atc_TipMov,   tmp.Atc_Modulo, tmp.Atc_ApCoPe, tmp.Atc_TiCaMo, tmp.Atc_PeApTi,
        tmp.Atc_Proces,   tmp.Atc_StoPro, tmp.Atc_Activo,     @NumTransac,    @Transaccio,    
        @Usuario,         @FechaSis,        @SucOrigen,     @SucDestino
		from SOTMPATC tmp noholdlock 
		left join SODAADTI des on tmp.Atc_TipMov = des.Dat_TipMov
        where des.Dat_TipMov is null 
          and convert(date, tmp.Atc_FecCon) between @IniMes and @FinMes
commit