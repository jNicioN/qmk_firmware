create procedure SOPERCLICON(
	@PerPersoID		int output,
	@ClClientID		int output,
	@Per_Numero 	char(8),
	@Cli_Numero		char(8),
	@Tip_Consul		char(2),
	
	@NumTransac		char(10),
	@Transaccio		char(3),
	@Usuario		char(6),
	@FechaSis		smalldatetime,
	@SucOrigen		char(3),
	@SucDestino		char(3),
	@Modulo			char(2))
as

/***************************************************************************
** Descripción:	 Consulta Persona y Cliente								****
****************************************************************************
** Modificó:	Armando Alexis Sepúlveda Cruz							****
** Fecha:		03/Agosto/2020											****
** Help Desk:	1379522													****
** Descripción:	Se modifica la consulta C7 para buscar contemplar los   ****
**				grupos de clientes										****
****************************************************************************
** Modificó:	Armando Alexis Sepúlveda Cruz							****
** Fecha:		03/Agosto/2020											****
** Help Desk:	1379522													****
** Descripción:	Se modifica la consulta C7 para buscar las personas		****
** 				relacionadas al cliente registrado en RHEMPLEA			****
****************************************************************************
** Modificó:	Armando Alexis Sepúlveda Cruz							****
** Fecha:		11/Octubre/2019											****
** Help Desk:	1285508													****
** Descripción:	Se agrega consulta C7 que retorna las personas Empleado	****
**				relacionado al número de Persona						****
****************************************************************************
** Modificó:	Josue Leal Ramirez										****
** Fecha:		03/Diciembre/2018										****
** Help Desk:	1160018													****
** Descripción:	Se agrega consulta C6 que retorna las personas de grupo	****
**				IDE														****
****************************************************************************
** Modifico:	Felipe Castillo Rendon									****
** Fecha:		16-08-2017												****
** Help:		989254  												****
** Descripcion:	Se agrega C4 y C5 para hacer busqueda por IDs			****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		06-06-2017												****
** Help:		00982757												****
** Descripcion:	Se agrega C3 para regresar los ID's a otro SP			****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		31-03-2017												****
** Help:		00909908												****
****************************************************************************/
													/* Declaración de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Peu_Grupo  char(8),
		@Emp_Client	char(8)
		
declare @Str_Vacio  char(1),						/* Declaración de constantes */
        @Con_Consul char(1),
        @Con_Client char(1),
        @Con_Person char(1),
        @Con_CliPar char(1),
        @Con_CliIde char(1),
        @Con_PerIde char(1),
        @Con_CliPer char(1),
        @Con_CliEmp char(1)
										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
        @Con_Consul  = 'C',				/* Tipo Consulta */
        @Con_Client	= '1',				/* Consutla por numero de cliente */
        @Con_Person	= '2',				/* Consulta por numero de persona */
        @Con_CliPar	= '3',				/* Consulta por numero de cliente en parametros*/
        @Con_CliIde	= '4',				/* Consulta por numero de cliente id */
        @Con_PerIde	= '5',				/* Consulta por numero de persona id */
        @Con_CliPer	= '6',				/* Consulta por numero de cliente o persona */
        @Con_CliEmp	= '7'				/* Consulta por numero de persona para saber si es cliente */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
if @Tip_ConTip = @Con_Consul begin							/* 'C':  Consulta */
	if @Tip_ConCon = @Con_Client begin						/* Consulta by Cli_Numero  */	
	
		select  ClClientID,  PerPersoID  ,  Adi_Client as Cli_Numero, Adi_NumPer as Per_Numero
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	Adi_Client  = @Cli_Numero
	
	end else	if @Tip_ConCon = @Con_Person begin			/* Consulta by Per_Numero  */	
	
		select 	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero

		from 	SOPERSON	noholdlock
		left 	join CLADICIO noholdlock on Adi_NumPer = Per_Numero 
		where  	Per_Numero  = @Per_Numero
	
	end else	if @Tip_ConCon = @Con_CliPar begin						/* Consulta by Cli_Numero , return params  */	
	
		select  @ClClientID = ClClientID,  @PerPersoID = PerPersoID  
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	Adi_Client  = @Cli_Numero
		
	end else	if @Tip_ConCon = @Con_CliIde begin			/* Consulta by ClClientID  */	
	
		select  ClClientID,  PerPersoID  ,  Adi_Client as Cli_Numero, Adi_NumPer as Per_Numero
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	ClClientID  = @ClClientID
	
	end else	if @Tip_ConCon = @Con_PerIde begin						/* Consulta by PerPersoID*/	
	
		select 	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero
		from 	SOPERSON	noholdlock
		left 	join CLADICIO noholdlock on Adi_NumPer = Per_Numero 
		where  	PerPersoID  = @PerPersoID
	
	end else	if @Tip_ConCon = @Con_CliPer begin						/* Consulta unificada por Cli_Numero o Per_Numero*/	
	
		select	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero
			from CLCLIUNI Cli noholdlock
				inner join CLCLIUNI Gpo noholdlock on Cli.Clu_Grupo = Gpo.Clu_Grupo
				inner join CLADICIO noholdlock on Gpo.Clu_Client = Adi_Client 
				inner join SOPERSON noholdlock on Adi_NumPer = Per_Numero
			where @Cli_Numero != @Str_Vacio and Cli.Clu_Client = @Cli_Numero  
		union  
		select	 AdiGpo.ClClientID,  PerGpo.PerPersoID ,  AdiGpo.Adi_Client as Cli_Numero , PerGpo.Per_Numero
			from SOPERSON Per
				inner join CLADICIO Adi noholdlock on  Per.Per_Numero = Adi.Adi_NumPer
				inner join CLCLIUNI Cli noholdlock on  Adi.Adi_Client = Cli.Clu_Grupo
				inner join CLADICIO AdiGpo noholdlock on Cli.Clu_Client = AdiGpo.Adi_Client
				inner join SOPERSON PerGpo noholdlock on AdiGpo.Adi_NumPer =  PerGpo.Per_Numero
			where @Per_Numero != @Str_Vacio and Per.Per_Numero = @Per_Numero
		union
		select	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero
			from SOPERSON  
				 left join CLADICIO on  Per_Numero  =  Adi_NumPer 
			where @Per_Numero != @Str_Vacio and Per_Numero = @Per_Numero	
	end else	if @Tip_ConCon = @Con_CliEmp begin						/* Consulta unificada por Cli_Numero o Per_Numero*/	
		create table #CLCLIUNI (
			Clu_Grupo char(8)
		)

		create index CLCLIUNI on #CLCLIUNI(Clu_Grupo)
				
		select @Peu_Grupo = Peu_Grupo
		  from SOUNIPER noholdlock
		 where Peu_Person = @Per_Numero

		insert into #CLCLIUNI
		select Clu_Grupo
		  from SOUNIPER noholdlock
		 inner join CLADICIO noholdlock on Peu_Person =	Adi_NumPer
		 inner join CLCLIUNI noholdlock on Clu_Client = Adi_Client
		 where Peu_Grupo = @Peu_Grupo
		 group by Clu_Grupo
		 order by Clu_Grupo
		 
		select @Emp_Client = Emp_Client
		  from #CLCLIUNI 
		 inner join CLCLIUNI noholdlock on #CLCLIUNI.Clu_Grupo = CLCLIUNI.Clu_Grupo
		 inner join RHEMPLEA on Emp_Client = CLCLIUNI.Clu_Client
		 
		select ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero, Per_Numero
		  from CLADICIO noholdlock
		 inner join SOPERSON noholdlock on Per_Numero = Adi_NumPer
		 inner join SOUNIPER noholdlock on Per_Numero =	Peu_Person
		 where Adi_Client = @Emp_Client
		 
		drop table #CLCLIUNI
	end
end
