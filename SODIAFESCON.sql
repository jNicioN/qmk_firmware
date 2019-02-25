create procedure SODIAFESCON (
	@Dfe_Fecha	smalldatetime,
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
** DESCRIPCION: Consulta de fechas en SODIAFES		 					****
****************************************************************************
** REFERENCIAS:															****
****************************************************************************
** Modifico:		Arely Dominguez										****
** Fecha:			14/Febrero/2019										****
** Descripcion: 	Se crea consulta para verificar si el dia actual    ****
**					es festivo											****
** Requisicion:		1202372												****
****************************************************************************
** Modifico:		Guillmar Illescas López								****
** Fecha:			22/Noviembre/2016									****
** Descripcion: 	Se crea para realizar consultas por fechas SODIAFES	****
** Requisicion:		926348												****
****************************************************************************
** Modificó:		Mayra Estrada										****
** Fecha:			21/Julio/1999										****
** Descripción:		@Tip_Consul p/ Cons. Tipificadas de Visual.			****
****************************************************************************/


/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)
		
/* Declaracion de Constantes*/
declare	@Str_Vacio char(1),
		@Str_C char (1),
		@Date_Fecha_Vacia smalldatetime, 
		@Int_Uno int,
		@Int_Dos int,
		@Str_Uno char(1),
		@Str_Dos char(1)

/* Asignacion de constantes	*/
select	@Str_Vacio	= '',					/*String Vacio*/
		@Str_C = 'C',						/*String C */
		@Date_Fecha_Vacia = '01/01/1900',	/*Para velidar que la fecha es vacia o es igual a 01/01/1900*/
		@Int_Uno = 1,						/*Entero uno*/
		@Int_Dos = 2,						/*Entero dos*/
		@Str_Uno = '1',						/*String uno*/
		@Str_Dos = '2'						/*String dos*/
		
		
if @Tip_Consul = @Str_Vacio begin	/* Cliente:  FoxPro */
	if (@Dfe_Fecha <= convert(smalldatetime, @Date_Fecha_Vacia))
		select	Dfe_Fecha,	Dfe_Coment
			from SODIAFES noholdlock
			order by Dfe_Fecha
	else
		select	Dfe_Fecha,	Dfe_Coment
			from SODIAFES noholdlock
			where	Dfe_Fecha	= @Dfe_Fecha
end else begin			/* Cliente:  Visual Basic */
	select	@Tip_ConTip	= substring(@Tip_Consul, @Int_Uno, @Int_Uno),
			@Tip_ConCon	= substring(@Tip_Consul, @Int_Dos, @Int_Uno)
	
	if @Tip_ConTip = @Str_C begin		/* 'C':  Consulta */
		if @Tip_ConCon = @Str_Uno begin				/* Consulta General */
			select	Dfe_Fecha,	Dfe_Coment
				from SODIAFES noholdlock
				where	Dfe_Fecha	= @Dfe_Fecha
		end
		if @Tip_ConCon = @Str_Dos begin		/*Consulta dia Actual*/
			select	Dfe_Fecha,	Dfe_Coment
				from SODIAFES noholdlock
				where	Dfe_Fecha	= convert(char(10), getdate(), 112)
		end
	end else begin					/* 'L':  Lista */
		if @Tip_ConCon = @Str_Uno begin			/* Lista General */
			select	Dfe_Fecha,	Dfe_Coment
				from SODIAFES noholdlock
				order by Dfe_Fecha
		end	
		if @Tip_ConCon = @Str_Dos begin				/* Rango */
			select	Dfe_Fecha,	Dfe_Coment
				from SODIAFES noholdlock
				where Dfe_Fecha >= @Dfe_Fecha
				order by Dfe_Fecha		
		end 
	end
end