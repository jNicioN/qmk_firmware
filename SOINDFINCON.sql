create procedure SOINDFINCON (
	@Ind_Consul	char(2),		/* Indicador de Consulta */		

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as
/******************************************************************/
/* DESCRIPCION: consulta para monitoreo de inversiones y metales  */
/*******************************************************************
** Modifico:	Marco Pardo										****
** Fecha:		08/08/2018										****
** Help:		1143879  										****
** Descripción:	Lista de tipo de cambio por sucursal (region)	****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:		26/04/2016										****
** Help:		867250  										****
** Descripción:	Se toman las UDIS de SOHISMON en la consulta 04 ****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:		19/04/2016										****
** Help:		862262  										****
** Descripción:	Se toman las UDIS de SOHISMON en la consulta 04 ****
*******************************************************************
** Modifico:	Estela Mendoza G								****
** Fecha:	27/Agosto/2014										****
** Help:	641171  Banda indicadores Intranet					****
** DescripciÃ³n:	En Consulta '90' se eliminan tasas CPP y TIIP   ****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:	19/Junio/2013										****
** Help:	566398  app movil									****
** DescripciÃ³n:	Se realiza cambio para agregar venta ventanilla ****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:	13/Junio/2013										****
** Help:	566398  app movil									****
** DescripciÃ³n:	Se realiza cambio para ordenamiento de valor 	****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:	11/Diciembre/2012									****
** Help:	519527  app movil									****
** DescripciÃ³n:	Se realiza cambio para el valor del dolar y euro****
********************************************************************
** Modifico:	Edgar Contreras									****
** Fecha:	29/noviembre/2012									****
** Help:	442011 app movil									****
** DescripciÃ³n:	Se agrego consulta para mostrar los metales		****
********************************************************************
** Modifico:	Tufik Aued										****
** Fecha:	19/Ene/2012											****
** Help:	435274 Monitor financiero							****
** DescripciÃ³n:	Se agrego consulta para mostrar los tipos de 	****
**				cambiorequeridos para monitor financiero		****
********************************************************************
** CreÃ³:		Arnoldo              							****
** Fecha:		08/Mar/06										****
** Help:		No. de Help al que pertenece la modificaciÃ³n	****
********************************************************************

Consulta de Indicadores Financieros para desplegar en la Intranet

	Ind_Consul	Indicador	
	----------	---------------------------------------
	L1		Lista de tipo de cambio por sucursal (region)
	01		Tipo de Cambio de DÃ³lares
	02		UDI's
	03		Tasas (CPP, CETES, TIIP, LIBOR 30, TIIE 28 DÃ­as)

	31		Tasa: CPP
	32		Tasa: CETES
	33		Tasa: TIIP
	34		Tasa: LIBOR 30		
	35		Tasa: TIIE 28 DÃ­as

	90		Lista Num. 01 de Indices Financieros (Tradicional)
*/


declare
	@Tip_ConTip char(1),	-- Tipo de tipo consulta
	@Tip_ConCon char(1),	-- Tipo de consulta
	@Mon_Compra money,		-- Compra
	@Mon_Venta money		-- Venta 

declare
	@Mon_Dolar	char(2),
	@Mon_UDI	char(2),
	@Tas_CPP	char(2),
	@Tas_CETES	char(2),
	@Tas_TIIP	char(2),
	@Tas_LIB30	char(2),
	@Tas_TIIE	char(2),

	@Ind_Dolar	char(2),
	@Ind_UDIs	char(2),
	@Ind_Tasas	char(2),
	@Ind_CPP	char(2),
	@Ind_CETES	char(2),
	@Ind_TIIP	char(2),
	@Ind_LIB30	char(2),
	@Ind_TIIE	char(2),
	@Ind_Lis01	char(2),
	@Ind_InMoFi	char(2),
	@Mon_Euro	char(2),
	@Met_Oro	char(2), 
	@Met_Plata  char(2), 
	@Met_Cen	char(2),
	@Met_CenDen money,
	@Met_PlaDen money,
	@Met_Metal  char(2),
	@Ent_Cero   int,
	@Ent_Uno	int,
	@Ent_Dos	int,

	@Fec_MaxHis	smalldatetime,
	@Str_Vacio	char(1),
	@Can_Cero	double precision,
	
	@Tip_Lista char(1),
	@Str_TiCaDo char(17),
	@Str_TipCam char(11),
	@Str_Uno char(1),
	@Str_OnLiPl char(19),
	@Str_Metale char(7),
	@Str_Centen char(10),
	@Str_ValUDI char(12),
	@Str_UDI char(3),
	@Str_OnzOro char(8),
	@Mon_Cero money,
	@Str_SucGen char(3)

select
	@Mon_Dolar	= '02',			/* SOMONEDA: 02 Dolares		*/
	@Mon_UDI	= '99',			/* SOMONEDA: 99 UDI's		*/
	@Met_Metal	= '98',			/* SOMONEDA: 98 metales		*/
	@Mon_Euro	= '28',			/* SOMONEDA: 28 Euros		*/
	@Tas_CPP	= '01',			/* Tasa: CPP			*/
	@Tas_CETES	= '02',			/* Tasa: CETES			*/
	@Tas_TIIP	= '03',			/* Tasa: TIIP			*/
	@Tas_LIB30	= '08',			/* Tasa: LIBOR 30		*/
	@Tas_TIIE	= '09',			/* Tasa: TIIE 28 DÃ­as		*/

	@Ind_Dolar	= '01',			/* Indicador: Tipo de Cambio de DÃ³lares	*/
	@Ind_UDIs	= '02',			/* Indicador: UDI's			*/
	@Ind_Tasas	= '03',			/* Indicador: Tasas (CPP, CETES, TIIP, LIBOR 30, TIIE 28 DÃ­as) */
	@Ind_CPP	= '31',			/* Indicador: Tasa CPP			*/
	@Ind_CETES	= '32',			/* Indicador: Tasa CETES		*/
	@Ind_TIIP	= '33',			/* Indicador: Tasa TIIP			*/
	@Ind_LIB30	= '34',			/* Indicador: Tasa LIBOR 30		*/
	@Ind_TIIE	= '35',			/* Indicador: Tasa TIIE 28 DÃ­as		*/
	@Ind_Lis01	= '90',			/* Indicador: Lista Num. 01 de Indices Financieros (Tradicional) */
	@Ind_InMoFi	= '04',			/* Indicador Monitor Financiero: Dolar, Euro, Udis, Cetes 28, TIIE */
	@Fec_MaxHis	= '1900-01-01',		/* Fecha MÃ¡xima en el Historial de Monedas	*/
	@Str_Vacio	= '',			/* String vacio				*/
	@Can_Cero	= 0.00,			/* Cantidad en Ceros 			*/
	@Met_Oro	= '51', 				-- Metal Oro
	@Met_Plata  = '60', 				-- Metal Plata
	@Met_Cen	= '50',					-- Metal Centenario
	@Met_CenDen = 50,					-- Metal Centenario Denominación
	@Met_PlaDen = 1,					-- Metal Plata Denominación
	@Ent_Cero   = 0,					-- Entero Cero
	@Ent_Uno	= 1,					-- Entero Uno
	@Ent_Dos	= 2,					-- Entero Dos
	
	@Tip_Lista 	= 'L1',					-- Tipo Lista
	@Str_Uno	= '1',					-- String uno
	@Str_TiCaDo = 'Tipo Cambio Dolar', 	-- Tipo de cambio de dolar.
	@Str_TipCam = 'Tipo Cambio', 		-- Tipo de cambio
	@Str_OnLiPl = 'Onza Libertad Plata',-- Onza libertad Plata
	@Str_Metale = 'METALES',			-- Metales
	@Str_Centen = 'Centenario',			-- Centenario
	@Str_ValUDI = 'Valor de UDI',		-- Valor UDI
	@Str_UDI = 'UDI',					-- UDI
	@Str_OnzOro = 'Onza Oro',			-- Onza Oro
	@Mon_Cero	= $0.00,				-- Entero Corto en Cero
	@Str_SucGen = '000'					-- Sucursal General

select	@FechaSis	= getdate()		/* Fecha del Sistema */

select	@Tip_ConTip	= substring(@Ind_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Ind_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Tip_Lista begin		/* 'L':  Consulta */
	if @Tip_ConCon = @Str_Uno begin	/* Lista de tipo de cambio por sucursal (region) */
	
		create table #ListaMonitorFinanciero (
			Ind_Nombre char(11),
			Ind_Abrevi char(50),
			Ind_DocCom money,
			Ind_DocVen money,
			Ind_Fecha  smalldatetime,
			Ind_Moneda char(2),
			Ind_Tasa   char(1),
			Ind_FecHor smalldatetime,
			Ind_Order  char(3),
			Ind_TiCaDi char(3)
		)
		
		-- Insertar Sucusal que pertenezcan a grupo
		insert into #ListaMonitorFinanciero
		select 	
				@Str_TipCam,
				SUC.Suc_Nombre, 
				@Mon_Cero,				
				@Mon_Cero,
				@FechaSis,
				isnull(DTC.Dtc_Moneda,@Mon_Dolar),
				@Str_Vacio,
				@FechaSis,
				PAR.Par_Sucurs,
				PAR.Par_TiCaDi
		from SOPARAMS PAR noholdlock 
		inner join SOSUCURS SUC noholdlock on PAR.Par_Sucurs = SUC.Suc_Numero 
		left join ITDETICA DTC noholdlock on DTC.Dtc_Numero = PAR.Par_TiCaDi
		where PAR.Par_TiCaDi <> @Str_Vacio
		order by PAR.Par_Sucurs
		
		delete from #ListaMonitorFinanciero
			where Ind_Moneda = @Mon_Euro		
		
		-- Inserto Euros que estan en sucursal
		insert into #ListaMonitorFinanciero
			select 
				Ind_Nombre = NUE.Ind_Nombre,
				Ind_Abrevi = NUE.Ind_Abrevi,
				Ind_DocCom = NUE.Ind_DocCom,
				Ind_DocVen = NUE.Ind_DocVen,
				Ind_Fecha = NUE.Ind_Fecha,
				Ind_Moneda = @Mon_Euro,
				Ind_Tasa = NUE.Ind_Tasa,
				Ind_FecHor = NUE.Ind_FecHor,
				Ind_Order = NUE.Ind_Order,
				Ind_TiCaDi = NUE.Ind_TiCaDi
			from #ListaMonitorFinanciero NUE
		
		-- Insertar Sucusal con Tipo de Cambio
		update #ListaMonitorFinanciero set
				Ind_DocCom = round(convert(decimal(7, 2), Mon_EfeCom) + 
					convert(decimal(7, 2), isnull(DTC.Dtc_Compra, @Mon_Cero)), @Ent_Dos),
				Ind_DocVen = round(convert(decimal(7, 2), Mon_EfeVen) + 
					convert(decimal(7, 2), isnull(DTC.Dtc_Venta, @Mon_Cero)), @Ent_Dos)
		from #ListaMonitorFinanciero LIS noholdlock 
		left join ITDETICA DTC noholdlock on DTC.Dtc_Numero = LIS.Ind_TiCaDi and DTC.Dtc_Moneda = LIS.Ind_Moneda
		left join SOMONEDA MON noholdlock on MON.Mon_Numero = LIS.Ind_Moneda
			
		-- Muestra información
		select 	Ind_Nombre, Ind_Abrevi, Ind_DocCom, Ind_DocVen, Ind_Fecha, 
				Ind_Moneda, Ind_Tasa, Ind_FecHor, Ind_Order 
			from #ListaMonitorFinanciero
		
		return 0
	end
end

if @Ind_Consul = @Ind_Dolar 			/* Indicador: Tipo de Cambio de DÃ³lares	*/
  begin
	select	Mon_Descri, Mon_EfeCom, Mon_EfeVen
		from SOMONEDA noholdlock
		where	Mon_Numero	= @Mon_Dolar
  end
else
  if @Ind_Consul = @Ind_UDIs 			/* Indicador: UDI's			*/
    begin
		/* Buscar Fecha Maxima de Historial de Moneda */
		select	@Fec_MaxHis	= max(Him_Fecha)
			from SOHISMON noholdlock
			where	Him_Moneda	= @Mon_UDI
			  and 	Him_Fecha	<= @FechaSis

		/* Buscar para esta moneda el ultimo registro historico */
		select	Him_EfeVen
			from SOHISMON noholdlock
			where	Him_Moneda	= @Mon_UDI
			  and	Him_Fecha	= @Fec_MaxHis 
    end		
  else
    if @Ind_Consul = @Ind_Tasas 		/* Indicador: Tasas (CPP, CETES, TIIP, LIBOR 30, TIIE 28 DÃ­as) */
      begin
     	select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
				Tas_Moneda, Tas_Extemp
			from SOTASAS noholdlock
			where	Tas_Numero	IN (@Tas_CPP, @Tas_CETES, @Tas_TIIP, @Tas_LIB30, @Tas_TIIE)

      end
    else
      if @Ind_Consul >= @Ind_CPP and @Ind_Consul <= @Ind_TIIE
		  begin
			if @Ind_Consul = @Ind_CPP 			/* Indicador: Tasa CPP			*/
			  begin
					select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
							Tas_Moneda, Tas_Extemp
						from SOTASAS noholdlock
						where	Tas_Numero	= @Tas_CPP
			  end
			else if @Ind_Consul = @Ind_CETES 		/* Indicador: Tasa CETES		*/
			  begin
					select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
							Tas_Moneda, Tas_Extemp
						from SOTASAS noholdlock
						where	Tas_Numero	= @Tas_CETES
			  end
			else if @Ind_Consul = @Ind_TIIP 		/* Indicador: Tasa TIIP			*/
			  begin
					select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
							Tas_Moneda, Tas_Extemp
						from SOTASAS noholdlock
						where	Tas_Numero	= @Tas_TIIP
			  end
			else if @Ind_Consul = @Ind_LIB30 		/* Indicador: Tasa LIBOR 30		*/
			  begin
					select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
							Tas_Moneda, Tas_Extemp
						from SOTASAS noholdlock
						where	Tas_Numero	= @Tas_LIB30
			  end
			else if @Ind_Consul = @Ind_TIIE 		/* Indicador: Tasa TIIE 28 DÃ­as		*/
			  begin
					select 	Tas_Numero, Tas_Descri, Tas_Abrevi, Tas_Valor, Tas_Fecha, 
							Tas_Moneda, Tas_Extemp
						from SOTASAS noholdlock
						where	Tas_Numero	= @Tas_TIIE
			  end
		  end
      else 
		if @Ind_Consul = @Ind_Lis01
		  begin
			/* Buscar Fecha Maxima de Historial de Moneda */
			select	@Fec_MaxHis = max(Him_Fecha)
				from SOHISMON noholdlock
				where	Him_Moneda	= @Mon_UDI 
				  and	Him_Fecha	<= @FechaSis
	
	
			select 	Ind_Nombre = @Str_TiCaDo, 
					Ind_Abrevi = Mon_Descri, 
					Ind_Valor1 = Mon_EfeCom, 
					Ind_Valor2 = Mon_EfeVen,
					Ind_Fecha  = Mon_Fecha,
					Ind_Moneda = Mon_Numero,
					Ind_Campo1 = @Str_Vacio,
					Ind_Campo2 = @Str_Vacio
				from SOMONEDA noholdlock
				where	Mon_Numero	= @Mon_Dolar
			union
			select 	Ind_Nombre = @Str_ValUDI,	/* Buscar para esta moneda el ultimo registro historico */
					Ind_Abrevi = @Str_UDI,
					Ind_Valor1 = Him_EfeVen,	
					Ind_Valor2 = @Can_Cero,
					Ind_Fecha  = Him_Fecha,
					Ind_Moneda = Him_Moneda,
					Ind_Campo1 = @Str_Vacio,
					Ind_Campo2 = @Str_Vacio
				from SOHISMON noholdlock
				where	Him_Moneda	= @Mon_UDI
				  and	Him_Fecha 	= @Fec_MaxHis 
			union
			select 	Ind_Nombre = Tas_Descri,
					Ind_Abrevi = Tas_Abrevi, 
					Ind_Valor1 = Tas_Valor, 
					Ind_Valor2 = @Can_Cero,
					Ind_Fecha  = Tas_Fecha,
					Ind_Moneda = Tas_Moneda,
					Ind_Campo1 = Tas_Numero, 
					Ind_Campo2 = Tas_Extemp
				from SOTASAS noholdlock
				where	Tas_Numero IN (@Tas_CETES, @Tas_LIB30, @Tas_TIIE)
				order by Ind_Abrevi		
		  end
if @Ind_Consul = @Ind_InMoFi
  begin
	/* Consulta de indicadores para monitor financiero.*/
	select	@Fec_MaxHis = max(Him_Fecha)
				from SOHISMON noholdlock
				where	Him_Moneda	= @Mon_UDI 
				  and	Him_Fecha	<= @FechaSis

	select 	Ind_Nombre = @Str_TipCam, 
			Ind_Abrevi = Mon_Descri, 
			Ind_DocCom = Him_EfeCom , 
			Ind_DocVen = Him_EfeVen ,
			Ind_Fecha  = Him_Fecha,
			Ind_Moneda = Mon_Numero,
			Ind_Tasa   = @Str_Vacio,
			Ind_FecHor = getdate(),
			Ind_Order  = @Can_Cero	
		from SOHISMON noholdlock
		inner join SOMONEDA noholdlock on Mon_Numero = Him_Moneda
			where	Him_Moneda	= @Mon_UDI
			  and	Him_Fecha 	= @Fec_MaxHis 
	union
	select 	Ind_Nombre = @Str_TipCam, 
			Ind_Abrevi = Mon_Descri, 
			Ind_DocCom = Mon_EfeCom , 
			Ind_DocVen = Mon_EfeVen ,
			Ind_Fecha  = Mon_Fecha,
			Ind_Moneda = Mon_Numero,
			Ind_Tasa   = @Str_Vacio,
			Ind_FecHor = getdate(),
			Ind_Order  = @Can_Cero	
		from SOMONEDA noholdlock
		where	Mon_Numero	in (@Mon_Dolar, @Mon_Euro)
	union
	select 	Ind_Nombre = Tas_Descri,
			Ind_Abrevi = Tas_Abrevi, 
			Ind_DocCom = Tas_Valor, 
			Ind_DocVen = @Can_Cero,
			Ind_Fecha  = Tas_Fecha,
			Ind_Moneda = @Str_Vacio,
			Ind_Tasa   = Tas_Numero,
			Ind_FecHor = getdate(),
			Ind_Order  = @Can_Cero
		from SOTASAS noholdlock
		where	Tas_Numero	IN (@Tas_CETES, @Tas_TIIE)
	union
	select 	Ind_Nombre = @Str_Metale ,
			Ind_Abrevi = @Str_Centen, 
			Ind_DocCom = Dme_ComVen, 
			Ind_DocVen = Dme_VenVen,
			Ind_Fecha  = @Str_Vacio,
			Ind_Moneda = @Met_Metal,
			Ind_Tasa   = @Str_Vacio,
			Ind_FecHor = getdate(),
			Ind_Order  = @Ent_Dos
		FROM ESDENMET noholdlock
		where	Dme_Moneda	= @Met_Cen
		  and	Dme_Denomi	= @Met_CenDen			
	union
	select 	Ind_Nombre = @Str_Metale,
			Ind_Abrevi = @Str_OnLiPl, 
			Ind_DocCom = Dme_ComVen, 
			Ind_DocVen = Dme_VenVen,
			Ind_Fecha  = @Str_Vacio,
			Ind_Moneda = @Met_Metal,
			Ind_Tasa   = @Str_Vacio,
			Ind_FecHor = getdate(),
			Ind_Order  = @Ent_Cero
		FROM ESDENMET noholdlock
		where	Dme_Moneda	= @Met_Plata
		  and	Dme_Denomi	= @Met_PlaDen	
	union
	select 	Ind_Nombre = @Str_Metale,
			Ind_Abrevi = @Str_OnzOro, 
			Ind_DocCom = Dme_ComVen, 
			Ind_DocVen = Dme_VenVen,
			Ind_Fecha  = @Str_Vacio,
			Ind_Moneda = @Met_Metal,
			Ind_Tasa   = @Str_Vacio,
			Ind_FecHor = getdate(),
			Ind_Order  = @Ent_Uno
		FROM ESDENMET noholdlock
		where	Dme_Moneda	= @Met_Oro
		  and	Dme_Denomi	= @Met_PlaDen	
	order by Ind_Nombre		  	
  end
else 
  begin  /* Marcar Error Desconocido */
	select	Err_Codigo	= '999999', 
			Err_Mensaj	= 'Error en Indicador de Consulta'
	return 1
  end
