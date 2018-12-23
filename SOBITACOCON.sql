create procedure SOBITACOCON (
	@Bit_FecIni	smalldatetime,
	@Bit_FecFin	smalldatetime,
	
	@Tip_Reprot char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as


select 	Bit_Host,  Usu_Nombre, Bit_Consec, Bit_Fecha, 
		Bit_DirIp, Bit_Pantal, Bit_Accion, Bit_Instru 
	from SOBITACO bit,
		 SOUSUARI usu
	where 	Usu_Numero = Bit_UsuNum
		and bit.FechaSis between @Bit_FecIni and @Bit_FecFin
	order by Bit_Consec


