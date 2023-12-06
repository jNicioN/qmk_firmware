create procedure SOTASASCON (
	@Tas_Numero	char(2),
	@Tas_Fecha	smalldatetime,
	@Tas_Descri	varchar(80),
	@Tas_Moneda	char(2),	
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2) )
	
as


/**************************************************************************/
/** DESCRIPCION: Consulta de Tasas									   ****
**************************************************************************/
/* REFERENCIAS: 									
****************************************************************************
** Modificó:	Gerardo Santos											****
** Fecha:		29/11/2023												****
** Help:																****
** Descripción:	Se crean las consultas C9 y L9.							****
****************************************************************************
** Modificó:	Jonathan Balderas Gauna									****
** Fecha:		23/Marzo/2016											****
** Help:		849927													****
** Descripción:	Se agrega consulta de SOHISTAS a C6						****					  
****************************************************************************
**Modifico :         José Luis Campos                                   ****
**Fecha:          04/Jul/2012                                           ****
**Descripción:    Se agrega el campo Tas_Clasif	y L8		            ****
**Help Desk:      489110                                                ****
****************************************************************************
** Modific¾:		Sergio Trevi±o Jasso		   					    ****
** Fecha:		23/Sep/2011												****
** Help:		      444178										    ****
** Descripci¾n:	Se agrega la condicion Tas_StaAct = 'S' a	            ****
**				todos los querys								        ****
****************************************************************************
** Modific¾:		Ramiro Garza Buentello   					        ****
** Fecha:		25/Abril/2011								            ****
** Help:		      376708										    ****
** Descripci¾n:	Se agrego Consulta 8						            ****
****************************************************************************
** Modific¾:		Gerardo Valladares Mu±iz					        ****
** Fecha:		13/Marzo/2008								            ****
** Help:		      74261										        ****
** Descripci¾n:	Se agrego Lista 7							            ****
****************************************************************************
** Modific¾:		Gerardo Flores Martinez						        ****
** Fecha:		20/Febrero/2007							                ****
** Help:		      72657									        	****
** Descripci¾n:	Se agrego Consulta 7						            ****
****************************************************************************
**				STORE CONVERTIDO						                ****
**	Fecha:		30/Ago/2006								                ****
**	Convirti¾:	Perla J. Abundis Orozco						            ****
****************************************************************************
** Modific¾:		Jorge Ortega RodrÝguez						        ****
** Fecha:		02/Agosto/2006								            ****
** Help:		      00124820.002								        ****
** Descripci¾n:	Se agrego @Tas_NoSePa para seleccion 		            ****
**				parcial, se agreg¾ C6 y L6					            ****
****************************************************************************
**				STORE CONVERTIDO						                ****
**	Fecha:		09/Ago/2005								                ****
**	Convirti¾:	Perla J. Abundis Orozco						            ****
****************************************************************************
** Modific¾:		Jorge M. Maldonado Gonzßlez				            ****
** Fecha:		20/Junio/2005								            ****
** Descripci¾n:	Agregar consulta de tasas p' pagare sin contr.	        ****
****************************************************************************
**áá áááááááááá			STORE CONVERTIDO					            ****
** Convirti¾ :	Eduardo Salazar GutiÚrrez					            ****
** Fecha:		05/Ago/04									            ****
****************************************************************************
** Modific¾:		Jorge M. Maldonado Gonzßlez				            ****
** Fecha:		02/Julio/2004								            ****
** Descripci¾n:	Agregar consulta de tasas para inv. cedes	            ****
****************************************************************************
** Modific¾:		Ra·l Gonzßlez								        ****
** Fecha:		26/Septiembre/2003						            	****
** Descripci¾n:	Se quito el campo Tas_Extemp de donde no	            ****
**				se necesitaba								            ****
****************************************************************************
** Modific¾:		Ra·l Gonzßlez								        ****
** Fecha:		03/Julio/2003								            ****
** Descripci¾n:	Se agreg¾ Tas_Extemp		 				            ****
****************************************************************************
** Modific¾:		Ricardo Elizondo Guerrero					        ****
** Fecha:		09/Mayo/2003								            ****
** Descripci¾n:	Consulta Exportador ArrendaRegio		 	            ****
****************************************************************************
** Modific¾:		FCHIA          								        ****
** Fecha:		07/Nov/01									            ****
** Descripci¾n:	Se agrego a L1 Tas_Fecha y Tas_Valor		            ****
****************************************************************************
** Modific¾:		Sandra Almaguer							            ****
** Fecha:		18/May/01									            ****
** Descripci¾n:	Agregue la lista 2							            ****
****************************************************************************
** Modific¾:		FCHIA          								        ****
** Fecha:		23/Abr/01									            ****
** Descripci¾n:	Se agrego la Moneda (Tas_Moneda)			            ****
****************************************************************************
** Modific¾:		Yadira Salazar Guanajuato					        ****
** Fecha:		27/Octubre/1999							                ****
** Descripci¾n:	Consultas Tipificadas para Visual				        ****
*****************************************************************************/


declare	@Tip_ConTip	char(1),				/* DeclaraciÃÂ³n de Variables */ 
		@Tip_ConCon	char(1),
		@Fot_Numero	char(3),
		@Fec_Tasa   smalldatetime,
		@Hit_Valor2 float

declare	@Str_Vacio	char(1),				/* DeclaraciÃÂ³n de Constantes */
		@Tas_NoSePa	char(1),
		@Fec_Vacia	smalldatetime,
		@Ent_Cero	int,
		@Sta_Activa	char(1),
		@Str_Porcen	char(1),
		@Str_TasCla	char(1),
		@Flo_Cero   float
		
/* Asignacion de Constantes */
select	@Str_Vacio	= '',					/* String Vacio */
		@Tas_NoSePa	= 'N',
		@Fec_Vacia	= '1900-01-01',			/* Fecha Vacia */
		@Ent_Cero	= 0,
		@Sta_Activa	= 'S',					/* Status activa */
		@Str_Porcen	= '%',
		@Str_TasCla = 'C', 					/*Captacion*/
		@Flo_Cero   = 0.00
								
if @Tip_Consul = @Str_Vacio begin	/* Cliente:  FoxPro */
	if (@Tas_Descri = @Str_Vacio) and (@Tas_Numero = @Str_Vacio)
		select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
				Tas_Moneda,	Mon_Descri
			from SOTASAS  noholdlock,
				 SOMONEDA noholdlock
			where	Tas_Moneda	= Mon_Numero
			  and	Tas_SelPar	= @Tas_NoSePa
			  and	Tas_StaAct	= @Sta_Activa
			order by Tas_Descri
			
	else if (@Tas_Descri = @Str_Vacio)
		if (@Tas_Fecha = @Fec_Vacia)
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda,	Mon_Descri, Tas_Extemp
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Numero	= @Tas_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		else
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Numero	= @Tas_Numero 
				  and	Tas_Fecha	= @Tas_Fecha
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
	else
		select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
				Tas_Moneda,	Tas_Descri
			from SOTASAS  noholdlock,
				 SOMONEDA noholdlock
			where	Tas_Moneda	= Mon_Numero
			  and	Tas_SelPar	= @Tas_NoSePa
			  and	Tas_Descri	like @Tas_Descri + @Str_Porcen
			  and	Tas_StaAct	= @Sta_Activa
			order by Tas_Descri

end else begin			/* Cliente:  Visual Basic */
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin		/* 'C':  Consulta */
		if @Tip_ConCon = '1' begin				/* Consulta de Llave Principal */
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '2' begin		/* Consulta de Llave Foranea */
			select	Tas_Numero,	Tas_Descri, Tas_Abrevi, Tas_Valor,	Tas_Moneda
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '3' begin		/* Consulta Exportador Arrendadora */
			select	Tas_Numero,	Tas_Descri, Tas_Abrevi, Tas_Valor,	Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '4' begin		/* Consulta tasas para inversiones cedes */			
			
			select	@Fot_Numero	= substring(ltrim(rtrim(@Tas_Descri)), 1, 3)
			
			select	Tas_Numero,	Tas_Descri, Tas_Abrevi, Tas_Valor,	Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock,
					 CEFORTAS noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Numero	= Fot_Tasa
				  and	Fot_Numero	= @Fot_Numero
				  and	Tas_Numero	= @Tas_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '5' begin		/* Consulta Tasas dispoibles para pagarÃÂ© sin contrato */
			select	Tas_Numero,	Tas_Descri, Tas_Abrevi,	Tas_Valor,	Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock,
					 CRPARAMS noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	patindex((@Str_Porcen + Tas_Numero + @Str_Porcen), Par_TaBaPS) <> @Ent_Cero
				  and	Tas_Moneda	= @Tas_Moneda
				  and	Tas_Numero	= @Tas_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '6' begin		/* Consulta Sin Importar Si Es Sel. Parcial */
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero
				  and	Tas_StaAct	= @Sta_Activa
			select @Fec_Tasa  = convert(date, dateadd(dd, -datepart(dd, getdate()), getdate()))
			exec SOANTFECHAB @Fec_Tasa output, @Ent_Cero, @Tas_NoSePa, @Tas_NoSePa
			/* Consulta la Tasa Histórica del corte del mes anterior */
			select @Hit_Valor2 = Hit_Valor2
				from SOHISTAS noholdlock
				where  Hit_Tasa = @Tas_Numero
					and Hit_Fecha = @Fec_Tasa
			if isnull(@Hit_Valor2, @Flo_Cero) = @Flo_Cero begin
				select @Fec_Tasa = max (Hit_Fecha)
					from SOHISTAS noholdlock
					where Hit_Tasa = @Tas_Numero
						and  Hit_Valor2 != @Flo_Cero
						
				select Hit_Valor2
					from SOHISTAS noholdlock
					where Hit_Tasa = @Tas_Numero
						and Hit_Fecha = @Fec_Tasa
			end
			else begin
				select @Hit_Valor2 Hit_Valor2
			end
		end else if @Tip_ConCon = '7' begin		/* Consulta Todas las tasas */
			select	@Tas_Descri	= ltrim(rtrim(@Tas_Descri)) + @Str_Porcen
			
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda
				from SOTASAS noholdlock
				where	Tas_Descri	like @Tas_Descri + @Str_Porcen
				  and	Tas_Descri != @Str_Vacio
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '8' begin
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	convert(Decimal(20 ,16 ),Tas_Valor) as 'Tas_Valor',	Tas_Fecha,
					Tas_Moneda
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero
				  and	Tas_Fecha	= @Tas_Fecha
				  and	Tas_StaAct	= @Sta_Activa
		end else if @Tip_ConCon = '9' begin		/* Consulta Sin Importar Si Es Sel. Parcial y si esta o no activa*/
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda, Tas_StaAct
				from SOTASAS noholdlock
				where	Tas_Numero	= @Tas_Numero
			select @Fec_Tasa  = convert(date, dateadd(dd, -datepart(dd, getdate()), getdate()))
			exec SOANTFECHAB @Fec_Tasa output, @Ent_Cero, @Tas_NoSePa, @Tas_NoSePa
			/* Consulta la Tasa Histórica del corte del mes anterior */
			select @Hit_Valor2 = Hit_Valor2
				from SOHISTAS noholdlock
				where  Hit_Tasa = @Tas_Numero
					and Hit_Fecha = @Fec_Tasa
			if isnull(@Hit_Valor2, @Flo_Cero) = @Flo_Cero begin
				select @Fec_Tasa = max (Hit_Fecha)
					from SOHISTAS noholdlock
					where Hit_Tasa = @Tas_Numero
						and  Hit_Valor2 != @Flo_Cero
						
				select Hit_Valor2
					from SOHISTAS noholdlock
					where Hit_Tasa = @Tas_Numero
						and Hit_Fecha = @Fec_Tasa
			end
			else begin
				select @Hit_Valor2 Hit_Valor2
			end
		end
	end else begin					/* 'L':  Lista */
		select	@Tas_Descri	= ltrim(rtrim(@Tas_Descri)) + @Str_Porcen
		
		if @Tip_ConCon = '1' begin				/* Lista General */
			select  Tas_Numero,	Tas_Descri, Mon_Descri,	Tas_Valor,	Tas_Fecha
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_Descri	like @Tas_Descri
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
				
		end else if @Tip_ConCon = '2' begin			/* Lista por Moneda */
			select  Tas_Numero,	Tas_Descri, Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Moneda	= @Tas_Moneda
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
		end else if @Tip_ConCon = '3' begin			/* Lista para Cedes */
			select	@Fot_Numero	= substring(ltrim(rtrim(@Tas_Descri)), 1, 3)
			
			select  Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda,	Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock,
					 CEFORTAS noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Numero	= Fot_Tasa
				  and	Fot_Numero	= @Fot_Numero
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
		end else if @Tip_ConCon = '5' begin			/* Lista para Cedes */
			select	Tas_Numero,	Tas_Descri,	Tas_Abrevi,	Tas_Valor,	Tas_Fecha,
					Tas_Moneda,	Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock,
					 CRPARAMS noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	patindex((@Str_Porcen + Tas_Numero + @Str_Porcen), Par_TaBaPS) <> @Ent_Cero
				  and	Tas_Moneda	= @Tas_Moneda
				  and	Tas_SelPar	= @Tas_NoSePa
				  and	Tas_Descri	like @Tas_Descri
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
		end else if @Tip_ConCon = '6' begin			/* Lista Sin Importar Si Es Sel. Parcial */
			select  Tas_Numero,	Tas_Descri, Tas_Abrevi,	Mon_Descri,	Tas_Valor,
					Tas_Fecha
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Descri	like @Tas_Descri
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
		end else if @Tip_ConCon = '7' begin
			select  Tas_Numero,	Tas_Descri, Mon_Descri
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Moneda	= @Tas_Moneda
				  and	Tas_StaAct	= @Sta_Activa
				order by Tas_Numero
				
		/* Consulta por clasificacion de tasa Captacion*/
		end else if @Tip_ConCon = '8' begin
			select  Tas_Numero,	Tas_Fecha,	Tas_Descri, Tas_Moneda,	Mon_Descri,
					Tas_Abrevi
				from SOTASAS  noholdlock,
					 SOCLATAS noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Numero	= Clt_Numero
				  and	Tas_StaAct	= @Sta_Activa
				  and 	Clt_Clasif	= @Str_TasCla
				order by Tas_Numero

		end else if @Tip_ConCon = '9' begin			/* Lista Sin Importar Si Es Sel. Parcial y esta o no activa */
			select  Tas_Numero,	Tas_Descri, Tas_Abrevi,	Mon_Descri,	Tas_Valor,
					Tas_Moneda, Tas_Fecha, Tas_StaAct
				from SOTASAS  noholdlock,
					 SOMONEDA noholdlock
				where	Tas_Moneda	= Mon_Numero
				  and	Tas_Descri	like @Tas_Descri
				order by Tas_Numero
		end
	end
end
