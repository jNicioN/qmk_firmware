create procedure SOVAHOSEPRO (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*****************Proceso que Valida Horario de Seguridad************************/

/*
****************************************************************************
** Creó:			Manuel Martínez Muñoz 						****
** Fecha:		16/Mayo/2012								****
** Help:		      462064										****
****************************************************************************
*/

/* Declaracion de Variables */
declare	@Dat_hms	int,
		@Hms_HoAcIn	int, 
		@Hms_HoAcFi int
	
/* Declaracion de Constantes */
declare	@Ent_Cero	int

/* Asignación de Constantes */
select	@Ent_Cero = 0	/* Entero Cero */

select	@Hms_HoAcIn	= Pas_HoInAC,
		@Hms_HoAcFi	= Pas_HoFiAC
	from SOPARSEG noholdlock

select @Dat_hms = convert(int,str_replace(convert(varchar,getdate(),108),':',null))

if @Hms_HoAcFi >= @Hms_HoAcIn begin
	if @Dat_hms >= @Hms_HoAcIn and  @Dat_hms <= @Hms_HoAcFi begin
		select	Pas_HoInAC,	Pas_HoFiAC
			from SOPARSEG noholdlock
	end else begin
	    select	Pas_HoInAC	= @Ent_Cero
	end
end else if @Hms_HoAcFi < @Hms_HoAcIn and (@Dat_hms <= @Hms_HoAcFi) begin
	if @Dat_hms <= @Hms_HoAcIn and  @Dat_hms <= @Hms_HoAcFi begin
		select	Pas_HoInAC,	Pas_HoFiAC
		from SOPARSEG noholdlock
	end else begin
    	select	Pas_HoInAC	= @Ent_Cero
	end
end else begin
	if @Dat_hms >= @Hms_HoAcIn and  @Dat_hms >= @Hms_HoAcFi begin
		select	Pas_HoInAC,	Pas_HoFiAC
		from SOPARSEG noholdlock
	end else begin
    	select	Pas_HoInAC	= @Ent_Cero
	end
end
