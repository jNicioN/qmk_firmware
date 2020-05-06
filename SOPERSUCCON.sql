create procedure SOPERSUCCON (
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	 
as 

/***************************************************************************/
 /* DESCRIPCION: Consulta de relacion de perfiles con sucursales  		   */
/***************************************************************************/ 
/* REFERENCIAS:															   */
/****************************************************************************
** Creo:		Angel Gonzalez Hernandez								*****
** Fecha:		20/Marzo/2020											 ****
** Descripcion:	2018-056 Gobierno de Identidades						 ****
** Help Desk:	2020030942000273									     ****
*****************************************************************************/

declare @Tip_ConTip	char(1), 	/* Declaracion de Variables */		
		@Tip_ConCon char(1),
		@Row_ConCli char(1),			
		@Row_ConPer	int,
		@Contador 	int,
		@ContAct	int,
		@Usu_Actual	char(6),  
		@Per_Actual char(256),
		@Con_PerAct int,
		@Ent_PerTot int,
		@Ent_Zero 	int		

declare	@Int_Uno    int,	/* Declaracion de Constantes */
		@Int_Dos    int,
		@Ent_Dos 	smallint,
		@Ent_Uno 	smallint,
		@StrVacio	char(1)

select	@Ent_Uno  	 =  1,					
		@Ent_Dos 	 =  2,
		@StrVacio 	 =  '',
		@Ent_Zero 	 =  0,		
		@Row_ConPer	 =  1
		
				
	/* Consulta  todos los usuarios con su perfil y su sucursal asignada */
			
		set @Row_ConPer	= @Int_Uno

		create table #PerUsu(
			Usu_Identi	int identity,
			Usu_Numero	    char(6),
			Usu_Clave	 	char(20),
			Usu_Perfil	varchar(500),
			Suc_Id		varchar(500)
		)
		create unique nonclustered index #PerUsu on #PerUsu ( Usu_Numero ASC )
			
		insert into #PerUsu 
			 select Usu_Numero , Usu_Clave, '','' from SOUSUARI noholdlock
			 group by Usu_Numero 
			 
			 select @ContAct = @Ent_Uno
			 select @Contador = count (Usu_Perfil) from #PerUsu
			 while @Contador >= @ContAct begin
			
				create table #PerfilesActuales(
					Usu_Identi	int identity,
					Usu_Perfil	char(3)
				)
				create unique nonclustered index #PerfilesActuales on #PerfilesActuales ( Usu_Identi ASC )	

				create table #SucursalesActuales(
					Usu_Identi		int identity,
					Usu_Sucursales	char(3)
	
				)
				create unique nonclustered index #SucursalesActuales on #SucursalesActuales ( Usu_Identi ASC )
				 
				select @Usu_Actual  = Usu_Numero
				from #PerUsu where Usu_Identi = @ContAct
			 	 
				Insert into #PerfilesActuales
				select Upe_Perfil from SAUSUPER
				where  Upe_Usuari = @Usu_Actual  
			 
				select @Con_PerAct = @Ent_Uno
				select @Ent_PerTot = count (Usu_Perfil)
				from #PerfilesActuales

				select @Per_Actual = @StrVacio
				if @Ent_PerTot  > @Ent_Zero begin
				while  @Ent_PerTot >= @Con_PerAct begin
				
		
					select @Per_Actual = ltrim (rtrim (@Per_Actual)) + ',' + rtrim (ltrim (Usu_Perfil))
					from #PerfilesActuales
					where Usu_Identi = @Con_PerAct
					
					select  @Per_Actual = RIGHT(@Per_Actual, LEN(@Per_Actual)-1)
					where 	@Per_Actual LIKE ',%'
								
					select @Con_PerAct = @Con_PerAct + @Ent_Uno 
						
				end
			 	
			 	update #PerUsu set Usu_Perfil = @Per_Actual
			 	where Usu_Numero = @Usu_Actual
			 	
			 	end
			 	
			 	/*Sucursales*/
			 	Insert into #SucursalesActuales
				 select Usl_Sucurs  from SOUSUSUC
				 where  Usl_Usuari  = @Usu_Actual
			 
				select @Con_PerAct = @Ent_Uno
				select @Ent_PerTot = count (Usu_Sucursales)
				from #SucursalesActuales

				select @Per_Actual = @StrVacio
				if @Ent_PerTot  > @Ent_Zero begin
				while  @Ent_PerTot >= @Con_PerAct begin
					
					select @Per_Actual = ltrim (rtrim (@Per_Actual)) + ',' + rtrim (ltrim (Usu_Sucursales))

					from #SucursalesActuales
					where Usu_Identi = @Con_PerAct
				
				    select  @Per_Actual = RIGHT(@Per_Actual, LEN(@Per_Actual)-1)
					where 	@Per_Actual LIKE ',%'
					
					select @Con_PerAct = @Con_PerAct + @Ent_Uno 
						
				end
			 	
			 	update #PerUsu set Suc_Id = @Per_Actual
			 	where Usu_Numero = @Usu_Actual
			 	
			 	end
			 	
			 	select @ContAct = @ContAct + @Ent_Uno
			 	
			 	 drop table  #PerfilesActuales
				 drop table  #SucursalesActuales
			 end	
	
		SELECT Usu_Numero , Usu_Clave , Usu_Perfil , Suc_Id
			FROM #PerUsu WHERE Usu_Perfil > '' OR Suc_Id > ''
			
		DROP TABLE #PerUsu		
