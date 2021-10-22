create procedure SOPROGRUCON  (
	@Pro_Identi	int,				/* Campo SOPROGRU.Prg_GruPro o SOGRUPRO.Grp_Identi */
	@Pro_Numero int,				/* Campo SOPROGRU.Prg_NumPro o SOPRODUC.Pro_Numero */
	@Tip_Consul char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
**DESCRIPCION: Consulta tipo cuentas asociadas a grupo de producto**
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Seth Luis										****
** Fecha:		21/10/2021										****
** Descripción:	Se agregan más campos a consulta L1				****
** Help:		1566195											****
********************************************************************
** Creó:		Carlos Ramirez									****
** Fecha:		05/Julio/2021									****
** HelpDesk:	1536016											****
*******************************************************************/

declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

declare @Con_Consul	char(1),
		@Con_Listas	char(1),
		@Str_Uno	char(1)

select	@Con_Consul	= 'C',				/* Tipo: Consulta		*/
		@Con_Listas	= 'L',				/* Tipo: Lista			*/
		@Str_Uno	= '1'				/* Cadena: Valor uno	*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if (@Tip_ConTip = @Con_Consul) begin
	if (@Tip_ConCon = @Str_Uno) begin																	/* Consulta por llave principal (por número de producto) */
		select	Cla_Numero,	Cla_Descri,	Tip_Numero,	Tip_Moneda,	Tip_Descri
			from CHTIPOS noholdlock
			inner join SOPRTICU noholdlock on Ptc_TipCue = Tip_Numero and Ptc_Moneda = Tip_Moneda
			inner join SOPRODUC noholdlock on Pro_Numero = Ptc_Produc
			inner join SOCLAPRO noholdlock on Clp_Produc = Pro_Numero
			inner join SOCLASIF noholdlock on Cla_Numero = Clp_Clasif
			where Pro_Numero = @Pro_Numero
	end
end else if (@Tip_ConTip = @Con_Listas) begin
	if (@Tip_ConCon = @Str_Uno) begin																	/* Lista por llave principal (por grupo de producto) */
		select	Prg.Prg_Identi,	Grp.Grp_Identi,	Grp.Grp_Descri,	Pro.Pro_Numero,	Pro.Pro_Nombre,
				Cla.Cla_Numero,	Cla.Cla_Descri,	Ptc.Ptc_Numero,	Tip.Tip_Numero,	Tip.Tip_Moneda,
				Tip.Tip_Descri
			from SOPROGRU Prg noholdlock
			inner join SOGRUPRO Grp noholdlock on Grp.Grp_Identi = Prg.Prg_GruPro
			inner join SOPRODUC Pro noholdlock on Pro.Pro_Numero = Prg.Prg_NumPro
			inner join SOCLAPRO Clp noholdlock on Clp.Clp_Produc = Pro.Pro_Numero
			inner join SOCLASIF Cla noholdlock on Cla.Cla_Numero = Clp.Clp_Clasif
			inner join SOPRTICU Ptc noholdlock on Ptc.Ptc_Produc = Pro.Pro_Numero
			inner join CHTIPOS Tip noholdlock on Tip.Tip_Numero = Ptc.Ptc_TipCue and Tip.Tip_Moneda = Ptc.Ptc_Moneda
			where Prg.Prg_GruPro = @Pro_Identi
			order by Pro.Pro_Nombre
	end
end

