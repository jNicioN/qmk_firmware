create procedure SODIHAEFCON (
	@FechaIni	smalldatetime,
	@FechaFin	smalldatetime,
	@Pais		varchar(3),	
	@NumDias	int output,
	@AsociaFond	char(1),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

declare	@Con_Siguie	char(2),					 /* Declaración de Constantes *//*Declararación de variables*/
		@Con_Anteri	char(2)
		

declare	@Ent_Cero 	smallint,					 /* Declaración de Constantes */
		@Niv_Anida1	smallint,
		@Fin_Si		char(1),
		@Fin_No		char(1),
		@SalFox_Si	char(1),
		@SalFox_No	char(1),
		@TipCon_Sig	char(2),
		@TipCon_Ant	char(2),
		@Aso_FonSi	char(1),
		@Tip_CoFISi	char(2),
		@Tip_CoFIAn	char(2),
		@Ent_Uno	int

select	@Ent_Cero	= 0,			/* Entero en Cero */
		@Niv_Anida1	= 1,			/* Nivel de anidamiento 1	*/
		@Fin_Si		= 'S',			/* Si Considera Fines de Semana */
		@Fin_No		= 'N',			/* No Considera Fines de Semana */
		@SalFox_Si	= 'S',			/* Si Selecciona los Valores como Salida */
		@SalFox_No	= 'N',			/* No Selecciona los Valores como Salida */
		@TipCon_Sig	= 'C1',			/* Utiliza el siguiente dia Hábil como Tipo de Consulta */
		@TipCon_Ant	= 'C2',			/* Utiliza el anterior dia Hábil como Tipo de Consulta */
		@Tip_CoFISi	= 'C3',			/* Consulta día hábil siguiente ligada a países de Fondos de Inversión */
		@Tip_CoFIAn	= 'C4',			/* Consulta día hábil anterior ligada a países de Fondos de Inversión */
		@Aso_FonSi	= 'S',			/* Consulta asociado a los fondos de inversión(soporte multipaís)*/
		@Ent_Uno	= 1				/* Entero en uno */

select	@NumDias = @Ent_Cero

if @AsociaFond	= @Aso_FonSi begin
	/*En estas consultas  la variable @Pais representa el fondo al cual están ligados los países a tomar en consideración para fechas inhábiles*/
	select	@Con_Siguie	= @Tip_CoFISi,
			@Con_Anteri	= @Tip_CoFIAn
end else begin
	/*Consulta para dar soporte a lo desarrollado previamente*/
	select	@Con_Siguie	= @TipCon_Sig,
			@Con_Anteri	= @TipCon_Ant
end

exec SODIAHABCON
	@FechaIni output,	@Ent_Cero,		@Fin_No,		@Pais,			@SalFox_No,
	@Con_Siguie,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,			@SucDestino,	@Modulo

exec SODIAHABCON
	@FechaFin output,	@Ent_Cero,		@Fin_No,		@Pais,			@SalFox_No,
	@Con_Anteri,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
	@SucOrigen,			@SucDestino,	@Modulo

while @FechaIni < @FechaFin begin

	select	@NumDias	= @NumDias + @Ent_Uno
	exec SODIAHABCON
		@FechaIni output,	@Ent_Uno,		@Fin_No,		@Pais,			@SalFox_No,
		@Con_Siguie,		@NumTransac,	@Transaccio,	@Usuario,		@FechaSis,
		@SucOrigen,			@SucDestino,	@Modulo
end

if @@nestlevel = @Niv_Anida1
	select	NumDias	= @NumDias
