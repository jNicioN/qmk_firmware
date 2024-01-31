create procedure SONOMLARCON (
	@Per_Numero varchar(8),
    @Nol_Person int,   
    @Nol_Nombre varchar(84),
    @Nol_ApePat varchar(84),
    @Nol_ApeMat varchar(84),
    @Nol_RazSoc varchar(254),
    @Nol_Comple varchar(254),
    @Nol_ComOrd varchar(254),
    @Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Consulta de personas con nombre largo 		****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		10/01/2024										****
** Help: 		36841 											****
** Descripcion:	Se crea SP				 						****
*******************************************************************/

--declaracion de variables
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1),
		@PerPersoID	int

--Declaracion de Constantes
declare @Str_Vacio	char(1),
		@Str_Uno	char(1),
		@Str_LetraC	char(1)

--Asignacion de constantes
select 	@Str_Uno	= '1',			-- String 1
		@Str_LetraC	= 'C'			-- Letra C

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_LetraC begin		--CONSULTA

	if @Tip_ConCon	= @Str_Uno begin	--C1 : por numero de Persona

		select @PerPersoID = PerPersoID
			from SOPERSON noholdlock
			where Per_Numero = @Per_Numero

		select 	Nol_Consec,	Nol_Person,	Nol_Nombre,	Nol_ApePat,	Nol_ApeMat,
			    Nol_RazSoc,	Nol_Comple,	Nol_ComOrd,	NumTransac,	Transaccio 
			    Usuario,  	FechaSis,   SucOrigen, 	SucDestino
			from SONOMLAR 
			where Nol_Person = @PerPersoID
			order by Nol_Consec desc

	end
end

