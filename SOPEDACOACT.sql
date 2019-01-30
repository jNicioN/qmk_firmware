create procedure SOPEDACOACT (
	@DaP_Person	char(8),
	@DaP_Firma	char(1),
	@DaP_CaNuIn	varchar(10),
	@DaP_FuPuPe	varchar(2),
	@DaP_NoFaPe	varchar(50),
	@DaP_ApPaPe	varchar(40),
	@DaP_ApMaPe	varchar(40),
	@DaP_EntBan	char(1),
	@DaP_EsPEP	char(1),
	@DaP_EsPaPE	char(1),
	@DaP_ParPEP varchar(2),
	@DaP_PaiNac char(3),
	@DaP_EntNac char(3),
	@DaP_CoVeDi char(1),
	@DaP_FolFid char(15),
	@DaP_TipFid char(1),
	@DaP_TiIdAd	char(1),
	@DaP_NuIdAd	varchar(30),
	@DaP_ExIdAd	smalldatetime,	
	@DaP_VeIdAd	smalldatetime,
	@DaP_ClvEle char(18),
	@DaP_NumEmi char(2),
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
** DESCRIPCION: Modificación de Datos Complementarios de Persona		****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Moidfico:	Esthepny Aguilar										****
** Fecha:		18/09/2018												****
** Help:		1134677													****
** Descripcion: Se agrega modificacion A para modificar los campos de 	****
** DaP_NumEmi, DaP_ClvEle, DaP_EntNac									****
****************************************************************************
** Creó:		Armando Alexis Sepúlveda Cruz							****
** Fecha:		24/Jul/2018												****
** Help:		1088831													****
***************************************************************************/

/* Declaración de Variables */
declare	@Per_Numero	char(8)	/* Persona Numero */

/* Declaración de Constantes */
declare	@Str_Vacio	char(1),
		@Tip_ClvNum	char(1),
		@Tip_AcualA char(1)				

select	@Str_Vacio	= '',	/*String Vacio*/
		@Tip_ClvNum = '1',	/*Tipo de Actualización de Clave Elector y Número de Emision*/
		@Tip_AcualA = 'A'	/* Tipo de actualizacion A*/

/* Validar Número de Cliente */
select	@Per_Numero	= DaP_Person
	from SOPEDACO noholdlock
	where	DaP_Person	= @DaP_Person

select	@Per_Numero	= isnull(@Per_Numero, @Str_Vacio)

if @Per_Numero = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'No existen Datos Complementarios de la Persona'
	rollback
	return 1
end
	
if @Tip_Actual = @Tip_ClvNum begin	/* Modificar Clave Elector y Número de Emision */
	update SOPEDACO set
		DaP_ClvEle	= @DaP_ClvEle,	
		DaP_NumEmi	= @DaP_NumEmi,
	
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	 where	DaP_Person	= @DaP_Person
end
if @Tip_Actual = @Tip_AcualA begin /* A Modifica  Clave Elector, Número de Emision y Entidad de Nacimiento */
	update SOPEDACO set
		DaP_ClvEle	= @DaP_ClvEle,	
		DaP_NumEmi	= @DaP_NumEmi,
		DaP_EntNac  = @DaP_EntNac
	where	DaP_Person	= @DaP_Person
end