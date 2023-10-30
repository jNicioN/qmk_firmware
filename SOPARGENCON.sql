create procedure SOPARGENCON (
	@Par_Consec	int,
	@Par_Nombre	varchar(50),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** DESCRIPCIÓN: Consulta de parámetros generales						  **
**************************************************************************** 
**																		  **
** REFERENCIAS:															  **
****************************************************************************
** Modifico: Joshua Said												****
** Fecha: 15/Junio/2023													****
** HelpDesk: TRAOPC-1227												****
****************************************************************************
** Creó: Mariel Morfín													****
** Fecha: 30/septiembre/2021											****
** HelpDesk: 1568050													****
****************************************************************************/

declare	@Tip_ConTip	char(1),	/* Declaración de variables */
		@Tip_ConCon	char(1),
		@End_Point varchar(200),
		@Url_Downlo varchar(200),
		@Url_EndEma varchar(200),
		@Url_ImaEma varchar(200)
								
declare	@Tip_ConInd	char(1),	/* Declaración de constantes */
		@Tip_ConUno	char(1),
		@Tip_ConDos	char(1),
		@Tip_ConTres char(1),
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Ent_Tres	int
		
declare @Par_EndPoi char(10), /* Declaración de variables Ec TDC*/
		@Par_UrlTdc char(10),
		@Par_SenEma char(10),
		@Par_UrlIma char(10)

/* Asignación de constantes */
select	@Tip_ConInd	= 'C',		/* Tipo Consulta Individual*/
		@Tip_ConUno	= '1',		/* Tipo Consulta Uno */
		@Tip_ConDos	= '2',		/* Tipo Consulta Dos */
		@Tip_ConTres 	= '3',		/* Tipo Consulta Tres */
		@Ent_Uno	= 1,		/* Entero Uno */
		@Ent_Dos	= 2,		/* Entero Dos */
		@Ent_Tres	= 3,		/* Entero Tres */
		@Par_EndPoi = 'Par_EndPoi',
		@Par_UrlTdc = 'Par_UrlDow',
		@Par_SenEma = 'Par_SenEma',
		@Par_UrlIma = 'Par_UrlIma'
										
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)
		
if @Tip_ConTip = @Tip_ConInd begin
	
	if @Tip_ConCon = @Tip_ConUno begin
		
		select	Par_Valor
			from SOPARGEN noholdlock
			where	Par_Consec	= @Par_Consec
			
	end if @Tip_ConCon = @Tip_ConDos begin
	
		select	Par_Valor
			from SOPARGEN noholdlock
			where	Par_Nombre	= @Par_Nombre

	end else if @Tip_ConCon = @Tip_ConTres begin  	/* Consulta de propiedades de MS Ec TDC*/
	
			select @End_Point = Par_Valor 
			from SOPARGEN noholdlock
				where Par_Nombre = @Par_EndPoi
				order by Par_Consec asc
				
			select @Url_Downlo = Par_Valor 
			from SOPARGEN noholdlock
				where Par_Nombre = @Par_UrlTdc
				order by Par_Consec asc
				
			select @Url_EndEma = Par_Valor 
			from SOPARGEN noholdlock
				where Par_Nombre = @Par_SenEma
				order by Par_Consec ASC
				
			select @Url_ImaEma = Par_Valor 
			from SOPARGEN noholdlock
				where Par_Nombre = @Par_UrlIma
				order by Par_Consec asc
				
			select ltrim(rtrim(@End_Point)) Endpoint, rtrim(ltrim(@Url_Downlo)) Urldownload,rtrim(ltrim(@Url_EndEma))
			
	end
	
end