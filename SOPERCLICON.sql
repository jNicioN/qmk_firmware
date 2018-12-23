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
		@Tip_ConCon	char(1)

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
	
	end
	
end
