create procedure SOUSUPANCON (
	@Usu_Nombre	varchar(50),
	@Usu_Pantal	varchar(8),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3), 
	@Modulo char(2))

as
declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1)
		
declare @Str_Vacio	char(1)			/* Declaración de Constantes */

/* Asignacion de Constantes */
select	@Str_Vacio	= ''			/* String Vacio */
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin			/* 'C':  Consulta */
	if @Tip_ConCon = '1' begin		

		if @Usu_Nombre	= @Str_Vacio
			select	Usu_Nombre	= @Str_Vacio,
					Usu_Pantal	= @Str_Vacio,
					Usu_Clave	= @Str_Vacio,	
					Cant		= COUNT(*)
				from SOUSUPAN noholdlock
				where	Usu_Pantal	= @Usu_Pantal
		else/* Adaptive Server has expanded all '*' elements in the following statement */ 
			select	SOUSUPAN.Usu_Nombre, SOUSUPAN.Usu_Clave, SOUSUPAN.Usu_Pantal, SOUSUPAN.NumTransac, SOUSUPAN.Transaccio, SOUSUPAN.Usuario, SOUSUPAN.FechaSis, SOUSUPAN.SucOrigen, SOUSUPAN.SucDestino
				from SOUSUPAN noholdlock
				where	Usu_Nombre	= @Usu_Nombre
				  and	Usu_Pantal	= @Usu_Pantal
		  
	end else if @Tip_ConCon = '2' begin

		select	Usu_Nombre
			from SOUSUPAN noholdlock
			where 	Usu_Nombre like @Usu_Nombre
			  and 	Usu_Pantal	= @Usu_Pantal
			order by Usu_Nombre
		
	end
	
	if @Tip_ConCon = '3' begin
	 select pa.Usu_Nombre, pa.Usu_Pantal, us.Usu_PassWo
	   from SOUSUPAN pa	noholdlock,
	        SOUSUARI us	noholdlock
	  where pa.Usu_Nombre = @Usu_Nombre
	    and	pa.Usu_Pantal = @Usu_Pantal
	    and	pa.Usu_Nombre = us.Usu_Clave
	end
	
end	
if @Tip_ConTip = 'L' begin			/* 'L':  Lista */	
	if @Tip_ConCon = '1' begin		
	
		select Usu_Nombre, Pan_Modulo,	Pan_Grupo,Usu_Pantal
		  from SOUSUPAN noholdlock,
	  		   SAPANTAL noholdlock 
	  	  where  Usu_Pantal = Pan_Nombre
	 	  order by Usu_Nombre 	 
	 
	end	 

	
end
