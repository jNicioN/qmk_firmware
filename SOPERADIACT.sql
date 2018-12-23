create procedure SOPERADIACT (
	@Adi_Grupo	char(8),
	@Adi_PerNum	char(8),
	@Adi_TipIde	char(1),
	@Adi_NumIde	varchar(30),
	@Tip_Actual	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/****************************************************************************/
/* DESCRIPCION: ** Persona Adicional Actualización **						*/
/****************************************************************************/
/** REFERENCIAS:
****************************************************************************
** Creó:		Karla Dosal												****
** Fecha:		25/Oct/2018												****
** Help Desk:	1115891													****
** Descripción: Actualización de datos adicionales de la persona		****
****************************************************************************
*/

/*	Declaracion de Variables	*/
declare	@Status		int,
		@Bit_Fecha	smalldatetime,
		@Bit_NumTra	char(10),
		@Bit_LugNac	varchar(50),
		@Bit_Sexo	char(1),
		@Bit_FecNac	smalldatetime,
		@Bit_RegMat	char(1),
		@Bit_VivCas	char(1),
		@Bit_TieRes	int,
		@Bit_Fax    varchar(20),
		@Bit_NumDep	int,
		@Bit_Puesto	varchar(50),
		@Bit_Ocupac	varchar(50),
		@Bit_AntLab	int,
		@Bit_LugTra	varchar(50),
		@Bit_TelTra	varchar(20),
		@Bit_CalTra	varchar(20),
		@Bit_NuCaTr	varchar(30),
		@Bit_ColTra	varchar(50),
		@Bit_Locali	char(8),
		@Bit_CPTra	varchar(50),
		@Bit_FecCon	smalldatetime,
		@Bit_CaNuIn	varchar(10),
		@Bit_NacExt	char(1),
		@Bit_Reside char(1),
		@Bit_DocEst	char(3),
		@Bit_OtDoEs varchar(50),
		@Bit_FeExDo	smalldatetime,
		@Bit_CalInm	char(1),
		@Bit_CalExt	varchar(40),
		@Bit_CaNuEx	varchar(10),
		@Bit_ColExt	varchar(150),
		@Bit_LocExt	varchar(40),
		@Bit_EntExt	varchar(40),
		@Bit_PaiExt	varchar(3),
		@Bit_CoPoEx	char(6),
		@Bit_TipIde	char(1),
		@Bit_OtrIde	varchar(50),
		@Bit_NumIde	varchar(30),
		@Bit_FeExId	smalldatetime,
		@Bit_FeVeId	smalldatetime,
		@Bit_NuIdFi	varchar(20),
		@Bit_EntPri char(40),
		@Bit_EntSeg char(40)

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),
		@Act_DatINE	char(1)

select	@Str_Vacio	= '',			/*	String: Vacio				*/
		@Act_DatINE	= 'I'			/*	Actualización: Datos INE	*/

select	@Adi_Grupo	= isnull(@Adi_Grupo, @Str_Vacio),
		@Adi_PerNum	= isnull(@Adi_PerNum, @Str_Vacio),
		@Adi_TipIde	= isnull(@Adi_TipIde, @Str_Vacio),
		@Adi_NumIde	= isnull(@Adi_NumIde, @Str_Vacio),
		@Tip_Actual	= isnull(@Tip_Actual, @Str_Vacio)

if @Tip_Actual = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Tipo de actualización inválida.'
	rollback
	return 1	
end

/*	Antes de actualizar se envía a la bitácora	*/
select	@Bit_Fecha	= Adi_Fecha,
		@Bit_NumTra	= Adi_NumTra,
		@Bit_LugNac	= Adi_LugNac,
		@Bit_Sexo	= Adi_Sexo,
		@Bit_FecNac	= Adi_FecNac,
		@Bit_RegMat	= Adi_RegMat,
		@Bit_VivCas	= Adi_VivCas,
		@Bit_TieRes	= Adi_TieRes,
		@Bit_Fax	= Adi_Fax,
		@Bit_NumDep	= Adi_NumDep,
		@Bit_Puesto	= Adi_Puesto,
		@Bit_Ocupac	= Adi_Ocupac,
		@Bit_AntLab	= Adi_AntLab,
		@Bit_LugTra	= Adi_LugTra,
		@Bit_TelTra	= Adi_TelTra,
		@Bit_CalTra	= Adi_CalTra,
		@Bit_NuCaTr	= Adi_NuCaTr,
		@Bit_ColTra	= Adi_ColTra,
		@Bit_Locali	= Adi_Locali,
		@Bit_CPTra	= Adi_CPTra,
		@Bit_FecCon	= Adi_FecCon,
		@Bit_CaNuIn	= Adi_CaNuIn,
		@Bit_NacExt	= Adi_NacExt,
		@Bit_Reside	= Adi_Reside,
		@Bit_DocEst	= Adi_DocEst,
		@Bit_OtDoEs	= Adi_OtDoEs,
		@Bit_FeExDo	= Adi_FeExDo,
		@Bit_CalInm	= Adi_CalInm,
		@Bit_CalExt	= Adi_CalExt,
		@Bit_CaNuEx	= Adi_CaNuEx,
		@Bit_ColExt	= Adi_ColExt,
		@Bit_LocExt	= Adi_LocExt,
		@Bit_EntExt	= Adi_EntExt,
		@Bit_PaiExt	= Adi_PaiExt,
		@Bit_CoPoEx	= Adi_CoPoEx,
		@Bit_TipIde	= Adi_TipIde,
		@Bit_OtrIde	= Adi_OtrIde,
		@Bit_NumIde	= Adi_NumIde,
		@Bit_FeExId	= Adi_FeExId,
		@Bit_FeVeId	= Adi_FeVeId,
		@Bit_NuIdFi	= Adi_NuIdFi,
		@Bit_EntPri	= Adi_EntPri,
		@Bit_EntSeg	= Adi_EntSeg
	from SOPERADI noholdlock
	where	Adi_PerNum	= @Adi_PerNum

exec @Status =	SOBIPEADALT
			@Adi_PerNum,	@Bit_Fecha,		@Bit_NumTra,	@Bit_LugNac,	@Bit_Sexo,
			@Bit_FecNac,	@Bit_RegMat,	@Bit_VivCas,	@Bit_TieRes,	@Bit_Fax,
			@Bit_NumDep,    @Bit_Puesto,	@Bit_Ocupac,	@Bit_AntLab,	@Bit_LugTra,
			@Bit_TelTra,	@Bit_CalTra,	@Bit_NuCaTr,	@Bit_ColTra,	@Bit_Locali,
			@Bit_CPTra,		@Bit_FecCon,	@Bit_CaNuIn,	@Bit_NacExt,	@Bit_Reside,
			@Bit_DocEst,	@Bit_OtDoEs,	@Bit_FeExDo,	@Bit_CalInm,	@Bit_CalExt,
			@Bit_CaNuEx,	@Bit_ColExt,	@Bit_LocExt,	@Bit_EntExt,	@Bit_PaiExt,
			@Bit_CoPoEx,	@Bit_TipIde,	@Bit_OtrIde,	@Bit_NumIde,	@Bit_FeExId,
			@Bit_FeVeId,	@Bit_NuIdFi,	@Bit_EntPri,	@Bit_EntSeg,	@NumTransac,
			@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,
			@Modulo

if @Status <> 0 begin
	rollback
	return 1
end

if @Tip_Actual = @Act_DatINE begin
	if	@Adi_TipIde = @Str_Vacio begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Proporcione el tipo de identificación'
		rollback
		return 1
	end
	
	if	@Adi_NumIde = @Str_Vacio begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Proporcione número de identificación'
		rollback
		return 1
	end
	
	update SOPERADI
		set	Adi_TipIde	= @Adi_TipIde,
			Adi_NumIde	= @Adi_NumIde,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where	Adi_PerNum	= @Adi_PerNum
end

if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Actualizado'
