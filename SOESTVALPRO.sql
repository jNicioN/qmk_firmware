create procedure SOESTVALPRO (
	@EVa_Estado varchar(2),
	@EVa_Result bit output,
	
    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************
** DESCRIPCION: Valida si el estado esta en la lista de estados, 			****
**				de acuerdo a la RENAPO.										****
********************************************************************************
** REFERENCIAS:
********************************************************************************
** Creó:   		Francisco Euan, Josue Palomar, Jesus Garza					****
** Fecha:		10/02/2025													****
** Help:		TCELNC-23008												****
********************************************************************************/
begin

	/* Declaración de variables */

	/* Declaración de constantes */
  	declare	@Ent_Cero int,
			@Ent_Uno int

  	create table #Tab_Estado (Cam_Estado varchar(2))
  	
	/* Asignación de valores a constantes */	
	select  @Ent_Cero 	= 0,    -- Valor Entero Cero
			@Ent_Uno 	= 1     -- Valor Entero Uno

	-- insertamos los estados válidos
	insert into #Tab_Estado(Cam_Estado) values ('AS') -- Aguascalientes
	insert into #Tab_Estado(Cam_Estado) values ('BC') -- Baja California
  	insert into #Tab_Estado(Cam_Estado) values ('BS') -- Baja California Sur
  	insert into #Tab_Estado(Cam_Estado) values ('CC') -- Campeche
  	insert into #Tab_Estado(Cam_Estado) values ('CS') -- Chiapas
  	insert into #Tab_Estado(Cam_Estado) values ('CH') -- Chihuahua
  	insert into #Tab_Estado(Cam_Estado) values ('CL') -- Coahuila
  	insert into #Tab_Estado(Cam_Estado) values ('CM') -- Colima
  	insert into #Tab_Estado(Cam_Estado) values ('DF') -- Ciudad de México
  	insert into #Tab_Estado(Cam_Estado) values ('DG') -- Durango
  	insert into #Tab_Estado(Cam_Estado) values ('GT') -- Guanajuato
  	insert into #Tab_Estado(Cam_Estado) values ('GR') -- Guerrero
  	insert into #Tab_Estado(Cam_Estado) values ('HG') -- Hidalgo
  	insert into #Tab_Estado(Cam_Estado) values ('JC') -- Jalisco
  	insert into #Tab_Estado(Cam_Estado) values ('MC') -- Estado de México
  	insert into #Tab_Estado(Cam_Estado) values ('MN') -- Michoacán
  	insert into #Tab_Estado(Cam_Estado) values ('MS') -- Morelos
  	insert into #Tab_Estado(Cam_Estado) values ('NT') -- Nayarit
  	insert into #Tab_Estado(Cam_Estado) values ('NL') -- Nuevo León
  	insert into #Tab_Estado(Cam_Estado) values ('OC') -- Oaxaca
  	insert into #Tab_Estado(Cam_Estado) values ('PL') -- Puebla
  	insert into #Tab_Estado(Cam_Estado) values ('QT') -- Querétaro
  	insert into #Tab_Estado(Cam_Estado) values ('QR') -- Quintana Roo
  	insert into #Tab_Estado(Cam_Estado) values ('SP') -- San Luis Potosí
  	insert into #Tab_Estado(Cam_Estado) values ('SL') -- Sinaloa
  	insert into #Tab_Estado(Cam_Estado) values ('SR') -- Sonora
  	insert into #Tab_Estado(Cam_Estado) values ('TC') -- Tabasco
  	insert into #Tab_Estado(Cam_Estado) values ('TS') -- Tamaulipas
  	insert into #Tab_Estado(Cam_Estado) values ('TL') -- Tlaxcala
  	insert into #Tab_Estado(Cam_Estado) values ('VZ') -- Veracruz
  	insert into #Tab_Estado(Cam_Estado) values ('YN') -- Yucatán
  	insert into #Tab_Estado(Cam_Estado) values ('ZS') -- Zacatecas
  	insert into #Tab_Estado(Cam_Estado) values ('NE') -- Nacido en el Extranjero
  	
    -- Verificar si el estado existe en la tabla
	if exists (select @Ent_Uno from #Tab_Estado where Cam_Estado = @EVa_Estado)
		set @EVa_Result = @Ent_Uno -- Estado válido
	else
		set @EVa_Result = @Ent_Cero -- Estado no válido
		
	drop table #Tab_Estado
end