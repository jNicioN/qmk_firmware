create procedure SOUSUEMACON(
		@Usu_EMail char(50),
		@Tip_Consul char(2),
		
		@NumTransac char(10),
		@Transaccio char(3),
		@Usuario char(6),
		@FechaSis smalldatetime,
		@SucOrigen char(3),
		@SucDestino char(3),
		@Modulo char(2))
as

/****************************************************************************/
/* DESCRIPCION: ** Consulta de usuario por Email 							*/
/****************************************************************************/
/** REFERENCIAS: 														****
****************************************************************************
** Creado:		Fabian Reyes											****
** Fecha:		08/03/2018												****
** Descripcion:	SP especifico de consulta de usuario por email para 	****
**				salesforce												****
***************************************************************************/

declare @Tip_ConTip char(1),		/* Declaracion de Variables */
		@Tip_ConCon char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)	
		
/* 'C':  Consulta */
if @Tip_ConTip = 'C' begin					
	if @Tip_ConCon = '1' begin	/* Consulta por email*/
		select	Usu.Usu_Numero,	Usu.Usu_Nombre,	Usu.Usu_Clave,	Usu.Usu_Autori,	Usu.Usu_Nivel,
			Usu.Usu_ImEsCu,	Usu.Usu_CoEsCu,	Usu.Usu_Status,	Usu.Usu_EMail,	Usu.Usu_Sucurs, Usu_StaSes,
			Usu.Usu_PassWo,	Usu.Usu_FeAcPa,	Usu.SaPerfilID,	Usu.Usu_Activo,	Usu_CanSes, Usu_PassWo, Usu_MulSes,
			Usu.Usu_IPSesi,	Usu.Usu_Depart
		from SOUSUARI Usu noholdlock
		where	UPPER(Usu_EMail)	= UPPER(@Usu_EMail)
	end
end
