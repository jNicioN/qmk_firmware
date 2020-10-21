-- drop procedure SOBICOCUACT
create procedure SOBICOCUACT (
	@Bcc_FecPro	smalldatetime,
	@Bcc_CanCue	int,
	@Bcc_CanCli	int,
	@Bcc_CaReCu	int,
	@Bcc_CaReCl	int,
	@Bcc_GenExi	bit,
	@Bcc_TraExi	bit,
	@Bcc_MenGen	varchar(100),
	@Bcc_MenTra	varchar(100),
	@Tip_Actual char(1),
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/*******************************************************************************************
** Descripcion:    	Actualizacion de Informacion de Bitacora de Configuraciones de 		****
**                  Cuentas y Clientes nuevos o que cambiaron de Tipo de Cuenta.		****
********************************************************************************************
** Creo:		Joel Gonzalez															****
** Fecha:		19/10/2020																****
** Help:		1286068									        						****
** Descripcion:	Generacion del Procedimiento											****
********************************************************************************************/
-- Declaracion de Variables
declare	@Res_EjePro	int		-- Resultado de Ejecucion de instrucciones
	
-- Declaracion de Constantes	
declare	@Ent_Cero  	tinyint,	-- Valor Entero: Cero
		@Act_Genera	char(1),	-- Actualizacion: Generacion
		@Act_Traspa	char(1)		-- Actualizacion: Traspaso

--Valores de Constantes
select  @Ent_Cero   = 0,		-- Valor Entero: Cero
		@Act_Genera	= 'G',		-- Actualizacion: Generacion
		@Act_Traspa	= 'T'		-- Actualizacion: Traspaso

select @FechaSis = getdate()

if @Tip_Actual = @Act_Genera begin						-- Actualizacion: Generacion

	update SOBICOCU
		set	Bcc_CanCue	= @Bcc_CanCue,
			Bcc_CanCli	= @Bcc_CanCli,
			Bcc_CaReCu	= @Bcc_CaReCu,
			Bcc_CaReCl	= @Bcc_CaReCl,
			Bcc_GenExi	= @Bcc_GenExi,
			Bcc_MenGen	= @Bcc_MenGen,
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where Bcc_FecPro = @Bcc_FecPro
		
end else if @Tip_Actual = @Act_Traspa begin				-- Actualizacion: Traspaso
	
	update SOBICOCU
		set	Bcc_TraExi	= @Bcc_TraExi,
			Bcc_MenTra	= @Bcc_MenTra,
			NumTransac	= @NumTransac,
			Transaccio	= @Transaccio,
			Usuario		= @Usuario,
			FechaSis	= @FechaSis,
			SucOrigen	= @SucOrigen,
			SucDestino	= @SucDestino
		where Bcc_FecPro = @Bcc_FecPro
		
end
