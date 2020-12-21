create procedure SOUSNAEXCON (
	@Une_TabCon		varchar(1),

	@Une_Identi		int,								
	@Une_IdeUsu     int,		                       
	@Une_TabOri		varchar(1),						
	@Une_Migrad		varchar(1),
	@Une_Estatu		varchar(1),

	@Use_IdUsEx	int,
	@Use_NoCoUs	varchar(150),
	@Use_NomUsu	varchar(181),
	@Use_ApPaUs	varchar(181),
	@Use_ApMaUs	varchar(181),
	@Use_FecNac smalldatetime,
	@Use_TiIdUs char(1),
	@Use_NumIde	varchar(30),
		
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio char(3), 
	@Usuario	char(6), 
	@FechaSis	smalldatetime, 
	@SucOrigen	char(3),
	@SucDestino char(3),
	@Modulo		char(2))

as

/**
*********************************************************************************
** Descripcion : Consulta de relacion de Usuarios Naciones y Extranjeros CVD ****
*********************************************************************************
** Referencias: 															  	*
*********************************************************************************
** Modifico:	Carlos Copto													*
** Descripcion : Se agrego el retorno del campo Une_Estatu en la consulta 		*
**				 cuando Une_TabCon es 1											*
** Fecha:	18/11/2020															*
** Help:	1376175     														*
*********************************************************************************
** Creo:	Carlos Copto														*
** Fecha:	13/07/2020															*
** Help:	1376175     														*
*********************************************************************************
**/

								/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@Status		int,
		@Ent_Identi	int
		
select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
		
								/* Declaracion de constantes */
declare	@Str_LetraI char(1),
		@Str_LetraD char(1),
		@Str_LetraT char(1),
		@Str_LetraM char(1),
		@Str_LetraE char(1),
		@Str_TipC 	char(1),
		@Str_TipL 	char(1),
		@Str_Vacio 	char(1),
		@Ent_Cero	int,
		@Ent_Uno	int

								/* Asignacion de valores a constantes */
select	@Str_LetraI = 'I',		/* String I: ID de relacion */
		@Str_LetraD = 'D',		/* String D: ID de Usuario */
		@Str_LetraT = 'T',		/* String T: Tabla Origen */
		@Str_LetraE = 'E',		/* String E: Estatus	*/
		@Str_LetraM = 'M',		/* String M: Usuario Migrado */
		@Str_TipC 	= 'C',		/* Tipo Consulta */
		@Str_TipL 	= 'L',		/* Tipo Lista */
		@Str_Vacio  = '',		/* String vacio */
		@Ent_Cero	= 0,		/* Entero cero */
		@Ent_Uno	= 1			/* Entero uno */

if @Une_TabCon = '0' begin   /* Consultas propias a SOUSNAEX */

	if @Tip_ConTip = @Str_TipC begin	/*	CONSULTAS */ 
	
		select @Ent_Identi = @Une_IdeUsu  /* Une_IdeUsu trae el folio de la tabla de relacion  */
		
		/* se obtiene el id de la tabla de extranjeros */
		select @Une_IdeUsu = Une_IdeUsu
		from SOUSNAEX noholdlock inner join SOUSUEXT on Une_IdeUsu = Use_IdUsEx 
		where Une_Identi = @Ent_Identi

		if @Tip_ConCon = @Str_LetraI begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Identi = @Une_Identi		
		end else if @Tip_ConCon = @Str_LetraD begin
			select	Une_Identi,	Une_IdeUsu = right('00000000' + ltrim(rtrim(convert(char, Une_IdeUsu))), 8),
					Une_TabOri, Une_Migrad, Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_IdeUsu = @Une_IdeUsu		
		end 
		
	end else if @Tip_ConTip = @Str_TipL begin  /* LISTAS */
	
		if @Tip_ConCon = @Str_LetraT begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_TabOri = @Une_TabOri	
		 end else if @Tip_ConCon = @Str_LetraM begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Migrad = @Une_Migrad	
		 end else if @Tip_ConCon = @Str_LetraE begin
			select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
					Une_Estatu, Une_FecReg, Une_FecEst
			from 	SOUSNAEX noholdlock
			where	Une_Estatu = @Une_Estatu	
		 end
	end
	
	if @Tip_Consul = @Str_Vacio begin
		select	Une_Identi,	Une_IdeUsu, Une_TabOri, Une_Migrad,
				Une_Estatu, Une_FecReg, Une_FecEst
		from 	SOUSNAEX noholdlock
	end

end else if @Une_TabCon = '1' begin   /* Si la consulta es de compra venta nacional  */
	
	select Une_IdeUsu, Une_Estatu
	from SOUSNAEX noholdlock
	where Une_Identi = @Une_Identi and Une_TabOri = @Une_TabCon

end else if @Une_TabCon = '2' begin   /* Si consulta SOUSUEXT  */

	exec SOUSUEXTCON
		@Use_IdUsEx, @Use_NoCoUs, @Use_NomUsu, @Use_ApPaUs, @Use_ApMaUs,
		@Use_FecNac, @Use_TiIdUs, @Use_NumIde, @Tip_Consul, @NumTransac,	
		@Transaccio, @Usuario,	  @FechaSis,   @SucOrigen,	@SucDestino,	
		@Modulo	

end