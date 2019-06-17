create procedure SOTELPERACT (
	@PerPersoID	int,
	@Tep_TipTel	int, 
	@ClClientID	int,	
	@Tep_Lada	int, 
	@Tep_Telefo	bigint,
	@Tep_Verifi	smallint,
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/***************************************************************************
** Descripción:	 Actualización de Teléfonos de Personas					****
****************************************************************************
** Referencias:															****
****************************************************************************
** Creó:		Francisco Javier Carrillo Rojas							****
** Fecha:		03/Nov/2018												****
** Help:		01171269												****
****************************************************************************/
										/* Declaración de variables */
declare	@Status		int,
		@Tep_StaAnt	smallint

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Sta_Verifi	int,
		@Ent_NegUno	int,
		@Act_TelVer	char(1)

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Fec_Vacia	= '1900-01-01',		/* Fecha vacía */
		@Ent_Cero	= 0,				/* Entero en cero */
		@Ent_Uno	= 1,				/* Entero en uno */
		@Sta_Verifi	= 1,				/* Estatus verificado */
		@Ent_NegUno	= -1,				/* Entero en menos uno */
		@Act_TelVer	= 'V'				/* Actualización teléfono verificado */

if @Tip_Actual	= @Act_TelVer begin	/*Actualización de teléfono verificado*/
	select	@Tep_StaAnt = Tep_Verifi
		from SOTELPER noholdlock
		where	PerPersoID	= @PerPersoID
		  and	Tep_TipTel	= @Tep_TipTel
		  and	ClClientID	= @ClClientID
		  and	Tep_Lada	= @Tep_Lada 
		  and	Tep_Telefo	= @Tep_Telefo

	if isnull(@Tep_StaAnt, @Ent_NegUno) != @Ent_NegUno begin
		--Solo actualizar si aún no ha sido verificado
		if @Tep_StaAnt != @Sta_Verifi begin
			update SOTELPER set
				Tep_Verifi 	= @Sta_Verifi
				where PerPersoID	= @PerPersoID
				  and Tep_TipTel	= @Tep_TipTel
				  and ClClientID	= @ClClientID
		end
	end
end