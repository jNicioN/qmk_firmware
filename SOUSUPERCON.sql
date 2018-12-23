create procedure SOUSUPERCON (
	@Upe_Numero	char(6),
	@Upe_Clave	char(8),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** DESCRIPCION: ** Consulta de persona por usuario **					****
****************************************************************************
** REFERENCIAS:
****************************************************************************
** ModificÃ³:	Rolando Bernal											****
** Fecha:		11/Dic/2015												****
** Help:		00801121												****
** DescripciÃ³n:	OptimizaciÃ³n											****
****************************************************************************
** Creo:			Evijair Nunez Jordan								****
** Fecha:			24/Nov/2015											****
** Help:			00801121											****
***************************************************************************/

declare	@Tip_ConTip	char(1),		/* DeclaraciÃ³n de Variables */
		@Tip_ConCon	char(1)

declare	@Str_Vacio	char(1),		/* DeclaraciÃ³n de Constantes */
		@Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Upe_GruUni	char(8),
		@Str_Porcen	char(1)

/* AsignaciÃ³n de Constantes */
select	@Str_Vacio	= '',			/* String VacÃ­o				*/
		@Tra_TipLis	= 'L',			/* Tipo : Lista				*/
		@Tra_TipCon	= 'C',			/* Tipo : Consulta			*/
		@Str_Uno	= '1',			/* String para consulta por numero	*/
		@Str_Dos	= '2',			/* String para consulta por clave	*/
		@Upe_GruUni	= '',
		@Str_Porcen	= '%'			/* String Porcentaje */

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Tra_TipCon begin					/* 'C':  Consulta		*/
	if @Tip_ConCon = @Str_Uno begin					/* Consulta principal	*/
		select	@Upe_GruUni	= Peu_Grupo
				from SOUNIPER noholdlock
				where	Peu_Person	= (
										select	Adi_PerNum
											from SOPERADI noholdlock
											where	Adi_PerNum	= (
																	select	Adi_NumPer
																		from CLADICIO noholdlock
																		where	Adi_Client	= (
																								select	Emp_Client
																									from RHEMPLEA noholdlock
																									where	Emp_Numero	 = @Upe_Numero
																								)
																	)
										)
	end
	
	if @Tip_ConCon = @Str_Dos begin					/* Consulta principal	*/

		select	@Upe_GruUni	= Peu_Grupo
			from SOUNIPER noholdlock
			where	Peu_Person	= (
									select	Adi_PerNum
										from SOPERADI noholdlock
										where	Adi_PerNum	= (
																select	Adi_NumPer
																	from CLADICIO noholdlock
																	where	Adi_Client	= (
																							select	Emp_Client
																								from RHEMPLEA noholdlock
																								where	Emp_Numero	like (@Str_Porcen + substring(@Upe_Clave, 4, 5))
																							)
																)
									)

	end

	select	Upe_GruUni	= @Upe_GruUni

end
