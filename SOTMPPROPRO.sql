create procedure SOTMPPROPRO (
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
** Elaboró: 		Frank Canul						                    ****
** Fecha:		    22/09/2021									        ****
** Help:			1286068  									        ****
** Descripción:	    Se agrega campo Pro_NivAut para la tabla SOPRODUC	****
**					y SOTMPPRO, se elimna el campo de subproducto       ****
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
	update SOPRODUC set
		Pro_Numero  =  tmp.Pro_Numero,
		Pro_Nombre  =  tmp.Pro_Nombre,
		Pro_Abrevi  =  tmp.Pro_Abrevi,
        Pro_Activo  =  tmp.Pro_Activo,
		Pro_NivAut	=  tmp.Pro_NivAut,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPPRO tmp
		inner join SOPRODUC des on tmp.Pro_Numero = des.Pro_Numero 
		where convert(date, tmp.Pro_FecCon) between @IniMes and @FinMes


	insert into SOPRODUC(
		Pro_Numero,   Pro_Nombre,   Pro_Abrevi, Pro_Activo,
        Pro_NivAut,	  NumTransac,   Transaccio, Usuario,    FechaSis,   
		SucOrigen,    SucDestino)
		select  
		tmp.Pro_Numero,   tmp.Pro_Nombre,   tmp.Pro_Abrevi, tmp.Pro_Activo,
		tmp.Pro_NivAut,   @NumTransac,      @Transaccio,    @Usuario,       @FechaSis,      
		@SucOrigen,       @SucDestino
		from SOTMPPRO tmp noholdlock 
		left join SOPRODUC des on tmp.Pro_Numero = des.Pro_Numero
		where des.Pro_Numero is null
		  and convert(date, tmp.Pro_FecCon) between @IniMes and @FinMes
commit