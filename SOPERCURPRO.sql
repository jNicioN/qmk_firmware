create procedure SOPERCURPRO (
	@Per_Numero	char(8),
	@Tip_Proces	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/*
********************************************************************
** DESCRIPCION: Proceso de personas por CURP					  **
********************************************************************
** REFERENCIAS: 												  **
********************************************************************
********************************************************************
** Creo:	Marcelo Bautista Hernandez							****
** Fecha:	11-Abr-2019											****
** Help:	01223447											****
********************************************************************
*/

/*Declaración constantes*/
declare	@Str_Vacios	char(1),
		@Str_Porcen	char(1),
		@Lon_Curp	smallint,
		@Ent_Uno	smallint

/*Declaración variables*/
declare	@Per_CURP	varchar(18),
		@Per_Comple	varchar(180),
		@Peu_Grupo	char(8),
		@Per_Grupo  char(8),
		@Ent_Cero	int,
		@Status		int

/* Asignación de constantes */
select	@Str_Vacios	= '',			-- String Vacio
		@Ent_Cero	= 0,			-- Entero en Cero
		@Str_Porcen	= '%',
		@Lon_Curp	= 18,
		@Ent_Uno	= 1

select	@Per_Grupo	= isnull(Peu_Grupo,	@Str_Vacios)
	from SOUNIPER noholdlock 
	where  Peu_Person	= @Per_Numero

select	@Per_CURP	= Per_CURP,
		@Per_Comple	= Per_Comple
	from SOPERSON noholdlock
	where	 Per_Numero	= @Per_Numero

if char_length(ltrim(rtrim(@Per_CURP))) <> @Lon_Curp begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Longitud de curp incorrecto'
	rollback
	return @Ent_Uno
end

select	@Peu_Grupo	= min(Peu_Grupo)
from SOUNIPER (index SOUNIPERPER) noholdlock
	where Peu_Person	in (select	Per_Numero
								from SOPERSON noholdlock 
								where	Per_Comple	= @Per_Comple and Per_CURP	= @Per_CURP)
	
if ltrim(@Per_Grupo) <> ltrim(@Str_Vacios) begin							/* Actualizar grupo*/
	if @Per_Grupo <> @Peu_Grupo and isnull(ltrim(@Peu_Grupo), @Str_Vacios) <> @Str_Vacios begin
	    update SOUNIPER set
		       Peu_Grupo  = @Peu_Grupo,
			   
			   NumTransac  = @NumTransac,
			   Transaccio  = @Transaccio,
			   Usuario	   = @Usuario,
			   FechaSis	   = @FechaSis,
			   SucOrigen   = @SucOrigen,
			   SucDestino  = @SucDestino
		 where Peu_Person  = @Per_Numero
	end 
end else begin																/* Alta de grupo*/
	if isnull(ltrim(@Peu_Grupo), @Str_Vacios) = @Str_Vacios
		select	@Peu_Grupo = @Per_Numero

	exec @Status =  SOUNIPERALT
		@Peu_Grupo,	@Per_Numero,	@NumTransac,	@Transaccio,	@Usuario,
		@FechaSis,	@SucOrigen,		@SucDestino,	@Modulo
	if @Status <> @Ent_Cero begin
		rollback
	return 1
end
end

if @@nestlevel = @Ent_Uno begin
	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Registro Agregado',
			Peu_Grupo	= @Peu_Grupo,
			Per_Numero	= @Per_Numero
end