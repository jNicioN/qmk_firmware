create procedure SOPERADIALT (
	@Adi_PerNum	char(8),
	@Adi_Fecha	smalldatetime,
	@Adi_NumTra	char(10),
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
	@Tip_Proces	char(2),
	@Cob_Tipo	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*****************************************************************************
** DESCRIPCION: **Alta de la Informacion Adicional de la Persona		  ****
******************************************************************************
** REFERENCIAS:															  
******************************************************************************
** 					STORE CONVERTIDO					                  ****
******************************************************************************
** Modificó:	Francisco Euan          						          ****
** Fecha:		14/Marzo/2025							                  ****
** Help:		TCELNC-23684								              ****
** Descripción:	Comprobación de valores para Adi_Sexo                     ****
******************************************************************************
** Modificó:	Marcelo Bautista Hernandez						          ****
** Fecha:		16/Junio/2015							                  ****
** Help:		774214										              ****
** Descripción:	asignar valor a @Adi_FecCon			                      ****
******************************************************************************
** Modificó:	Ignacio Ordaz Valtierra						              ****
** Fecha:		12/Sep/2012								                  ****
** Help:		386371										              ****
** Descripción:	Validar localidad este activo			                  ****
******************************************************************************
** Modificó:    Karina Chavarría Tovar						              ****
** Fecha:		26/Sep/2008								                  ****
** Descripción:	Agregar @Adi_EntPri, @Adi_EntSeg			              ****
** HelpDesk:	100187										              ****
******************************************************************************
** Modificó:	Gerardo Valladares							              ****
** Fecha:		25/Sep/07									              ****
** Descripción:	Agregar var Err_Descri						              ****
** Help:		3666										              ****
******************************************************************************
** 				STORE CONVERTIDO						                  ****
** Fecha:		21/Agosto/2007	  							              ****
** Convirtió:	Karina Chavarría Tovar						              ****
******************************************************************************
** Modificó:	Juan Mario Galindo de Leon					              ****
** Fecha:		05/Julio/07		  							              ****
** Descripción:	Agregar campos Adi_Reside y Adi_OtDoEs	                  ****
** Help:		7100										              ****
******************************************************************************
** Modificó:	Lucina Gonzalez Trejo						              ****
** Fecha:		12/Marzo/07								                  ****
** Descripción:	Agregar campos								              ****
** Help:		3666									                  ****
******************************************************************************
** Creó:		Ricardo Salinas								              ****
** Fecha:		06/Ene/06									              ****
** Descripcion  Da Alta de inf de persona  					              ****
******************************************************************************
** Creó:		BANREGIO-A453F0							                  ****
** Fecha:		06/Ene/06									              ****
** Help:        No. de Help al que pertenece la modificación	          ****
******************************************************************************/


									/*	Declaracion de Variables	*/
declare	@Status		int,
		@Per_Tipo	char(1),
		@Per_Calle	char(40),
		@Per_CalNum	varchar(10),
		@Per_Coloni	varchar(150),
		@Per_Locali	char(8),
		@Per_CodPos	char(6),
		@Per_RFC	char(15),
		@Per_ActEmp	char(1),
		@Err_Descri	char(12),
		@Sta_Locali char(1)

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Ent_Cero	int,
		@Tip_CueChe	char(2),
		@Tip_CliNom char(2),
		@Tip_Tarjet char(2),
		@Tip_Intern	char(2),
		@Sta_Benefi	char(1),
		@Fec_Vacia	smalldatetime,
		@Nac_Extran	char(1),
		@Forma_FM2	char(3),
		@Str_Si		char(1),
		@Tip_OtrIde	char(1),
		@Tip_Pasapo	char(1),
		@Tip_LinMan	char(1),
		@Tip_Benefi	char(1),
		@Tip_ProRec	char(1),
		@Tip_ProRea	char(1),
		@Per_ApoRea	char(1),
		@Tip_CreBaC	char(1),
		@Per_Moral	char(1),
		@Per_Fisica	char(1),
		@Res_Mexica	char(1),
		@Res_Extran	char(1),
		@Doc_EstFM2	char(3),
		@Doc_EstFM3	char(3),
		@Doc_EstOTR	char(3),
		@Tip_Apode	char(1),
		@Tip_Hered	char(1),
		@Tip_Titula	char(1),
		@Sta_Inacti	char(1),
        @Tip_Mascul char(1),
        @Tip_Femeni char(1)

select	@Str_Vacio	= '',			/* String Vacio	*/
		@Ent_Cero	= 0,			/* Entero en cero */
		@Tip_CueChe	= 'CH',			/* Proceso: Personas relacionadas a Cuenta de cheques*/
		@Tip_CliNom = 'CN',			/* Proceso: Cliente de Nomina		*/
		@Tip_Tarjet = 'TA',			/* Proceso: Tarjetas				*/
		@Tip_Intern	= 'IT',			/* Proceso: Personas relacionadas a Internacional*/
		@Sta_Benefi	= 'S',			/* Status: Beneficiario */
		@Fec_Vacia	= '1900-01-01',	/* Fecha vacia */
		@Nac_Extran	= 'E',			/* Nacionalidad extranjera*/
		@Forma_FM2	= 'FM2',		/* Forma: FM2*/
		@Str_Si		= 'S',			/* String: Si */
		@Tip_OtrIde	= 'O',			/* Tipo: Otra identificacion */
		@Tip_Pasapo	= 'P',			/* Tipo: Pasaporte */
		@Tip_LinMan	= 'L',			/* Tipo: Licencia de Manejo */
		@Tip_Benefi	= '4',			/* Beneficiario			*/
		@Tip_ProRec	= '5',			/* Proveedor de Recursos			*/
		@Tip_ProRea	= '6',			/* Propietario Real					*/
		@Per_ApoRea	= '8',			/* Apoderado del Propietario Real	*/
		@Tip_CreBaC = 'B',			/* Tipo: Credencia para votar de Baja California */
		@Per_Moral	= '1',			/* Persona: Moral */
		@Per_Fisica	= '2',			/* Persona: Fisica */
		@Res_Mexica	= 'N',			/* Residencia Nacional */	
		@Res_Extran	= 'E',			/* Residencia Extranjera  */
		@Doc_EstFM2	= 'FM2',		/* Documento estancia FM2*/
		@Doc_EstFM3	= 'FM3',		/* Documento estancia FM3*/
		@Doc_EstOTR	= 'OTR',		/* Otro Documento que acredita la estancia Legal */
		@Tip_Apode	= '2',			/* Apoderado de la Cuenta para Personas Morales de CHCOTBEN	*/
		@Tip_Hered	= 'H',
		@Tip_Titula	= '1',
		@Sta_Inacti	= 'I',			/* Status Inactivo para validar localidad */
        @Tip_Mascul = 'M',          /* Valor para sexo Masculino */
        @Tip_Femeni = 'F'           /* Valor para sexo Femenino */

if @Cob_Tipo	= @Tip_Titula and @Tip_Proces = @Tip_CueChe begin
	select	@Err_Descri	= ' del Cliente'
end else begin
	select	@Err_Descri	= @Str_Vacio
end

select	@Adi_Fecha	= Per_Fecha,
		@Per_RFC	= Per_RFC,
		@Per_Tipo	= Per_Tipo,
		@Per_ActEmp	= Per_ActEmp,
		@Per_Calle	= Per_Calle,
		@Per_CalNum	= Per_CalNum,
		@Per_Coloni	= Per_Coloni,
		@Per_Locali	= Per_Locali,
		@Per_CodPos	= Per_CodPos
	from SOPERSON noholdlock
	where Per_Numero	= @Adi_PerNum

select	@Per_RFC	= isnull(@Per_RFC, @Str_Vacio)
select	@Per_Tipo	= isnull(@Per_Tipo, @Str_Vacio)
select	@Per_Calle	= isnull(@Per_Calle, @Str_Vacio)
select	@Per_CalNum	= isnull(@Per_CalNum, @Str_Vacio)
select	@Per_Coloni	= isnull(@Per_Coloni, @Str_Vacio)
select	@Per_Locali	= isnull(@Per_Locali, @Str_Vacio)
select	@Per_CodPos	= isnull(@Per_CodPos, @Str_Vacio)

if @Per_Tipo = @Per_Moral begin
	select 	@Adi_FecCon = @Adi_FecNac,
			@Adi_Sexo	= @Str_Vacio
end

if @Per_RFC	= @Str_Vacio and @Adi_NuIdFi = @Str_Vacio and @Adi_NacExt = 'E' begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Especifique el Numero de Identificacion Fiscal o RFC',
			Err_Variab	= 'Adi_NuIdFi'
	rollback
	return 1
end

if	@Tip_Proces = @Tip_CueChe and @Cob_Tipo <> @Per_ApoRea begin
	if @Adi_FecNac = @Fec_Vacia and @Cob_Tipo <> @Tip_ProRec begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Proporcione la Fecha de nacimiento' + @Err_Descri,
				Err_Variab	= 'Adi_FecNac'
		rollback
		return 1
	end

	if @Per_Tipo like '[23]' begin
		if 	(@Adi_Sexo = @Str_Vacio) and @Cob_Tipo <> @Tip_Hered begin
			select	Err_Codigo	= '000003',
					Err_Mensaj 	= 'Proporcione el sexo' + @Err_Descri,
					Err_Variab 	= 'vAdi_Sexo'
			rollback
			return 1
		end
		if (@Adi_Sexo not in (@Tip_Mascul, @Tip_Femeni)) and @Cob_Tipo <> @Tip_Hered begin
			select	Err_Codigo	= '000020',
					Err_Mensaj 	= 'Sexo no válido' + @Err_Descri,
					Err_Variab 	= 'vAdi_Sexo'
			rollback
			return 1
		end
	 	if	@Adi_TipIde = @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_CliNom,@Tip_Tarjet) begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'Proporcione con que se identifica' + @Err_Descri,
					Err_Variab	= 'Adi_TipIde'
			rollback
			return 1
		end
	 	if	@Adi_TipIde = @Tip_OtrIde and @Adi_OtrIde =  @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) begin
			select	Err_Codigo	= '000005',
					Err_Mensaj	= 'Proporcione con que se identifica' + @Err_Descri,
					Err_Variab	= 'Adi_OtrIde'
			rollback
			return 1
		end
		if @Adi_FeExId = @Fec_Vacia and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea) AND @Adi_TipIde not in (@Tip_OtrIde,@Tip_CreBaC) begin
			select	Err_Codigo	= '000006',
					Err_Mensaj	= 'Proporcione la Fecha de expedición de la identificacion' + @Err_Descri,
					Err_Variab	= 'Adi_FeExId'
			rollback
			return 1
		end
		if @Adi_TipIde in (@Tip_LinMan, @Tip_Pasapo) and  @Adi_FeVeId = @Fec_Vacia and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered) begin
			select	Err_Codigo	= '000007',
					Err_Mensaj	= 'Proporcione la Fecha de vencimiento de la identificacion' + @Err_Descri,
					Err_Variab	= 'Adi_FeVeId'
			rollback
			return 1
		end

	 	if	@Adi_NumIde=  @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea) begin
			select	Err_Codigo	= '000008',
					Err_Mensaj	= 'Proporcione el Número de la identificación' + @Err_Descri,
					Err_Variab	= 'Adi_NumIde'
			rollback
			return 1
		end
	end

	if @Adi_NacExt = @Str_Vacio and @Cob_Tipo <> @Tip_Hered begin
		select	Err_Codigo	= '000009',
				Err_Mensaj	= 'Proporcione la Nacionalidad' + @Err_Descri,
				Err_Variab	= 'Adi_NacExt'
		rollback
		return 1
	end
	if @Adi_NacExt = @Nac_Extran  begin
		if (@Per_Tipo like '[23]') and  @Adi_TipIde <> @Tip_Pasapo and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea) begin
			select	Err_Codigo	= '000010',
					Err_Mensaj	= 'Tipo de Identificación' + @Err_Descri + ' incorrecta',
					Err_Variab	= 'Adi_TipIde'
			rollback
			return 1
		end
		if	@Adi_DocEst	= @Str_Vacio 
			and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_Apode) begin
			select	Err_Codigo	= '000011',
					Err_Mensaj	= 'Proporcione el documento de estancia legal' + @Err_Descri,
					Err_Variab	= 'vAdi_DocEst'
			rollback
			return 1
		end
		if @Adi_FeExDo = @Fec_Vacia 
			and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_Apode) begin
			if @Adi_DocEst	= @Forma_FM2 and @Adi_CalInm = @Str_Si
				select	Err_Codigo	= '000012',
						Err_Mensaj	= 'Proporcione la Fecha de expedición del Documento de Estancia Legal' + @Err_Descri,
						Err_Variab	= 'Adi_FeExDo'
			else
				select	Err_Codigo	= '000013',
						Err_Mensaj	= 'Proporcione la Fecha de expiración del Documento de Estancia Legal' + @Err_Descri,
						Err_Variab	= 'Adi_FeExDo'
			rollback
			return 1
		end

		if	(@Adi_CalExt = @Str_Vacio or @Adi_CaNuEx = @Str_Vacio or @Adi_LocExt = @Str_Vacio or @Adi_EntExt = @Str_Vacio
		 or @Adi_PaiExt = @Str_Vacio) and (@Per_Calle	= @Str_Vacio or @Per_CalNum = @Str_Vacio or @Per_Coloni = @Str_Vacio
		 or @Per_Locali = @Str_Vacio or @Per_CodPos = @Str_Vacio) and @Cob_Tipo <> @Tip_Apode begin
		 	select	Err_Codigo	= '000014',
					Err_Mensaj	= 'Especifique el Domicilio Nacional o en el Extranjero Completo' + @Err_Descri,
					Err_Variab	= 'OpcDir'
			rollback
			return 1
		end
		if @Adi_PaiExt <> @Str_Vacio and	not exists ( select	Pai_Numero
															from SOPAIS noholdlock
															where	Pai_Numero	= @Adi_PaiExt) begin
			select	Err_Codigo	= '000015',
					Err_Mensaj	= 'Pais del domicilio en el extranjero' + @Err_Descri + ' Incorrecto',
					Err_Variab	= 'Adi_PaiExt'
			rollback
			return 1
		end

		if @Adi_NuIdFi = @Str_Vacio and (@Per_Tipo = @Per_Moral or (@Per_Tipo = @Per_Fisica and @Per_ActEmp	= @Str_Si)) begin
			exec @Status = CLVALRFCPRO	/* Valida RFC */
				@Per_RFC,		@Per_Tipo,		@Per_ActEmp,	@NumTransac,	@Transaccio,
				@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo

			if @Status <> @Ent_Cero begin
				select	Err_Codigo	= '000016',
						Err_Mensaj 	= 'R.F.C.' + @Err_Descri + ' incorrecto',
						Err_Variab 	= 'Per_RFC'
				rollback
				return 1
			end
		end
	end
end

if	@Tip_Proces = @Tip_CueChe and @Cob_Tipo = @Per_ApoRea  begin
	if @Adi_NacExt = @Str_Vacio begin
		select	Err_Codigo	= '000017',
				Err_Mensaj	= 'Proporcione la Nacionalidad' + @Err_Descri,
				Err_Variab	= 'Adi_NacExt'
		rollback
		return 1
	end
end

if	@Tip_Proces = @Tip_Intern and @Per_Tipo = @Per_Moral and @Adi_NacExt <> @Nac_Extran begin
	if not @Adi_Reside in (@Res_Mexica, @Res_Extran) begin
		select 	Err_Codigo = '000018', 
				Err_Mensaj = 'Residencia Incorrecta',
				Err_Foco   = 'fraCli_Reside'
		rollback 
		return 1
	end
	
	if not @Adi_DocEst in (@Doc_EstFM2, @Doc_EstFM3, @Doc_EstOTR) begin
		select 	Err_Codigo = '000026', 
				Err_Mensaj = 'Documento que acredita la estancia legal Incorrecto',
				Err_Foco   = 'rad_FM2'
		rollback 
		return 1
	end
	
	if @Adi_DocEst = @Doc_EstOTR begin
		if isnull(@Adi_OtDoEs, @Str_Vacio) = @Str_Vacio begin
			select	Err_Codigo	= '000019',
				Err_Mensaj	= 'El Otro documento de estancia legal no puede estar vacio',
				Err_Foco	= 'txtAdi_OtDoEs'
			rollback
			return 1
		end
	end
else
	select @Adi_OtDoEs = @Str_Vacio,
		   @Adi_Reside = @Str_Vacio
end

if isnull(@Adi_NumTra, @Str_Vacio) = @Str_Vacio begin
	select	@Adi_Fecha	= @FechaSis,
			@Adi_NumTra	= @NumTransac
end


/* Validar que la Localidad y la Entidad a dar de alta estan activos */

select @Sta_Locali = Loc_Status
	from CLLOCALI noholdlock
where Loc_Numero	= @Adi_Locali


if @Sta_Locali = @Sta_Inacti begin
	select	Err_Codigo	= '000010',
			Err_Mensaj	= 'La Localidad que intenta guardar esta Inactiva',
			Err_Variab	= 'Adi_Locali'
	rollback
	return 1
end

insert into SOPERADI values (
	@Adi_PerNum,	@Adi_Fecha,		@Adi_NumTra,	@Adi_LugNac,	@Adi_Sexo,
	@Adi_FecNac,	@Adi_RegMat,	@Adi_VivCas,	@Adi_TieRes,	@Adi_Fax,
	@Adi_NumDep,    @Adi_Puesto,	@Adi_Ocupac,	@Adi_AntLab,	@Adi_LugTra,
	@Adi_TelTra,	@Adi_CalTra,	@Adi_NuCaTr,	@Adi_ColTra,	@Adi_Locali,
	@Adi_CPTra,		@Adi_FecCon,	@Adi_CaNuIn,	@Adi_NacExt,	@Adi_Reside,				
	@Adi_DocEst,	@Adi_OtDoEs,	@Adi_FeExDo,	@Adi_CalInm,	@Adi_CalExt,	
	@Adi_CaNuEx,	@Adi_ColExt,	@Adi_LocExt,	@Adi_EntExt,	@Adi_PaiExt,	
	@Adi_CoPoEx,	@Adi_TelExt,	@Adi_TipIde,	@Adi_OtrIde,	@Adi_NumIde,	
	@Adi_FeExId,	@Adi_FeVeId,	@Adi_NuIdFi,	@Adi_EntPri,	@Adi_EntSeg,
	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,		
	@SucDestino)
if @@nestlevel = 1
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado'
