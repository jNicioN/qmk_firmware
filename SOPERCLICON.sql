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
		@Str_Vacio  char(1)
		
										/* Asignación de constantes */
select	@Str_Vacio	= ''				/* String vacío */		

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		

if @Tip_ConTip = 'C' begin							/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin						/* Consulta by Cli_Numero  */	
	
		select  ClClientID,  PerPersoID  ,  Adi_Client as Cli_Numero, Adi_NumPer as Per_Numero
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	Adi_Client  = @Cli_Numero
	
	end else	if @Tip_ConCon = '2' begin			/* Consulta by Per_Numero  */	
	
		select 	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero
		from 	SOPERSON	noholdlock
		left 	join CLADICIO noholdlock on Adi_NumPer = Per_Numero 
		where  	Per_Numero  = @Per_Numero
	
	end else	if @Tip_ConCon = '3' begin						/* Consulta by Cli_Numero , return params  */	
	
		select  @ClClientID = ClClientID,  @PerPersoID = PerPersoID  
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	Adi_Client  = @Cli_Numero
		
	end else	if @Tip_ConCon = '4' begin			/* Consulta by ClClientID  */	
	
		select  ClClientID,  PerPersoID  ,  Adi_Client as Cli_Numero, Adi_NumPer as Per_Numero
		from 	CLADICIO 	noholdlock
		inner	join SOPERSON noholdlock on	Per_Numero	=	Adi_NumPer
		where  	ClClientID  = @ClClientID
	
	end else	if @Tip_ConCon = '5' begin						/* Consulta by PerPersoID*/	
	
		select 	ClClientID,  PerPersoID ,  Adi_Client as Cli_Numero , Per_Numero
		from 	SOPERSON	noholdlock
		left 	join CLADICIO noholdlock on Adi_NumPer = Per_Numero 
		where  	PerPersoID  = @PerPersoID
	
	end else	if @Tip_ConCon = '6' begin						/* Consulta unificada por Cli_Numero o Per_Numero*/	
	
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
	end
	
end