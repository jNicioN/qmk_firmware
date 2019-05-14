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
** Creó:	Armando Alexis Sepúlveda Cruz								****
** Fecha:	11/Abril/2019												****
** Help:	1214398														****
****************************************************************************/

declare	@Tip_ConTip	char(1),					/* Declaracion de variables */
		@Tip_ConCon	char(1),
		@Rev_Regist	int,						/* Revision de registros */
		@Peu_Grupo	char(8),					/* Grupo de personas */
		@Col_Id		int
		
declare	@Str_Vacio	char(1),					/* Declaracion de Constantes */
		@Cue_Activa	char(1),
		@Per_Fisica	char(1),
		@Per_FisAct	char(1),
		@Ent_Uno	int,
		@Tip_Client	char(1),
		@Tip_Person	char(1)

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
		@Tip_Person	= 'P'								/* Tipo Persona */
		
		
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

if @Tip_ConTip = 'L' begin
	if @Tip_ConCon = '1' begin					/* Consulta por llave principal */
		/*Busqueda Persona Unica*/
		insert into #PersonaBus
		select @Gpc_Person
	
		/*Búsqueda de RFC + Homoclave*/
		if len(@Gpc_RFC) > 13 begin
			insert into #PersonaBus
			select Per_Numero
			  from SOPERSON noholdlock
			 where Per_RFC = @Gpc_RFC
		end
		
		/*Búsqueda de Nombre + RFC*/
		insert into #PersonaBus
		select Per_Numero
		  from SOPERSON noholdlock
		 where Per_Comple = @Gpc_Comple
		   and Per_RFC like substring(@Gpc_RFC, 1, 10) + '%'
		
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
		select Peu_Grupo, Peu_Person
		  from SOUNIPER noholdlock
		 where Peu_Grupo in (
			 select distinct Gpc_Grupo
			   from #GrupoBus
		 )
		 		
		/*Salida de información relacionada a la busqueda y grupos*/
		select Gpc_Grupo  as Gpc_Grupo, Gpc_Person as Gpc_Person, Per_Nombre as Gpc_Nombre, Per_ApePat as Gpc_ApePat, Per_ApeMat as Gpc_ApeMat, 
		       Adi_FecNac as Gpc_FecNac, Adi_Sexo  as Gpc_Sexo,   Ent_Abrevi as Gpc_EntNac, Per_RFC    as Gpc_RFC,	  Per_CURP   as Gpc_CURP
		  from #GrupoPer
		 inner join SOPERSON noholdlock on Per_Numero = Gpc_Person
		 inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		 inner join CLENTIDA noholdlock on Ent_Numero = Per_Entida
		 order by Gpc_Grupo, Gpc_Person
	end
end

drop table #PersonaBus, #GrupoBus, #GrupoPer