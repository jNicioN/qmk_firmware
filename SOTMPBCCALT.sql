create procedure SOTMPBCCALT (
	@Bcc_Fecha	smalldatetime,
	@Bcc_StoPro	char(11),
	@Bcc_TipMov char(6),
	@Bcc_Descri	varchar(50),
	@Bcc_Tiempo	int,
	@Bcc_FecIni	smalldatetime,
	@Bcc_FecFin smalldatetime,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*********************************************************************************/
/** 	Alta en la tabla de monitoreo en el proceso de Calculo de Comisiones	**/
/*********************************************************************************/
/*** Nombre: Code4U Joel Gonzalez						   						**/
/**  Fecha: 30/Enero/2020										   				**/
/**  Help: 												   				  		**/
/**  Descripcion: Registros de Tiempos de la ejecución de Cálculo de Comisiones	**/
/**               por cada Comision.											**/
/*********************************************************************************/


insert into SOTMPBCC	
	(Bcc_Fecha,	Bcc_StoPro,	Bcc_TipMov,	Bcc_Descri,	Bcc_Tiempo,
	Bcc_FecIni,	Bcc_FecFin )         
		values ( 
		@Bcc_Fecha, 	@Bcc_StoPro,	@Bcc_TipMov,	@Bcc_Descri,	@Bcc_Tiempo,
		@Bcc_FecIni,	@Bcc_FecFin)
