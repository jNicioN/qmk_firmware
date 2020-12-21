create procedure SOBITUSUPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as

/**
****************************************************************************
** DESCRIPCION: ** Paso a Historico de Bitacora de Usuarios			    ****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		Carlos Copto											****
** Fecha:		09/12/2020   											****
** Help Desk:	1376175										 			****
****************************************************************************
**/

								/* Declaracion de constantes */
declare	@Ent_Cero  int

								/* Asignacion de valores a constantes */
select	@Ent_Cero  = 0			/* Entero cero */
		
begin transaction

	insert into SOHISUSU 
	select Biu_FolUsu, Biu_Estatus, Biu_FecEst, Biu_Usuari, Biu_Sucurs, Biu_Canal, Biu_DesEst, @NumTransac, @Transaccio, @Usuario, @FechaSis, @SucOrigen, @SucDestino
	from SOBITUSU where Biu_Consec > @Ent_Cero
			  
commit

begin transaction
	
	delete from SOBITUSU where Biu_Consec > @Ent_Cero
	
commit 