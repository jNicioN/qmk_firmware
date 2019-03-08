create procedure SOESTFINACT (
   @Esf_Numero	int,
   @Esf_PerNum	int, 
   @Esf_Solici	int,
   @Tic_ClEsFi	int,
   @Esf_Filtro	varchar(1000),
   @Esf_EsEsFi	int,
   @Esf_ConAct  int,
   @Esf_AplIca	bit,
   @Esf_Icap	numeric(10,2),
   @Esf_CapNet	numeric(10,2),
   @Esf_AcSuRi	numeric(10,2),
   @Esf_TipSol	int,
   @Esf_TipLiq	int,
   @Esf_TipEfi	int,
   @Esf_Status	bit,
   @Tip_Actual char(1),
   @NumTransac char(10),
   @Transaccio char(3),
   @Usuario char(6),
   @FechaSis smalldatetime,
   @SucOrigen char(3),
   @SucDestino char(3),
   @Modulo char(2)) 
as

/****************************************************************/
/** DESCRIPCION: Actualizacion de registros de Estados			*/
/**				Financieros en la tabla SOESTFIN				*/
/****************************************************************/
/** Modifico:	Edwin Santiago								    */
/** Fecha:		27/11/2018                               		*/
/** Descripcion: Se agrega campo Esf_ConAct						*/
/** Help:		1074432 					 					*/
/****************************************************************/
/** Creo:		Felipe Castillo									*/
/** Fecha:		19/05/2017                               		*/
/** Help:		929417 					 						*/
/****************************************************************/

/* Declaracion de variables  */
declare @Str_Filtro varchar(1000), 	/*Filtro*/
		@Ent_Posici numeric(20),   	/*Posicion*/
		@Str_EstFin varchar(50),   	/*Estado Financiero*/
		@Str_Vacio varchar(2),     	/*String vacio*/
		@Str_Coma varchar(2)       /*String coma*/
		
/* Declaracion de constantes*/
declare	@Tip_ActA	char(1), 		/*	Actualiza el valor de status para visualizar o no el estado financiero*/
		@Tip_ActB	char(1), 		/*  Tipo de Actualizacion B*/
		@Tip_ActC	char(1), 		/*  Tipo de Actualizacion C*/
		@Tip_ActD	char(1), 		/*  Tipo de Actualizacion D*/
		@Tip_ActE	char(1), 		/*  Tipo de Actualizacion E*/
		@Ent_Cero	int,     		/*  ENTERO CERO*/
		@Ent_Uno	int      		/*  ENTERO UNO*/

/* Asignacion de Constantes */
select	@Tip_ActA = 'A',	
		@Tip_ActB = 'B',    
		@Tip_ActC = 'C',	
		@Tip_ActD = 'D', 	
		@Tip_ActE = 'E',	
		@Ent_Cero = 0,      
		@Ent_Uno = 1		
		
if @Tip_Actual = @Tip_ActA begin
	
	create table #TemporalEstadosFinancieros (Efi_Numero int)
  
	SET @Str_Filtro = @Esf_Filtro,
		@Ent_Cero = 0,
		@Str_Vacio = '',
		@Str_Coma = ','
	
	SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
	if (@Ent_Posici = @Ent_Cero and @Esf_Filtro <> @Str_Vacio) begin
			insert into #TemporalEstadosFinancieros(Efi_Numero)
			values(convert(int, @Esf_Filtro))
	end
	while @Ent_Posici <> @Ent_Cero begin
		SET @Str_EstFin = LEFT(@Str_Filtro, @Ent_Posici-1)
		SET @Str_Filtro = stuff(@Str_Filtro, 1, @Ent_Posici, NULL)
		SET @Ent_Posici = charindex(@Str_Coma, @Str_Filtro)
		
		if (@Ent_Posici = @Ent_Cero) begin
			insert into #TemporalEstadosFinancieros(Efi_Numero)
			values(convert(int, @Str_Filtro))
		end
		
		insert into #TemporalEstadosFinancieros(Efi_Numero)
		values(convert(int, @Str_EstFin))
	end
	
	if (@Ent_Posici = @Ent_Cero) begin
		update SOESTFIN set 
			Esf_Status = @Ent_Cero,
			Esf_EsEsFi = @Esf_EsEsFi,
		
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino 	= @SucDestino
			where Esf_Numero IN (select efi.Efi_Numero from #TemporalEstadosFinancieros efi )
	end
	
	drop table #TemporalEstadosFinancieros
	
	select	Err_Codigo	= '000000',	Err_Mensaj	= 'Registro Actualizado'
end

if @Tip_Actual = @Tip_ActB begin
	update SOESTFIN set
		Esf_EsEsFi	= @Esf_EsEsFi,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino 	= @SucDestino
		where Esf_Numero = @Esf_Numero

	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end

if @Tip_Actual = @Tip_ActC begin
	update SOESTFIN set
		Esf_ConAct   = @Esf_ConAct,
		Esf_AplIca	= @Esf_AplIca,
		Esf_Icap	= @Esf_Icap,
		Esf_CapNet	= @Esf_CapNet,
		Esf_AcSuRi	= @Esf_AcSuRi,
		Esf_TipSol	= @Esf_TipSol,
		Esf_TipLiq	= @Esf_TipLiq,
		Esf_TipEfi	= @Esf_TipEfi,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino 	= @SucDestino
		where Esf_Numero = @Esf_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end

if @Tip_Actual = @Tip_ActD begin
	update SOESTFIN set
		Esf_UsuMod	= @Usuario,
		Esf_FecMod	= @FechaSis,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino 	= @SucDestino
		where Esf_Numero = @Esf_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end

if @Tip_Actual = @Tip_ActE begin
	update SOESTFIN set
		Esf_Status	= @Esf_Status,
		Esf_UsuMod	= @Usuario,
		Esf_FecMod	= @FechaSis,
		
		NumTransac	= @NumTransac,
		Transaccio	= @Transaccio,
		Usuario		= @Usuario,
		FechaSis	= @FechaSis,
		SucOrigen	= @SucOrigen,
		SucDestino 	= @SucDestino
		where Esf_Numero = @Esf_Numero
	
	select	Err_Codigo	= '000000',	
			Err_Mensaj	= 'Registro Actualizado'
end