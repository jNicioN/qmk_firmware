create procedure SOPERSONPRO (
	@Per_Numero	char(8),
	@Per_CURP	varchar(18),
	@Peu_Grupo	char(8),
	@Adi_TipIde	char(1),
	@Adi_NumIde	varchar(30),
	@Adi_FeExId	smalldatetime,
	@DaP_ClvEle	char(18),
	@DaP_NumEmi	char(2),
	@Adi_FecNac	smalldatetime,
	@Adi_Sexo	char(1),
	@DaP_EntNac	char(3),
	@DaP_PaiNac	char(3),
	@Adi_FeVeId	smalldatetime,
	@Per_Email	varchar(50),
	@Tip_Proces	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo char(2))
	
as

/*******************************************************************/
/* DESCRIPCION: Personas (Proceso)						  		   */
/*******************************************************************/
/** REFERENCIAS:
********************************************************************
** Modificó:	Angel Cisneros               					****
** Fecha:		04/Ene/2019										****
** Help:		01138771										****
** Descripción:	Crear proceso de actualización para documentos  ****
**              para autenticacion de persona 					****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		04/Dic/2018										****
** Help:		01171269										****
** Descripción:	Crear proceso de actualización de Per_Email		****
**				por persona 									****
********************************************************************
** Modificó:	Karla Dosal										****
** Fecha:		16/Nov/2018										****
** Help:		1115891											****
** Descripción:	Se agrega llamada a SOPERADIACT para el tipo de	****
**				proceso de INE, utilizado en fábrica			****
********************************************************************
** Modificó:	Francisco Javier Carrillo Rojas					****
** Fecha:		14/Nov/2018										****
** Help:		01145227										****
** Descripción:	No actualizar Adi_TipIde y Adi_NumIde cuando se ****
**				envía datos de una persona que será considerada ****
**				como extranjera									****
********************************************************************
** Creó:		Marcelo Bautista Hernandez						****
** Fecha:		30/Octubre/2018									****
** Help:		1147468											****
** Descripción:	Proceso para actualizar datos tanto en SOPERSON,****
**				SOPEDACO y SOPERADI								****
********************************************************************
*/

declare	@Status		int,					/*	Declaracion de Variables	*/
		@Str_PerNum	char(8),
		@Bit_NumPer	char(8),
		@Bit_Fecha	smalldatetime,
		@Bit_NumTra	char(10),
		@Bit_Tipo	char(1),
		@Bit_NuSeFi	varchar(30),
		@Bit_Titulo	varchar(10),
		@Bit_Nombre	varchar(40),
		@Bit_ApePat	varchar(40),
		@Bit_ApeMat	varchar(40),
		@Bit_RazSoc	varchar(180),
		@Bit_Comple	varchar(180),
		@Bit_ComOrd	varchar(180),
		@Bit_RFC	char(15),
		@Bit_CURP	char(18),
		@Bit_Calle	char(40),
		@Bit_CalNum	varchar(10),
		@Bit_Coloni	varchar(150),
		@Bit_Entida	char(3),
		@Bit_Locali	char(8),
		@Bit_CodPos	char(6),
		@Bit_ApaPos	char(6),
		@Bit_LadTel	varchar(5),
		@Bit_Telefo	char(15),
		@Bit_Email	varchar(50),
		@Bit_ComDom	char(1),
		@Bit_EstCiv	varchar(20),
		@Bit_Nacion	char(3),
		@Bit_ActEmp	char(1),
		@Bit_Giro	char(30),
		@Bit_Sector	char(3),
		@Bit_Activi	char(10),
		@Bit_ActINE	varchar(10),
		@Adi_NacExt char(1)
	
declare	@Str_Vacio	char(1),				/*	Declaracion de Constantes	*/
		@Ent_Cero	int,
		@Fec_Vacia	smalldatetime,
		@Tip_Renapo	char(1),
		@Tip_ProIne	char(1),
		@Tip_Email	char(1),
		@Ent_LonCur	smallint,
		@Pai_Mexico	char(3),
		@Nac_Nacion	char(1),
		@Nac_Extran	char(1),
		@Ent_Uno	int

select	@Str_Vacio	= '',					/*	String Vacio				*/
		@Ent_Cero	= 0,					/*	Entero: Cero				*/
		@Fec_Vacia	= '1900-01-01',			/*	Fecha Vacía					*/
		@Tip_Renapo	= 'A',					/*	Tipo proceso para actualizar datos requeridos para RENAPO */
		@Tip_ProIne	= 'I',					/*	Tipo proceso para actualizar datos INE	*/
		@Tip_Email	= 'C',					/*	Tipo proceso para actualizar email  */
		@Ent_LonCur	= 18,					/*	Longitud CURP	*/
		@Pai_Mexico	= '001',				/*	País de nacimiento México */
		@Nac_Nacion	= 'N',					/*	Nacionalidad: Nacional */
		@Nac_Extran	= 'E',					/*	Nacionalidad: Extranjejo */
		@Ent_Uno	= 1						/*	Entero en uno */

if @Tip_Proces = @Tip_Renapo begin
	if len(rtrim(ltrim(@Per_CURP))) <> @Ent_LonCur begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'La CURP no es válido'
		rollback
		return 1
	end
	
	insert into SOBITPER (
			Bit_NumPer,	Bit_Fecha,	Bit_NumTra,	Bit_TipPer,	Bit_NuSeFi,
			Bit_Titulo,	Bit_Nombre,	Bit_ApePat,	Bit_ApeMat,	Bit_RazSoc,
			Bit_Comple,	Bit_ComOrd,	Bit_RFC,	Bit_CURP,	Bit_Calle,
			Bit_CalNum,	Bit_Coloni,	Bit_Entida,	Bit_Locali,	Bit_CodPos,
			Bit_ApaPos,	Bit_LadTel,	Bit_Telefo,	Bit_Email,	Bit_ComDom,
			Bit_EstCiv,	Bit_Nacion,	Bit_ActEmp,	Bit_Giro,	Bit_Sector,
			Bit_Activi,	Bit_ActINE,	NumTransac,	Transaccio,	Usuario,
			FechaSis,	SucOrigen,	SucDestino)
	
	select	Per_Numero, Per_Fecha, Per_NumTra,	Per_Tipo, Per_NuSeFi,
			Per_Titulo, Per_Nombre, Per_ApePat,	Per_ApeMat, Per_RazSoc,
			Per_Comple, Per_ComOrd, Per_RFC,	Per_CURP, Per_Calle,
			Per_CalNum, Per_Coloni, Per_Entida, Per_Locali, Per_CodPos,
			Per_ApaPos, Per_LadTel, Per_Telefo, Per_Email, Per_ComDom,
			Per_EstCiv, Per_Nacion, Per_ActEmp, Per_Giro, Per_Sector,
			Per_Activi, Per_ActINE, per.NumTransac, per.Transaccio, per.Usuario,
			per.FechaSis, per.SucOrigen, per.SucDestino
	from SOUNIPER uni noholdlock
		 inner join SOPERSON per noholdlock on Peu_Person=Per_Numero
	where	Peu_Grupo	= @Peu_Grupo
	
	update SOPERSON set
		Per_CURP	= @Per_CURP,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from SOUNIPER noholdlock
		 inner join SOPERSON noholdlock on Peu_Person=Per_Numero
	where	Peu_Grupo	= @Peu_Grupo

	insert into SOBIPEAD  (
		Bit_PerNum,	Bit_Fecha,	Bit_NumTra,	Bit_LugNac,	Bit_Sexo,
		Bit_FecNac,	Bit_RegMat,	Bit_VivCas,	Bit_TieRes,	Bit_Fax,
		Bit_NumDep,	Bit_Puesto,	Bit_Ocupac,	Bit_AntLab,	Bit_LugTra,
		Bit_TelTra,	Bit_CalTra,	Bit_NuCaTr,	Bit_ColTra,	Bit_Locali,
		Bit_CPTra,	Bit_FecCon,	Bit_CaNuIn,	Bit_NacExt,	Bit_Reside,
		Bit_DocEst,	Bit_OtDoEs,	Bit_FeExDo,	Bit_CalInm,	Bit_CalExt,	
		Bit_CaNuEx,	Bit_ColExt,	Bit_LocExt,	Bit_EntExt,	Bit_PaiExt,	
		Bit_CoPoEx,	Bit_TipIde,	Bit_OtrIde,	Bit_NumIde,	Bit_FeExId,	
		Bit_FeVeId,	Bit_NuIdFi,	Bit_EntPri,	Bit_EntSeg,	NumTransac,
		Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
	
	select	Adi_PerNum, Adi_Fecha, Adi_NumTra, Adi_LugNac, Adi_Sexo,
		Adi_FecNac, Adi_RegMat, Adi_VivCas, Adi_TieRes, Adi_Fax,
		Adi_NumDep, Adi_Puesto, Adi_Ocupac, Adi_AntLab, Adi_LugTra,
		Adi_TelTra, Adi_CalTra, Adi_NuCaTr, Adi_ColTra, Adi_Locali,
		Adi_CPTra, Adi_FecCon, Adi_CaNuIn, Adi_NacExt, Adi_Reside,
		Adi_DocEst, Adi_OtDoEs, Adi_FeExDo, Adi_CalInm, Adi_CalExt,
		Adi_CaNuEx, Adi_ColExt, Adi_LocExt, Adi_EntExt, Adi_PaiExt,
		Adi_CoPoEx, Adi_TipIde, Adi_OtrIde, Adi_NumIde, Adi_FeExId,
		Adi_FeVeId, Adi_NuIdFi, Adi_EntPri, Adi_EntSeg, per.NumTransac,
		per.Transaccio, per.Usuario, per.FechaSis, per.SucOrigen, per.SucDestino
	from SOUNIPER uni noholdlock
		 inner join SOPERADI per noholdlock on Peu_Person= Adi_PerNum 
	where	Peu_Grupo	= @Peu_Grupo
	
	/* Se considera la nacionalidad	que será asignada para no sobreescribir el tipo, el número, la fecha de expedición y vencimiento de la identificación usada en la captura de la persona cuando es extranjero */
	if @DaP_PaiNac = @Pai_Mexico begin
		select	@Adi_NacExt	= @Nac_Nacion
		
		update SOPERADI set
			Adi_FecNac	= @Adi_FecNac,
			Adi_Sexo	= @Adi_Sexo,
			Adi_NumIde	= @Adi_NumIde,
			Adi_TipIde	= @Adi_TipIde,
			Adi_FeExId	= @Adi_FeExId,
			Adi_FeVeId	= @Adi_FeVeId,
			Adi_NacExt	= @Adi_NacExt,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		from SOUNIPER noholdlock
			 inner join SOPERADI noholdlock on Peu_Person= Adi_PerNum 
		where	Peu_Grupo	= @Peu_Grupo
		
	end else begin
		select	@Adi_NacExt	= @Nac_Extran
		
		update SOPERADI set
			Adi_FecNac	= @Adi_FecNac,
			Adi_Sexo	= @Adi_Sexo,
			Adi_NacExt	= @Adi_NacExt,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		from SOUNIPER noholdlock
			 inner join SOPERADI noholdlock on Peu_Person= Adi_PerNum 
		where	Peu_Grupo	= @Peu_Grupo		
	end


	insert into SOPEDACO (
		DaP_Person, DaP_Firma, DaP_CaNuIn, DaP_EsPEP, DaP_FuPuPe,
		DaP_EsPaPE, DaP_ParPEP, DaP_NoFaPe, DaP_ApPaPe, DaP_ApMaPe,
		DaP_EntBan, DaP_PaiNac, DaP_EntNac, DaP_CoVeDi, DaP_FolFid,
		DaP_TipFid, DaP_TiIdAd, DaP_NuIdAd, DaP_ExIdAd, DaP_VeIdAd,
		DaP_ClvEle, DaP_NumEmi, NumTransac, Transaccio, Usuario,
		FechaSis, SucOrigen, SucDestino )
	select	Peu_Person,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@DaP_PaiNac,	@DaP_EntNac,	@Str_Vacio,		@Str_Vacio,
			@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
			@DaP_ClvEle,	@DaP_NumEmi,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino
	from SOUNIPER noholdlock
	left join SOPEDACO noholdlock on Peu_Person = DaP_Person
	where	Peu_Grupo	= @Peu_Grupo
	  and	DaP_Person is null

	--Exranjero, no actualizamos información ligada al INE/IFE
	if @DaP_PaiNac = @Pai_Mexico begin
		update SOPEDACO set
			DaP_PaiNac	= @DaP_PaiNac,
			DaP_EntNac	= @DaP_EntNac,
			DaP_ClvEle	= @DaP_ClvEle,	
			DaP_NumEmi	= @DaP_NumEmi,

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		from SOUNIPER noholdlock
			 inner join SOPEDACO noholdlock on Peu_Person = DaP_Person
		where	Peu_Grupo	= @Peu_Grupo
	end else begin
		update SOPEDACO set
			DaP_PaiNac	= @DaP_PaiNac,
			DaP_EntNac	= @DaP_EntNac,

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		from SOUNIPER noholdlock
			 inner join SOPEDACO noholdlock on Peu_Person = DaP_Person
		where	Peu_Grupo	= @Peu_Grupo		
	end	
	
end

if @Tip_Proces = @Tip_ProIne begin
	/* Agrega a la bitácora de SOPERSON */
	select	@Bit_NumPer	= Per_Numero,
			@Bit_Fecha	= Per_Fecha,
			@Bit_NumTra	= Per_NumTra,
			@Bit_Tipo	= Per_Tipo,
			@Bit_NuSeFi	= Per_NuSeFi,
			@Bit_Titulo	= Per_Titulo,
			@Bit_Nombre	= Per_Nombre,
			@Bit_ApePat	= Per_ApePat,
			@Bit_ApeMat	= Per_ApeMat,
			@Bit_RazSoc	= Per_RazSoc,
			@Bit_Comple	= Per_Comple,
			@Bit_ComOrd	= Per_ComOrd,
			@Bit_RFC	= Per_RFC,
			@Bit_CURP	= Per_CURP,
			@Bit_Calle	= Per_Calle,
			@Bit_CalNum	= Per_CalNum,
			@Bit_Coloni	= Per_Coloni,
			@Bit_Entida	= Per_Entida,
			@Bit_Locali	= Per_Locali,
			@Bit_CodPos	= Per_CodPos,
			@Bit_ApaPos	= Per_ApaPos,
			@Bit_LadTel	= Per_LadTel,
			@Bit_Telefo	= Per_Telefo,
			@Bit_Email	= Per_Email,
			@Bit_ComDom	= Per_ComDom,
			@Bit_EstCiv	= Per_EstCiv,
			@Bit_Nacion	= Per_Nacion,
			@Bit_ActEmp	= Per_ActEmp,
			@Bit_Giro	= Per_Giro,
			@Bit_Sector	= Per_Sector,
			@Bit_Activi	= Per_Activi,
			@Bit_ActINE	= Per_ActINE
		from SOPERSON noholdlock
		where	Per_Numero = @Per_Numero
	
	exec @Status = SOBITPERALT
			@Bit_NumPer,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
			@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
			@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
			@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
			@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
			@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
			@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
			@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end

	/* En SOPERSON actualiza el CURP */
	update SOPERSON
		set	Per_CURP	= @Per_CURP,
				
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where	Per_Numero	= @Per_Numero
	
	/* Se ejcuta el SOPERADIACT para actualizar el tipo de identificación y su número  */
	exec @Status = SOPERADIACT
				@Peu_Grupo,		@Per_Numero,	@Adi_TipIde,	@Adi_NumIde,	@Tip_ProIne,
				@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
				@SucDestino,	@Modulo

	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end

	/* Se ejcuta el SOPEDACOPRO para actualizar  */
	exec @Status = SOPEDACOPRO
				@Per_Numero,	@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Fec_Vacia,		@Fec_Vacia,
				@DaP_ClvEle,	@DaP_NumEmi,	@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end
end else if @Tip_Proces = @Tip_Email begin
	if @Per_Email = @Str_Vacio begin
		select	Err_Codigo	= '000001', 
				Err_Mensaj	= 'Debe capturar el correo electronico del cliente'
		rollback
		return 1
	end
	
	select	@Bit_NumPer	= Per_Numero,
			@Bit_Fecha	= Per_Fecha,
			@Bit_NumTra	= Per_NumTra,
			@Bit_Tipo	= Per_Tipo,
			@Bit_NuSeFi	= Per_NuSeFi,
			@Bit_Titulo	= Per_Titulo,
			@Bit_Nombre	= Per_Nombre,
			@Bit_ApePat	= Per_ApePat,
			@Bit_ApeMat	= Per_ApeMat,
			@Bit_RazSoc	= Per_RazSoc,
			@Bit_Comple	= Per_Comple,
			@Bit_ComOrd	= Per_ComOrd,
			@Bit_RFC	= Per_RFC,
			@Bit_CURP	= Per_CURP,
			@Bit_Calle	= Per_Calle,
			@Bit_CalNum	= Per_CalNum,
			@Bit_Coloni	= Per_Coloni,
			@Bit_Entida	= Per_Entida,
			@Bit_Locali	= Per_Locali,
			@Bit_CodPos	= Per_CodPos,
			@Bit_ApaPos	= Per_ApaPos,
			@Bit_LadTel	= Per_LadTel,
			@Bit_Telefo	= Per_Telefo,
			@Bit_Email	= Per_Email,
			@Bit_ComDom	= Per_ComDom,
			@Bit_EstCiv	= Per_EstCiv,
			@Bit_Nacion	= Per_Nacion,
			@Bit_ActEmp	= Per_ActEmp,
			@Bit_Giro	= Per_Giro,
			@Bit_Sector	= Per_Sector,
			@Bit_Activi	= Per_Activi,
			@Bit_ActINE	= Per_ActINE
		from SOPERSON noholdlock
		where	Per_Numero = @Per_Numero
		
	exec @Status = SOBITPERALT
		@Bit_NumPer,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
		@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
		@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
		@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
		@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
		@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
		@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end
	
	update SOPERSON set
		Per_Email	= @Per_Email,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	from SOUNIPER noholdlock
	where	Per_Numero	= @Per_Numero

end

if @Tip_Proces = 'D' begin        /*Actualizacion de doctos para autenticacion de personas */	
	select @Peu_Grupo =  Peu_Grupo 
	from SOUNIPER noholdlock
	where  Peu_Person  = @Per_Numero
	
	
	/*Se guarda en bitacora la informacion a actualizar*/	
	insert into SOBIPEAD  (
		Bit_PerNum,	Bit_Fecha,	Bit_NumTra,	Bit_LugNac,	Bit_Sexo,
		Bit_FecNac,	Bit_RegMat,	Bit_VivCas,	Bit_TieRes,	Bit_Fax,
		Bit_NumDep,	Bit_Puesto,	Bit_Ocupac,	Bit_AntLab,	Bit_LugTra,
		Bit_TelTra,	Bit_CalTra,	Bit_NuCaTr,	Bit_ColTra,	Bit_Locali,
		Bit_CPTra,	Bit_FecCon,	Bit_CaNuIn,	Bit_NacExt,	Bit_Reside,
		Bit_DocEst,	Bit_OtDoEs,	Bit_FeExDo,	Bit_CalInm,	Bit_CalExt,	
		Bit_CaNuEx,	Bit_ColExt,	Bit_LocExt,	Bit_EntExt,	Bit_PaiExt,	
		Bit_CoPoEx,	Bit_TipIde,	Bit_OtrIde,	Bit_NumIde,	Bit_FeExId,	
		Bit_FeVeId,	Bit_NuIdFi,	Bit_EntPri,	Bit_EntSeg,	NumTransac,
		Transaccio,	Usuario,	FechaSis,	SucOrigen,	SucDestino)
	
	select	Adi_PerNum, Adi_Fecha, Adi_NumTra, Adi_LugNac, Adi_Sexo,
		Adi_FecNac, Adi_RegMat, Adi_VivCas, Adi_TieRes, Adi_Fax,
		Adi_NumDep, Adi_Puesto, Adi_Ocupac, Adi_AntLab, Adi_LugTra,
		Adi_TelTra, Adi_CalTra, Adi_NuCaTr, Adi_ColTra, Adi_Locali,
		Adi_CPTra, Adi_FecCon, Adi_CaNuIn, Adi_NacExt, Adi_Reside,
		Adi_DocEst, Adi_OtDoEs, Adi_FeExDo, Adi_CalInm, Adi_CalExt,
		Adi_CaNuEx, Adi_ColExt, Adi_LocExt, Adi_EntExt, Adi_PaiExt,
		Adi_CoPoEx, Adi_TipIde, Adi_OtrIde, Adi_NumIde, Adi_FeExId,
		Adi_FeVeId, Adi_NuIdFi, Adi_EntPri, Adi_EntSeg, NumTransac,
		Transaccio, Usuario,    FechaSis,   SucOrigen,  SucDestino
	from SOPERADI noholdlock
	where	 Adi_PerNum 	= @Per_Numero
	or       Adi_PerNum     = @Peu_Grupo
	
	update SOPERADI set
		Adi_TipIde	= @Adi_TipIde,
        Adi_NumIde  = @Adi_NumIde,
        Adi_FeVeId  = @Adi_FeExId,
        
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Adi_PerNum = @Per_Numero
	
	/* Se ejcuta el SOPEDACOPRO para actualizar  */
	exec @Status = SOPEDACOPRO
				@Per_Numero,	@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
				@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Fec_Vacia,		@Fec_Vacia,
				@DaP_ClvEle,	@DaP_NumEmi,	@NumTransac,	@Transaccio,	@Usuario,
				@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	
	if @Status <> @Ent_Cero begin
		rollback
		return 1
	end
	
	if (@Peu_Grupo <> @Per_Numero)begin /*Si son diferentes personas, se actualiza la info tambien para persona unica*/
		/*Se guarda en bitacora la informacion a actualizar*/			
		update SOPERADI set
			Adi_TipIde	= @Adi_TipIde,
			Adi_NumIde  = @Adi_NumIde,
			Adi_FeVeId  = @Adi_FeExId,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where Adi_PerNum = @Peu_Grupo
		
		/* Se ejcuta el SOPEDACOPRO para actualizar  */
		exec @Status = SOPEDACOPRO
					@Peu_Grupo,	   @Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
					@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
					@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Str_Vacio,
					@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Fec_Vacia,		@Fec_Vacia,
					@DaP_ClvEle,	@DaP_NumEmi,	@NumTransac,	@Transaccio,	@Usuario,
					@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
		
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end	
	end 

end

if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Actualizado'