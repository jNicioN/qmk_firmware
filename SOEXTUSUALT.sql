create procedure SOEXTUSUALT (
	@Use_Numero		char(8) output,
	@Use_NumSuc		char(3),  
	@Use_FecCre		smalldatetime output,		
	@Use_NomUsu		varchar(40), 
	@Use_ApPaUs		varchar(40), 
	@Use_ApMaUs		varchar(40),
	@Use_FecNac		smalldatetime,			
	@Use_SexUsu		char(1),
	@Use_PaNaUs		char(3), 
	@Use_LuNaUs		varchar(50),
	@Use_CaDoUs		varchar(40),
	@Use_PrEnCa		varchar(40),
	@Use_SeEnCa		varchar(40), 
	@Use_NuDoUs		char(10),
	@Use_CoDoUs		varchar(150), 
	@Use_EntDom		char(3),
	@Use_LocDom		char(8), 
	@Use_CpDoUs		char(6),
	@Use_LaTeUs		char(8),
	@Use_TelUsu		char(15),
	@Use_CorUsu		varchar(50), 
	@Use_ActUsu		char(10),
	@Use_AcInUs		char(10), 
	@Use_OcuUsu		varchar(30), 
	@Use_TiIdUs		char(1), 
	@Use_NumIde		varchar(30),
	@Use_ViIdUs		char(1),
	@Use_FeExId		smalldatetime, 		
	@Use_FeVeId		smalldatetime, 
	@Use_CaDoEx		varchar(40), 
	@Use_NuDoEx		char(10), 
	@Use_CoDoEx		varchar(150), 
	@Use_LoDoEx		varchar(40),
	@Use_EnDoEx		varchar(40),
	@Use_PaDoEx		char(3), 
	@Use_CpDoEx		char(6),
	@Use_TelExt		varchar(20),

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
** Descripción : Alta de usuario extranjero para compra 		*
				 venta de dll									*
*****************************************************************
** Referencias: 												*
*****************************************************************
** creo: Francisco Minajas										*
** Fecha:	 04/05/2023											*
** JIRA:	 TRAAC-1450		     								*
*****************************************************************
*****************************************************************
** creo: Yhendi ochoa											*
** Descripcion:	se agrega validacion de cliente duplicado 		*
** Fecha:	 14/01/2025											*
** JIRA:	 TRAAC-9222	     									*
*****************************************************************
**/

declare	@Use_NoCoUs	varchar(120),	/*	Declaracion de Variables	*/
		@PerPersoID	int,
		@PerExist	int,
		@Err_Descri	char(12),
		@Une_Identi char(8)

declare	@Str_Vacio	char(1),		/*	Declaracion de Constantes	*/
		@Str_Espaci	char(1),
		@Sta_ActIna	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Si		char(1),
		@Str_No		char(1),
		@Per_PaiMex	char(3),
		@Sta_Inacti	char(1)

select	@Str_Vacio	= '',			/*	String Vacio	*/
		@Str_Espaci	= ' ',			/*	String Espacio	*/
		@Sta_ActIna = 'I',			/* Status de actividad inactiva */
		@Ent_Cero	= 0,			/* Entero en Cero */
		@Ent_Uno	= 1,			/* Entero en Uno */
		@Str_Si		= 'S',			/* String Si						*/
		@Str_No		= 'N',			/* String No						*/
		@Per_PaiMex	= '001',		/* Pais de Nacionalidad: Mexico		*/
	 	@Sta_Inacti	= 'I'			/* Status Inactivo para validar localidad y entidad */		

									/*  VALIDACIONES GENERALES */
if isnull(@Use_NomUsu, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Proporcione el Nombre',
			Err_Variab	= 'Use_NomUsu'
	rollback
	return @Ent_Uno
end

if isnull (@Use_ApPaUs, @Str_Vacio ) = @Str_Vacio  begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Proporcione el Apellido paterno',
			Err_Variab	= 'Use_ApPaUs'
	rollback
	return @Ent_Uno
end

if isnull (@Use_ApMaUs, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Proporcione el Apellido materno' + @Err_Descri,
			Err_Variab	= 'Use_ApMaUs'
	rollback
	return @Ent_Uno
end

if isnull (@Use_FecNac, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000004',
			Err_Mensaj	= 'Proporcione fecha de Nacimiento',
			Err_Variab  = 'Use_FecNac'
	rollback
	return @Ent_Uno
end


select @Use_NoCoUs = (ltrim(rtrim(@Use_ApPaUs))+' '+ltrim(rtrim(@Use_ApMaUs))+' '+ltrim(rtrim(@Use_NomUsu)))

/*---------------- VALIDAR SI EXISTE USUARIO ----------------*/
select	@PerExist = @Ent_Cero
select	@PerExist = @Ent_Uno
			from SOUSUEXT noholdlock
			where	Use_NomUsu	= @Use_NomUsu
			  and	Use_ApPaUs	= @Use_ApPaUs
			  and	Use_ApMaUs  = @Use_ApMaUs
			  and	Use_FecNac	= @Use_FecNac
			  
select	@PerExist	= @Ent_Uno
			from SOUSUEXT noholdlock
			where	Use_NoCoUs	= @Use_NoCoUs
			  and	Use_FecNac	= @Use_FecNac


select	@PerExist = isnull(@PerExist, @Ent_Cero)

if @PerExist <> @Ent_Cero begin
	
	select @Une_Identi = right('00000000' + ltrim(rtrim(convert(char, Une_Identi))), 8) from SOUSNAEX noholdlock
	inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
	where Use_NomUsu = @Use_NomUsu
		and	Use_ApPaUs	= @Use_ApPaUs
		and	Use_ApMaUs  = @Use_ApMaUs
		and	Use_FecNac	= @Use_FecNac
	
	select	Err_Codigo	= '000005',
			Err_Mensaj	= 'El usuario ' + @Une_Identi + ' ya existe',
			Err_Variab	= 'Use_NoCoUs'
		rollback
		return @Ent_Uno
end
/*----------------------------------------------*/

if @Use_FecCre <= convert(smalldatetime, '01/01/1990') begin
	select	@Use_FecCre	= @FechaSis
end
	
if isnull( @Use_SexUsu, @Str_Vacio ) = @Str_Vacio  begin
	select	Err_Codigo	= '000006',
			Err_Mensaj	= 'Proporcione el sexo del usuario',
			Err_Variab	= 'Use_SexUsu'
	rollback
	return @Ent_Uno
end

if isnull(@Use_PaNaUs, @Str_Vacio ) = @Str_Vacio begin
	select	Err_Codigo	= '0000007',
			Err_Mensaj	= 'Proporcione Pais de Nacimiento',
			Err_Variab	= 'Use_PaNaUs'
end else if not exists ( select	Pai_Numero
		from SOPAIS noholdlock
		where	Pai_Numero	= @Use_PaNaUs) begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'Nacionalidad  Incorrecta',
				Err_Variab	= 'Use_PaNaUs'
end

if isnull(@Use_LuNaUs, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000009',
			Err_Mensaj	= 'Proporcione el lugar de nacimiento',
			Err_Variab	= 'Use_LuNaUs'
	rollback
	return @Ent_Uno
end

if isnull(@Use_TiIdUs, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000010',
			Err_Mensaj	= 'Proporcione Tipo de Identificacion',
			Err_Variab	= 'Use_TiIdUs'
	rollback
	return @Ent_Uno
end

if isnull(@Use_NumIde, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000011',
			Err_Mensaj	= 'Proporcione Numero de Identificacion',
			Err_Variab	= 'Use_NumIde'
	rollback
	return @Ent_Uno
end

if @Use_FeExId <= convert(smalldatetime, '01/01/1990') begin
	select	Err_Codigo	= '000012',
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
	select	Err_Codigo	= '000013',
			Err_Mensaj	= 'Proporcione Calle de Domicilio Extranjero',
			Err_Variab	= 'Use_CaDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_NuDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000014',
			Err_Mensaj	= 'Proporcione Numero en Calle del Domicilio Extranjero',
			Err_Variab	= 'Use_NuDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_CoDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000015',
			Err_Mensaj	= 'Proporcione Colonia del Domicilio Extranjero',
			Err_Variab	= 'Use_CoDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_LoDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000016',
			Err_Mensaj	= 'Proporcione Localidad del Domicilio Extranjero',
			Err_Variab	= 'Use_LoDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_EnDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000017',
			Err_Mensaj	= 'Proporcione Entidad del Domicilio Extranjero',
			Err_Variab	= 'Use_EnDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_PaDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000018',
			Err_Mensaj	= 'Proporcione Pais de Domicilio extranjero',
			Err_Variab	= 'Use_PaDoEx'
	rollback
	return @Ent_Uno
end

if isnull(@Use_CpDoEx, @Str_Vacio) = @Str_Vacio begin
	select	Err_Codigo	= '000019',
			Err_Mensaj	= 'Proporcione Codigo Postal de Domicilio extranjero',
			Err_Variab	= 'Use_CpDoEx'
	rollback
	return @Ent_Uno
end

insert into SOUSUEXT (
	Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs, Use_ApMaUs,	
	Use_NoCoUs, Use_FecNac, Use_SexUsu, Use_PaNaUs, Use_LuNaUs, 
	Use_CaDoUs,	Use_PrEnCa, Use_SeEnCa, Use_NuDoUs, Use_CoDoUs, 
	Use_EntDom,	Use_LocDom, Use_CpDoUs, Use_LaTeUs, Use_TelUsu,
	Use_CorUsu,	Use_ActUsu, Use_AcInUs, Use_OcuUsu, Use_TiIdUs,	
	Use_NumIde, Use_ViIdUs, Use_FeExId, Use_FeVeId, Use_CaDoEx, 
	Use_NuDoEx,	Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, Use_PaDoEx,	
	Use_CpDoEx,	Use_TelExt, NumTransac, Transaccio, Usuario,    
	FechaSis, 	SucOrigen,  SucDestino		
) values	(
	@SucOrigen, @Use_FecCre, @Use_NomUsu, @Use_ApPaUs, @Use_ApMaUs,	
	@Use_NoCoUs, @Use_FecNac, @Use_SexUsu, @Use_PaNaUs, @Use_LuNaUs, 	
	@Use_CaDoUs, @Use_PrEnCa, @Use_SeEnCa, @Use_NuDoUs, @Use_CoDoUs, 
	@Use_EntDom, @Use_LocDom, @Use_CpDoUs, @Use_LaTeUs, @Use_TelUsu,	
	@Use_CorUsu, @Use_ActUsu, @Use_AcInUs, @Use_OcuUsu, @Use_TiIdUs, 	
	@Use_NumIde, @Use_ViIdUs, @Use_FeExId, @Use_FeVeId, @Use_CaDoEx, 	
	@Use_NuDoEx, @Use_CoDoEx, @Use_LoDoEx, @Use_EnDoEx, @Use_PaDoEx,		
	@Use_CpDoEx, @Use_TelExt, @NumTransac, @Transaccio, @Usuario,    
	@FechaSis,   @SucOrigen,  @SucDestino		
)

select @PerPersoID = @@identity

select	@Use_Numero	= convert(char(8), @PerPersoID)

if @Use_Numero = @Str_Vacio begin
		rollback
		return @Ent_Uno
end


if @@nestlevel = @Ent_Uno
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro agregado',
			Use_Numero	= @Use_Numero,
			Use_FecCre	= @Use_FecCre
