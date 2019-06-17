create procedure SOCATTRACON (
	@Tra_Numero int,
	@modalidad char(1),
	
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

if @modalidad='i'
	begin
		/* Adaptive Server has expanded all '*' elements in the following statement */ select SOCATTRA.Tra_Numero, SOCATTRA.Tra_SerOri, SOCATTRA.Tra_BaDaOr, SOCATTRA.Tra_TabOri, SOCATTRA.Tra_SerDes, SOCATTRA.Tra_BaDaDe, SOCATTRA.Tra_TabDes, SOCATTRA.Tra_Estado, SOCATTRA.Tra_Coment, SOCATTRA.Tra_Trunca, SOCATTRA.NumTransac, SOCATTRA.Transaccio, SOCATTRA.Usuario, SOCATTRA.FechaSis, SOCATTRA.SucOrigen, SOCATTRA.SucDestino, SOCATTRA.Modulo from SOCATTRA where Tra_Numero=@Tra_Numero
	end

if @modalidad='t'/*todos los registros*/
	begin
		/* Adaptive Server has expanded all '*' elements in the following statement */ select SOCATTRA.Tra_Numero, SOCATTRA.Tra_SerOri, SOCATTRA.Tra_BaDaOr, SOCATTRA.Tra_TabOri, SOCATTRA.Tra_SerDes, SOCATTRA.Tra_BaDaDe, SOCATTRA.Tra_TabDes, SOCATTRA.Tra_Estado, SOCATTRA.Tra_Coment, SOCATTRA.Tra_Trunca, SOCATTRA.NumTransac, SOCATTRA.Transaccio, SOCATTRA.Usuario, SOCATTRA.FechaSis, SOCATTRA.SucOrigen, SOCATTRA.SucDestino, SOCATTRA.Modulo from SOCATTRA order by Tra_SerOri,Tra_BaDaOr,Tra_TabOri
	end
	
if @modalidad='a'/*todos los registros activos*/
	begin
		/* Adaptive Server has expanded all '*' elements in the following statement */ select SOCATTRA.Tra_Numero, SOCATTRA.Tra_SerOri, SOCATTRA.Tra_BaDaOr, SOCATTRA.Tra_TabOri, SOCATTRA.Tra_SerDes, SOCATTRA.Tra_BaDaDe, SOCATTRA.Tra_TabDes, SOCATTRA.Tra_Estado, SOCATTRA.Tra_Coment, SOCATTRA.Tra_Trunca, SOCATTRA.NumTransac, SOCATTRA.Transaccio, SOCATTRA.Usuario, SOCATTRA.FechaSis, SOCATTRA.SucOrigen, SOCATTRA.SucDestino, SOCATTRA.Modulo from SOCATTRA where Tra_Estado='A' order by Tra_SerOri,Tra_BaDaOr,Tra_TabOri
	end
if @modalidad='b'/*todos los registros inactivos*/
	begin
		/* Adaptive Server has expanded all '*' elements in the following statement */ select SOCATTRA.Tra_Numero, SOCATTRA.Tra_SerOri, SOCATTRA.Tra_BaDaOr, SOCATTRA.Tra_TabOri, SOCATTRA.Tra_SerDes, SOCATTRA.Tra_BaDaDe, SOCATTRA.Tra_TabDes, SOCATTRA.Tra_Estado, SOCATTRA.Tra_Coment, SOCATTRA.Tra_Trunca, SOCATTRA.NumTransac, SOCATTRA.Transaccio, SOCATTRA.Usuario, SOCATTRA.FechaSis, SOCATTRA.SucOrigen, SOCATTRA.SucDestino, SOCATTRA.Modulo from SOCATTRA where Tra_Estado='I' order by Tra_SerOri,Tra_BaDaOr,Tra_TabOri
	end


