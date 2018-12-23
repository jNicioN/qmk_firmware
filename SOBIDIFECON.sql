create procedure SOBIDIFECON (
	@Bdf_TipPro	char(3),
	@Bdf_DiaFes	smalldatetime,
	@Var_Contin	char(1) output,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: Consulta de Bitacora de actualización de dias festivos	****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Creó:		Andrea Ramirez Mondragon								****
** Fecha:		27/Dic/2017												****
** Help:		1038263													****
****************************************************************************
*/

/* Declaracion de Variables		*/
declare	@Bdf_Proces	char(3)

/* Declaracion de constantes		*/
declare	@Sta_Si		char(1),
		@Sta_No		char(1),
		@Str_Vacio	char(1)
		
select	@Sta_Si		= 'S',		/* Status: Si	*/
		@Sta_No		= 'N',		/* Status: No	*/
		@Str_Vacio	= ''		/* String vacio */

select	@Bdf_Proces =  Bdf_TipPro
from SOBIDIFE noholdlock
where	Bdf_TipPro	=	@Bdf_TipPro
  and	Bdf_DiaFes	=	@Bdf_DiaFes

if isnull (@Bdf_Proces,@Str_Vacio) = @Str_Vacio
	select	@Var_Contin =	@Sta_Si
else
	select	@Var_Contin =	@Sta_No
