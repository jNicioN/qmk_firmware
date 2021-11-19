create procedure SOTMPPTAPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Migracion de la Información de Producto Tarjeta      ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		Frank Alberto Canul Moo                               ****
** Fecha:		    06/10/2021									        ****
** Help:			  	1574028								        ****
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
	update SOPRTITA set
		Ptt_TipTar  =  tmp.Pta_TipTar,
		Ptt_Produc  =  tmp.Pta_Produc,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPPTA tmp
		inner join SOPRTITA des on tmp.Pta_TipTar = des.Ptt_TipTar and  
                                   tmp.Pta_Produc = des.Ptt_Produc
		where convert(date, tmp.Pta_FecCon) between @IniMes and @FinMes


	insert into SOPRTITA(
	    Ptt_TipTar, Ptt_Produc, NumTransac,   Transaccio,   
		Usuario,    FechaSis,    SucOrigen,    SucDestino)
		select  
		tmp.Pta_TipTar, tmp.Pta_Produc,  @NumTransac, @Transaccio,      
		@Usuario,       @FechaSis,        @SucOrigen, @SucDestino
		from SOTMPPTA tmp noholdlock 
		left join SOPRTITA des on tmp.Pta_TipTar = des.Ptt_TipTar and  
                                   tmp.Pta_Produc = des.Ptt_Produc
		where des.Ptt_Numero is null
		  and convert(date, tmp.Pta_FecCon) between @IniMes and @FinMes
commit