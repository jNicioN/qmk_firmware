create procedure SOCLCAPEALT (
	@Clp_NumPer	char(8),
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
/* DESCRIPCION: ** Alta de Clasificacin de Cartera de Personas **		*/
/**************************************************************************/
/* REFERENCIAS:															***/
/****************************************************************************
** Modific:		Javier Eduardo Ceron Rangel								****
** Fecha:		16/06/2025												****
** Help:		58967													****
** Descripciónn:	Se agrega validacion para no permitir altas			****
** de personas diferentes de PM											****
****************************************************************************
** Modificó:		Marcelo Bautista Hernandez					****
** Fecha:		22/Junio/2015								****
** Help:			746062										****
** Descripción	si ya existe se modifica						****
****************************************************************************
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
declare @Per_Tipo char(1),
		@Status		int

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Per_Fisica	char(1),
		@Str_Si		char(1),
		@Ent_Cero	int,
		@Ent_Uno	int

select	@Str_Vacio	= '',
		@Per_Fisica	= '2',			/* Persona Fisica */
		@Str_Si		= 'S',
		@Ent_Cero	= 0,
		@Ent_Uno	= 1


select @Per_Tipo = Per_Tipo
from SOPERSON noholdlock
where Per_Numero = @Clp_NumPer

if	@Per_Tipo	!= @Str_Vacio begin	
	if @Per_Tipo = @Per_Fisica and @Clp_Fideic = @Str_Si begin
		select	Err_Codigo	= '000001', 
				Err_Mensaj  = 'Error de Dato Fideicomiso, no esta permitido dar de alta fideicomiso para PF/PFAE', 
				Err_Variab	= 'Clp_Fideic'
		rollback
		return 1
	end
end


select	@Clp_EntFin	= Tis_EntFin
	from	CLTIPSOC noholdlock
	where	Tis_Numero	= @Clp_TipSoc

select	@Clp_EntFin = isnull(@Clp_EntFin,'')

if not exists(select Clp_NumPer
				from SOCLCAPE noholdlock
				where	Clp_NumPer	= @Clp_NumPer) begin
					
insert into SOCLCAPE values (@Clp_NumPer,	@Clp_InsReg,	@Clp_OtoCre,	@Clp_Bancar,	@Clp_SubBan,
	@Clp_Fideic,	@Clp_TipSoc,	@Clp_NomSoc,	@Clp_UsBuCr,	@Clp_EntFin,
	@Clp_LocINE,	@Clp_EntINE,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino)
	
end else begin
	
	exec @Status =  SOCLCAPEMOD
		@Clp_NumPer,	@Clp_InsReg,	@Clp_OtoCre,	@Clp_Bancar,	@Clp_SubBan,
		@Clp_Fideic,	@Clp_TipSoc,	@Clp_NomSoc,	@Clp_EntFin,	@Clp_UsBuCr,
		@Clp_LocINE,	@Clp_EntINE,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

	if @Status <> @Ent_Cero begin
		rollback
		return @Ent_Uno
	end	
	
end
select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Agregado'
