create procedure SOUNIPERCON (
	@Peu_Grupo	char(8),
	@Peu_Person	char(8),
	@Peu_RFC	char(15),
	@Peu_NomCom	varchar(180),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Descripcion											****
************************************************************
**	Consulta de Unificacion de Personas 				****
************************************************************
** Referencias											****
************************************************************
** Modifico:	Claudia V Sandoval P					****
** Fecha:		09-Ene-2015								****
** Help:		0694843									****
** Descripcion:	Agrega L5 busqueda de personas de su grupo**
************************************************************
**		STORE CONVERTIDO								****
**		Convirio: David Ruiz							****
**		Fecha:	08/10/2013								****
************************************************************
**	Creo:	David Ruiz									****
**	Help:	00599444									****
**	Fecha:	07-Oct-2013									****
***********************************************************/

create table #personas 
(Per_Grupo	char(8),
 Per_Person	char(8),
 Per_Comple	varchar(180),
 Per_RFC	varchar(15), 
 Per_FecNac	date,
 Per_FecCon	date)
 
declare @Tip_ConTip	char(1),	/* Declaracion de Variables */
		@Tip_ConCon	char(1),
		@Num_Regist	int,
		@sPeuRFC	varchar(15),
		@sPeuNom	varchar(150)
 
declare	@Str_Vacio	char(1),	/* Declaracion de Constantes */
		@Fec_Vacia	smalldatetime
		

select	@Str_Vacio	= '',			/* String Vacio */	
		@Fec_Vacia	= '1900-01-01'	/* Fecha Vacia */
		
select	@sPeuRFC = ltrim(rtrim(@Peu_RFC)) + '%',
		@sPeuNom = ltrim(rtrim(@Peu_NomCom)) + '%'			

select 	@Tip_ConTip = substring(@Tip_Consul,1,1),
		@Tip_ConCon = substring(@Tip_Consul,2,1)

if @Tip_ConTip = 'C' begin  	/* 'C' = Consulta */
	if @Tip_ConCon = '1' begin 					/* Consulta por Persona */	

		insert into	#personas
		select	Per_Princi = @Str_Vacio,
				Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
		from SOUNIPER noholdlock 
			inner join SOPERSON noholdlock on Per_Numero = Peu_Person
			inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
			where  Peu_Grupo = @Peu_Person
			
		select @Num_Regist = count(1) 
			from #personas
		
		if 	@Num_Regist = 0 begin
			insert into	#personas	
			select	Per_Princi = @Str_Vacio,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from SOPERSON noholdlock 
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				where  Per_Numero = @Peu_Person
		end	
				

	end

end else begin
	if @Tip_ConCon = '1' begin 					/* Consulta por Grupo */

		insert into	#personas	
			select	Per_Princi = @Str_Vacio,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from SOUNIPER noholdlock 
				inner join SOPERSON noholdlock on Per_Numero = Peu_Person
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				where  Peu_Grupo = @Peu_Grupo

	end
	
	if @Tip_ConCon = '2' begin 					/* Consulta por RFC */
	
		select Per_Numero, Per_Comple, Per_RFC
			into #tmpPerso01
			from	SOPERSON noholdlock
				where  Per_RFC like @sPeuRFC
	
		insert into	#personas	
			select	Per_Princi = @Str_Vacio,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from #tmpPerso01 noholdlock 
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
		
		drop table #tmpPerso01

	end
	
	if @Tip_ConCon = '3' begin 					/* Consulta por Nombre */
	
			select Per_Numero, Per_Comple, Per_RFC
			into #tmpPerso02
				from	SOPERSON noholdlock
					where  Per_Comple like @sPeuNom

		insert into	#personas	
			select	Per_Princi = @Str_Vacio,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from #tmpPerso02 noholdlock 
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				
		drop table #tmpPerso02		

	end

	if @Tip_ConCon = '4' begin 					/* Consulta por RFC + Nombre */
	
			select Per_Numero, Per_Comple, Per_RFC
				into #tmpPerso03
				from	SOPERSON noholdlock
					where  Per_RFC like @sPeuRFC
					  and  Per_Comple like @sPeuNom

		insert into	#personas	
			select	Per_Princi = @Str_Vacio,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from #tmpPerso03 noholdlock 
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				  
		drop table #tmpPerso03
		
	end

	if @Tip_ConCon = '5' begin 					/* Consulta por numero de persona @Peu_Person */
		select	@Peu_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = @Peu_Person
		
		
		insert into	#personas	
			select	@Peu_Grupo,
					Per_Numero, Per_Comple, Per_RFC, Adi_FecNac, Adi_FecCon
				from SOUNIPER noholdlock 
				inner join SOPERSON noholdlock on Per_Numero = Peu_Person
				inner join SOPERADI noholdlock on Adi_PerNum = Per_Numero
				where Peu_Grupo = @Peu_Grupo
	end
end

update #personas set
	Per_Grupo = Peu_Grupo
	from	SOUNIPER noholdlock
		where	Peu_Person = Per_Person

select	Per_Person,	Per_Comple, Per_RFC, Per_FecNac, Per_FecCon,
		Per_Grupo
	from	#personas
	order by Per_Comple, Per_RFC, Per_Person

drop table #personas
