create procedure SOUSUEXTCON (
	@Use_IdUsEx	int,
	@Use_NoCoUs	varchar(150),
	@Use_NomUsu	varchar(181),
	@Use_ApPaUs	varchar(181),
	@Use_ApMaUs	varchar(181),
	@Use_FecNac smalldatetime,
	@Use_TiIdUs char(1),
	@Use_NumIde	varchar(30),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/**
*****************************************************************
** Descripción : Consulta de usuario extranjero para compra 	*
				 venta de dll									*
*****************************************************************
** Referencias: 												*
*****************************************************************
** Modifico:	Adriana Gomez								 ****
** Fecha:		03/02/2021   								 ****
** Descripcion: Se corta la busqueda a 8 digitos 			 ****
** Help Desk:	1376175							 			 ****
*****************************************************************
** modifico: 	Carlos Copto									*
** Fecha:	 	10/12/2020										*
** Help:		1376175 										*
** Descripcion: Se agrega trim a la vaiable de nombre y se 		*
**				agrega retornar el campo Une_Estatu de SOUSNAEX	*
**				en consulta 1 y C1								*
*****************************************************************
** Creo:			Adriana Gomez								*
** Fecha:			28/nov/2020									*
** Help:			1376175 									*
** Descripcion:		se agrega retorno de folio de cv 			*
*****************************************************************
** creo:	 Adriana Gomez										*
** Fecha:	 04/05/2020											*
** Help:	 1376175			     							*
*****************************************************************
**/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Str_LuNaNu varchar(8),		-- String Numero de lugar de nacimiento
		@Ent_Identi	int, 
		@Ent_Contad	int,
		@Use_LuNaUs varchar(50),
		@Ent_Total  int,
		@Ent_Consec int,
		@Une_Estatu char(1),
		@Usu_Numero varchar(8)

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Str_Porcen	char(1),
		@Str_Coma	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ent_Ocho	int,
		@Sta_Activo	char(1),
		@Tip_TabNac char(1),
		@Tip_TabExt char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',			-- String Vacio
		@Str_Porcen	= '%',			-- String Porcentaje
		@Str_Coma	= ',',			-- String Coma
		@Ent_Cero	= 0,			-- Entero : 0
		@Ent_Uno	= 1,			-- Entero : 1
		@Ent_Ocho	= 8,			-- Entero : 8
		@Sta_Activo	= 'A',			-- Status: Activo
		@Tip_TabNac = '1',			/* Tabla Usuarios Nacionales SOPERSON */
		@Tip_TabExt = '2'           /* Tabla Usuarios Extrajeros SOUSUEXT */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

select @Ent_Identi = @Use_IdUsEx /* idUsEx que se recibe es el identiti de la tabla de relacion  */
select @Use_NoCoUs = ltrim(rtrim(@Use_NoCoUs))  /* se le quitan espacios extremos al nombre que se busca */

/* se obtiene el id y el estatus del usuario, de la tabla de extranjero con el que se hace la consulta */
select @Use_IdUsEx = Une_IdeUsu,
	   @Une_Estatu = Une_Estatu
from SOUSNAEX noholdlock 
inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
where Une_Identi = @Use_IdUsEx
	
if @Tip_ConTip = 'C' begin
	if @Tip_ConCon	= '1' begin
		
		select @Str_LuNaNu = Loc_Numero 
		from CLLOCALI noholdlock 
		inner join SOUSUEXT noholdlock on substring(Use_LuNaUs, 1, charindex(',', Use_LuNaUs) - 1) = Loc_Nombre and Loc_Status = @Sta_Activo
		where	Use_IdUsEx	= @Use_IdUsEx
		and Use_LuNaUs is not null and charindex(',',  Use_LuNaUs ) > 0
	
		select	Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs,
				Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu, Use_PaNaUs,
				@Str_LuNaNu as Use_LuNaUs , Use_CaDoUs, Use_PrEnCa, Use_SeEnCa, Use_NuDoUs,
				Use_CoDoUs, Use_EntDom, Use_LocDom, Use_CpDoUs, Use_LaTeUs,
				Use_TelUsu, Use_CorUsu, Use_ActUsu, Use_OcuUsu, Use_TiIdUs,
				Use_NumIde, Use_FeExId, Use_FeVeId, Use_CaDoEx, Use_NuDoEx,
				Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, Use_PaDoEx, Use_CpDoEx,
				Use_TelExt, @Ent_Identi as Use_Numero, @Une_Estatu as Une_Estatu
			from SOUSUEXT noholdlock
			where	Use_IdUsEx	=  @Use_IdUsEx
	end
	if @Tip_ConCon	= '2' begin
		select	Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs,
				Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu, Use_PaNaUs,
				Use_LuNaUs, Use_CaDoUs, Use_PrEnCa, Use_SeEnCa, Use_NuDoUs,
				Use_CoDoUs, Use_EntDom, Use_LocDom, Use_CpDoUs, Use_LaTeUs,
				Use_TelUsu, Use_CorUsu, Use_ActUsu, Use_OcuUsu, Use_TiIdUs,
				Use_NumIde, Use_FeExId, Use_FeVeId, Use_CaDoEx, Use_NuDoEx,
				Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, Use_PaDoEx, Use_CpDoEx,
				Use_TelExt
			from SOUSUEXT noholdlock
			where	Use_NomUsu	= @Use_NomUsu
			  and	Use_ApPaUs	= @Use_ApPaUs
			  and	Use_ApMaUs  = @Use_ApMaUs
			  and	Use_FecNac	= @Use_FecNac
	end
	if @Tip_ConCon	= '3' begin
		select	Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs,
				Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu, Use_PaNaUs,
				Use_LuNaUs, Use_CaDoUs, Use_PrEnCa, Use_SeEnCa, Use_NuDoUs,
				Use_CoDoUs, Use_EntDom, Use_LocDom, Use_CpDoUs, Use_LaTeUs,
				Use_TelUsu, Use_CorUsu, Use_ActUsu, Use_OcuUsu, Use_TiIdUs,
				Use_NumIde, Use_FeExId, Use_FeVeId, Use_CaDoEx, Use_NuDoEx,
				Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, Use_PaDoEx, Use_CpDoEx,
				Use_TelExt
			from SOUSUEXT noholdlock
			where	Use_NoCoUs	= @Use_NoCoUs
			  and	Use_FecNac	= @Use_FecNac
	end
	if @Tip_ConCon = '4' begin
		select	Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs,
				Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu, Use_PaNaUs,
				Use_LuNaUs, Use_CaDoUs, Use_PrEnCa, Use_SeEnCa, Use_NuDoUs,
				Use_CoDoUs, Use_EntDom, Use_LocDom, Use_CpDoUs, Use_LaTeUs,
				Use_TelUsu, Use_CorUsu, Use_ActUsu, Use_OcuUsu, Use_TiIdUs,
				Use_NumIde, Use_FeExId, Use_FeVeId, Use_CaDoEx, Use_NuDoEx,
				Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, Use_PaDoEx, Use_CpDoEx,
				Use_TelExt
			from SOUSUEXT noholdlock
			where	Use_IdUsEx	=  @Use_IdUsEx
	end
end	else begin
	if @Tip_ConCon	= '1' begin	
		
		create table #UsuarioCompVentDola(
			Use_Consec  int identity,
			Use_FolUsu	char(8), /*folio usuario c/V*/
			Use_IdUsEx	char(8), /* id tabla  */
			Use_NumSuc  char(3),
			Use_FecCre	smalldatetime,
			Use_NomUsu	varchar(40),
			Use_ApPaUs	varchar(40),
			Use_ApMaUs	varchar(40),
			Use_NoCoUs  varchar(120),
			Use_FecNac	smalldatetime,
			Use_SexUsu  char(1),
			Use_PaNaUs  char(3),
			Use_LuNaUs  char(8),
			Use_RFC     varchar(15),
			Use_CURP    char(18),
			Use_CaDoUs	varchar(40),
			Use_PrEnCa	varchar(40),
			Use_SeEnCa	varchar(40),
			Use_NuDoUs	varchar(10),
			Use_CoDoUs	varchar(40),
			Use_EntDom	char(3),
			Use_LocDom	char(8),
			Use_CpDoUs	char(6),
			Use_LaTeUs	char(8), 
			Use_TelUsu  char(8), 
			Use_CorUsu  varchar(50), 
			Use_ActUsu  char(10), 
			Use_OcuUsu  varchar(30), 
			Use_TiIdUs  char(1), 
			Use_NumIde  varchar(30), 
			Use_FeExId	smalldatetime, 
			Use_FeVeId  smalldatetime, 
			Use_CaDoEx  varchar(40), 
			Use_NuDoEx  char(10), 
			Use_CoDoEx  varchar(150), 
			Use_LoDoEx  varchar(40), 
			Use_EnDoEx  varchar(40), 
			Use_PaDoEx  char(3), 
			Use_CpDoEx  char(6),	
			Use_TelExt  varchar(20),
			Use_LugNac  varchar(50),
			Une_Estatu  varchar(1)
		)
	
		
		if ISNUMERIC(@Use_NoCoUs) = @Ent_Uno begin
			/*Usuarios Compra Venta de Dlls Extranjeros*/
			if char_length(ltrim(rtrim(@Use_NoCoUs))) > @Ent_Ocho begin
				select	@Use_NoCoUs = substring(@Use_NoCoUs,@Ent_Uno,@Ent_Ocho)
			end

			insert into #UsuarioCompVentDola
				select	 right('00000000' + ltrim(rtrim(convert(char, Une_Identi))), 8) as 
						Use_FolUsu, right('00000000' + ltrim(rtrim(convert(char,  Une_IdeUsu ))), 8) as 
						Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs, 
						Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu,	Use_PaNaUs, 
						'', 		'',			'',			Use_CaDoUs, Use_PrEnCa, 
						Use_SeEnCa, Use_NuDoUs, Use_CoDoUs, Use_EntDom, Use_LocDom, 
						Use_CpDoUs, Use_LaTeUs, Use_TelUsu, Use_CorUsu, Use_ActUsu, 
						Use_OcuUsu, Use_TiIdUs, Use_NumIde, Use_FeExId, Use_FeVeId, 
						Use_CaDoEx, Use_NuDoEx, Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, 
						Use_PaDoEx, Use_CpDoEx,	Use_TelExt, Use_LuNaUs,	Une_Estatu
				from SOUSNAEX noholdlock 
				join SOUSUEXT  noholdlock on Une_IdeUsu = Use_IdUsEx  
				where Une_TabOri = @Tip_TabExt
				and Une_Identi	= convert(int, @Use_NoCoUs)	
			
			select @Ent_Total =  count(*) from #UsuarioCompVentDola
			
			if @Ent_Total> @Ent_Cero begin
				select @Ent_Consec = min(Use_Consec) from #UsuarioCompVentDola noholdlock 
				select 	@Ent_Contad = @Ent_Uno
				
				while @Ent_Contad <= @Ent_Total begin
					select @Use_LuNaUs  = Use_LugNac from #UsuarioCompVentDola noholdlock 
										where Use_Consec= @Ent_Consec
					if @Use_LuNaUs is not null 
						and charindex(',',  @Use_LuNaUs ) > 0 begin
					
						select @Use_LuNaUs= Loc_Numero 
						from CLLOCALI noholdlock 
						where Loc_Status = @Sta_Activo 
						and Loc_Nombre = substring(@Use_LuNaUs, 1, charindex(',',  @Use_LuNaUs ) - 1)
					
						update  #UsuarioCompVentDola  set Use_LuNaUs = @Use_LuNaUs
						where  Use_Consec= @Ent_Consec
					end
					select @Ent_Contad = @Ent_Contad + @Ent_Uno
					select @Ent_Consec = @Ent_Consec + @Ent_Uno
				end
			end
				
		/*Usuarios Compra Venta de Dlls Nacionales*/	
			insert into #UsuarioCompVentDola
				select	 right('00000000' + ltrim(rtrim(convert(char, Une_Identi))), 8) as 
						Use_FolUsu, right('00000000' + ltrim(rtrim(convert(char,  Une_IdeUsu ))), 8) as 
						Use_IdUsEx, '',  		Per_Fecha,  Per_Nombre, Per_ApePat, 
						Per_ApeMat, Per_Comple, Adi_FecNac, Adi_Sexo,   Per_Nacion, 
						Per_Locali, Per_RFC,	Per_CURP,   Per_Calle, 	'', 
						'', 		Per_CalNum, Per_Coloni, Per_Entida, Per_Locali, 
						Per_CodPos, Per_LadTel, Per_Telefo, Per_Email, 	Per_Activi, 
						Adi_Ocupac, Adi_TipIde, Adi_TipIde, Adi_FeExId, Adi_FeVeId, 
						'', 		'', 		'', 		'', 		'', 
						'', 		'',			'', 		'',			Une_Estatu
				from SOUSNAEX noholdlock 
				join SOPERSON noholdlock on  PerPersoID = Une_IdeUsu  
				join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				where Une_TabOri = @Tip_TabNac
				and Une_Identi	= convert(int, @Use_NoCoUs)	
			
		end else begin
			select	@Use_NoCoUs	= ltrim(rtrim(@Use_NoCoUs)) + '%'
			
			/*Usuarios Compra Venta de Dlls Extranjeros*/
			insert into #UsuarioCompVentDola
				select	  right('00000000' + ltrim(rtrim(convert(char, Une_Identi))), 8) as 
						Use_FolUsu, right('00000000' + ltrim(rtrim(convert(char,  Une_IdeUsu ))), 8) as 
						Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, Use_ApPaUs, 
						Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu,	Use_PaNaUs, 
						'', 		'',			'',			Use_CaDoUs, Use_PrEnCa, 
						Use_SeEnCa, Use_NuDoUs, Use_CoDoUs, Use_EntDom, Use_LocDom, 
						Use_CpDoUs, Use_LaTeUs, Use_TelUsu, Use_CorUsu, Use_ActUsu, 
						Use_OcuUsu, Use_TiIdUs, Use_NumIde, Use_FeExId, Use_FeVeId, 
						Use_CaDoEx, Use_NuDoEx, Use_CoDoEx, Use_LoDoEx, Use_EnDoEx, 
						Use_PaDoEx, Use_CpDoEx,	Use_TelExt, Use_LuNaUs,	Une_Estatu
				from SOUSNAEX noholdlock 
				join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx  
				where Une_TabOri = @Tip_TabExt
				and  Use_NoCoUs  like @Use_NoCoUs
					
				select @Ent_Total =  count(*) from #UsuarioCompVentDola
			
			if @Ent_Total> @Ent_Cero begin
				
				select @Ent_Consec = min(Use_Consec) 
				from #UsuarioCompVentDola noholdlock 
				select 	@Ent_Contad = @Ent_Uno
				
				while @Ent_Contad <= @Ent_Total begin
					
					select @Use_LuNaUs  = Use_LugNac 
					from #UsuarioCompVentDola noholdlock 
					where Use_Consec= @Ent_Consec
					
					if @Use_LuNaUs is not null 
						and charindex(',',  @Use_LuNaUs ) > 0 begin
					
						select @Use_LuNaUs = Loc_Numero 
						from CLLOCALI noholdlock 
						where Loc_Status = @Sta_Activo 
						and Loc_Nombre = substring(@Use_LuNaUs, 1, charindex(',',  @Use_LuNaUs ) - 1)
					
						update  #UsuarioCompVentDola  set Use_LuNaUs = @Use_LuNaUs
						where  Use_Consec = @Ent_Consec
					end
					select @Ent_Contad = @Ent_Contad + @Ent_Uno
					select @Ent_Consec = @Ent_Consec + @Ent_Uno
				end
			end
				
		/*Usuarios Compra Venta de Dlls Nacionales*/	
		insert into #UsuarioCompVentDola
				select	 right('00000000' + ltrim(rtrim(convert(char, Une_Identi))), 8) as 
						Use_FolUsu, right('00000000' + ltrim(rtrim(convert(char,  Une_IdeUsu ))), 8) as 
						Use_IdUsEx, '',  		Per_Fecha,  Per_Nombre, Per_ApePat, 
						Per_ApeMat, Per_Comple, Adi_FecNac, Adi_Sexo,   Per_Nacion, 
						Per_Locali, Per_RFC,	Per_CURP,   Per_Calle, 	'', 
						'', 		Per_CalNum, Per_Coloni, Per_Entida, Per_Locali, 
						Per_CodPos, Per_LadTel, Per_Telefo, Per_Email, 	Per_Activi, 
						Adi_Ocupac, Adi_TipIde, Adi_TipIde, Adi_FeExId, Adi_FeVeId, 
						'', 		'', 		'', 		'', 		'', 
						'', 		'',			'',			'',			Une_Estatu
				from SOUSNAEX noholdlock 
				join SOPERSON noholdlock on  PerPersoID = Une_IdeUsu  
				join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				where Une_TabOri = @Tip_TabNac
				and Per_Comple	like @Use_NoCoUs		
		end
		
		select  Use_FolUsu, Use_IdUsEx, Use_NumSuc, Use_FecCre, Use_NomUsu, 
				Use_ApPaUs, Use_ApMaUs, Use_NoCoUs, Use_FecNac, Use_SexUsu,	
				Use_PaNaUs, Use_LocDom, Use_CaDoUs, Use_PrEnCa, Use_SeEnCa, 
				Use_RFC,	Use_CURP,	Use_NuDoUs, Use_CoDoUs, Use_EntDom, 
				Use_LocDom, Use_CpDoUs, Use_LaTeUs, Use_TelUsu, Use_CorUsu, 
				Use_ActUsu, Use_OcuUsu, Use_TiIdUs, Use_NumIde, Use_FeExId, 
				Use_FeVeId, Use_CaDoEx, Use_NuDoEx, Use_CoDoEx, Use_LoDoEx, 
				Use_EnDoEx, Use_PaDoEx, Use_CpDoEx,	Use_TelExt,	Une_Estatu
		from #UsuarioCompVentDola noholdlock 
		
	end
	drop table #UsuarioCompVentDola 
end