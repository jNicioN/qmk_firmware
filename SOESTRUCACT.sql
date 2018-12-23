create procedure SOESTRUCACT (
	@Est_Numero	char(8),
	@Est_Puesto	char(8),
	@Est_Nombre	char(80),
	@Est_Usuari	char(6),
	@Est_Raiz	char(3),
	
	@Tip_Actual	char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Tip_Modifi	char(1)			/* Declaracion de Constantes */
		
/* Asignacion de Constantes 			Actualizar :*/
select	@Tip_Modifi	= 'M'			/* Modificar */
			
if @Tip_Actual= @Tip_Modifi begin										
	update SOESTRUC set 
		Est_Puesto	= @Est_Puesto,
		Est_Nombre	= @Est_Nombre,
		Est_Usuari	= @Est_Usuari,
		Est_Raiz	= @Est_Raiz,

		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino	= @SucDestino
		where 	Est_Numero 	= @Est_Numero
end

select 	Err_Codigo = '000000', 
		Err_Mensaj = 'Registro Modificado'

