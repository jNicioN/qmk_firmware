create procedure SOPROMODCON (
	@Prm_Numero	char(3),
	@Prm_Modulo	char(2),
	@Prm_Descri	varchar(50),
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
/* DESCRIPCION: Consulta de Modulos por Proceso								 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			10/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variables */
declare @Tip_ConTip char(1),
		@Tip_ConCon char(1)

/* Declaración de Constantes */
declare @Str_Porcen	char(1)

/* Asignación de Constantes */
select	@Str_Porcen	= '%'				/* String % */

select 	@Tip_ConTip = substring(@Tip_Consul, 1, 1),
		@Tip_ConCon = substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = 'C' begin  			/* 'C' = Consulta */

	if @Tip_ConCon = '1' begin				
		select	Prm_Numero, Prm_Modulo, Prm_Descri, Prm_Observ
			from SOPROMOD noholdlock
			where Prm_Numero = @Prm_Numero
			  and Prm_Modulo = @Prm_Modulo
	end
	
end else begin							/* 'L' = Lista */
	
	select	@Prm_Descri	= @Str_Porcen + rtrim(ltrim(@Prm_Descri)) + @Str_Porcen

	if @Tip_ConCon = '1' begin				
		select	Prm_Numero, Prm_Descri
			from SOPROMOD noholdlock
			where Prm_Modulo = @Prm_Modulo
			  and Prm_Descri like @Prm_Descri
			order by Prm_Numero
	end

end
