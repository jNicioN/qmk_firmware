create procedure SOPACAEXPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***********************************************************************************/
/*DESCRIPCION: Procesa las nuevas personas unicas proximas a crear expediente	   */
/***********************************************************************************/
/*REFERENCIAS:
*************************************************************************************
** Creo¸:		Francisco Euan     												 ****
** Fecha:		29/Octubre/2021													 ****
** Help:	1574028														****
************************************************************************************/


/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Ent_Doce	smallint,
		@Ent_Trece	smallint,
		@Cla_Hey	smallint,
		@Cla_Banreg	smallint,
		@Str_Prefi char(4)

select	@Str_Vacio	= '',			/* Cadena vacia 								*/
		@Ent_Doce	= 12,			/* Entero doce									*/
		@Ent_Trece	= 13,			/* Entero trece									*/
		@Cla_Hey	= 1,			/* Clasificaciè´¸n para Hey						*/
		@Cla_Banreg	= 2,			/* Clasificaciè´¸n para Banregio					*/
		@Str_Prefi	= 'exp-'

CREATE TABLE #PersonasUnicas(
	Per_Grupo char(8) not null
)
create nonclustered index #PersonasUnicas on #PersonasUnicas ( Per_Grupo)

insert into #PersonasUnicas(Per_Grupo)
select distinct UNI.Peu_Grupo
	from CLCLACLI CLA noholdlock
inner join CLADICIO ADI noholdlock on CLA.Clc_Client = ADI.ClClientID
inner join SOUNIPER UNI noholdlock on ADI.Adi_NumPer = UNI.Peu_Grupo
where 	CLA.Clc_Clasif = @Cla_Hey

insert into SOPACAEX
	(Pce_UniPer,	Pce_Tipo,	Pce_RFC,	Pce_PerFis,	Pce_Reposi,
	Pce_Nombre,		Pce_ApePat,	Pce_ApeMat,	Pce_RazSoc,	Pce_Curp,
	Pce_FecNac,		NumTransac,	Transaccio,	Usuario,	FechaSis,
	SucOrigen,		SucDestino)
select 	PER.PerPersoID, PER.Per_Tipo, PER.Per_RFC, PER.Per_Tipo,lower(@Str_Prefi||PER.Per_RFC) as Repo,
		PER.Per_Nombre, PER.Per_ApePat, PER.Per_ApeMat, PER.Per_RazSoc, PER.Per_CURP,'1900-01-01',
		@NumTransac, 	@Transaccio, 	@Usuario,		@FechaSis, 		@SucOrigen, 
		@SucDestino
from #PersonasUnicas PEU
inner join SOPERSON PER noholdlock on PEU.Per_Grupo = PER.Per_Numero
left join SOPACAEX CRE noholdlock on PER.PerPersoID = CRE.Pce_UniPer
where	CRE.Pce_UniPer is null

drop table #PersonasUnicas
