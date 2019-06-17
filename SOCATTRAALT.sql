create procedure SOCATTRAALT (
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
	@Modulo		char(2))


as
/*Declaracion de variables*/
declare @Tra_Numero int

/*asigancion de varibles*/

if (SELECT isnull(MAX (Tra_Numero)+1,0) from SOCATTRA)=0
begin
	select @Tra_Numero=0
end
else
begin
	select @Tra_Numero=(SELECT MAX(Tra_Numero)+1 from SOCATTRA)
end



INSERT INTO SOCATTRA
	(Tra_Numero,
	Tra_SerOri ,
	Tra_BaDaOr ,
	Tra_TabOri ,
	Tra_SerDes ,
	Tra_BaDaDe ,
	Tra_TabDes ,
	Tra_Estado ,
	Tra_Coment ,
	Tra_Trunca ,

	NumTransac	,
	Transaccio	,
	Usuario	,
	FechaSis ,
	SucOrigen	,
	SucDestino	,
	Modulo
	)
 VALUES (@Tra_Numero,
	@Tra_SerOri ,
	@Tra_BaDaOr ,
	@Tra_TabOri ,
	@Tra_SerDes ,
	@Tra_BaDaDe ,
	@Tra_TabDes ,
	@Tra_Estado ,
	@Tra_Coment ,
	@Tra_Trunca ,

	@NumTransac	,
	@Transaccio	,
	@Usuario	,
	@FechaSis	,
	@SucOrigen	,
	@SucDestino	,
	@Modulo
	)



