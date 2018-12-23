create procedure SODEPARTACT (
	@Dep_Numero	char(3),
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tip_Activa char(1),	/* Declaracion de Constantes */
		@Tip_Inacti	char(1),
		@Sta_Activa	char(1),
		@Sta_Inacti	char(1)

/* Asignacion de Constantes */
select	@Tip_Activa = '1',		/* Tipo de Activa */
		@Tip_Inacti	= '2',		/* Tipo de Inactiva */
		@Sta_Activa	= 'A',		/* Status de Activa */
		@Sta_Inacti	= 'I'		/* Status de Inactiva */

if @Tip_Actual = @Tip_Activa begin
	update SODEPART set
		Dep_Status	= @Sta_Activa
		where	Dep_Numero	= @Dep_Numero
end

if @Tip_Actual = @Tip_Inacti begin
	update SODEPART set
		Dep_Status	= @Sta_Inacti
		where	Dep_Numero	= @Dep_Numero
end
