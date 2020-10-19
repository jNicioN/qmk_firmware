create procedure SOTMPETCPRO (
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
	update SOELTIMO set
		Etm_Numero  =  tmp.Etc_Numero,
		Etm_TiCaMo  =  tmp.Etc_TiCaMo,
		Etm_NumEle  =  tmp.Etc_NumEle,
        Etm_Nombre  =  tmp.Etc_Nombre,
        Etm_Abrevi  =  tmp.Etc_Abrevi,
        Etm_Descri  =  tmp.Etc_Descri,
        Etm_TiVaEl  =  tmp.Etc_TiVaEl,
        Etm_Activo  =  tmp.Etc_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPETC tmp
		inner join SOELTIMO des on tmp.Etc_Numero = des.Etm_Numero
		where convert(date, tmp.Etc_FecCon) between @IniMes and @FinMes


	insert into SOELTIMO(
		Etm_Numero,   Etm_TiCaMo, Etm_NumEle, Etm_Nombre, Etm_Abrevi,
        Etm_Descri,   Etm_TiVaEl, Etm_Activo, NumTransac, Transaccio, 
        Usuario,      FechaSis,   SucOrigen,  SucDestino)
		select  
		tmp.Etc_Numero,   tmp.Etc_TiCaMo, tmp.Etc_NumEle, tmp.Etc_Nombre, tmp.Etc_Abrevi,
        tmp.Etc_Descri,   tmp.Etc_TiVaEl, tmp.Etc_Activo, @NumTransac,    @Transaccio,
        @Usuario,         @FechaSis,      @SucOrigen,     @SucDestino
		from SOTMPETC tmp noholdlock 
		left join SOELTIMO des on tmp.Etc_Numero = des.Etm_Numero
        where des.Etm_Numero is null 
          and convert(date, tmp.Etc_FecCon) between @IniMes and @FinMes
commit