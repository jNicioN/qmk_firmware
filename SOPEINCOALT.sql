create procedure SOPEINCOALT (
   @Pic_PerNum int,
   @Pic_ActPre int,
   
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2))  
 as

/*******************************************************************
** DESCRIPCION: Alta de Persona Informacion Complemento        	  **
********************************************************************
** Creo:		Raul Muniz			                     		  **
** Fecha:		05/10/2021                               		  **
** Help:		1504301					 						  **
********************************************************************/

/* Declaracion de Constantes */
declare @Int_Uno int

/* Asignacion de valores a Constantes */
select  @Int_Uno = 1

insert into SOPEINCO
	(Pic_PerNum,	Pic_ActPre,		NumTransac,		Transaccio,		Usuario,
	FechaSis,		SucOrigen,		SucDestino)
	values (
	@Pic_PerNum,	@Pic_ActPre,	@NumTransac,	@Transaccio,	@Usuario,
	@FechaSis,		@SucOrigen,		@SucDestino)

if @@nestlevel = @Int_Uno begin 
     select Err_Codigo = '000000', 
     		Err_Mensaj = 'Relacion agregada correctamente'
end