create procedure SOBIPRFLALT (
	@Bpf_EjeFlu	int,
	@Bpf_ProFlu	int,
	@Bpf_Elemen varchar(20), 
	@Bpf_FecHor	smalldatetime,
	@Bpf_EjeExi	bit,
	@Bpf_Mensaj	varchar(200),
	@Bpf_IdeExt varchar(20), 
	@NumTransac	char(10),	
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/*******************************************************************************************
** Descripcion:    	Alta de Bitacora de Procesos de Flujos								****
********************************************************************************************
** Referencias:																	  		****
********************************************************************************************
** Elaboro: 	Joel Gonzalez	                     									****
** Fecha:		21/07/2020									        					****
** Help:		1394242						        									****
** Descripcion:	Alta de Bitacora de Procesos de Flujos									****
********************************************************************************************/
		
--Variables
declare	@Res_EjePro	int

--Constantes
declare	@Can_Cero  tinyint,		-- Cantidad: Cero
		@Can_Uno   tinyint		-- Cantidad: Uno

select  @Can_Cero  = 0,			-- Cantidad: Cero
		@Can_Uno   = 1			-- Cantidad: Uno

--
select	@Res_EjePro	= @Can_Uno

insert into SOBIPRFL	(	Bpf_EjeFlu,	Bpf_ProFlu,	Bpf_Elemen, Bpf_FecHor,	Bpf_EjeExi,
							Bpf_Mensaj, Bpf_IdeExt,	NumTransac, Transaccio, Usuario,	
							FechaSis, 	SucOrigen,	SucDestino)
values(						@Bpf_EjeFlu,@Bpf_ProFlu,@Bpf_Elemen,@Bpf_FecHor,@Bpf_EjeExi,
							@Bpf_Mensaj,@Bpf_IdeExt,@NumTransac,@Transaccio,@Usuario,	
							@FechaSis, 	@SucOrigen,	@SucDestino)
-- En caso de error informar Codigo de Error
select	@Res_EjePro	= @@error
if @Res_EjePro	<> @Can_Cero begin
	return	@Res_EjePro
end


