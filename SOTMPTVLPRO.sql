create procedure SOTMPTVLPRO (
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
	update SOTIVAEL set
		Tve_Numero  =  tmp.Tvl_Numero,
		Tve_Nombre  =  tmp.Tvl_Nombre,
		Tve_Abrevi  =  tmp.Tvl_Abrevi,
        Tve_EsEnt   =  tmp.Tvl_EsEnt,
        Tve_EsMon   =  tmp.Tvl_EsMon,
        Tve_EsDec   =  tmp.Tvl_EsDec,
        Tve_Logico  =  tmp.Tvl_Logico,
        Tve_Activo  =  tmp.Tvl_Activo,
        Tve_EsFech	=  tmp.Tvl_EsFech,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPTVL tmp
		inner join SOTIVAEL des on tmp.Tvl_Numero = des.Tve_Numero
		where convert(date, tmp.Tvl_FecCon) between @IniMes and @FinMes


	insert into SOTIVAEL(
		Tve_Numero,   Tve_Nombre, Tve_Abrevi, Tve_EsEnt,  Tve_EsMon,
        Tve_EsDec,    Tve_Logico, Tve_EsFech, Tve_Activo, NumTransac, 
        Transaccio,   Usuario,    FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Tvl_Numero,   tmp.Tvl_Nombre, tmp.Tvl_Abrevi, tmp.Tvl_EsEnt,  tmp.Tvl_EsMon,
        tmp.Tvl_EsDec,    tmp.Tvl_Logico, tmp.Tvl_EsFech, tmp.Tvl_Activo, @NumTransac,    
        @Transaccio,      @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPTVL tmp noholdlock 
		left join SOTIVAEL des on tmp.Tvl_Numero = des.Tve_Numero
        where des.Tve_Numero is null 
          and convert(date, tmp.Tvl_FecCon) between @IniMes and @FinMes
commit

