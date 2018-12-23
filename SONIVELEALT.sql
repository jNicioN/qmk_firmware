create procedure SONIVELEALT	(
	@Niv_Numero	char(2),
	@Niv_Descri	varchar(30),
	@Niv_Acceso	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Tab_Nombre	char(8)					/* Declaración de Variables */

declare	@Str_Vacio	char(1),				/* Declaración de Constantes */
		@Str_Si		char(1),
		@Str_No		char(1)

/* Asignación de Constantes */
select	@Str_Vacio	= '',					/* String Vacío */
		@Str_Si		= 'S',					/* String Si 	*/
		@Str_No		= 'N'					/* String No	*/

select	@Tab_Nombre = 'SONIVELE'

if exists (select	Niv_Numero
						from SONIVELE noholdlock
						where	Niv_Numero	= @Niv_Numero) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'El nivel ya existe',
			Err_Variab	= 'Niv_Numero',
			Err_Foco	= 'txtNiv_Numero'
	rollback
	return 1
end else if @Niv_Descri = @Str_Vacio begin
	select	Err_Codigo	= '000002',
			Err_Mensaj	= 'Descripcion incorrecta',
			Err_Variab	= 'Niv_Descri',
			Err_Foco	= 'txtNiv_Descri'
	rollback
	return 1
end else if (@Niv_Acceso <> @Str_Si and @Niv_Acceso <> @Str_No) begin
	select	Err_Codigo	= '000003',
			Err_Mensaj	= 'Acceso Incorrecto',
			Err_Variab	= 'vNiv_Acceso',
			Err_Foco	= 'txtNiv_Acceso'
	rollback
	return 1
end else begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado'
	
	insert into SONIVELE values (
		@Niv_Numero,	@Niv_Descri,	@Niv_Acceso,	@NumTransac,	@Transaccio,
		@Usuario,		@FechaSis,		@SucOrigen,		@SucDestino)
	
	exec SYTABLOCACT
		@Tab_Nombre,	@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen,		@SucDestino,	@Modulo

end
