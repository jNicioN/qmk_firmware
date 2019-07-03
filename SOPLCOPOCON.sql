create procedure SOPLCOPOCON (
	@Cpc_Numero	char(6),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/*
****************************************************************************
** Consulta del Codigo Postal **
****************************************************************************
** Creó:		Claudia Moncada											****
** Fecha:		25/Junio/2019	 				            			****
** HelpDesk:	1250382													****
****************************************************************************/

/* Declaracion de Variables */
declare @Cpc_Entida	char(3),
		@Est_Numero	char(2)

/* Declaracion de Constantes */
declare	@Pai_Mexico	char(2),
		@Sta_Activo	char(1)
		
select 	@Pai_Mexico	= '01', /*Pais méxico*/
		@Sta_Activo	= 'A' /*Status activo*/

select	@Cpc_Entida = Cpc_Entida
	from CLCODPOS noholdlock
	where	Cpc_Numero	= @Cpc_Numero

select @Est_Numero = Est_Numero
	from SOESTADO noholdlock inner join CLENTIDA noholdlock on Ent_Fondeo = Est_ClaABM
	where Ent_Pais = @Pai_Mexico
	  and Ent_Status = @Sta_Activo
	  and Est_Pais = @Pai_Mexico
	  and Ent_Numero = @Cpc_Entida

select top 1 Suc_Plaza
from SOSUCURS noholdlock
where  Suc_Estado = '19' order by Suc_Numero