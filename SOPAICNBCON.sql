create procedure SOPAICNBCON (
	@Pac_Clave	char(3),
	@Pac_Nombre	varchar(30),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

 /*	Declaracion De Variables	*/
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaración de Constantes */
declare		@Str_Vacio	char(1)		

/* Asignación de Constantes */
select	@Str_Vacio	= ''			/*	String Vacío 		*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if  	@Pac_Clave	= @Str_Vacio and @Pac_Nombre = @Str_Vacio begin
		select	Pac_Clave,	Pac_Nombre
			from SOPAICNB noholdlock
			order by Pac_Nombre
end 

if @Tip_ConTip = 'C' begin					/*	C O N S U L T A S	*/
	if @Tip_ConCon = '1' begin	/*	Consulta por Llave Principal	*/
		select	Pac_Clave,	Pac_Nombre
			from SOPAICNB noholdlock
			where	Pac_Clave	= @Pac_Clave
	end
end else begin								/*	L I S T A S	*/
	select	@Pac_Nombre	= ltrim(rtrim(@Pac_Nombre)) + '%'
	
	if @Tip_ConCon = '1' begin	/* Lista de Catálogo */		
		select	Pac_Clave,	Pac_Nombre
			from SOPAICNB noholdlock
			where	Pac_Nombre	like @Pac_Nombre
			order by Pac_Nombre
	end
end
