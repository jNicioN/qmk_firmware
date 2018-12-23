create procedure SOPACOMZCON (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

select Par_Server, Par_BasDat, Par_Usuari, Par_Contra, Par_NoOdBc
    from SOPACOMZ noholdlock 
  
  
  

