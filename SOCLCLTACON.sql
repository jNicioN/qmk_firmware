create procedure SOCLCLTACON (
	@Cct_Clabe	char(18),
	@Cct_Tarjet	char(16),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************/
/* DESCRIPCION:   Consulta de clasificacion de producto por CLABE o tarjeta	*/
/** REFERENCIAS:
****************************************************************************
** Creó:		Armida González											****
** Fecha:		02/03/2021												****
** Help:		1455332													****
***************************************************************************/

/*	Declaracion de Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Cue_Tipo	char(2),
		@Cue_Moneda	char(2),
		@TaP_TipTar	char(4)
	
/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int,
		@Tip_TipCon	char(1),
		@Tip_ConUno	char(1),
		@Tip_ConDos	char(1)

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
		@Tip_TipCon	= 'C',			/* Tipo consulta*/
		@Tip_ConUno	= '1',			/* Uno - Consulta por producto de cheques*/
		@Tip_ConDos	= '2'			/* Dos - Consulta por producto de tarjeta*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tip_TipCon begin			/* Consulta */
	if @Tip_ConCon = @Tip_ConUno begin				/* Consulta por cuenta CLABE*/

		select	@Cue_Tipo	= Cue_Tipo,
				@Cue_Moneda	= Cue_Moneda
			from CHCUENTA noholdlock
			where	Cue_Clabe	= @Cct_Clabe
					
		select Clp_Numero, Clp_Clasif, Clp_Produc, Ptc_TipCue
			from SOCLAPRO noholdlock,
				 SOPRTICU noholdlock
			where   Ptc_TipCue	= @Cue_Tipo
			  and	Ptc_Moneda	= @Cue_Moneda
			  and	Clp_Produc	= Ptc_Produc	
				
	end if @Tip_ConCon = @Tip_ConDos begin			/* Consulta por número de tarjeta*/
	
		select	@TaP_TipTar	= TaP_TipTar
			from CTTARPRO noholdlock
			where	TaP_Tarjet	= @Cct_Tarjet

		select distinct Clp_Numero, Clp_Clasif, Clp_Produc, Ptt_TipTar
			from SOCLAPRO noholdlock,
				 SOPRTITA noholdlock
			where	Ptt_TipTar	= @TaP_TipTar
			  and	Clp_Produc	= Ptt_Produc  
	end
end
