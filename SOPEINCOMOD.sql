create procedure SOPEINCOMOD (
	@Pic_PerNum	char(8),
	@Pic_ActPre	int,

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION: Modificacion de Persona Informacion Complemento   **
********************************************************************
** Creo:		Raul Muniz			                     		  **
** Fecha:		05/10/2021                               		  **
** Help:		1504301					 						  **
********************************************************************/

/*	Declaracion de Variables */
declare	@Status		int,
		@Num_Person	char(8)

/*	Declaracion de Constantes	*/
declare	@Str_Vacio	char(1),				-- String Vacio
		@Ent_Uno	int						-- Entero Uno

select	@Str_Vacio	= '',					-- String Vacio
		@Ent_Uno	= 1						-- Entero Uno

select	@Num_Person = isnull(Pic_PerNum, @Str_Vacio)
	from	SOPEINCO noholdlock
	where	Pic_PerNum	= @Pic_PerNum

if @Num_Person	= @Str_Vacio begin

	exec @Status = SOPEINCOALT
		@Pic_PerNum,	@Pic_ActPre,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,		@SucOrigen,		@SucDestino,	@Modulo
		
	if @Status <> 0 begin
		select	Err_Codigo = '000020', 
				Err_Mensaj = 'No se Actualizo la Informacion'
		rollback
		return 1
	end

end else begin
	update	SOPEINCO set
		Pic_ActPre = @Pic_ActPre,
		NumTransac = @NumTransac,
		Transaccio = @Transaccio,
		Usuario = @Usuario,
		FechaSis = @FechaSis,
		SucOrigen = @SucOrigen,
		SucDestino = @SucDestino
	where	Pic_PerNum = @Pic_PerNum
	
	if @@nestlevel = 1
		select	Err_Codigo	= '000000', 
				Err_Mensaj	= 'Registro Modificado'
				
end