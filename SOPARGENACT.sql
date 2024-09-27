create procedure SOPARGENACT(
    @Par_Consec  int,
	@Par_Nombre  varchar(50),
    @Par_Valor   varchar(200),
    @Par_Descri  varchar(200),
	@Tip_Actual  char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/***************************************************************************
** DESCRIPCION: Proceso de Actualizacion parcial de tabla SOPARGEN   	****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modifico:	Rafael Dominguez										****
** Fecha:		01/08/2024												****
** Help:														****
** Descripcion: Creacion sp SOPARGENACT para actualización parcial   	****
***************************************************************************/
/* Declaracion de Variables */
declare @Str_CanVal char(1)

/* Declaración de Constantes */
declare @Str_Vacio	char(1),
		@Str_Cambio char(1)

/* Asignación de Constantes*/
select @Str_Vacio	= '',						/* String Vacio 										 */
	   @Str_CanVal	= 'A' 						/* Tipo de cambio A para cambiar el campos Par_Valor		 */

if @Tip_Actual = @Str_CanVal begin 
		
		select @Par_Valor = isnull(@Par_Valor,@Str_Vacio)
		
		update SOPARGEN set
			Par_Valor = @Par_Valor,
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario  	= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
			where Par_Consec  = @Par_Consec

end 