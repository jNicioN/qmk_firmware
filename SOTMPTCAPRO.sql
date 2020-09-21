create procedure SOTMPTCAPRO (
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
	update SOTICAMO set
		Tcm_Numero  =  tmp.Tca_Numero,
		Tcm_Nombre  =  tmp.Tca_Nombre,
		Tcm_Abrevi  =  tmp.Tca_Abrevi,
        Tcm_Descri  =  tmp.Tca_Descri,
        Tcm_Activo  =  tmp.Tca_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPTCA tmp
		inner join SOTICAMO des on tmp.Tca_Numero = des.Tcm_Numero
		where convert(date, tmp.Tca_FecCon) between @IniMes and @FinMes


	insert into SOTICAMO(
		Tcm_Numero,   Tcm_Nombre, Tcm_Abrevi, Tcm_Descri, Tcm_Activo,
        NumTransac,   Transaccio, Usuario,    FechaSis,   SucOrigen,
        SucDestino)
		select  
		tmp.Tca_Numero,   tmp.Tca_Nombre, tmp.Tca_Abrevi, tmp.Tca_Descri, tmp.Tca_Activo,
        @NumTransac,      @Transaccio,    @Usuario,       @FechaSis,      @SucOrigen,
        @SucDestino
		from SOTMPTCA tmp noholdlock 
		left join SOTICAMO des on tmp.Tca_Numero = des.Tcm_Numero
        where des.Tcm_Numero is null 
          and convert(date, tmp.Tca_FecCon) between @IniMes and @FinMes
commit