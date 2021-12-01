create procedure SOTMPCLPPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
    @Modulo		char(2))

as

/***************************************************************************
** Descripción:    Migracion de la Información de Clasificacin Produco      ****
****************************************************************************
** Referencias:															****
****************************************************************************
** Elaboró: 		Frank Alberto Canul Moo                               ****
** Fecha:		    06/10/2021									        ****
** Help:			  		1574028							        ****
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
	update SOCLAPRO set
		Clp_Clasif  =  tmp.Clp_Clasif,
		Clp_Produc  =  tmp.Clp_Produc,
		NumTransac  =  @NumTransac,
		Transaccio  =  @Transaccio,
		Usuario     =  @Usuario,   
		FechaSis    =  @FechaSis,  
		SucOrigen   =  @SucOrigen, 
		SucDestino  =  @SucDestino 
		from SOTMPCLP tmp noholdlock
		inner join  SOCLAPRO des noholdlock on tmp.Clp_Clasif = des.Clp_Clasif and  
                                   tmp.Clp_Produc = des.Clp_Produc
		where convert(date, tmp.Clp_FecCon) between @IniMes and @FinMes


	insert into SOCLAPRO(
		Clp_Clasif, Clp_Produc, NumTransac,    Transaccio,   
		Usuario,    FechaSis,    SucOrigen,     SucDestino)
		select  
	    tmp.Clp_Clasif, tmp.Clp_Produc,  @NumTransac,  @Transaccio,     
		@Usuario,       @FechaSis,        @SucOrigen,  @SucDestino
		from SOTMPCLP tmp noholdlock 
		left join SOCLAPRO des noholdlock on   tmp.Clp_Clasif = des.Clp_Clasif and  
                                   tmp.Clp_Produc = des.Clp_Produc
		where des.Clp_Numero is null
		  and convert(date, tmp.Clp_FecCon) between @IniMes and @FinMes
commit