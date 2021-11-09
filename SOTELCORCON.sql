create procedure SOTELCORCON(
	@Tep_Lada   int,
    @Tep_Telefo varchar(10),
    @Cop_Correo   varchar(100),
    @Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** Descripción:	 Consulta de correos y telefono de persona				****
****************************************************************************
** Creó:		Luis Enrique Ramirez Ortiz								****
** Fecha:		01/10/2021												****
** Help:		1179955													****
****************************************************************************/

declare @Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Tep_TelLon	bigint

										/* Declaración de constantes */
declare	@Con_Consul	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1)

										/* Asignación de constantes */
select	@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Str_Uno	= '1',				/* String Uno*/
		@Str_Dos	= '2'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
select @Tep_TelLon = convert(bigint, @Tep_Telefo)
		

		
if @Tip_ConTip = @Con_Consul begin		/* Consultas */
	if @Tip_ConCon = @Str_Uno begin	/* Consulta por Telefono */
		select   PerPersoID , Tep_Lada, Tep_Telefo
		from SOTELPER noholdlock
		where  Tep_Lada = @Tep_Lada
		and	   Tep_Telefo =  @Tep_TelLon
	end else if @Tip_ConCon = @Str_Dos begin /* Consulta Por Correo */
		select   PerPersoID ,  Cop_Correo
		from SOCORPER noholdlock
		where   Cop_Correo  = @Cop_Correo
	end
end