create procedure SOPLAZASBAJ (
	@Pla_Numero char(3),
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

declare	@Str_Vacio	char(1),		/* Declaración de Constantes */
		@Tip_Plaza	char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',				/* String Vacio */
		@Tip_Plaza	= 'A'				/* Tipo de alta en Leyendas: PLAZA */

if not exists (select	Pla_Numero
				from SOPLAZAS noholdlock
				where	Pla_Numero	= @Pla_Numero) begin
	select 	Err_Codigo	= '000001',
			Err_Mensaj	= 'La plazas no existe',
			Err_Variab	= 'Pla_Numero'
	rollback
	
end else begin
	delete from SOPLAZAS 
		where	Pla_Numero	= @Pla_Numero

	exec CHLEESCUBAJ	
		@Pla_Numero,	@Str_Vacio,		@Str_Vacio,		@Str_Vacio,		@Tip_Plaza,
		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,		@SucOrigen,
		@SucDestino,	@Modulo

	select 	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Borrado'

end
