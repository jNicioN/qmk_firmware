create procedure SOCLCAPECON (
	@Clp_NumPer	char(8),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION: ** Consulta de Clasificacin de Cartera de Personas 	***/
/**************************************************************************/
/* REFERENCIAS:															***/
/****************************************************************************
**       			STORE CONVERTIDO                 			****
****************************************************************************
** Modificó:		Edwin E. Pérez Requena						****
** Fecha:		08/Mayo/2014								****
** Help:		      652393										****
** Descripción	Se agregó  Clp_LocINE y Clp_EntINE a		****
**				resultado									****
****************************************************************************
** Creó:			Abraham Sánchez    							****
** Fecha:		11/Febrere/2014							****
** Help:		      538910										****
****************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1)
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta la Clasificacin de Cartera por Persona */
		select	Clp_NumPer,	Clp_InsReg,	Clp_OtoCre,	Clp_Bancar,	Clp_SubBan,
				Clp_Fideic,	Clp_TipSoc,	Clp_NomSoc,	Clp_EntFin,	Clp_UsBuCr,
				Clp_LocINE,	Clp_EntINE
			from SOCLCAPE noholdlock
			where	Clp_NumPer	= @Clp_NumPer
	end
end
