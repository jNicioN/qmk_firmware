create procedure SOEMPNOMPRO (
	@Per_Numero	char(8),
	@Per_Fecha	smalldatetime,
	@Per_NumTra	char(10),
	@Per_Tipo	char(1),
	@Per_NuSeFi	varchar(30),
	@Per_Titulo	varchar(10),
	@Per_Nombre	varchar(40),
	@Per_ApePat	varchar(40),
	@Per_ApeMat	varchar(40),
	@Per_RazSoc	varchar(180),	
	@Per_RFC	varchar(15),
	@Per_CURP	varchar(18),
	@Per_Benefi	char(1),
	@Per_Calle	varchar(40),
	@Per_CalNum	varchar(10),
	@Per_Coloni	varchar(150),
	@Per_Entida	char(3),
	@Per_Locali	char(8),
	@Per_CodPos	char(6),
	@Per_ApaPos	char(6),
	@Per_LadTel	varchar(8),
	@Per_Telefo char(15),
	@Per_Email	varchar(50),
	@Per_ComDom	char(1),
	@Per_EstCiv	varchar(20),
	@Per_Nacion	char(3),
	@Per_ActEmp char(1),
	@Per_Giro	char(30),
	@Per_Sector	char(3),
	@Per_Activi	char(10),
	@Per_TipPar	char(1),
	@Adi_LugNac	varchar(50),
	@Adi_Sexo	char(1),
	@Adi_FecNac	smalldatetime,
	@Adi_RegMat	char(1),
	@Adi_VivCas	char(1),
	@Adi_TieRes	int,
	@Adi_Fax    varchar(20),
	@Adi_NumDep	int,
	@Adi_Puesto	varchar(50),
	@Adi_Ocupac	varchar(50),
	@Adi_AntLab	int,
	@Adi_LugTra	varchar(50),
	@Adi_TelTra	varchar(20),
	@Adi_CalTra	varchar(20),
	@Adi_NuCaTr	varchar(30),
	@Adi_ColTra	varchar(50),
	@Adi_Locali	char(8),
	@Adi_CPTra	varchar(50),
	@Adi_FecCon	smalldatetime,
	@Adi_CaNuIn	varchar(10),
	@Adi_NacExt	char(1),
	@Adi_Reside	char(1),
	@Adi_DocEst	char(3),
	@Adi_OtDoEs	varchar(50),
	@Adi_FeExDo	smalldatetime,
	@Adi_CalInm	char(1),
	@Adi_CalExt	varchar(40),
	@Adi_CaNuEx	varchar(10),
	@Adi_ColExt	varchar(150),
	@Adi_LocExt	varchar(40),
	@Adi_EntExt	varchar(40),
	@Adi_PaiExt	varchar(3),
	@Adi_CoPoEx	char(6),
	@Adi_TelExt	varchar(20),
	@Adi_TipIde	char(1),
	@Adi_OtrIde	varchar(50),
	@Adi_NumIde	varchar(30),
	@Adi_FeExId	smalldatetime,
	@Adi_FeVeId	smalldatetime,
	@Adi_NuIdFi	varchar(20),
	@Adi_EntPri varchar(40), 
	@Adi_EntSeg varchar(40),
	@Adi_TelCel char(20),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))

as
/***************************************************************************
** Descripcion: Actualiza la información de un empleado de nomina 		****
**				para el apartado de direccion							****
****************************************************************************
** Referencias:															****
****************************************************************************
** Modificó:	Jose Francisco Romero Celis								****
** Fecha:		08/Octubre/2020											****
** Help:		01137159												****
**Descripcion:	Modificacion de información de personas unicas y 		****
**				clientes												****
****************************************************************************/

/*	Declaracion de Variables	 */
declare	@Status		int						/* Status */				

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),				/* String Vacio	*/
		@Ent_Cero	int

/* Asignación de constantes 	*/
select	@Str_Vacio	= '',					/* String Vacio	*/
		@Ent_Cero	= 0				/* Entero Cero */

/*Inician validaciones*/
if not exists (	select	Per_Numero
					from SOPERSON noholdlock
					where	Per_Numero	= @Per_Numero ) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'La persona no existe'
	return 1
end

if isnull(@Adi_TelCel, @Str_Vacio) <> @Str_Vacio
begin
	update CLADICIO set
	Adi_TelCel	= @Adi_TelCel,

	NumTransac	= @NumTransac,
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= getdate(),
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
	where	Adi_NumPer	= @Per_Numero
	
end

	exec @Status =  SOPERUNIMOD
		@Per_Numero,	@Per_Fecha,		@Per_NumTra,	@Per_Tipo,		@Per_NuSeFi,
		@Per_Titulo,	@Per_Nombre,	@Per_ApePat,	@Per_ApeMat,	@Per_RazSoc,
		@Per_RFC,		@Per_CURP,		@Per_Benefi,	@Per_Calle,		@Per_CalNum,
		@Per_Coloni,	@Per_Entida,	@Per_Locali,	@Per_CodPos,	@Per_ApaPos,
		@Per_LadTel,	@Per_Telefo,	@Per_Email,		@Per_ComDom,	@Per_EstCiv,
		@Per_Nacion,	@Per_ActEmp,	@Per_Giro,		@Per_Sector,	@Per_Activi,
		@Per_TipPar,	@Adi_LugNac,	@Adi_Sexo,		@Adi_FecNac,	@Adi_RegMat,
		@Adi_VivCas,	@Adi_TieRes,	@Adi_Fax,		@Adi_NumDep,	@Adi_Puesto,
		@Adi_Ocupac,	@Adi_AntLab,	@Adi_LugTra,	@Adi_TelTra,	@Adi_CalTra,	
		@Adi_NuCaTr,	@Adi_ColTra,	@Adi_Locali,	@Adi_CPTra,		@Adi_FecCon,
		@Adi_CaNuIn,	@Adi_NacExt,	@Adi_Reside,	@Adi_DocEst,	@Adi_OtDoEs,
		@Adi_FeExDo,	@Adi_CalInm,	@Adi_CalExt,	@Adi_CaNuEx,	@Adi_ColExt,
		@Adi_LocExt,	@Adi_EntExt,	@Adi_PaiExt,	@Adi_CoPoEx,	@Adi_TelExt,
		@Adi_TipIde,	@Adi_OtrIde,	@Adi_NumIde,	@Adi_FeExId,	@Adi_FeVeId,
		@Adi_NuIdFi,	@Adi_EntPri,	@Adi_EntSeg,	@Str_Vacio,		@NumTransac,
		@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
		@Modulo
		
	if @Status <> @Ent_Cero
	begin

		rollback
		return 1

	end

select	Err_Codigo	= '000000',
		Err_Mensaj	= 'Registro Actualizado',
		Per_Numero	= @Per_Numero,
		Per_NumTra	= @Per_NumTra
