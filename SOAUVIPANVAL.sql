create procedure SOAUVIPANVAL (
	@Pantalla 	char(100),
	
	@NumTransac	char(10),  	
	@Transaccio	char(3), 	
	@Usuario	char(6), 	
	@FechaSis	smalldatetime, 	
	@SucOrigen	char(3), 	
	@SucDestino	char(3),	
	@Modulo		char(2))

as

/***************************************************************************/
 /* DESCRIPCION: Validación de Autorizaciones Visualización Pantallas
				 Valida que exista autorización existente en Sysbase para 
				 visualización de pantalla de parte de usuario logueado 
				 dependiendo de su perfil asignado */
/***************************************************************************
** Creó: Diego Calvillo ****
** Fecha: 24/Ago/21 ****
** Help: 1555359 ****
****************************************************************************/


/*Declaración de variables*/
declare @Usu_Count int

select @Usu_Count = count(BEUSUPER.Usu_Numero)
	from BEPANPLA noholdlock 
	inner join BEPANPER noholdlock on Pan_Numero = Pan_Pantal 
	inner join BEUSUPER noholdlock on Pan_Perfil = Usu_Perfil 
	where Pan_Nombre like '%'+@Pantalla+'%' and Usu_Numero = @Usuario

select @Usu_Count as ConteoPantalla