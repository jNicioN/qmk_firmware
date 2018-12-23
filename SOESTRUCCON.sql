create procedure SOESTRUCCON(
	@Est_Numero	char(8),
	@Est_Nombre	char(60),
    @Usu_Clave Char(15),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Definicion de Constantes	*/
declare	@Str_PueSDi char(8),
		@Str_Admini char(8),
		@Int_Encont int,
		@Str_Vacio	varchar(1),
		@Int_Uno 	int,
		@Int_Diez 	int

select 	@Str_PueSDi	= '00000004',	/* Puesto de Sub-Director							*/
		@Str_Admini = '00000001',
		@Int_Encont = 999,			/* Bandera de si encontro al subdirector en la estructura */
		@Str_Vacio	= '',
		@Int_Uno 	= 1,
		@Int_Diez 	= 10

declare	@Tip_ConTip	char(1),		/* Variables para identificar el tipo de consulta */
		@Tip_ConCon	char(1),
		@Str_Estruc char(8),
		@Str_Puesto char(8),	
		@Int_i		int,
		@Str_AreAdm	char(160)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)


if @Tip_ConTip = 'L' begin					/* 'L':  Listas */
	if @Tip_ConCon = '1' begin
		create table #Serial (
			Num_Serial	char(160) null)
				
		insert into #Serial		
			select adm.Est_Serial
				from SOESTRUC est noholdlock,
					 SORELEST rel noholdlock,
					 SOESTRUC adm noholdlock
				where	est.Est_Usuari	= @Usuario
				  and	Rel_Estruc 		= est.Est_Numero
			  	  and   Rel_Relaci 		= @Str_Admini
			 	  and   Rel_EstRel 		= adm.Est_Numero
		
		update #Serial set
			Num_Serial = Num_Serial + '%'		
		 
		select	est.Est_Numero, 			est.Est_Nombre,				est.Est_Nivel,
				est.Est_Depend,				est.Est_Usuari,				est.Est_Raiz,				
				dep.Est_Nombre 	Est_NomEst,	dep.Est_Nombre Est_NomDep,	est.Est_Serial,
				usu.Usu_Nombre,
				(select count(Est_Numero) 
					from SOESTRUC ND noholdlock 
					where ND.Est_Depend = est.Est_Numero)  Est_NumDep
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu,
					#Serial
			where dep.Est_Numero =* est.Est_Depend
			  and usu.Usu_Numero =* est.Est_Usuari
			  and est.Est_Serial like Num_Serial
			  order by est.Est_Serial
			  
		drop table #Serial
	end 
	if @Tip_ConCon = '2' begin				
		select @Est_Nombre = rtrim(@Est_Nombre)
		select	Est_Numero,	Est_Nombre
	 		from	SOESTRUC noholdlock
	 		where 	Est_Nombre like @Est_Nombre 
			order by Est_Serial
	end 
	if @Tip_ConCon = '3' begin
		select @Est_Nombre = rtrim(@Est_Nombre)  + '%'
		select	est.Est_Numero, 			est.Est_Nombre,				est.Est_Nivel,
				est.Est_Depend,				est.Est_Usuari,				est.Est_Raiz,				
				dep.Est_Nombre 	Est_NomEst,	dep.Est_Nombre Est_NomDep,	est.Est_Serial,
				usu.Usu_Nombre,
				(select count(Est_Numero) from SOESTRUC ND noholdlock where ND.Est_Depend = est.Est_Numero)  Est_NumDep
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu
			where est.Est_Nombre like @Est_Nombre 
			  and dep.Est_Numero =* est.Est_Depend
			  and usu.Usu_Numero =* est.Est_Usuari
				order by est.Est_Serial
	end
       if @Tip_ConCon = '4' begin
		select @Est_Nombre = rtrim(@Est_Nombre)  + '%'
		select	rtrim(est.Est_Nombre) + ' - ' + ltrim(usu.Usu_Nombre) Est_NombreUsu,
		        est.Est_Numero, 			est.Est_Nombre,				est.Est_Nivel,
				est.Est_Depend,				est.Est_Usuari,				est.Est_Raiz,			
				dep.Est_Nombre 	Est_NomEst,	dep.Est_Nombre Est_NomDep,	est.Est_Serial,
				usu.Usu_Nombre,
				(select count(Est_Numero) from SOESTRUC ND noholdlock where ND.Est_Depend = est.Est_Numero)  Est_NumDep
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu
			where est.Est_Nombre like @Est_Nombre 
			  and dep.Est_Numero =* est.Est_Depend
			  and usu.Usu_Numero =* est.Est_Usuari
				order by est.Est_Serial
	end	
	if @Tip_ConCon = '5' begin				/*Lista Jefe Inmediato via Usu_Clave*/
		select @Usu_Clave = rtrim(@Usu_Clave) + '%'
		select	usu.Usu_Clave,	usu.Usu_Numero,	                usu.Usu_Nombre,
		       est.Est_Depend,	dus.Usu_Numero Dep_Numero,	dus.Usu_Nombre Dep_NOmbre
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu noholdlock,
					SOUSUARI dus noholdlock
			where usu.Usu_Clave like @Usu_Clave
			  and dep.Est_Numero = est.Est_Depend
			  and est.Est_Usuari = usu.Usu_Numero
			  and dep.Est_Usuari = dus.Usu_Numero
	end 		
end else if @Tip_ConTip = 'C' begin			/* 'C':  Consultas */
	if @Tip_ConCon = '1' begin				/* Nombre de la Structura */
		select	Est_Numero,	Est_Nombre
	 		from	SOESTRUC noholdlock
			where	Est_Numero	=	@Est_Numero
	end 
	if @Tip_ConCon = '2' begin				/* Informacion de la Estrucura */
		select	Est_Numero,	Est_Nombre,	Est_Usuari,	Est_Raiz,		
				Est_Puesto,	Usu_Nombre
	 		from	SOESTRUC noholdlock,
	 				SOUSUARI noholdlock
			where	Est_Numero	= @Est_Numero
		 	  and 	Usu_Numero  = Est_Usuari
	end 
	if @Tip_ConCon = '3' begin				/* Jefe Inmediato */
		select	usu.Usu_Numero, 			usu.Usu_Nombre,				est.Est_Depend,				
				dus.Usu_Numero Dep_Numero,	dus.Usu_Nombre Dep_NOmbre
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu noholdlock,
					SOUSUARI dus noholdlock
			where est.Est_Usuari = @Usuario
			  and dep.Est_Numero = est.Est_Depend
			  and est.Est_Usuari = usu.Usu_Numero
			  and dep.Est_Usuari = dus.Usu_Numero
	end 
	if @Tip_ConCon = '4' begin				/* SubDirector */
		select @Int_i = @Int_Uno
		while 	@Int_i < @Int_Diez 
			and exists( select	est.Est_Numero
					 		from 	SOESTRUC est noholdlock
							where 	est.Est_Usuari = @Usuario)
		begin
			select	@Str_Estruc=dep.Est_Numero, 	@Str_Puesto = dep.Est_Puesto,
					@Usuario=dep.Est_Usuari
 				from 	SOESTRUC est noholdlock,
						SOESTRUC dep noholdlock
				where	est.Est_Usuari =	@Usuario
			      and 	dep.Est_Numero =	est.Est_Depend
   			select @Int_i = @Int_i + @Int_Uno
   			if @Str_Puesto = @Str_PueSDi
		    	select @Int_i = @Int_Encont
		end
		if @Int_i = @Int_Encont
			select	usu.Usu_Numero,	usu.Usu_Nombre
	 			from SOESTRUC est noholdlock,
					 SOUSUARI usu noholdlock
				where est.Est_Numero  	= @Str_Estruc
				  and est.Est_Usuari	= usu.Usu_Numero
		else
			select	Usu_Nombre = @Str_Vacio
		end
        if @Tip_ConCon = '5' begin				/* Informacion de la Estrucura */
		select	Est_Numero,	Est_Nombre,	Est_Usuari,	Est_Raiz,		
				Est_Puesto,	Usu_Nombre, Est_Nivel, Usu_EMail, Pue_Nombre
	 		from	SOESTRUC noholdlock,
	 				SOUSUARI noholdlock,
	 				SOPUESTO noholdlock
			where 	Usu_Numero  = @Usuario
                and Est_Usuari = @Usuario
                and Est_Puesto = Pue_Numero
	end
        if @Tip_ConCon = '6' begin				/* Informacion de SOUSUARI via Usu_Clave*/
		select	Est_Numero,	Est_Nombre,	Est_Usuari,	Est_Raiz,		
				Est_Puesto,	Usu_Nombre, Est_Nivel, Usu_EMail, Pue_Nombre
	 		from	SOESTRUC noholdlock,
	 				SOUSUARI noholdlock,
	 				SOPUESTO noholdlock
			where 	Usu_Clave = @Usu_Clave 
			    and Usu_Numero = Est_Usuari
			    and Est_Puesto = Pue_Numero
	end
        if @Tip_ConCon = '7' begin				/* Jefe Inmediato via Usu_Clave*/
		select	usu.Usu_Numero, 			usu.Usu_Nombre,				est.Est_Depend,				
				dus.Usu_Numero Dep_Numero,	dus.Usu_Nombre Dep_NOmbre
	 		from	SOESTRUC est noholdlock,
					SOESTRUC dep noholdlock,
					SOUSUARI usu noholdlock,
					SOUSUARI dus noholdlock
			where usu.Usu_Clave = @Usu_Clave
			  and dep.Est_Numero = est.Est_Depend
			  and est.Est_Usuari = usu.Usu_Numero
			  and dep.Est_Usuari = dus.Usu_Numero
        end  
end
