create procedure SOTMPEXPPRO (
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
** Modifico:		Oscar Trevino    												 ****
** Fecha:		13/Diciembre/2021													 ****
** Desc:		Se corrige condicion en consulta de grupos unicos para ****
**					utilizar Peu_Person en lugar de Peu_Grupo						****
** Help:	1574028																		****
*************************************************************************************
** Creo:		Francisco Euan     												 ****
** Fecha:		29/Octubre/2021													 ****
** Help:	1574028														****
************************************************************************************/


/* Declaracion de Constantes */
declare	@Str_Vacio	char(1),
		@Ent_Doce	smallint,
		@Ent_Trece	smallint,
		@Cla_Hey	smallint,
		@Cla_Banreg	smallint,
		@Str_Prefi char(4),
		@Sta_Exito smallint

select	@Str_Vacio	= '',			/* Cadena vacia 								*/
		@Ent_Doce	= 12,			/* Entero doce									*/
		@Ent_Trece	= 13,			/* Entero trece									*/
		@Cla_Hey	= 1,			/* Clasificacion para Hey						*/
		@Cla_Banreg	= 2,			/* Clasificacion para Banregio					*/
		@Str_Prefi	= 'exp-',
		@Sta_Exito  = 2

CREATE TABLE #PersonasUnicas(
	Grupo char(8) not null
)
create nonclustered index #PersonasUnicas on #PersonasUnicas ( Grupo)

delete from SOTMPEXP where Exp_NumTra <> @NumTransac

insert into #PersonasUnicas(Grupo)
select distinct UNI.Peu_Grupo
	from CLCLACLI CLA noholdlock
inner join CLADICIO ADI noholdlock on CLA.Clc_Client = ADI.ClClientID
inner join SOUNIPER UNI noholdlock on ADI.Adi_NumPer = UNI.Peu_Person
where 	CLA.Clc_Clasif = @Cla_Hey

delete #PersonasUnicas
from #PersonasUnicas 
inner join SOBICREX noholdlock on Grupo = Bce_Person
where Bce_Status = @Sta_Exito

insert into SOTMPEXP
	(Exp_Person,	Exp_Tipo,	Exp_RFC,	Exp_PerFis,	Exp_Reposi,
	Exp_Nombre,		Exp_ApePat,	Exp_ApeMat,	Exp_RazSoc,	Exp_Curp,
	Exp_FecNac,		Exp_NumTra)
select 	PER.Per_Numero, PER.Per_Tipo, PER.Per_RFC, PER.Per_Tipo,lower(@Str_Prefi||PER.Per_RFC) as Repo,
		PER.Per_Nombre, PER.Per_ApePat, PER.Per_ApeMat, PER.Per_RazSoc, PER.Per_CURP,PEA.Adi_FecNac,
		@NumTransac
from #PersonasUnicas PEU
inner join SOPERSON PER noholdlock on PEU.Grupo = PER.Per_Numero
inner join SOPERADI PEA noholdlock on PER.Per_Numero = PEA.Adi_PerNum
left join SOTMPEXP CRE noholdlock on PER.Per_Numero = CRE.Exp_Person
where	CRE.Exp_Person is null

drop table #PersonasUnicas
