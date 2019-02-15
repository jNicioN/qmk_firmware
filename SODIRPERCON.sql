create procedure SODIRPERCON (
	@PerPersoID int,
	@Dip_TipDir	int,
	@ClClientID	int,	
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
** Descripción:	 Consulta de Direccion Persona							****
****************************************************************************
** Modifico:	Marcell Moreno											****
** Fecha:		14-02-2019												****
** Help:		001187875												****
****************************************************************************
** Modifico:		Norma Tijerina											****
** Fecha:		05-05-2017												****
** Help:		00946339												****
****************************************************************************
** Creó:		Roberto Saldivar										****
** Fecha:		17-03-2017												****
** Help:		00909908												****
****************************************************************************/

										/* Declaración de variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

										/* Declaración de constantes */
declare	@Str_Vacio	char(1),
		@Con_Consul	char(1),
		@Con_Listas	char(1),
		@Por_LlaPri	char(1),
		@Tip_Ppal	char(1),
		@Tip_Adicio	char(1),
		@Str_A		char(1),
		@Str_Uno    char(1),   
		@Str_Dos    char(1),
		@Str_Tres   char(1),
		@Str_Cuatro char(1),
		@Ent_Uno    int,
		@Ent_Dos    int

										/* Asignación de constantes */
select	@Str_Vacio	= '',				/* String vacío */
		@Con_Consul	= 'C',				/* Tipo: Consulta */
		@Con_Listas	= 'L',				/* Tipo: Lista */
		@Tip_Ppal	= '1',
		@Tip_Adicio	= '0',
		@Str_A		= 'A',
		@Str_Uno    = '1',              /*String del numero 1*/
		@Str_Dos    = '2',              /*String del numero 2*/
		@Str_Tres   = '3',              /*String del numero 3*/
		@Str_Cuatro = '4',              /*String del numero 4*/
		@Ent_Uno    =  1,               /*Entero del numero 1*/
		@Ent_Dos    =  2                /*Entero del numero 2*/
		
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

/* Consulta a Descripcion */
if @Tip_ConTip = @Con_Consul begin		/* Consultas */

	if @Tip_ConCon = @Str_Uno begin	/* Consulta por persona */

		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock
			where	PerPersoID	= @PerPersoID
			and		Dip_Status = @Str_A
	end
	
	if @Tip_ConCon = @Str_Dos begin	/* Consulta por cliente  */

		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock
			where	ClClientID	= @ClClientID
			and 	Dip_Status = @Str_A
	end
	
	if @Tip_ConCon = @Str_Tres begin	/* Consulta de Direccion Por Indices */

		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock
			inner join SOCATIDI noholdlock on  Ctd_Numero  = Dip_TipDir
			where 	PerPersoID		= @PerPersoID 
			and		ClClientID  	= @ClClientID 
			and		Dip_TipDir 		= @Dip_TipDir 
					 
	end
	
	if @Tip_ConCon = @Str_Cuatro begin	/* Consulta de Direccion Por Indices */

		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock
			inner join SOCATIDI noholdlock on  Ctd_Numero  = Dip_TipDir
			and		ClClientID  	= @ClClientID 
			and		Dip_TipDir 		= @Dip_TipDir 
					 
	end

end else if @Tip_ConTip = @Con_Listas begin	/* Listas */

	if @Tip_ConCon = @Str_Uno begin	/* Lista por llave principal */
		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock
			 where	Dip_Status = @Str_A
	end
	if @Tip_ConCon = @Str_Dos begin	/* Lista de direcciones adicionales por llave principal */
		select	PerPersoID,	ClClientID,	Dip_TipDir,	Dip_Calle,	Dip_NumExt,
				Dip_NumInt,	Dip_NumCP,	Dip_EntCa1,	Dip_EntCa2,	Dip_Refere,
				Dip_Status
			from SODIRPER noholdlock 
			inner join SOCATIDI noholdlock on  Ctd_Numero  = Dip_TipDir
			where   PerPersoID	= @PerPersoID 
			  and	Ctd_Principal = @Tip_Adicio		
			  and	Dip_Status = @Str_A
	end

end