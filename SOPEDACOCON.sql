create procedure SOPEDACOCON (
	@DaP_Person	char(8),
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
** DESCRIPCION: ** Consulta de datos complementarios de persona  **	****
***************************************************************************/
/* REFERENCIAS:
****************************************************************************
** Modificó:	Armando Alexis Sepúlveda Cruz							****
** Fecha:		11/Jul/2018												****
** Help:		1088831 												****
** Descripción:	Se agregan campos:  DaP_TiIdAd, DaP_NuIdAd, DaP_ExIdAd	****
**				DaP_VeIdAd, DaP_ClvEle, DaP_NumEmi						****
****************************************************************************
** Modificó:	Daniel Bautista Gomez									****
** Fecha:		30/Nov/2017												****
** Help:		1050138 												****
** Descripción:	Se agregan campos:  DaP_TipFid y DaP_FolFid
****************************************************************************
** Modificó:	Daniel Bautista Gomez									****
** Fecha:		20/Noviembre/2017										****
** Help:		1044393													****
** Descripción:	Se agregan campos DaP_CoVeDi				****
****************************************************************************
** Modificó:	Claudia Moncada											****
** Fecha:		1/Septiembre/2016										****
** Help:		00901110												****
** Descripción:	Se agregan campos DaP_PaiNac y DaP_EntNac				****
****************************************************************************
** Creoó:		Andrea Ramírez Mondragón								****
** Fecha:		07/Ene/2016												****
** Help:		00801121												****
****************************************************************************/

declare	@Tip_ConTip	char(1),	/* Declaración de variables */
		@Tip_ConCon	char(1)

/* Declaración de Constantes */
declare	@Str_Vacio	char(1),
		@Ent_Cero	int

/* Asignación de Constantes */
select	@Str_Vacio	= '',				-- String Vacio
		@Ent_Cero	= 0				-- Entero Cero


select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta Pricipal */
		select	DaP_Person,	DaP_Firma,	DaP_CaNuIn,	DaP_EsPEP,	DaP_FuPuPe, 
				DaP_EsPaPE,	DaP_ParPEP,	DaP_NoFaPe,	DaP_ApPaPe,	DaP_ApMaPe, 
				DaP_EntBan, DaP_PaiNac, DaP_EntNac, DaP_CoVeDi, DaP_FolFid, 
				DaP_TipFid, DaP_TiIdAd, DaP_NuIdAd, DaP_ExIdAd, DaP_VeIdAd,
				DaP_ClvEle, DaP_NumEmi
		from	SOPEDACO noholdlock
		where	DaP_Person	= @DaP_Person
	end
end
