create procedure SOBITMONCON (
	@Mon_Numero	char(2),
	@Mon_Fecha	smalldatetime,	

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
		
select	Bim_EfeCom,	Bim_EfeVen,	Bim_DocCom, Bim_DocVen, Bim_FixCom,
		Bim_FixVen,	FechaSis 
	from SOBITMON noholdlock
	where 	Bim_Moneda	= @Mon_Numero
	and		Bim_Fecha	= @Mon_Fecha
	order by FechaSis
