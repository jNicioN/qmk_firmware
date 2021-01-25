create procedure SOPECLCLCON(
	@Per_RFC	char(15),
	@Per_Client	char(8),
	@Cli_Clasif int,
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*
**************************************************************
** DESCRIPCION: Personas por Clasificacion de Clientes		**
**************************************************************
** Creador:		Jaret Guanajuato Ruvalcaba					**
** Fecha:		22/01/2021									**
** HelpDesk:	1069797										**
** Descripcion:	Creacion del procedimiento					**
**************************************************************
*/

declare @Tip_ConTip char(1),
		@Tip_ConCon char(1)

declare @Con_Client char(1),
		@Con_RFC	char(1),
		@Str_Consul char(1),
		@Cla_BR		int,
		@Str_Vacio	char(1)

select	@Con_Client = '1',
		@Con_RFC	= '2',
		@Str_Consul = 'C',
		@Cla_BR		= 2,
		@Str_Vacio	= ''

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

create table #PersonaClasificacion(
	Per_Numero	char(8)  not null,
	Per_Tipo	char(1)  not null,
	Per_Benefi  char(1)  not null,
	Per_NuSeFi  varchar(30)  not null,
	Per_Titulo  varchar(10)  not null,
	Per_Nombre  varchar(40)  not null,
	Per_ApePat  varchar(40)  not null,
	Per_ApeMat  varchar(40)  not null,
	Per_RazSoc  varchar(180)  not null,
	Per_Comple  varchar(180)  not null,
	Per_ComOrd  varchar(180)  not null,
	Per_RFC		varchar(15)  not null,
	Per_Client	char(8) not null,
	Per_CURP	char(18)  not null,
	Per_Fecha	smalldatetime,
	Per_Entida  char(3)  not null,
	Per_Locali  char(8)  not null,
	Per_ClaCli	int not null)


if @Tip_ConTip = @Str_Consul begin
	if @Tip_ConCon = @Con_Client begin

		create table #GrupoPersona (
			Per_Person char(10),
			Per_Grupo  char(10)
		)
		
		insert into #GrupoPersona
		select Adi_NumPer,	Adi_NumPer
			from CLADICIO noholdlock
			inner join CLCLACLI noholdlock on ClClientID = Clc_Client
			where Adi_Client = @Per_Client
			  and Clc_Clasif = @Cli_Clasif 
		
		update #GrupoPersona set
			Per_Grupo = Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person = Per_Person
			
	
		insert into #PersonaClasificacion
		select	P.Per_Numero,	P.Per_Tipo,		P.Per_Benefi,	P.Per_NuSeFi,	P.Per_Titulo,
				P.Per_Nombre,	P.Per_ApePat,	P.Per_ApeMat,	P.Per_RazSoc,	P.Per_Comple,
				P.Per_ComOrd,	P.Per_RFC,		@Per_Client,	P.Per_CURP,		P.FechaSis,		
				P.Per_Entida,	P.Per_Locali,	@Cli_Clasif
			from SOPERSON P noholdlock
			inner join #GrupoPersona on P.Per_Numero = Per_Grupo   
		
		select	Per_Numero, Per_Tipo, 	Per_Benefi, Per_NuSeFi, Per_Titulo, 
				Per_Nombre, Per_ApePat, Per_ApeMat, Per_RazSoc, Per_Comple, 
				Per_ComOrd, Per_RFC, 	Per_CURP, 	Per_Fecha, 	Per_Entida, 
				Per_Locali, Per_ClaCli, 
				Per_Client = case when Per_Client = @Str_Vacio then null else Per_Client end
			from #PersonaClasificacion
		
		drop table #GrupoPersona

	end else if @Tip_ConCon = @Con_RFC begin

		   
		insert into #PersonaClasificacion
		select	P.Per_Numero,	P.Per_Tipo,		P.Per_Benefi,	P.Per_NuSeFi,	P.Per_Titulo,
				P.Per_Nombre,	P.Per_ApePat,	P.Per_ApeMat,	P.Per_RazSoc,	P.Per_Comple,
				P.Per_ComOrd,	P.Per_RFC,		isnull(A.Adi_Client, @Str_Vacio),	P.Per_CURP,		P.FechaSis,		
				P.Per_Entida,	P.Per_Locali,	@Cla_BR
			from	SOPERSON P noholdlock
			left join CLADICIO A noholdlock on A.Adi_NumPer = P.Per_Numero
			where	P.Per_RFC = @Per_RFC
		 
		create table #ClientesClasificacion(
			ClClientID int not null,
			Cli_Numero char(8) not null,
			Cli_Clasif int not null)
		 
		insert into #ClientesClasificacion
		select ClClientID, Cli_Numero, Clc_Clasif
			from CLCLIENT noholdlock,
				 #PersonaClasificacion,
				 CLCLACLI noholdlock
			where Cli_Numero = Per_Client
			  and ClClientID = Clc_Client
			  and Per_Client != @Str_Vacio
	 	
		update #PersonaClasificacion
			set Per_ClaCli = Cli_Clasif
			from #ClientesClasificacion
			where Per_Client = Cli_Numero
			
		drop table #ClientesClasificacion
		 
		select	Per_Numero, Per_Tipo, 	Per_Benefi, Per_NuSeFi, Per_Titulo, 
				Per_Nombre, Per_ApePat, Per_ApeMat, Per_RazSoc, Per_Comple, 
				Per_ComOrd, Per_RFC, 	Per_CURP, 	Per_Fecha, 	Per_Entida, 
				Per_Locali, Per_ClaCli, 
				Per_Client = case when Per_Client = @Str_Vacio then null else Per_Client end
		from #PersonaClasificacion 
		where Per_ClaCli = @Cli_Clasif

	end
end
drop table #PersonaClasificacion
