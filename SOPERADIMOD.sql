create procedure SOPERADIMOD (
	@Adi_PerNum	char(8),
	@Adi_Fecha	smalldatetime,
	@Adi_NumTra	char(10),
	@Adi_LugNac	varchar(50),
	@Adi_Sexo	char(1),
	@Adi_FecNac	smalldatetime,
	@Adi_RegMat	char(1),
	@Adi_VivCas	char(1),
	@Adi_TieRes	int,
	@Adi_Fax	varchar(20),
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
	@Adi_EntPri	varchar(40),
	@Adi_EntSeg	varchar(40),
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

/*******************************************************************************
** DESCRIPCION: **Modificacion de la Informacion Adicional de la Persona**	****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** 					STORE CONVERTIDO										****
********************************************************************************
** Modificó:	Francisco Euan          						          	****
** Fecha:		14/Marzo/2025							                  	****
** Help:		TCELNC-23684								              	****
** Descripción:	Comprobación de valores para Adi_Sexo                     	****
********************************************************************************
** Modificó:	Rolando Bernal												****
** Fecha:		12/Nov/2015													****
** Help:		00801121													****
** Descripción:	Seccionar validaciones segÃºn el Tipo de Pantalla para		****
**				Sibamex3													****
********************************************************************************
** Modificó:	Marcelo Bautista Hernandez									****
** Fecha:		16/Junio/2015												****
** Help:		774214														****
** Descripción:	asignar valor a @Adi_FecCon									****
********************************************************************************
** Modificó:	Karina ChavarrÃ­a Tovar										****
** Fecha:		26/Sep/2008													****
** Descripción:	Agregar @Adi_EntPri, @Adi_EntSeg							****
** HelpDesk:	100187														****
********************************************************************************
** Modificó:	Lucina Gonzalez Trejo										****
** Fecha:		22/Agosto/07												****
** Descripción:	Agregar var Err_Descri										****
** Help:		3666														****
********************************************************************************
** 				STORE CONVERTIDO											****
** Fecha:		23/Julio	/07												****
** Convirtió:	Karina ChavarrÃa Tovar										****
********************************************************************************
** Modificó:	Juan Mario Galindo de Leon									****
** Fecha:		05/Julio/07		  											****
** Descripción:	Agregar campos Adi_Reside, Adi_OtDoEs,						****
**	 			Bit_Reside y Bit_OtDoEs										****
** Help:			7100													****
********************************************************************************
** Modificó:	Lucina Gonzalez Trejo										****
** Fecha:		12/Marzo/07													****
** Descripción:	Agregar campos												****
** Help:		3666														****
********************************************************************************
** Modificó:	Estela Mendoza												****
** Fecha:		28/Sep/06													****
** Descripción:	Faltaba un campo al dar de alta en 							****
**  			SOPERADIMOD 												****
** Help:		4099														****
********************************************************************************
** Creó:		Ricardo Salinas												****
** Fecha:		06/Ene/06													****
** Descripción:	Actuliza inf en tabal soperadi								****
*******************************************************************************/

									/*	DeclaraciÃ³n de Variables */
declare	@Status		int,
		@Err_Descri	varchar(50),
		@Per_Tipo	char(1),
		@Per_Calle	char(40),
		@Per_CalNum	varchar(10),
		@Per_Coloni	varchar(150),
		@Per_Locali	char(8),
		@Per_CodPos	char(6),
		@Per_RFC	char(15),
		@Bit_PerNum	char(8),
		@Bit_Fecha	smalldatetime,
		@Bit_NumTra	char(10),
		@Bit_LugNac	varchar(50),
		@Bit_Sexo	char(1),
		@Bit_FecNac	smalldatetime,
		@Bit_RegMat	char(1),
		@Bit_VivCas	char(1),
		@Bit_TieRes	int,
		@Bit_Fax	varchar(20),
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
		@Bit_Reside	char(1),
		@Bit_DocEst	char(3),
		@Bit_OtDoEs	varchar(50),
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
		@Bit_EntPri	char(40),
		@Bit_EntSeg	char(40)

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Tip_CueChe	char(2),
		@Tip_CliNom	char(2),
		@Tip_Tarjet	char(2),
		@Sta_Benefi	char(1),
		@Tip_Cotitu	char(1),
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
		@Tip_Intern	char(2),
		@Res_Mexica	char(1),
		@Res_Extran	char(1),
		@Doc_EstOTR	char(3),
		@Doc_EstFM2	char(3),
		@Doc_EstFM3	char(3),
		@Per_Moral	char(1),
		@Tip_Apode	char(1),
		@Tip_Hered	char(1),
		@Tip_Titula	char(1),
		@Pan_DatPer	char(2),
		@Pan_DatCon	char(2),
		@Pan_Promot	char(2),
		@Pan_PerCli	char(2),
		@Pan_ActFin	char(2),
		@Tip_Mascul char(1),
        @Tip_Femeni char(1)

select	@Str_Vacio	= '',					-- String Vacio
		@Tip_CueChe	= 'CH',					-- Proceso: Personas relacionadas a Cuenta de cheques
		@Tip_CliNom	= 'CN',					-- Proceso: Cliente de Nomina
		@Tip_Tarjet	= 'TA',					-- Proceso: Tarjetas
		@Sta_Benefi	= 'S',					-- Status: Beneficiario
		@Fec_Vacia	= '1900-01-01',			-- Fecha vacia
		@Nac_Extran	= 'E',					-- Nacionalidad extranjera
		@Forma_FM2	= 'FM2',				-- Forma: FM2
		@Str_Si		= 'S',					-- String: Si
		@Tip_OtrIde	= 'O',					-- Tipo: Otra identificacion
		@Tip_Pasapo	= 'P',					-- Tipo: Pasaporte
		@Tip_LinMan	= 'L',					-- Tipo: Licencia de Manejo
		@Tip_Benefi	= '4',					-- Beneficiario
		@Tip_Cotitu	= '3',					-- Cotitular
		@Tip_ProRec	= '5',					-- Proveedor de Recursos
		@Tip_ProRea	= '6',					-- Propietario Real
		@Per_ApoRea	= '8',					-- Apoderado del Propietario Real Desde la solicitud de Cuenta
		@Tip_CreBaC	= 'B',					-- Tipo: Credencial para Votar de Baja California
		@Tip_Intern = 'IT',					-- Proceso: Personas relacionadas a Internacional
		@Res_Mexica	= 'N',					-- Residencia Nacional
		@Res_Extran	= 'E',					-- Residencia Extranjera
		@Doc_EstOTR	= 'OTR',				-- Otro Documento de estancia legal
		@Doc_EstFM2	= 'FM2',				-- Documento estancia FM2
		@Doc_EstFM3	= 'FM3',				-- Documento estancia FM3
		@Per_Moral	= '1',					-- Persona Moral
		@Tip_Apode	= '2',					-- Apoderado de la Cuenta para Personas Morales de CHCOTBEN
		@Tip_Hered	= 'H',					-- Herederos Legales
		@Tip_Titula	= '1',					-- Titular
		@Pan_DatPer	= '01',					-- Pantalla Sibamex3: Datos Personales
		@Pan_DatCon	= '02',					-- Pantalla Sibamex3: Datos de Contacto
		@Pan_Promot	= '03',					-- Pantalla Sibamex3: Promotores
		@Pan_PerCli	= '04',					-- Pantalla Sibamex3: Perfilamiento
		@Pan_ActFin	= '05',					-- Pantalla Sibamex3: Actividad Financiera
		@Tip_Mascul = 'M',          		-- Valor para sexo Masculino
        @Tip_Femeni = 'F'           		-- Valor para sexo Femenino

select	@Per_Tipo	= Per_Tipo
	from SOPERSON noholdlock
	where	Per_Numero	= @Adi_PerNum

if @Per_Tipo = @Per_Moral begin
	select	@Adi_FecCon	= @Adi_FecNac
end

if @Cob_Tipo = @Tip_Titula and @Tip_Proces = @Tip_CueChe begin
	select	@Err_Descri	= ' del Cliente'
end else begin
	select	@Err_Descri	= @Str_Vacio
end

if @Tip_Proces = @Tip_CueChe begin
	/*14-Ago-2007 GVM*/
	select	@Adi_CalTra	= Adi_CalTra,
			@Adi_NuCaTr	= Adi_NuCaTr,
			@Adi_ColTra	= Adi_ColTra,
			@Adi_Locali	= Adi_Locali,
			@Adi_CPTra	= Adi_CPTra
		from SOPERADI noholdlock
		where	Adi_PerNum	= @Adi_PerNum

	select	@Adi_CalTra	= isnull(@Adi_CalTra, @Str_Vacio),
			@Adi_NuCaTr	= isnull(@Adi_NuCaTr, @Str_Vacio),
			@Adi_ColTra	= isnull(@Adi_ColTra, @Str_Vacio),
			@Adi_Locali	= isnull(@Adi_Locali, @Str_Vacio),
			@Adi_CPTra	= isnull(@Adi_CPTra,  @Str_Vacio)
	/*14-Ago-2007 GVM*/
end

if @Tip_Proces = @Tip_CueChe and @Cob_Tipo = @Tip_Titula begin
	select	@Adi_NuIdFi	= Adi_NuIdFi
		from SOPERADI noholdlock
		where	Adi_PerNum	= @Adi_PerNum

	select	@Adi_NuIdFi	= isnull(@Adi_NuIdFi, @Str_Vacio)
end

if	@Tip_Proces = @Tip_CueChe and @Cob_Tipo <> @Per_ApoRea begin
	select	@Per_Tipo	= Per_Tipo,
			@Per_Calle	= Per_Calle,
			@Per_CalNum	= Per_CalNum,
			@Per_Coloni	= Per_Coloni,
			@Per_Locali	= Per_Locali,
			@Per_CodPos	= Per_CodPos,
			@Per_RFC	= Per_RFC
		from SOPERSON noholdlock
		where	Per_Numero	= @Adi_PerNum

	select	@Per_Tipo	= isnull(@Per_Tipo, @Str_Vacio)
	select	@Per_Calle	= isnull(@Per_Calle, @Str_Vacio)
	select	@Per_CalNum	= isnull(@Per_CalNum, @Str_Vacio)
	select	@Per_Coloni	= isnull(@Per_Coloni, @Str_Vacio)
	select	@Per_Locali	= isnull(@Per_Locali, @Str_Vacio)
	select	@Per_CodPos	= isnull(@Per_CodPos, @Str_Vacio)
	select	@Per_RFC	= isnull(@Per_RFC, @Str_Vacio)

	if @Per_RFC = @Str_Vacio and @Adi_NuIdFi = @Str_Vacio and @Adi_NacExt = 'E' begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'Especifique el Numero de Identificacion Fiscal o RFC',
				Err_Variab	= 'Adi_NuIdFi'
		rollback
		return 1
	end

	if @Adi_FecNac = @Fec_Vacia and @Cob_Tipo <> @Tip_ProRec begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Proporcione la Fecha de nacimiento' + @Err_Descri,
				Err_Variab	= 'Adi_FecNac'
		rollback
		return 1
	end

	if @Per_Tipo like '[23]' begin

		if (@Adi_Sexo = @Str_Vacio) and @Cob_Tipo <> @Tip_Hered begin
			select	Err_Codigo	= '000003',
					Err_Mensaj	= 'Proporcione el sexo' + @Err_Descri,
					Err_Variab	= 'vAdi_Sexo'
			rollback
			return 1
		end
		
		if (@Adi_Sexo not in (@Tip_Mascul, @Tip_Femeni)) and @Cob_Tipo <> @Tip_Hered begin
			select	Err_Codigo	= '000021',
					Err_Mensaj 	= 'Sexo no válido' + @Err_Descri,
					Err_Variab 	= 'vAdi_Sexo'
			rollback
			return 1
		end

		if	@Adi_TipIde = @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea,@Tip_CliNom,@Tip_Tarjet) begin
			select	Err_Codigo	= '000004',
					Err_Mensaj	= 'Proporcione la identificaciÃ³n' + @Err_Descri,
					Err_Variab	= 'Adi_TipIde'
			rollback
			return 1
		end

		if @Adi_TipIde <> @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi, @Tip_Hered, @Tip_ProRec, @Tip_ProRea, @Tip_CliNom, @Tip_Tarjet) begin

			if @Adi_TipIde = @Tip_OtrIde and @Adi_OtrIde = @Str_Vacio begin
				select	Err_Codigo	= '000005',
						Err_Mensaj	= 'Proporcione la identificaciÃ³n' + @Err_Descri,
						Err_Variab	= 'Adi_OtrIde'
				rollback
				return 1
			end

			if @Adi_TipIde = @Tip_OtrIde and @Adi_FeExId = @Fec_Vacia and @Adi_FeVeId = @Fec_Vacia  begin
				select	Err_Codigo	= '000006',
						Err_Mensaj	= 'Especifique la Fecha de Expedicion o la Fecha de Vencimiento de la Identificacion' + @Err_Descri,
						Err_Variab	= 'Adi_FeExId'
				rollback
				return 1
			end

			if @Adi_FeExId = @Fec_Vacia and @Adi_TipIde not in (@Tip_CreBaC, @Tip_OtrIde) begin
				select	Err_Codigo	= '000007',
						Err_Mensaj	= 'Proporcione la Fecha de expediciÃ³n de la identificacion' + @Err_Descri,
						Err_Variab	= 'Adi_FeExId'
				rollback
				return 1
			end

			if (@Adi_TipIde in (@Tip_LinMan, @Tip_Pasapo) and  @Adi_FeVeId = @Fec_Vacia) begin
				select	Err_Codigo	= '000008',
						Err_Mensaj	= 'Proporcione la Fecha de vencimiento de la identificacion' + @Err_Descri,
						Err_Variab	= 'Adi_FeVeId'
				rollback
				return 1
			end

			if @Adi_NumIde = @Str_Vacio begin
				select	Err_Codigo	= '000009',
						Err_Mensaj	= 'Proporcione el NÃºmero de identificaciÃ³n' + @Err_Descri,
						Err_Variab	= 'Adi_NumIde'
				rollback
				return 1
			end

		end

	end

	if @Adi_NacExt = @Str_Vacio and @Cob_Tipo <> @Tip_Hered begin
		select	Err_Codigo	= '000010',
				Err_Mensaj	= 'Nacionalidad' + @Err_Descri + ' incorrecta',
				Err_Variab	= 'Adi_NacExt'
		rollback
		return 1
	end

	if @Adi_NacExt = @Nac_Extran begin

		if (@Per_Tipo like '[23]') and  @Adi_TipIde <> @Tip_Pasapo and @Cob_Tipo not in (@Tip_Benefi,@Tip_Hered,@Tip_ProRec,@Tip_ProRea) begin
			select	Err_Codigo	= '000011',
					Err_Mensaj	= 'Tipo de IdentificaciÃ³n' + @Err_Descri + ' incorrecta',
					Err_Variab	= 'Adi_TipIde'
			rollback
			return 1
		end

		if @Adi_DocEst = @Str_Vacio and @Cob_Tipo not in (@Tip_Benefi, @Tip_Hered, @Tip_ProRec, @Tip_ProRea, @Tip_Apode) begin
			select	Err_Codigo	= '000012',
					Err_Mensaj	= 'Proporcione el documento estancia legal' + @Err_Descri,
					Err_Variab	= 'vAdi_DocEst'
			rollback
			return 1
		end

		if @Adi_FeExDo = @Fec_Vacia and @Cob_Tipo not in (@Tip_Benefi, @Tip_Hered, @Tip_ProRec, @Tip_ProRea, @Tip_Apode) begin

			if @Adi_DocEst = @Forma_FM2 and @Adi_CalInm = @Str_Si
				select	Err_Codigo	= '000013',
						Err_Mensaj	= 'Proporcione la Fecha de expediciÃ³n del Documento de Estancia Legal' + @Err_Descri,
						Err_Variab	= 'Adi_FeExDo'
			else
				select	Err_Codigo	= '000014',
						Err_Mensaj	= 'Proporcione la Fecha de expiraciÃ³n del Documento de Estancia Legal' + @Err_Descri,
						Err_Variab	= 'Adi_FeExDo'

			rollback
			return 1

		end

		if (@Adi_CalExt = @Str_Vacio or @Adi_CaNuEx = @Str_Vacio or @Adi_LocExt = @Str_Vacio or @Adi_EntExt = @Str_Vacio
			or @Adi_PaiExt = @Str_Vacio) and (@Per_Calle = @Str_Vacio or @Per_CalNum = @Str_Vacio or @Per_Coloni = @Str_Vacio
			or @Per_Locali = @Str_Vacio or @Per_CodPos = @Str_Vacio) and @Cob_Tipo <> @Tip_Apode begin
		 	select	Err_Codigo	= '000015',
					Err_Mensaj	= 'Especifique el Domicilio Nacional o en el Extranjero Completo' + @Err_Descri,
					Err_Variab	= 'OpcDir'
			rollback
			return 1
		end

		if @Adi_PaiExt <> @Str_Vacio and not exists (select	Pai_Numero
															from SOPAIS noholdlock
															where	Pai_Numero	= @Adi_PaiExt) begin
			select	Err_Codigo	= '000016',
					Err_Mensaj	= 'Pais del domicilio en el extranjero' + @Err_Descri + ' Incorrecto',
					Err_Variab	= 'Adi_PaiExt'
			rollback
			return 1
		end

	end

end

if @Tip_Proces = @Tip_CueChe and @Cob_Tipo = @Per_ApoRea begin
	if @Adi_NacExt = @Str_Vacio begin
		select	Err_Codigo	= '000017',
				Err_Mensaj	= 'Nacionalidad' + @Err_Descri + ' incorrecta',
				Err_Variab	= 'Adi_NacExt'
		rollback
		return 1
	end
end

if @Tip_Proces = @Tip_Intern and @Per_Tipo = @Per_Moral and @Adi_NacExt <> @Nac_Extran begin

	if not @Adi_Reside in (@Res_Mexica, @Res_Extran) begin
		select	Err_Codigo	= '000018', 
				Err_Mensaj	= 'Residencia Incorrecta',
				Err_Foco	= 'fraCli_Reside'
		rollback
		return 1
	end

	if not @Adi_DocEst in (@Doc_EstFM2, @Doc_EstFM3, @Doc_EstOTR) begin
		select	Err_Codigo	= '000026', 
				Err_Mensaj	= 'Documento que acredita la estancia legal Incorrecto',
				Err_Foco	= 'rad_FM2'
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
	select	@Adi_OtDoEs	= @Str_Vacio,
			@Adi_Reside	= @Str_Vacio
end

if not exists (select	Adi_PerNum
				from SOPERADI noholdlock
				where	Adi_PerNum	= @Adi_PerNum) begin

	exec @Status = SOPERADIALT
		@Adi_PerNum,	@Adi_Fecha,		@Adi_NumTra,	@Adi_LugNac,	@Adi_Sexo,
		@Adi_FecNac,	@Adi_RegMat,	@Adi_VivCas,	@Adi_TieRes,	@Adi_Fax,
		@Adi_NumDep,	@Adi_Puesto,	@Adi_Ocupac,	@Adi_AntLab,	@Adi_LugTra,
		@Adi_TelTra,	@Adi_CalTra,	@Adi_NuCaTr,	@Adi_ColTra,	@Adi_Locali,
		@Adi_CPTra,		@Adi_FecCon,	@Adi_CaNuIn,	@Adi_NacExt,	@Adi_Reside,
		@Adi_DocEst,	@Adi_OtDoEs,	@Adi_FeExDo,	@Adi_CalInm,	@Adi_CalExt,
		@Adi_CaNuEx,	@Adi_ColExt,	@Adi_LocExt,	@Adi_EntExt,	@Adi_PaiExt,
		@Adi_CoPoEx,	@Adi_TelExt,	@Adi_TipIde,	@Adi_OtrIde,	@Adi_NumIde,
		@Adi_FeExId,	@Adi_FeVeId,	@Adi_NuIdFi,	@Adi_EntPri,	@Adi_EntSeg,
		@Tip_Proces,	@Cob_Tipo,		@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> 0 begin
		select	Err_Codigo = '000020', 
				Err_Mensaj = 'No se Actualizo la Informacion'
		rollback
		return 1
	end

end else begin

	if not exists (select	Adi_PerNum
					from SOPERADI noholdlock
					where	Adi_PerNum	= @Adi_PerNum
					  and	Adi_NumTra	= @Adi_NumTra
					  and	Adi_Fecha	= @Adi_Fecha ) begin

		select	@Bit_PerNum	= Adi_PerNum,
				@Bit_Fecha	= Adi_Fecha,
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

		exec @Status = SOBIPEADALT
			@Bit_PerNum,	@Bit_Fecha,		@Bit_NumTra,	@Bit_LugNac,	@Bit_Sexo,
			@Bit_FecNac,	@Bit_RegMat,	@Bit_VivCas,	@Bit_TieRes,	@Bit_Fax,
			@Bit_NumDep,	@Bit_Puesto,	@Bit_Ocupac,	@Bit_AntLab,	@Bit_LugTra,
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

	end

	if @Cob_Tipo <> @Per_ApoRea begin
		update SOPERADI set
			Adi_Fecha	= @Adi_Fecha,
			Adi_NumTra	= @Adi_NumTra,
			Adi_LugNac	= @Adi_LugNac,
			Adi_Sexo	= @Adi_Sexo,
			Adi_FecNac	= @Adi_FecNac,
			Adi_RegMat	= @Adi_RegMat,
			Adi_VivCas	= @Adi_VivCas,
			Adi_TieRes	= @Adi_TieRes,
			Adi_Fax		= @Adi_Fax,
			Adi_NumDep	= @Adi_NumDep,
			Adi_Puesto	= @Adi_Puesto,
			Adi_Ocupac	= @Adi_Ocupac,
			Adi_AntLab	= @Adi_AntLab,
			Adi_LugTra	= @Adi_LugTra,
			Adi_TelTra	= @Adi_TelTra,
			Adi_CalTra	= @Adi_CalTra,
			Adi_NuCaTr	= @Adi_NuCaTr,
			Adi_ColTra	= @Adi_ColTra,
			Adi_Locali	= @Adi_Locali,
			Adi_CPTra	= @Adi_CPTra,
			Adi_FecCon	= @Adi_FecCon,
			Adi_CaNuIn	= @Adi_CaNuIn,
			Adi_NacExt	= @Adi_NacExt,
			Adi_Reside	= @Adi_Reside,
			Adi_DocEst	= @Adi_DocEst,
			Adi_OtDoEs	= @Adi_OtDoEs,
			Adi_FeExDo	= @Adi_FeExDo,
			Adi_CalInm	= @Adi_CalInm,
			Adi_CalExt	= @Adi_CalExt,
			Adi_CaNuEx	= @Adi_CaNuEx,
			Adi_ColExt	= @Adi_ColExt,
			Adi_LocExt	= @Adi_LocExt,
			Adi_EntExt	= @Adi_EntExt,
			Adi_PaiExt	= @Adi_PaiExt,
			Adi_CoPoEx	= @Adi_CoPoEx,
			Adi_TelExt	= @Adi_TelExt,
			Adi_TipIde	= @Adi_TipIde,
			Adi_OtrIde	= @Adi_OtrIde,
			Adi_NumIde	= @Adi_NumIde,
			Adi_FeExId	= @Adi_FeExId,
			Adi_FeVeId	= @Adi_FeVeId,
			Adi_NuIdFi	= @Adi_NuIdFi,
			Adi_EntPri	= @Adi_EntPri,
			Adi_EntSeg	= @Adi_EntSeg,

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where	Adi_PerNum	= @Adi_PerNum

	end else begin

		update SOPERADI set
			Adi_Fecha	= @Adi_Fecha,
			Adi_NumTra	= @Adi_NumTra,
			Adi_NacExt	= @Adi_NacExt,
			Adi_FecNac	= @Adi_FecNac,

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
				Err_Mensaj	= 'Registro Modificado'

end
