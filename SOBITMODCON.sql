create procedure SOBITMODCON (
	@Archivo char(80),
	@Fecha char(10),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as/* Adaptive Server has expanded all '*' elements in the following statement */ 

select SOBITMOD.Bit_Numero, SOBITMOD.Bit_Tipo, SOBITMOD.Bit_Usuari, SOBITMOD.Bit_Fecha, SOBITMOD.Bit_Hora, SOBITMOD.Bit_Archiv, SOBITMOD.Bit_Nombre, SOBITMOD.Bit_Refere, SOBITMOD.Bit_Coment, SOBITMOD.Bit_RegIni, SOBITMOD.Bit_RegCar, SOBITMOD.Bit_RegFin, SOBITMOD.NumTransac, SOBITMOD.Transaccio, SOBITMOD.Usuario, SOBITMOD.FechaSis, SOBITMOD.SucOrigen, SOBITMOD.SucDestino from SOBITMOD where Bit_Archiv=@Archivo and Bit_Fecha=@Fecha
