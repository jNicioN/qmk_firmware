create procedure SOULHESPCON (
	@Uhs_Moneda	char(2),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
** Consulta del Ultimo Hecho Spot										****
****************************************************************************
*/

/*
****************************************************************************
** Modificó:	Fernando Del Angel Sánchez								****
** Fecha:		12/Agosto/2015			   								****
** HelpDesk:	00802695												****
** Descripción:	Agregar Lista: L1 para intefase Infosel 				****
****************************************************************************
** Modificó:	Arnoldo Garza Quezada									****
** Fecha:		11/Enero/2006			   								****
** HelpDesk:	0003594													****
** Descripción:	Agregar consulta utilizada para Actualizar Dólar/Euro 	****
** 				desde Bloomberg											****
****************************************************************************
** Creó:		FCHIA													****
** Fecha:		13/Junio/2005											****
****************************************************************************
*/

declare	@Tip_ConTip	char(1),			/* Declaración de variables */
		@Tip_ConCon	char(1)

declare	@Mon_Dolar	char(2),			/* Declaración de constantes*/
	    @Mon_Euro	char(2),
	    @Str_Si		char(1)

/* Asignación de constantes*/
select  @Mon_Dolar 	= '02',				/* Moneda: Dólar */
	   	@Mon_Euro  	= '28',				/* Moneda: Euro */
	   	@Str_Si		= 'S'				/* String: Si */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin				/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin 				/* Consulta de Llave Principal */
		select	Uhs_Fecha,	Uhs_Moneda,	Uhs_Valor
			from SOULHESP noholdlock
			where	Uhs_Moneda 	= @Uhs_Moneda
		end
    else begin if @Tip_ConCon = '2' begin	/* Consulta utilizada previa a Actualizar Dolar/Euro desde Bloomberg */
		select  Uhs_Fecha,	Uhs_Moneda,	Uhs_Valor
			from SOULHESP noholdlock
			where 	Uhs_Moneda 	in (@Mon_Dolar, @Mon_Euro)
			order by Uhs_Moneda
		end
    end
end else if @Tip_ConTip = 'L' begin		/* 'L':  Lista */
	if @Tip_ConCon = '1' begin				/* Obtiene las monedas operables en cambios para actulizar precios por cron */
		select  Uhs_Fecha,	Uhs_Moneda,	Uhs_Valor
			from SOULHESP noholdlock
				 inner join SOMONEDA noholdlock on (Uhs_Moneda = Mon_Numero)
			where	Mon_OpeCam = @Str_Si
			order by Uhs_Moneda
	end
end
