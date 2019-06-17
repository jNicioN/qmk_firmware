create procedure SOLIMSESACT (

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3))

as
/**************************************************************************/
/* DESCRIPCION: Limpia Sesiones de Usuarios 							  */
/**************************************************************************/
/** REFERENCIAS: 
****************************************************************************
** Creó:		Misden Crystal Martinez Lucio							****
** Fecha:		14/Octubre/2013											****
** Help:		603096													****
***************************************************************************/

Declare	
							/* Declaracion de Constantes */
		@Str_Vacio	char(1),
		@Ent_Cero	int,
		@Sta_Inacti	char(1),
		@Usu_S		char(1),
		@Usu_A		char(1),
		@Status int
		
			

/* Asignación de Constantes */

select		
			@Str_Vacio	= '',			/* String Vacío	*/
			@Ent_Cero	= 0,			/* Entero en Cero*/
			@Sta_Inacti	= 'I',			/* Status de Usuario Inactivo*/
			@Usu_A	= 'A',
			@Usu_S ='S'

		

select	@FechaSis	= getdate()


BEGIN TRANSACTION

	update SOUSUARI set
		Usu_StaSes	= @Sta_Inacti,
		Usu_IPSesi	= @Str_Vacio,
		Usu_CanSes	= @Ent_Cero,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where	Usu_Status= @Usu_A
				and Usu_Activo= @Usu_S

COMMIT TRANSACTION
