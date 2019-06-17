create procedure SOCLCAPEMOD (
	@Clp_NumPer char(8),
	@Clp_InsReg char(1),
	@Clp_OtoCre char(1),
	@Clp_Bancar char(1),
	@Clp_SubBan char(1),
	@Clp_Fideic char(1),
	@Clp_TipSoc char(3),
	@Clp_NomSoc varchar(180),
	@Clp_EntFin	char(1),
	@Clp_UsBuCr	char(1),
	@Clp_LocINE	char(3),
	@Clp_EntINE	char(2),
   
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**************************************************************************/
/* DESCRIPCION: ** Modificacin de Clasificacin de Cartera de Personas ***/
/**************************************************************************/
/* REFERENCIAS:															***/
/****************************************************************************
** Modificó:		Marcelo Bautista Hernandez					****
** Fecha:		12/Junio/2015								****
** Help:			774214										****
** Descripción	se consulta si es entidad financiera			****
** 				en CLTIPSOC								****
****************************************************************************
**       			STORE CONVERTIDO                 			****
**	Convirtio :  	Edwin E. Pérez Requena						****
** 	Fecha:   	08/Mayo/2014	                                          ****	
****************************************************************************
** Modificó:		Edwin E. Pérez Requena						****
** Fecha:		08/Mayo/2014								****
** Help:		      652393										****
** Descripción	Se agregaron parámetros @Clp_LocINE y		****
**				@Clp_EntINE								****
****************************************************************************
** Creó:			Abraham Sánchez    							****
** Fecha:		11/Febrero/2014							****
** Help:		      538910										****
****************************************************************************/

select	@Clp_EntFin	= Tis_EntFin
	from	CLTIPSOC noholdlock
	where	Tis_Numero	= @Clp_TipSoc

select	@Clp_EntFin = isnull(@Clp_EntFin,'')

if not exists(select Clp_NumPer
				from SOCLCAPE noholdlock
				where	Clp_NumPer	= @Clp_NumPer) begin
	
	exec SOCLCAPEALT	@Clp_NumPer,	@Clp_InsReg,	@Clp_OtoCre,	@Clp_Bancar,	@Clp_SubBan,
						@Clp_Fideic,	@Clp_TipSoc,	@Clp_NomSoc,	@Clp_EntFin,	@Clp_UsBuCr,
						@Clp_LocINE,	@Clp_EntINE,	@NumTransac,	@Transaccio,	@Usuario,
						@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
end else begin
	update SOCLCAPE set
	Clp_InsReg	= @Clp_InsReg,
	Clp_OtoCre	= @Clp_OtoCre,
	Clp_Bancar	= @Clp_Bancar,
	Clp_SubBan	= @Clp_SubBan,
	Clp_Fideic	= @Clp_Fideic,
	Clp_TipSoc	= @Clp_TipSoc,
	Clp_NomSoc	= @Clp_NomSoc,
	Clp_EntFin	= @Clp_EntFin,
	Clp_UsBuCr	= @Clp_UsBuCr,
	Clp_LocINE	= @Clp_LocINE,
	Clp_EntINE	= @Clp_EntINE
	where	Clp_NumPer	= @Clp_NumPer

	select	Err_Codigo	= '000000', 
			Err_Mensaj	= 'Registro Modificado'
end
