create procedure SOBIDAFICON (
	@PerPersoID	int,	
	@Tip_Consul	 	char(2),

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
** DESCRIPCION: ** Consulta  de SOBIDAFI	  por Persona				****
****************************************************************************
**	REFERENCIAS:														****
****************************************************************************
** Creo:		José Antonio Mandujano Salgado							****
** Fecha:		03/05/2022   											****
** Help Desk:	1621179	 									 			****
****************************************************************************
**/


/*Declaración Variables*/
declare	@Tip_ConTip	char(1),			/*	Tipo consulta			*/
		@Tip_ConCon	char(1)				/*	Tipo de consulta		*/


/* Declaracion de Constantes */
declare @Tra_TipLis	char(1),
		@Tra_TipCon	char(1),
		@Str_Uno	char(1),
		@Str_Dos	char(1),
		@Ent_Uno	int,
		@Ent_Dos	int,
		@Str_Vacio	char(1),
		@Ent_Cero	int


								/* Asignacion de valores a constantes */
select	@Str_Vacio = '',		/* String Vacio */
		@Ent_Cero  = 0,			/* Entero cero */
		@Tra_TipLis	= 'L',		/* Tipo : Lista		*/		
		@Tra_TipCon	= 'C',		/* Tipo : Consulta	*/
		@Str_Uno	= '1',		/* String Uno 		*/	
		@Str_Dos	= '2',		/* String Dos 		*/
		@Ent_Uno	= 1, 		/* Entero Uno 		*/
		@Ent_Dos	= 2			/* Entero Dos 		*/

select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Tra_TipLis begin		/************** LISTAS ******************/
	if @Tip_ConCon = @Str_Uno begin			/* Inicio L1 */
		
		select 
				PerPersoID, Bdf_Nombre, Bdf_Regime, Bdf_UsoCfd, 
				Bdf_ApePat, Bdf_ApeMat, Bdf_RazSoc, NumTransac,	
				Transaccio, Usuario, FechaSis, SucOrigen, SucDestino
		from SOBIDAFI noholdlock
		where PerPersoID = @PerPersoID  
				
	end		
	
end

	
