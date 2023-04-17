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
** Modifico:	Joseph Santos							        ****
** Fecha:		18/04/2023										****
** ID Jira:		TCELID-13889									****
** Descripcion:	Se modifica select final en C1 para que no devu ****
**              elva campos nulos								****
********************************************************************
** Modifico:	Joseph Santos							        ****
** Fecha:		11/04/2023										****
** ID Jira:		TCELID-13889									****
** Descripcion:	Se modifica consulta C1 para comparar con 		****
**				bitacora CLBIDAHI el telefono y correo			****
********************************************************************
** Creo:		Melissa Reyna							        ****
** Fecha:		03/Oct/2022										****
** Help:		1379522											****
** Descripcion:	Consulta datos de contacto del cliente persona	****
*******************************************************************/

/* Declaracion de Variables */
declare	@Tip_ConTip	char(1), /* Consulta Tipo C/L*/
		@Tip_ConCon	char(1),
		@Fec_ModAnt date,
		@Fec_Mod date,
		@Dias_Act	int,
		@Str_Cel	varchar(20),
		@Str_Email	varchar(50),
		@Mod_Cel	int,
		@Mod_Email	int,
		@Per_Verifi	bit

/* Declaracion de Constantes */
declare	@Str_Vacio	 char(1), /* Vacio */
		@Str_C		 char(1), /* Tipo C */
		@Str_Uno	 char(1), /* Tipo 1 */
		@Cli_ClaBR	 smallint,
		@Bit_PeVeSi  BIT,
		@Bit_PeVeNo  BIT,
		@Str_Null	 varchar(1),
		@Str_Espacio varchar(1)

/* Asignacion de Constantes */
select	@Str_Vacio	= '',
		@Str_C		= 'C',
		@Str_Uno	= '1',
		@Cli_ClaBR	= 2,
		@Bit_PeVeSi = 1,
		@Bit_PeVeNo = 0,
		@Str_Null 	= null,
		@Str_Espacio = ' '

/* Asignacion de Variables */
select	@Tip_ConTip	= substring(@Tip_Consul,1 , 1),
		@Tip_ConCon	= substring(@Tip_Consul, 2, 1),
		@Fec_ModAnt = dateadd(dd, -@NumDiaAct, current_date()),
		@Dias_Act 	= @NumDiaAct + 1,
		@Per_Verifi = @Bit_PeVeSi

if @Tip_ConTip = @Str_C begin
	if @Tip_ConCon	= @Str_Uno begin

		create table #ActReciente(
			Act_TelCel 	varchar(20),
			Act_Email 	varchar(50),
			Act_dias 	int
		)
		/*Me traigo registros de la bitacora que estén dentro de los 90 días*/
		insert into #ActReciente
		select
			str_replace(a.Cli_TelCel, @Str_Espacio,@Str_Null),
			lower(a.Cli_Email),
			datediff(day,  a.FechaSis, getdate())
		from CLBIDAHI a noholdlock
		inner join CLADICIO b noholdlock
		on Cli_Numero = Adi_Client
		inner join CLCLACLI c noholdlock
		on b.ClClientID = c.Clc_Client
		where Adi_NumPer = @Per_Numero
		and c.Clc_Clasif = @Cli_ClaBR
		and (isnull(a.Cli_TelCel, @Str_Vacio) != @Str_Vacio)
		and (isnull(a.Cli_Email, @Str_Vacio) != @Str_Vacio)

		/*Tomo el telefono y correo de CLADICIO (Deberían ser los actuales)*/
		select top 1
			@Str_Cel = str_replace(Adi_TelCel, @Str_Espacio,@Str_Null),
			@Str_Email = lower(Adi_Email),
			@Fec_Mod = Adi_FeMoCl
		from  CLADICIO noholdlock
		inner join CLCLACLI noholdlock on ClClientID = Clc_Client
		where Adi_NumPer = @Per_Numero
		and Clc_Clasif = @Cli_ClaBR
		order by Adi_FeMoCl desc

		/*Busco si tiene un telefono diferente en la bitacora dentro de los 90 días*/
		select @Mod_Cel = count(1)
		from #ActReciente
		where Act_TelCel != @Str_Cel

		/*Busco si tiene un correo diferente en la bitacora dentro de los 90 días*/
		select @Mod_Email = count(1)
		from #ActReciente
		where Act_Email != @Str_Email

		/*Si cualquiera de los dos da un count mayor a 0, no permite la verificación o si los campos de CLADICIO están nulos, tampoco*/
		if ((@Mod_Cel > 0 or @Mod_Email > 0) and @Fec_Mod >= @Fec_ModAnt )
			or (isnull(@Str_Cel,@Str_Vacio) = @Str_Vacio or isnull(@Str_Email,@Str_Vacio) = @Str_Vacio) begin
			select @Per_Verifi = @Bit_PeVeNo
		end

		select
			isnull(@Str_Cel, @Str_Vacio) Adi_TelCel,
			isnull(@Str_Email, @Str_Vacio) Adi_Email,
			@Per_Verifi PermiteVer

		drop table #ActReciente
	end
end
