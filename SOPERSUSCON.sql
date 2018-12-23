create procedure SOPERSUSCON (
	@Cla_Param char(2),
	
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
** Modificó:		Adraina Maldonado Rangel							****
** Fecha:		26/Febrero/2013										    ****
** Help:		      537947									        ****
**Descripción:  Se elimino el campo "For_Acceso" de todos			    ****
**                 los tipos de consulta que lo utilizaban.	            ****
****************************************************************************
***************************************************************************
** Modificó:		Adraina Maldonado Rangel							****
** Fecha:		17/Septiembre/2012										****
** Help:		      486313									        ****
**Descripción:  agregar las consultas de Fabricas Web y Auto	        ****
****************************************************************************
****************************************************************************
** Modificó:		Oscar Acevedo										****
** Fecha:		14/Febrero/2011											****
** Help:		      357516											****
***************************************************************************
** Modificó:		Gabriel Carbajal								    ****
** Fecha:		02/Agosto/2010								            ****
** Help:		      310850										    ****
** Descripción:	Se agrego consulta tipo H					            ****
****************************************************************************
** Creó:			Miguel Valles         							    ****
** Fecha:		07/Jun/10									            ****
** Help:		      297373                                            ****
****************************************************************************/
/*Declaracion de constantes*/

declare @pntperfil char(1)
declare @pntusuari char(1)
declare @pntusrper char(1)
declare @pntlisfor char(1)
declare @pntlisniv char(1)
declare @pntforniv char(1)
declare @pntforpro char(1)
declare @pntsousua char(1)
declare @Sta_Activo char(1)
declare @pntfwuxp char(1)
declare @pntfwpxp char(2)
declare @pntfwpxu char(2)
declare @pntfavis char(2)
declare @pntfaacc char(2)
declare @pntfaana char(2)
declare @pntfafac char(2)

/*Asignacion de constantes*/

select @pntperfil = '1'
select @pntusuari = '2'
select @pntusrper = '3'
select @pntlisfor = '4'
select @pntlisniv = '5'
select @pntforniv = '6'
select @pntforpro = '7'
select @pntsousua = '8'
select @pntfwuxp = '9'
select @pntfwpxp = '10'
select @pntfwpxu = '11'
select @pntfavis = '12'
select @pntfaacc = '13'
select @pntfaana = '14'
select @pntfafac = '15'
select @Sta_Activo = 'A'
	


if @Cla_Param = @pntperfil /* Se obtienen las Pantallas por Perfil */
	begin
			select  Titulo = 'Pantallas por Perfil',Ppa_PerfID,	
				Per_Descri,	Ppa_Pantal,	
				Pan_Descri,	Mod_Nombre,	
				Gru_Nombre,
				Pan_Titulo into #A
		from    SAPEPAAC noholdlock, SAPERFIL noholdlock, 
				SAPANTAL noholdlock, SYMODULO noholdlock, 
				SYGRUPOS noholdlock
		where   Ppa_PerfID	= SaPerfilID
				and Ppa_Pantal	= Pan_Nombre
				and Mod_Codigo	=* Pan_Modulo
				and Pan_Grupo	*= Gru_Numero
		order By Ppa_Pantal
		
		update #A set
		#A.Gru_Nombre = SAGRUPOS.Gru_Nombre
		from 	#A,
				SAPANTAL, 
				SAGRUPOS 
		where 	#A.Gru_Nombre is null
		  and 	#A.Ppa_Pantal = Pan_Nombre
		  and 	Pan_Grupo = SAGRUPOS.Gru_Numero
		
		/* Adaptive Server has expanded all '*' elements in the following statement */ Select #A.Titulo, #A.Ppa_PerfID, #A.Per_Descri, #A.Ppa_Pantal, #A.Pan_Descri, #A.Mod_Nombre, #A.Gru_Nombre, #A.Pan_Titulo from #A
		Drop table #A
	End

If @Cla_Param = @pntusuari  /* Se obtienen las Pantallas por Usuario */
	begin
		select 	Titulo = 'Pantallas por Usuario',Upa_UsuaID,
				Upa_Pantal,	Pan_Descri,	
				Usu_Clave,	Usu_Nombre,	
				Mod_Nombre,	Gru_Nombre,	
				Pan_Titulo 
				into #B
		from    SAUSPAAC noholdlock,SOUSUARI noholdlock,
				SAPANTAL noholdlock,SYMODULO noholdlock,
				SYGRUPOS noholdlock
		where   Upa_UsuaID = SoUsuariID
				and Upa_Pantal = Pan_Nombre
				and Mod_Codigo =* Pan_Modulo
				and Pan_Grupo *= Gru_Numero
		order by Upa_UsuaID, Upa_Pantal
		/* Adaptive Server has expanded all '*' elements in the following statement */ Select #B.Titulo, #B.Upa_UsuaID, #B.Upa_Pantal, #B.Pan_Descri, #B.Usu_Clave, #B.Usu_Nombre, #B.Mod_Nombre, #B.Gru_Nombre, #B.Pan_Titulo from #B
		Drop table #B
	End

If @Cla_Param = @pntusrper /* Se obtienen los  por Perfil */
	Begin
		Select Titulo = 'Usuarios por Perfil',	SA.Per_Numero,
			   SA.Per_Descri, SO.Usu_Numero,	
			   SO.Usu_Nombre, SO.SaPerfilID,
			   SO.Usu_Perfil, SO.Usu_Clave,
			   SO.Usu_PassWo, SO.Usu_FeAcPa,
			   SO.Usu_Autori, SO.Usu_Nivel,
			   SO.Usu_Status, SO.Usu_EMail,
			   SO.Usu_Sucurs, SO.Usu_ImEsCu,	
			   SO.Usu_CoEsCu, SO.Usu_PasEsp,
			   SO.Usu_ImNoCl, SO.Usu_CoInSu,
			   SO.Usu_Activo, SO.Usu_FeUlAc,
			   SO.Usu_FecDes
			   into #C
		from   SOUSUARI SO noholdlock, SAPERFIL SA noholdlock
		where   SO.SaPerfilID  = SA.SaPerfilID
				and SO.Usu_Status  =  @Sta_Activo 
		order by Per_Numero
		/* Adaptive Server has expanded all '*' elements in the following statement */ select #C.Titulo, #C.Per_Numero, #C.Per_Descri, #C.Usu_Numero, #C.Usu_Nombre, #C.SaPerfilID, #C.Usu_Perfil, #C.Usu_Clave, #C.Usu_PassWo, #C.Usu_FeAcPa, #C.Usu_Autori, #C.Usu_Nivel, #C.Usu_Status, #C.Usu_EMail, #C.Usu_Sucurs, #C.Usu_ImEsCu, #C.Usu_CoEsCu, #C.Usu_PasEsp, #C.Usu_ImNoCl, #C.Usu_CoInSu, #C.Usu_Activo, #C.Usu_FeUlAc, #C.Usu_FecDes from #C
		Drop table #C
	End

If @Cla_Param = @pntlisfor /* Se obtienen Listados por Formas */
	Begin
		Select Titulo = 'Listado de Formas', For_Numero,
			   For_Nombre, For_Descri,
			   For_Titulo,
			   For_Modulo, Pro_Nombre,
			   For_Params 
			   into #D
		from   SYFORMAS noholdlock, SYPROYEC noholdlock
		where For_Modulo = Pro_Codigo
		/* Adaptive Server has expanded all '*' elements in the following statement */ select #D.Titulo, #D.For_Numero, #D.For_Nombre, #D.For_Descri, #D.For_Titulo, #D.For_Modulo, #D.Pro_Nombre, #D.For_Params from #D
		Drop table #D
	End

If @Cla_Param = @pntlisniv /*Se obtiene los listados de nieveles*/
	Begin
		Select Titulo = 'Listado de Niveles',Niv_Numero,
			   Niv_Descri, Niv_Acceso
			   into #E
		from SONIVELE noholdlock 
		/* Adaptive Server has expanded all '*' elements in the following statement */ Select #E.Titulo, #E.Niv_Numero, #E.Niv_Descri, #E.Niv_Acceso from #E
		Drop table #E
	End

If @Cla_Param = @pntforniv /*Se obtienes formas por nievel*/
	Begin
		Select Titulo = 'Formas por Nivel', Fni_Nivel,
			   Niv_Descri, Fni_Forma,
			   For_Nombre, For_Descri, For_Titulo, Pro_Nombre
			   into #F
		from    SYFORNIV noholdlock,SYFORMAS noholdlock,
				SONIVELE noholdlock,SYPROYEC noholdlock
		where Fni_Forma = For_Numero
			  and   Fni_Nivel = Niv_Numero and
			  For_Modulo = Pro_Codigo
		order by Fni_Nivel
		/* Adaptive Server has expanded all '*' elements in the following statement */ Select #F.Titulo, #F.Fni_Nivel, #F.Niv_Descri, #F.Fni_Forma, #F.For_Nombre, #F.For_Descri, #F.For_Titulo, #F.Pro_Nombre from #F
		Drop table #F
	End

If @Cla_Param = @pntforpro /*Se obtienen formas por proyecto*/
	Begin
		Select Titulo = 'Formas por Proyecto',Fpr_Proyec,
			   Pro_Nombre, Fpr_Forma,
			   For_Nombre, For_Descri
			   into #G
		from   SYFORPRO noholdlock,SYFORMAS noholdlock,
			   SYPROYEC noholdlock
		where Fpr_Forma = For_Numero
		and Pro_Codigo = Fpr_Proyec
		order by Fpr_Proyec 
		/* Adaptive Server has expanded all '*' elements in the following statement */ Select #G.Titulo, #G.Fpr_Proyec, #G.Pro_Nombre, #G.Fpr_Forma, #G.For_Nombre, #G.For_Descri from #G
		Drop table #G
	End
	
If @Cla_Param = @pntsousua /*Se obtiene sousuari*/
begin
	select	SoUsuariID,	Usu_Numero,	Usu_Nombre,	SaPerfilID,	Usu_Perfil,
			Usu_Clave,	Usu_PassWo,	Usu_FeAcPa,	Usu_Autori,	Usu_Nivel,
			Usu_Status,	Usu_EMail,	Usu_Sucurs,	Usu_ImEsCu,	Usu_CoEsCu,
			Usu_PasEsp,	Usu_CoInSu,	Usu_Activo,	Usu_FeUlAc,	Usu_FecDes,
			Usu_StaSes,	Usu_IPSesi,	Usu_CanSes
		into #H
		from SOUSUARI noholdlock
		order by Usu_Nombre

	/* Adaptive Server has expanded all '*' elements in the following statement */ select #H.SoUsuariID, #H.Usu_Numero, #H.Usu_Nombre, #H.SaPerfilID, #H.Usu_Perfil, #H.Usu_Clave, #H.Usu_PassWo, #H.Usu_FeAcPa, #H.Usu_Autori, #H.Usu_Nivel, #H.Usu_Status, #H.Usu_EMail, #H.Usu_Sucurs, #H.Usu_ImEsCu, #H.Usu_CoEsCu, #H.Usu_PasEsp, #H.Usu_CoInSu, #H.Usu_Activo, #H.Usu_FeUlAc, #H.Usu_FecDes, #H.Usu_StaSes, #H.Usu_IPSesi, #H.Usu_CanSes
		from #H

	drop table #H
end




If @Cla_Param = @pntfwuxp  
begin
		

		select			A.Usu_Clave,
				A.Usu_Numero,
				A.Usu_Nombre,	
				A.Usu_Status,
				B.Usu_Perfil,	
				Per_Descri,	
				Per_Status,	
				Mod_Nombre,
				Usu_FeUlAc
from			SOUSUARI A,
				BEUSUPER B,
				BEPERFIL,
				SYMODULO  
where			A.Usu_Numero		=		B.Usu_Numero
and				B.Usu_Perfil		= 		Per_Numero 
and 			Per_Modulo 			=  		Mod_Codigo 
order by 		Per_Modulo
end


If @Cla_Param = @pntfwpxp  
begin
		Select 			Pan_Perfil, 
						Per_Descri,  
						Per_Status,  
						Pan_Pantal,   
						Pan_Descri  
		from 			BEPANPER noholdlock,  
						BEPERFIL noholdlock, 
						BEPANPLA noholdlock
		where  			Pan_Perfil  		= 		Per_Numero  
		and  			Pan_Pantal  		=   	Pan_Numero

end

If @Cla_Param = @pntfwpxu 
begin

		Select 			Usu_Clave,
						Usu_Numero,
						Usu_Numero,
						Usu_Status,
						Pan_Pantal,
						Pan_Descri,
						Pan_Nombre,
						Pan_Modulo,
						Mod_Nombre,
						Usu_FeUlAc
		from 			BEPANUSU noholdlock, 
						SOUSUARI noholdlock, 	
						BEPANPLA noholdlock, 
						SYMODULO noholdlock
		where  			Pan_Usuari 			= 		Usu_Numero
		and   			Pan_Pantal 			= 		Pan_Numero
		and   			Pan_Modulo 			= 		Mod_Codigo 


end 

If @Cla_Param = @pntfavis 
begin
	SELECT
			NoUsuario 	= A.Usu_Numero,
			Clave     	= A.Usu_Clave,
			Nombre    	= A.Usu_Nombre,	
			Estatus2 =  CASE WHEN A.Usu_Status = 'A' THEN 'Activo'
								 WHEN A.Usu_Status = 'C' THEN 'Cancelado'
						 ELSE 	 'Inactivo' END,
					Sucursal = ISNULL(Suc_Nombre, '')
	FROM SOUSUARI A noholdlock
	INNER JOIN GCALCUSU B noholdlock ON A.Usu_Numero  = B.Alc_Usuari
	INNER JOIN SOSUCURS C noholdlock ON C.Suc_Numero = Alc_Sucurs
	ORDER BY A.Usu_Numero
end 

If @Cla_Param = @pntfaacc 
begin

	SELECT DISTINCT Usuario
	INTO #USU_GCSOLICI
	FROM  GCSOLICI


	SELECT NoUsuario 	= A.Usu_Numero,
		  Clave     	= A.Usu_Clave,
		  Nombre    	= A.Usu_Nombre,	
		  Estatus   	= A.Usu_Status
	INTO #USUARIOS_AUTOS 
		  FROM SOUSUARI  A noholdlock,
		#USU_GCSOLICI B noholdlock
		WHERE A.Usu_Numero = B.Usuario
		AND A.Usu_Status = 'A'
		
			

	SELECT
					B.NoUsuario,
					B.Clave,
					B.Nombre,	
					Estatus2 =  CASE WHEN B.Estatus = 'A' THEN 'Activo'
								 WHEN B.Estatus = 'C' THEN 'Cancelado' 
								 ELSE 'Inactivo' END,
				   Accion = C.Tia_Nombre
	FROM #USUARIOS_AUTOS B noholdlock
	LEFT JOIN GCACCION A  noholdlock ON A.Acc_Usuari   = B.NoUsuario
	INNER JOIN GCTIPACC C  noholdlock ON Tia_Numero = Acc_Tipo
	ORDER BY NoUsuario

    drop table #USU_GCSOLICI
	drop table #USUARIOS_AUTOS

end 

If @Cla_Param = @pntfaana  
begin


	
	SELECT DISTINCT Usuario
	INTO #USU_GCSOLICI1
	FROM  GCSOLICI
	
	SELECT NoUsuario 	= A.Usu_Numero,
		  Clave     	= A.Usu_Clave,
		  Nombre    	= A.Usu_Nombre,	
		  Estatus   	= A.Usu_Status
	INTO #USUARIOS_AUTOS1 
		  FROM SOUSUARI  A noholdlock,
		#USU_GCSOLICI1 B noholdlock
		WHERE A.Usu_Numero = B.Usuario
		AND A.Usu_Status = 'A'
		
	SELECT
					B.NoUsuario,
					B.Clave,
					B.Nombre,	
					Estatus2 =  CASE WHEN B.Estatus = 'A' THEN 'Activo'
									 WHEN B.Estatus = 'C' THEN 'Cancelado' 
									 ELSE  'Inactivo' END,
				 Analista = Ana_AnaCre,	
			  Facultado 	= Ana_Facult
	INTO #ANALISTAS3
	FROM GCANACRE A noholdlock
	INNER JOIN #USUARIOS_AUTOS1 B noholdlock ON A.Ana_Usuari  = B.NoUsuario  

	/* Adaptive Server has expanded all '*' elements in the following statement */ select #ANALISTAS3.NoUsuario, #ANALISTAS3.Clave, #ANALISTAS3.Nombre, #ANALISTAS3.Estatus2, #ANALISTAS3.Analista, #ANALISTAS3.Facultado from #ANALISTAS3
	drop table #ANALISTAS3
	drop table #USUARIOS_AUTOS1
	drop table #USU_GCSOLICI1
end


If @Cla_Param = @pntfafac  
begin



SELECT 
	  NoUsuario 	= A.Usu_Numero,
	  Clave     	= A.Usu_Clave,
	  Nombre    	= A.Usu_Nombre,	
	  Estatus  		= CASE WHEN A.Usu_Status = 'A' THEN 'Activo'
	  				     WHEN A.Usu_Status = 'C' THEN 'Cancelado' ELSE 		
						 'Inactivo' END,
	  Facultad =      F.Fac_Nombre
	  FROM 	SOUSUARI A noholdlock,
			GCUSUFAC B noholdlock,
			GCFACULT F noholdlock
	WHERE A.Usu_Numero = B.Usf_Usuari
	AND   F.Fac_Numero = B.Usf_Facult 
	AND F.Fac_Estatu = 'A'
	ORDER BY F.Fac_Numero


end
