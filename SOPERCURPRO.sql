create procedure SOUNGRPEPRO (
	@Gpc_Person char(8),
	@Gpc_Grupo  char(8),
	@Gpc_Nombre char(40),
	@Gpc_ApePat char(40),
	@Gpc_ApeMat char(40),
	@Gpc_FecNac datetime,
	@Gpc_Sexo	char(1),
	@Gpc_EntNac char(2),
	@Gpc_RFC	varchar(15),
	@Gpc_CURP	char(18),
	@Tip_Proces	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)

as

/***************************************************************************
** DESCRIPCION: ** Proceso de unificación de grupos de Persona			****
****************************************************************************
** REFERENCIAS: 														****
****************************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz							****
** Fecha:		28/Mayo/2019											****
** Help:		1214398													****
** Descripcion:	Se modifica la unificación de la persona tomando en 	****
**				cuenta a la persona del cliente único.					****
****************************************************************************
** Creó:	Armando Alexis Sepúlveda Cruz								****
** Fecha:	11/Abril/2019												****
** Help:	1214398														****
****************************************************************************/

/* Declaracion de variables */
declare	@Reg_Existe	int,					/*Existe Registro*/
		@Status		int,					/*Estatus de Procedimiento*/
		@Peu_Person char(8),				/*Persona*/
		@Gpc_GrpAnt	char(8),				/*Grupo Anterior*/
		@Gpc_Comple char(120),				/*Nombre Completo*/
		@Gpc_ComOrd char(120),				/*Nombre Completo Ordenado*/
		@Gpc_PrClUn char(8),				/*Persona del Cliente Único*/
		@Per_Entida char(3),				/*Entidad*/
		@Pro_Datos	char(1),				/*Proceso de actualización de Datos*/
		@Pro_DesAgr	char(1),				/*Proceso de desagrupación de persona*/
		@Pro_GruMin	char(1),				/*Proceso de agrupación de persona por minimo*/
		@Pro_GrClUn char(1),				/*Proceso de agrupacion de persona por persona del cliente único*/
		@Ent_Status	int,					/* Status */
		@Bit_Fecha	smalldatetime,			/* Bitacora Fecha */
		@Bit_NumTra	char(10),				/* Bitacora Numero de transaccion */
		@Bit_Tipo	char(1),				/* Bitacora tipo */
		@Bit_NuSeFi	varchar(30),			/* Bitacora Numero de serie de la Firma Electronica Avanzada */
		@Bit_Titulo	varchar(10),			/* Bitacora titulo */
		@Bit_Nombre	varchar(40),			/* Bitacora Nombre */
		@Bit_ApePat	varchar(40),			/* Bitacora apellido paterno */
		@Bit_ApeMat	varchar(40),			/* Bitacora Apellido Materno */
		@Bit_RazSoc	varchar(180),			/* Bitacora Razon social */
		@Bit_Comple	varchar(180),			/* Bitacora nombre completo */
		@Bit_ComOrd	varchar(180),			/* Bitacora nombre ordenado */
		@Bit_RFC	char(15),				/* Bitacora RFC */
		@Bit_CURP	char(18),				/* Bitacora CURP */
		@Bit_Calle	char(40),				/* Bitacora Calle */
		@Bit_CalNum	varchar(10),			/* Bitacora Calle numero */
		@Bit_Coloni	varchar(150),			/* Bitacora Colonia */
		@Bit_Entida	char(3),				/* Bitacora Identidad */
		@Bit_Locali	char(8),				/* Bitacora Localidad */
		@Bit_CodPos	char(6),				/* Bitacora Codigo Postal */
		@Bit_ApaPos	char(6),				/* Bitacora Apartado Postal */
		@Bit_LadTel	varchar(5),				/* Bitacora lada telefono */
		@Bit_Telefo	char(15),				/* Bitacora telefono */
		@Bit_Email	varchar(50),			/* Bitacora email */	
		@Bit_ComDom	char(1),				/* Bitacora Comprobante de domicilio */
		@Bit_EstCiv	varchar(20),			/* Bitacora Estado civil */
		@Bit_Nacion	char(3),				/* Bitacora nacionalidad */
		@Bit_ActEmp	char(1),				/* Bitacora Actividad Empresarial */
		@Bit_Giro	char(30),				/* Bitacora giro */
		@Bit_Sector	char(3),				/* Bitacora sector */
		@Bit_Activi	char(10),				/* Bitacora actividad */
		@Bit_ActINE	varchar(10),			/* Bitacora Actividad según INEGI */	
		@Bit_LugNac	varchar(50),			/* Bitacora Lugar Nacimiento */
		@Bit_Sexo	char(1),				/* Bitacora Sexo */
		@Bit_FecNac	smalldatetime,			/* Bitacora Fecha Nacimiento */
		@Bit_RegMat	char(1),				/* Bitacora Rrgimen matrimonial Mancomunados, Separados */
		@Bit_VivCas	char(1),				/* Bitacora Vive en casa  Propia, Renta , Casa*/
		@Bit_TieRes	int,					/* Bitacora Tiempo de residencia */
		@Bit_Fax    varchar(20),			/* Bitacora Fax */
		@Bit_NumDep	int,					/* Bitacora Numero de dependientes */
		@Bit_Puesto	varchar(50),			/* Bitacora Puesto */
		@Bit_Ocupac	varchar(50),			/* Bitacora Ocupacion */
		@Bit_AntLab	int,					/* Bitacora Antiguedad laboral  */
		@Bit_LugTra	varchar(50),			/* Bitacora Lugar trabajo */
		@Bit_TelTra	varchar(20),			/* Bitacora Telefono trabajo */
		@Bit_CalTra	varchar(20),			/* Bitacora Calle de Trabajo */
		@Bit_NuCaTr	varchar(30),			/* Bitacora Numero de calle del  Trabajo*/
		@Bit_ColTra	varchar(50),			/* Bitacora Numero trabajo */
		@Bit_CPTra	varchar(50),			/* Bitacora Codigo postal trabajo */
		@Bit_FecCon	smalldatetime,			/* Bitacora Fecha  */
		@Bit_CaNuIn	varchar(10),			/* Bitacora Numero ineterior */
		@Bit_NacExt	char(1),				/* Bitacora Nacionalidad Extranjera */
		@Bit_Reside char(1),				/* Bitacora Recidente */
		@Bit_DocEst	char(3),				/* Bitacora Documento  */
		@Bit_OtDoEs varchar(50),			/* Bitacora Otro Documento que Acredita Estancia Legal */
		@Bit_FeExDo	smalldatetime,			/* Bitacora Fecha de expiracion o expedicion del documento que acredita la estancia legal */
		@Bit_CalInm	char(1),				/* Bitacora  Calidad de Inmigrante */
		@Bit_CalExt	varchar(40),			/* Bitacora Calle  del Domicilio en el extranjero en caso de extranjero */
		@Bit_CaNuEx	varchar(10),			/* Bitacora Calle numero exteriro */
		@Bit_ColExt	varchar(150),			/* Bitacora Colonia Extranjero */
		@Bit_LocExt	varchar(40),			/* Bitacora Localidad Extranjero */
		@Bit_EntExt	varchar(40),			/* Bitacora Entidad Extranjero */
		@Bit_PaiExt	varchar(3),				/* Bitacora Pais Extranjero */
		@Bit_CoPoEx	char(6),				/* Bitacora Codigo Postak Extranjero */
		@Bit_TipIde	char(1),				/* Bitacora Tipo de identificacion */
		@Bit_OtrIde	varchar(50),			/* Bitacora Otra identificacion */
		@Bit_NumIde	varchar(30),			/* Bitacora numero identificacion */
		@Bit_FeExId	smalldatetime,			/* Bitacora Fecha de expedicion de la identificacion */
		@Bit_FeVeId	smalldatetime,			/* Bitacora Fecha de vencimiento de la identificacion */
		@Bit_NuIdFi	varchar(20),			/* Bitacora Numero de Identificacion Fiscal */
		@Bit_EntPri char(40), 				/* Bitacora Entre Calle Primera */
		@Bit_EntSeg char(40)				/* Bitacora Entre Calle Segunda */

/* Declaracion de Constantes */
declare	@Ent_Uno	int,					/*Entero: Uno*/
		@Sta_Activo	char(1),				/*Estatus: Activo*/
		@Ent_Cero	int,					/*Numero entero 0 */
		@Str_Vacio	char(1)					/*String: vacio*/

select	@Ent_Uno	= 1,
		@Sta_Activo	= 'A',
		@Ent_Cero	= 0,
		@Pro_Datos	= '1',
		@Pro_DesAgr = '2',
		@Pro_GruMin	= '3',
		@Pro_GrClUn = '4',
		@Str_Vacio	= ''
		
if @Tip_Proces = @Pro_Datos begin		/*Actualización de Datos*/
	select @Gpc_Nombre	= isnull(@Gpc_Nombre, @Str_Vacio)
	select @Gpc_ApePat	= isnull(@Gpc_ApePat, @Str_Vacio)
	select @Gpc_ApeMat	= isnull(@Gpc_ApeMat, @Str_Vacio)
	select @Gpc_FecNac	= isnull(@Gpc_FecNac, @Str_Vacio)
	select @Gpc_Sexo	= isnull(@Gpc_Sexo, @Str_Vacio)
	select @Gpc_EntNac	= isnull(@Gpc_EntNac, @Str_Vacio)
	select @Gpc_RFC		= isnull(@Gpc_RFC, @Str_Vacio)
	select @Gpc_CURP	= isnull(@Gpc_CURP, @Str_Vacio)

	select	@Bit_Fecha	= Per_Fecha,
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
			@Bit_Telefo	= Per_Email,
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
		where	Per_Numero = @Gpc_Person

	exec @Ent_Status = SOBITPERALT
		@Gpc_Person,	@Bit_Fecha,		@Bit_NumTra,	@Bit_Tipo,		@Bit_NuSeFi,
		@Bit_Titulo,	@Bit_Nombre,	@Bit_ApePat,	@Bit_ApeMat,	@Bit_RazSoc,
		@Bit_Comple,	@Bit_ComOrd,	@Bit_RFC,		@Bit_CURP,		@Bit_Calle,
		@Bit_CalNum,	@Bit_Coloni,	@Bit_Entida,	@Bit_Locali,	@Bit_CodPos,
		@Bit_ApaPos,	@Bit_LadTel,	@Bit_Telefo,	@Bit_Email,		@Bit_ComDom,
		@Bit_EstCiv,	@Bit_Nacion,	@Bit_ActEmp,	@Bit_Giro,		@Bit_Sector,
		@Bit_Activi,	@Bit_ActINE,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
	if @Ent_Status <> @Ent_Cero begin
		rollback
		return 1
	end

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
		where	Adi_PerNum	= @Gpc_Person

		exec @Ent_Status =	SOBIPEADALT
			@Gpc_Person,	@Bit_Fecha,		@Bit_NumTra,	@Bit_LugNac,	@Bit_Sexo,
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

		if @Ent_Status <> 0 begin
			rollback
			return 1
		end


	select	@Gpc_Comple = ltrim(rtrim(@Gpc_ApePat)) + ' ' + ltrim(rtrim(@Gpc_ApeMat)) + ' ' + ltrim(rtrim(@Gpc_Nombre)),
			@Gpc_ComOrd = ltrim(rtrim(@Gpc_Nombre)) + ' ' + ltrim(rtrim(@Gpc_ApePat)) + ' ' + ltrim(rtrim(@Gpc_ApeMat))
			
	select @Per_Entida = Ent_Numero 
	  from CLENTIDA noholdlock
	 where Ent_Abrevi = @Gpc_EntNac
	   and Ent_Status = @Sta_Activo
			
	update SOPERSON set
		Per_Nombre	= ltrim(rtrim(@Gpc_Nombre)),
		Per_ApePat	= ltrim(rtrim(@Gpc_ApePat)),
		Per_ApeMat	= ltrim(rtrim(@Gpc_ApeMat)),
		Per_Comple	= ltrim(rtrim(@Gpc_Comple)),
		Per_ComOrd	= ltrim(rtrim(@Gpc_ComOrd)),
		Per_Entida	= ltrim(rtrim(@Per_Entida)),
		Per_RFC		= ltrim(rtrim(@Gpc_RFC)),
		Per_CURP	= ltrim(rtrim(@Gpc_CURP)),
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Per_Numero = @Gpc_Person
	
	update SOPERADI set
		Adi_FecNac	= ltrim(rtrim(@Gpc_FecNac)),
		Adi_Sexo	= ltrim(rtrim(@Gpc_Sexo)),
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Adi_PerNum = @Gpc_Person
	
end	else if @Tip_Proces = @Pro_DesAgr begin		/*Desagrupacion de Registros*/
	/*Consulta de la persona del Cliente Unico ligada a la persona consultada*/
	select @Gpc_PrClUn = AdiUni.Adi_NumPer
	  from CLADICIO as AicionalOuter noholdlock
	 inner join CLCLIUNI as CliOuter noholdlock on CliOuter.Clu_Client = AicionalOuter.Adi_Client
	 inner join CLADICIO as AdiUni   noholdlock on CliOuter.Clu_Grupo = AdiUni.Adi_Client
	 where AicionalOuter.Adi_NumPer = @Gpc_Person
	 group by AdiUni.Adi_NumPer
	 
	/*Si existe le asigna la persona del Cliente Único*/
	if isnull(@Gpc_PrClUn, @Str_Vacio) <> @Str_Vacio begin
		select @Gpc_Grupo = @Gpc_PrClUn
	end else begin 
		select @Gpc_Grupo = @Gpc_Person
	end
	
	update SOUNIPER set
		Peu_Grupo = @Gpc_Grupo,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
	where Peu_Person = @Gpc_Person
	
	/*Salida: Notificación cambio Persona IDE*/
	select @Gpc_GrpAnt as Gpc_Person, @Gpc_Grupo as Gpc_Grupo
	
end	else if @Tip_Proces = @Pro_GruMin or @Tip_Proces = @Pro_GrClUn begin		/*Agrupacion de Registros*/

	if @Tip_Proces = @Pro_GrClUn begin 
		/*Consulta de la persona del Cliente Unico ligada a la persona consultada*/
		select @Gpc_PrClUn = Adi_NumPer
		  from CLCLIUNI noholdlock
		 inner join CLADICIO noholdlock on Clu_Grupo = Adi_Client
		 where Clu_Grupo = @Gpc_Grupo
		 
		/*Si existe le asigna la persona del Cliente Único*/
		if isnull(@Gpc_PrClUn, @Str_Vacio) <> @Str_Vacio begin
			select @Gpc_Grupo = @Gpc_PrClUn
		end else begin
			select @Gpc_Grupo = @Gpc_Person
		end
	end
	
	select @Gpc_Grupo = rtrim(ltrim(isnull(@Gpc_Grupo, @Str_Vacio)))
	
	if isnull(@Gpc_Grupo, @Str_Vacio) = @Str_Vacio begin
		select @Gpc_Grupo = AdiUni.Adi_NumPer
		  from CLADICIO as AicionalOuter noholdlock
		 inner join CLCLIUNI as CliOuter noholdlock on CliOuter.Clu_Client = AicionalOuter.Adi_Client
		 inner join CLADICIO as AdiUni   noholdlock on CliOuter.Clu_Grupo = AdiUni.Adi_Client
		 where AicionalOuter.Adi_NumPer = @Gpc_Person
		 group by AdiUni.Adi_NumPer
	end
	
	/*Consulta de grupo anterior*/
	select @Gpc_GrpAnt = Peu_Grupo
	  from SOUNIPER noholdlock
	 where Peu_Person = @Gpc_Person
	 
	if isnull(@Gpc_Grupo, @Str_Vacio) = @Str_Vacio begin
		select @Gpc_Grupo = @Gpc_GrpAnt
	end
	 
	if isnull(@Gpc_GrpAnt, @Str_Vacio) = @Str_Vacio and not exists(select @Ent_Uno from SOUNIPER where Peu_Grupo = @Gpc_Grupo and Peu_Person = @Gpc_Person) begin
		exec @Status = SOUNIPERALT @Gpc_Grupo, @Gpc_Person, @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino, @Modulo
		
		if @Status <> @Ent_Cero begin
			rollback
			return 1
		end
	end else if not exists(select @Ent_Uno from SOUNIPER where Peu_Grupo = @Gpc_Grupo and Peu_Person = @Gpc_Person) begin
		update SOUNIPER set
			Peu_Grupo = @Gpc_Grupo,
			
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where Peu_Person = @Gpc_Person
	end
	
	/*Salida: Notificación cambio Persona IDE*/
	select @Gpc_GrpAnt as Gpc_Person, @Gpc_Grupo as Gpc_Grupo
end