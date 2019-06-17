create procedure SOANESCOBAJ (
	@Aec_Numero numeric,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
 as

/*****************************************************************
** DESCRIPCION: Baja de analitica estandar concepto				**
******************************************************************
*** Creo:		Felipe Castillo									**
*** Fecha:		17/05/2017                               		**
*** Help:		929417 					 						**
*****************************************************************/

delete from SOANESCO
where Aec_Numero = @Aec_Numero

select	Err_Codigo = '000000',
Err_Mensaj = 'Registro Borrado Correctamente'
