create procedure SOUSUMULREP (
	@Usu_MulSes	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Descripción: Reporte de Usuarios Multisesion
****************************************************************************
** Creó:		Ignacio Ordaz Valtierra						****
** Fecha:		04/Ene/13									****
** Help:		00499777 										****
****************************************************************************
*/

select	SoUsuariID,	Usu_Nombre,	Usu_Clave,	Usu_MulSes,	
		Usu_Perfil,	Per_Descri, Usu_Nivel,	Niv_Descri
	from SOUSUARI noholdlock, 
		 SAPERFIL noholdlock,
		 SONIVELE noholdlock
where Usu_Perfil	= Per_Numero
 and  Usu_Nivel		= Niv_Numero
 and  Usu_MulSes	= @Usu_MulSes
