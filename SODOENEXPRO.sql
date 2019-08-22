create procedure SODOENEXPRO (
	@PerPersoID	int,
	@Dee_NumIde	char(2),
	@Dee_FolIde	varchar(25),
	@Dee_FecEmi	smalldatetime,
	@Dee_FecVen	smalldatetime,
	@Dee_Clave	varchar(18),
	@Dee_NumEmi	varchar(2),
	@Tip_Proces	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	
as

/* *****************************************************************
** DESCRIPCION: Proceso de documento de enrolamiento de extranjero**
********************************************************************
** Creó:		Francisco Javier Carrillo Rojas					****
** Fecha:		07/Ago/2019										****
** Help:		01278846										****
** Descripcion:	Proceso de documento de enrolamiento de extranjero**
********************************************************************/
/* Declaracion de Variables */

/* Declaracion de Constantes */
declare	@Tip_BajPer	char(1)

/* Asignacion de Constantes */
select	@Tip_BajPer	= '1'			/*	Proceso baja por persona ( masiva )*/
		
select	@FechaSis	= getdate()

if @Tip_Proces	= @Tip_BajPer begin
	delete from SODOENEX
		where	PerPersoID	= @PerPersoID
end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro(s) procesados'			