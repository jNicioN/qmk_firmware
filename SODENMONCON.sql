create procedure SODENMONCON	(
	@Dem_Moneda	char(2),
	@Dem_Denomi	money,
	
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/* Declaración de constantes */
declare	@Mon_Cero	money,
		@Str_Vacio	char(1)		

/* Asignación de valores a constantes */
select	@Mon_Cero	= $0.00,					/* Campo money en ceros */
		@Str_Vacio	= ''						/* Campo string vacio */
		
select	@Dem_Denomi	= isnull(@Dem_Denomi,@Mon_Cero)
select	@Dem_Moneda = isnull(@Dem_Moneda,@Str_Vacio)

if @Dem_Denomi = @Mon_Cero begin
	if @Dem_Moneda = @Str_Vacio begin
		select	Dem_Moneda,	Dem_Denomi,	Dem_Descri,
				Den_TCCom	= @Mon_Cero,
				Den_TCVen	= @Mon_Cero
			into #Denominaciones
			from	SODENMON noholdlock
			order by Dem_Moneda, Dem_Denomi desc
	
		update #Denominaciones set
			Den_TCCom	= Dme_ComVen,
			Den_TCVen	= Dme_VenVen
			from #Denominaciones,
				 ESDENMET noholdlock
			where	Dme_Moneda	= Dem_Moneda
			  and	Dme_Denomi	= Dem_Denomi	 
		
		/* Adaptive Server has expanded all '*' elements in the following statement */ select	#Denominaciones.Dem_Moneda, #Denominaciones.Dem_Denomi, #Denominaciones.Dem_Descri, #Denominaciones.Den_TCCom, #Denominaciones.Den_TCVen
			from #Denominaciones  
			order by Dem_Moneda, Dem_Denomi desc
		
	end else/* Adaptive Server has expanded all '*' elements in the following statement */ 
		select	SODENMON.Dem_Moneda, SODENMON.Dem_Denomi, SODENMON.Dem_Descri, SODENMON.NumTransac, SODENMON.Transaccio, SODENMON.Usuario, SODENMON.FechaSis, SODENMON.SucOrigen, SODENMON.SucDestino
			from SODENMON noholdlock
			where	Dem_Moneda	= @Dem_Moneda
			order by Dem_Moneda, Dem_Denomi desc
end else/* Adaptive Server has expanded all '*' elements in the following statement */ 
	select	SODENMON.Dem_Moneda, SODENMON.Dem_Denomi, SODENMON.Dem_Descri, SODENMON.NumTransac, SODENMON.Transaccio, SODENMON.Usuario, SODENMON.FechaSis, SODENMON.SucOrigen, SODENMON.SucDestino
		from SODENMON noholdlock
		where	Dem_Moneda	= @Dem_Moneda 
	 	  and	Dem_Denomi	= @Dem_Denomi
		order by Dem_Moneda, Dem_Denomi desc
