create procedure SOFOLIOSALT (
	@Fol_Tabla	char(8),
	@Fol_Numero	int)

as
/***************************************************************
 DESCRIPCION: 	Alta de Folio 
****************************************************************
 REFERENCIAS: 
***************************************************************
** Creo:		Tania De la Garza							****
** Fecha:		06/09/2018									****
** HelpDesk:	1157792										****
****************************************************************/

insert into SOFOLIOS (Fol_Tabla, Fol_Numero)
	values(	@Fol_Tabla,	@Fol_Numero)
