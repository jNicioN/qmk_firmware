create procedure SOUSACDIACT (
	@Uad_Numero	int,
	@Uad_Usuari	char(6),
	@Uad_Pantal	int,
	@Uad_Indice	int,
	@Uad_IndAnt	int,
	@Tip_Actual	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/****************************************************************************/
/* DESCRIPCION:	Proceso para reordenar posicion de accesos					**
** 				directos tabla (SOUSACDI)									*/
/****************************************************************************/
/** REFERENCIAS:															*/
/*****************************************************************************
** Modificó:		Adaías Fuentes Martínez									**
** Fecha:			26/06/2013												**
** Modificación:	Creación del store procedure.							**
** Help Desk:		539205													**
******************************************************************************/
/*****************************************************************************
** Modificó:		Adaías Fuentes Martínez									**
** Fecha:			13/09/2013												**
** Modificación:	Correccion de validaciones if con select.				**
** Help Desk:		539205													**
******************************************************************************/

declare	@Uad_Inicio	int,		/* Declaración de Variables */
		@Uad_Fin	int,
		@Uad_Add	int,
		@Uad_IndAct	int,
		@Uad_IndNew	int
		
declare	@Tip_ActInd	char(1),			/* Declaración de Constantes */
		@Int_Null	int

/* Asignación de Constantes */
select	@Tip_ActInd	= 'I' 				/* Actualizacion de tipo Indices */
select	@Int_Null	= -1 				/* Representa un numero NULL	*/

if @Tip_Actual	= @Tip_ActInd begin
	select	@Uad_IndAct	= Uad_Indice
		from SOUSACDI noholdlock
		where	Uad_Numero	= @Uad_Numero
		
	if @Uad_IndAnt	<> @Uad_IndAct begin
		select	Err_Codigo	= '000001',
				Err_Mensaj	= 'El indice del acceso directo no coincide con el indice que se quiere actualizar'
		rollback
		return 1
	end
	
	select	@Uad_IndNew = Uad_Indice
		from SOUSACDI noholdlock
		where	Uad_Usuari	= @Uad_Usuari and
				Uad_Indice	= @Uad_Indice
	
	if isnull(@Uad_IndNew, @Int_Null) = @Int_Null begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'El indice nuevo no existe'
		rollback
		return 1
	end
		
	if @Uad_Indice	> @Uad_IndAnt begin
		select	@Uad_Inicio	= @Uad_IndAnt,
				@Uad_Fin	= @Uad_Indice,
				@Uad_Add	= -1
	end else begin
		select	@Uad_Inicio	= @Uad_Indice,
				@Uad_Fin	= @Uad_IndAnt,
				@Uad_Add	= 1
	end
	
	--actualiza los indices intermedios
	update SOUSACDI set
		Uad_Indice	= Uad_Indice + @Uad_Add,
	
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino,
		Modulo		= @Modulo
	from SOUSACDI
	where	Uad_Usuari	= @Uad_Usuari and
			Uad_Indice between @Uad_Inicio and @Uad_Fin
	
	--actualiza el acceso directo que se movió
	update SOUSACDI set 
		Uad_Indice	= @Uad_Indice,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino,
		Modulo		= @Modulo
	from SOUSACDI
	where	Uad_Numero	= @Uad_Numero

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Indices actualizados correctamente'
end
