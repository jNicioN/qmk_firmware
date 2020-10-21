--drop procedure SOBICOCUREP
create procedure SOBICOCUREP (
	@Fec_MenEje	smalldatetime,			-- Fecha menor de ejecucion
    @NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Reporte de Bitacora de Ejecucion de Configuraciones de Cuentas		****
**                  y Clientes nuevas o que cambian de Tipo de Cuenta.					****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		19/10/2020									        					****
** Help:		1286068						        									****
** Descripcion:	Generacion del Procedimiento											****
********************************************************************************************/
		
--Variables

--Constantes
--declare	@Ent_Cero   tinyint		-- Cantidad: Cero 

-- Asignacion de Constantes
--select  @Ent_Cero   = 0			-- Cantidad: Cero
		

select	Bcc_Numero,	Bcc_FecPro,	Bcc_CanCue,	Bcc_CanCli,	Bcc_CaReCu,
		Bcc_CaReCl,	Bcc_GenExi,	Bcc_TraExi,	Bcc_MenGen,	Bcc_MenTra
	from SOBICOCU noholdlock
	where Bcc_FecPro	>= @Fec_MenEje
	order by Bcc_FecPro

