create procedure SOSAFIDIVAL (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Fec_Proces	smalldatetime, 		/* Declaracin de Variables */
		@Fecha	smalldatetime

declare @Mon_Pesos 	char(2),		/* Declaración de Constantes */
		@Cie_Sucurs	char(1)
		
/* Asignación de Costantes */		
select	@Mon_Pesos	= '01',		/* Moneda: Pesos */
		@Cie_Sucurs	= 'S'		/* Cierre Sucursal */

select	@Fec_Proces	= dateadd(day, -1, getdate())	
select	@Fecha	= @Fec_Proces

exec SOANTFECHAB
	@Fecha		= @Fecha output,	
	@NumDia		= 0,
	@FinSem		= 'N',
	@Salida_Fox	= 'N'
	
/* Crea Temporal */		
create table #Aperturas 
	(Fecha		smalldatetime null,
	Sucursal	char(3) null,
	Sal_Final	money null)

insert into #Aperturas 
	select	Sal_Fecha,	Sal_Sucurs,	Sal_Final
		from	VEPRISAL noholdlock,
			SOSUCURS noholdlock
		where   Sal_Sucurs	= Suc_Numero
		  and	Sal_Fecha	= @Fecha
		  and	Sal_Moneda	= @Mon_Pesos
		  and	Suc_CiCrCe	= @Cie_Sucurs

/* Adaptive Server has expanded all '*' elements in the following statement */ select #Aperturas.Fecha, #Aperturas.Sucursal, #Aperturas.Sal_Final from #Aperturas 

/* Borra Temporal */		
drop table #Aperturas 	
