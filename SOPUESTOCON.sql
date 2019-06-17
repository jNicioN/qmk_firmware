create procedure SOPUESTOCON (
	@Pue_Numero	char(8),
	@Pue_Nombre	char(60),
	
	@Tip_Consul char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_ConTip	char(1),	/* Variables para identificar el tipo de consulta */
		@Tip_ConCon	char(1)

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'L' begin					/* 'L':  Listas */

	if @Tip_ConCon = '1' begin				/* Listar Documentos */	
		select Pue_Numero,	Pue_Nombre
		  from SOPUESTO noholdlock
	end 
	
end


