create procedure SOGRUPROCON (
	@Grp_Identi	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***********************************************************************
** DESCRIPCIÓN:	Consultas a tabla SOGRUPRO							****
************************************************************************
** REFERENCIAS: 													****
************************************************************************
** Creó:		Juan Galván Ramírez									****
** Fecha:		21/10/2021											****
** Help:															****
***********************************************************************/

/* Declaración de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaración de constantes */
declare	@Con_TipCon	char(1),
		@Con_TipLis	char(1),
		@Con_LlaPri	char(1),
		@Lis_Catalo	char(1)

/* Asignación de constantes */
select	@Con_TipCon	= 'C',														/* Consulta tipo consulta */
		@Con_TipLis	= 'L',														/* Consulta tipo lista */
		@Con_LlaPri	= '1',														/* Consulta de llave principal */
		@Lis_Catalo	= '1'														/* Lista 1 */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Con_TipCon begin												/* C O N S U L T A S */
	if @Tip_ConCon = @Con_LlaPri begin											/* Consulta de llave principal */
		select	Grp_Identi, Grp_Descri
			from SOGRUPRO noholdlock
			where	Grp_Identi	= @Grp_Identi
	end 
end else if @Tip_ConTip = @Con_TipLis  begin									/* L I S T A S */
			if @Tip_ConCon = @Lis_Catalo begin									/* Lista de todos los registros de la tabla */
				select	Grp_Identi,	Grp_Descri,	NumTransac,	Transaccio,	Usuario
						FechaSis,	SucOrigen,	SucDestino
					from SOGRUPRO noholdlock
			end
	end