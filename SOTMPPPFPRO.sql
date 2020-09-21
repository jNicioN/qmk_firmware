create procedure SOTMPPPFPRO (
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
	update SOPRPEFI set
		Ppf_Numero  =  tmp.Ppf_Numero,
		Ppf_Produc  =  tmp.Ppf_Produc,
		Ppf_PerFis  =  tmp.Ppf_PerFis,
        Ppf_Activo  =  tmp.Ppf_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPPPF tmp
		inner join SOPRPEFI des on (tmp.Ppf_Numero = des.Ppf_Numero
        and tmp.Ppf_Produc = des.Ppf_Produc
        and tmp.Ppf_PerFis = des.Ppf_PerFis)
		where convert(date, tmp.Ppf_FecCon) between @IniMes and @FinMes


	insert into SOPRPEFI(
		Ppf_Numero,   Ppf_Produc, Ppf_PerFis, Ppf_Activo, NumTransac,
        Transaccio,   Usuario,    FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Ppf_Numero,   tmp.Ppf_Produc, tmp.Ppf_PerFis, tmp.Ppf_Activo, @NumTransac,
        @Transaccio,      @Usuario,       @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPPPF tmp noholdlock 
		left join SOPRPEFI des on tmp.Ppf_Numero = des.Ppf_Numero
        where des.Ppf_Numero is null 
          and convert(date, tmp.Ppf_FecCon) between @IniMes and @FinMes
commit