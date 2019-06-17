create procedure SOPERCURCON (
	@Per_Comple	varchar(181),
	@Per_CURP	varchar(18),
	@Tip_Consul	char(2),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2)
) as

/*
********************************************************************
** DESCRIPCION:  ** Consulta de Personas por nombre y curp **	****
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Creo:	Marcelo Bautista Hernandez							****
** Fecha:	21/Marzo/2019										****
** Help:	01223447											****
********************************************************************
*/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1),
		@Tip_ConCon	char(1)

/* Declaracion de Constantes */
declare	@Str_Uno	char(1),
		@Str_TipCon	char(1)

/* Asignacion de Constantes */
select	@Str_Uno	= '1',
		@Str_TipCon	= 'C'

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

if @Tip_ConTip = @Str_TipCon begin
	if @Tip_ConCon	= @Str_Uno begin
		select distinct Peu_Grupo, Per_Comple, Per_ComOrd, Per_CURP
		from SOPERSON noholdlock
		inner join SOUNIPER noholdlock on Per_Numero = Peu_Person
		where  Per_Comple =@Per_Comple and Per_CURP = @Per_CURP
	end
end