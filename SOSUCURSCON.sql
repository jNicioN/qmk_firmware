create procedure SOSUCURSCON(
	@Suc_Numero	char(3),
	@Suc_Nombre	varchar(50),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/***************************************************************************
 DESCRIPCION: ** Consulta alfabetica y numerica de sucursales **
****************************************************************************
 REFERENCIAS:
****************************************************************************
**                           Store CONVERTIDO 							****
****************************************************************************
** Modifico:	Melissa Sepulveda										****
** Fecha:		08/Feb/2018												****
** Descripcion:	L8- Lista Sucursales Categoria Sucursales				****
** Help Desk:	1039567	 												****
****************************************************************************
** Modifico:	Carlos Candelaria Mora									****
** Fecha:		16/Enero/2018											****
** Descripcion:	CZ- Consulta sucursa y zona que pertenece				****
** Help Desk:	1007133 												****
****************************************************************************
** Modifico:	Brandon Garcia	 										****
** Fecha:		16/Febrero/2017											****
** Descripcion:	Se agrega campo Suc_Catego a consulta C1				****
** Help Desk:	927640													****
****************************************************************************
** Modifico:	Felipe Castillo 										****
** Fecha:		15/Septiembre/2016										****
** Descripcion:	Obtener sucursal y nombre plaza en la misma consulta	****
** Help Desk:	903360													****
****************************************************************************
** Modifico:	Karla Dosal					 							****
** Fecha:		16/06/2016												****
** Descripcion:	Se agrega Consulta 'CF' para fabrica					****
** Help Desk:	884258													****
****************************************************************************
** Modifico:	Felipe Ramirez Lopez		 							****
** Fecha:		15/Febrero/2016											****
** Descripcion:	Se agrega Consulta 'C6', 'C7' para obtener los perfiles	****
**				de promotores de una sucursal determianda				****
** Help Desk:	819063													****
****************************************************************************
** Modifico:	David Alejandro Cantu Trevino  							****
** Fecha:		24/Agosto/2015											****
** Descripcion:	Se agrega nuevo campo para identificar la sucursal como ****
**				cerrada													****
** Help Desk:	749260													****
****************************************************************************
** Modifico:	Ignacio Ordaz Valtierra									****
** Fecha:		03/Abril/2013											****
** Descripcion:	Se elimina el filtro de consulta a Estado de cuenta		****
** Help Desk:	533483													****
****************************************************************************
** Modifico:	Tania De la Garza										****
** Fecha:		12 Octubre 2012											****
** Descripcion:	Se agrego Consulta C5 para cierre de creditos en java	****
** Help Desk:	00444014												****
**				FASE I de Rediseno										**** 
****************************************************************************
** Modifico:		Ivan Zarrabal Cobos									****
** Fecha:		2/Ago/2010												****
** Requi:		301497											 		****
** Descripcion:	Se agrego la consulta L6								****
****************************************************************************
** Modifico:		Armando Garcia										****
** Fecha:		12/Feb/2010												****
** Requi:		000246228								 				****
** Descripcion:	se agrego Suc_ApeSab ala consulta fox  y L5 lista 		****
**				de apertura 											****
****************************************************************************
** Modifico:		Noel Pena Flores									****
** Fecha:		30/Dic/2008												****
** Requi:		00093480								 				****
** Descripcion:	Agregar L4 lista por plaza								****
****************************************************************************
** Modifico:		Lucina Gonzalez Trejo								****
** Fecha:		13/Mayo/2008											****
** Requi:		90217									 				****
** Descripcion:	Agregar Campo AnioMes a L2								****
****************************************************************************
**                           Store CONVERTIDO 							****
** Convirtio:       Karina Chavarria Tovar	 							****
** Fecha:           18/Junio/2007										****
****************************************************************************
** Modifico:		Gerardo Valladares Muniz							****
** Fecha:		06/Junio/2007											****
** Help:			00003651										 	****
** Descripcion:	Agregar L3												****
****************************************************************************
**                           Store CONVERTIDO 							****
** Convirtio:       Karina Chavarria Tovar	 							****
** Fecha:           12/Abril/2007										****
****************************************************************************
** Modifico:		Ricardo Elizondo Guerrero							****
** Fecha:		02/Abril/2007											****
** Help:			00024338										 	****
** Descripcion:	Incluir Consulta Para Cierre de ArrendaRegio			****
****************************************************************************
** Modifico:		Francis Flores Contreras							****
** Fecha:		14/Sep/2006												****
** Descripcion:	Se agrego parametros Suc_FecApe	y       				****
**                      Suc_DifHor										****
** HD:			 # 3611													****
****************************************************************************
** Modifico:		Francis Flores Contreras							****
** Fecha:		06/Sept/2006											****
** HD:																	****
** Descripcion:	Se agrego el campo Suc_FecApe							****
****************************************************************************
** Modifico:		Lucina Gonzalez Trejo								****
** Fecha:		27/Julio/2006											****
** HD:			140833													****
** Descripcion:	Se agrego el campo Suc_Path a la Lista 2				****
****************************************************************************
**                           Store CONVERTIDO 							****
** Convirtio: 		Arnoldo Garza	 									****
** Fecha:     05/Octubre/2005											****
****************************************************************************
** Modifico:		Gabriela Alonso Jalomo								****
** Fecha:		20/Sep/2005												****
** Descripcion:	Se agrego el campo Suc_Zona y Suc_IVA					****
** HD:			97418													****
****************************************************************************
**                           Store CONVERTIDO 							****
** Convirtio: Perla Judith Abundis Orozco 								****
** Fecha:     15/Agosto/2005											****
****************************************************************************
** Modificar:		Lucina Gonzalez Trejo								****
** Fecha:		13/Julio/2005											****
** Descr :		Agregar luista 2										****
** HelpDesk:	83813-78												****
****************************************************************************
**                           Store CONVERTIDO 							****
** Convirtio: Perla Judith Abundis Orozco 								****
** Fecha:     15/Febrero/2005											****
****************************************************************************
** Modificar:		Ma de Lourdes Valdes Ramirez						****
** Fecha:		15/Febrero/2005											****
** Descr :		Adecuaciones para creditos castigados					****
** HelpDesk:	00075346												****
****************************************************************************
**                           Store CONVERTIDO 							****
****************************************************************************
** Modificar:		Claudia Lazarin Soto								****
** Fecha:		07/Feb/03												****
** Descr :		Se agregaron Suc_StaCie y Suc_CiCrCe					****
****************************************************************************
** Modificar:		Jorge Lozano										****
** Fecha:		07/Dic/01												****
** Se agrego los campos Suc_Gerent,Suc_MaiGer,Suc_SubGer,				****
** Suc_MaiSub															****
****************************************************************************
** Modifico:		Sandra Almaguer										****
** Fecha:		26/Julio/2001											****
** Descripcion:	Agrego los Campos que hacen la Direccion				****
****************************************************************************
** Modifico:		Mayra Estrada										****
** Fecha:		21/Julio/1999											****
** Descripcion:	@Tip_Consul p/ Cons. Tipificadas de Visual.				****
***************************************************************************/

declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1),
		@Suc_Cerrad char(1)
		
declare	@Str_Vacio	char(1),		/* Declaracion de Constantes */
		@Sta_Proces	char(1),
		@Sta_ProCas	char(1),
		@Str_Si		char(1),
		@Sta_CiCrCe	char(1),
		@Sta_CiCrSu	char(1),
		@Str_Porcen char(1),
		@Con_LlaPri	char(1),
		@Con_LlaFor	char(1),
		@Con_CieCen	char(1),
		@Con_CieAut	char(1),
		@Con_CiCrJa char(1),
		@Con_DirSuc	char(1),
		@Con_SucPer char(1),
		@Lis_Genera	char(1),
		@Lis_PlaNom	char(1),
		@Lis_CatSuc	char(1),
		@Lis_ECU	char(1),
		@Lis_CieMas	char(1),
		@Lis_Plaza	char(1),
		@Lis_Apertu	char(1),
		@Lis_Zona	char(1),
		@Con_Consul char(1),
		@Cie_Sucurs char(1),
		@Str_Status char(1),		
		@Str_Perfil char(3),
		@Str_Modulo char(2),
		@Con_SucFab	char(1),
		@Con_SucZon	char(1),
		@Cat_Sucurs	char(1)
		
/* Asignacion de Constantes */
select	@Str_Vacio	= '',			/*	String Vacio 		*/
		@Sta_Proces	= 'N',			/*	Status: En Proceso	*/
		@Sta_ProCas = 'M',			/*	Status: En Proceso Castigado */
		@Str_Si		= 'S',			/*	String:	Si			*/
		@Sta_CiCrCe	= 'C',			/*	Status:	Cierre de Creditos Centralizado ya realizado	*/
		@Sta_CiCrSu	= 'S',			/*	Status:	Cierre de Creditos en Sucursal					*/
		@Str_Porcen = '%',			/*	String Porcentaje 							*/
		@Con_LlaPri = '1',			/*	Consulta: LLave Primaria					*/
		@Con_LlaFor = '2',			/*	Consulta: LLave Foranea						*/
		@Con_CieCen = '3',			/*	Consulta: Cierre Centralizado de Creditos	*/
		@Con_CieAut = '4',			/*	Consulta: Cierre de Autoregio				*/
		@Con_CiCrJa	= '5',			/*	Consulta: Cierre de Creditos en Java		*/
		@Con_SucPer	= '6',			/*	Consulta: De Perfiles por Sucursal			*/				
		@Con_DirSuc	= '7',			/*	Consulta: Direccion sucursal				*/
		@Lis_Genera = '1',			/*	Lista: General								*/
		@Lis_ECU 	= '2',			/*	Lista: Edo de Cuenta Unico					*/
		@Lis_CieMas = '3',			/*	Lista: Cierre Masivo de Creditos			*/
		@Lis_Plaza  = '4',			/*	Lista: por Plaza							*/
		@Lis_Apertu = '5',			/*	Lista: Apertura								*/
		@Lis_Zona	= '6',			/*	Lista: por Zona								*/
		@Lis_PlaNom	= '7',			/*	Lista: de la plaza							*/
		@Lis_CatSuc = '8',			/*	Lista: Categoria Sucursal					*/
		@Con_Consul	= 'C',			/*	Consulta									*/
		@Cie_Sucurs = 'S',
		@Str_Status = 'A',			/*	Estatus de Perfil a consultar				*/	
		@Str_Perfil = '030',		/*	Perfil de Promotor a Consultar				*/
		@Str_Modulo = 'FB',			/*  Modulo de Fabrica							*/
		@Con_SucFab	= 'F',			/*	Consulta: Sucursal, plaza y parametros		*/
		@Con_SucZon	= 'Z',			/*	Consulta: Sucursal, zona y ciudad			*/
		@Cat_Sucurs = 'S'			/*	Consulta: Categoria Sucursal				*/

			
if isnull(@Tip_Consul, @Str_Vacio) = @Str_Vacio begin	/* Cliente:  FoxPro */
	if isnull(@Suc_Nombre, @Str_Vacio) = @Str_Vacio and isnull(@Suc_Numero, @Str_Vacio) = @Str_Vacio
		select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Suc_Calle,	Suc_CalNum,
				Suc_Coloni,	Suc_CodPos,	Suc_ApaPos,	Suc_Telefo,	Suc_Ciudad,
				Suc_Estado,	Suc_Pais,	Suc_UltDia,	Suc_Apertu,	Suc_Plaza,
				Suc_Gerent,	Suc_MaiGer,	Suc_SubGer,	Suc_MaiSub,	Suc_CiCrCe,
				Suc_Zona, 	Suc_IVA,	Suc_FecApe, Suc_DifHor, Suc_ApeSab
			from SOSUCURS noholdlock
			order by Suc_Nombre
	else if isnull(@Suc_Nombre, @Str_Vacio) = @Str_Vacio
		select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Suc_Calle,	Suc_CalNum,
				Suc_Coloni,	Suc_CodPos,	Suc_ApaPos,	Suc_Telefo,	Suc_Ciudad,
				Suc_Estado,	Suc_Pais,	Suc_UltDia,	Suc_Apertu,	Suc_Plaza,
				Suc_Gerent,	Suc_MaiGer,	Suc_SubGer,	Suc_MaiSub,	Suc_CiCrCe,
				Suc_Zona, 	Suc_IVA,	Suc_FecApe,	Suc_DifHor, Suc_ApeSab
			from SOSUCURS noholdlock
			where	Suc_Numero	= @Suc_Numero
	else begin
		select	@Suc_Nombre	= ltrim(rtrim(@Suc_Nombre)) + @Str_Porcen
		select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Suc_Calle,	Suc_CalNum,
				Suc_Coloni,	Suc_CodPos,	Suc_ApaPos,	Suc_Telefo,	Suc_Ciudad,
				Suc_Estado,	Suc_Pais,	Suc_UltDia,	Suc_Apertu,	Suc_Plaza,
				Suc_Gerent,	Suc_MaiGer,	Suc_SubGer,	Suc_MaiSub,	Suc_CiCrCe,
				Suc_Zona, 	Suc_IVA,	Suc_FecApe,	Suc_DifHor, Suc_ApeSab
			from SOSUCURS noholdlock
			where	upper(Suc_Nombre)	like upper(@Suc_Nombre)
			order by Suc_Nombre
	end
			
end else begin													/* Cliente:  Visual Basic */

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = @Con_Consul begin							/* 'C':  Consulta */
		if @Tip_ConCon = @Con_LlaPri begin						/* Consulta de Llave Principal */
			
			select @Suc_Cerrad = Suc_Cerrad  
				from SOSUCURS noholdlock
				where Suc_Numero = @Suc_Numero
			
			if @Suc_Cerrad = @Str_Vacio begin
				select @Suc_Cerrad = 'N'
			end 
			
			select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Suc_Calle,	Suc_CalNum,
					Suc_Coloni,	Suc_CodPos,	Suc_ApaPos,	Suc_Telefo,	Suc_Ciudad,
					Suc_Estado,	Suc_Pais,	Suc_UltDia,	Suc_Apertu,	Suc_Plaza,
					Suc_Gerent,	Suc_MaiGer,	Suc_SubGer,	Suc_MaiSub, Suc_CiCrCe,
					Suc_Zona,	Suc_IVA,	Suc_FecApe,	Suc_DifHor, Suc_ApeSab,
					@Suc_Cerrad as Suc_Cerrad,	Suc_Catego
				from SOSUCURS noholdlock
				where	Suc_Numero	= @Suc_Numero
		end else if @Tip_ConCon = @Con_LlaFor begin				/* Consulta de Llave Foranea */
			select	Suc_Numero,	Suc_Nombre, Suc_Zona
				from SOSUCURS noholdlock
				where	Suc_Numero	= @Suc_Numero
		end else if @Tip_ConCon = @Con_CieCen begin				/* Consulta para Cierre Centralizado Creditos */

			select	Suc_Numero,
					Suc_Nombre	= max(Suc_Nombre),
					Suc_StaCre	= max(Suc_StaCre),
					Suc_CiCrCe	= max(Suc_CiCrCe),
					Suc_NumCre	= count(Cre_Numero)
				from SOSUCURS noholdlock,
					CRCREDIT noholdlock
				where	Suc_Numero	= substring(Cre_Numero, 1, 3)
				  and	Suc_CiCrCe	= @Cie_Sucurs
				  and	Cre_Status	in (@Sta_Proces, @Sta_ProCas)
			group by Suc_Numero
			order by count(Cre_Numero)

		end else if @Tip_ConCon = @Con_CieAut begin				/*	Consulta Cierre De ArrendaRegio	*/

			select	Suc_Numero,
					Suc_Nombre	= max(Suc_Nombre),
					Suc_StCiAr	= max(Suc_StCiAr),
					Suc_NumCre	= count(Cre_Numero)
				from SOSUCURS noholdlock,
					 ABCREDIT noholdlock
				where	Suc_Numero	= substring(Cre_Numero, 1, 3)
				  and	Cre_Status	= @Sta_Proces
  				group by Suc_Numero
				order by count(Cre_Numero)
		end else if @Tip_ConCon = @Con_CiCrJa begin				/* Consulta para Cierre de Creditos en Java */
		
			create table #sucursales (
				Suc_Numero  char(3),
				Suc_Nombre  varchar(50),
				Suc_StaCre  char(1),
				Suc_CiCrCe  char(1),
				Suc_NumCre	int
				)

			insert into #sucursales
			select	Suc_Numero,
					Suc_Nombre	= max(Suc_Nombre),
					Suc_StaCre	= max(Suc_StaCre),
					Suc_CiCrCe	= max(Suc_CiCrCe),
					Suc_NumCre	= count(Cre_Numero)
				from SOSUCURS noholdlock,
					CRCREDIT noholdlock
				where	Suc_Numero	= substring(Cre_Numero, 1, 3)
			group by Suc_Numero
			order by count(Cre_Numero)			
			
			insert into #sucursales
			select	Suc.Suc_Numero,
					Suc.Suc_Nombre,	
					Suc.Suc_StaCre,	
					Suc.Suc_CiCrCe,	
					Suc_NumCre	= 0
			from SOSUCURS Suc noholdlock
				where	Suc.Suc_Numero	not in (Select Suc_Numero 
													from #sucursales noholdlock ) 
			
			select Suc_Numero,	Suc_Nombre,	Suc_StaCre,	Suc_CiCrCe,	Suc_NumCre
				from #sucursales order by Suc_NumCre
			
			drop table #sucursales
		end else if @Tip_ConCon	= @Con_SucPer begin				/* Consulta de Perfiles por Sucursal */
			select 	perfil.Per_Numero,	usu.Usu_Clave,	perfil.Per_Descri,	perfil.Per_Status,	perfil.Per_Modulo 
				from SOUSUARI usu noholdlock
				inner join BEUSUPER per_usu noholdlock on	usu.Usu_Numero	= per_usu.Usu_Numero
				inner join BEPERFIL perfil noholdlock on	per_usu.Usu_Perfil	= perfil.Per_Numero
				where	Usu_Sucurs	= @Suc_Numero
					AND perfil.Per_Status	= @Str_Status
					AND perfil.Per_Numero	= @Str_Perfil
					AND perfil.Per_Modulo	= @Str_Modulo

		end else if @Tip_ConCon = @Con_DirSuc begin	 /*Consulta de direccion completa de la sucursal*/
			select	Suc_Numero,	Suc_Nombre,	Suc_Direcc,	Suc_Calle,	Suc_CalNum,
					Suc_Coloni,	Suc_CodPos,	Suc_ApaPos,	Suc_Telefo,	Suc_Ciudad,
					Suc_Estado,	Est_Nombre,	Suc_Pais,	Suc_UltDia,	Suc_Apertu,	
					Suc_Plaza,	Suc_Gerent,	Suc_MaiGer,	Suc_SubGer,	Suc_MaiSub, 
					Suc_CiCrCe,	Suc_Zona,	Suc_IVA,	Suc_FecApe,	Suc_DifHor, 
					Suc_ApeSab
				from SOSUCURS noholdlock
				inner join SOESTADO noholdlock on	Est_Numero = Suc_Estado
				where	Suc_Numero	= @Suc_Numero
		end else if @Tip_ConCon = @Con_SucFab begin		/*	Consulta de sucursal, plaza y parametros	*/
			select	Suc_Numero,	Suc_Nombre,	Suc_Plaza,	Pla_Nombre,	Pla_Abrevi,
					Pla_Clabe,	Pla_ClaMin,	Par_FecAct,	Par_IVA
				from SOSUCURS noholdlock
					inner join SOPLAZAS noholdlock on Suc_Plaza = Pla_Numero
					inner join SOPARAMS noholdlock on Suc_Numero = Par_Sucurs
				where	Suc_Numero	= @Suc_Numero
		
		end else if @Tip_ConCon = @Con_SucZon begin		/*	Consulta de sucursal, zona y ciudad	*/
			select	Suc_Numero,	Suc_Nombre,	Suc_Plaza,	Pla_Numero,	Pla_Nombre,	
					Pla_Abrevi,	Pla_ClaMin,	Pla_Region,	SoCiudadID
				from SOSUCURS noholdlock
					inner join SOPLAZAS noholdlock on Suc_Plaza = Pla_Numero
				where	Suc_Numero	= @Suc_Numero
		end
		
	end else begin												/* 'L':  Lista */
		select	@Suc_Nombre	= ltrim(rtrim(@Suc_Nombre)) + @Str_Porcen
		
		if @Tip_ConCon = @Lis_Genera							/* Lista General L1*/
			select	Suc_Numero,	Suc_Nombre, Suc_StaCre
				from SOSUCURS noholdlock
				where	upper(Suc_Nombre)	like upper(@Suc_Nombre)
				order by Suc_Nombre
		else if @Tip_ConCon = @Lis_ECU 							/* Lista Ordenada por Numero Exclusiva para ESTADO DE CUENTA UNICO L2 */
				select	Suc_Numero,	Suc_Nombre,
						Suc_Path	= space(28),
						Suc_AniMes	= space(6)
					from SOSUCURS noholdlock
					order by Suc_Numero
		else if @Tip_ConCon = @Lis_CieMas 						/* Lista para Cierre Diario Masivo de Creditos 	GVM L3 */
				select	Suc_Numero, Suc_Nombre,
						Cerrar	= space(2)
					from SOSUCURS noholdlock
					where Suc_CiCrCe = @Str_Si
			  	  	  and	Suc_StaCre	not in (@Sta_CiCrCe, @Sta_CiCrSu)
		else if @Tip_ConCon = @Lis_Plaza begin					/* Lista de Sucursales por Plaza L4 */
				/*	En esta lista se utilizo @Suc_Numero como parametro para Suc_Plaza para no agregar mas parametros ya que afecta en 
					varias plataformas	*/

				select	Suc_Numero, Suc_Nombre,	Suc_Plaza
					from SOSUCURS noholdlock
					where Suc_Plaza = @Suc_Numero
					  and upper(Suc_Nombre)	like upper(@Suc_Nombre)
					order by Suc_Numero
		end else if @Tip_ConCon = @Lis_Apertu begin					/* Lista de apertura L5 */
	
			select	Suc_Numero, Suc_Nombre,Suc_StaCre,Suc_Apertu, Suc_ApeSab
				from SOSUCURS noholdlock
				
		end else if @Tip_ConCon = @Lis_Zona begin				/* Folio 301497 IZC Consulta de Sucursales por Zona L6*/
			select Suc_Numero, Suc_Nombre, Pla_Numero, Pla_Nombre, Zon_Numero
			  from SOSUCURS noholdlock,
				   SOZONAS noholdlock,
				   SOPLAZAS noholdlock
			 where Suc_Zona		= Zon_Numero
			   and Suc_Plaza	= Pla_Numero
			   and Zon_Numero	= @Suc_Numero
			   order by Pla_Numero asc
			   
		end else if @Tip_ConCon = @Lis_PlaNom begin						/* Lista General L7 */
			select	Suc_Numero,	Suc_Nombre, Pla_Numero, Pla_Nombre
				from SOSUCURS noholdlock
				inner join SOPLAZAS noholdlock on (Pla_Numero = Suc_Plaza)
				where	Suc_Nombre	like @Suc_Nombre
				order by Suc_Nombre
		end else if @Tip_ConCon = @Lis_CatSuc begin						/* Lista Sucursales Categoria Sucursales L8 */
			select	Suc_Numero,	Suc_Nombre
				from SOSUCURS noholdlock				
				where	Suc_Catego	= @Cat_Sucurs
				order by Suc_Nombre						
		end
	end
end
