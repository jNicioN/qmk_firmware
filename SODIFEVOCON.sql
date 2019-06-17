create procedure SODIFEVOCON (
	@Dfe_Fecha	smalldatetime,
	
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario 	char(6),
	@FechaSis 	smalldatetime,
	@SucOrigen 	char(3),
	@SucDestino char(3),
	@Modulo 	char(2))

as

declare	@Internac	int,				/* Declaración de Variables		*/
		@Inversio	int,
		@Mesa		int,
		@Cupon		int,
		@Papel		int,
		@PapelCup	int,
		@Emision	int,
		@Factoraje	int,
		@Document	int,
		@Pasivos	int,
		@Amortiza	int,
		@RegioAmo	int,
		@Credito	int,
		@CarCre		int,
		@NegCar		int,
		@MovSBC		int
		
declare	@Ent_Cero	int,				/* Declaración de Constantes	*/
		@Sta_Negoci	char,
		@Ope_Direct char,
		@Ope_Report char,
		@Sta_Cancel	char,
		@Sta_Proces	char(1)

/* Asignacion de Constantes */
select	@Ent_Cero	= 0,				/* Entero en cero				*/
		@Sta_Negoci	= 'N',				/* Status Negoci				*/
		@Ope_Direct	= 'D',				/* Operacion en Directo 		*/
		@Ope_Report	= 'R',				/* Operacion en Reporto 		*/
		@Sta_Cancel	= 'C',				/* Status Cancelado				*/
		@Sta_Proces	= 'N'				/* Status de en proceso			*/

if not exists (	select	Dfe_Fecha
					from SODIAFES noholdlock
					where	Dfe_Fecha	= @Dfe_Fecha) begin
	select	Err_Codigo	= '000001',
			Err_Mensaj	= 'Fecha no existe en dias festivos',
			Err_Variab	= 'Dfe_Fecha'
	rollback
	return 1
end else begin

	/* Validacion de Internacional */
	select	@Internac	= count(Cov_FecVen)	
		from ITCOMVEN noholdlock
		where	Cov_FecVen	= @Dfe_Fecha
	
	select	@Internac	= isnull(@Internac, @Ent_Cero)
	
	if @Internac > @Ent_Cero begin
		select	Err_Codigo	= '000002',
				Err_Mensaj	= 'Existe en Internacional movimientos con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validación de inversiones */
	select	@Inversio	= count(Inv_Numero)	
		from ININVERS noholdlock
		where	Inv_FecVen	= @Dfe_Fecha
		  and	Inv_Status	= @Sta_Negoci
	
	select	@Inversio	= isnull(@Inversio, @Ent_Cero)
	
	if @Inversio > @Ent_Cero begin
		select	Err_Codigo	= '000003',
				Err_Mensaj	= 'Existe Inversiones con esta fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	
	/* Validacion de Mesa Dinero */
	select	@Mesa	= count(Inv_Numero)	
		from MDINVERS noholdlock
		where	Inv_FecVen	= @Dfe_Fecha
		  and	Inv_Status	= @Sta_Negoci
	
	select	@Mesa	= isnull(@Mesa, @Ent_Cero)
	
	if @Mesa > @Ent_Cero begin
		select	Err_Codigo	= '000004',
				Err_Mensaj	= 'Existe Operacion en Mesa con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end
		
	/* Validacion de Mesa Cupones  */
	select	@Cupon	= count(Cup.Inc_Invers)	
		from MDINVCUP Cup noholdlock,
			 MDINVERS Inv noholdlock
		where	Inc_Invers	= Inv_Numero
		  and	Inv_Operac 	= @Ope_Direct
		  and	Inv_Status	= @Sta_Negoci
		  and	Inc_FecLiq	= @Dfe_Fecha
	
	select	@Cupon	= isnull(@Cupon, @Ent_Cero)
	
	if @Cupon > @Ent_Cero begin
		select	Err_Codigo	= '000005',
				Err_Mensaj	= 'Existe Cupones en Mesa con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion de Mesa Papel */
	select	@Papel	= count(Pap_Numero)	
		from MDPAPEL noholdlock
		where	Pap_Status	<> @Sta_Cancel
		  and	Pap_FecVen	= @Dfe_Fecha
	
	select	@Papel	= isnull(@Papel, @Ent_Cero)
	
	if @Papel > @Ent_Cero begin
		select	Err_Codigo	= '000006',
				Err_Mensaj	= 'Existe Papel en Mesa con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end
	
	/* Validacion */
	select	@PapelCup	= count(Cup.Pac_Papel)	
		from MDPAPCUP Cup noholdlock,
			 MDPAPEL Pap noholdlock
		where	Pac_Papel	= Pap_Numero
		  and	Pap_Operac	= @Ope_Direct
		  and	Pap_PerCup	<> @Ent_Cero
		  and	Pap_Status	<> @Sta_Cancel
		  and	Pac_FecLiq	= @Dfe_Fecha
	
	select	@PapelCup	= isnull(@PapelCup, @Ent_Cero)
	
	if @PapelCup > @Ent_Cero begin
		select	Err_Codigo	= '000007',
				Err_Mensaj	= 'Existe Papel en Mesa con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Emision de Papel*/
	select	@Emision	= count(Emc.Emc_Emisio)	
		from MDPAPEL Pap noholdlock,
			 MDEMISIO Emi noholdlock,
			 MDEMICUP Emc noholdlock
		where	Pap_Emisio	= Emi_Numero
		  and	Emc_Emisio	= Emi_Numero
		  and	Pap_Status	<> @Sta_Cancel
		  and	Pap_Operac	= @Ope_Report
		  and	Emc_FecLiq	= @Dfe_Fecha
	
	select	@Emision	= isnull(@Emision, @Ent_Cero)
	
	if @Emision > @Ent_Cero begin
		select	Err_Codigo	= '000008',
				Err_Mensaj	= 'Existe Emisiones con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Factoraje */
	select	@Factoraje	= count(Fac_Numero)	
		from FAFACTOR noholdlock
		where	Fac_FecVen	= @Dfe_Fecha
		  and	Fac_Status	= @Sta_Negoci
	
	select	@Factoraje	= isnull(@Factoraje, @Ent_Cero)
	
	if @Factoraje > @Ent_Cero begin
		select	Err_Codigo	= '000009',
				Err_Mensaj	= 'Existe Operaciones en Factoraje con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Documentos */
	select	@Document	= count(Doc_Factor)	
		from FADOCUME noholdlock
		where	Doc_FecVen	= @Dfe_Fecha
		  and	Doc_Status	= @Sta_Negoci
	
	select	@Factoraje	= isnull(@Factoraje, @Ent_Cero)
	
	if @Document > @Ent_Cero begin
		select	Err_Codigo	= '000010',
				Err_Mensaj	= 'Existe Documentos con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end
		
	/* Validacion Pasivos */
	select	@Pasivos	= count(Amp_PasDol)	
		from ITPASAMO noholdlock
		where	Amp_FecVen	= @Dfe_Fecha
		  and	Amp_Status	= @Sta_Proces
	
	select	@Pasivos	= isnull(@Pasivos, @Ent_Cero)
	
	if @Pasivos > @Ent_Cero begin	
		select	Err_Codigo	= '000011',
				Err_Mensaj	= 'Existe Pasivos con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Amortización */
	select	@Amortiza	= count(Amo_Credit)	
		from CRAMORTI noholdlock
		where	Amo_FecPag	= @Dfe_Fecha
		  and	Amo_Status	= @Sta_Negoci
	
	select	@Amortiza	= isnull(@Amortiza, @Ent_Cero)
	
	if @Amortiza > @Ent_Cero begin
		select	Err_Codigo	= '000012',
				Err_Mensaj	= 'Existe Amortizaciónes con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Regio Amortización */
	select	@RegioAmo	= count(Amo_Credit)	
		from CRREGAMO noholdlock
		where	Amo_FecPag	= @Dfe_Fecha
		  and	Amo_Status	= @Sta_Negoci
	
	select	@RegioAmo	= isnull(@RegioAmo, @Ent_Cero)
	
	if @RegioAmo > @Ent_Cero begin
		select	Err_Codigo	= '000013',
				Err_Mensaj	= 'Existe Regio Amortizaciónes con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end
		
	/* Validacion Ventanilla */
	select	@MovSBC	= count(Mov_Consec)	
		from VEMOVSBC noholdlock
		where	Mov_FePaFi	= @Dfe_Fecha
	
	select	@MovSBC	= isnull(@MovSBC, @Ent_Cero)
	
	if @MovSBC > @Ent_Cero begin
		select	Err_Codigo	= '000015',
				Err_Mensaj	= 'Existe Movimientos SBC con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end
		
	/* Validacion Cartas de Creditos */
	select	@CarCre	= count(Car_Numero)	
		from ITCARCRE noholdlock
		where	Car_FecVen	= @Dfe_Fecha
	
	select	@CarCre	= isnull(@CarCre, @Ent_Cero)
	
	if @CarCre > @Ent_Cero begin
		select	Err_Codigo	= '000016',
				Err_Mensaj	= 'Existe Cartas de Credito con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end

	/* Validacion Cartas de Negocio */
	select	@NegCar	= count(Neg_Carta)	
		from ITNEGCAR noholdlock
		where	Neg_FecVen	= @Dfe_Fecha
	
	select	@NegCar	= isnull(@NegCar, @Ent_Cero)
	
	if @NegCar > @Ent_Cero begin
		select	Err_Codigo	= '000017',
				Err_Mensaj	= 'Existe Cartas de Negocio con esa fecha ',
				Err_Variab	= 'Dfe_Fecha'
		rollback
		return 1
	end		

	select	Err_Codigo	= '000000',
			Err_Mensaj	= 'Fecha Validada'
end


