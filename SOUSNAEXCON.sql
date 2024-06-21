create procedure SOUSNAEXCON (
	@Une_TabCon		varchar(1),

	@Une_Identi		int,								
	@Une_IdeUsu     int,		                       
	@Une_TabOri		varchar(1),						
	@Une_Migrad		varchar(1),
	@Une_Estatu		varchar(1),

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
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**
*********************************************************************************
** Descripcion : Consulta de relacion de Usuarios Naciones y Extranjeros CVD ****
*********************************************************************************
** Referencias: 															  	*
*********************************************************************************
** ** Modifico:	Brandon Garcia												 ****
** Fecha:		20/06/2024													 ****
** Jira:	    TCELES-29955								 				 ****
** Descripción:	Se crea consulta LF											 ****
*********************************************************************************
* ** Modifico:	Francisco Minajas											 ****
** Fecha:		20/06/2023													 ****
** Jira:	    TRAAC-1542									 				 ****
** Descripción:	Se genera consulta para localizar usuarios activos y		 ****
				cancelados													 ****
*********************************************************************************
* ** Modifico:	Francisco Minajas											 ****
** Fecha:		04/05/2023													 ****
** Jira:	    TRAAC-1450									 				 ****
** Descripción:	Se agrega consulta 3 para encontrar la relacion de usuarios  ****
*********************************************************************************
* ** Modifico:	Francisco Minajas											 ****
** Fecha:		23/01/2023													 ****
** Jira:	    TRAAC-1162									 				 ****
** Descripción:	Se agrega consulta de fecha de creacion de la bitacora		 ****
* 				SOBITUSU													 ****
*********************************************************************************
** Modifico:	Ezequiel Gonzalez Cobix											*
** Descripcion : Busqueda por nombre de usuarios de divisa				 	 	*
** Fecha:	17/10/2022															*
** Key Jira:	TRAAC-851 														*
*********************************************************************************
** Modifico:	Martin Adonis Lopez Mendoza													*
** Descripcion : Busqueda  de usuarios de divisas nacionales y extrangeros 											*
** Fecha:	01/09/2022															*
** Help:	1643006     														*
*********************************************************************************
** Modifico:	Carlos Copto													*
** Descripcion : Se agrego el retorno del campo Une_Estatu en la consulta 		*
**				 cuando Une_TabCon es 1											*
** Fecha:	18/11/2020															*
** Help:	1376175     														*
*********************************************************************************
** Creo:	Carlos Copto														*
** Fecha:	13/07/2020															*
** Help:	1376175     														*
*********************************************************************************
**/

								/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Status		int,
		@Ent_Identi	int,
		@Ucv_IdTaOr int,
		@Ucv_TabOri char(1),
		@Ucv_Estatu char(1),
		@Ucv_UlUsMo	char(6),
		@Ucv_NomUsu	varchar(70),
		@Biu_descri varchar(150),
		@Biu_sucursal varchar(15)
		
				
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
								/* Declaracion de constantes */
declare	@Str_LetraI char(1),
		@Str_LetraD char(1),
		@Str_LetraT char(1),
		@Str_LetraM char(1),
		@Str_LetraE char(1),
		@Str_LetraF	char(1),
		@Str_TipC 	char(1),
		@Str_TipL 	char(1),
		@Str_Vacio 	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Str_Uno 	char(1),
		@Tab_UsuNac	char(1),
		@Tab_UsuExt	char(1),
		@Str_Dos	char(1),
		@Str_Porcen	char(1),
		@Fec_Vacia	smalldatetime,
		@Fec_Cre	smalldatetime,
		@Str_Status char(1)

								/* Asignacion de valores a constantes */
select	@Str_LetraI = 'I',		/* String I: ID de relacion */
		@Str_LetraD = 'D',		/* String D: ID de Usuario */
		@Str_LetraT = 'T',		/* String T: Tabla Origen */
		@Str_LetraE = 'E',		/* String E: Estatus	*/
		@Str_LetraM = 'M',		/* String M: Usuario Migrado */
		@Str_LetraF = 'F',		/* String F: Nombre Usuario */
		@Str_TipC 	= 'C',		/* Tipo Consulta */
		@Str_Status = 'A',		/* Estatus activo */
		@Str_TipL 	= 'L',		/* Tipo Lista */
		@Str_Vacio  = '',		/* String vacio */
		@Ent_Cero	= 0,		/* Entero cero */
		@Ent_Uno	= 1,			/* Entero uno */
		@Str_Uno	= '1',		/* String: Uno */
		@Tab_UsuNac	= '1',		/* Tabla Origen: SOPERSON usuario nacional */
		@Tab_UsuExt	= '2',		/* Tabla Origen: SOUSUEXT usuario extranjero */
		@Str_Dos	= '2',		/* String: dos */
		@Str_Porcen	= '%',		/* porcentanje*/
		@Fec_Vacia	= '1900-01-01',	/*Fecha Vacia*/		
		@Fec_Cre	= '1900-01-01'	/*Fecha Vacia*/		
		

		
if @Une_TabCon = '' begin   /* Si consulta SOUSUEXT  */
	
	if @Tip_ConTip = @Str_TipC begin	/*	CONSULTAS */ 
		
		/* Consulta Usuarios por Identificador */
		if @Tip_ConCon = @Str_Uno begin
			
			select	@Ucv_IdTaOr =  Une_IdeUsu,
					@Ucv_TabOri =  Une_TabOri,
					@Ucv_Estatu = Une_Estatu
			from 	SOUSNAEX noholdlock 
			where 	Une_Identi	= @Une_Identi
			
			if @Str_Vacio = isnull(@Ucv_TabOri, @Str_Vacio) begin
				select	Err_Codigo	= '000001',
						Err_Mensaj	= 'Usuario no existe'
				rollback
				return @Ent_Uno
			end
			
			if @Ucv_TabOri = @Tab_UsuNac begin
				
				select  @Une_Identi as Une_Identi,
						@Ucv_Estatu as Une_Estatu,
						Per_Comple	as Use_NoCoUs,
						Per_Nombre as Une_nombre,
						Per_ApePat as Une_ApellPat,
						Per_ApeMat as Une_ApellMat,
						Adi_FecNac	as Use_FecNac,
						CASE Adi_TipIde	
							WHEN 'O' THEN Adi_OtrIde
							ELSE  Tid_Descri 
						END as Use_TiIdUs,
						Per_Fecha 	as Use_FecCre,
						Per_Nacion as Use_Nacion
				into #UsuarioCompraVentaNacional
				from SOPERSON noholdlock
				inner join SOPERADI noholdlock on Per_Numero = Adi_PerNum
				inner join CLTIPIDE noholdlock on Adi_TipIde = Tid_Variab 
				where	PerPersoID	= @Ucv_IdTaOr
				
				select 	top 1 @Ucv_UlUsMo = Biu_Usuari,
				@Biu_descri = Biu_DesEst,
				@Biu_sucursal = Biu_Sucurs,
				@Fec_Cre =  Biu_FecEst
				from	SOBITUSU noholdlock
				where	Biu_FolUsu	= @Une_Identi
				order by  Biu_Consec desc
				
				select 	@Ucv_NomUsu = ltrim(rtrim(Usu_Clave)) + ' - ' + ltrim(rtrim(Usu_Nombre))
				from 	SOUSUARI noholdlock
				where 	Usu_Numero	= @Ucv_UlUsMo
				
				select	Une_Identi, Une_Estatu, Use_NoCoUs, Use_FecNac, Use_TiIdUs,
						@Fec_Cre as Use_FecCre,Une_nombre,Une_ApellPat,Une_ApellMat,
						@Ucv_NomUsu as Biu_Usuari,
						@Biu_descri as Biu_descri,
						Pai_Gentil as Biu_Pais,
						@Biu_sucursal as Origen
				from	#UsuarioCompraVentaNacional inner join SOPAIS noholdlock on Pai_Numero = Use_Nacion
				where	Une_Identi	= @Une_Identi
				
				drop table #UsuarioCompraVentaNacional				
				
			end else if @Ucv_TabOri = @Tab_UsuExt begin
				
				select  @Une_Identi as Une_Identi,
						@Ucv_Estatu as Une_Estatu,
						Use_NomUsu as Une_nombre,
						Use_ApPaUs as Une_ApellPat,
						Use_ApMaUs as Une_ApellMat,
						Use_NoCoUs,	Use_FecNac,	 Tid_Descri as Use_TiIdUs,	Use_FecCre,SOUSUEXT.Use_NumSuc as Origen
						,Use_PaNaUs
				into #UsuarioCompraVentaExtranjero
				from SOUSUEXT noholdlock
				inner join CLTIPIDE noholdlock on Use_TiIdUs = Tid_Variab 
				where	Use_IdUsEx	= @Ucv_IdTaOr
				
				select 	top 1 @Ucv_UlUsMo = Biu_Usuari,
				@Biu_descri = Biu_DesEst,
				@Fec_Cre =  Biu_FecEst
				from	SOBITUSU noholdlock
				where	Biu_FolUsu	= @Une_Identi
				order by  Biu_Consec desc
				
				select 	@Ucv_NomUsu = ltrim(rtrim(Usu_Clave)) + ' - ' + ltrim(rtrim(Usu_Nombre))
				from 	SOUSUARI noholdlock
				where 	Usu_Numero	= @Ucv_UlUsMo
				
				select	Une_Identi, Une_Estatu, Use_NoCoUs, Use_FecNac, Use_TiIdUs,
						@Fec_Cre as Use_FecCre,Origen,Une_nombre,Une_ApellPat,Une_ApellMat,
						@Ucv_NomUsu as Biu_Usuari,
						@Biu_descri as Biu_descri,
						Pai_Gentil as Biu_Pais
				from	#UsuarioCompraVentaExtranjero inner join SOPAIS noholdlock on Pai_Numero = Use_PaNaUs
				where	Une_Identi	= @Une_Identi
				
				drop table #UsuarioCompraVentaExtranjero			
				
			end			
			
		end	else if @Tip_ConCon = @Str_Dos begin
			/* consulta por nombre de usuario de divisa */
			
			Create Table #BusquedaUsuDivisa(
			Numero						int identity not 	null,
			Une_Identi					int					null,
			Use_NoCoUs					char(180)			null,
			Biu_Pais					char(30)			null,
			Use_FecNac					smalldatetime		null,
			Une_TabOri					char(1)				null,
			Per_Numero					char(8)				null,
			Use_PaNaUs					char(3)				null	
			)			
			
			insert into #BusquedaUsuDivisa(Une_Identi, Use_NoCoUs, Biu_Pais, Use_FecNac, Une_TabOri, Per_Numero, Use_PaNaUs)
			Select Une_Identi, Per_Comple, @Str_Vacio, @Fec_Vacia, Une_TabOri,
					Per_Numero, Per_Nacion
			from SOUSNAEX noholdlock
			inner join SOPERSON noholdlock on (PerPersoID = Une_IdeUsu)
			where  Une_TabOri = @Tab_UsuNac 
				and Per_Comple	like	@Use_NoCoUs+@Str_Porcen
			
			insert into #BusquedaUsuDivisa(Une_Identi, Use_NoCoUs, Biu_Pais, Use_FecNac, Une_TabOri, Per_Numero, Use_PaNaUs)
			Select Une_Identi,  Use_NoCoUs, @Str_Vacio, Use_FecNac, Une_TabOri,
					@Str_Vacio, Use_PaNaUs
			from SOUSNAEX noholdlock
			inner join SOUSUEXT noholdlock on (Use_IdUsEx = Une_IdeUsu)
			where	Une_TabOri = @Tab_UsuExt 
				and  Use_NoCoUs	like	@Use_NoCoUs+@Str_Porcen	
				
			Update 	#BusquedaUsuDivisa
				set #BusquedaUsuDivisa.Use_FecNac =  Adi_FecNac 
				from #BusquedaUsuDivisa
				inner join SOPERADI noholdlock on #BusquedaUsuDivisa.Per_Numero = Adi_PerNum
				where #BusquedaUsuDivisa.Une_TabOri = @Tab_UsuNac 
					and #BusquedaUsuDivisa.Per_Numero <> @Str_Vacio
				
			Update 	#BusquedaUsuDivisa
				set #BusquedaUsuDivisa.Biu_Pais =  Pai_Gentil 
				from #BusquedaUsuDivisa
				inner join SOPAIS noholdlock on Pai_Numero =  #BusquedaUsuDivisa.Use_PaNaUs
			
				
			Select Une_Identi,  Use_NoCoUs, Biu_Pais,  Use_FecNac  
			from #BusquedaUsuDivisa	
			
			drop table #BusquedaUsuDivisa	
		end
	
	end

end else if @Une_TabCon = '0' begin   /* Consultas propias a SOUSNAEX */

	if @Tip_ConTip = @Str_TipC begin	/*	CONSULTAS */ 
	
		select @Ent_Identi = @Une_IdeUsu  /* Une_IdeUsu trae el folio de la tabla de relacion  */
		
		/* se obtiene el id de la tabla de extranjeros */
		select @Une_IdeUsu = Une_IdeUsu
		from SOUSNAEX noholdlock 
		inner join SOUSUEXT noholdlock on Une_IdeUsu = Use_IdUsEx 
		where Une_Identi = @Ent_Identi

		if @Tip_ConCon = @Str_LetraI begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Identi = @Une_Identi		
		end else if @Tip_ConCon = @Str_LetraD begin
			select	Une_Identi,	Une_IdeUsu = right('00000000' + ltrim(rtrim(convert(char, Une_IdeUsu))), 8),
					Une_TabOri, Une_Migrad, Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_IdeUsu = @Une_IdeUsu		
		end 
		
	end else if @Tip_ConTip = @Str_TipL begin  /* LISTAS */
	
		if @Tip_ConCon = @Str_LetraT begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_TabOri = @Une_TabOri	
		 end else if @Tip_ConCon = @Str_LetraM begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Migrad = @Une_Migrad	
		 end else if @Tip_ConCon = @Str_LetraE begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Estatu = @Une_Estatu	
		 end else if @Tip_ConCon = @Str_LetraF begin
		 	create table #UsuariosCompraVenta (
				Usu_Id int,
				Usu_Nombre varchar(150)
			)
			
			insert into #UsuariosCompraVenta
			select	Une_Identi,	Per_ComOrd
			  from	SOPERSON noholdlock
			 inner join	SOUSNAEX noholdlock on Une_IdeUsu = PerPersoID
			 where	Une_Estatu = @Str_Status
			   and	Per_ComOrd like @Use_NoCoUs + @Str_Porcen
			   and	Une_TabOri = @Tab_UsuNac
			
			insert into #UsuariosCompraVenta
			select	Une_Identi,	Use_NoCoUs
			  from	SOUSUEXT noholdlock
			 inner join	SOUSNAEX noholdlock on Une_IdeUsu = Use_IdUsEx
			 where	Une_Estatu = @Str_Status
			   and	Use_NoCoUs like @Use_NoCoUs + @Str_Porcen
			   and	Une_TabOri = @Tab_UsuExt
			
			select	Usu_Id, Usu_Nombre 
			  from	#UsuariosCompraVenta order by Usu_Nombre asc
			  
			drop table #UsuariosCompraVenta
		 end
	end
	
	if @Tip_Consul = @Str_Vacio begin
		select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
				Une_Estatu, Une_FecReg, Une_FecEst
		from 	SOUSNAEX noholdlock
	end

end else if @Une_TabCon = '1' begin   /* Si la consulta es de compra venta nacional  */
	
	select Une_IdeUsu, Une_Estatu
	from SOUSNAEX noholdlock
	where Une_Identi = @Une_Identi and Une_TabOri = @Une_TabCon

end else if @Une_TabCon = '2' begin   /* Si consulta SOUSUEXT  */

	exec SOUSUEXTCON
		@Use_IdUsEx, @Use_NoCoUs, @Use_NomUsu, @Use_ApPaUs, @Use_ApMaUs,
		@Use_FecNac, @Use_TiIdUs, @Use_NumIde, @Tip_Consul, @NumTransac,	
		@Transaccio, @Usuario,	  @FechaSis,   @SucOrigen,	@SucDestino,	
		@Modulo	

end else if @Une_TabCon = '3' begin   /* Localiza usuario por numero de persona  */
	
	select Une_Identi, Une_IdeUsu, Une_Estatu,  Une_FecReg,  Une_FecEst
	from SOUSNAEX noholdlock
	where  Une_IdeUsu  = @Une_IdeUsu and Une_TabOri = @Une_TabOri
	
end else if @Une_TabCon = '4' begin   /* Localiza usuarios activos  */
	
	select	Une_Identi, Une_IdeUsu, Une_Estatu,  Une_FecReg,  Une_FecEst
	from SOUSNAEX noholdlock
	inner join SOBITUSU noholdlock on  Biu_FolUsu  = Une_Identi 
	where	Une_IdeUsu	= @Une_IdeUsu and Une_TabOri = @Une_TabOri and   Biu_Estatu  = @Str_Status 
	order by  Biu_FecEst DESC
	
end else if @Une_TabCon = '5' begin   /* Localiza usuarios cancelados en bitacora  */
	
	select	Biu_FolUsu as Une_Identi,  Biu_Estatu  as Une_Estatu, Biu_FecEst as  Une_FecEst
	from SOUSNAEX noholdlock
	inner join SOBITUSU noholdlock on  Biu_FolUsu  = Une_Identi 
	where	Une_IdeUsu	= @Une_IdeUsu and Une_TabOri = @Une_TabOri and   Biu_Estatu  = @Str_TipC
	order by  Biu_FecEst DESC

end