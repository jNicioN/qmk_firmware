create procedure SODIHAFECON (
	@FechaIni	smalldatetime,
	@FechaFin	smalldatetime,
	
	@NumDias	int output)
	
as

declare	@Ent_Cero 	smallint,					 /* Declaración de Constantes */
		@Niv_Anida1	smallint

select	@Ent_Cero	= 0,					/* Entero en Cero */
		@Niv_Anida1	= 1						/* Nivel de anidamiento 1	*/

select	@NumDias = @Ent_Cero

exec SOSIGFECHAB
	@Fecha		= @FechaIni output,
	@NumDia		= 0,
	@FinSem 	= 'N',
	@Salida_Fox	= 'N'

exec SOANTFECHAB
	@Fecha		= @FechaFin output,
	@NumDia		= 0,
	@FinSem 	= 'N',
	@Salida_Fox	= 'N'


while @FechaIni < @FechaFin begin

	select	@NumDias	= @NumDias + 1
	
	exec SOSIGFECHAB
		@Fecha		= @FechaIni output,
		@NumDia		= 1,
		@FinSem 	= 'N',
		@Salida_Fox	= 'N'
	
end

if @@nestlevel = @Niv_Anida1
	select	NumDias	= @NumDias

