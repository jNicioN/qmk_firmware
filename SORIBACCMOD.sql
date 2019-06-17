create procedure SORIBACCMOD (
	@Ria_Numero int,
	@Ria_NumRib int,
	@Ria_NumPer char(8),
	@Ria_PorPar numeric(10,2),
	@Ria_Activo bit,
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino	char(3),
	@Modulo char(2))
 as 
/****************************************************************/
/* DESCRIPCION: Modificacion de registros de Accionistas RIB	*/
/****************************************************************/
/** Creo:		Victor Osorio									*/
/** Fecha:		07/04/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

if not exists (select Ria_Numero
                   from SORIBACC noholdlock
                   where Ria_Numero = @Ria_Numero) begin
   select  Err_Codigo = '000001',
           Err_Mensaj	= 'El Número de ID: ' +  convert(varchar,@Ria_Numero) + ' No Existe',
           Err_Variab	= 'Ria_Numero'
   rollback
   return 1
end

Update SORIBACC set
	Ria_NumRib	= @Ria_NumRib,
	Ria_NumPer	= @Ria_NumPer,
	Ria_PorPar	= @Ria_PorPar,
	NumTransac	= @NumTransac, 
	Transaccio	= @Transaccio,
	Usuario		= @Usuario,
	FechaSis	= @FechaSis,
	SucOrigen	= @SucOrigen,
	SucDestino	= @SucDestino
where Ria_Numero = @Ria_Numero 

select Err_Codigo = '000000',
       Err_Mensaj = 'Registro Modificado Correctamente',
       Rri_Numero = @Ria_Numero
