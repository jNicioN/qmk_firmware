create procedure SOVISIBIPRO (
	@Vis_Usuari	char(6),
	@Vis_Nivel	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Definicion de Constantes	*/
declare @Str_Depend char(8),
		@Str_PorDep char(1),
		@Str_PorRel char(1),
		@Str_Vacio	char(1),
		@Int_TipRel	int,
		@Int_Uno	int

select	@Str_Depend = '00000000',	/* Relacion de Dependencia */
		@Str_PorDep = 'D',			/* Por Dependencia */
		@Str_PorRel = 'R',			/* Por Relacion */
		@Str_Vacio	= '',
		@Int_TipRel = 0,
		@Int_Uno	= 1

declare @Status int, /* Declaracion de Variables */
		@Tab_Nombre char(8),
		@Fol_Numero int,
		@Vis_Numero	char(8)

select @Tab_Nombre = 'SOVISIBI'
select @Fol_Numero = 0
select @Vis_Numero = '00000000'

execute @Status 	= GCFOLIOSACT
		@Fol_Tabla 	= @Tab_Nombre,
		@Fol_Numero = @Fol_Numero output

select @Vis_Numero = convert(char(8), @Fol_Numero)

exec UTCERIZQ
	@Valor = @Vis_Numero output,
	@Longitud = 8

/*	1. Se inserta el Login 	*/
insert into SOVISIBI	
	select 	@Vis_Numero,	Est_Numero,		Est_Usuari,	 	Est_Serial,
			@Str_PorDep,	Est_Nivel,		@Int_TipRel,	@NumTransac, 	
			@Transaccio,	@Usuario, 		@FechaSis,		@SucOrigen, 	
			@SucDestino
	  from	SOESTRUC noholdlock
	 where 	Est_Usuari = @Vis_Usuari
		
/*	2. Insertar Los que dependen del login 	*/
select @Int_TipRel = @Int_TipRel + 1 
while  exists( select Rel_Estruc
				from 	SORELEST rel noholdlock,
						SOESTRUC est noholdlock
				where 	Rel_Estruc	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
 				and		Rel_Relaci 	= @Str_Depend 
				and 	Rel_Estruc	= Est_Numero 
				and 	Rel_Estruc	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero ) )  
				
	begin
		insert into SOVISIBI	
			select	@Vis_Numero,	Rel_Estruc,		Est_Usuari,	 	Est_Serial,
					@Str_PorDep,	Est_Nivel,		@Int_TipRel,	@NumTransac, 	
					@Transaccio,	@Usuario, 		@FechaSis,		@SucOrigen, 	
					@SucDestino
			from 	SORELEST rel noholdlock,
					SOESTRUC est noholdlock
			where 	Rel_EstRel	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
			and		Rel_Relaci 	= @Str_Depend
			and 	Rel_Estruc	= Est_Numero
			and 	Rel_Estruc	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero) 
		select @Int_TipRel = @Int_TipRel + 1 
	end

/*	3. Insertar Los relacionados que dependen del login 	*/
select @Int_TipRel = 1000
while  exists( select Rel_EstRel
				from 	SORELEST rel noholdlock,
						SOESTRUC est noholdlock
				where 	Rel_Estruc	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
			 	and		Rel_Relaci 	!= @Str_Depend
				and		Rel_EstRel	= Est_Numero 
				and		Rel_EstRel	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero) ) 
	begin
		insert into SOVISIBI	
			select	@Vis_Numero,	Rel_EstRel,		Est_Usuari,		Est_Serial,
					@Str_PorRel,	Est_Nivel,		@Int_TipRel,	@NumTransac, 	
					@Transaccio,	@Usuario, 		@FechaSis,		@SucOrigen, 	
					@SucDestino
			from 	SORELEST rel noholdlock,
					SOESTRUC est noholdlock
			where 	Rel_Estruc	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
		 	and		Rel_Relaci 	!= @Str_Depend
			and 	Rel_EstRel	= Est_Numero
			and 	Rel_EstRel	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero) 
		select @Int_TipRel = @Int_TipRel + 1 
	end

/*	4. Insertar Los que dependen del los relacionados 	*/
select @Int_TipRel = 2000
while  exists( select Rel_Estruc
				from 	SORELEST rel noholdlock,
						SOESTRUC est noholdlock
				where 	Rel_EstRel	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
 				and		Rel_Relaci 	= @Str_Depend
				and 	Rel_Estruc	= Est_Numero 
				and 	Rel_Estruc	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero) ) 
	begin
		insert into SOVISIBI		
			select	@Vis_Numero,	Rel_Estruc,		Est_Usuari,		Est_Serial,
					@Str_PorRel,	Est_Nivel,		@Int_TipRel,	@NumTransac, 	
					@Transaccio,	@Usuario, 		@FechaSis,		@SucOrigen, 	
					@SucDestino
			from 	SORELEST rel noholdlock,
					SOESTRUC est noholdlock
			where 	Rel_EstRel	in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero)
		 	and		Rel_Relaci 	= @Str_Depend
			and 	Rel_Estruc	= Est_Numero
			and 	Rel_Estruc	not in (select Vis_Estruc from SOVISIBI noholdlock  where Vis_Numero =  @Vis_Numero) 
		select @Int_TipRel = @Int_TipRel + 1 
	end


/* Cambiar un nivel de dependencia a si mismo */
/*
if @Vis_Nivel > 0 begin
	update SOVISIBI set Vis_Depend = Vis_Estruc
		where Vis_Numero =  @Vis_Numero
		  and Vis_Nivel =  @Int_Uno
end
	Cambiar dependencia a el jefe 
	while  exists( select Vis_Numero
					from 	SOVISIBI  noholdlock
					where Vis_Numero =  @Vis_Numero 
					 and  Vis_Nivel > @Vis_Nivel)
		update SOVISIBI set Vis_Depend = Est_Depend,
  				  		Vis_Nivel = Vis_Nivel - @Int_Uno
			from SOESTRUC noholdlock
    		where Vis_Numero =  @Vis_Numero
      		  and Vis_Nivel > @Vis_Nivel
		  	  and Est_Numero = Vis_Estruc
*/				 


select 	Err_Codigo = '000000',
		Err_Mensaj = 'Registro modificado',
		Vis_Numero = @Vis_Numero

