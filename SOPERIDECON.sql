create procedure SOPERIDECON (
	@PerPersoID	int,
	@Per_Numero	char(8),
	@Per_Comple	varchar(181),
	@Per_Tipo	char(1),
	@Per_RFC	varchar(15),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION: Consulta de Personas por ID						****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Creo:		Ricardo de la Fuente							****
** Fecha:		27/Mar/2023										****
*******************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaracion de Constantes */
declare	@Str_C 		char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Sta_Si		char(1),
		@Sta_No		char(1)

/* Asignacion de Constantes */
select	@Str_C 		= 'C',			-- String C
		@Str_Uno	= '1',			-- String Uno
		@Str_Dos	= '2',			-- String Dos
		@Sta_Si		= 'S',			-- Status : Si
		@Sta_No		= 'N'			-- Status : No
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin			/*	Consulta persona Toda la info por ID*/
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn,	Adi_EntPri,	Adi_EntSeg, PerPersoID 
			into #Soperson
			from SOPERSON noholdlock
				 left join SOPERADI noholdlock on Per_Numero	= Adi_PerNum
			where	PerPersoID	=  @PerPersoID
			
		select	Per_Numero,	Per_Tipo,	Per_Benefi,	Per_NuSeFi,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_LadTel,	Per_Telefo,	Per_Email,	Per_ComDom,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_Fax,
				Adi_Puesto,	Adi_Ocupac,	Adi_LugTra,	Adi_TelTra,	Adi_CalTra,
				Adi_NuCaTr,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,	Adi_NacExt,
				Adi_DocEst,	Adi_FeExDo,	Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,
				Adi_ColExt,	Adi_LocExt,	Adi_EntExt,	Adi_PaiExt,	Adi_CoPoEx,
				Adi_TipIde,	Adi_OtrIde,	Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,
				Adi_NuIdFi,	Adi_TieRes,	Adi_NumDep,	Adi_AntLab,	Adi_FecCon,
				Adi_CaNuIn, PerPersoID
			from #Soperson
			order by  PerPersoID desc
		
		select	Per_Numero,	Adi_EntPri,	Adi_EntSeg
			from #Soperson

		drop table #Soperson
	end
	if @Tip_ConCon	= @Str_Dos begin			/* Consulta De Ejecutivo en Base A su ID */
		select	Per_Existe	= @Sta_Si,
				Eje_Existe	= @Sta_No,
				Per_Numero,	Per_Tipo,	Per_Titulo,	Per_Nombre,	Per_ApePat,
				Per_ApeMat,	Per_RazSoc,	Per_Comple,	Per_ComOrd,	Per_RFC,
				Per_CURP,	Per_Calle,	Per_CalNum,	Per_Coloni,	Per_Entida,
				Per_Locali,	Per_CodPos,	Per_ApaPos,	Per_Telefo,	Per_EstCiv,
				Per_Nacion,	Per_ActEmp,	Per_Giro,	Per_Sector,	Per_Activi,
				Per_ActINE,
				Eje_Extens	= space(4),
				Eje_Celula	= space(15),
				Eje_Depart	= space(50),
				Eje_Email	= space(20)
			into #Person
			from SOPERSON noholdlock  
			where	PerPersoID	= @PerPersoID

		update #Person set
			Eje_Existe	= @Sta_Si,
			#Person.Eje_Extens	= ABEJECUT.Eje_Extens,
			#Person.Eje_Celula	= ABEJECUT.Eje_Celula,
			#Person.Eje_Depart	= ABEJECUT.Eje_Depart,
			#Person.Eje_Email	= ABEJECUT.Eje_Email
			from ABEJECUT noholdlock
			where	Per_Numero	= Eje_Numero

		select	Per_Existe,	Eje_Existe,	Per_Numero,	Per_Tipo,	Per_Titulo,
				Per_Nombre,	Per_ApePat,	Per_ApeMat,	Per_RazSoc,	Per_Comple,
				Per_ComOrd,	Per_RFC,	Per_CURP,	Per_Calle,	Per_CalNum,
				Per_Coloni,	Per_Entida,	Per_Locali,	Per_CodPos,	Per_ApaPos,
				Per_Telefo,	Per_EstCiv,	Per_Nacion,	Per_ActEmp,	Per_Giro,
				Per_Sector,	Per_Activi,	Per_ActINE,	Eje_Extens,	Eje_Celula,
				Eje_Depart,	Eje_Email
			from #Person

		drop table #Person
	end
end