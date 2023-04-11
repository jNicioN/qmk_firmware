create procedure SOPECLDCCON (
	@Per_Numero	char(8),
	@NumDiaAct int,
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
** DESCRIPCION: Consulta datos de contacto del cliente			****
**				ligado a la persona								****
********************************************************************
** Creo:		Melissa Reyna							        ****
** Fecha:		03/Oct/2022										****
** Help:		1379522											****
** Descripcion:	Consulta datos de contacto del cliente persona	****
*******************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1), /* Consulta Tipo C/L*/
		@Tip_ConCon	char(1),
		@Fec_ModAnt date

/* Declaracion de Constantes */
declare	@Str_Vacio	char(1), /* Vacio */
		@Str_C		char(1), /* Tipo C */
		@Str_Uno	char(1), /* Tipo 1 */
		@Cli_ClaBR	smallint,
		@Bit_PeVeSi BIT,
		@Bit_PeVeNo BIT

/* Asignacion de Constantes */
select	@Str_Vacio	= '',
		@Str_C		= 'C',
		@Str_Uno	= '1',
		@Cli_ClaBR	= 2,
		@Bit_PeVeSi 	= 1,
		@Bit_PeVeNo 	= 0

/* Asignacion de Variables */
select	@Tip_ConTip	= substring(@Tip_Consul,1 , 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1),
		@Fec_ModAnt = dateadd(dd, -@NumDiaAct, current_date())

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin

		select top 1 Adi_TelCel, Adi_Email,(CASE
		    WHEN  Adi_FeMoCl <= @Fec_ModAnt AND (Adi_TelCel !=@Str_Vacio OR Adi_Email !=@Str_Vacio) THEN @Bit_PeVeSi
		   	ELSE @Bit_PeVeNo
		    END) as PermiteVer
			from  CLADICIO noholdlock
			inner join CLCLACLI noholdlock on ClClientID = Clc_Client
			where Adi_NumPer = @Per_Numero
				and Clc_Clasif = @Cli_ClaBR
			order by Adi_FeMoCl desc

	end
end
