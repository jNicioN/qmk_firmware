create procedure SORELACICON (
	@Rel_Numero	char(8),
	@Rel_Nombre	char(60),
	
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Str_Depend	char(8)
select	@Str_Depend = '00000000'	/* Depende de */

declare	@Tip_ConTip	char(1),	/* Variables para identificar el tipo de consulta */
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin					/* 'C':  Consultas */

	if @Tip_ConCon = '1' begin				/* Consulta por Llave */	
		select Rel_Numero,	Rel_Nombre
		from SORELACI	noholdlock
		where Rel_Numero	= @Rel_Numero
	end 
	
end
if @Tip_ConTip = 'L' begin					/* 'L':  Listas */

	if @Tip_ConCon = '1' begin				/* Lista de Estatus */	
		select Rel_Numero,	Rel_Nombre
		from SORELACI noholdlock
		where Rel_Numero != @Str_Depend
		order by Rel_Nombre
	end 
	
end
