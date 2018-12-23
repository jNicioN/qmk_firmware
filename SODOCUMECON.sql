create procedure SODOCUMECON (
	@Doc_Cuenta	char(15),
	@Doc_Tipo	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

	Select 	Doc_Cuenta, Doc_Apoder, Doc_Numero, Doc_Tipo,   Doc_NumEsc,
			Doc_Fecha = convert(char,Doc_Fecha,103),
		    Doc_Notari, Doc_NumNot, Doc_Ciudad, Doc_Estado, Doc_NumReg,
		    Doc_Volume, Doc_Libro, Doc_FecReg= convert(char,Doc_FecReg,103),
		    Doc_EntReg, Doc_LocReg, Doc_Descri, Loc_Ciudad = Loc_Nombre
		INTO #TEMPORAL
		from SODOCUME (index SODOCUME), CLLOCALI noholdlock
			where	Doc_Cuenta 	= @Doc_Cuenta
				and Doc_Tipo 	= @Doc_Tipo
				and Doc_Ciudad  *= Loc_Numero

	/* Adaptive Server has expanded all '*' elements in the following statement */ Select T1.Doc_Cuenta, T1.Doc_Apoder, T1.Doc_Numero, T1.Doc_Tipo, T1.Doc_NumEsc, T1.Doc_Fecha, T1.Doc_Notari, T1.Doc_NumNot, T1.Doc_Ciudad, T1.Doc_Estado, T1.Doc_NumReg, T1.Doc_Volume, T1.Doc_Libro, T1.Doc_FecReg, T1.Doc_EntReg, T1.Doc_LocReg, T1.Doc_Descri, T1.Loc_Ciudad,Loc_Nombre
		from #TEMPORAL T1, CLLOCALI T2 noholdlock			
			where Doc_LocReg  *= Loc_Numero
