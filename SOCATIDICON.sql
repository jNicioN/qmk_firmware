create procedure SOCATIDICON (
	@Ctd_Numero	integer,
	@Ctd_Nombre	char(50),
	@Ctd_Descri	varchar(255),
	@Ctd_Activo	char(1),
	@Ctd_Principal char(1),
	@Tip_Consul	char(2),
		
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/***************************************************************************
** Descripción:	** Consulta de Catalogo Tipo Direccion **					****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		21-03-2017												****
** Help:		00909908												****
****************************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),	
		@Tip_ConCon	char(1)
		
/* Declaracion de Constantes */
declare @Str_Vacio	char(1),
		@Str_TipPal	char(1),
		@Str_TipAdi	char(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',		/*	String Vacio	*/
		@Str_TipPal = '1',		/* Tipo Principal	*/
		@Str_TipAdi = '0'		/* Tipo Alterno		*/

if @Tip_Consul != @Str_Vacio begin	
	select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)
	
	if @Tip_ConTip = 'C' begin		
		if @Tip_ConCon = '1' begin	 
			select Ctd_Numero, Ctd_Nombre, Ctd_Descri, Ctd_Activo, Ctd_Principal
			from SOCATIDI	noholdlock
			where   Ctd_Numero   = @Ctd_Numero
		end
		if @Tip_ConCon = '2' begin	 -- Get Direccion Principal
			select Ctd_Numero, Ctd_Nombre, Ctd_Descri, Ctd_Activo, Ctd_Principal
			from SOCATIDI	noholdlock
			where   Ctd_Principal = @Str_TipPal
		end
	end 
	if	@Tip_ConTip = 'L' begin
		if @Tip_ConCon = '1' begin
			select Ctd_Numero, Ctd_Nombre, Ctd_Descri, Ctd_Activo, Ctd_Principal
			from SOCATIDI	noholdlock
		end
		if @Tip_ConCon = '2' begin	-- Gets Direcciones Adicionales
			select Ctd_Numero, Ctd_Nombre, Ctd_Descri, Ctd_Activo, Ctd_Principal
			from SOCATIDI	noholdlock
			where Ctd_Principal = @Str_TipAdi
		end
	end	
end
