create procedure SOUNGRPECON (
	@Gpc_Person char(8),
	@Gpc_Comple char(180),
	@Gpc_RFC	varchar(15),
	@Gpc_CURP	char(18),
	@Tip_Consul	char(2),

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
** DESCRIPCION: ** Consulta Unificacion Grupo de Persona				****
****************************************************************************
** REFERENCIAS: 														****
****************************************************************************
** Modifico:	Javier Eduardo Ceron Rangel								****
** Fecha:		9/Febrero/2026											****
** Help: TRACL-15670													****
** Descripcion:	OPTIMIZACIÓN: Reducción de I/O en búsqueda por RFC		****
**				- Cambio LIKE por SARG (>=, <) para usar índice			****
****************************************************************************
** Modifico:	Armando Alexis Sepulveda Cruz							****
** Fecha:		24/Marzo/2020											****
** Help:		1370878													****
** Descripcion:	Se valida si el campo retornado esta nulo entonces 		****
**				regresa por defecto el valor de vacio					****
****************************************************************************
** Modifico: Armando Alexis Sepúlveda Cruz								****
** Fecha:	 29/Mayo/2019												****
** Help:	 1258812													****
** Descripción: Se visualiza todas las personas relacionadas por		****
**				SOUNIPER y CLCLIUNI.									****
****************************************************************************
** Creó:	Armando Alexis Sepúlveda Cruz								****
** Fecha:	11/Abril/2019												****
** Help:	1214398														****
****************************************************************************/

declare	@Tip_ConTip	char(1),					/* Declaracion de variables */
		@Tip_ConCon	char(1),
		@Rev_Regist	int,						/* Revision de registros */
		@Peu_Grupo	char(8),					/* Grupo de personas */
		@Col_Id		int,
		@Str_PerRFC	varchar(15)					/*String persona rfc*/
		
declare	@Str_Vacio	char(1),					/* Declaracion de Constantes */
		@Cue_Activa	char(1),
		@Per_Fisica	char(1),
		@Per_FisAct	char(1),
		@Ent_Uno	int,
		@Tip_Client	char(1),
		@Tip_Person	char(1),
		@Str_Porcen	char(1),
		@Len_RFCOrd	int,
		@Len_RFCHom int

select @Gpc_Person	= isnull(@Gpc_Person, @Str_Vacio)
select @Gpc_CURP	= isnull(@Gpc_CURP, @Str_Vacio)
select @Gpc_RFC		= isnull(@Gpc_RFC, @Str_Vacio)
select @Gpc_Comple	= isnull(@Gpc_Comple, @Str_Vacio)

/* Asignacion de Constantes */
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1),
		@Str_Vacio = '',
		@Cue_Activa	= 'A',								/* Cuenta Activa */
		@Per_Fisica = '2',								/* Persona Física */
		@Per_FisAct = '3',								/* Persona Fisica con Actividad Empresarial */
		@Ent_Uno	= 1,								/* Enero Uno */
		@Tip_Client	= 'C',								/* Tipo Cliente */
		@Tip_Person	= 'P',								/* Tipo Persona */
		@Str_Porcen	= '%',								/* String porcentaje % */
		@Len_RFCOrd	= 10,								/* Longitud de rfc ordinario*/
		@Len_RFCHom = 13								/* Longitud de rfc con homoclave*/
		
select @Str_PerRFC = ltrim(rtrim(@Gpc_RFC))
		
create table #PersonaBus (
	Gpc_Person char(8)
) create index PersonaBus on #PersonaBus(Gpc_Person)

create table #GrupoBus (
	Gpc_Grupo char(8)
) create index GrupoBus on #GrupoBus(Gpc_Grupo)

create table #GrupoPer (
	Gpc_Grupo char(8),
	Gpc_Person char(8)
) create index GrupoPer on #GrupoPer(Gpc_Grupo)

create table #ClienteUni (
	Gcu_Grupo char(8)
) create index ClienteUni on #ClienteUni(Gcu_Grupo)

create table #Grupo (
	Gpc_CliUni	char(8),  
	Gpc_Client	char(8),
	Gpc_Grupo	char(8),
	Gpc_Person	char(8),
) create index Grupo on #Grupo(Gpc_Grupo)
	
create table #InfoPer (
	Gpc_Id		int identity,
	Gpc_CliUni	char(8),
	Gpc_Client  char(8),
	Gpc_Grupo	char(8),
	Gpc_Person	char(8),
	Gpc_Nombre	char(40),
	Gpc_ApePat	char(40),
	Gpc_ApeMat	char(40),
	Gpc_FecNac	smalldatetime,
	Gpc_Sexo	char(1),
	Gpc_EntNac	char(2),
	Gpc_RFC		char(15),
	Gpc_CURP	char(18)
) create index InfoPer on #InfoPer(Gpc_Id)

if @Tip_ConTip = 'L' begin
	if @Tip_ConCon = '1' begin					/* Consulta por llave principal */
		if isnull(@Gpc_Person, @Str_Vacio) <> @Str_Vacio begin		/*Busqueda Persona Unica*/
			insert into #PersonaBus
			select @Gpc_Person
		end
		
		/*Búsqueda de RFC*/
		if isnull(@Str_PerRFC, @Str_Vacio) <> @Str_Vacio and len(@Str_PerRFC) = @Len_RFCHom begin
			insert into #PersonaBus
			select Per_Numero
			  from SOPERSON noholdlock
			 where Per_RFC = @Str_PerRFC
		end else if isnull(@Str_PerRFC, @Str_Vacio) <> @Str_Vacio and len(@Str_PerRFC) >= @Len_RFCOrd begin
			declare @Str_RFCMax varchar(30)
			
			/* Calcular límite superior para rango SARG */
			/* CHAR(255) es el carácter mayor en ASCII - garantiza incluir todo */
			select @Str_RFCMax = @Str_PerRFC + CHAR(255) 
			
			insert into #PersonaBus
			select Per_Numero
			  from SOPERSON noholdlock
			 where Per_RFC >= @Str_PerRFC 
			   and Per_RFC < @Str_RFCMax
		end
		
		/*Búsqueda de Nombre + CURP*/
		insert into #PersonaBus
		select Per_Numero
		  from SOPERSON noholdlock
		 where Per_Comple = @Gpc_Comple
		   and Per_CURP like @Gpc_CURP		   
		   
		/*Búsqueda de Grupos*/
		insert into #GrupoBus
		select Peu_Grupo
		  from SOUNIPER noholdlock
		 where Peu_Person in (
			select distinct Gpc_Person
			  from #PersonaBus
		)
				
		/*Búsqueda de Personas relacionadas a los grupos*/
		insert into #GrupoPer
		select distinct Peu_Grupo, Peu_Person
		  from SOUNIPER noholdlock
		 where Peu_Grupo <> @Str_Vacio
		   and Peu_Grupo in (
			 select distinct Gpc_Grupo
			   from #GrupoBus
		 )
		 		 		
		/*Búsqueda de todas las personas relacionadas*/ 
		insert into #GrupoPer
		select distinct @Str_Vacio, Gpc_Person
		  from #PersonaBus
		 where Gpc_Person not in (
			select Gpc_Person
			  from #GrupoPer
		)
						  
		/*Búsqueda de clientes únicos*/
		insert into #ClienteUni
		select distinct Clu_Grupo
	      from #GrupoPer
	     inner join CLADICIO noholdlock on Gpc_Person = Adi_NumPer
	     inner join CLCLIUNI noholdlock on Clu_Client = Adi_Client
		 
		/*Inserción de personas relacionadas al grupo de clientes*/
		insert into #GrupoPer
		select distinct @Str_Vacio, Adi_NumPer
		  from #ClienteUni
		 inner join CLCLIUNI noholdlock on Gcu_Grupo = Clu_Grupo
		 inner join CLADICIO noholdlock on Adi_Client = Clu_Client
		 where Adi_NumPer not in (
			select Gpc_Person
			  from #GrupoPer
		)
		
		/*Actualizacion de grupo de persona*/
		update #GrupoPer set 
			Gpc_Grupo = Peu_Grupo
		  from SOUNIPER noholdlock
	     where Peu_Person = Gpc_Person
	    	     	    
		insert into #GrupoPer
		select distinct Peu_Grupo, Peu_Person
		  from #GrupoPer
		 inner join SOUNIPER noholdlock on Gpc_Grupo = Peu_Grupo
		 where Peu_Grupo <> @Str_Vacio
		   and Peu_Person not in (
			select Gpc_Person
			  from #GrupoPer
		 )
		 		 					   
		insert into #Grupo
		select isnull(Clu_Grupo, @Str_Vacio),
			   isnull(Clu_Client, @Str_Vacio),
			   Gpc_Grupo,
			   Gpc_Person
		  from #GrupoPer
		  left join CLADICIO noholdlock on Gpc_Person = Adi_NumPer
		  left join CLCLIUNI noholdlock on Clu_Client = Adi_Client
				  		  		  	
		/*Salida de información relacionada a la busqueda y grupos*/
		insert into #InfoPer
		select isnull(Gpc_CliUni, @Str_Vacio) as Gpc_CliUni,
			   isnull(Gpc_Client, @Str_Vacio) as Gpc_Client,
			   isnull(Gpc_Grupo, @Str_Vacio)  as Gpc_Grupo,
			   isnull(Gpc_Person, @Str_Vacio) as Gpc_Person,
			   isnull(Per_Nombre, @Str_Vacio) as Gpc_Nombre,
			   isnull(Per_ApePat, @Str_Vacio) as Gpc_ApePat,
			   isnull(Per_ApeMat, @Str_Vacio) as Gpc_ApeMat,
			   isnull(Adi_FecNac, @Str_Vacio) as Gpc_FecNac,
			   isnull(Adi_Sexo, @Str_Vacio)   as Gpc_Sexo,
			   isnull(Ent_Abrevi, @Str_Vacio) as Gpc_EntNac,
			   isnull(Per_RFC, @Str_Vacio)    as Gpc_RFC,
			   isnull(Per_CURP, @Str_Vacio)   as Gpc_CURP
		  from #Grupo
		 inner join SOPERSON noholdlock on Per_Numero = Gpc_Person
		 left join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		 left join CLENTIDA noholdlock on Ent_Numero = Per_Entida
		 		 		 
		select Gpc_CliUni,  Gpc_Client, Gpc_Grupo,	Gpc_Person,	Gpc_Nombre, 
			   Gpc_ApePat,	Gpc_ApeMat,	Gpc_FecNac,	Gpc_Sexo,	Gpc_EntNac,	
			   Gpc_RFC,		Gpc_CURP
		  from #InfoPer
		 order by Gpc_CliUni, Gpc_Client, Gpc_Grupo, Gpc_Person
	end
end

drop table #PersonaBus, #GrupoBus, #GrupoPer, #ClienteUni, #InfoPer, #Grupo
