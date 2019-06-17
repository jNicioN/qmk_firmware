create procedure SOCAINUPPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Carga Inicial Unificacion de Personas			  */
/*******************************************************************
** Modifico:	Estela Mendoza G								****
** Fecha:		26/Jun/2014										****
** Help:		0634146 										****
** Descripcion:	No insertar con grupo vacio						****
********************************************************************
** Creo:		Claudia Sandoval								****
** Fecha:		07/Ago/2013										****
** Help:		0599444											****
*******************************************************************/

truncate table SOUNIPER

create table #UniPer (
	Person	char(8),
	Client	char(8),
	CliGru	char(8),
	PerGru	char(8)
)

insert into #UniPer
	select	Adi_NumPer,	Adi_Client,	Clu_Grupo, 
			case when	Adi_Client	= Clu_Grupo 
				 then	Adi_NumPer 
				 else	''
			end
	from CLCLIUNI noholdlock
		inner join CLADICIO noholdlock on  Adi_Client =  Clu_Client and Adi_NumPer <> ''

create index IndiceCliGru		on #UniPer(CliGru)
create index IndicePerGru		on #UniPer(PerGru)

update #UniPer set 
	PerGru	= Adi_NumPer
	from CLADICIO noholdlock
	where	Adi_Client = CliGru

insert into SOUNIPER
	select	distinct PerGru, Person,
			@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	@SucOrigen,
			@SucDestino
	from #UniPer
	where 	PerGru <> ''

drop table #UniPer
