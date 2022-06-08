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
** Help:		1637684														****
****************************************************************************/

-- Declaracion de variables

declare @Num_Detalle	int,			-- conteo de registros
	     @Num_Grupos	int,
		 @Ccr_numero	int

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

create table #ClientesGrupos (
Cli_Grupo	char(8)
)

create table #Grupos200 (
Cli_Grupo	char(8)
)

-- ================================================================================== --
-- 						Sacamos los totales Iniciales detalle y grupo General			  --
-- ================================================================================== --

-- Sacamos el detalle inicial 
select  @Num_Detalle = count(*)
	from  SOCLIREC noholdlock 

insert into #ClientesGrupos
select Clr_Grupo
	from SOCLIREC noholdlock 
	 group by Clr_Grupo

-- Sacamos el numero inicial de grupo
select  @Num_Grupos = count(*)
from #ClientesGrupos 

-- Insertamos el detalle y los grupos (Iniciales) para el caso 100
insert into SOCICORE
	   	(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cero,		@Ent_Cero,	@Num_Detalle,	@Num_Grupos,
		@Ent_Cero,		@Ent_Cero,	@FechaSis,		@NumTransac,
		@Transaccio,	@Usuario,	@FechaSis,		@SucOrigen, 
		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null



-- ================================================================================== --
-- 				Sacamos los totales Iniciales detalle y grupo	Tipo Caso 2	  			--
-- ================================================================================== --

-- Sacamos el detalle inicial 
select  @Num_Detalle = count(*)
	from  SOCLIREC noholdlock 
	where Clr_TipCas = @Ent_Dos



insert into #ClientesGrupos
select Clr_Grupo
	from SOCLIREC noholdlock 
	  where Clr_TipCas = @Ent_Dos
	  group by Clr_Grupo


-- Sacamos el numero inicial de grupo
select  @Num_Grupos = count(*)
from #ClientesGrupos 


-- Insertamos el detalle y los grupos (Iniciales) para el caso 100
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cero,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
		@Ent_Cero,	@FechaSis, 	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,	@SucOrigen,	@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null 

------------------------------------------------------------------------------
--- Casos cien, con inconsistencias-------------------------------------------
insert into #ClientesConUsrSinL
select Clr_Grupo
	from SOCLIREC noholdlock 
	where Clr_TipCas = @Ent_Dos
	  and Clr_Nbusua = @Str_SI
	  and ( Clr_LinVir = @Str_Vacio  or (Clr_LinVir<> @Str_Vacio and Clr_StLiVi = @Str_Cancel ) )

-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 100   			  --
-- ================================================================================== --


-- Sacamos el detalle inicial Para los casos 100
select  @Num_Detalle = count(*)
	from SOCLIREC noholdlock 
	inner join #ClientesConUsrSinL  on Cli_Grupo = Clr_Grupo 


insert into #ClientesGrupos 
select Clr_Grupo
	from SOCLIREC noholdlock 
	inner join #ClientesConUsrSinL on Cli_Grupo = Clr_Grupo
	group by Clr_Grupo

-- Sacamos el numero inicial de grupo
select  @Num_Grupos = count(*)
from #ClientesGrupos 

-- Insertamos el detalle y los grupos (Iniciales) para el caso 100
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cien,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino


delete from #ClientesGrupos 
where Cli_Grupo is not null

-- Se actualiza la informacion
update SOCLIREC set
Clr_Caso = @Ent_Cien
	from SOCLIREC noholdlock 
	inner join #ClientesConUsrSinL on Cli_Grupo = Clr_Grupo

-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 100 --
-- =============================================================== --

-- Vamos por el total general de los tipo caso 2 y caso 100
select @Num_Detalle = @@rowcount	

-- Guardamos los numero de grupos actualizados al final

insert into #ClientesGrupos 
select Clr_Grupo
		from SOCLIREC noholdlock 
		where Clr_Caso 	 = @Ent_Cien
	  	  and Clr_TipCas = @Ent_Dos 
		group by Clr_Grupo


select @Num_Grupos = count(*)
from #ClientesGrupos 


update SOCICORE set Ccr_ClDeAc =  @Num_Detalle,
					Ccr_ClGrAc =  @Num_Grupos
	where Ccr_IdCaso = @Ent_Cien 
	  and Ccr_FecCla = @FechaSis


delete from #ClientesGrupos
where Cli_Grupo is not null

-- ========================================================================================= --
--  								CLASIFICACION 99 				 						 --
-- ========================================================================================= --


-- Clientes que no tienen lineas de credito ni cuentas que generan recompensas NADA QUE HACER
insert into #Clientes99
select Clr_Grupo, SUM(Clr_CaCuRe), sum(Clr_CaLiCr) 
	from SOCLIREC noholdlock
	where Clr_TipCas = @Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	group by Clr_Grupo	
	having sum(Clr_CaCuRe)= @Ent_Cero  and sum(Clr_CaLiCr) = @Ent_Cero
	order by Clr_Grupo	



-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 99   			 	 --
-- ================================================================================== --

-- Sacamos el numero de registros detalles para el caso 99
select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
	inner join #Clientes99 on Cli_Grupo = Clr_Grupo  

-- Sacamos el numero de registros grupo para el caso 99

insert into #ClientesGrupos
 select Clr_Grupo
					from SOCLIREC noholdlock
					inner join #Clientes99 on Cli_Grupo = Clr_Grupo
					group by  Clr_Grupo

select @Num_Grupos = count(*)
    from 	#ClientesGrupos

-- Insertamos el detalle y los grupos (Iniciales) para el caso 99
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Noven,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero, 
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino


delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC noholdlock
	inner join #Clientes99 on Cli_Grupo = Clr_Grupo  


-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99  --
-- =============================================================== -- 

-- Recuperamos el numero de registros actualizados
 select @Num_Detalle = @@rowcount

-- Revisamos cuantos grupos se actualizaron en la tabla

insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_Caso 	 = @Ent_Noven
	  	 		 and Clr_TipCas  = @Ent_Dos 
				group by Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos


-- Registramos los detalles y grupos post actualizacion
update SOCICORE set Ccr_ClDeAc =  @Num_Detalle,
					Ccr_ClGrAc =  @Num_Grupos
	where Ccr_IdCaso = @Ent_Noven 
	  and Ccr_FecCla = @FechaSis


delete from #ClientesGrupos
where Cli_Grupo is not null
-- ========================================================================================= --
--  								CLASIFICACION 99 				 						 --
-- ========================================================================================= --


-- Son clientes que no tienen lineas virtuales
insert into #Clientes99SinL
select Clr_Grupo, SUM(Clr_CanLiv)
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	group by Clr_Grupo	
	having  SUM(Clr_CanLiv)= @Ent_Cero




-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 99   			 	 --
-- ================================================================================== --

-- sacamos el siguiente numero de registros detalles para los casos 99
select @Num_Detalle=count(*)
	from SOCLIREC noholdlock
	inner join #Clientes99SinL on Cli_Grupo = Clr_Grupo



insert into #ClientesGrupos
select Clr_Grupo
			from SOCLIREC noholdlock
				inner join #Clientes99SinL on Cli_Grupo = Clr_Grupo
				group by Clr_Grupo

select @Num_Grupos = count(*)
from #ClientesGrupos

-- Registramos los numero detalle y grupos
update  SOCICORE set Ccr_ClDeTo = Ccr_ClDeTo + @Num_Detalle,  
					 Ccr_ClGrTo = Ccr_ClGrTo + @Num_Grupos
where   Ccr_IdCaso = @Ent_Noven 
	and Ccr_FecCla = @FechaSis



delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC noholdlock
	inner join #Clientes99SinL on Cli_Grupo = Clr_Grupo  	

-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99  --
-- =============================================================== -- 

-- Sacamos los registros detalle afectados
   select @Num_Detalle = @@rowcount

-- Revisamos cuantos grupos se actualizaron en la tabla

Insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_Caso 	 = @Ent_Noven
	  	 		 and  Clr_TipCas = @Ent_Dos 
				group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos


-- Registramos los detalles y grupos post actualizacion
update SOCICORE set Ccr_ClDeAc =  Ccr_ClDeAc + @Num_Detalle,
					Ccr_ClGrAc =  Ccr_ClGrAc
	where Ccr_IdCaso = @Ent_Noven 
	  and Ccr_FecCla = @FechaSis


delete from #ClientesGrupos
where Cli_Grupo is not null

-- ========================================================================================= --
--  								CLASIFICACION 101 				 						 --
-- ========================================================================================= --

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
	

-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 101   			 	 --
-- ================================================================================== --

-- Sacamos el detalle inicial para el caso 101

select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
		inner join #Clientes101 Uno on Uno.Cli_Grupo = Clr_Grupo
		left join  #ClientesDosUsu Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
		where Dos.Cli_Grupo is null



insert into #ClientesGrupos
select Clr_Grupo
		from SOCLIREC noholdlock
		inner join #Clientes101 Uno on Uno.Cli_Grupo = Clr_Grupo
		left join  #ClientesDosUsu Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
		where Dos.Cli_Grupo is null
		group by Clr_Grupo

select @Num_Grupos = count(*)
from #ClientesGrupos

-- Insertamos el detalle y los grupos (Iniciales) para el caso 101
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_CieUno,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino	

delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_CieUno
	from SOCLIREC noholdlock
	inner join #Clientes101 Uno on Uno.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsu Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
	where Dos.Cli_Grupo is null

	
-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 101  --
-- =============================================================== -- 


-- Recuperamos el numero de registros afectados 
select @Num_Detalle = @@rowcount



insert into #ClientesGrupos
select Clr_Grupo
			from SOCLIREC noholdlock
			where Clr_Caso   = @Ent_CieUno
			 and  Clr_TipCas = @Ent_Dos
			 group by Clr_Grupo

select @Num_Grupos = count(*)
from #ClientesGrupos

-- Registramos los detalles y grupos post actualizacion
update SOCICORE set Ccr_ClDeAc =  @Num_Detalle,
					Ccr_ClGrAc =  @Num_Grupos
	where Ccr_IdCaso = @Ent_CieUno
	  and Ccr_FecCla = @FechaSis

delete from #ClientesGrupos
where Cli_Grupo is not null

-- ========================================================================================= --
--  								CLASIFICACION 102 										 --
-- ========================================================================================= -- 

								
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
	
-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 99   			 	 --
-- ================================================================================== --

-- 						existe una clasificacion previa para el caso 99					---

-- Sacamos los datos iniciales detalle para el nuevo bloque 99

	select @Num_Detalle = count(*)
		from SOCLIREC noholdlock
		inner join #ClientesDosUsu102 Cli	on Cli.Cli_Grupo = Clr_Grupo
		left join #ClientesDosUsuProRec Rec on Rec.Cli_Grupo = Cli.Cli_Grupo
		where Rec.Cli_Grupo is null


-- Sacamos los datos detalles Iniciales para el nuevo bloque 99
insert into #ClientesGrupos
select Clr_Grupo
	from SOCLIREC noholdlock
	inner join #ClientesDosUsu102 Cli	on Cli.Cli_Grupo = Clr_Grupo
	left join #ClientesDosUsuProRec Rec on Rec.Cli_Grupo = Cli.Cli_Grupo
	where Rec.Cli_Grupo is null
	group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos


-- registramos los datos esperados para el nuevo bloque 99
update SOCICORE set Ccr_ClDeTo =  Ccr_ClDeTo + @Num_Detalle,
					Ccr_ClGrTo =  Ccr_ClGrTo + @Num_Grupos
	where Ccr_IdCaso = @Ent_Noven 
	  and Ccr_FecCla = @FechaSis 



delete from #ClientesGrupos
where Cli_Grupo is not null

	
update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC 
	inner join #ClientesDosUsu102 Cli on Cli.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsuProRec Rec on Rec.Cli_Grupo = Cli.Cli_Grupo
	where Rec.Cli_Grupo is null 
	
-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99  --
-- =============================================================== -- 

-- vamos con los registros afectados en el update
select @Num_Detalle = @@rowcount

-- vamos por los registros de los grupos resultantes

insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_Caso = @Ent_Noven
				  and  Clr_TipCas = @Ent_Dos
				group by Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos

-- Registramos los valores post update	
update SOCICORE set Ccr_ClDeAc =  Ccr_ClDeAc + @Num_Detalle,
					Ccr_ClGrAc =  @Num_Grupos
	where Ccr_IdCaso = @Ent_Noven
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 102   			 	 --
-- ================================================================================== --


-- sacamos el detalle inicial para el caso 102
select @Num_Detalle = count(*)
   from SOCLIREC noholdlock
	inner join #ClientesDosUsuProRec on Cli_Grupo = Clr_Grupo


-- sacamos el grupo inicial para el caso 102

insert into #ClientesGrupos
select Clr_Grupo 
			   from SOCLIREC noholdlock
				inner join #ClientesDosUsuProRec on Cli_Grupo = Clr_Grupo
				group by Clr_Grupo


select @Num_Grupos = count(*)
    from #ClientesGrupos

-- inseramos los datos del 102
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_CieDos,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null


update SOCLIREC set
Clr_Caso = @Ent_CieDos
	from SOCLIREC noholdlock
	inner join #ClientesDosUsuProRec on Cli_Grupo = Clr_Grupo


-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 102  --
-- =============================================================== -- 

-- vamos por la informacion detalle de los registros afectamos por el upodate del 102
select @Num_Detalle = @@rowcount


-- vamos por los registros de los grupos resultantes

insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_Caso = @Ent_CieDos
				  and  Clr_TipCas = @Ent_Dos
				group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos
	
-- Registramos los valores post update para el 102	
update SOCICORE set Ccr_ClDeAc = @Num_Detalle,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_IdCaso = @Ent_CieDos
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ========================================================================================= --
--  								CLASIFICACION 103				 --
-- ========================================================================================= --

--103
insert into #Clientes103
select Clr_Grupo
	from SOCLIREC noholdlock
	where Clr_TipCas =@Ent_Dos 
	  and Clr_Caso = @Ent_Cien
	  and Clr_CueAct =@Ent_Cero
	group by Clr_Grupo	
	order by Clr_Grupo	

-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, caso 103   			 	 --
-- ================================================================================== --

-- sacamos los registros detalle iniciales para el caso 103

select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
	inner join #Clientes103 on Cli_Grupo = Clr_Grupo

-- Sacmaos los registros grupo iniciales para el caso 103

insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock
				inner join #Clientes103 on Cli_Grupo = Clr_Grupo
				group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos 

-- inseramos los datos del 103
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_CieTre,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_CieTre
	from SOCLIREC noholdlock
	inner join #Clientes103 on Cli_Grupo = Clr_Grupo
	
-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 102  --
-- =============================================================== --


-- vamos por los dealles afectados 
select @Num_Detalle = @@rowcount

-- vamos por los registros de los grupos resultantes

insert into #ClientesGrupos
select Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_Caso = @Ent_CieTre
				  and  Clr_TipCas = @Ent_Dos
				group by Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos
	
-- Registramos los valores post update para el 103	
update SOCICORE set Ccr_ClDeAc = @Num_Detalle  ,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_IdCaso = @Ent_CieTre
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 2 caso 100 Final		 --
-- ================================================================================== --

select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
	where  Clr_TipCas = @Ent_Dos
		and  Clr_Caso   = @Ent_Cien

insert into #ClientesGrupos
select Clr_Grupo
			  from SOCLIREC noholdlock
			  where  Clr_TipCas = @Ent_Dos
			    and  Clr_Caso   = @Ent_Cien
				group by Clr_Grupo


select  @Num_Grupos = count(*) 
	from #ClientesGrupos


-- Se registra los conteos antes del update
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cien,	@Ent_Dos,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null

drop table  #ClientesConUsrSinL, #Clientes101,
		 	#ClientesDosUsu102, #Clientes103,#ClientesDosUsuProRec,
			#ClientesDosUsu, #Clientes99SinL,	#Clientes99


	

-------------------------------------------------------------------------
-- Tipo caso 3
-- ========================================================================================= --
--  								CLASIFICACION TIPO CASO 3						 				 --
-- ========================================================================================= -- 
insert into #ConLinCredit
select distinct Clr_Grupo
from SOCLIREC noholdlock
where Clr_CaLiCr != @Ent_Cero
and Clr_LinVir != @Str_Vacio
and Clr_TipCas in (@Ent_Tres,@Ent_Cuatro)
and Clr_TipPer = @Tip_PePFAE


-- ================================================================================== --
-- 						Sacamos los totales detalle y grupo, tipo caso 3		 	 --
-- ================================================================================== -- 
-- vamos por el detalle 
select @Num_Detalle = count(*)
	from SOCLIREC noholdlock 
	where Clr_TipCas =@Ent_Tres
    


-- vamos por los grupos

insert into #ClientesGrupos
select  Clr_Grupo
				from SOCLIREC noholdlock 
				where Clr_TipCas =@Ent_Tres
				group by Clr_Grupo

select @Num_Grupos = count(*)
  from #ClientesGrupos
 

-- Guardamos el conteo inicial de los registros para el tipo caso 3

insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cero,	@Ent_Tres,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 3 caso 99 	 --
-- ================================================================================== -- 

-- Sin linea de credito

-- vamos por el detalle para el caso 99 del tipo caso 3
select @Num_Detalle = count(*)
   from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas =@Ent_Tres
      and b.Clr_Grupo is null

-- vampos por los grupos  para el caso 99 del tipo 3

insert into #ClientesGrupos
select 	a.Clr_Grupo
			from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
			where Clr_TipCas =@Ent_Tres
			and b.Clr_Grupo is null
			group by a.Clr_Grupo

select @Num_Grupos = count(*)
  from #ClientesGrupos


-- Se registra los conteos antes del update
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Noven,	@Ent_Tres,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino


delete from #ClientesGrupos
where Cli_Grupo is not null

-- se actualiza la informacion para los casos 99 del tipo 3
update SOCLIREC set Clr_Caso=@Ent_Noven
from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
where Clr_TipCas = @Ent_Tres
and b.Clr_Grupo is null


-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99  --
-- =============================================================== --


-- recuperamos el numero detalle de registros afectados
select @Num_Detalle = @@rowcount


-- Vamos por el numero de grupos afectados en el update

insert into  #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock
			   where Clr_TipCas = @Ent_Tres
			     and Clr_Caso   = @Ent_Noven
				 group by Clr_Grupo


select @Num_Grupos = count(*)
   from  #ClientesGrupos

update SOCICORE set Ccr_ClDeAc = @Num_Detalle  ,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_TipCas = @Ent_Tres
	  and Ccr_IdCaso   = @Ent_Noven
	  and Ccr_FecCla = @FechaSis 

delete from  #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 3 caso 99 	 --
-- ================================================================================== -- 

-- Con linea de credito


-- vamos por el detalle para el caso 99 del tipo caso 3
select @Num_Detalle = count(*)
   from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas = @Ent_Tres

-- vampos por los grupos  para el caso 99 del tipo 3


insert into #ClientesGrupos
select 	a.Clr_Grupo
			from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
			where Clr_TipCas =@Ent_Tres
			group by a.Clr_Grupo


select @Num_Grupos = count(*)
  from #ClientesGrupos

-- Se registra los conteos antes del update

update SOCICORE set Ccr_ClDeAc = Ccr_ClDeAc + @Num_Detalle  ,
					Ccr_ClGrAc = Ccr_ClGrAc + @Num_Grupos 
	where Ccr_TipCas = @Ent_Tres
	  and Ccr_IdCaso   = @Ent_Noven
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null

-- se actualiza la informacion para los casos 99 del tipo 3
update SOCLIREC set Clr_Caso=@Ent_Noven
from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
where Clr_TipCas = @Ent_Tres

-- =============================================================== --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99  --
-- =============================================================== --


-- recuperamos el numero detalle de registros afectados
select @Num_Detalle = @@rowcount


-- Vamos por el numero de grupos afectados en el update

insert into #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock
			   where Clr_TipCas = @Ent_Tres
	  			 and Clr_Caso   = @Ent_Noven
				 group by Clr_Grupo

select @Num_Grupos = count(*)
   from #ClientesGrupos

update SOCICORE set Ccr_ClDeAc = Ccr_ClDeAc + @Num_Detalle  ,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_TipCas = @Ent_Tres
	  and Ccr_IdCaso   = @Ent_Noven
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null

-- ========================================================================================= --
--  								CLASIFICACION  TIPO CASO 4			 				 --
-- ========================================================================================= -- 



-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 	 --
-- ================================================================================== -- 

-- Vamos por el detalle de clientes para el caso 99 del tipo caso 4
 
select @Num_Detalle = count(*)
	from SOCLIREC noholdlock 
	where Clr_TipCas =@Ent_Cuatro



-- vamos por los grupos

insert into #ClientesGrupos
select  Clr_Grupo
				from SOCLIREC noholdlock
				where Clr_TipCas =@Ent_Cuatro
				group by Clr_Grupo

select @Num_Grupos = count(*)
  from #ClientesGrupos
 

-- Guardamos el conteo inicial de los registros para el tipo caso 4

insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cero,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null


-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 99 PFAE	 --
-- ================================================================================== -- 

-- Sin Linea de credito

-- vamos por el detalle para el caso 99 del tipo caso 4
select @Num_Detalle = count(*)
   from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas = @Ent_Cuatro
	  and Clr_TipPer = @Tip_PePFAE
      and b.Clr_Grupo is null

-- vampos por los grupos  para el caso 99 del tipo 4

insert into #ClientesGrupos
select 	a.Clr_Grupo
			from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
			where Clr_TipCas = @Ent_Cuatro
			and Clr_TipPer = @Tip_PePFAE
			and b.Clr_Grupo is null
			group by a.Clr_Grupo


select @Num_Grupos = count(*)
  from #ClientesGrupos

-- Se registra los conteos antes del update
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Noven,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino


delete from #ClientesGrupos
where Cli_Grupo is not null


-- se actualiza la informacion para los casos 99 del tipo 4
update SOCLIREC set Clr_Caso=@Ent_Noven
from SOCLIREC  a noholdlock left join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
where Clr_TipCas = @Ent_Cuatro
and Clr_TipPer = @Tip_PePFAE
and b.Clr_Grupo is null

-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99 tipo 4  --
-- ======================================================================= --

-- recuperamos el numero detalle de registros afectados
select @Num_Detalle = @@rowcount


-- Vamos por el numero de grupos afectados en el update

insert into #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock
			   where Clr_TipCas =@Ent_Cuatro
			     and Clr_Caso   = @Ent_Noven
				 group by Clr_Grupo

select @Num_Grupos = count(*)
   from #ClientesGrupos


update SOCICORE set Ccr_ClDeAc = @Num_Detalle  ,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_IdCaso = @Ent_Noven
	  and Ccr_TipCas = @Ent_Cuatro
	  and Ccr_FecCla = @FechaSis 

delete from #ClientesGrupos
where Cli_Grupo is not null

-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 99	 --
-- ================================================================================== -- 

-- Con Linea de credito


-- vamos por el detalle para el caso 99 del tipo caso 4
select @Num_Detalle = count(*)
   from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
	where Clr_TipCas = @Ent_Cuatro
	  and Clr_TipPer = @Tip_PePFAE

-- vampos por los grupos  para el caso 99 del tipo 4

insert into #ClientesGrupos
select 	a.Clr_Grupo
			from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
			where Clr_TipCas = @Ent_Cuatro
			  and Clr_TipPer = @Tip_PePFAE
			group by a.Clr_Grupo

select @Num_Grupos = count(*)
  from #ClientesGrupos

-- Se registra los conteos antes del update
update SOCICORE set Ccr_ClDeTo = Ccr_ClDeTo + @Num_Detalle  ,
					Ccr_ClGrTo = Ccr_ClGrTo + @Num_Grupos 
	where Ccr_IdCaso = @Ent_Noven
	  and Ccr_TipCas = @Ent_Cuatro
	  and Ccr_FecCla = @FechaSis 


delete from #ClientesGrupos
where Cli_Grupo is not null

-- se actualiza la informacion para los casos 99 del tipo 4
update SOCLIREC set Clr_Caso=@Ent_Noven
from SOCLIREC  a noholdlock inner join #ConLinCredit b on a.Clr_Grupo=b.Clr_Grupo
where Clr_TipCas = @Ent_Cuatro
and Clr_TipPer = @Tip_PePFAE

-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99 tipo 4  --
-- ======================================================================= --


-- recuperamos el numero detalle de registros afectados
select @Num_Detalle = @@rowcount


-- Vamos por el numero de grupos afectados en el update

insert into #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock
			   where Clr_TipCas = @Ent_Cuatro
			     and Clr_Caso   = @Ent_Noven
				 group by Clr_Grupo

select @Num_Grupos = count(*)
   from  #ClientesGrupos

update SOCICORE set Ccr_ClDeAc = Ccr_ClDeAc + @Num_Detalle  ,
					Ccr_ClGrAc = @Num_Grupos 
	where Ccr_IdCaso = @Ent_Noven
	  and Ccr_TipCas = @Ent_Cuatro
	  and Ccr_FecCla = @FechaSis 

delete from  #ClientesGrupos
where Cli_Grupo is not null

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



-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 100			 --
-- ================================================================================== -- 

-- vamos por el detalle 
select @Num_Detalle = count(*)
   from SOCLIREC Soc noholdlock 
   inner join #ClientesConUsrSinLin4  Cli	on Cli.Clr_Grupo = Soc.Clr_Grupo
											and Soc.Clr_TipPer = @Tip_PersPF

-- Vamos por el grupo

insert into  #ClientesGrupos
select Soc.Clr_Grupo
	from SOCLIREC Soc noholdlock 
	inner join #ClientesConUsrSinLin4  Cli	on Cli.Clr_Grupo = Soc.Clr_Grupo
											and Soc.Clr_TipPer = @Tip_PersPF
	GROUP BY Soc.Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos



-- Se registra los conteos antes del update
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cien,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero, 	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_Cien
	from SOCLIREC Soc noholdlock 
	inner join #ClientesConUsrSinLin4 Cli on Cli.Clr_Grupo = Soc.Clr_Grupo
	and Soc.Clr_TipPer = @Tip_PersPF

-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 100 tipo 4  --
-- ======================================================================= --

-- vamos por los registros detalle afectados por el update
select @Num_Detalle = @@rowcount


-- Vamos por los registros grupos afectados por el update

insert into #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock	
			   Where Clr_Caso   = @Ent_Cien
			    and  Clr_TipCas = @Ent_Cuatro
				group by Clr_Grupo

select @Num_Grupos=count(*)
   from  #ClientesGrupos


-- Guardamos la informacion de los conteos post update
update SOCICORE set Ccr_ClDeAc =  @Num_Detalle  ,
					Ccr_ClGrAc =  @Num_Grupos 
	where Ccr_IdCaso = @Ent_Cien
	  and Ccr_TipCas = @Ent_Cuatro
	  and Ccr_FecCla = @FechaSis  

delete from  #ClientesGrupos
where Cli_Grupo is not null

-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 99			 --
-- ================================================================================== --


-- vamos por el detalle antes del update para el caso 99 del tipo caso 4
	
select @Num_Detalle = count(*)
   from SOCLIREC Soc noholdlock 
   left join #ClientesConUsrSinLin4 Cli	on Cli.Clr_Grupo = Soc.Clr_Grupo
	where Soc.Clr_TipCas = @Ent_Cuatro
	  and Soc.Clr_TipPer = @Tip_PersPF 
	  and Cli.Clr_Grupo is null
	
	
-- Vamos por el grupo antes el update para el caso 99 del tipo caso 4
				
insert into  #ClientesGrupos
select Soc.Clr_Grupo
	from SOCLIREC Soc noholdlock
	left join #ClientesConUsrSinLin4 Cli	on Cli.Clr_Grupo = Soc.Clr_Grupo	
	where Soc.Clr_TipCas = @Ent_Cuatro
	  and Soc.Clr_TipPer = @Tip_PersPF
	  and Cli.Clr_Grupo is null
	
	group by Soc.Clr_Grupo
				
select @Num_Grupos = count(*)
   from #ClientesGrupos

-- guardamos los registros esperados
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Noven,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null

-- mandamos a 99 los que no tiene problemas	

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC Soc noholdlock 
	left join #ClientesConUsrSinLin4 Cli	on Cli.Clr_Grupo = Soc.Clr_Grupo
	where Soc.Clr_TipCas = @Ent_Cuatro
	  and Soc.Clr_TipPer = @Tip_PersPF
	  and Cli.Clr_Grupo is null

-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99 tipo 4  --
-- ======================================================================= --

-- vamos por los registros afectados por el update
select @Num_Detalle = @@rowcount


-- vamos por los registros grupos afectados por el update

insert into #ClientesGrupos
select Clr_Grupo
			  from SOCLIREC noholdlock
			  where  Clr_TipCas = @Ent_Cuatro
			    and  Clr_Caso   = @Ent_Noven
				and  Clr_TipPer = @Tip_PersPF
				group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos


-- vamos por el id del registro
 select @Ccr_numero =  max(Ccr_Numero)
    from SOCICORE noholdlock
	where Ccr_IdCaso = @Ent_Noven
	  and Ccr_TipCas = @Ent_Cuatro
	  and Ccr_FecCla = @FechaSis 

update SOCICORE set Ccr_ClDeAc =  @Num_Detalle  ,
					Ccr_ClGrAc =  @Num_Grupos 
	where Ccr_Numero = @Ccr_numero

delete from #ClientesGrupos
where Cli_Grupo is not null


-- Clientes que no tienen lineas de credito ni cuentas que generan recompensas NADA QUE HACER
insert into #Clientes499
select tmp.Clr_Grupo, SUM(Clr_CaCuRe), sum(Clr_CaLiCr) 
	from #ClientesConUsrSinLin4 tmp
	inner join SOCLIREC Soc noholdlock 	on Soc.Clr_Grupo	= tmp.Clr_Grupo
										and Clr_TipCas		= @Ent_Cuatro 
	group by tmp.Clr_Grupo	
	having sum(Clr_CaCuRe)= @Ent_Cero  and sum(Clr_CaLiCr) = @Ent_Cero
	order by tmp.Clr_Grupo	


-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 99			 --
-- ================================================================================== --

-- vamos por el detalle antes del update para los registros del caso 99 para el tipo caso 4
select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
	inner join #Clientes499 on Cli_Grupo = Clr_Grupo  
	where  Clr_TipPer = @Tip_PersPF

-- vamos por el grupo antes del update para los registros del caso 99 para el tipo de caso 4

insert into #ClientesGrupos
select Clr_Grupo
			from SOCLIREC noholdlock
			inner join #Clientes499 on Cli_Grupo = Clr_Grupo  
			where  Clr_TipPer = @Tip_PersPF
			group by Clr_Grupo

select @Num_Grupos = count(*)
	from #ClientesGrupos

-- Guardamos el conteo antes del update

update SOCICORE set Ccr_ClDeTo = Ccr_ClDeTo + @Num_Detalle  ,
					Ccr_ClGrTo = Ccr_ClGrTo + @Num_Grupos 
	where Ccr_Numero = @Ccr_numero


delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_Noven
	from SOCLIREC noholdlock
	inner join #Clientes499 on Cli_Grupo = Clr_Grupo  
	where  Clr_TipPer = @Tip_PersPF
 


-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 99 tipo 4  --
-- ======================================================================= --


-- vamos por los registros detalle afectados por el update
select @Num_Detalle = @@rowcount



-- vamos por los registros del grupo afectados por el update

insert into #ClientesGrupos
select Clr_Grupo
			   from SOCLIREC noholdlock 
			   WHERE Clr_TipCas = @Ent_Cuatro
			      and Clr_Caso  = @Ent_Noven
				  and Clr_TipPer = @Tip_PersPF
				group by Clr_Grupo


select @Num_Grupos = count(*)
  from #ClientesGrupos


update SOCICORE set Ccr_ClDeAc = Ccr_ClDeAc + @Num_Detalle  ,
					Ccr_ClGrAc =  @Num_Grupos 
 where Ccr_Numero = @Ccr_numero

delete from #ClientesGrupos
where Cli_Grupo is not null

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
	

insert into #Grupos200
select  Clr_Grupo 
	from SOCLIREC noholdlock
	where Clr_Caso in(  @Ent_Cien,@Ent_CieTre )
	and (Clr_CreAct =  @Ent_Uno or Clr_CrABAc = @Ent_Uno or Clr_CrCCAc = @Ent_Uno )


-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo,  caso 200			 --
-- ================================================================================== --


-- vamos por el detalle antes del update para el caso 200 del tipo caso 2
select @Num_Detalle = count(*)
   from SOCLIREC noholdlock
inner join #Grupos200 on Cli_Grupo = Clr_Grupo

-- Vamos por el grupo antes el update para el caso 99 del tipo caso 4

insert into  #ClientesGrupos
select Clr_Grupo
	from SOCLIREC noholdlock
inner join #Grupos200 on Cli_Grupo = Clr_Grupo
				group by Clr_Grupo


select @Num_Grupos = count(*)
   from #ClientesGrupos

-- guardamos los registros esperados
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Doscie,	@Ent_Cero,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino


delete from #ClientesGrupos
where Cli_Grupo is not null


update SOCLIREC set
Clr_Caso = @Ent_Doscie
from SOCLIREC noholdlock
inner join #Grupos200 on Cli_Grupo = Clr_Grupo



-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 200  --
-- ======================================================================= --


-- vamos por los registros detalle afectados por el update
select @Num_Detalle = @@rowcount



-- vamos por los registros del grupo afectados por el update

insert into #ClientesGrupos
	select Clr_Grupo
		from SOCLIREC  noholdlock
		WHERE Clr_Caso  = @Ent_Doscie
		group by Clr_Grupo


select @Num_Grupos = count(*)
  from #ClientesGrupos


update SOCICORE set Ccr_ClDeAc = @Num_Detalle  ,
					Ccr_ClGrAc =  @Num_Grupos 
 where Ccr_IdCaso = @Ent_Doscie
	and Ccr_FecCla = @FechaSis	

	
delete from #ClientesGrupos
where Cli_Grupo is not null
	
-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 101			 --
-- ================================================================================== --
	
	
-- vamos por los detalles antes del update

select @Num_Detalle = count(*)
	from SOCLIREC Soc noholdlock
	inner join #Clientes1014 Uno on Uno.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsu4 Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
	where Dos.Cli_Grupo is null
	   and Clr_TipPer = @Tip_PersPF

insert into #ClientesGrupos
select Clr_Grupo	
				from SOCLIREC noholdlock
				inner join #Clientes1014 Uno on Uno.Cli_Grupo = Clr_Grupo
				left join  #ClientesDosUsu4 Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
				where Dos.Cli_Grupo is null
	   			and Clr_TipPer = @Tip_PersPF
				group by Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos

 

-- Se registra los conteos antes del update
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_CieUno,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null

update SOCLIREC set
Clr_Caso = @Ent_CieUno
	from SOCLIREC noholdlock 
	inner join #Clientes1014 Uno on Uno.Cli_Grupo = Clr_Grupo
	left join  #ClientesDosUsu4 Dos on Dos.Cli_Grupo = Uno.Cli_Grupo
	where Dos.Cli_Grupo is null
	   and Clr_TipPer =@Tip_PersPF

-- ======================================================================= --
-- Guardamos  detalle y grupo despues de la actualizacion caso 101 tipo 4  --
-- ======================================================================= --

-- vamos por los registros actualizados 
select  @Num_Detalle = @@rowcount



-- vamos por los registros 

insert into #ClientesGrupos
select Clr_Grupo
			from SOCLIREC noholdlock
			where Clr_Caso   = @Ent_CieUno
			  and Clr_TipCas = @Ent_Cuatro
			  and Clr_TipPer = @Tip_PersPF
			  group by Clr_Grupo


select @Num_Grupos = count(*)
	from #ClientesGrupos


update SOCICORE set Ccr_ClDeAc = @Num_Detalle,
					Ccr_ClGrAc = @Num_Grupos
where Ccr_IdCaso = @Ent_CieUno
  and Ccr_TipCas = @Ent_Cuatro
  and Ccr_FecCla = @FechaSis

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 				Sacamos los totales detalle y grupo, tipo caso 4 caso 100 Final		 --
-- ================================================================================== --

select @Num_Detalle = count(*)
	from SOCLIREC noholdlock
	where  Clr_TipCas = @Ent_Cuatro
		and  Clr_Caso   = @Ent_Cien
		and  Clr_TipPer = @Tip_PersPF

insert into #ClientesGrupos
select Clr_Grupo
			  from SOCLIREC noholdlock
			  where  Clr_TipCas = @Ent_Cuatro
			    and  Clr_Caso   = @Ent_Cien
				and  Clr_TipPer = @Tip_PersPF
				group by Clr_Grupo

select  @Num_Grupos = count(*) 
	from #ClientesGrupos


-- Se registra los conteos Finales para saber como acabo el caso 100
insert into SOCICORE 
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cien,	@Ent_Cuatro,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,		@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,		@SucDestino

delete from #ClientesGrupos
where Cli_Grupo is not null
-- ================================================================================== --
-- 						Sacamos los totales Final detalle y grupo General			  --
-- ================================================================================== --

-- Sacamos el detalle inicial 
select  @Num_Detalle = count(*)
	from  SOCLIREC noholdlock 
	where Clr_Caso = @Ent_Cero


-- Sacamos el numero inicial de grupo

insert into #ClientesGrupos
select Clr_Grupo
		  from SOCLIREC noholdlock 
		  where Clr_Caso = @Ent_Cero
		  group by Clr_Grupo


select  @Num_Grupos = count(*)
from #ClientesGrupos


-- Insertamos el detalle y los grupos (Iniciales) para el caso 100
insert into SOCICORE
		(Ccr_IdCaso, 	Ccr_TipCas, Ccr_ClDeTo, Ccr_ClGrTo, 
		Ccr_ClDeAc,		Ccr_ClGrAc, Ccr_FecCla, NumTransac, 
		Transaccio,		Usuario,	FechaSis,	SucOrigen,
		SucDestino)
select @Ent_Cero,	@Ent_Cero,	@Num_Detalle,	@Num_Grupos,	@Ent_Cero,
	   @Ent_Cero,	@FechaSis,	@NumTransac,	@Transaccio,	@Usuario,
	   @FechaSis,	@SucOrigen,	@SucDestino


drop table	#ClientesConUsrSinLin4,	#Clientes499,	#Clientes1014,	#ClientesDosUsu4, #ClientesGrupos,
			#Grupos200
		

	 