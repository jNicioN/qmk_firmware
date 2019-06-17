create procedure SOPROMATBAJ (
	@ProcId	varchar(11),
	@NumTransac char(10),
	@Transaccio char(3),
	@Usuario char(6),
	@FechaSis smalldatetime,
	@SucOrigen char(3),
	@SucDestino char(3),
	@Modulo char(2))
 
as	
/******************************************************
** Creó:			Héctor Silva López			 	***
** Fecha:			02/03/2015						***
** Help:		739123							***
** Descripción:	Cambio de tabla a SOTMPMAT	***
********************************************************/
/******************************************************
** Creó:			Héctor Silva López			 	***
** Fecha:			22/12/2014						***
** Help:			721650							***
** Descripción:	Borrar registros de tabla SOPROMAT	***
********************************************************/

delete SOTMPMAT
	where Mat_NomRep = @ProcId
