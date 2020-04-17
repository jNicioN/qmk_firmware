create procedure SOPERSUCCON (
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
	 
as 

/***************************************************************************/
/* DESCRIPCION: Consulta de relacion de perfiles con sucursales 	  	   */
/***************************************************************************/ 
/* REFERENCIAS:					                           				   */
/****************************************************************************
** Creo:		Angel Gonzalez Hernandez								*****
** Fecha:		20/Marzo/2020											 ****
** Descripcion:	2018-056 Gobierno de Identidades		        		 ****
** Help Desk:	20200309420002						 					 ****
****************************************************************************/

declare @Tip_ConTip	char(1), 			
		@Tip_ConCon char(1),
		@Row_ConCli char(1),			
		@Row_ConPer	int				

declare	@Int_Uno        	int,
		@Int_Dos        int,
		@Tip_ConLis	char(1)	

declare	@Str_Consul char(1),
		@Ent_Dos 	smallint,
		@Ent_Uno 	smallint,
		@Tra_TipCon	char(1)

select	@Str_Consul	 = 'C',				
		@Ent_Uno = 1,					
		@Ent_Dos = 2		

select	@Row_ConPer		=   1,		
		@Row_ConCli	=  '1',		
		@Tip_ConLis	=  'L'		

select	@Tip_ConTip	= substring(@Tip_Consul,@Ent_Uno,@Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul,@Ent_Dos,@Ent_Uno)


if @Tip_ConTip = @Tip_ConLis begin  	/* Consultas*/
	if @Tip_ConCon = '1'	begin 		/* Consulta  todos los usuarios con su perfil y su sucursal asignada */
		
		set @Row_ConPer	= @Int_Uno

		create table #PerUsu(
			Usu_Identi	int identity,
			Usu_Id	    char(10),
			Usu_Perfil	char(10)
		)
		
		create table #SucUsu(
			Usu_Identi		int identity,
			Usu_Id	    	char(10),
			Usu_Sucursal	char(10)
		)
		
		create table #Perfiles(
			Usu_Identi		int identity,
			Usu_Id	    	char(10),
			Usu_Perfiles	varchar(256)
		)
		
		create table #Sucursales(
			Usu_Identi		int identity,
			Usu_Id	    	char(10),
			Usu_Sucursales	varchar(256),
		)   
		
		insert into #PerUsu	(
					    Usu_Id, Usu_Perfil)	 
			select  Upe_Usuari, Upe_Perfil
				from SAUSUPER noholdlock
				order by Upe_Usuari
				
		insert into #SucUsu	(
					    Usu_Id, Usu_Sucursal)	 
			select  Usl_Usuari, Usl_Sucurs
				from SOUSUSUC noholdlock
				order by Usl_Usuari
				
	DECLARE @Per_Id     		INT,
			@Per_max	INT,
			@Per_Numusu 	char(10),
			@Per_All  	VARCHAR(255),
			@Per_Usuant 	char(10)
			
	
	SELECT  @Per_Id = @Ent_Uno,
			@Per_max = MAX(Usu_Identi)
	FROM    #PerUsu
	
	WHILE (@Ent_Uno = @Ent_Uno)
	BEGIN
	
		SELECT  @Per_Numusu = Usu_Id
		FROM    #PerUsu
		WHERE   Usu_Identi = @Per_Id
	
		IF @Per_Numusu IS NULL
		BEGIN
			SELECT  @Per_Id = @Per_Id + @Ent_Uno
	
			IF @Per_Id > @Per_max
				BREAK
			ELSE
				CONTINUE
		END
	
		UPDATE  #PerUsu
		SET     @Per_All = @Per_All + ',' + CONVERT(VARCHAR, Usu_Perfil) 
		WHERE   Usu_Id = @Per_Numusu
	
		select  @Per_All = RIGHT(@Per_All, LEN(@Per_All)-@Ent_Uno)
				
		IF NOT  @Per_Numusu = @Per_Usuant

		BEGIN
			insert into #Perfiles (Usu_Id, Usu_Perfiles) values(@Per_Numusu, @Per_All)
			SET @Per_Usuant = @Per_Numusu 
		END
			
		SELECT  @Per_Numusu   = NULL,
				@Per_All = NULL
	
		SELECT  @Per_Id = @Per_Id + @Ent_Uno
	
		IF @Per_Id > @Per_max
			BREAK
	
		IF @Per_Id > 100000
			BREAK
	END
			
	DECLARE @Suc_Idsuc			INT,
			@Suc_Maxsuc 		INT,
			@Suc_Idusu  		char(10),
			@Suc_All 	 	VARCHAR(255),
			@Suc_Ultusu 		char(10)
	
	SELECT  @Suc_Idsuc = @Ent_Uno,
			@Suc_Maxsuc = MAX(Usu_Identi)
	FROM    #SucUsu
			
	WHILE (@Ent_Uno = @Ent_Uno)
	BEGIN
	
		SELECT  @Suc_Idusu = Usu_Id
		FROM    #SucUsu
		WHERE   Usu_Identi = @Suc_Idsuc		    
			
		IF @Suc_Idusu IS NULL
		
		BEGIN
						
			SELECT  @Suc_Idsuc = @Suc_Idsuc + @Ent_Uno
					
			IF @Suc_Idsuc > @Suc_Maxsuc
				BREAK
			ELSE
				CONTINUE
		END
		
		UPDATE  #SucUsu
		SET     @Suc_All  = @Suc_All + ',' + CONVERT(VARCHAR, Usu_Sucursal) 
		WHERE   Usu_Id = @Suc_Idusu
	
		select  @Suc_All = RIGHT(@Suc_All, LEN(@Suc_All)-@Ent_Uno)
			
		IF NOT  @Suc_Idusu = @Suc_Ultusu
	
			BEGIN
				insert into #Sucursales (Usu_Id, Usu_Sucursales) values (@Suc_Idusu, @Suc_All)
				SET @Suc_Ultusu = @Suc_Idusu 
			END
	
		SELECT  @Suc_Idusu   = NULL,
				@Suc_All = NULL
	
		SELECT  @Suc_Idsuc = @Suc_Idsuc + @Ent_Uno
			
		IF @Suc_Idsuc > @Suc_Maxsuc
			BREAK
	
		IF @Suc_Idsuc > 100000
			BREAK
	END
	
		SELECT #Perfiles.Usu_Id, #Perfiles.Usu_Perfiles, #Sucursales.Usu_Sucursales 
			FROM #Perfiles LEFT JOIN #Sucursales ON #Sucursales.Usu_Id =  #Perfiles.Usu_Id 
			WHERE #Sucursales.Usu_Sucursales  > ''
			
		DROP TABLE #PerUsu, #SucUsu, #Perfiles, #Sucursales	
	end
end