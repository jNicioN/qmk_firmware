create procedure SOMONABRCON(
    @Mon_AbrISO varchar(3),
    @Tip_Consul	char(2),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2)
)
as

/*
****************************************************************************
**** Consulta moneda por la abreviacion             					****
****************************************************************************
** Creo: 		Shaila Palafox                  				        ****
** Fecha: 		05/10/2023										        ****
** Helpdesk:    TCELTO-4796								                ****	
***************************************************************************/

/* Declaracion de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaracion de constantes */
declare @Str_C char(1), 
        @Str_Uno char(1)

/* Asignacion de valores a constantes */
select @Str_C = 'C',
       @Str_Uno = '1'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin				/* 'C':  Consulta */
    if @Tip_ConCon = @Str_Uno begin				/* Consulta C1: Por Abreviatura ISO */
        select  Mon_Numero,	Mon_Descri,	Mon_Simbol,	Mon_Fecha,	Mon_EfeCom,
	    	    Mon_EfeVen,	Mon_DocCom,	Mon_DocVen,	Mon_FixCom,	Mon_FixVen,
	    	    Mon_Abrevi,	Mon_DesCor,	Mon_CtaEfe,	Mon_CtaBM,	Mon_CtaSBC,	
	    	    Mon_CtaRem,	Mon_CieCom,	Mon_CieVen,	Mon_SpoCom,	Mon_SpoVen,	
	    	    Mon_EqBaMa,	Mon_OpeCam, Mon_CieDia,	Mon_FixVal,	Mon_DesLeg,
	    	    Mon_Tipo,	Mon_ForMet, Mon_AbrISO
            from SOMONEDA noholdlock
	        where	Mon_AbrISO = @Mon_AbrISO
    end    
end


