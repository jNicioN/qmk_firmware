create procedure SOEXTUSUMOD (
	/* Datos personales */
	@Use_TiIdUs		char(1), 
	@Use_NumIde		varchar(30),
	@Use_FeExId		smalldatetime, 		
	@Use_FeVeId		smalldatetime, 
	@Use_SexUsu		char(1),
	@Use_PaNaUs		char(3), 
	@Use_LuNaUs		varchar(50),
	@Use_CaDoEx		varchar(40), 
	@Use_NuDoEx		char(10), 
	@Use_CoDoEx		varchar(150), 
	@Use_LoDoEx		varchar(40),
	@Use_EnDoEx		varchar(40),
	@Use_PaDoEx		char(3), 
	@Use_CpDoEx		char(6),
	@Use_EntDom		char(3),
	/* datos de contacto  */
	@Use_Numero		char(8) output,
	@Use_CaDoUs		varchar(40),
	@Use_PrEnCa		varchar(40),
	@Use_SeEnCa		varchar(40), 
	@Use_NuDoUs		char(10),
	@Use_CoDoUs		varchar(150), 
	@Use_LocDom		char(8), 
	@Use_CpDoUs		char(6),
	@Use_LaTeUs		char(8),
	@Use_TelUsu		char(15),
	@Use_CorUsu		varchar(50), 
	/* actividad profesional  */
	@Use_ActUsu		char(10),
	@Use_AcInUs		char(10), 
	@Use_OcuUsu		varchar(30), 

	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**
*****************************************************************
** Descripción : Modificacion para los datos de Usuarios 		*
				 extranjeros compra venta						*
*****************************************************************
** Referencias: 												*
*****************************************************************
*****************************************************************
** creo: Francisco Minajas										*
** Fecha:	 04/05/2023											*
** JIRA:	 TRAAC-1450		     								*
*****************************************************************
**/
									/*	Declaracion de Variables	*/
declare @Use_NumInt int,
		@Use_ViIdUs	char(1),
		@Ent_Identi	int,
		@Control	int			--variable para saber que valor retornar dependiendo de los datos actualizados

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Sta_ActIna	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Si		char(1),
		@Str_No		char(1),
		@Per_PaiMex	char(3),
		@Sta_Inacti	char(1),
		@Tip_Uno 	char(2),
		@Tip_Dos	char(2),
		@Tip_Tres	char(2)

select	@Str_Vacio	= '',			/*	String Vacio	*/
		@Str_Espaci	= ' ',			/*	String Espacio	*/
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1,			/* Entero en Uno */
		@Str_Si		= 'S',			/* String Si						*/
		@Str_No		= 'N',			/* String No						*/
		@Per_PaiMex	= '001',		/* Pais de Nacionalidad: Mexico		*/
	 	@Sta_Inacti	= 'I',			/* Status Inactivo para validar localidad y entidad */		
		@Tip_Uno	= '1',			/* Actualizacion de datos personales */		
		@Tip_Dos	= '2',			/* Actualizacion de datos de contacto */	
		@Tip_Tres	= '3'			/* Actualizacion de actividad profesional */			
		
select @Ent_Identi = (convert(int, @Use_Numero ))  /* use_nuero es el identiti de la tabla de relacion  */
	
	if isnull(@Use_Numero, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000013',
				Err_Mensaj	= 'Proporcione numero de usuario'
		rollback
		return @Ent_Uno
	end
	
	select	@Use_NumInt	= (convert(int, @Use_Numero ))

if @Use_TiIdUs <> @Str_Vacio begin /* si recibe tipo de ID valida los siguentes campos de datos personales */

	if isnull(@Use_TiIdUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Proporcione Tipo de Identificacion',
				Err_Variab	= 'Use_TiIdUs'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_NumIde, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Proporcione Numero de Identificacion',
				Err_Variab	= 'Use_NumIde'
		rollback
		return @Ent_Uno
	end

	if @Use_FeExId <= convert(smalldatetime, '01/01/1990') begin
		select	Err_Codigo	= '000004',
				Err_Mensaj	= 'Fecha de expedicion de identificacion incorrecta',
				Err_Variab  = 'Use_FeExId'
		rollback
		return @Ent_Uno
	end

	if @Use_FeVeId <= convert(smalldatetime, '01/01/1990') begin
		select @Use_ViIdUs = 'N'
	end

	if @Use_FeVeId > convert(smalldatetime, '01/01/1990') begin
		select @Use_ViIdUs = 'S'
	end

	if isnull(@Use_CaDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'Proporcione Calle de Domicilio Extranjero',
				Err_Variab	= 'Use_CaDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_NuDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000006',
				Err_Mensaj	= 'Proporcione Numero en Calle del Domicilio Extranjero',
				Err_Variab	= 'Use_NuDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_CoDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000007',
				Err_Mensaj	= 'Proporcione Colonia del Domicilio Extranjero',
				Err_Variab	= 'Use_CoDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_LoDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'Proporcione Localidad del Domicilio Extranjero',
				Err_Variab	= 'Use_LoDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_EnDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000009',
				Err_Mensaj	= 'Proporcione Entidad del Domicilio Extranjero',
				Err_Variab	= 'Use_EnDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_PaDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000010',
				Err_Mensaj	= 'Proporcione Pais de Domicilio extranjero',
				Err_Variab	= 'Use_PaDoEx'
		rollback
		return @Ent_Uno
	end

	if isnull(@Use_CpDoEx, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000011',
				Err_Mensaj	= 'Proporcione Codigo Postal de Domicilio extranjero',
				Err_Variab	= 'Use_CpDoEx'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_EntDom, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000012',
				Err_Mensaj	= 'Proporcione la entidad',
				Err_Variab	= 'Use_EntDom'
		rollback
		return @Ent_Uno
	end
	
	select @Control = @Ent_Uno
	
end else begin  /* si no, toma los actuales que esten en la tabla */

	select  @Use_TiIdUs = Use_TiIdUs, 
			@Use_NumIde = Use_NumIde,
			@Use_FeExId = Use_FeExId,		
			@Use_FeVeId = Use_FeVeId,
			@Use_SexUsu = Use_SexUsu,		
			@Use_PaNaUs = Use_PaNaUs,		 
			@Use_LuNaUs = Use_LuNaUs,		
			@Use_CaDoEx = Use_CaDoEx,		 
			@Use_NuDoEx = Use_NuDoEx,		 
			@Use_CoDoEx = Use_CoDoEx,		 
			@Use_LoDoEx = Use_LoDoEx,		
			@Use_EnDoEx = Use_EnDoEx,		
			@Use_PaDoEx = Use_PaDoEx,		
			@Use_CpDoEx = Use_CpDoEx,
			@Use_EntDom = Use_EntDom	
	from 	SOUSUEXT noholdlock
	where	Use_IdUsEx	= @Use_NumInt

end

if @Use_CaDoUs <> @Str_Vacio begin /* si recibe el campo calle valida los siguentes campos correspondientes a datos de contacto */								
	
	if isnull(@Use_CaDoUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000014',
				Err_Mensaj	= 'Proporcione la calle',
				Err_Variab	= 'Use_CaDoUs'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_PrEnCa, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000015',
				Err_Mensaj	= 'Proporcione la primera entrecalle',
				Err_Variab	= 'Use_PrEnCa'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_SeEnCa, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000016',
				Err_Mensaj	= 'Proporcione la segunda entrecalle',
				Err_Variab	= 'Use_SeEnCa'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_NuDoUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000017',
				Err_Mensaj	= 'Proporcione numero de domicilio',
				Err_Variab	= 'Use_NuDoUs'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_CoDoUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000018',
				Err_Mensaj	= 'Proporcione la colonia',
				Err_Variab	= 'Use_CoDoUs'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_EntDom, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000019',
				Err_Mensaj	= 'Proporcione la entidad',
				Err_Variab	= 'Use_EntDom'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_LocDom, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000020',
				Err_Mensaj	= 'Proporcione la localidad',
				Err_Variab	= 'Use_LocDom'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_CpDoUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000021',
				Err_Mensaj	= 'Proporcione el codigo postal',
				Err_Variab	= 'Use_CpDoUs'
		rollback
		return @Ent_Uno
	end
		
	if isnull(@Use_LaTeUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000022',
				Err_Mensaj	= 'Proporcione la lada',
				Err_Variab	= 'Use_LaTeUs'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_TelUsu, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000023',
				Err_Mensaj	= 'Proporcione el telefono',
				Err_Variab	= 'Use_TelUsu'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_CorUsu, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000024',
				Err_Mensaj	= 'Proporcione el correo electronico',
				Err_Variab	= 'Use_CorUsu'
		rollback
		return @Ent_Uno
	end 
	
	select @Control = @Ent_Cero
	
end else begin  /* si no, toma los actuales que esten en la tabla */

	select  @Use_CaDoUs = Use_CaDoUs,	
			@Use_PrEnCa = Use_PrEnCa,	
			@Use_SeEnCa = Use_SeEnCa,	
			@Use_NuDoUs = Use_NuDoUs,	
			@Use_CoDoUs = Use_CoDoUs,		
			@Use_EntDom = Use_EntDom,		
			@Use_LocDom = Use_LocDom,		
			@Use_CpDoUs = Use_CpDoUs,		
			@Use_LaTeUs = Use_LaTeUs,	
			@Use_TelUsu = Use_TelUsu,	
			@Use_CorUsu = Use_CorUsu
	from 	SOUSUEXT noholdlock
	where	Use_IdUsEx	= @Use_NumInt

end

if @Use_ActUsu <> @Str_Vacio begin  /* si recibe la actividad valida los siguientes datos de actividad profesional */

	if isnull(@Use_ActUsu, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000025',
				Err_Mensaj	= 'Proporcione la actividad',
				Err_Variab	= 'Use_ActUsu'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_AcInUs, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000026',
				Err_Mensaj	= 'Proporcione actividad segun INEGI',
				Err_Variab	= 'Use_AcInUs'
		rollback
		return @Ent_Uno
	end
	
	if isnull(@Use_OcuUsu, @Str_Vacio) = @Str_Vacio begin
		select	Err_Codigo	= '000027',
				Err_Mensaj	= 'Proporcione la ocupacion',
				Err_Variab	= 'Use_OcuUsu'
		rollback
		return @Ent_Uno
	end
	
	select @Control = @Ent_Cero

end else begin  /* si no, toma los actuales que esten en la tabla */

	select  @Use_ActUsu = Use_ActUsu,
			@Use_AcInUs = Use_AcInUs,	
			@Use_OcuUsu = Use_OcuUsu
	from 	SOUSUEXT noholdlock
	where	Use_IdUsEx	= @Use_NumInt

end

	update SOUSUEXT set
			Use_TiIdUs = @Use_TiIdUs, 
			Use_NumIde = @Use_NumIde,
			Use_FeExId = @Use_FeExId,		
			Use_FeVeId = @Use_FeVeId,
			Use_SexUsu = @Use_SexUsu,		
			Use_PaNaUs = @Use_PaNaUs,		 
			Use_LuNaUs = @Use_LuNaUs,		
			Use_CaDoEx = @Use_CaDoEx,		 
			Use_NuDoEx = @Use_NuDoEx,		 
			Use_CoDoEx = @Use_CoDoEx,		 
			Use_LoDoEx = @Use_LoDoEx,		
			Use_EnDoEx = @Use_EnDoEx,		
			Use_PaDoEx = @Use_PaDoEx,		
			Use_CpDoEx = @Use_CpDoEx,
			Use_EntDom = @Use_EntDom,		
			
			Use_CaDoUs = @Use_CaDoUs,	
			Use_PrEnCa = @Use_PrEnCa,	
			Use_SeEnCa = @Use_SeEnCa,	
			Use_NuDoUs = @Use_NuDoUs,	
			Use_CoDoUs = @Use_CoDoUs,		
			Use_LocDom = @Use_LocDom,		
			Use_CpDoUs = @Use_CpDoUs,		
			Use_LaTeUs = @Use_LaTeUs,	
			Use_TelUsu = @Use_TelUsu,	
			Use_CorUsu = @Use_CorUsu, 

			Use_ActUsu = @Use_ActUsu,
			Use_AcInUs = @Use_AcInUs,	
			Use_OcuUsu = @Use_OcuUsu,	

			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
	where	Use_IdUsEx	= @Use_NumInt
	
	if @@nestlevel = @Ent_Uno 
		select	Err_Codigo	= '000000',
				Err_Mensaj	= 'Registro modificado',
				Use_Numero	= @Ent_Identi
