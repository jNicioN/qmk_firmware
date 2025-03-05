create procedure SOPERADICON (
	@Adi_PerNum char(8), 
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*
****************************************************************************
** 				STORE CONVERTIDO						****
****************************************************************************
** Modificó:		Angel Encalada										****
** Fecha:		05/marzo/2025											****
** Descripción:	Se agrega campo Adi_PerNum a consulta C1				****
** Help:			TCELNC-23481										****
****************************************************************************
** Modificó:		Marcelo Bautista									****
** Fecha:		12/Febrero/2016											****
** Descripción:	Se agrega campo Adi_TelExt a consulta C2				****
** Help:			801121												****
****************************************************************************
** Modificó:		Karina ChavarrÝa Tovar								****
** Fecha:		01/Octubre/2008											****
** Descripción:	Agregar campos Adi_EntPri y Adi_EntSeg					****
** Help:			100187												****
****************************************************************************
** 				STORE CONVERTIDO										****
** Fecha:		16/Agosto/2007											****
** Convirtió:		Karina ChavarrÝa Tovar								****
****************************************************************************
** Modificó:		Juan Mario Galindo de Leon							****
** Fecha:		05/Julio/07		  										****
** Descripción:	Agregar campos Adi_Reside y Adi_OtDoEs					****
** Help:			7100												****
****************************************************************************
** Modificó:		Lucina Gonzalez Trejo								****
** Fecha:		12/Marzo/07												****
** Descripción:	Agregar  C2												****
** Help:			3666												****
****************************************************************************
** Creó:			Rsalinas											****
** Fecha:		06/Ene/06												****
** Help:		       Fabirca de Creditos Comercial					****
****************************************************************************
*/

/* Cliente:  Visual Basic */

declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin				/* Consulta General */	
		select	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_RegMat,	Adi_VivCas,	
				Adi_TieRes,	Adi_Fax,    Adi_NumDep, Adi_Puesto, Adi_Ocupac,
				Adi_AntLab,	Adi_LugTra,	Adi_TelTra, Adi_CalTra,	Adi_NuCaTr,	
				Adi_CalTra,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,  Adi_FecCon,
				Adi_CaNuIn, Adi_PerNum 
			from SOPERADI noholdlock
			where 	Adi_PerNum = @Adi_PerNum		
	end	
	if @Tip_ConCon = '2' begin				/* Consulta General */	
		select	Adi_PerNum,	Adi_LugNac,	Adi_Sexo,	Adi_FecNac,	Adi_RegMat,
				Adi_VivCas,	Adi_TieRes,	Adi_Fax,    Adi_NumDep, Adi_Puesto,
				Adi_Ocupac,	Adi_AntLab,	Adi_LugTra,	Adi_TelTra, Adi_CalTra,
				Adi_NuCaTr,	Adi_CalTra,	Adi_ColTra,	Adi_Locali,	Adi_CPTra,
				Adi_FecCon,	Adi_CaNuIn,	Adi_NacExt, Adi_Reside,	Adi_DocEst,	
				Adi_OtDoEs, Adi_FeExDo, Adi_CalInm,	Adi_CalExt,	Adi_CaNuEx,	
				Adi_ColExt,	Adi_LocExt, Adi_EntExt, Adi_PaiExt,	Adi_CoPoEx,	
				Adi_TipIde,	Adi_OtrIde, Adi_NumIde,	Adi_FeExId,	Adi_FeVeId,	
				Adi_NuIdFi, Adi_EntPri, Adi_EntSeg,	Adi_TelExt
			from SOPERSON noholdlock,
				 SOPERADI noholdlock
			where	Per_Numero 	= Adi_PerNum
			  and	Adi_PerNum	= @Adi_PerNum
	end	
end
