create procedure SOPROAUTREP (		
	@ProcId	varchar(11))
as
/************************************************************
** Modificó:			Héctor Silva López				 ****
** Fecha:			02/03/2015							 ****
** Help:		739123									 ****
** Descripción:	Cambio de tabla a SOTMPRES				 ****
*************************************************************/
/************************************************************
** Modificó:			Héctor Silva López				 ****
** Fecha:			22/12/2014							 ****
** Help:			721650								 ****
** Descripción:	Reporte de tabla SOPRORES				 ****
*************************************************************/

select Res_Campos,	Res_Valor,	Res_Posici,	Res_Proced,	Res_Grupo	
	from SOTMPRES noholdlock
	where convert(varchar(11),Res_Proced) like @ProcId
	order by Res_Grupo asc, Res_Posici
