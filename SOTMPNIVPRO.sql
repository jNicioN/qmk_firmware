create procedure SOTMPNIVPRO (
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
** Fecha:		    11/01/2010									        ****
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
	update SONIVENT set
		Nie_Numero  =  tmp.Niv_Numero,
		Nie_Nombre  =  tmp.Niv_Nombre,
		Nie_Abrevi  =  tmp.Niv_Abrevi,
        Nie_EsProd  =  tmp.Niv_EsProd,
        Nie_Priori  =  tmp.Niv_Priori,
        Nie_Tabla   =  tmp.Niv_Tabla,
        Nie_Activo  =  tmp.Niv_Activo,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPNIV tmp
		inner join SONIVENT des on tmp.Niv_Numero = des.Nie_Numero
		where convert(date, tmp.Niv_FecCon) between @IniMes and @FinMes


	insert into SONIVENT(
		Nie_Numero,   Nie_Nombre, Nie_Abrevi, Nie_EsProd, Nie_Priori,
        Nie_Tabla,    Nie_Activo, NumTransac, Transaccio, Usuario,
        FechaSis,     SucOrigen,  SucDestino)
		select  
		tmp.Niv_Numero,   tmp.Niv_Nombre, tmp.Niv_Abrevi, tmp.Niv_EsProd,  tmp.Niv_Priori,
        tmp.Niv_Tabla,    tmp.Niv_Activo, @NumTransac,    @Transaccio,     @Usuario,
        @FechaSis,        @SucOrigen,     @SucDestino
		from SOTMPNIV tmp noholdlock 
		left join SONIVENT des on tmp.Niv_Numero = des.Nie_Numero
        where des.Nie_Numero is null 
          and convert(date, tmp.Niv_FecCon) between @IniMes and @FinMes
commit