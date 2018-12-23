create procedure SOHISMONACT (
	@Him_Moneda	char(2),
	@Him_Fecha	smalldatetime,
	@Him_RevBal	double precision,
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Status		int					/* Declaración de Variables */

declare	@Str_Vacio	char(1),			/* Declaración de Constantes */
		@Dob_Cero	double precision,
		@Tip_RevBal	char(1)
		
/* Asignación de Constantes */
select	@Str_Vacio	= '',				/* String Vacío */
		@Dob_Cero	= 0.00,				/* Doble en Cero  */
		@Tip_RevBal	= 'R'				/* Actualicación de valor de TC Revalorizacion de Balance */

if @Tip_Actual = @Tip_RevBal begin
	if not exists (	select	Him_Moneda
						from SOHISMON
						where Him_Moneda = @Him_Moneda
						  and Him_Fecha	 = @Him_Fecha) begin
		select	Err_Codigo	= '000001', 
				Err_Mensaj	= 'No existe la moneda en esa fecha',
				Err_Foco	= 'Him_Moneda'
		rollback
		return 1
	end
	
	if isnull(@Him_RevBal, @Dob_Cero) = @Dob_Cero begin
		select	Err_Codigo	= '000002', 
				Err_Mensaj	= 'El campo TC Revalorización de Balance debe ser mayor a Cero',
				Err_Foco	= 'Him_RevBal'
		rollback
		return 1
	end
	
	Update SOHISMON set
		Him_RevBal	= @Him_RevBal
		where Him_Moneda	= @Him_Moneda
		  and Him_Fecha		= @Him_Fecha
end
