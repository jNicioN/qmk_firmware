create procedure SOAPESUCVAL (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare @Dia_Habil 	char(1),		/* Declaración de Constantes */
		@Dia_InHabi	char(1),
		@Cie_Sucurs	char(1)
		
/* Asignación de Costantes */		
select	@Dia_Habil	= 'H',		/* Dia: Habil */
		@Dia_InHabi	= 'I',		/* Dia: Inhabil */
		@Cie_Sucurs = 'S'		/* Cierre Sucursal */

select	Suc_Numero, 
	case Suc_UltDia
		when @Dia_Habil then 'Habil' 
		when @Dia_InHabi then 'Inhabil' 
	end  as Status,
	Par_FecAct
	from SOSUCURS  noholdlock,
		 SOPARAMS  noholdlock
	where	Suc_Numero	= Par_Sucurs
	  and	Suc_CiCrCe	= @Cie_Sucurs
	order by Suc_Numero

