create procedure SOTMPBCCCON (
	@Bcc_Fecha	smalldatetime,
	@Bcc_StoPro	char(11),
	@Bcc_TipMov char(6),
	@Par_Contin	bit output,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*********************************************************************************/
/** 	Consulta a la tabla de monitoreo en el proceso de Calculo de Comisiones	**/
/*********************************************************************************/
/*** Nombre: Code4U Joel Gonzalez						   						**/
/**  Fecha: 30/Enero/2020										   				**/
/**  Help: 												   				  		**/
/**  Descripcion: Consulta a la tabla de Bitacora del proceso de Calculo de 	**/
/**               Comisiones, para determinar si el proceso que esta por        **/
/**               ejecutarse ya fue previamente ejecuta.                        **/
/*********************************************************************************/

/* Declaracion de constantes		*/
declare	@Sta_Si		bit,	/* Status: Si	*/
		@Sta_No		bit		/* Status: No	*/

/* Asignacion de constantes		*/
select	@Sta_Si		= 1,		/* Status: Si	*/
		@Sta_No		= 0		/* Status: No	*/

if exists (	select	 Bcc_StoPro        
				from	SOTMPBCC noholdlock
				where 	Bcc_Fecha = @Bcc_Fecha 
				  and 	Bcc_StoPro = @Bcc_StoPro
				  and 	Bcc_TipMov = @Bcc_TipMov ) 
	select	@Par_Contin =	@Sta_No
else
	select	@Par_Contin =	@Sta_Si

