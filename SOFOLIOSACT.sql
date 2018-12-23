create procedure SOFOLIOSACT (
	@Fol_Tabla	char(8),
	@Fol_Numero	int		output)

as

/***************************************************************
 DESCRIPCION: Actualizar el folio de la tabla indicada.
****************************************************************
 REFERENCIAS: 
****************************************************************
** Modifico:	Tania De la Garza							****
** Help:		1157792										****
** Fecha:		06/Septiembre/2018							****
** Descripcion:	Optimización 								****
****************************************************************
** Modificó:	Laura V. Vázquez Nieto						****
** Fecha:		14/Septiembre/2004							****
** Descripción:	Agregar mensaje de salida del  resultado.	****
****************************************************************
** Creó:		LVAZQUEZ       								****
** Fecha:		12/Jul/04									****
***************************************************************/
/* Declaración de constantes */
declare @Status int

/* Declaración de constantes */
declare	@Ent_Cero	int,
		@Ent_Uno 	int

/* Asignación de valores a constantes */
select	@Ent_Cero	= 0,				/* Campo entero en ceros */
		@Ent_Uno	= 1					/* Entero Uno */
	
update SOFOLIOS set
	Fol_Numero	= Fol_Numero + @Ent_Uno, @Fol_Numero = Fol_Numero + @Ent_Uno
	where	Fol_Tabla	= @Fol_Tabla
	
select	@Fol_Numero	= isnull(@Fol_Numero,@Ent_Cero)

if @Fol_Numero	= @Ent_Cero	begin
	select	@Fol_Numero	= @Ent_Uno
	
	exec @Status = SOFOLIOSALT
			@Fol_Tabla,	@Fol_Numero
	if @Status <> 0 begin
		rollback
		return 1
	end
end	

if @@nestlevel	= @Ent_Uno begin
	select	Folio	= @Fol_Numero
end
