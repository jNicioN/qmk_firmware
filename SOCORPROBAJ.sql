create procedure SOCORPROBAJ (
	@Cop_Folio	int,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************************************************************************/
/* DESCRIPCION: Baja de Correos por Proceso									 */
/*****************************************************************************/

/** REFERENCIAS:
****************************************************************************
** Creó:			Marco A. Morales Ventura							****
** Fecha:			11/Julio/2013										****
** Help:		    00468177											****
*****************************************************************************/

/* Declaración de Variable */
declare	@Cop_FolAux	int

/* Declaración de Constantes */
declare	@Ent_Cero	int

/* Asignación de Constantes */
select	@Ent_Cero	= 0				/* Entero en Cero */

select	@Cop_FolAux = Cop_Folio
	from SOCORPRO noholdlock
	where Cop_Folio = @Cop_Folio

if isnull(@Cop_Folio, @Ent_Cero) = @Ent_Cero begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Registro no Existe',
			Err_Foco	= 'txtCop_Folio'
	rollback
	return 1
end

delete from SOCORPRO
	where	Cop_Folio	= @Cop_Folio
