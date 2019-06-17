create procedure SOPEDACOPRO (
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

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: Procesa Datos Complementarios de Persona				****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modificó:	Armando Alexis Sepúlveda Cruz							****
** Fecha:		11/Jul/2018												****
** Help:		1088831 												****
** Descripción:	Se agregan campos:  DaP_TiIdAd, DaP_NuIdAd, DaP_ExIdAd	****
**				DaP_VeIdAd, DaP_ClvEle, DaP_NumEmi						****
****************************************************************************
** Creó:		Daniel Bautista											****
** Fecha:		18/Diciembre/2017										****
** Help:		1050138													****
***************************************************************************/

							/* Declaración de Variables */
declare	@Status		int,
		@Per_Numero	char(8),
		@DaP_ComVen char(1)

							/* Declaración de Constantes */
declare	@Str_Vacio	char(1)

							/* Asignación de valores a constantes 	*/
select	@Str_Vacio	= ''	/* String Vacio							*/

select @Per_Numero	= DaP_Person
	from SOPEDACO noholdlock
	where	DaP_Person	= @DaP_Person
	

select	@Per_Numero	= isnull(@Per_Numero, @Str_Vacio)

if @Per_Numero = @Str_Vacio begin
	exec @Status = SOPEDACOALT
		@DaP_Person,	@DaP_Firma,		@DaP_CaNuIn,	@DaP_FuPuPe,	@DaP_NoFaPe,
		@DaP_ApPaPe,	@DaP_ApMaPe,	@DaP_EntBan,	@DaP_EsPEP,		@DaP_EsPaPE,
		@DaP_ParPEP,	@DaP_PaiNac,	@DaP_EntNac,    @DaP_CoVeDi,	@DaP_FolFid,	
		@DaP_TipFid,	@DaP_TiIdAd, 	@DaP_NuIdAd, 	@DaP_ExIdAd, 	@DaP_VeIdAd,
		@DaP_ClvEle,	@DaP_NumEmi,    @NumTransac,	@Transaccio,	@Usuario,		
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end	
end else begin
	
	select 	@DaP_ComVen = DaP_CoVeDi
	from SOPEDACO noholdlock
	where	DaP_Person	= @DaP_Person
	
	exec @Status = SOPEDACOMOD
		@DaP_Person,	@DaP_Firma,		@DaP_CaNuIn,	@DaP_FuPuPe,	@DaP_NoFaPe,
		@DaP_ApPaPe,	@DaP_ApMaPe,	@DaP_EntBan,	@DaP_EsPEP,		@DaP_EsPaPE,
		@DaP_ParPEP,	@DaP_PaiNac,	@DaP_EntNac,    @DaP_CoVeDi,	@DaP_FolFid,	
		@DaP_TipFid,	@DaP_TiIdAd, 	@DaP_NuIdAd, 	@DaP_ExIdAd, 	@DaP_VeIdAd,
		@DaP_ClvEle,	@DaP_NumEmi,    @NumTransac,	@Transaccio,	@Usuario,		
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		rollback
		return 1
	end	
end
	
if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Datos Complementarios de Persona Registrados'
