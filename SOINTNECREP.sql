create procedure SOINTNECREP (
	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))
as
/**********************************************************************/
/* DESCRIPCION: Informacion Integracion NEC							  */
/**********************************************************************/
/* REFERENCIAS: 													  */
/***********************************************************************
** Creo:		Claudia V Sandoval P								****
** Fecha:		08/01/2013											****
** Help:		000384210											****
************************************************************************/
declare @COPERSON bigint,
		@COCLIENT bigint,
		@COADICIO bigint,
		@COCLIUNI bigint,
		@COCONTRA bigint,
		@COENTIDA bigint,
		@COLOCALI bigint,
		@COTIPSOC bigint,
		@COSUCURS bigint,
		@COUSUARI bigint

select	@COADICIO	= count(1)
	from CLADICIO noholdlock

select	@COCLIENT	= count(1)
	from CLCLIENT noholdlock

select	@COCLIUNI	= count(1)
	from CLCLIUNI noholdlock

select	@COCONTRA	= count(1)
	from CLCONTRA noholdlock

select	@COENTIDA	= count(1)
	from CLENTIDA noholdlock

select	@COLOCALI	= count(1)
	from CLLOCALI noholdlock

select	@COTIPSOC	= count(1)
	from CLTIPSOC noholdlock

select	@COPERSON	= count(1)
	from SOPERSON noholdlock

select	@COSUCURS	= count(1)
	from SOSUCURS noholdlock

select	@COUSUARI	= count(1)
	from SOUSUARI noholdlock

select	COADICIO	= @COADICIO, 
		COCLIENT	= @COCLIENT, 
		COCLIUNI	= @COCLIUNI, 
		COCONTRA	= @COCONTRA, 
		COENTIDA	= @COENTIDA, 
		COLOCALI	= @COLOCALI, 
		COTIPSOC	= @COTIPSOC, 
		COPERSON	= @COPERSON, 
		COSUCURS	= @COSUCURS,
		COUSUARI	= @COUSUARI
