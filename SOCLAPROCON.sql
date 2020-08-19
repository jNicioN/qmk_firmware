create procedure SOCLAPROCON (
	@Clp_Numero int,
	@Clp_Clasif int,
	@Clp_Produc int,
	@Clp_CuePro char(2),
	@Clp_TarPro char(4),
	@Clp_CrePro char(2),
	@Tip_Consul	char(2),

	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))

as

/***************************************************************************/
/* DESCRIPCION:   Consulta de clasificacion de producto  	   	       */
/** REFERENCIAS:
*****************************************************************************
** Creo:	Oscar Daniel Trevino Quintanilla							****
** Fecha:	07/08/2020													****
** Help:	01415639													****
****************************************************************************/

/*	Declaracion de Variables	*/
declare	@Tip_ConTip	char(1),
	@Tip_ConCon	char(1)

/*	Declaracion de Constantes	*/
declare	@Ent_Uno	int,
	@Str_Uno	char(1),
	@Str_Dos	char(1),
	@Str_Tres	char(1),
	@Str_TipCon	char(1),
	@Str_TipLis	char(1)

/* Asignacion de Constantes */
select	@Ent_Uno	= 1,			/* Entero Uno*/
	@Str_Uno	= '1',			/* Caracter Uno*/
	@Str_Dos	= '2',			/* Caracter Dos*/
	@Str_Tres	= '3',			/* Caracter Tres*/
	@Str_TipCon	= 'C',			/* Tipo consulta*/
	@Str_TipLis	= 'L'			/* Tipo lista	*/

select	@Tip_ConTip	= substring(@Tip_Consul, 1, 1),
			@Tip_ConCon	= substring(@Tip_Consul, 2, 1)

select @Tip_ConTip,@Tip_ConCon

if @Tip_ConTip = @Str_TipLis begin			/* Listas */
	if @Tip_ConCon = @Str_Uno begin				/* Consulta por producto global*/

		select Clp_Numero, Clp_Clasif, Clp_Produc
		from SOCLAPRO noholdlock
		where Clp_Produc = @Clp_Produc

	end else if @Tip_ConCon = @Str_Dos begin

		select Clp_Numero, Clp_Clasif, Clp_Produc, Ptc_TipCue			/* Consulta por producto de cheques*/
		from SOCLAPRO noholdlock,
				SOPRTICU noholdlock
		where Ptc_TipCue = convert(int,@Clp_CuePro)
		    and Clp_Produc =  Ptc_Produc 

	end if @Tip_ConCon = @Str_Tres begin			/* Consulta por producto de tarjeta*/

		select distinct Clp_Numero, Clp_Clasif, Clp_Produc, Ptt_TipTar
		from SOCLAPRO noholdlock,
				 SOPRTITA noholdlock
		where Ptt_TipTar = @Clp_TarPro
		    and Clp_Produc =   Ptt_Produc  

	end
end 
