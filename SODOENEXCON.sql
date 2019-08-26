create procedure SODOENEXCON (
	@Dee_Id	int,
	@PerPersoID	int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Consulta de documento de enrolamiento de extranjero*
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		07/Ago/2019										****
** Help:		01278846										****
** Descripcion:	Consulta de documento de enrolamiento de extranjero*
********************************************************************/
/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	/* Consulta Tipo C/L*/
		@Tip_ConCon	char(1)		/* Tipo Consecutivo */

/* Declaracion de Constantes */
declare	@Str_C		char(1),
		@Str_Uno	char(1),
		@Str_Dos    char(1)

/* Asignacion de Constantes */
select	@Str_C		= 'C',	/* Tipo C */
		@Str_Uno	= '1',	/* Tipo 1 */
		@Str_Dos    = '2'	/* Tipo 2 */
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin /* C1 - Búsqueda principal por llave primaria */			  			
		select	Dee_Id,		PerPersoID,	Dee_NumIde,	Dee_FolIde,	Dee_FecEmi,
				Dee_FecVen,	Dee_Clave,	Dee_NumEmi
			from SODOENEX noholdlock
			where Dee_Id	= @Dee_Id
	end else if @Tip_ConCon	= @Str_Dos begin /* C1 - Búsqueda por número de persona */
		select	Dee_Id,		PerPersoID,	Dee_NumIde,	Dee_FolIde,	Dee_FecEmi,
				Dee_FecVen,	Dee_Clave,	Dee_NumEmi
			from SODOENEX noholdlock
			where PerPersoID	= @PerPersoID
			order by Dee_Id asc
	end
end