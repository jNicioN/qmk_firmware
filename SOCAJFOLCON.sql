create procedure SOCAJFOLCON (
	@Tip_Consul	char(2),			/* Preparación para Consultas Futuras */
									/* Pasar vacío para SiCCA/Autorizador */

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/* Regresa los Folios necesarios para cambiarse de modo Normal a Modo Cierre/Fuera-de-Linea y viceversa.
	Los Folios son e
   1 El Numero de Transaccion (similar a SYFOLIOS) para operaciones de Cajeros/Punto de Venta,
   2 El Numero de Autorizacion para operaciones de Tarjetas de Debito
   3 El Numero de Autorizacion para operaciones de Tarjetas de Credito
*/

declare	@Fol_Transa	int,
		@Num_Transa char(10),
		@Num_TranExt char(10)

select 	@Fol_Transa	= Fol_Transa
	from CTFOLIOS holdlock

select 	@Num_Transa =  right('0000000000'+ ltrim(rtrim(convert(char, @Fol_Transa))), 9)

select 	@Fol_Transa	= Fol_Transa
	from CTFOLEXT holdlock

select 	@Num_TranExt =  right('000000000'+ ltrim(rtrim(convert(char, @Fol_Transa))), 8)


select Fol_Transa= @Num_Transa, CT_Autori= CTAUTORI.Aut_Numero, TA_Autori= TAAUTORI.Aut_Numero, Fol_TranEx = @Num_TranExt 
from CTAUTORI noholdlock,
	TAAUTORI noholdlock
	
	
