create procedure SOCORPROCON (
	@Cop_Folio	int,
	@Cop_Modulo	char(2),
	@Cop_Proces	char(3),
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Consulta de Correo por Procesos						 		*/
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** CreÃ³:			Marco A. Morales Ventura							****
** Fecha:			11/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Tip_ConTip char(1),
		@Tip_ConCon char(1)

/* Declaración de Constantes */
declare @Str_Porcen	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(2),
		@Str_Para	char(4),
		@Str_CC		char(9)

/* Asignación de Constantes */
select	@Str_Porcen	= '%',				/* String % */
		@Str_Uno	= '1',				/* String Uno */
		@Str_Dos	= '2',				/* String Dos */
		@Str_Para	= 'Para',			/* String Para */
		@Str_CC		= 'Con Copia'		/* String Con Copia */

select 	@Tip_ConTip = substring(@Tip_Consul, 1, 1),
		@Tip_ConCon = substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin  			/* 'C' = Consulta */

	if @Tip_ConCon = '1' begin				
		select	Cop_Folio, Cop_Modulo, Cop_Proces, Cop_Nombre, Cop_Correo, 
				Cop_Tipo
			from SOCORPRO noholdlock
			where Cop_Folio	= @Cop_Folio
	end

	if @Tip_ConCon = '2' begin				
		select	Cop_Folio, Cop_Nombre, Cop_Correo, 
				Cop_Tipo = case Cop_Tipo 
								when @Str_Uno then @Str_Para
								when @Str_Dos then @Str_CC
							end
			from SOCORPRO noholdlock
			where Cop_Modulo = @Cop_Modulo
			  and Cop_Proces = @Cop_Proces
			order by Cop_Folio
	end

end
