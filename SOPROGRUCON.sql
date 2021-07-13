create procedure SOPROGRUCON  (
	@Pro_Identi	int,	
	@Pro_Numero int,					--Recibe campo Grp_Identi de SOGRUPRO
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
********************************************************************
**DESCRIPCION: Consulta tipo cuentas asociadas a grupo de producto**
********************************************************************
*/

/* REFERENCIAS:
********************************************************************
** Creó:		Carlos Ramirez									****
** Fecha:		05/Julio/2021									****
** HelpDesk:	1497258											****
********************************************************************
*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

declare @Con_Consul char(1),
		@Con_Listas char(1),
		@Str_Uno    char(1)
		
select	@Con_Consul	= 'C',				/* Tipo: Consulta		*/
		@Con_Listas	= 'L',				/* Tipo: Lista			*/
		@Str_Uno	= '1'				/* Cadena: Valor uno	*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip = @Con_Consul begin		/* Consultas */
	if @Tip_ConCon = @Str_Uno begin	/* Consulta por llave principal */
	
	select Cla_Numero, Cla_Descri, Tip_Numero, Tip_Moneda, Tip_Descri
		from CHTIPOS noholdlock
		inner join SOPRTICU noholdlock on Ptc_TipCue = Tip_Numero and Ptc_Moneda = Tip_Moneda
		inner join SOPRODUC noholdlock on Pro_Numero = Ptc_Produc
		inner join SOCLAPRO noholdlock on Clp_Produc = Pro_Numero
		inner join SOCLASIF noholdlock on Cla_Numero = Clp_Clasif
		where Ptc_Numero = @Pro_Numero
	end
end
else if @Tip_ConTip = @Con_Listas begin	
	if @Tip_ConCon = @Str_Uno begin	/* Lista por llave principal */

		select Cla_Numero, Cla_Descri, Tip_Numero, Tip_Moneda, Tip_Descri,
			   Ptc_Numero
			from SOCLASIF noholdlock
				inner join SOCLAPRO noholdlock on (Cla_Numero = Clp_Clasif)
				inner join SOPROGRU noholdlock on (Clp_Produc = Prg_NumPro)
				inner join SOPRTICU noholdlock on (Prg_NumPro = Ptc_Produc)
				inner join CHTIPOS noholdlock on (Tip_Numero = Ptc_TipCue and Tip_Moneda = Ptc_Moneda)
				where Prg_GruPro = @Pro_Identi
				
	end
end

