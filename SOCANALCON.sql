create procedure SOCANALCON (
	@Can_Numero int,
	@Can_Nombre char(50),
	@Tip_Consul char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
)
as
/* **********************************************************************/
/* DESCRIPCION: Consulta de Canales                                     */ 
/* **********************************************************************
** Creo:		Julio Cesar Diaz Lopez	                 	    		*
** Fecha:		27/Julio/2022			  	 							*
** Descripcion:	Consulta de Canales                                     *
** Help			1609249         										*/
/************************************************************************/

						/*Declaracion de variables*/
declare @Tip_ConTip	char(1),
        @Tip_ConCon char(1)
						
						/*Declaracion de Constantes*/
declare	@Ent_Uno	int,
		@Ent_Dos	int,
		@Str_C		char(1),
		@Str_L		char(1),
		@Str_Uno	char(1),
		@Str_Porcen	char(1),
		@Str_Vacio  char(1)
						
						/*Asignacion de Constantes*/												
select  @Ent_Uno	= 1,	/* Entero Uno*/
		@Ent_Dos	= 2,	/* Entero Dos*/
		@Str_C		= 'C',	/* Consulta especifica*/
		@Str_L		= 'L',	/* Consulta en lista*/
		@Str_Uno	= '1',	/* String 1*/
		@Str_Porcen	= '%',	/* Cadena Porcentaje*/
		@Str_Vacio  = ''    /*  String Vacio*/
		
select	@Tip_ConTip	= substring(@Tip_Consul, @Ent_Uno, @Ent_Uno),
		@Tip_ConCon	= substring(@Tip_Consul, @Ent_Dos, @Ent_Uno)

if @Tip_ConTip = @Str_C begin						/*Consulta*/
	if @Tip_ConCon = @Str_Uno begin
					/*Consulta General por numero*/
		 select Can_Numero, Can_Nombre, Can_Abrevi, Can_Origen, Can_Tipo
				from SOCANAL noholdlock
				where Can_Numero = @Can_Numero
	end
	
end else if @Tip_ConTip = @Str_L begin				/*Consulta por Lista*/
	if @Tip_ConCon = @Str_Uno begin					/*Consulta General (sin filtros)*/
		if isnull(@Can_Nombre,@Str_Vacio) = @Str_Vacio begin
			select Can_Numero, Can_Nombre, Can_Abrevi, Can_Origen, Can_Tipo
				from SOCANAL noholdlock
		end else begin
			select Can_Numero, Can_Nombre, Can_Abrevi, Can_Origen, Can_Tipo
				from SOCANAL noholdlock
				where upper(Can_Nombre) like @Str_Porcen + upper(ltrim(rtrim(@Can_Nombre))) + @Str_Porcen
		end
	end
end