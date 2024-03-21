create procedure SOBINOLAALT (
    @Bnl_Person int,       
    @Bnl_Nombre varchar(84),
    @Bnl_ApePat varchar(84),
    @Bnl_ApeMat varchar(84),
    @Bnl_RazSoc varchar(254),
    @Bnl_Comple varchar(254),
    @Bnl_ComOrd varchar(254),

	@NumTransac	char(10),
	@Transaccio	char(3),
	@Usuario	char(6),
	@FechaSis	smalldatetime,
	@SucOrigen	char(3),
	@SucDestino	char(3),
	@Modulo		char(2))

as

/*******************************************************************
** DESCRIPCION:  ** Alta de Bitacora de Personas con nombre largo **
********************************************************************
** REFERENCIAS:													****
********************************************************************
** Modificó:	Carlos Copto									****
** Fecha:		10/01/2024										****
** Help: 		36841 											****
** Descripcion:	Se crea SP				 						****
*******************************************************************/

--declaracion de variables

--Declaracion de Constantes

--Asignacion de constantes

insert into SOBINOLA (
    Bnl_Person,    Bnl_Nombre,    Bnl_ApePat,    Bnl_ApeMat,    Bnl_RazSoc,
    Bnl_Comple,    Bnl_ComOrd,    NumTransac,    Transaccio,    Usuario,           
    FechaSis,      SucOrigen,     SucDestino
) values (
	@Bnl_Person,	@Bnl_Nombre,	@Bnl_ApePat,	@Bnl_ApeMat,	@Bnl_RazSoc,
    @Bnl_Comple,	@Bnl_ComOrd,	@NumTransac,	@Transaccio,	@Usuario,			
    @FechaSis,		@SucOrigen,		@SucDestino
)
