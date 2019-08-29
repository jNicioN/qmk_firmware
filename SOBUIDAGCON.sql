create procedure SOBUIDAGCON (
	@Bia_IdAsesor int,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/****************************************************************************
*** REFERENCIAS: 														****
****************************************************************************
** Creo:	Pedro de los Reyes											****
** Descripcion: Busqueda de Id de Agente call center					****
** Folio:		1230668													****
** Fecha:		05/AGOSTO/2019											****
****************************************************************************/

declare	@Agente 	int, /* Declaracion de Variables */
     	@Id_Agente 	int /* Declaracion de Variables */
     	
select @Id_Agente=SoAgenteID from SOREAGCA where SoUsuariID = @Bia_IdAsesor

if @Id_Agente is null begin
	select @Id_Agente=0
end

select @Id_Agente as SoAgenteID