create procedure SOCAPESUPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/******************************************************************/
/* DESCRIPCION: Carga de Personas sin Unificar 					  */
/*******************************************************************
** Creo:		Estela Mendoza G.								****
** Fecha:		26/Jun/2014										****
** Help:		0634146											****
** Descripcion:	Se Crea el Store Personas sin unificar			****
*******************************************************************/

declare	@Str_Vacio	char(1),
		@Str_Espaci	char(1),
		@Str_Guion	char(1),
		@Tip_Moral	char(1),
		@Tip_Fisica	char(1)

select	@Str_Vacio	= '',
		@Str_Espaci	= ' ',
		@Str_Guion	= '-',
		@Tip_Moral	= '1',
		@Tip_Fisica	= '2'

select	Persona		= Per_Numero,
		Rfc			= Per_RFC,
		RfcMod		= replicate(@Str_Vacio, 13),
		TipPer		= Per_Tipo , 
		LongitudRFC	= len(ltrim(rtrim(Per_RFC))),
		Grupo		= replicate(@Str_Vacio, 8)
	into #PerNoUni
	from SOPERSON noholdlock 
	where Per_Numero not in (select Peu_Person from SOUNIPER noholdlock)

update #PerNoUni set
	RfcMod	= isnull(ltrim(rtrim(STR_REPLACE(STR_REPLACE(Rfc,@Str_Espaci, null),@Str_Guion, null))), @Str_Vacio)

create index PerNoUni		on #PerNoUni (Persona)
create index PerNoUniRFC	on #PerNoUni (RfcMod)
create index PerNoUniLon	on #PerNoUni (LongitudRFC)

select distinct RfcMod
	into #RfcSinUni
	from #PerNoUni
	where 	LongitudRFC >= 12
	  and	RfcMod <> 'NOCAPTURADO'

select Person = Per_Numero, RfcPer = Per_RFC, RfcModPer = replicate(@Str_Vacio, 13)	
	into #Personas 
	from SOPERSON noholdlock 

update #Personas set
	RfcModPer	= isnull(ltrim(rtrim(STR_REPLACE(STR_REPLACE(RfcPer,@Str_Espaci, null),@Str_Guion, null))), @Str_Vacio)

create index PersonasRfc	on #Personas (RfcModPer) /*  1  */

select	PerMatch	= Person, 
		RfcMod as RfcUniPer, 
		PerSinUni	= replicate(@Str_Vacio, 8), 
		GrupoUni	= replicate(@Str_Vacio, 8) 
	into #UniPer 
	from #RfcSinUni
	inner join #Personas 
		on	RfcMod = RfcModPer 
		and Person not in (select Persona from #PerNoUni)

drop table #RfcSinUni
drop table #Personas /*  2  */

update  #UniPer set
	GrupoUni =  Peu_Grupo 
	from SOUNIPER noholdlock 
	where  Peu_Person = PerMatch

update  #PerNoUni set
	Grupo	= GrupoUni
	from #UniPer 
	where RfcMod = RfcUniPer

drop table #UniPer /*  3  */

update  #PerNoUni set
	Grupo	= Persona
	where Grupo = @Str_Vacio

insert into SOUNIPER
	select distinct 
			Grupo, Persona,
			@NumTransac,	@Transaccio,	@Usuario,	@FechaSis,	@SucOrigen,
			@SucDestino 
	from #PerNoUni 
	where Grupo <> @Str_Vacio

drop table #PerNoUni
