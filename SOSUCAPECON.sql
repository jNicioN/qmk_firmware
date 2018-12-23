create procedure SOSUCAPECON(
	@Fecha		smalldatetime,
	@Sap_NumApe int,
	@Tip_Consul	char(2),
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
declare	@Tip_ConTip	char(1),		/* Declaracion de Variables */
		@Tip_ConCon	char(1)
		
declare	@Str_Vacio	char(1)			/* Declaracion de Constantes */

/* Asignacion de Constantes */
select	@Str_Vacio	= ''			/*	String Vacio 		*/

		

	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'L' begin			/* 'l':  Lista */
		if @Tip_ConCon = '1' begin		/*Traer bitacora de la apertura  */
		
		select	Sap_NumApe,	Sap_FeHrAp,	Sap_FecApe,	Suc_Numero,	Suc_Nombre,	
				Sap_Apertu,	Par_FecAct,	Sap_Error,	Sap_Mensaj,	@Fecha FechaAperturar,
				-----------condicion de apertura
				case when SOPARAMS.Par_FecAct>= @Fecha
						and	SOPARAMS.Par_FecAct< (select  dateadd(day, +1,@Fecha ) )   
							then 'A' 
					else 'N'
				end	 as Sap_Status,	isnull(Suc_ApeSab, 'N') as Suc_ApeSab,	Suc_UltDia
				---------------condicion de apertura		 
					from  SOSUCAPE noholdlock,
						  SOSUCURS noholdlock,
						  SOPARAMS noholdlock		
						where	Suc_Numero	*= Sap_Sucurs
							and	Suc_Numero	= Par_Sucurs
							and Sap_NumApe	= @Sap_NumApe
							and Sap_FecApe	>= @Fecha
							and Sap_FecApe	< (select  dateadd(day, +1,@Fecha) )
							
					order by Sap_NumApe	,	SOSUCAPE.FechaSis,	Sap_Status desc,	Suc_Numero
		end else if @Tip_ConCon = '2' begin							
			----traer bitacora de  los movimiento del dia 
			select	Sap_NumApe,	Sap_FeHrAp,	Sap_FecApe,	Suc_Numero,	Suc_Nombre,	
					Sap_Apertu,	Sap_FecSuc,	Sap_Error,	Sap_Mensaj,
					case when SOSUCAPE.Sap_FecSuc>= SOSUCAPE.Sap_FecApe
						and	SOSUCAPE.Sap_FecSuc< (select  dateadd(day, +1,SOSUCAPE.Sap_FecApe ) )   
							then 'A' 
						else 'N'
					end	 as Sap_Status,	SOSUCAPE.FechaSis as FechaSis,	Suc_UltDia
				from SOSUCAPE noholdlock,
					 SOSUCURS noholdlock,
					 SOPARAMS noholdlock		
					where	Sap_Sucurs	*= Suc_Numero
						and		Sap_Sucurs	*= Par_Sucurs
						and 	Sap_FecApe	>= @Fecha
						and 	Sap_FecApe	< (select  dateadd(day, +1,@Fecha ) )
				
				order by Sap_NumApe	,	FechaSis,	Sap_Status desc,	Suc_Numero		
		end else if @Tip_ConCon = '3' begin		
							
			----traer bitacora de ultimo movimiento del dia 
			select	Sap_NumApe,	Sap_FeHrAp,	Sap_FecApe,	Suc_Numero,	Suc_Nombre,	
					Sap_Apertu,	Sap_FecSuc,	Sap_Error,	Sap_Mensaj,
					case when SOSUCAPE.Sap_FecSuc>= SOSUCAPE.Sap_FecApe
						and	SOSUCAPE.Sap_FecSuc< (select  dateadd(day, +1,SOSUCAPE.Sap_FecApe ) )   
							then 'A' 
						else 'N'
					end	 as Sap_Status,	SOSUCAPE.FechaSis as FechaSis,	Suc_UltDia	 	 
				from SOSUCAPE noholdlock,
					 SOSUCURS noholdlock,
					 SOPARAMS noholdlock		
					where	Sap_Sucurs	*= Suc_Numero
						and		Sap_Sucurs	*= Par_Sucurs
						and 	Sap_FecApe	>=@Fecha
						and 	Sap_FecApe	< (select  dateadd(day, +1,@Fecha) )
						and 	Sap_NumApe	= (select  max (Sap_NumApe) 
													from SOSUCAPE
														where	Sap_FecApe	>=@Fecha		
															and 	Sap_FecApe	< (select  dateadd(day, +1,@Fecha) ) 
											  )
			
					 
				order by Sap_NumApe	,	FechaSis,	Sap_Status desc,	Suc_Numero

		end 
	end
