create procedure SOCATTRAMOD (
	@Tra_Numero int,
	@Tra_SerOri char(12),
	@Tra_BaDaOr char(15),
	@Tra_TabOri char(8),
	@Tra_SerDes char(12),
	@Tra_BaDaDe char(15),
	@Tra_TabDes char(8),
	@Tra_Estado char(1),
	@Tra_Coment varchar(150),
	@Tra_Trunca char(1),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo     char(2))
	

as
UPDATE SOCATTRA SET 
    Tra_SerOri=@Tra_SerOri,
	Tra_BaDaOr=@Tra_BaDaOr,
	Tra_TabOri=@Tra_TabOri,
	Tra_SerDes=@Tra_SerDes,
	Tra_BaDaDe=@Tra_BaDaDe,
	Tra_TabDes=@Tra_TabDes,
	Tra_Estado=@Tra_Estado,
	Tra_Coment=@Tra_Coment,
	Tra_Trunca=@Tra_Trunca,
	NumTransac=@NumTransac,	
	Transaccio=@Transaccio,	
	Usuario=@Usuario,	
	FechaSis=@FechaSis,	
	SucOrigen=@SucOrigen,
	SucDestino=@SucDestino,
	Modulo=@Modulo
WHERE Tra_Numero=@Tra_Numero 

