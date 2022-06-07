-- drop procedure SOCLACLIPRO
create procedure SOCLACLIPRO (
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

/***************************************************************************
* DESCRIPCION: Proceso de clasificacion informacion clientes recompensas   *
****************************************************************************
** REFERENCIAS: 														   *
****************************************************************************
** Creo:		Fatima Sanchez Luis										****
** Fecha:		31/Mayo/2022											****
** Help:																****
****************************************************************************/
-- Declaración de constantes 
declare @Str_Cancel	char(1),
		@Tip_PersPF	varchar(8),
		@Str_SI		char(1),
		@Str_Vacio	char(1),
		@Tip_PePFAE	varchar(8),
		@Tip_DobPer	varchar(10),
		@Ent_Cero	int,
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Ent_Tres	int,
		@Ent_Cuatro	int,
		@Ent_Noven	int,
		@Ent_Cien	int,
		@Ent_CieUno	int,
		@Ent_CieDos	int,
		@Ent_CieTre	int,
		@Ent_Doscie	int
		
		
-- Asignación de Constantes 
select	@Str_Cancel	= 'C',		-- String estatus Cancelado
		@Tip_PersPF = 'PF',		-- Tipo de persona PF
		@Str_SI		= 'S',		-- String Si 
		@Str_Vacio	= '',		-- String vacio 
		@Tip_PePFAE	= 'PFAE',	-- Tipo de persona PFAE
		@Tip_DobPer	= 'PF PFAE',	-- Constante doble personalidad
		@Ent_Cero	= 0,
		@Ent_Uno	= 1,
		@Ent_Dos	= 2,
		@Ent_Tres	= 3,
		@Ent_Cuatro	= 4,
		@Ent_Noven	= 99,
		@Ent_Cien	= 100,
		@Ent_CieUno	= 101,
		@Ent_CieDos	= 102,
		@Ent_CieTre	= 103,
		@Ent_Doscie = 200
		
create table #ClientesConUsrSinL (
Cli_Grupo char(8)
)

create table #Clientes99 (
Cli_Grupo	char(8),
Cli_CantRe	int,
Cli_CanLin	int )

create table #Clientes99SinL (
Cli_Grupo	char(8),
Cli_CantRe	int )

create table #Clientes101 (
Cli_Grupo	char(8)
)

create table #ClientesDosUsu (
Cli_Grupo	char(8)
)

create table #ClientesDosUsu102 (
Cli_Grupo	char(8)
)

create table #ClientesDosUsuProRec (
Cli_Grupo	char(8)
)

create table #Clientes103 (
Cli_Grupo	char(8)
)

create table #ConLinCredit (
Clr_Grupo	char(8)
)

create table #ClientesConUsrSinLin4 (
Clr_Grupo	char(8)
)
 
create table #Clientes499 (
Cli_Grupo	char(8),
Cli_CantRe	int,
Cli_CanLin	int )

create table #Clientes1014 (
Cli_Grupo	char(8)
)

create table #ClientesDosUsu4 (
Cli_Grupo	char(8)
)

create table #Grupos200 (
Cli_Grupo	char(8)
)

------------------------------------------------------------------------------
--- Casos cien, con inconsistencias-------------------------------------------
insert into #ClientesConUsrSinL
select Clr_Grupo
	from SOCLIREC noholdlock 
	where Clr_TipCas = @Ent_Dos
	  and Clr_Nbusua = @Str_SI
	  and ( Clr_LinVir = @Str_Vacio  or (Clr_LinVir<> @Str_Vacio and Clr_StLiVi = @Str_Cancel ) )

update SOCLIREC set
Clr_Caso = @Ent_Cien
	from SOCLIREC  
	where Clr_Grupo in (select Cli_Grupo from #ClientesConUsrSinL  )

-- ================================================================================== --
-- 						Sacamos los totales generales								  --
-- ================================================================================== --

-- totales caso 2
insert into TMPCIFREC_BKP20220630
select Clr_TipPer, Clr_TipCas, @Ent_Cero ,count(*), 'Total Clientes Detalle',@FechaSis
				from SOCLIREC noholdlock
				where Clr_TipCas =@Ent_Dos and Clr_Caso != @Ent_Cero
				group by Clr_TipPer, Clr_TipCas
Union 
select Clr_TipPer , Clr_TipCas, @Ent_Cero, count(*)conteos, 'Total Grupos' descripcion,@FechaSis
	from (
			select Clr_Grupo,Clr_TipPer , Clr_TipCas
				from SOCLIREC noholdlock
			where Clr_TipCas =@Ent_Dos and Clr_Caso != @Ent_Cero
				group by Clr_Grupo,Clr_TipPer,Clr_TipCas
	) a
	group by Clr_TipPer,Clr_TipCas
-- totales caso 3
insert into TMPCIFREC_BKP20220630
select Clr_TipPer, Clr_TipCas, @Ent_Cero ,count(*), 'Total Clientes Detalle',@FechaSis
				from SOCLIREC noholdlock
				where Clr_TipCas =@Ent_Tres 
				group by Clr_TipPer, Clr_TipCas
Union 
select Clr_TipPer , Clr_TipCas, @Ent_Cero, count(*)conteos, 'Total Grupos' descripcion,@FechaSis
	from (
			select Clr_Grupo,Clr_TipPer , Clr_TipCas
				from SOCLIREC noholdlock
			where Clr_TipCas =@Ent_Tres
				group by Clr_Grupo,Clr_TipPer,Clr_TipCas
	) a
	group by Clr_TipPer,Clr_TipCas
	
-- totales caso 4
insert into TMPCIFREC_BKP20220630
select @Tip_DobPer, Clr_TipCas, @Ent_Cero ,count(*), 'Total Clientes Detalle',@FechaSis
				from SOCLIREC noholdlock
				where Clr_TipCas =@Ent_Cuatro 
				group by Clr_TipCas
Union 
select @Tip_DobPer , Clr_TipCas, @Ent_Cero, count(*)conteos, 'Total Grupos' descripcion,@FechaSis
	from (
			select Clr_Grupo , Clr_TipCas
				from SOCLIREC noholdlock
			where Clr_TipCas =@Ent_Cuatro
				group by Clr_Grupo,Clr_TipCas
	) a
	group by Clr_TipCas

-- ================================================================================== --
-- 						Fin  totales generales								  --
-- ================================================================================== --

-- Clientes que no tienen lineas de credito ni cuentas que generan recompensas NADA QUE HACER
insert into #Clientes99
select Clr_Grupo, SUM(Clr_CaCuRe), sum(Clr_CaLiCr) 
	from SOCLIREC noholdlock
	where Clr_TipCas = @Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	group by Clr_Grupo	
	having sum(Clr_CaCuRe)= @Ent_Cero  and sum(Clr_CaLiCr) = @Ent_Cero
	order by Clr_Grupo	

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC 
	inner join #Clientes99 on Cli_Grupo = Clr_Grupo  


-- Son clientes que no tienen lineas virtuales
insert into #Clientes99SinL
select Clr_Grupo, SUM(Clr_CanLiv)
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	group by Clr_Grupo	
	having  SUM(Clr_CanLiv)= @Ent_Cero

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC noholdlock
	inner join #Clientes99SinL on Cli_Grupo = Clr_Grupo  	


----101
-- drop table #Clientes101 = 101 UNA LINEA CANCELADA QUE SE PUEDE REACTIVAR
insert into #Clientes101
select Clr_Grupo
	from SOCLIREC noholdlock 
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	  and Clr_LinVir <> @Str_Vacio
	group by Clr_Grupo	
	having count(*)>@Ent_Uno
	order by Clr_Grupo	
	
insert into #ClientesDosUsu	
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	  and Clr_UsuBan <> @Str_Vacio
	group by Clr_Grupo	
	having count(*)>@Ent_Uno
	order by Clr_Grupo		
	
	
update SOCLIREC set
Clr_Caso = @Ent_CieUno
	from SOCLIREC noholdlock
	inner join #Clientes101 Uno on Uno.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsu Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
	where Dos.Cli_Grupo is null

								
---102 Cliente PF con mas de un id, con mas de un usuario de banca activo, linea de recompensas cancelada en 1 de sus ids el cual tiene producto que genera de recompensas
-- drop table #ClientesDosUsu102 
insert into #ClientesDosUsu102
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	  and Clr_UsuBan <> @Str_Vacio
	group by Clr_Grupo	
	having count(*)>@Ent_Uno
	order by Clr_Grupo	
	
insert into #ClientesDosUsuProRec
select  Clr_Grupo 
	from SOCLIREC noholdlock
	inner join #ClientesDosUsu102 on Cli_Grupo = Clr_Grupo
	where Clr_TipCas = @Ent_Dos 
	  and   Clr_Caso = @Ent_Cien
	  and( Clr_CaCuRe >= @Ent_Uno or Clr_CaLiCr >=@Ent_Uno )
	 group by Clr_Grupo
	 having count(*) > @Ent_Uno
	
update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC 
	inner join #ClientesDosUsu102 on Cli_Grupo = Clr_Grupo
	where Clr_Grupo not in (select Cli_Grupo from  #ClientesDosUsuProRec )	
	

	
update SOCLIREC set
Clr_Caso = @Ent_CieDos
	from SOCLIREC noholdlock
	inner join #ClientesDosUsuProRec on Cli_Grupo = Clr_Grupo
	

--103
insert into #Clientes103
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	  and Clr_CueAct =@Ent_Cero
	group by Clr_Grupo	
	order by Clr_Grupo	
	
update SOCLIREC set
Clr_Caso = @Ent_CieTre
	from SOCLIREC noholdlock
	inner join #Clientes103 on Cli_Grupo = Clr_Grupo
	
	
drop table  #ClientesConUsrSinL, #Clientes101,
		 	#ClientesDosUsu102, #Clientes103,#ClientesDosUsuProRec,
			#ClientesDosUsu, #Clientes99SinL,	#Clientes99


	

-------------------------------------------------------------------------
-- Tipo caso 3
-- ========================================================================================= --
--  								CLASIFICACION PFAE SIN LINEA DE CREDITO 				 --
-- ========================================================================================= -- 
insert into #ConLinCredit
select distinct Clr_Grupo
from SOCLIREC noholdlock
where Clr_CaLiCr != @Ent_Cero
and Clr_LinVir != @Str_Vacio
and Clr_TipCas in (@Ent_Tres,@Ent_Cuatro)
and Clr_TipPer = @Tip_PePFAE

-- ========================================================================================= --
--  								CLASIFICACION PFAE CON LINEA DE CREDITO 				 --
-- ========================================================================================= -- 
update SOCLIREC set 
	Clr_Caso=@Ent_Noven
	from SOCLIREC a left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas in (3,@Ent_Cuatro)
	and Clr_TipPer = @Tip_PePFAE
	and b.Clr_Grupo is null


update SOCLIREC set 
	Clr_Caso=@Ent_Noven
	from SOCLIREC a inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas in (@Ent_Tres,@Ent_Cuatro)
	and Clr_TipPer = @Tip_PePFAE

drop table #ConLinCredit


-------------------------------------------------------------------------

-- Clasificacion de casos 4

-- drop table #ClientesConUsrSinL	
insert into #ClientesConUsrSinLin4
  select Clr_Grupo 
	from SOCLIREC noholdlock 
	where Clr_TipCas = @Ent_Cuatro
	  and Clr_TipPer = @Tip_PersPF
	  and Clr_Nbusua = @Str_SI
	  and ( Clr_LinVir = @Str_Vacio  or (Clr_LinVir<> @Str_Vacio and Clr_StLiVi = @Str_Cancel ) )


update SOCLIREC set
Clr_Caso = @Ent_Cien
	from SOCLIREC noholdlock 
	where Clr_Grupo in (select Clr_Grupo from #ClientesConUsrSinLin4  )
	and Clr_TipPer = @Tip_PersPF

-- mandamos a 99 los que no tiene problemas	
update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC noholdlock 
	where Clr_TipCas = @Ent_Cuatro
	and Clr_Grupo not in (select Clr_Grupo from #ClientesConUsrSinLin4  )
	and Clr_TipPer = @Tip_PersPF

-- Clientes que no tienen lineas de credito ni cuentas que generan recompensas NADA QUE HACER
insert into #Clientes499
select tmp.Clr_Grupo, SUM(Clr_CaCuRe), sum(Clr_CaLiCr) 
	from #ClientesConUsrSinLin4 tmp
	inner join SOCLIREC Soc noholdlock 	on Soc.Clr_Grupo	= tmp.Clr_Grupo
										and Clr_TipCas		= @Ent_Cuatro 
	group by tmp.Clr_Grupo	
	having sum(Clr_CaCuRe)= @Ent_Cero  and sum(Clr_CaLiCr) = @Ent_Cero
	order by Clr_Grupo	

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC 
	inner join #Clientes499 on Cli_Grupo = Clr_Grupo  
	where  Clr_TipPer = @Tip_PersPF
 

--drop table #Clientes101 = 101 UNA LINEA CANCELADA QUE SE PUEDE REACTIVAR
insert into #Clientes1014
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Cuatro 
	  and Clr_Caso = @Ent_Cien
	  and Clr_LinVir <> @Str_Vacio
	  and Clr_TipPer =@Tip_PersPF
	group by Clr_Grupo	
	having count(*)>@Ent_Uno
	order by Clr_Grupo	

insert into #ClientesDosUsu4
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas	= @Ent_Cuatro 
	  and Clr_Caso		= @Ent_Cien
	  and Clr_UsuBan	<> @Str_Vacio
	  and Clr_TipPer	= @Tip_PersPF
	group by Clr_Grupo	
	having count(*)> @Ent_Uno
	order by Clr_Grupo		
	
	
update SOCLIREC set
Clr_Caso = @Ent_CieUno
	from SOCLIREC 
	inner join #Clientes1014 Uno on Uno.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsu4 Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
	where Dos.Cli_Grupo is null
	   and Clr_TipPer =@Tip_PersPF



insert into #Grupos200
select  Clr_Grupo 
	from SOCLIREC noholdlock
	where Clr_Caso =  @Ent_CieTre
	and (Clr_CreAct =  @Ent_Uno or Clr_CrABAc = @Ent_Uno or Clr_CrCCAc = @Ent_Uno )


update SOCLIREC set
Clr_Caso = @Ent_Doscie
from SOCLIREC
inner join #Grupos200 on Cli_Grupo = Clr_Grupo


drop table	#ClientesConUsrSinLin4,	#Clientes499,	#Clientes1014,	#ClientesDosUsu4,
			#Grupos200
		


-- ========================================================================= --
-- 						Insertamos Conteos de los casos						 --
-- ========================================================================= --

insert into TMPCIFREC_BKP20220630
select *,@FechaSis
from (
		
	select  Clr_TipPer , Clr_TipCas, Clr_Caso, count(*) conteos, 'Detalles' descripcion
		from SOCLIREC noholdlock
		group by Clr_TipPer,Clr_TipCas, Clr_Caso
Union 
select Clr_TipPer , Clr_TipCas, Clr_Caso, count(*)conteos, 'Grupos' descripcion
	from (
			select Clr_Grupo,Clr_TipPer , Clr_TipCas, Clr_Caso
				from SOCLIREC noholdlock
				group by Clr_Grupo,Clr_TipPer,Clr_TipCas, Clr_Caso
	) a
	group by Clr_TipPer,Clr_TipCas, Clr_Caso
) a
	order by Clr_TipPer,Clr_TipCas, Clr_Caso, descripcion asc
	 
	 