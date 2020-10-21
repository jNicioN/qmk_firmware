--drop procedure SOBICOCUALT
create procedure SOBICOCUALT (
	@Bcc_FecPro	smalldatetime,
	@Bcc_CanCue	int,
	@Bcc_CanCli	int,
	@Bcc_CaReCu	int,
	@Bcc_CaReCl	int,
	@Bcc_GenExi	bit,
	@Bcc_TraExi	bit,
	@Bcc_MenGen	varchar(100),
	@Bcc_MenTra	varchar(100),
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Informacion de Bitacora de Configuraciones de Cuentas y 	****
**                  Clientes nuevos o que cambiaron de Tipo de Cuenta.					****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		19/10/2020									        					****
** Help:		1286068									        						****
** Descripcion:	Generacion del Procedimiento											****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int		-- Resultado de Ejecucion de instrucciones

--Constantes
declare	@Ent_Cero  tinyint	-- Valor Entero: Cero

--Valores de Constantes
select  @Ent_Cero   = 0		-- Valor Entero: Cero

select @FechaSis = getdate()

insert into SOBICOCU	(	Bcc_FecPro,	Bcc_CanCue,	Bcc_CanCli,	Bcc_CaReCu, Bcc_CaReCl,
							Bcc_GenExi,	Bcc_TraExi,	Bcc_MenGen,	Bcc_MenTra,	NumTransac, 
							Transaccio, Usuario,	FechaSis, 	SucOrigen,	SucDestino)
values(						@Bcc_FecPro,@Bcc_CanCue,@Bcc_CanCli,@Bcc_CaReCu,@Bcc_CaReCl,
							@Bcc_GenExi,@Bcc_TraExi,@Bcc_MenGen,@Bcc_MenTra,@NumTransac,
							@Transaccio,@Usuario,	@FechaSis, 	@SucOrigen,	@SucDestino)
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Ent_Cero begin
	return	@Res_EjePro
end


