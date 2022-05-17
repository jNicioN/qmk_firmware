create procedure SOCLCLTACON (
	@Cct_Clabe	char(18),
	@Cct_Tarjet	char(16),
	@Cue_Numero	char(12),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION:	Consulta de clasificación de producto por CLABE,		****
** 				tarjeta o cuenta										****
** REFERENCIAS:															****
****************************************************************************
** Modificó:	Seth Karim Luis Martínez								****
** Fecha:		29/04/2022												****
** Help:		1640569													****
** Descripción: Consulta de clasificación por número de cuenta			****
****************************************************************************
** Creó:		Armida González											****
** Fecha:		02/03/2021												****
** Help:		1455332													****
***************************************************************************/

/*	Declaración de Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Cue_Tipo	char(2),
		@Cue_Moneda	char(2),
		@TaP_TipTar	char(4)
	
/*	Declaración de Constantes	*/
declare	@Ent_Uno	int,
		@Tip_TipCon	char(1),
		@Tip_ConUno	char(1),
		@Tip_ConDos	char(1),
		@Tip_ConTre char(1)

/* Asignación de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
		@Tip_TipCon	= 'C',			/* Tipo consulta*/
		@Tip_ConUno	= '1',			/* Uno - Consulta de clasificación por clabe */
		@Tip_ConDos	= '2',			/* Dos - Consulta de clasificación por número de tarjeta */
		@Tip_ConTre	= '3'			/* Tres - Consulta de clasificación por número de cuenta */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if (@Tip_ConTip = @Tip_TipCon) begin			/* Consulta */
	if (@Tip_ConCon = @Tip_ConUno) begin				/* Consulta por cuenta CLABE*/
		select	@Cue_Tipo	= Cue_Tipo,
				@Cue_Moneda	= Cue_Moneda
			from CHCUENTA noholdlock
			where	Cue_Clabe	= @Cct_Clabe
					
		select Clp_Numero, Clp_Clasif, Clp_Produc, Ptc_TipCue
			from SOCLAPRO noholdlock,
				 SOPRTICU noholdlock
			where	Ptc_TipCue	= @Cue_Tipo
			  and	Ptc_Moneda	= @Cue_Moneda
			  and	Clp_Produc	= Ptc_Produc
	end else if (@Tip_ConCon = @Tip_ConDos) begin				/* Consulta por número de tarjeta*/
		select	@TaP_TipTar	= TaP_TipTar
			from CTTARPRO noholdlock
			where	TaP_Tarjet	= @Cct_Tarjet

		select distinct Clp_Numero, Clp_Clasif, Clp_Produc, Ptt_TipTar
			from SOCLAPRO noholdlock,
				 SOPRTITA noholdlock
			where	Ptt_TipTar	= @TaP_TipTar
			  and	Clp_Produc	= Ptt_Produc  
	end else if (@Tip_ConCon = @Tip_ConTre) begin				/* Consulta por número de cuenta*/
		select	clp.Clp_Numero,	clp.Clp_Clasif,	clp.Clp_Produc,	ptc.Ptc_TipCue
			from CHCUENTA cue
			inner join SOPRTICU ptc noholdlock on ptc.Ptc_TipCue = cue.Cue_Tipo and ptc.Ptc_Moneda = cue.Cue_Moneda
			inner join SOCLAPRO clp noholdlock on clp.Clp_Produc = ptc.Ptc_Produc
			where	cue.Cue_Numero	= @Cue_Numero
	end
end
